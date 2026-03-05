-- 04_subqueries_quality.sql
-- Subconsultas + checks de calidad + señales de riesgo

-- 1) Clientes sin transacciones (posible inactividad / onboarding incompleto)
SELECT
  c.customer_id,
  c.full_name,
  c.created_at
FROM customers c
WHERE c.customer_id NOT IN (
  SELECT DISTINCT a.customer_id
  FROM accounts a
  JOIN transactions t ON a.account_id = t.account_id
  WHERE t.status = 'posted'
);

-- 2) Posibles duplicados por email
SELECT
  email,
  COUNT(*) AS cnt
FROM customers
GROUP BY email
HAVING COUNT(*) > 1
ORDER BY cnt DESC;

-- 3) Importes sospechosos (outliers simples)
SELECT
  txn_id, account_id, txn_ts, txn_type, amount, merchant, category
FROM transactions
WHERE status = 'posted'
  AND ABS(amount) > 5000
ORDER BY ABS(amount) DESC;

-- 4) Ratio de pagos fallidos por mes (señal de riesgo)
SELECT
  DATE_TRUNC('month', payment_date) AS month,
  SUM(CASE WHEN status = 'failed' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS failed_rate
FROM payments
GROUP BY DATE_TRUNC('month', payment_date)
ORDER BY month;

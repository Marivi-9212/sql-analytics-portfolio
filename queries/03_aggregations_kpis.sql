-- 03_aggregations_kpis.sql
-- KPIs financieros y de actividad

-- 1) Ingresos por mes (pagos pagados)
SELECT
  DATE_TRUNC('month', payment_date) AS month,
  SUM(amount) AS revenue
FROM payments
WHERE status = 'paid'
GROUP BY DATE_TRUNC('month', payment_date)
ORDER BY month;

-- 2) ARPU mensual
SELECT
  DATE_TRUNC('month', p.payment_date) AS month,
  SUM(p.amount) / NULLIF(COUNT(DISTINCT p.customer_id), 0) AS arpu
FROM payments p
WHERE p.status = 'paid'
GROUP BY DATE_TRUNC('month', p.payment_date)
ORDER BY month;

-- 3) Gasto por categoría (últimos 30 días)
SELECT
  category,
  COUNT(*) AS txn_count,
  SUM(CASE WHEN amount < 0 THEN -amount ELSE 0 END) AS total_spend
FROM transactions
WHERE status = 'posted'
  AND txn_ts >= (CURRENT_DATE - INTERVAL '30 day')
GROUP BY category
ORDER BY total_spend DESC;

-- 4) Clientes activos por mes (al menos 1 transacción)
SELECT
  DATE_TRUNC('month', t.txn_ts) AS month,
  COUNT(DISTINCT a.customer_id) AS active_customers
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
WHERE t.status = 'posted'
GROUP BY DATE_TRUNC('month', t.txn_ts)
ORDER BY month;

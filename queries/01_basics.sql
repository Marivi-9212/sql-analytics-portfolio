-- 01_basics.sql
-- Consultas básicas: filtros, orden, campos calculados

-- 1) Clientes creados en los últimos 90 días
SELECT
  customer_id,
  full_name,
  email,
  country,
  segment,
  created_at
FROM customers
WHERE created_at >= (CURRENT_DATE - INTERVAL '90 day')
ORDER BY created_at DESC;

-- 2) Top transacciones por importe (solo contabilizadas)
SELECT
  txn_id,
  account_id,
  txn_ts,
  txn_type,
  amount,
  category,
  merchant
FROM transactions
WHERE status = 'posted'
ORDER BY ABS(amount) DESC
LIMIT 20;

-- 3) Separar ingresos vs gastos (gasto positivo para reporting)
SELECT
  txn_id,
  txn_ts,
  txn_type,
  amount,
  CASE WHEN amount < 0 THEN -amount ELSE 0 END AS expense_amount,
  CASE WHEN amount > 0 THEN  amount ELSE 0 END AS income_amount
FROM transactions
WHERE status = 'posted';

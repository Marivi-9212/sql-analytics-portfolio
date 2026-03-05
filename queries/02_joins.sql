-- 02_joins.sql
-- Joins analíticos: clientes + cuentas + transacciones

-- 1) Vista analítica de transacciones con datos de cliente
SELECT
  t.txn_id,
  t.txn_ts,
  t.txn_type,
  t.amount,
  t.category,
  a.account_type,
  a.status AS account_status,
  c.customer_id,
  c.full_name,
  c.segment,
  c.country
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
WHERE t.status = 'posted';

-- 2) Nº de cuentas activas por cliente
SELECT
  c.customer_id,
  c.full_name,
  c.segment,
  COUNT(*) AS active_accounts
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
WHERE a.status = 'active'
GROUP BY c.customer_id, c.full_name, c.segment
ORDER BY active_accounts DESC;

-- 3) Última transacción por cliente (sin window functions)
SELECT
  c.customer_id,
  c.full_name,
  MAX(t.txn_ts) AS last_txn_ts
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN transactions t ON a.account_id = t.account_id
WHERE t.status = 'posted'
GROUP BY c.customer_id, c.full_name
ORDER BY last_txn_ts DESC;

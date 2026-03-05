-- 00_schema.sql (modelo de ejemplo)
-- Dialecto: SQL estándar (puede requerir ajustes mínimos según PostgreSQL/MySQL/SQLite)

-- Clientes
CREATE TABLE customers (
  customer_id     INT PRIMARY KEY,
  full_name       VARCHAR(120),
  email           VARCHAR(150),
  country         VARCHAR(80),
  segment         VARCHAR(30),   -- 'Retail', 'SMB', 'Enterprise'
  created_at      DATE
);

-- Cuentas (un cliente puede tener varias)
CREATE TABLE accounts (
  account_id      INT PRIMARY KEY,
  customer_id     INT,
  account_type    VARCHAR(30),   -- 'checking', 'savings', 'credit'
  opened_at       DATE,
  status          VARCHAR(20),   -- 'active', 'closed'
  credit_limit    DECIMAL(12,2),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Transacciones
CREATE TABLE transactions (
  txn_id          INT PRIMARY KEY,
  account_id      INT,
  txn_ts          TIMESTAMP,
  txn_type        VARCHAR(30),   -- 'card_purchase', 'transfer', 'deposit', 'withdrawal', 'fee', 'refund'
  amount          DECIMAL(12,2), -- + ingresos / - gastos (convención)
  merchant        VARCHAR(120),
  category        VARCHAR(60),
  status          VARCHAR(20),   -- 'posted', 'reversed', 'pending'
  FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

-- Pagos (para KPIs de ingresos)
CREATE TABLE payments (
  payment_id      INT PRIMARY KEY,
  customer_id     INT,
  payment_date    DATE,
  amount          DECIMAL(12,2),
  product         VARCHAR(60),   -- 'subscription', 'loan', etc.
  status          VARCHAR(20),   -- 'paid', 'failed', 'refunded'
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

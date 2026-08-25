#!/usr/bin/env bash
set -euo pipefail

psql \
    --username "$POSTGRES_USER" \
    --dbname "$POSTGRES_DB" \
    --set=account_password="$ACCOUNT_DB_PASSWORD" \
    --set=ledger_password="$LEDGER_DB_PASSWORD" <<'EOSQL'

CREATE ROLE account_app
    LOGIN
    PASSWORD :'account_password';

CREATE ROLE ledger_app
    LOGIN
    PASSWORD :'ledger_password';

CREATE SCHEMA account AUTHORIZATION account_app;
CREATE SCHEMA ledger AUTHORIZATION ledger_app;

REVOKE CREATE ON SCHEMA public FROM PUBLIC;

REVOKE ALL ON SCHEMA ledger FROM account_app;
REVOKE ALL ON SCHEMA account FROM ledger_app;

ALTER ROLE account_app SET search_path = account;
ALTER ROLE ledger_app SET search_path = ledger;

EOSQL

use owshq
go

ALTER VIEW vw_bank_ranked
AS
SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS ranking_id,
id,
uid,
account_number,
iban,
bank_name,
routing_number,
swift_bic,
user_id,
dt_current_timestamp,
cast(dt_current_timestamp as datetime2) create_at
from owshq.dbo.bank
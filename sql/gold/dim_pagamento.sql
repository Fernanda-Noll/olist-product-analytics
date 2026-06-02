COPY (
    WITH pagamentos AS (
        SELECT DISTINCT
            CASE payment_type
                WHEN 'credit_card' THEN 'Cartão de crédito'
                WHEN 'debit_card' THEN 'Cartão de débito'
                WHEN 'boleto' THEN 'Boleto'
                WHEN 'voucher' THEN 'Voucher'
                ELSE 'Não informado'
            END AS tipo_pagamento
        FROM read_parquet('data/silver/olist_order_payments_dataset.parquet')
        WHERE payment_type IS NOT NULL
          AND TRIM(payment_type) <> ''
    )
    SELECT
        tipo_pagamento,
        CASE
            WHEN tipo_pagamento IN ('Cartão de crédito', 'Cartão de débito') THEN 'Cartão'
            WHEN tipo_pagamento = 'Boleto' THEN 'Boleto'
            WHEN tipo_pagamento = 'Voucher' THEN 'Voucher'
            ELSE 'Não informado'
        END AS categoria_pagamento
    FROM pagamentos
)
TO 'data/gold/dim_pagamento.parquet' (FORMAT PARQUET);

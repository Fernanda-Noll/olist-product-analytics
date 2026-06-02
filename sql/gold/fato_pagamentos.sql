COPY (
    SELECT
        order_id AS pedido_id,
        payment_sequential AS sequencia_pagamento,
        CASE payment_type
            WHEN 'credit_card' THEN 'Cartão de crédito'
            WHEN 'debit_card' THEN 'Cartão de débito'
            WHEN 'boleto' THEN 'Boleto'
            WHEN 'voucher' THEN 'Voucher'
            ELSE 'Não informado'
        END AS tipo_pagamento,
        payment_installments AS quantidade_parcelas,
        CASE
            WHEN payment_installments = 0 THEN '0 parcelas'
            WHEN payment_installments = 1 THEN '1 parcela'
            WHEN payment_installments <= 3 THEN '2 a 3 parcelas'
            WHEN payment_installments <= 6 THEN '4 a 6 parcelas'
            WHEN payment_installments <= 10 THEN '7 a 10 parcelas'
            WHEN payment_installments <= 12 THEN '11 a 12 parcelas'
            ELSE 'Acima de 12 parcelas'
        END AS faixa_parcelas,
        payment_value AS valor_pagamento
    FROM read_parquet('data/silver/olist_order_payments_dataset.parquet')
)
TO 'data/gold/fato_pagamentos.parquet' (FORMAT PARQUET);

select 'NIPOS'sumber,
'GROSS' keterangan,
COUNT(*)produksi,
SUM(np.connote__connote_amount)+
SUM(
        CASE 
            WHEN UPPER(customer_code) = 'DAGSHOPEE04120A'
             AND UPPER(custom_field__cod) != 'NONCOD'
            THEN COALESCE(t_webhook.good_value, 0) * 0.005
            ELSE COALESCE(np.custom_field__fee_value, 0)
        END
    ) AS pendapatan
FROM nipos.nipos__part_2026 np
LEFT JOIN (
    SELECT DISTINCT resi, good_value
    FROM nipos.webhook_marketplace
    WHERE member_id = 'DAGSHOPEE04120A'
) t_webhook
ON np.connote__connote_booking_code = t_webhook.resi
WHERE
    UPPER(connote__location_name) != 'AGP TESTING LOCATION'
    AND connote__connote_amount >= 0
    AND connote__connote_service != 'LNINCOMING'
    AND UPPER(connote__connote_state) NOT IN ('CANCEL', 'PENDING')
union all
--trx glid
select
'GLID' sumber,
'GROSS' keterangan,
    COUNT(t3.order_code) AS produksi,
        SUM(t3.total_amount )pendapatan
FROM (
    SELECT
        DATE(tgl_billing) AS connote__created_at,
        kode_nopen AS nopen,
        customer_code,
        service_code AS connote__connote_service,
        service_name,
        order_code,
        jenis_produk,
        CASE
            WHEN service_code = 'FFE' THEN 'EB'
            ELSE 'WIN'
        END AS subdit_id,
        MAX(total_amount) AS total_amount
    FROM glid.glid g
    WHERE DATE(tgl_billing) >= DATE '2026-01-01'
    GROUP BY
        DATE(tgl_billing),
        kode_nopen,
        customer_code,
        service_code,
        service_name,
        order_code,
        jenis_produk,
        CASE
            WHEN service_code = 'FFE' THEN 'EB'
            ELSE 'WIN'
        END
) t3
union
SELECT jenis_feeder sumber,'GROSS' keterangan,SUM(produksi)produksi,SUM(pendapatan)pendapatan
FROM sap.feeder_sap
where tgltr>='20260101'
group by 1

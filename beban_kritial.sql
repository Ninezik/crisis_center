select tanggal,
    COALESCE(SUM(CASE
        WHEN flow_type = 'SALDO AWAL' THEN nominal
        ELSE 0
    END), 0)
    +
    COALESCE(SUM(CASE
        WHEN flow_type = 'TOTAL PENERIMAAN' THEN nominal
        ELSE 0
    END), 0) AS proyeksi_penerimaan,
    COALESCE(SUM(CASE
        WHEN flow_type = 'TOTAL PENGELUARAN' THEN nominal
        ELSE 0
    END), 0) AS proyeksi_pengeluran,
    COALESCE(SUM(CASE
        WHEN flow_type = 'SALDO AKHIR' THEN nominal
        ELSE 0
    END), 0)nett
FROM datas.vw_monitoring_cash_sheet_monitor
WHERE tanggal > '2026-07-24'
group by 1
order by 1

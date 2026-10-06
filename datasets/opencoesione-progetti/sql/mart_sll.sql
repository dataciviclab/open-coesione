-- mart_sll.sql — finanziamenti per SLL (geografia presente su tutti i cicli)
-- Nota: COD 0 = "SLL NON ATTRIBUIBILE", 9999 = "SLL MULTIPLO" (sentinel fonte).
SELECT
  OC_COD_SLL AS cod_sll,
  OC_DENOMINAZIONE_SLL AS sll,
  CASE
    WHEN OC_COD_SLL IS NULL OR OC_COD_SLL = 0 THEN 'non_attribuibile'
    WHEN OC_COD_SLL = 9999 THEN 'multiplo'
    ELSE 'ok'
  END AS flag_sll,
  OC_MACROAREA_PROGETTO AS macroarea,
  COUNT(*) AS n_progetti,
  SUM(FINANZ_UE) AS finanz_ue_tot,
  SUM(FINANZ_TOTALE_PUBBLICO) AS finanz_tot_pub,
  SUM(OC_COSTO_COESIONE) AS costo_coesione,
  SUM(TOT_PAGAMENTI) AS pagamenti_tot,
  CASE
    WHEN SUM(OC_COSTO_COESIONE) > 0
    THEN SUM(TOT_PAGAMENTI) / SUM(OC_COSTO_COESIONE)
    ELSE NULL
  END AS ratio_pagamenti_costo
FROM clean_input
WHERE OC_COD_SLL IS NOT NULL
GROUP BY 1, 2, 3, 4
ORDER BY finanz_ue_tot DESC

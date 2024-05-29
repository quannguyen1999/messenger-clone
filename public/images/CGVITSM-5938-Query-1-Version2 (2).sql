WITH result_total_spending as(
	SELECT D.SAV_MBR_NO,
        sum(C.PAY_AMT) total_spending,
        FIR_SALE_CHNL_CD
    FROM TB_MP_SALE_PRD a,    TB_MP_SALE_PAY C, TB_MP_SALE D 
    WHERE   a.prd_sale_no = d.sale_no AND C.PAY_SALE_NO = D.SALE_NO 
        AND D.SALE_STATUS_CD = '01' 
        AND a.sale_dy >= '20230101' AND a.sale_dy <= '20240430'
        AND   D.SAV_MBR_NO IS NOT NULL 
        GROUP BY    D.SAV_MBR_NO,    FIR_SALE_CHNL_CD
),
result_adm_offline AS (
	SELECT D.SAV_MBR_NO,
        sum(C.PAY_AMT) total_credit,
        count(FIR_SALE_CHNL_CD) adm_offline
    FROM TB_MP_SALE_PRD a,    TB_MP_SALE_PAY C, TB_MP_SALE D 
    WHERE   a.prd_sale_no = d.sale_no AND C.PAY_SALE_NO = D.SALE_NO 
        AND D.SALE_STATUS_CD = '01' 
        AND C.PAY_KND_CD IN ('02','06') 
        AND (FIR_SALE_CHNL_CD NOT IN ('04','05'))
        AND a.sale_dy >= '20230101' AND a.sale_dy <= '20240430'
        AND   D.SAV_MBR_NO IS NOT NULL 
        GROUP BY    D.SAV_MBR_NO,
     FIR_SALE_CHNL_CD   
),
result_adm_online AS (
	SELECT D.SAV_MBR_NO,
        sum(C.PAY_AMT) total_credit,
        count(FIR_SALE_CHNL_CD) adm_online
    FROM TB_MP_SALE_PRD a,    TB_MP_SALE_PAY C, TB_MP_SALE D 
    WHERE   a.prd_sale_no = d.sale_no AND C.PAY_SALE_NO = D.SALE_NO 
        AND D.SALE_STATUS_CD = '01' 
        AND C.PAY_KND_CD IN ('02','06') 
        AND (FIR_SALE_CHNL_CD IN ('04','05'))
        AND a.sale_dy >= '20230101' AND a.sale_dy <= '20240430'
        AND   D.SAV_MBR_NO IS NOT NULL 
        GROUP BY    D.SAV_MBR_NO,
        FIR_SALE_CHNL_CD   
)
SELECT rts.SAV_MBR_NO MBR_NO,
		tmmi.BIRTHDAY DOB,
		rts.total_spending total_spending, 
		sum(nvl(raof.total_credit,0) + nvl(raon.total_credit, 0)) spending_by_credit_cart,
		raof.adm_offline adm_off,
		raon.adm_online adm_on
FROM result_total_spending rts LEFT JOIN result_adm_offline raof ON rts.SAV_MBR_NO = raof.SAV_MBR_NO 
LEFT JOIN result_adm_online raon ON rts.SAV_MBR_NO = raon.SAV_MBR_NO 
LEFT JOIN tb_mm_mbr_info tmmi ON rts.SAV_MBR_NO = tmmi.MBR_NO 
GROUP BY rts.SAV_MBR_NO,
	tmmi.BIRTHDAY,
		rts.total_spending,
			raof.adm_offline,
		raon.adm_online
		
		
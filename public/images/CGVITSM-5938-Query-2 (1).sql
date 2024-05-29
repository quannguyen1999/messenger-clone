   WITH result_table AS (
       SELECT 
        D.SAV_MBR_NO,
        A.sale_dy,
        D.FIR_SALE_THAT_CD
    FROM TB_MP_SALE_PRD a,    TB_MP_SALE_PAY C, TB_MP_SALE D 
    WHERE   a.prd_sale_no = d.sale_no AND C.PAY_SALE_NO = D.SALE_NO 
        AND D.SALE_STATUS_CD = '01' 
        AND a.sale_dy >= '20240101' AND a.sale_dy <= '20240430'
        AND   D.SAV_MBR_NO IS NOT NULL 
        GROUP BY    D.SAV_MBR_NO,
        A.sale_dy, D.FIR_SALE_THAT_CD 
  )
  SELECT 
  	   rt.SAV_MBR_NO MBR_NO,
       rt.sale_dy DOB,
       FN_DECRYPT(tmmi.EMAIL_UPPER) EMAIL,
       FN_DECRYPT(tmmi.MOBILE_NO) Phone,
        (SELECT THAT_NM FROM VW_MB_THAT_01 WHERE THAT_CD = rt.FIR_SALE_THAT_CD) site
  FROM result_table rt LEFT JOIN TB_MM_MBR_INFO tmmi ON rt.SAV_MBR_NO = tmmi.MBR_NO
  
  
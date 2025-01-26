WITH Most_Recent_Date_For_Client AS (
    SELECT 
     CLIENT
     ,CONTACT_NAME
     ,MAX(TO_DATE(FROM_DATE, 'dd/mm/yyyy')) AS DATE_COL
    FROM PD_2021_WK05
    GROUP BY CLIENT, CONTACT_NAME)
    
SELECT *
FROM PD_2021_WK05 m
INNER JOIN MOST_RECENT_DATE_FOR_CLIENT mr
    ON m.client = mr.client
    AND TO_DATE(m.FROM_DATE, 'dd/mm/yyyy') = mr.Date_col
    AND m.contact_name = mr.CONTACT_NAME;
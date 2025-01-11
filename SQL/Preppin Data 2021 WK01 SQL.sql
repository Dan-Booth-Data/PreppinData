WITH SPLITTING AS(
    SELECT
    order_id
    ,RTRIM(SPLIT_PART(STORE_BIKE, '-', 1)) AS Location
    ,LTRIM(SPLIT_PART(STORE_BIKE, '-', 2)) AS Bike
    FROM PD2021_WK01
)

SELECT 
    Location
    , main.ORDER_ID
    , CASE
        WHEN LEFT(BIKE, 1) = 'R' THEN 'Road'
        WHEN LEFT(BIKE, 1) = 'M' THEN 'Mountain'
        WHEN LEFT(BIKE, 1) = 'G' THEN 'Gravel'
      END AS Bike
    , QUARTER(DATE) AS Q
    , DAYOFMONTH(DATE) AS Day_Of_Month
FROM PD2021_WK01 main
INNER JOIN SPLITTING s
    ON main.order_id = s.order_id
WHERE TO_NUMBER(main.ORDER_ID) > 10;

-- Create a CTE with the cleaned initial table
WITH Agg_Table AS(
SELECT 
     QUARTER(FULL_DATA."Date") AS Q
     , CITY
    ,SUM(PRODUCTS_SOLD) AS PRODUCTS_SOLD
FROM (
    SELECT *
        , 'London' AS CITY
    FROM PD2021_WK03_LONDON
        UNION ALL
    SELECT *
     , 'Manchester' AS CITY
    FROM PD2021_WK03_MANCHESTER
        UNION ALL
    SELECT * 
     , 'Leeds' AS CITY
    FROM PD2021_WK03_LEEDS
        UNION ALL
    SELECT * 
    , 'Birmingham' AS CITY
    FROM PD2021_WK03_BIRMINGHAM
        UNION ALL
    SELECT * 
     , 'York' AS CITY
    FROM PD2021_WK03_YORK) AS FULL_DATA
UNPIVOT(PRODUCTS_SOLD
         FOR NAME
            IN ("New_-_Saddles"
            ,"New_-_Mudguards"
            ,"New_-_Wheels"
            ,"New_-_Bags"
            ,"Existing_-_Saddles"
            ,"Existing_-_Mudguards"
            ,"Existing_-_Wheels"
            ,"Existing_-_Bags"))
GROUP BY CITY, Q)


-- Join the CTE with the Targets table and Rank
SELECT *
    ,RANK() OVER ( PARTITION BY "Store" ORDER BY "Variance" DESC) AS STORE_RANK
FROM( 
    SELECT
        "Quarter"
        , "Store"
        , PRODUCTS_SOLD
        , "Target"
        , PRODUCTS_SOLD - "Target" AS "Variance"
    FROM AGG_TABLE M
    INNER JOIN PD2021_WK04_TARGETS T
        ON T."Quarter" = M.Q
        AND T."Store" = M.CITY);


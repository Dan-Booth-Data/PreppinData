-- OUTPUT 1

SELECT
    SPLIT_PART(NAME, '_-_', 2) AS PRODUCT
    ,QUARTER(FULL_DATA."Date") AS Q
    ,SUM(PRODUCTS_SOLD)
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
GROUP BY PRODUCT, Q;


-- OUTPUT 2
SELECT
    CITY
    ,SPLIT_PART(NAME, '_-_', 1) AS CUSTOMER_TYPE
    ,SPLIT_PART(NAME, '_-_', 2) AS PRODUCT
    ,SUM(PRODUCTS_SOLD)
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
GROUP BY CITY, CUSTOMER_TYPE, PRODUCT;
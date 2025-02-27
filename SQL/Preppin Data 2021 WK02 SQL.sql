--OUTPUT 1

SELECT
    ARRAY_TO_STRING(REGEXP_SUBSTR_ALL(MODEL, '[A-Z]'), '') AS BRAND -- Obtain only characters
    , BIKE_TYPE
    ,SUM(VALUE_PER_BIKE * QUANTITY) AS ORDER_VALUE
    ,SUM(QUANTITY) AS QUANTITY_SOLD
    ,AVG(VALUE_PER_BIKE) AS AVG_BIKE VALUE
FROM PD2021_WK02_BIKE_SALES
GROUP BY BRAND, BIKE_TYPE;


--OUTPUT 2

SELECT
    ARRAY_TO_STRING(REGEXP_SUBSTR_ALL(MODEL, '[A-Z]'), '') AS BRAND -- Obtain only characters
    , STORE
    ,SUM(VALUE_PER_BIKE * QUANTITY) AS ORDER_VALUE
    ,SUM(QUANTITY) AS QUANTITY_SOLD
    ,AVG(DATEDIFF
        ('days', TO_DATE(ORDER_DATE, 'DD/MM/YYYY')
        , TO_DATE(SHIPPING_DATE, 'DD/MM/YYYY'))) AS AVG_DAYS_TO_SHIP
FROM PD2021_WK02_BIKE_SALES
GROUP BY BRAND, STORE;
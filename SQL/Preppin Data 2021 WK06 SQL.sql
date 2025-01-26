WITH 
-- Total Prize Money
Total_Prize_Money AS (
    SELECT 
        'Total Prize Money' AS Measure,
        "'PGA'" AS PGA,  -- Single quotes around PGA
        "'LPGA'" AS LPGA,  -- Single quotes around LPGA
        LPGA - PGA AS "Difference between tours"
    FROM (
        SELECT
            SUM(TO_NUMBER(REGEXP_REPLACE(MONEY, '\\D', ''))) AS "Total Prize Money",
            TOUR
        FROM PD_2021_WK06
        GROUP BY TOUR
    ) 
    PIVOT (
        MAX("Total Prize Money") FOR TOUR IN ('PGA', 'LPGA')
    )
),

-- Number of Events
Number_of_Events AS (
    SELECT 
        'Number of Events' AS Measure,
        "'PGA'" AS PGA,  -- Single quotes around PGA
        "'LPGA'" AS LPGA,  -- Single quotes around LPGA
        LPGA - PGA AS "Difference between tours"
    FROM (
        SELECT
            SUM(EVENTS) AS "No. of Events",
            TOUR
        FROM PD_2021_WK06
        GROUP BY TOUR
    ) 
    PIVOT (
        MAX("No. of Events") FOR TOUR IN ('PGA', 'LPGA')
    )
),

-- Number of Players
Number_of_Players AS (
    SELECT 
        'Number of Players' AS Measure,
        "'PGA'" AS PGA,  -- Single quotes around PGA
        "'LPGA'" AS LPGA,  -- Single quotes around LPGA
        LPGA - PGA AS "Difference between tours"
    FROM (
        SELECT
            COUNT(PLAYER_NAME) AS "No. of Players",
            TOUR
        FROM PD_2021_WK06
        GROUP BY TOUR
    ) 
    PIVOT (
        MAX("No. of Players") FOR TOUR IN ('PGA', 'LPGA')
    )
),

-- AVG Money per Event
Avg_Money_Per_Event AS (
    SELECT 
        'Avg Money Per Event' AS Measure,
        "'PGA'" AS PGA,  -- Single quotes around PGA
        "'LPGA'" AS LPGA,  -- Single quotes around LPGA
        LPGA - PGA AS "Difference between tours"
    FROM (
        SELECT
            (SUM(TO_NUMBER(REGEXP_REPLACE(MONEY, '\\D', ''))) / SUM(EVENTS)) AS "AVG Prize Money",
            TOUR
        FROM PD_2021_WK06
        GROUP BY TOUR
    ) 
    PIVOT (
        MAX("AVG Prize Money") FOR TOUR IN ('PGA', 'LPGA')
    )
),

-- Rank Per Tour + Overall
Avg_Difference_in_Ranking AS (
    SELECT 
        'Avg Difference in Ranking' AS Measure,
        "'PGA'" AS PGA,  -- Single quotes around PGA
        "'LPGA'" AS LPGA,  -- Single quotes around LPGA
        LPGA - PGA AS "Difference between tours"
    FROM (
        SELECT
            AVG("Difference in Rank") AS Avg_diff,
            TOUR
        FROM (
            SELECT
                TO_NUMBER(REGEXP_REPLACE(MONEY, '\\D', '')) AS "AVG Prize Money",
                (RANK() OVER(ORDER BY TO_NUMBER(REGEXP_REPLACE(MONEY, '\\D', '')) DESC)) - 
                (RANK() OVER(PARTITION BY TOUR ORDER BY TO_NUMBER(REGEXP_REPLACE(MONEY, '\\D', '')) DESC)) AS "Difference in Rank",
                TOUR,
                PLAYER_NAME
            FROM PD_2021_WK06
        )
        GROUP BY TOUR
    ) 
    PIVOT (
        MAX(Avg_diff) FOR TOUR IN ('PGA', 'LPGA')
    )
)

-- Union all the CTEs
SELECT * FROM Total_Prize_Money
UNION ALL
SELECT * FROM Number_of_Events
UNION ALL
SELECT * FROM Number_of_Players
UNION ALL
SELECT * FROM Avg_Money_Per_Event
UNION ALL
SELECT * FROM Avg_Difference_in_Ranking;

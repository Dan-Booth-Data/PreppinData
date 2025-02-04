---- Get a dates table

WITH DATES AS(
    SELECT 
        DATEADD('minute', -11, MIN(TO_TIMESTAMP(DATE, 'DD/MM/YYYY HH24:MI'))) AS start_date
        ,MAX(TO_TIMESTAMP(DATE, 'DD/MM/YYYY HH24:MI')) AS end_date
    FROM PD_2021_WK08_SONGS), 

    GENERATED_DATES AS(
     SELECT 
        ROW_NUMBER() OVER (ORDER BY start_date) AS ROW_NUMBER 
       ,DATEADD('minute', row_number, start_date) AS DATES
     FROM DATES,
        TABLE(flatten(array_generate_range(0, datediff('minute', start_date, end_date))))
    ),

---- Join date table with main table and fill down
    Filled_Table AS(
        SELECT DATES
         , coalesce(Session_ID, lag(Session_ID) IGNORE NULLS over (order by DATES)) as filled_Session
         , coalesce(Song_order, lag(Song_order) IGNORE NULLS over (order by DATES)) as filled_Song_Order
        , coalesce(Song, lag(Song) IGNORE NULLS over (order by DATES)) as filled_Song
        , coalesce(Artist, lag(Artist) IGNORE NULLS over (order by DATES)) as filled_Artist
        FROM (SELECT *
            , RANK() OVER (PARTITION BY SESSION_ID ORDER BY DATE_TIME) AS SONG_ORDER  // Calculate Song Order
             FROM (SELECT
                        SUM(CASE WHEN NEW_SESSION = 'Yes' THEN 1 ELSE 0 END) 
                         OVER (ORDER BY DATE_TIME ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS SESSION_ID // Calculate Session_ID
                        , DATE_TIME
                        , ARTIST
                        , SONG
                   FROM (SELECT
                            DATEADD('minute' , -10, TO_TIMESTAMP(DATE, 'DD/MM/YYYY HH24:MI')) AS DATE_TIME
                            , ARTIST
                            , SONG
                            , LAG(DATE_TIME)
                                OVER (ORDER BY DATE_TIME) AS PREV_TIME
                            , DATEDIFF('minute', PREV_TIME, DATE_TIME) AS TIME_SINCE_LAST_SONG
                            , IFF(TIME_SINCE_LAST_SONG >59, 'Yes', 'No') AS NEW_SESSION // Calculate new session
                        FROM PD_2021_WK08_SONGS)
                        ORDER BY DATE_TIME))
        FULL JOIN GENERATED_DATES
            ON GENERATED_DATES.DATES >= DATE_TIME 
            AND GENERATED_DATES.DATES < DATEADD('minute', 1, DATE_TIME)
        ORDER BY DATES)


---- Combine with customer table, and fill down customers per session

SELECT 
    Filled_session
    , filled_song_order
    , Filled_Song
    , filled_artist
    , MIN(customers) AS customers_
    , MIN(DATES) AS TIME
FROM(
    SELECT
         Filled_session
         , filled_song_order
         , Filled_Song
         , filled_artist
         , coalesce(CUSTOMER_ID, lag(CUSTOMER_ID) IGNORE NULLS over (partition by FILLED_SESSION order by DATES)) as customers
         , DATES
        FROM FILLED_TABLE
    FULL JOIN PD_2021_WK08_CUSTOMERS
        ON DATES = TO_TIMESTAMP(ENTRY_TIME, 'DD/MM/YYYY HH24:MI'))
GROUP BY Filled_session
    , filled_song_order
    , Filled_Song
    , filled_artist
ORDER BY TIME;

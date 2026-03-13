WITH CTE AS (
  SELECT 
    -- Trim the double quotes (") from the string before converting
    TO_TIMESTAMP(TRIM(STARTED_AT, '"')) AS STARTED_AT,
    DATE(TO_TIMESTAMP(TRIM(STARTED_AT, '"'))) AS DATE_STARTED_AT,
    HOUR(TO_TIMESTAMP(TRIM(STARTED_AT, '"'))) AS HOUR_STARTED_AT,

    CASE 
    WHEN DAYNAME(TO_TIMESTAMP(TRIM(STARTED_AT, '"'))) in ('sat','sun')
    THEN 'WEEKEND'
    ELSE 'BUSINESSDAY'
    END AS DAY_TYPE,

     CASE WHEN MONTH(TO_TIMESTAMP(TRIM(STARTED_AT, '"'))) in (12,1,2)
          THEN 'WINTER'
          WHEN MONTH(TO_TIMESTAMP(TRIM(STARTED_AT, '"'))) in (3,4,5)
          THEN 'SPRING'   
           WHEN MONTH(TO_TIMESTAMP(TRIM(STARTED_AT, '"'))) in (6,7,8)
          THEN 'SUMMER'   
          ELSE 'AUTUMN'    
          END AS STATION_OF_YEAR     

    

  FROM 
    {{ source('demo', 'bike') }}
  WHERE 
    STARTED_AT NOT LIKE '%started%'
    AND STARTED_AT IS NOT NULL
)

SELECT * FROM CTE
-- NON-Vegan Products
SELECT 
    PRODUCT
    , MAX(DESCRIPTION)
    , MAX(INGREDIENTS_ALLERGENS)
    , LISTAGG(NON_VEGAN, ',') AS ALLERGEN
FROM (SELECT *
        , CONTAINS(INGREDIENTS_ALLERGENS, NON_VEGAN) AS NON_VEGAN_ITEM
    FROM PD_WK07_SHOPPING_LIST
     CROSS JOIN (SELECT 
                  REGEXP_SUBSTR(REPLACE(VALUE, ' ', ''), '\\w*') AS NON_VEGAN 
                  FROM PD_WK_07_INGREDIENTS, 
                       LATERAL FLATTEN(input=>split(animal_ingredients, ','))) //Split Ingredients into rows and append
    WHERE NON_VEGAN_ITEM = TRUE)
GROUP BY PRODUCT;


-- Vegan Products

WITH Non_Vegan_Products AS (
    SELECT 
        PRODUCT,
        MAX(DESCRIPTION) AS DESCRIPTION,
        MAX(INGREDIENTS_ALLERGENS) AS INGREDIENTS_ALLERGENS,
        LISTAGG(NON_VEGAN, ',') AS ALLERGEN
    FROM (
        SELECT *
            , CONTAINS(INGREDIENTS_ALLERGENS, NON_VEGAN) AS NON_VEGAN_ITEM
        FROM PD_WK07_SHOPPING_LIST
        CROSS JOIN (
                SELECT 
                    REGEXP_SUBSTR(REPLACE(VALUE, ' ', ''), '\\w*') AS NON_VEGAN 
                FROM PD_WK_07_INGREDIENTS, 
                 LATERAL FLATTEN(input => split(animal_ingredients, ',')))
        WHERE NON_VEGAN_ITEM = TRUE)
    GROUP BY PRODUCT
)

SELECT 
    shopping_list.PRODUCT,
    shopping_list.DESCRIPTION,
    shopping_list.INGREDIENTS_ALLERGENS
FROM PD_WK07_SHOPPING_LIST shopping_list
LEFT JOIN Non_Vegan_Products non_vegan
    ON shopping_list.PRODUCT = non_vegan.PRODUCT
WHERE non_vegan.PRODUCT IS NULL;

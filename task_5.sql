--Задание 5
WITH menu_cte AS (
	SELECT
		cafe_name,
		'Пицца' AS dish_type,
		(jsonb_each_text(menu -> 'Пицца')).KEY AS pizza_name,
		(jsonb_each_text(menu -> 'Пицца')).value::int AS pizza_price
	FROM cafe.restaurants AS r
	WHERE type = 'pizzeria'
),
menu_with_rank AS (
	SELECT
		cafe_name,
		dish_type,
		pizza_name,
		pizza_price,
		row_number() OVER (PARTITION BY cafe_name ORDER BY pizza_price DESC) AS rn
	FROM menu_cte
)
SELECT
	cafe_name,
	dish_type,
	pizza_name,
	pizza_price
FROM menu_with_rank
WHERE rn = 1
ORDER BY cafe_name;
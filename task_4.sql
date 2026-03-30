--Задание 4
WITH menu_table AS (
	SELECT
		cafe_name,
		(jsonb_each_text(menu -> 'Пицца')).KEY AS pizza_name
	FROM cafe.restaurants AS r
	WHERE type = 'pizzeria'
),
rank_cafe AS (
	SELECT
		cafe_name,
		count(pizza_name) AS pizza_count,
		dense_rank() OVER (ORDER BY count(pizza_name) DESC) AS rank
	FROM menu_table
	GROUP BY cafe_name
)
SELECT cafe_name, pizza_count
FROM rank_cafe
WHERE RANK = 1;
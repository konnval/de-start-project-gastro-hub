-- Задание 1
CREATE VIEW cafe.v_avg_top_sales AS
	WITH avg_rest AS (
		SELECT restaurant_uuid, avg(avg_check)::NUMERIC(6,2) AS avg_check
		FROM cafe.sales AS s
		GROUP BY restaurant_uuid
	),
		top_sales AS (
		SELECT
			cafe_name AS cafe_name,
			type AS cafe_type,
			avg_check,
			row_number() OVER (PARTITION BY type ORDER BY avg_check DESC) AS rows
		FROM cafe.restaurants AS r
		JOIN avg_rest USING (restaurant_uuid)
		ORDER BY type
	)
	SELECT cafe_name, cafe_type, avg_check
	FROM top_sales
	WHERE ROWS <= 3;
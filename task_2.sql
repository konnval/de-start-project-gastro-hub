--Задание 2
CREATE MATERIALIZED VIEW cafe.v_check_difference_per_year AS
	WITH avg_per_year AS (
		SELECT 
			EXTRACT(YEAR FROM s.date) AS year,
			r.cafe_name AS cafe_name,
			r.type,
			avg(s.avg_check)::NUMERIC(6,2) AS avg_check
		FROM cafe.sales AS s
		JOIN cafe.restaurants AS r USING (restaurant_uuid)
		GROUP BY EXTRACT(YEAR FROM s.date), cafe_name, type
	)
	SELECT
		*,
		LAG(avg_check) OVER(PARTITION BY cafe_name ORDER BY avg_per_year.YEAR) AS prev_check,
		(((avg_check / LAG(avg_check) OVER(PARTITION BY cafe_name)) - 1) * 100)::NUMERIC(6,2) AS percentage
	FROM avg_per_year
	WHERE YEAR < 2023;
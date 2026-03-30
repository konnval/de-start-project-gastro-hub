--Задание 3
WITH manager_history AS (
	SELECT
		cafe_name,
		manager_uuid,
		LAG(manager_uuid) OVER (PARTITION BY restaurant_uuid ORDER BY start_date) AS prev_manager
	FROM cafe.restaurant_manager_work_dates AS rm
	JOIN cafe.restaurants AS r USING(restaurant_uuid)
)
SELECT
	cafe_name,
	sum(CASE WHEN manager_uuid != prev_manager THEN 1 ELSE 0 END) AS manager_changes
FROM manager_history
GROUP BY cafe_name
ORDER BY manager_changes DESC
LIMIT 3;
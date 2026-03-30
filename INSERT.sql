-- запонляем таблицу ресторанов
INSERT INTO cafe.restaurants(cafe_name, type)
SELECT DISTINCT
	cafe_name,
	type::cafe.restaurant_type
FROM raw_data.sales;

-- заполняем таблицу менеджеров
INSERT INTO cafe.managers(manager, manager_phone)
SELECT DISTINCT
	manager,
	manager_phone
FROM raw_data.sales;

-- заполняем таблицу начала и окончания смен менеджеров
INSERT INTO cafe.restaurant_manager_work_dates(restaurant_uuid, manager_uuid, start_date, end_date)
SELECT DISTINCT 
	r.restaurant_uuid,
	m.manager_uuid,
	min(s.report_date) AS start_date,
	max(s.report_date) AS end_date
FROM raw_data.sales AS s
JOIN cafe.restaurants AS r ON s.cafe_name = r.cafe_name
JOIN cafe.managers AS m ON s.manager = m.manager
GROUP BY r.restaurant_uuid, m.manager_uuid
ORDER BY m.manager_uuid;

-- заполняем таблицу продаж
INSERT INTO cafe.sales(date, restaurant_uuid, avg_check)
SELECT s.report_date, r.restaurant_uuid, s.avg_check
FROM raw_data.sales AS s
JOIN cafe.restaurants AS r ON s.cafe_name = r.cafe_name;
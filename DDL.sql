-- создаем схему для gastrohub
CREATE SCHEMA IF NOT EXISTS cafe;

-- создаем enum с типами заведений
CREATE TYPE cafe.restaurant_type AS ENUM ('coffee_shop', 'restaurant', 'bar', 'pizzeria');

-- таблица информации о ресторанах
CREATE TABLE cafe.restaurants(
	restaurant_uuid uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	cafe_name varchar NOT NULL UNIQUE,
	type cafe.restaurant_type
);

-- при решении задач я понял, что забыл добавить меню в таблицу ресторанов.
-- поэтому добавил меню через изменение таблицы, чтобы не пересоздавать их. и поднял строки запросов сюда
ALTER TABLE cafe.restaurants ADD COLUMN menu jsonb;

UPDATE cafe.restaurants AS r
SET menu = m.menu
FROM raw_data.menu m
WHERE r.cafe_name = m.cafe_name;

-- таблица информации о менеджерах
CREATE TABLE cafe.managers(
	manager_uuid uuid PRIMARY KEY DEFAULT gen_random_uuid(),
	manager varchar NOT NULL,
	manager_phone varchar NOT NULL
);

-- таблица начала и окончания смен менеджеров в ресторане
CREATE TABLE cafe.restaurant_manager_work_dates(
	restaurant_uuid uuid NOT NULL REFERENCES cafe.restaurants(restaurant_uuid),
	manager_uuid uuid NOT NULL REFERENCES cafe.managers(manager_uuid),
	start_date date NOT NULL DEFAULT current_date,
	end_date date,
	PRIMARY KEY (restaurant_uuid, manager_uuid)
);

-- таблица продаж
CREATE TABLE cafe.sales(
	date date NOT NULL,
	restaurant_uuid uuid NOT NULL REFERENCES cafe.restaurants(restaurant_uuid),
	avg_check NUMERIC(6,2),
	PRIMARY KEY (date, restaurant_uuid)
);
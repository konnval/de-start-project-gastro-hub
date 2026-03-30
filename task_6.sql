--Задание 6
BEGIN;
SELECT *
FROM cafe.restaurants
WHERE type = 'coffee_shop' AND menu -> 'Кофе' ? 'Капучино'
FOR UPDATE; 
-- выбрал for update тк думаю он наиболее подходящий для ситуации когда
-- нужно заблокировать строки на изменение и в рамках этой же транзакции их обновить

WITH coffee_prices AS (
	SELECT
		cafe_name,
		ROUND(((menu -> 'Кофе' ->> 'Капучино')::numeric * 1.2))::int AS new_price
	FROM cafe.restaurants
	WHERE type = 'coffee_shop' AND menu -> 'Кофе' ? 'Капучино'
)
UPDATE cafe.restaurants AS r
SET menu = jsonb_set(r.menu, '{Кофе,Капучино}', to_jsonb(cp.new_price), false)
FROM coffee_prices AS cp
WHERE cp.cafe_name = r.cafe_name;
COMMIT;
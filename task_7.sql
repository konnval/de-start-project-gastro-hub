--Задание 7
BEGIN;
LOCK TABLE cafe.managers IN EXCLUSIVE MODE;
-- EXCLUSIVE MODE как раз подходит для режима, когда нужно запретить редактировать таблицу
-- но оставить доступ для чтения из нее.

ALTER TABLE cafe.managers ADD COLUMN phones text[];

WITH new_phones AS (
	SELECT
		manager_uuid,
		ARRAY['8-800-2500-' || num, manager_phone] AS phones
	FROM (
		SELECT *, row_number() OVER (ORDER BY manager) + 99 AS num
		FROM cafe.managers AS m
	) AS row_num
)
UPDATE cafe.managers AS m
SET phones = p.phones
FROM new_phones AS p
WHERE m.manager_uuid = p.manager_uuid;

ALTER TABLE cafe.managers DROP COLUMN manager_phone;

COMMIT;
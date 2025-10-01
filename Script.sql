-- Создание последовательности
create sequence culture_palaces_clubs_seq

ALTER TABLE culture_palaces_clubs
    ALTER COLUMN "data.general.id" SET DEFAULT nextval('culture_palaces_clubs_seq');

-- Добавление первичного ключа к колонке data.general.id
ALTER TABLE culture_palaces_clubs
    ADD CONSTRAINT culture_palaces_clubs_pkey PRIMARY KEY ("data.general.id");

-- Проверка на NULL 
SELECT COUNT(*) AS null_name FROM culture_palaces_clubs WHERE "data.general.category.name" IS NULL;
SELECT COUNT(*) AS null_full_address FROM culture_palaces_clubs WHERE "data.general.address.fullAddress" IS NULL;

-- Проверка дубликатов organization_inn
SELECT "data.general.organization.inn", COUNT(*) 
FROM culture_palaces_clubs
GROUP BY "data.general.organization.inn"
HAVING COUNT(*) > 1;

-- Установка NOT NULL
ALTER TABLE culture_palaces_clubs
ALTER COLUMN "data.general.category.name" SET NOT NULL,
ALTER COLUMN "data.general.address.fullAddress" SET NOT NULL;

-- Отобразить все данные, относящиеся к Вологодской области
select * 
FROM culture_palaces_clubs
WHERE "data.general.address.fullAddress" LIKE '%Вологодская%';

-- Удалить все записи из таблицы, кроме тех, которые относятся к Вологодской области
DELETE FROM culture_palaces_clubs
WHERE "data.general.address.fullAddress" NOT LIKE '%Вологодская%';

-- Просмотр таблицы после удаления записей
SELECT * FROM culture_palaces_clubs;

-- Создать расширение PostGIS
CREATE EXTENSION IF NOT EXISTS postgis;

-- Добавить новую колонку geom для хранения географических координат
ALTER TABLE culture_palaces_clubs
ADD COLUMN geom geometry(Point, 4326);

-- Преобразовать данные из колонки data.general.address.mapPosition в геометрию типа Point 
UPDATE culture_palaces_clubs
SET geom = ST_SetSRID(ST_GeomFromGeoJSON("data.general.address.mapPosition" ), 4326)
WHERE "data.general.address.mapPosition" IS NOT NULL;

-- Проверка
SELECT COUNT(*), COUNT(geom) FROM culture_palaces_clubs;


-- Создание таблицы   
CREATE TABLE tags (
    tag_id SERIAL PRIMARY KEY,
    tag_name VARCHAR(255) NOT NULL,
    sys_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM tags;

-- Извлечение уникальных тегов 
INSERT INTO tags (tag_name, sys_name)
SELECT DISTINCT 
    tag->>'name' AS tag_name,
    tag->>'sysName' AS sys_name
FROM culture_palaces_clubs,
     jsonb_array_elements("data.general.tags") AS tag
WHERE "data.general.tags" IS NOT NULL;

SELECT * FROM tags;

-- Создание промежуточной таблицы для хранения связей 
CREATE TABLE m2m_culture_palaces_clubs_tags (
    "data.general.id" INTEGER NOT NULL,
    tag_id INTEGER NOT NULL,
    CONSTRAINT m2m_culture_palaces_clubs_tags_pk PRIMARY KEY ("data.general.id", tag_id),
    CONSTRAINT m2m_culture_palaces_clubs_tags_culture_palace_club_fk FOREIGN KEY ("data.general.id")
        REFERENCES culture_palaces_clubs("data.general.id"),
    CONSTRAINT m2m_culture_palaces_clubs_tags_tag_fk FOREIGN KEY (tag_id)
        REFERENCES tags(tag_id)  
);

-- Заполнение таблицы данными
INSERT INTO m2m_culture_palaces_clubs_tags ("data.general.id", tag_id)
SELECT c."data.general.id", t.tag_id
FROM culture_palaces_clubs c
JOIN jsonb_array_elements(c."data.general.tags") AS tag ON TRUE
JOIN tags t ON t.sys_name = tag->>'sysName'
WHERE c."data.general.tags" IS NOT NULL;

SELECT * FROM m2m_culture_palaces_clubs_tags;

-- Создание индексов на столбцах
CREATE INDEX idx_culture_palace_club_id ON m2m_culture_palaces_clubs_tags("data.general.id");
CREATE INDEX idx_tag_id ON m2m_culture_palaces_clubs_tags(tag_id);










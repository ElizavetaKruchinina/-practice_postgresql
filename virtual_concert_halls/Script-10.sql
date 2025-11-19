-- Отобразить все данные, относящиеся к Вологодской области
select * 
FROM virtual_concert_hall.virrtual_concert_halls 
WHERE "data.region" LIKE '%Вологодская%';

-- Удалить все записи из таблицы, кроме тех, которые относятся к Вологодской области
DELETE FROM virtual_concert_hall.virrtual_concert_halls
WHERE "data.region" NOT LIKE '%Вологодская%';

-- Просмотр таблицы после удаления записей
SELECT * FROM virtual_concert_hall.virrtual_concert_halls;

-- Добавим столбик geom для хранения географических координат
ALTER TABLE virtual_concert_hall.virrtual_concert_halls
ADD COLUMN geom public.geometry(point, 4326);

-- Добавим столбик date_download, в которой будет дата загрузки данных
ALTER TABLE virtual_concert_hall.virrtual_concert_halls
ADD COLUMN date_download DATE;

UPDATE virtual_concert_hall.virrtual_concert_halls 
SET date_download = '2023-09-25';
   
-- Добавлние координат
UPDATE virtual_concert_hall.virrtual_concert_halls 
SET geom = ST_SetSRID(ST_MakePoint(46.481384, 60.960193), 4326)
WHERE "data.address" = '162341, Вологодская обл., район Великоустюгский, город Красавино, проспект Советский, дом 152';

UPDATE virtual_concert_hall.virrtual_concert_halls 
SET geom = ST_SetSRID(ST_MakePoint(35.949886, 59.386477), 4326)
WHERE "data.address" = '162480, Вологодская обл., район Бабаевский, город Бабаево, площадь Привокзальная, дом 3';

UPDATE virtual_concert_hall.virrtual_concert_halls 
SET geom = ST_SetSRID(ST_MakePoint(40.131085, 59.456884), 4326)
WHERE "data.address" = '162130, Вологодская обл., район Сокольский, город Сокол, улица Советская, дом 30';

UPDATE virtual_concert_hall.virrtual_concert_halls 
SET geom = ST_SetSRID(ST_MakePoint(40.206930, 59.951371), 4326)
WHERE "data.address" = '162250, Вологодская обл., район Харовский, город Харовск, улица Октябрьская, дом 10';

UPDATE virtual_concert_hall.virrtual_concert_halls 
SET geom = ST_SetSRID(ST_MakePoint(36.448936, 61.008919), 4326)
WHERE "data.address" = '162900, ВОЛОГОДСКАЯ ОБЛАСТЬ, ВЫТЕГОРСКИЙ Р-Н, Г. ВЫТЕГРА, УЛ. 25 ОКТЯБРЯ, Д.12';

























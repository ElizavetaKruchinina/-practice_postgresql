CREATE EXTENSION postgis;

-- Нахождение дубликатов геоданных объектов в колонке geom*, sql-запрос показывает:
-- Какие координаты повторяются
-- Сколько домов имеют одинаковые координаты
-- Какие это адреса

SELECT 
    geom,
    COUNT(*) AS num_houses,
    ARRAY_AGG(address) AS addresses
FROM 
    resstr_mkd.reformagkh_reestr_mkd rrm
GROUP BY 
    geom
HAVING 
    COUNT(*) > 1;

-- Корректировка геоданных: Проверка реального расположение домов с через Яндекс.Карты, определение корректных координат для каждого адреса
-- SQL-запросы на обновление некорректных значений в колонке geom

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.905042, 59.085752), 4326) 
WHERE address = 'Вологодская обл, Череповец г, Городецкая ул, д. 15 секц.3'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.904575, 59.085844), 4326) 
WHERE address = 'Вологодская обл, Череповец г, Городецкая ул, д. 15 секц.6'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.905312, 59.085803), 4326) 
WHERE address = 'Вологодская обл, Череповец г, Городецкая ул, д. 15 секц.2'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.904485, 59.085978), 4326) 
WHERE address = 'Вологодская обл, Череповец г, Городецкая ул, д. 15 секц.7'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.904647, 59.085729), 4326) 
WHERE address = 'Вологодская обл, Череповец г, Городецкая ул, д. 15 секц.5';  

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.904737, 59.085701), 4326) 
WHERE address = 'Вологодская обл, Череповец г, Городецкая ул, д. 15 секц.4'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.904737, 59.085701), 4326) 
WHERE address = 'Вологодская обл, Череповец г, Городецкая ул, д. 15 секц.1'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.907234, 59.093943), 4326) 
WHERE address = 'Вологодская обл, Череповец г, Наседкина ул, д. 12, корп. 1'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.906839, 59.090342), 4326) 
WHERE address = 'Вологодская обл, Череповец г, Городецкая ул, д. 22 секц.1'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.906830, 59.090171), 4326) 
WHERE address = 'Вологодская обл, Череповец г, Городецкая ул, д. 22 секц.2'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.908043, 59.092298), 4326)
WHERE address = 'Вологодская обл, Череповец г, Наседкина ул, д. 7, корп. 1';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.914681, 59.129585), 4326)
WHERE address = 'Вологодская обл, Череповец г, Металлургов пл, д. 5';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.913253, 59.129331), 4326)
WHERE address = 'Вологодская обл, Череповец г, Металлургов ул, д. 2';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.914070, 59.128357), 4326)
WHERE address = 'Вологодская обл, Череповец г, Металлургов пл, д. 2';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.913253, 59.129331), 4326)
WHERE address = 'Вологодская обл, Череповец г, Металлургов ул, д. 2';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.913253, 59.129331), 4326)
WHERE address = 'Вологодская обл, Череповец г, Верещагина ул, д. 8, корп. 2';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.913612, 59.121906), 4326)
WHERE address = 'Вологодская обл, Череповец г, Верещагина ул, д. 8';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.913253, 59.129331), 4326)
WHERE address = 'Вологодская обл, Череповец г, Металлургов ул, д. 2';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.915615, 59.100349), 4326)
WHERE address = 'Вологодская обл, Череповец г, Батюшкова ул, д. 9, корп. 1';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.916029, 59.088290), 4326)
WHERE address = 'Вологодская обл, Череповец г, Городецкая ул, д. 1А секц.2';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.915615, 59.088373), 4326)
WHERE address = 'Вологодская обл, Череповец г, Городецкая ул, д. 1А секц.1';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.918068, 59.099947), 4326)
WHERE address = 'Вологодская обл, Череповец г, Батюшкова ул, д. 12, корп. 1';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.923368, 59.097904), 4326)
WHERE address = 'Вологодская обл, Череповец г, Годовикова ул, д. 24, корп. 1';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.929216, 59.100132), 4326)
WHERE address = 'Вологодская обл, Череповец г, Раахе ул, д. 58';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.930869, 59.129017), 4326)
WHERE address = 'Вологодская обл, Череповец г, Советский пр-кт, д. 81, корп. 1';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.934399, 59.095076), 4326)
WHERE address = 'Вологодская обл, Череповец г, Рыбинская ул, д. 16, корп. 1';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.943733, 59.148936), 4326)
WHERE address = 'Вологодская обл, Череповец г, П.Окинина ул, д. 12 секц.2';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.943661, 59.148710), 4326)
WHERE address = 'Вологодская обл, Череповец г, П.Окинина ул, д. 12 секц.1';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.960405, 59.116118), 4326)
WHERE address = 'Вологодская обл, Череповец г, Красная ул, д. 20, корп. 2';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.961277, 59.116774), 4326)
WHERE address = 'Вологодская обл, Череповец г, Красная ул, д. 24 секц.1';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.960944, 59.116922), 4326)
WHERE address = 'Вологодская обл, Череповец г, Красная ул, д. 24 секц.2';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.966846, 59.123970), 4326)
WHERE address = 'Вологодская обл, Череповец г, Победы пр-кт, д. 102 секц.2';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.982279, 59.129368), 4326)
WHERE address = 'Вологодская обл, Череповец г, Архангельская ул, д. 100 , корп. 1';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.982369, 59.129959), 4326)
WHERE address = 'Вологодская обл, Череповец г, Архангельская ул, д. 100';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.995862, 59.115869), 4326)
WHERE address = 'Вологодская обл, Череповец г, К.Белова ул, д. 29, корп. 2';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(37.996248, 59.115809), 4326)
WHERE address = 'Вологодская обл, Череповец г, К.Белова ул, д. 29, корп. 1';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(38.000066, 59.117268), 4326)
WHERE address = 'Вологодская обл, Череповец г, Победы пр-кт, д. 190, корп. 1';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(38.004603, 59.128574), 4326)
WHERE address = 'Вологодская обл, Череповец г, Краснодонцев ул, д. 94, корп. 1';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(38.004683, 59.128343), 4326)
WHERE address = 'Вологодская обл, Череповец г, Краснодонцев ул, д. 94, корп. 2';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(38.005474, 59.115194), 4326)
WHERE address = 'Вологодская обл, Череповец г, Олимпийская ул, д. 3, корп. 1';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(38.514562, 59.238639), 4326)
WHERE address = 'Вологодская обл, Шекснинский район, Шексна рп, Школьная ул, д. 2, корп. 2';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(39.854238, 59.214295), 4326)
WHERE address = 'Вологодская обл, Вологда г, Ленинградская ул, д. 74, корп. 2';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(39.854297, 59.214297), 4326)
WHERE address = 'Вологодская обл, Вологда г, Ленинградская ул, д. 74, корп. 1';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(39.871311, 59.228310), 4326)
WHERE address = 'Вологодская обл, Вологда г, Маяковского пер, д. 6';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(39.921401, 59.212754), 4326)
WHERE address = 'Вологодская обл, Вологда г, Разина ул, д. 34А, корп. 1';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(39.921823, 59.214965), 4326)
WHERE address = 'Вологодская обл, Вологда г, Водников пер, д. 3';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(40.187607, 59.971546), 4326)
WHERE address = 'Вологодская обл, Харовский район, Харовск г, Кирова ул, д. 7';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(42.76646, 59.975277), 4326)
WHERE address = 'Вологодская обл, Тотемский район, Тотьма г, Луначарского ул, д. 26';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(40.098324, 59.472246), 4326)
WHERE address = 'Вологодская обл, Сокольский район, Сокол г, Советская ул, д. 94, корп. 1';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(40.148396, 59.444045), 4326)
WHERE address = 'Вологодская обл, Сокольский район, Сокол г, Шатенево ул, д. 49';

UPDATE resstr_mkd.reformagkh_reestr_mkd rrm
SET geom = ST_SetSRID(ST_MakePoint(46.326685, 60.745405), 4326)
WHERE address = 'Вологодская обл, Великоустюгский район, Великий Устюг г, Водников ул, д. 80 секц.1';

-- Проверка
SELECT 
    geom,
    COUNT(*) AS num_houses,
    ARRAY_AGG(address) AS addresses
FROM 
    resstr_mkd.reformagkh_reestr_mkd rrm
GROUP BY 
    geom
HAVING 
    COUNT(*) > 1;













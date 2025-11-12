-- Устранение дубликатов: поиск через колонку houseguid (т.к. в колонке address не было совпадений, а через другие неэффективно).
-- Например, houseguid: 1b5711a9-e9af-4887-8c08-ea27fb95bfe2 был у 2-х адресов:
--		Вологодская обл, Вологда г, Воркутинская ул., д. 14Б
--		Вологодская обл, Вологда г, Воркутинская ул, д. 14Б
-- Адрес один и тот же, только разная запись - у одной есть точка после ул., а другой - нет.

SELECT 
    houseguid,
    COUNT(*) AS num,
    ARRAY_AGG(address) AS addresses
FROM 
    resstr_mkd.reestr_mkd_new
GROUP BY 
    houseguid
HAVING 
    COUNT(*) > 1;

-- Удаление записи в зависимости от last_update

DELETE FROM resstr_mkd.reestr_mkd_new
WHERE address = 'Вологодская обл, Вологда г, Воркутинская ул, д. 14Б';

DELETE FROM resstr_mkd.reestr_mkd_new
WHERE address = 'Вологодская обл, Великоустюгский район, Великий Устюг г, 2-я ул, д. 1';

DELETE FROM resstr_mkd.reestr_mkd_new
WHERE address = 'Вологодская обл, Череповец г, Октябрьский пр-кт, д. 49, корп. 1';

DELETE FROM resstr_mkd.reestr_mkd_new
WHERE address = 'Вологодская обл, Вологда г, Герцена ул, д. 70';

DELETE FROM resstr_mkd.reestr_mkd_new
WHERE address = 'Вологодская обл, Вологда г, Ветошкина ул, д. 54';

DELETE FROM resstr_mkd.reestr_mkd_new
WHERE address = 'Вологодская обл, Великоустюгский район, Великий Устюг г, 2-я ул, д. 24Б';

DELETE FROM resstr_mkd.reestr_mkd_new
WHERE address = 'Вологодская обл, Вологда г, Зосимовская ул, д. 40';

DELETE FROM resstr_mkd.reestr_mkd_new
WHERE address = 'Вологодская обл, Вытегорский район, Вытегра г, К.Либкнехта ул, д. 29';

DELETE FROM resstr_mkd.reestr_mkd_new
WHERE address = 'Вологодская обл, Череповец г, Шекснинский пр-кт, д. 16 секц.';



-- Определение, какие записи есть в reestr_mkd_new и нет reformagkh_reestr_mkd 

SELECT n.address
FROM reestr_mkd_new.export_kr1 n
WHERE NOT EXISTS (
    SELECT 1
    FROM resstr_mkd.reformagkh_reestr_mkd m
    WHERE m.address = n.address
);


-- Обновление таблицы reforma_reestr_mkd новыми данными (т. е. добавить только те данные, которых в таблице нет); 

INSERT INTO resstr_mkd.reformagkh_reestr_mkd (
    subject_rf,
    mun_obr_oktmo,
    mun_obr,
    mkd_code,
    houseguid,
    address,
    commission_year,
    architectural_monument_category,
    total_s,
    total_rooms_amount,
    living_rooms_amount,
    total_rooms_s,
    living_rooms_s,
    total_ppl,
    number_floors_max,
    money_collecting_way,
    money_ppl_collected,
    money_ppl_collected_debts,
    overhaul_funds_spent_all,
    overhaul_funds_spent_subsidy,
    overhaul_fund_spent_other,
    overhaul_funds_balance,
    update_date_of_information,
    money_ppl_collected_date,
    owners_payment,
    energy_efficiency,
    alarm_document_date,
    exclude_date_from_program,
    inclusion_date_to_program,
    comment,
    last_update,
    house_id
)
SELECT
    subject_rf,
    mun_obr_oktmo,
    mun_obr,
    mkd_code,
    houseguid,
    address,
    commission_year,
    architectural_monument_category,
    total_s,
    total_rooms_amount,
    living_rooms_amount,
    total_rooms_s,
    living_rooms_s,
    total_ppl,
    number_floors_max,
    money_collecting_way,
    money_ppl_collected,
    money_ppl_collected_debts,
    overhaul_funds_spent_all,
    overhaul_funds_spent_subsidy,
    overhaul_fund_spent_other,
    overhaul_funds_balance,
    update_date_of_information,
    money_ppl_collected_date,
    owners_payment,
    energy_efficiency,
    alarm_document_date,
    exclude_date_from_program,
    inclusion_date_to_program,
    comment,
    last_update,
    house_id
FROM resstr_mkd.reestr_mkd_new n
WHERE NOT EXISTS (
     SELECT 1
     FROM resstr_mkd.reformagkh_reestr_mkd m
     WHERE m.address = n.address   
);


-- Заполним поле id у новых записей:
-- Создаем последовательность
CREATE SEQUENCE mkd_seq START WITH 11247 INCREMENT BY 1;

-- Обновляем существующие строки с отсутствующими значениями id
UPDATE resstr_mkd.reformagkh_reestr_mkd
SET id = nextval('mkd_seq')
WHERE id IS NULL;


-- Определим, какие записи в reformagkh_reestr_mkd имеют новые адреса (которых ранее не было в таблице до обновления)

SELECT address
FROM resstr_mkd.reformagkh_reestr_mkd
WHERE geom IS NULL;


-- Находим координаты для новых записей через Яндекс.Карты и вносим их в поле geom 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(37.630504, 59.124836), 4326) 
WHERE address = 'Вологодская обл, Череповецкий район, Неверов Бор п, Рейдовая ул, д. 29'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.249487, 58.833169), 4326) 
WHERE address = 'Вологодская обл, Грязовецкий район, Льнозавода п, Речная ул, д. 19'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.003096, 59.133388), 4326) 
WHERE address = 'Вологодская обл, Вологодский район, Снасудово д, д. 3'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(39.845527, 59.216280), 4326) 
WHERE address = 'Вологодская обл, Вологда г, Петина ул, д. 34'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(39.903398, 59.249496), 4326) 
WHERE address = 'Вологодская обл, Вологда г, Старое шоссе ул, д. 9'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(39.896656, 59.264364), 4326) 
WHERE address = 'Вологодская обл, Вологда г, ст. Рыбкино тер, д. 11'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(39.895240, 59.262981), 4326) 
WHERE address = 'Вологодская обл, Вологда г, ст. Рыбкино тер, д. 1Б'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(39.905618, 59.253652), 4326) 
WHERE address = 'Вологодская обл, Вологда г, Чернышевского ул, д. 128А'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(37.877877, 59.124081), 4326) 
WHERE address = 'Вологодская обл, Череповец г, Устюженская ул, д. 14'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(44.376738, 60.231326), 4326) 
WHERE address = 'Вологодская обл, Нюксенский район, Городищна с, Школьная ул, д. 32'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(43.291374, 60.439779), 4326) 
WHERE address = 'Вологодская обл, Тарногский район, Тюприха д, д. 33'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.762081, 58.928926), 4326) 
WHERE address = 'Вологодская обл, Грязовецкий район, Лежа п/ст, Железнодорожная ул, д. 14'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.768581, 58.931228), 4326) 
WHERE address = 'Вологодская обл, Грязовецкий район, Лежа п/ст, Железнодорожная ул, д. 21'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.768581, 58.931228), 4326) 
WHERE address = 'Вологодская обл, Грязовецкий район, Лежа п/ст, Советская ул, д. 4'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.762081, 58.928926), 4326) 
WHERE address = 'Вологодская обл, Грязовецкий район, Лежа п/ст, Советская ул, д. 6'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.249487, 58.833169), 4326) 
WHERE address = 'Вологодская обл, Грязовецкий район, Льнозавода п, Речная ул, д. 24'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.249487, 58.833169), 4326) 
WHERE address = 'Вологодская обл, Грязовецкий район, Льнозавода п, Речная ул, д. 30'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.297272, 59.065358), 4326) 
WHERE address = 'Вологодская обл, Грязовецкий район, Туфаново ж/д_ст, д. 9'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(35.933754, 59.389917), 4326) 
WHERE address = 'Вологодская обл, Бабушкинский район, им Бабушкина с, Мелиоративный пер, д. 5А'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(37.249459, 59.963509), 4326) 
WHERE address = 'Вологодская обл, Белозерский район, Артюшинское с/п, Анашкино д, д. 31'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.199429, 60.476227), 4326) 
WHERE address = 'Вологодская обл, Вожегодский район, Большая Климовская д, Чкалова ул, д. 5'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.253229, 58.876337), 4326) 
WHERE address = 'Вологодская обл, Грязовецкий район, Грязовец г, Ленина ул, д. 75 секц.1'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(46.398505, 60.766878), 4326) 
WHERE address = 'Вологодская обл, Великоустюгский район, Аристово д, Садовая ул, д. 2'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(39.901512, 59.190020), 4326) 
WHERE address = 'Вологодская обл, Вологда г, Конева ул, д. 14'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(37.938981, 59.148308), 4326) 
WHERE address = 'Вологодская обл, Череповец г, Остинская ул, д. 23'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(41.032282, 58.830016), 4326) 
WHERE address = 'Вологодская обл, Грязовецкий район, Вохтога пгт, Ленина ул, д. 4'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(41.047913, 58.814428), 4326) 
WHERE address = 'Вологодская обл, Грязовецкий район, Вохтога пгт, Октябрьская ул, д. 55'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(46.425114, 60.822542), 4326) 
WHERE address = 'Вологодская обл, Великоустюгский район, Бобровниково д, Лесная ул, д. 38'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(46.465116, 60.928889), 4326) 
WHERE address = 'Вологодская обл, Великоустюгский район, Васильевское с, Центральная ул, д. 40'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(46.318250, 60.749420), 4326) 
WHERE address = 'Вологодская обл, Великоустюгский район, Великий Устюг г, Водников ул, д. 32А'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(46.269337, 60.771900), 4326) 
WHERE address = 'Вологодская обл, Великоустюгский район, Великий Устюг г, Гледенская ул, д. 59Б'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(35.934793, 59.401824), 4326) 
WHERE address = 'Вологодская обл, Бабаевский район, Бабаево г, Гайдара ул, д. 34'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(46.320127, 60.779497), 4326) 
WHERE address = 'Вологодская обл, Великоустюгский район, Великий Устюг г, Транспортная ул, д. 2Б'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(46.314800, 60.756145), 4326) 
WHERE address = 'Вологодская обл, Великоустюгский район, Великий Устюг г, Шилова пер, д. 5'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(46.300921, 60.774110), 4326) 
WHERE address = 'Вологодская обл, Великоустюгский район, Великий Устюг г, Щетинщиков 4-й проезд, д. 4'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.253277, 58.876386), 4326) 
WHERE address = 'Вологодская обл, Грязовецкий район, Грязовец г, Ленина ул, д. 75 секц.2'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(46.177503, 60.723724), 4326) 
WHERE address = 'Вологодская обл, Великоустюгский район, Подсосенье д, д. 30'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(46.313563, 60.789041), 4326) 
WHERE address = 'Вологодская обл, Великоустюгский район, Энергетик п, д. 1'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.198748, 60.477669), 4326) 
WHERE address = 'Вологодская обл, Вожегодский район, Большая Климовская д, Чкалова ул, д. 1'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.20022, 60.477655), 4326) 
WHERE address = 'Вологодская обл, Вожегодский район, Большая Климовская д, Чкалова ул, д. 3'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.197277, 60.477727), 4326) 
WHERE address = 'Вологодская обл, Вожегодский район, Большая Климовская д, Чкалова ул, д. 5'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.222234, 60.471157), 4326) 
WHERE address = 'Вологодская обл, Вожегодский район, Вожега рп, Свободы ул, д. 13'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.214128, 60.47806), 4326) 
WHERE address = 'Вологодская обл, Вожегодский район, Вожега рп, Транспортная ул, д. 26А'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.21131, 60.479656), 4326) 
WHERE address = 'Вологодская обл, Вожегодский район, Вожега рп, Транспортная ул, д. 37'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(9.830628, 60.474908), 4326) 
WHERE address = 'Вологодская обл, Вожегодский район, Вожегодское с/с, Савинская д, д. 13'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.266692, 60.312835), 4326) 
WHERE address = 'Вологодская обл, Вожегодский район, Кадниковский п, Завокзальная ул, д. 4'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.265701, 60.311966), 4326) 
WHERE address = 'Вологодская обл, Вожегодский район, Кадниковский п, Завокзальная ул, д. 5'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(39.619525, 59.28169), 4326) 
WHERE address = 'Вологодская обл, Вологодский район, Дитятьево д, д. 2'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(39.631403, 59.363736), 4326) 
WHERE address = 'Вологодская обл, Вологодский район, Куркино с, Школьная ул, д. 1'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(39.623994, 59.324784), 4326) 
WHERE address = 'Вологодская обл, Вологодский район, Пестово д, д. 13'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(39.900380, 59.207540), 4326) 
WHERE address = 'Вологодская обл, Вологда г, Герцена ул., д. 70'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(36.45605, 60.997703), 4326) 
WHERE address = 'Вологодская обл, Вытегорский район, Вытегра г, Архангельский тракт, д. 31А'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(39.896363, 59.212935), 4326) 
WHERE address = 'Вологодская обл, Вологда г, Зосимовская ул., д. 40'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.978561, 58.752383), 4326) 
WHERE address = 'Вологодская обл, Грязовецкий район, Сидорово с, Кооперативная ул, д. 23'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.973967, 58.758069), 4326) 
WHERE address = 'Вологодская обл, Грязовецкий район, Сидорово с, Советская ул, д. 25'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.972416, 58.756598), 4326) 
WHERE address = 'Вологодская обл, Грязовецкий район, Сидорово с, Советская ул, д. 32'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(37.150303, 59.197743), 4326) 
WHERE address = 'Вологодская обл, Кадуйский район, Кадуй рп, Курманова ул, д. 2'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(38.382513, 59.86551), 4326) 
WHERE address = 'Вологодская обл, Кирилловский район, Кириллов г, Лелекова ул, д. 28'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(38.380351, 59.872191), 4326) 
WHERE address = 'Вологодская обл, Кирилловский район, Кириллов г, Механизаторов ул, д. 6'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(38.378584, 59.867025), 4326) 
WHERE address = 'Вологодская обл, Кирилловский район, Кириллов г, Октябрьская ул, д. 15А'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.227668, 58.874762), 4326) 
WHERE address = 'Вологодская обл, Грязовецкий район, Грязовец г, Лесной пер, д. 15'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(42.745128, 59.976365), 4326) 
WHERE address = 'Вологодская обл, Тотемский район, Тотьма г, Бабушкина ул, д. 25'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(42.747637, 59.967879), 4326) 
WHERE address = 'Вологодская обл, Тотемский район, Тотьма г, Дорожный пер, д. 4А'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(42.747452, 59.96759), 4326) 
WHERE address = 'Вологодская обл, Тотемский район, Тотьма г, Дорожный пер, д. 6'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(42.777142, 59.977413), 4326) 
WHERE address = 'Вологодская обл, Тотемский район, Тотьма г, Запольная ул, д. 16'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(42.775799, 59.978376), 4326) 
WHERE address = 'Вологодская обл, Тотемский район, Тотьма г, Запольный пер, д. 7'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(42.748813, 59.967705), 4326) 
WHERE address = 'Вологодская обл, Тотемский район, Тотьма г, Заречная ул, д. 10'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(42.751508, 59.977672), 4326) 
WHERE address = 'Вологодская обл, Тотемский район, Тотьма г, Октябрьский пер, д. 7А'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.178102, 59.814401), 4326) 
WHERE address = 'Вологодская обл, Харовский район, Семигородняя ж/д_ст, Спортивная ул, д. 30'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(42.050097, 59.672081), 4326) 
WHERE address = 'Вологодская обл, Тотемский район, Юбилейный п, Молодежная ул, д. 2'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(39.745573, 59.627154), 4326) 
WHERE address = 'Вологодская обл, Усть-Кубинский район, Устье с, Мелиораторов ул, д. 22А'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(36.400719, 58.846674), 4326) 
WHERE address = 'Вологодская обл, Устюженский район, Устюжна г, Зеленый пер, д. 7А'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(36.436206, 58.838702), 4326) 
WHERE address = 'Вологодская обл, Устюженский район, Устюжна г, Луначарского пер, д. 30А'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(36.400875, 58.845639), 4326) 
WHERE address = 'Вологодская обл, Устюженский район, Устюжна г, Зеленый пер, д. 8'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(36.418267, 58.842139), 4326) 
WHERE address = 'Вологодская обл, Устюженский район, Устюжна г, Розы Люксембург ул, д. 8/44'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(45.802243, 59.990156), 4326) 
WHERE address = 'Вологодская обл, Кичменгско-Городецкий район, Кичменгский Городок с, Дошкольная ул, д. 1А'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(45.80996, 59.991784), 4326) 
WHERE address = 'Вологодская обл, Кичменгско-Городецкий район, Кичменгский Городок с, Советская ул, д. 10'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(45.675902, 59.939378), 4326) 
WHERE address = 'Вологодская обл, Кичменгско-Городецкий район, Шонга с, Сосновая ул, д. 7'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(45.460678, 59.54045), 4326) 
WHERE address = 'Вологодская обл, Никольский район, Никольск г, Заводская ул, д. 22'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(45.429009, 59.537787), 4326) 
WHERE address = 'Вологодская обл, Никольский район, Никольск г, Заречная ул, д. 20'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(45.427896, 59.53731), 4326) 
WHERE address = 'Вологодская обл, Никольский район, Никольск г, Заречная ул, д. 24'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(45.458133, 59.531317), 4326) 
WHERE address = 'Вологодская обл, Никольский район, Никольск г, Красная ул, д. 104А'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(41.488495, 59.582614), 4326) 
WHERE address = 'Вологодская обл, Сокольский район, Биряково с, Н.Рубцова ул, д. 4'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(39.951626, 59.602588), 4326) 
WHERE address = 'Вологодская обл, Сокольский район, Василево д, д. 6'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(39.951786, 59.603037), 4326) 
WHERE address = 'Вологодская обл, Сокольский район, Василево д, д. 8'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(41.148551, 59.617573), 4326) 
WHERE address = 'Вологодская обл, Сокольский район, Огарово д, д. 39'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.061425, 59.36237), 4326) 
WHERE address = 'Вологодская обл, Сокольский район, Оларево д, д. 3'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.146866, 59.449647), 4326) 
WHERE address = 'Вологодская обл, Сокольский район, Сокол г, Набережная Сухоны ул, д. 28А'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.129606, 59.44626), 4326) 
WHERE address = 'Вологодская обл, Сокольский район, Сокол г, Нечаевская ул, д. 12'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.089221, 59.453036), 4326) 
WHERE address = 'Вологодская обл, Сокольский район, Сокол г, Сухона ст, д. 38'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.088888, 59.452518), 4326) 
WHERE address = 'Вологодская обл, Сокольский район, Сокол г, Сухона ст, д. 40'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(43.5501, 60.510461), 4326) 
WHERE address = 'Вологодская обл, Тарногский район, Тарногский Городок с, Заводская ул, д. 14'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(37.545992, 59.157918), 4326) 
WHERE address = 'Вологодская обл, Череповецкий район, Суда п, Садовая ул, д. 18'; 

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(37.671842, 59.575738), 4326) 
WHERE address = 'ВВологодская обл, Череповецкий район, Нестеровское д, д. 23';

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(35.22185, 59.094922), 4326) 
WHERE address = 'Вологодская обл, Чагодощенский район, Сазоново рп, Комсомольская ул, д. 1';

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(35.122779, 59.173119), 4326) 
WHERE address = 'Вологодская обл, Чагодощенский район, Первомайский п, Центральная ул, д. 24';

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(35.590156, 59.146863), 4326) 
WHERE address = 'Вологодская обл, Чагодощенский район, Мегрино д, Северная ул, д. 1';

UPDATE resstr_mkd.reformagkh_reestr_mkd
SET geom = ST_SetSRID(ST_MakePoint(40.211563, 59.957545), 4326) 
WHERE address = 'Вологодская обл, Харовский район, Харовск г, Ленинградская ул, д. 45';


-- Убедимся, что после добавления у каждого адреса соответствуют уникальные координаты (исключения: угловые дома и дома с указанием подъездов)

SELECT 
    geom,
    COUNT(*) AS num_houses,
    ARRAY_AGG(address) AS addresses
FROM 
    resstr_mkd.reformagkh_reestr_mkd
GROUP BY 
    geom
HAVING 
    COUNT(*) > 1;














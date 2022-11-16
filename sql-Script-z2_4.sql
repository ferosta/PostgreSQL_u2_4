-- практическая работа блока 2.4 SQL вторая часть 

--1. Чтобы успешно справиться с данным практическим заданием, вам необходимо выполнить как минимум задания 1-4 практики 
--в теме 2.3 "Реляционные базы данных: PostgreSQL", но желательно сделать, конечно же, все.

--все сделано https://github.com/ferosta/PostgreSQL_u2_3.git
-------------------------------------------------
-- 2. Для будущих отчетов аналитики попросили вас создать еще одну таблицу с информацией по отделам 
-- – в таблице должен быть 
-- идентификатор для каждого отдела, 
-- название отдела (например. Бухгалтерский или IT отдел), 
-- ФИО руководителя 
--и количество сотрудников.

CREATE TABLE IF NOT EXISTS Divisions(
	Id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	Title VARCHAR(255),
	Head_Name VARCHAR(255),
	Staff_Count NUMERIC
);

--  1. Создать таблицу с основной информацией о сотрудниках: 
--  ФИО, дата рождения, 
--  дата начала работы, 
--  должность, 
--  уровень сотрудника (jun, middle, senior, lead), 
--  уровень зарплаты, 
--  идентификатор отдела, 
--  наличие/отсутствие прав(True/False). 
--  При этом в таблице обязательно должен быть уникальный номер для каждого сотрудника.

DROP TYPE IF EXISTS Stage_Type ;
CREATE TYPE Stage_Type AS ENUM ('junior', 'middle', 'senior', 'lead');

CREATE TABLE IF NOT EXISTS Workers
(
	Id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	FIO VARCHAR(255) NOT NULL,	
	Begint_Data DATE NOT NULL,
	Post VARCHAR (20) NOT NULL,
	Stage Stage_Type NOT NULL DEFAULT 'junior',
	Salary INT NOT NULL DEFAULT 20000,
	Division_Id INT,
	Drive_License BOOLEAN NOT NULL DEFAULT FALSE,
	CONSTRAINT Division_Fk
		FOREIGN KEY (Division_Id)
		REFERENCES Divisions(Id)
		ON DELETE CASCADE
);


--· 3. На кону конец года и необходимо выплачивать сотрудникам премию. 
--Премия будет выплачиваться по совокупным оценкам, которые сотрудники получают в каждом квартале года. 
--Создайте таблицу, в которой для каждого сотрудника будут его оценки за каждый квартал. 
--Диапазон оценок от A – самая высокая, до E – самая низкая.
DROP TYPE IF EXISTS Rating_Type;
CREATE TYPE Rating_Type AS ENUM ('A', 'B', 'C', 'D', 'E');

CREATE TABLE IF NOT EXISTS Rating(
	Id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	Worker_Id INT,
	Q1 Rating_Type, 
	Q2 Rating_Type, 
	Q3 Rating_Type,
	Q4 Rating_Type,
	CONSTRAINT worker_fk
		FOREIGN KEY (Worker_Id)
		REFERENCES Workers(Id)
		ON DELETE CASCADE
);

--· 4. Несколько уточнений по предыдущим заданиям – в первой таблице должны быть записи как минимум о 5 сотрудниках, 
--которые работают как минимум в 2-х разных отделах. 
--Содержимое соответствующих атрибутов остается на совесть вашей фантазии, но, 
--желательно соблюдать осмысленность и правильно выбирать типы данных (для зарплаты – числовой тип, для ФИО – строковый и т.д.)

INSERT INTO Divisions( 
	Title ,
	Head_Name ,
	Staff_Count 
)
VALUES
('лаб.№21', 'Иван Иванович Иванов', 4),
('лаб.№23', 'Василий Васильевич Васильев', 4),
('лаб.№27', 'Сергей Борисович Звездюлёв', 4);

INSERT INTO Workers (
	FIO,
	Begint_Data,
	Post,
	Stage,
	Salary,
	Division_Id,
	Drive_License
)
VALUES 
	('Иван Иванович Иванов', '2022-02-24', 'м.н.с.', 'junior', 30001, 1, TRUE),
	('Марина Петровна Петрова', '2021-01-01', 'н.с.', 'middle', 40010, 2, FALSE),
	('Василий Васильевич Васильев', '1995-10-20', 'в.н.с.', 'lead', 70010, 3, TRUE),
    ('Михаил Джекович Блэк', '2022-03-04', 'м.н.с.', 'junior', 30010, 1, TRUE),
	('Сергей Борисович Звездюлёв', '2019-12-30', 'г.н.с.', 'lead', 40001, 2, TRUE),
	('Марьяна Ибрагимовна Минскер', '2020-06-15', 'в.н.с.', 'middle', 70001, 3, TRUE),
	('Семен Семенович Семенченко', '2018-01-05', 'н.с.', 'middle', 35001, 1, TRUE),
	('Дмитрий Анатольевич Медвечук', '2017-06-21', 'в.н.с.', 'lead', 45010, 2, TRUE),
	('Григорий Григорьевич Гюго', '2001-04-21', 'инженер', 'senior', 75010, 3, TRUE),
    ('Ева Евгеньевна Еланская', '2008-08-08', 'секретарь', 'junior', 33010, 1, TRUE),
	('Анжелика Николаевна Шац', '2016-11-15', 'лаборант', 'middle', 46001, 2, FALSE),
	('Софья Святославовна Трампидзе', '2001-07-30', 'ассистент', 'junior', 29001, 3, TRUE);


INSERT INTO Rating(
	Worker_Id ,
	Q1 , 
	Q2 , 
	Q3 ,
	Q4 
)
VALUES
(1,'A','B','C','D'),
(2,'B','C','D','E'),
(3,'B','D','A','E'),
(4,'A','E','D','C'),
(5,'A','D','B','E'),
(6,'B','C','C','D'),
(7,'A','B','C','D'),
(8,'B','C','D','E'),
(9,'C','D','E','A'),
(10,'D','E','A','B'),
(11,'E','A','B','C'),
(12,'A','A','E','B');
--------------------------------------------------
--------------------------------------------------



--2. Теперь мы знакомы с гораздо большим перечнем операторов языка SQL и это дает нам дополнительные возможности для анализа данных. 
--Выполните следующие запросы:
--a.     Попробуйте вывести не просто самую высокую зарплату во всей команде, 
--а вывести именно фамилию сотрудника с самой высокой зарплатой.

SELECT FIO as "Сотрудник с самой высокой З/п", Salary as "З/п" 
FROM Workers w 
WHERE w.salary = (SELECT max(salary) FROM Workers);

--b. Попробуйте вывести фамилии сотрудников в алфавитном порядке
SELECT FIO as "Сотрудник"
FROM Workers w 
ORDER BY FIO;

--c. Рассчитайте средний стаж для каждого уровня сотрудников
SELECT Stage as "Уровень"
		,AVG ( 0.1*round(10* (current_date - Begint_Data)/365.0 ) ) as "Стаж, лет"
--		,AVG(*) as "Средний стаж, лет"
FROM Workers
GROUP BY Stage; 


--d. Выведите фамилию сотрудника и название отдела, в котором он работает
SELECT FIO as "Сотрудник", d.title as "Отдел"
FROM workers w, divisions d  
WHERE w.division_id = d.id ;


--e. Выведите название отдела и фамилию сотрудника с самой высокой зарплатой в данном отделе и саму зарплату также.
SELECT s.Title as "Отдел" , FIO as "Сотрудник c самой высокоф З/п", s.avgzpt as "З/п" 
FROM Workers w,
			(SELECT d.id, d.Title, max(w.Salary) as avgzpt
			FROM Workers w, divisions d 
			WHERE w.division_id = d.id
			GROUP BY d.id, d.Title) as s
WHERE w.Division_id=s.Id AND w.Salary = s.avgzpt  
ORDER BY w.division_id;  


--f. *Выведите название отдела, сотрудники которого получат наибольшую премию по итогам года. 
--Как рассчитать премию можно узнать в последнем задании предыдущей домашней работы

---- расчет бонусного коэффициента
--SELECT *  
--		,0.1*(-ASCII(CAST(r.Q1 AS char(1)))+67)
--		,0.1*(-ASCII(CAST(r.Q2 AS char(1)))+67)
--		,0.1*(-ASCII(CAST(r.Q3 AS char(1)))+67)
--		,0.1*(-ASCII(CAST(r.Q4 AS char(1)))+67)
--		,0.1*(-ASCII(CAST(r.Q1 AS char(1)))+67)
--		+0.1*(-ASCII(CAST(r.Q2 AS char(1)))+67)
--		+0.1*(-ASCII(CAST(r.Q3 AS char(1)))+67)
--		+0.1*(-ASCII(CAST(r.Q4 AS char(1)))+67) + 1  AS "Коэффициент"
--FROM Rating r;

-- таблица с фамилиями и премиями
--SELECT division_id, FIO as "Сотрудник"
--		, Salary as "З/п"
--		, rk.koef as "Бонусный коэффициент"
--		, Salary * (rk.koef-1) as "Премия"
--		, Salary * rk.koef as "З/п с премией"
--FROM Workers w 
--		,(SELECT Id  
--			,0.1*(-ASCII(CAST(r.Q1 AS char(1)))+67)
--			+0.1*(-ASCII(CAST(r.Q2 AS char(1)))+67)
--			+0.1*(-ASCII(CAST(r.Q3 AS char(1)))+67)
--			+0.1*(-ASCII(CAST(r.Q4 AS char(1)))+67) + 1  AS koef
--		FROM Rating r) as rk 
--WHERE w.Id = rk.Id  
--ORDER BY division_id;


-- решение: отдел с сотрудниками с максимальным бонусом
SELECT Divisions.Title as "Отдел с наибольшей преимей"--"Отдел"
	   --, "Суммарная премия" 
FROM 
	(SELECT  Division_id 
			, sum( Salary * (rk.koef-1) ) as "Суммарная премия"
	 FROM Workers w  
			,(SELECT Id  
				,0.1*(-ASCII(CAST(r.Q1 AS char(1)))+67)
				+0.1*(-ASCII(CAST(r.Q2 AS char(1)))+67)
				+0.1*(-ASCII(CAST(r.Q3 AS char(1)))+67)
				+0.1*(-ASCII(CAST(r.Q4 AS char(1)))+67) + 1  AS koef
			  FROM Rating r) as rk 
	 WHERE w.Id = rk.Id  
	 GROUP BY division_id) as wks  
LEFT JOIN Divisions
ON wks.Division_id = Divisions.Id 
ORDER BY "Суммарная премия" DESC
LIMIT 1;


--g. *Проиндексируйте зарплаты сотрудников с учетом коэффициента премии. 
--Для сотрудников с коэффициентом премии больше 1.2 – размер индексации составит 20%, 
--для сотрудников с коэффициентом премии от 1 до 1.2 размер индексации составит 10%. 
--Для всех остальных сотрудников индексация не предусмотрена.

-- таблица с фамилиями и премиями
SELECT division_id, FIO as "Сотрудник"
		, Salary as "З/п"
		, rk.koef as "Бонусный коэфф."
		, CASE 
			 WHEN rk.koef > 1.2 THEN Salary*1.2
			 WHEN rk.koef <= 1.2 AND rk.koef >= 1.0 THEN Salary*1.1
			 ELSE Salary*1.0
 		  END as "З/п с индексацией"
FROM Workers w 
	,(SELECT Id  -- вычисляем бонусный коэффициент
		,0.1*(-ASCII(CAST(r.Q1 AS char(1)))+67)
		+0.1*(-ASCII(CAST(r.Q2 AS char(1)))+67)
		+0.1*(-ASCII(CAST(r.Q3 AS char(1)))+67)
		+0.1*(-ASCII(CAST(r.Q4 AS char(1)))+67) + 1  AS koef
	  FROM Rating r) 
	 as rk 
WHERE w.Id = rk.Id  
ORDER BY division_id;


-- вариант с фомрированием новой таблицы
DROP TABLE IF EXISTS Workers_Bonused;
SELECT 	 w.Id, FIO ,Begint_Data ,Post	,Stage
		,CASE 
			 WHEN rk.koef > 1.2 THEN Salary*1.2
			 WHEN rk.koef <= 1.2 AND rk.koef >= 1.0 THEN Salary*1.1
			 ELSE Salary*1.0
		 END as "salary"
		,Division_Id ,Drive_License 
INTO Workers_Bonused -- чудесная опция для формирования новой таблицы с результатами этого запроса	
FROM Workers w 
	,(SELECT Id  -- вычисляем бонусный коэффициент нестандартным способом
		,0.1*(-ASCII(CAST(r.Q1 AS char(1)))+67)
		+0.1*(-ASCII(CAST(r.Q2 AS char(1)))+67)
		+0.1*(-ASCII(CAST(r.Q3 AS char(1)))+67)
		+0.1*(-ASCII(CAST(r.Q4 AS char(1)))+67) + 1  AS koef
	  FROM Rating r) 
	 as rk 
WHERE w.Id = rk.Id  
ORDER BY division_id;


--h. ***По итогам индексации отдел финансов хочет получить следующий отчет: 
--вам необходимо на уровень каждого отдела вывести следующую информацию:
--i. Название отдела
--ii. Фамилию руководителя
--iii. Количество сотрудников
--iv. Средний стаж
--v. Средний уровень зарплаты
SELECT Title as "Отдел"
	, d.head_name as "Руководитель Отдела"
	, d.staff_count as "Количество сотрудников"
	, w_exp as "Средний стаж в отделе, лет"
	, w_zp as "Средняя З/п в отделе" 
FROM
	(SELECT division_id --получаем средние значения по зарплате и по стажу 
			,AVG ( 0.1*round(10* (current_date - Begint_Data)/365.0 ) ) as w_exp
			,AVG ( salary ) as w_zp 
	 FROM Workers
	 GROUP BY division_id
	) as zp_avg
LEFT JOIN divisions d 
ON d.id = zp_avg.division_id ;

--vi. Количество сотрудников уровня junior
--vii. Количество сотрудников уровня middle
--viii. Количество сотрудников уровня senior
--ix. Количество сотрудников уровня lead
SELECT Title as "Отдел", wstg.Stage as "Уровень", wstg.Stage_Count as "Количество сотрудников" 
FROM  
	(	SELECT division_id
			, Stage 
			, COUNT(Stage) as Stage_Count 
		FROM Workers
		GROUP BY division_id, stage 
		ORDER BY division_id , stage
	) AS wstg
LEFT JOIN divisions d 
ON d.Id = wstg.division_id;
	
-- а теперь тоже самое, но транспонировать и записать по столбцам уровни в лаборатории
SELECT d.id, d.Title
		, z_j.Stage_Count as "juniors"
		, z_m.Stage_Count as "middles" 
		, z_s.Stage_Count as "seniors" 
		, z_l.Stage_Count as "leads" 
FROM divisions d
LEFT JOIN (SELECT division_id, Stage , COUNT(Stage) as Stage_Count FROM Workers GROUP BY division_id, stage HAVING Stage='junior') as z_j
ON d.Id = z_j.division_id
LEFT JOIN (SELECT division_id, Stage , COUNT(Stage) as Stage_Count FROM Workers GROUP BY division_id, stage HAVING Stage='middle') as z_m 
ON d.Id = z_m.division_id
LEFT JOIN (SELECT division_id, Stage , COUNT(Stage) as Stage_Count FROM Workers GROUP BY division_id, stage HAVING Stage='senior') as z_s 
ON d.Id = z_s.division_id
LEFT JOIN (SELECT division_id, Stage , COUNT(Stage) as Stage_Count FROM Workers GROUP BY division_id, stage HAVING Stage='lead') as z_l 
ON d.Id = z_l.division_id;

-- объединяем с полученной ранее информацией об отделе => решение задачи до ix
SELECT Title as "Отдел"
	, d.head_name as "Руководитель Отдела"
	, d.staff_count as "Штат, чел"
	, w_exp as "Средний стаж, лет"
	, w_zp as "Средняя З/п" 
	, jmsl.juniors 
	, jmsl.middls 
	, jmsl.seniors 
	, jmsl.leads
FROM
	(SELECT division_id --получаем средние значения по зарплате и по стажу 
			,AVG ( 0.1*round(10* (current_date - Begint_Data)/365.0 ) ) as w_exp
			,AVG ( salary ) as w_zp 
	 FROM Workers
	 GROUP BY division_id
	) as zp_avg
LEFT JOIN divisions d 
ON d.id = zp_avg.division_id 
LEFT JOIN  
		(SELECT d.id  -- количество сотрудников по уровням: транспонируем группировку
				, z_j.Stage_Count as "juniors"
				, z_m.Stage_Count as "middls" 
				, z_s.Stage_Count as "seniors" 
				, z_l.Stage_Count as "leads" 
		FROM divisions d
		LEFT JOIN (SELECT division_id, Stage , COUNT(Stage) as Stage_Count FROM Workers GROUP BY division_id, stage HAVING Stage='junior') as z_j
		ON d.Id = z_j.division_id
		LEFT JOIN (SELECT division_id, Stage , COUNT(Stage) as Stage_Count FROM Workers GROUP BY division_id, stage HAVING Stage='middle') as z_m 
		ON d.Id = z_m.division_id
		LEFT JOIN (SELECT division_id, Stage , COUNT(Stage) as Stage_Count FROM Workers GROUP BY division_id, stage HAVING Stage='senior') as z_s 
		ON d.Id = z_s.division_id
		LEFT JOIN (SELECT division_id, Stage , COUNT(Stage) as Stage_Count FROM Workers GROUP BY division_id, stage HAVING Stage='lead') as z_l 
		ON d.Id = z_l.division_id
		) as jmsl
ON d.Id = jmsl.Id;



--x. Общий размер оплаты труда всех сотрудников до индексации
--xi. Общий размер оплаты труда всех сотрудников после индексации

-- простая группировка (эх, надо было по уровням не фасовать - проще бы получилось)
SELECT wfzp.division_id, wfzp.stage, wfzp.salary_sum as Salary, wb_wfzp.salary_sum as Salay_Indexed
FROM
   (SELECT division_id, stage, sum(salary) as Salary_Sum FROM workers w  GROUP BY division_id, stage ) AS wfzp
LEFT JOIN
   (SELECT division_id, stage, sum(salary) as Salary_Sum  FROM Workers_Bonused wb  GROUP BY division_id, stage ) AS wb_wfzp
ON wfzp.division_id = wb_wfzp.division_id AND wfzp.stage = wb_wfzp.stage;


-- группировка в строчку
SELECT d.id, z_j.Stage -- исходная суммарная зарплата сотрудников по уровням: транспонируем группировку
		, z_j.Salary_Sum as "З/п juniors"
		, z_m.Salary_Sum as "З/п middls" 
		, z_s.Salary_Sum as "З/п seniors" 
		, z_l.Salary_Sum as "З/п leads" 
		, zb_j.Salary_Sum as "Индкс.З/п juniors"
		, zb_m.Salary_Sum as "Индкс.З/п middls" 
		, zb_s.Salary_Sum as "Индкс.З/п seniors" 
		, zb_l.Salary_Sum as "Индкс.З/п leads" 
FROM  divisions d    
LEFT JOIN (SELECT division_id, stage, sum(salary) as Salary_Sum FROM workers w  GROUP BY division_id, stage  HAVING Stage='junior') as z_j
ON d.id = z_j.division_id 
LEFT JOIN (SELECT division_id, stage, sum(salary) as Salary_Sum FROM workers w  GROUP BY division_id, stage  HAVING Stage='middle') as z_m 
ON d.id = z_m.division_id 
LEFT JOIN (SELECT division_id, stage, sum(salary) as Salary_Sum FROM workers w  GROUP BY division_id, stage  HAVING Stage='senior') as z_s 
ON d.id = z_s.division_id 
LEFT JOIN (SELECT division_id, stage, sum(salary) as Salary_Sum FROM workers w  GROUP BY division_id, stage  HAVING Stage='lead') as z_l 
ON d.id = z_l.division_id 
LEFT JOIN (SELECT division_id, stage, sum(salary) as Salary_Sum FROM Workers_Bonused wb  GROUP BY division_id, stage  HAVING Stage='junior') as zb_j
ON d.Id = zb_j.division_id
LEFT JOIN (SELECT division_id, stage, sum(salary) as Salary_Sum FROM Workers_Bonused wb  GROUP BY division_id, stage  HAVING Stage='middle') as zb_m 
ON d.Id = zb_m.division_id
LEFT JOIN (SELECT division_id, stage, sum(salary) as Salary_Sum FROM Workers_Bonused wb  GROUP BY division_id, stage  HAVING Stage='senior') as zb_s 
ON d.Id = zb_s.division_id
LEFT JOIN (SELECT division_id, stage, sum(salary) as Salary_Sum FROM Workers_Bonused wb  GROUP BY division_id, stage  HAVING Stage='lead') as zb_l 
ON d.Id = zb_l.division_id;
		


-- объединяем с полученной ранее информацией об отделе => решение задачи до x
SELECT Title as "Отдел"
	, d.head_name as "Руководитель Отдела"
	, d.staff_count as "Штат, чел"
	, w_exp as "Средний стаж, лет"
	, w_zp as "Средняя З/п" 
	, jmsl.juniors 
	, jmsl.middls 
	, jmsl.seniors 
	, jmsl.leads
	, zpt."З/п juniors"
	, zpt."З/п middls" 
	, zpt."З/п seniors" 
	, zpt."З/п leads" 
	, zpt."Индкс.З/п juniors"
	, zpt."Индкс.З/п middls" 
	, zpt."Индкс.З/п seniors" 
	, zpt."Индкс.З/п leads"
FROM
	(SELECT division_id --получаем средние значения по зарплате и по стажу 
			,AVG ( 0.1*round(10* (current_date - Begint_Data)/365.0 ) ) as w_exp
			,AVG ( salary ) as w_zp 
	 FROM Workers
	 GROUP BY division_id
	) as zp_avg
LEFT JOIN divisions d 
ON d.id = zp_avg.division_id 
LEFT JOIN  
		(SELECT d.id  -- количество сотрудников по уровням: транспонируем группировку
				, z_j.Stage_Count as "juniors"
				, z_m.Stage_Count as "middls" 
				, z_s.Stage_Count as "seniors" 
				, z_l.Stage_Count as "leads" 
		FROM divisions d
		LEFT JOIN (SELECT division_id, Stage , COUNT(Stage) as Stage_Count FROM Workers GROUP BY division_id, stage HAVING Stage='junior') as z_j
		ON d.Id = z_j.division_id
		LEFT JOIN (SELECT division_id, Stage , COUNT(Stage) as Stage_Count FROM Workers GROUP BY division_id, stage HAVING Stage='middle') as z_m 
		ON d.Id = z_m.division_id
		LEFT JOIN (SELECT division_id, Stage , COUNT(Stage) as Stage_Count FROM Workers GROUP BY division_id, stage HAVING Stage='senior') as z_s 
		ON d.Id = z_s.division_id
		LEFT JOIN (SELECT division_id, Stage , COUNT(Stage) as Stage_Count FROM Workers GROUP BY division_id, stage HAVING Stage='lead') as z_l 
		ON d.Id = z_l.division_id
		) as jmsl
ON d.Id = jmsl.Id
LEFT JOIN
		(SELECT d.id, z_j.Stage -- исходная и индексированная суммарная зарплата сотрудников по уровням: транспонируем группировку
				, z_j.Salary_Sum as "З/п juniors"
				, z_m.Salary_Sum as "З/п middls" 
				, z_s.Salary_Sum as "З/п seniors" 
				, z_l.Salary_Sum as "З/п leads" 
				, zb_j.Salary_Sum as "Индкс.З/п juniors"
				, zb_m.Salary_Sum as "Индкс.З/п middls" 
				, zb_s.Salary_Sum as "Индкс.З/п seniors" 
				, zb_l.Salary_Sum as "Индкс.З/п leads" 
		FROM  divisions d    
		LEFT JOIN (SELECT division_id, stage, sum(salary) as Salary_Sum FROM workers w  GROUP BY division_id, stage  HAVING Stage='junior') as z_j
		ON d.id = z_j.division_id 
		LEFT JOIN (SELECT division_id, stage, sum(salary) as Salary_Sum FROM workers w  GROUP BY division_id, stage  HAVING Stage='middle') as z_m 
		ON d.id = z_m.division_id 
		LEFT JOIN (SELECT division_id, stage, sum(salary) as Salary_Sum FROM workers w  GROUP BY division_id, stage  HAVING Stage='senior') as z_s 
		ON d.id = z_s.division_id 
		LEFT JOIN (SELECT division_id, stage, sum(salary) as Salary_Sum FROM workers w  GROUP BY division_id, stage  HAVING Stage='lead') as z_l 
		ON d.id = z_l.division_id 
		LEFT JOIN (SELECT division_id, stage, sum(salary) as Salary_Sum FROM Workers_Bonused wb  GROUP BY division_id, stage  HAVING Stage='junior') as zb_j
		ON d.Id = zb_j.division_id
		LEFT JOIN (SELECT division_id, stage, sum(salary) as Salary_Sum FROM Workers_Bonused wb  GROUP BY division_id, stage  HAVING Stage='middle') as zb_m 
		ON d.Id = zb_m.division_id
		LEFT JOIN (SELECT division_id, stage, sum(salary) as Salary_Sum FROM Workers_Bonused wb  GROUP BY division_id, stage  HAVING Stage='senior') as zb_s 
		ON d.Id = zb_s.division_id
		LEFT JOIN (SELECT division_id, stage, sum(salary) as Salary_Sum FROM Workers_Bonused wb  GROUP BY division_id, stage  HAVING Stage='lead') as zb_l 
		ON d.Id = zb_l.division_id) AS zpt
ON d.Id = zpt.Id;


--xii. Общее количество оценок А
--xiii. Общее количество оценок B
--xiv. Общее количество оценок C
--xv. Общее количество оценок D
--xvi. Общее количество оценок Е

-- для контроля выводим таблицу с оценками
SELECT w.division_id , r.* FROM rating r, workers w WHERE w.id = r.worker_id
order by w.division_id;

WITH 
  Divisioned_Rating AS (SELECT w.division_id , r.* FROM rating r, workers w WHERE w.id = r.worker_id) -- приписываем к рейтингам номер отдела
, Z_Q1 AS (SELECT division_id, q1, count(*) AS c_q FROM Divisioned_Rating GROUP BY division_id, q1) -- группировка по q1
, Z_Q2 AS (SELECT division_id, q2, count(*) AS c_q FROM Divisioned_Rating GROUP BY division_id, q2) -- группировка по q2
, Z_Q3 AS (SELECT division_id, q3, count(*) AS c_q FROM Divisioned_Rating GROUP BY division_id, q3) -- группировка по q3
, Z_Q4 AS (SELECT division_id, q4, count(*) AS c_q FROM Divisioned_Rating GROUP BY division_id, q4) -- группировка по q4
SELECT d.id 
		, COALESCE(qq1_a.c_q,0)+COALESCE(qq2_a.c_q,0)+COALESCE(qq3_a.c_q,0)+COALESCE(qq4_a.c_q,0) AS "Оценок 'A'"
		, COALESCE(qq1_b.c_q,0)+COALESCE(qq2_b.c_q,0)+COALESCE(qq3_b.c_q,0)+COALESCE(qq4_b.c_q,0) AS "Оценок 'B'"
		, COALESCE(qq1_c.c_q,0)+COALESCE(qq2_c.c_q,0)+COALESCE(qq3_c.c_q,0)+COALESCE(qq4_c.c_q,0) AS "Оценок 'C'"
		, COALESCE(qq1_d.c_q,0)+COALESCE(qq2_d.c_q,0)+COALESCE(qq3_d.c_q,0)+COALESCE(qq4_d.c_q,0) AS "Оценок 'D'"
		, COALESCE(qq1_e.c_q,0)+COALESCE(qq2_e.c_q,0)+COALESCE(qq3_e.c_q,0)+COALESCE(qq4_e.c_q,0) AS "Оценок 'E'"
FROM Divisions d 
LEFT JOIN (SELECT * FROM Z_Q1 WHERE q1 = 'A') as qq1_a ON id = qq1_a.division_id
LEFT JOIN (SELECT * FROM Z_Q1 WHERE q1 = 'B') as qq1_b ON id = qq1_b.division_id
LEFT JOIN (SELECT * FROM Z_Q1 WHERE q1 = 'C') as qq1_c ON id = qq1_c.division_id
LEFT JOIN (SELECT * FROM Z_Q1 WHERE q1 = 'D') as qq1_d ON id = qq1_d.division_id
LEFT JOIN (SELECT * FROM Z_Q1 WHERE q1 = 'E') as qq1_e ON id = qq1_e.division_id
LEFT JOIN (SELECT * FROM Z_Q2 WHERE q2 = 'A') as qq2_a ON id = qq2_a.division_id
LEFT JOIN (SELECT * FROM Z_Q2 WHERE q2 = 'B') as qq2_b ON id = qq2_b.division_id
LEFT JOIN (SELECT * FROM Z_Q2 WHERE q2 = 'C') as qq2_c ON id = qq2_c.division_id
LEFT JOIN (SELECT * FROM Z_Q2 WHERE q2 = 'D') as qq2_d ON id = qq2_d.division_id
LEFT JOIN (SELECT * FROM Z_Q2 WHERE q2 = 'E') as qq2_e ON id = qq2_e.division_id
LEFT JOIN (SELECT * FROM Z_Q3 WHERE q3 = 'A') as qq3_a ON id = qq3_a.division_id
LEFT JOIN (SELECT * FROM Z_Q3 WHERE q3 = 'B') as qq3_b ON id = qq3_b.division_id
LEFT JOIN (SELECT * FROM Z_Q3 WHERE q3 = 'C') as qq3_c ON id = qq3_c.division_id
LEFT JOIN (SELECT * FROM Z_Q3 WHERE q3 = 'D') as qq3_d ON id = qq3_d.division_id
LEFT JOIN (SELECT * FROM Z_Q3 WHERE q3 = 'E') as qq3_e ON id = qq3_e.division_id
LEFT JOIN (SELECT * FROM Z_Q4 WHERE q4 = 'A') as qq4_a ON id = qq4_a.division_id
LEFT JOIN (SELECT * FROM Z_Q4 WHERE q4 = 'B') as qq4_b ON id = qq4_b.division_id
LEFT JOIN (SELECT * FROM Z_Q4 WHERE q4 = 'C') as qq4_c ON id = qq4_c.division_id
LEFT JOIN (SELECT * FROM Z_Q4 WHERE q4 = 'D') as qq4_d ON id = qq4_d.division_id
LEFT JOIN (SELECT * FROM Z_Q4 WHERE q4 = 'E') as qq4_e ON id = qq4_e.division_id
ORDER BY d.id;




-- объединяем с полученной ранее информацией об отделе => решение задачи до xvi
--- плюс оптимизация с использованием подзапросов
--- минус расфасовка суммарных зарплат по уровням (вроде такой задачи не стояло, а как-то само собой получилось)

WITH 
Div_Stg_Cnt AS (SELECT division_id, Stage , COUNT(Stage) as Stage_Count FROM Workers GROUP BY division_id, stage) -- количество работников каждого уровня
, Div_Stg_Sum_Slr_0 AS (SELECT division_id, sum(salary) as Salary_Sum FROM workers w  GROUP BY division_id) -- суммарные зарплаты до индексации
, Div_Stg_Sum_Slr_Wb_0 AS (SELECT division_id, sum(salary) as Salary_Sum FROM Workers_Bonused wb  GROUP BY division_id) -- суммарные з/п после индексации
, Div_Stg_Sum_Slr AS (SELECT division_id, stage, sum(salary) as Salary_Sum FROM workers w  GROUP BY division_id, stage) -- суммарные з/п по уровням
, Div_Stg_Sum_Slr_Wb AS (SELECT division_id, stage, sum(salary) as Salary_Sum FROM Workers_Bonused wb  GROUP BY division_id, stage) -- сумм з\п по уровням с индексацией
, Divisioned_Rating AS (SELECT w.division_id , r.* FROM rating r, workers w WHERE w.id = r.worker_id) -- приписываем к рейтингам номер отдела
, Z_Q1 AS (SELECT division_id, q1, count(*) AS c_q FROM Divisioned_Rating GROUP BY division_id, q1) -- группировка по q1
, Z_Q2 AS (SELECT division_id, q2, count(*) AS c_q FROM Divisioned_Rating GROUP BY division_id, q2) -- группировка по q2
, Z_Q3 AS (SELECT division_id, q3, count(*) AS c_q FROM Divisioned_Rating GROUP BY division_id, q3) -- группировка по q3
, Z_Q4 AS (SELECT division_id, q4, count(*) AS c_q FROM Divisioned_Rating GROUP BY division_id, q4) -- группировка по q4
SELECT Title as "Отдел"
	, d.head_name as "Руководитель Отдела"
	, d.staff_count as "Штат, чел"
	, w_exp as "Средний стаж, лет"
	, w_zp as "Средняя З/п" 
	, jmsl.juniors 
	, jmsl.middls 
	, jmsl.seniors 
	, jmsl.leads
	, zpt."З/п сумма"
	, zpt."Индкс.З/п сумма"
--	, zpt."З/п juniors"
--	, zpt."З/п middls" 
--	, zpt."З/п seniors" 
--	, zpt."З/п leads" 
--	, zpt."Индкс.З/п juniors"
--	, zpt."Индкс.З/п middls" 
--	, zpt."Индкс.З/п seniors" 
--	, zpt."Индкс.З/п leads"
	, zq."Оценок 'A'"
	, zq."Оценок 'B'"
	, zq."Оценок 'C'"
	, zq."Оценок 'D'"
	, zq."Оценок 'E'"
FROM
	(SELECT division_id --получаем средние значения по зарплате и по стажу 
			,AVG ( 0.1*round(10* (current_date - Begint_Data)/365.0 ) ) as w_exp
			,AVG ( salary ) as w_zp 
	 FROM Workers
	 GROUP BY division_id
	) as zp_avg
LEFT JOIN divisions d 
ON d.id = zp_avg.division_id 
LEFT JOIN  
		(SELECT d.id  -- количество сотрудников по уровням: транспонируем группировку
				, z_j.Stage_Count as "juniors"
				, z_m.Stage_Count as "middls" 
				, z_s.Stage_Count as "seniors" 
				, z_l.Stage_Count as "leads" 
		FROM divisions d
		LEFT JOIN (SELECT * FROM Div_Stg_Cnt WHERE Stage='junior') as z_j ON d.Id = z_j.division_id
		LEFT JOIN (SELECT * FROM Div_Stg_Cnt WHERE Stage='middle') as z_m ON d.Id = z_m.division_id
		LEFT JOIN (SELECT * FROM Div_Stg_Cnt WHERE Stage='senior') as z_s ON d.Id = z_s.division_id
		LEFT JOIN (SELECT * FROM Div_Stg_Cnt WHERE Stage='lead')   as z_l ON d.Id = z_l.division_id
		) as jmsl
ON d.Id = jmsl.Id
LEFT JOIN
		(SELECT d.id -- исходная и индексированная суммарная зарплата сотрудников по уровням: транспонируем группировку
				, z_all.Salary_Sum as "З/п сумма"
				, zb_all.Salary_Sum as "Индкс.З/п сумма"
--				, z_j.Stage
--				, z_j.Salary_Sum as "З/п juniors"
--				, z_m.Salary_Sum as "З/п middls" 
--				, z_s.Salary_Sum as "З/п seniors" 
--				, z_l.Salary_Sum as "З/п leads" 
--				, zb_j.Salary_Sum as "Индкс.З/п juniors"
--				, zb_m.Salary_Sum as "Индкс.З/п middls" 
--				, zb_s.Salary_Sum as "Индкс.З/п seniors" 
--				, zb_l.Salary_Sum as "Индкс.З/п leads" 
		FROM  divisions d    
		LEFT JOIN (SELECT * FROM Div_Stg_Sum_Slr_0 ) as z_all 	ON d.id = z_all.division_id  --суммарная зарплата до индексирования
		LEFT JOIN (SELECT * FROM Div_Stg_Sum_Slr_Wb_0 ) as zb_all 	ON d.id = zb_all.division_id  --суммарная зарплата после индекасирования
--		LEFT JOIN (SELECT * FROM Div_Stg_Sum_Slr WHERE Stage='junior') as z_j 	ON d.id = z_j.division_id -- расфасовка суммарных зарплат по уровням
--		LEFT JOIN (SELECT * FROM Div_Stg_Sum_Slr WHERE Stage='middle') as z_m 	ON d.id = z_m.division_id 
--		LEFT JOIN (SELECT * FROM Div_Stg_Sum_Slr WHERE Stage='senior') as z_s 	ON d.id = z_s.division_id 
--		LEFT JOIN (SELECT * FROM Div_Stg_Sum_Slr WHERE Stage='lead')   as z_l 	ON d.id = z_l.division_id 
--		LEFT JOIN (SELECT * FROM Div_Stg_Sum_Slr_Wb WHERE Stage='junior') as zb_j	ON d.Id = zb_j.division_id
--		LEFT JOIN (SELECT * FROM Div_Stg_Sum_Slr_Wb WHERE Stage='middle') as zb_m 	ON d.Id = zb_m.division_id
--		LEFT JOIN (SELECT * FROM Div_Stg_Sum_Slr_Wb WHERE Stage='senior') as zb_s 	ON d.Id = zb_s.division_id
--		LEFT JOIN (SELECT * FROM Div_Stg_Sum_Slr_Wb WHERE Stage='lead')   as zb_l 	ON d.Id = zb_l.division_id
		) AS zpt
ON d.Id = zpt.Id
LEFT JOIN -- количество оценок
		(SELECT d.id 
				, COALESCE(qq1_a.c_q,0)+COALESCE(qq2_a.c_q,0)+COALESCE(qq3_a.c_q,0)+COALESCE(qq4_a.c_q,0) AS "Оценок 'A'"
				, COALESCE(qq1_b.c_q,0)+COALESCE(qq2_b.c_q,0)+COALESCE(qq3_b.c_q,0)+COALESCE(qq4_b.c_q,0) AS "Оценок 'B'"
				, COALESCE(qq1_c.c_q,0)+COALESCE(qq2_c.c_q,0)+COALESCE(qq3_c.c_q,0)+COALESCE(qq4_c.c_q,0) AS "Оценок 'C'"
				, COALESCE(qq1_d.c_q,0)+COALESCE(qq2_d.c_q,0)+COALESCE(qq3_d.c_q,0)+COALESCE(qq4_d.c_q,0) AS "Оценок 'D'"
				, COALESCE(qq1_e.c_q,0)+COALESCE(qq2_e.c_q,0)+COALESCE(qq3_e.c_q,0)+COALESCE(qq4_e.c_q,0) AS "Оценок 'E'"
		FROM Divisions d 
		LEFT JOIN (SELECT * FROM Z_Q1 WHERE q1 = 'A') as qq1_a ON id = qq1_a.division_id
		LEFT JOIN (SELECT * FROM Z_Q1 WHERE q1 = 'B') as qq1_b ON id = qq1_b.division_id
		LEFT JOIN (SELECT * FROM Z_Q1 WHERE q1 = 'C') as qq1_c ON id = qq1_c.division_id
		LEFT JOIN (SELECT * FROM Z_Q1 WHERE q1 = 'D') as qq1_d ON id = qq1_d.division_id
		LEFT JOIN (SELECT * FROM Z_Q1 WHERE q1 = 'E') as qq1_e ON id = qq1_e.division_id
		LEFT JOIN (SELECT * FROM Z_Q2 WHERE q2 = 'A') as qq2_a ON id = qq2_a.division_id
		LEFT JOIN (SELECT * FROM Z_Q2 WHERE q2 = 'B') as qq2_b ON id = qq2_b.division_id
		LEFT JOIN (SELECT * FROM Z_Q2 WHERE q2 = 'C') as qq2_c ON id = qq2_c.division_id
		LEFT JOIN (SELECT * FROM Z_Q2 WHERE q2 = 'D') as qq2_d ON id = qq2_d.division_id
		LEFT JOIN (SELECT * FROM Z_Q2 WHERE q2 = 'E') as qq2_e ON id = qq2_e.division_id
		LEFT JOIN (SELECT * FROM Z_Q3 WHERE q3 = 'A') as qq3_a ON id = qq3_a.division_id
		LEFT JOIN (SELECT * FROM Z_Q3 WHERE q3 = 'B') as qq3_b ON id = qq3_b.division_id
		LEFT JOIN (SELECT * FROM Z_Q3 WHERE q3 = 'C') as qq3_c ON id = qq3_c.division_id
		LEFT JOIN (SELECT * FROM Z_Q3 WHERE q3 = 'D') as qq3_d ON id = qq3_d.division_id
		LEFT JOIN (SELECT * FROM Z_Q3 WHERE q3 = 'E') as qq3_e ON id = qq3_e.division_id
		LEFT JOIN (SELECT * FROM Z_Q4 WHERE q4 = 'A') as qq4_a ON id = qq4_a.division_id
		LEFT JOIN (SELECT * FROM Z_Q4 WHERE q4 = 'B') as qq4_b ON id = qq4_b.division_id
		LEFT JOIN (SELECT * FROM Z_Q4 WHERE q4 = 'C') as qq4_c ON id = qq4_c.division_id
		LEFT JOIN (SELECT * FROM Z_Q4 WHERE q4 = 'D') as qq4_d ON id = qq4_d.division_id
		LEFT JOIN (SELECT * FROM Z_Q4 WHERE q4 = 'E') as qq4_e ON id = qq4_e.division_id
		) AS zq
ON d.Id = zq.Id;
























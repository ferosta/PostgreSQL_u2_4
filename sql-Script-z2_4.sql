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

DROP TYPE IF EXISTS Stage_Type;
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
('лаб.№21', 'Иван Иванович Иванов', 2),
('лаб.№23', 'Василий Васильевич Васильев', 2),
('лаб.№27', 'Сергей Борисович Звездюлёв', 2);

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
	('Марьяна Ибрагимовна Минскер', '2020-06-15', 'в.н.с.', 'middle', 70001, 3, TRUE);

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
(6,'B','C','C','D');
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










































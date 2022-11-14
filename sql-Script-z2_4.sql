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
('лаб.№23', 'Иван Иванович Иванов', 2),
('лаб.№21', 'Василий Васильевич Васильев', 2),
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
	('Иван Иванович Иванов', '2022-02-24', 'м.н.с.', 'junior', 30000, 1, TRUE),
	('Марина Петровна Петрова', '2021-01-01', 'н.с.', 'middle', 40000, 2, FALSE),
	('Василий Васильевич Васильев', '1995-10-20', 'в.н.с.', 'lead', 70000, 3, TRUE),
    ('Михаил Джекович Блэк', '2022-03-04', 'м.н.с.', 'junior', 30000, 1, TRUE),
	('Сергей Борисович Звездюлёв', '2019-12-30', 'г.н.с.', 'lead', 40000, 2, TRUE),
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

SELECT FIO as "Сотрудник с максимальной зарплатой", Salary as "Зарплата" 
FROM Workers w 
WHERE w.salary = (SELECT max(salary) FROM Workers);





































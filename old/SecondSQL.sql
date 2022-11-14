--Практика часть 2:
-- --o  a.Попробуйте вывести не просто самую высокую зарплату во всей команде, а вывести именно фамилию сотрудника с самой высокой зарплатой.
 -- Уже делал Выведите самую высокую зарплату в компании. Заодно рассекретим человека/ов)
   select surname,salary from employees where salary=(select max(salary) from employees);
-- b.Попробуйте вывести фамилии сотрудников в алфавитном порядке
   select surname from employees order by surname;
-- c.Рассчитайте средний стаж для каждого уровня сотрудников
   select grade, round(avg(current_date-incomdate)/365) from employees e group by grade;
-- d.Выведите фамилию сотрудника и название отдела, в котором он работает
   select surname, depname from employees left join departments d on d.id=department_id;
-- e.Выведите название отдела и фамилию сотрудника с самой высокой зарплатой в данном отделе и саму зарплату также.
   select depname, surname, salary from employees left join departments d on d.id=department_id where salary in (select max(salary) from employees group by department_id) order by depname;
-- f. *Выведите название отдела, сотрудники которого получат наибольшую премию по итогам года. Как рассчитать премию можно узнать в последнем задании предыдущей домашней работы
   select

   with max_sal_dep as (select max(salary),department_id from employees group by department_id)
   select surname, salary from max_sal_dep;


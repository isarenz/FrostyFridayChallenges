--Set the settings
use database FROSTYFRIDAY;
use schema FROSTYFRIDAYSCHEMA;


--Set the number of years to generate
SELECT TO_DATE('2000-01-01','YYYY-MM-DD') AS start_date, 
ROW_NUMBER() OVER(ORDER BY start_date) AS row_numbers,
DATEADD(DAY, row_numbers, start_date) AS v_date
FROM TABLE(GENERATOR(rowcount => 9000));

--Set the Start date 
set days_to_generate = 9000;
set start_date = to_date('2000-01-01','yyyy-mm-dd');
set end_date = dateadd(d,-1,dateadd(d,$days_to_generate,'2000-01-01'));
select $start_date, $end_date; 

alter session set week_of_year_policy = 1;

--create the table
create or replace table week_18 as
(select 
       dateadd(d, (row_number() over (order by null))-1, $start_date) as cal_date,
       year(cal_date) as "YEAR", 
       monthname(cal_date) as "MONTH_ABBR",
       TO_CHAR((cal_date),'MMMM') as "MONTH_NAME",
       dayofmonth(cal_date) as "DAY_OF_MONTH",
       dayofweekiso(cal_date) as "DAY_OF_WEEK",
       weekofyear(cal_date) as "WEEK_OF_YEAR",
       dayofyear(cal_date) as "DAY_OF_YEAR"
from table(generator(rowcount=>9000)));

--Check the table
select * from week_18;


--Create a function to calculate the number of business days between 2 dates
create or replace function calculate_business_days(from_date date, till_date date, include_2nd boolean)
    returns number
as '
select count(*)
from week_18 
where day_of_week not in (6,7) 
and cal_date between from_date and (till_date - (not include_2nd)::number)
';



--Test as required by the exercise
select calculate_business_days('2020-11-2','2020-11-6',true) as including
, calculate_business_days('2020-11-2','2020-11-6',false) as excluding
;

--Test the data as required by the exercise
create or replace table testing_data (
id INT,
start_date DATE,
end_date DATE
);
insert into testing_data (id, start_date, end_date) values (1, '11/11/2020', '9/3/2022');
insert into testing_data (id, start_date, end_date) values (2, '12/8/2020', '1/19/2022');
insert into testing_data (id, start_date, end_date) values (3, '12/24/2020', '1/15/2022');
insert into testing_data (id, start_date, end_date) values (4, '12/5/2020', '3/3/2022');
insert into testing_data (id, start_date, end_date) values (5, '12/24/2020', '6/20/2022');
insert into testing_data (id, start_date, end_date) values (6, '12/24/2020', '5/19/2022');
insert into testing_data (id, start_date, end_date) values (7, '12/31/2020', '5/6/2022');
insert into testing_data (id, start_date, end_date) values (8, '12/4/2020', '9/16/2022');
insert into testing_data (id, start_date, end_date) values (9, '11/27/2020', '4/14/2022');
insert into testing_data (id, start_date, end_date) values (10, '11/20/2020', '1/18/2022');
insert into testing_data (id, start_date, end_date) values (11, '12/1/2020', '3/31/2022');
insert into testing_data (id, start_date, end_date) values (12, '11/30/2020', '7/5/2022');
insert into testing_data (id, start_date, end_date) values (13, '11/28/2020', '6/19/2022');
insert into testing_data (id, start_date, end_date) values (14, '12/21/2020', '9/7/2022');
insert into testing_data (id, start_date, end_date) values (15, '12/13/2020', '8/15/2022');
insert into testing_data (id, start_date, end_date) values (16, '11/4/2020', '3/22/2022');
insert into testing_data (id, start_date, end_date) values (17, '12/24/2020', '8/29/2022');
insert into testing_data (id, start_date, end_date) values (18, '11/29/2020', '10/13/2022');
insert into testing_data (id, start_date, end_date) values (19, '12/10/2020', '7/31/2022');
insert into testing_data (id, start_date, end_date) values (20, '11/1/2020', '10/23/2021');

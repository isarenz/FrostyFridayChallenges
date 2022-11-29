--Define the settings
USE FROSTYFRIDAY
USE SCHEMA FROSTYFRIDAYSCHEMA
USE COMPUTE_WH


--Create the table with a random number
CREATE OR REPLACE TABLE week_5 
AS 
SELECT uniform(1, 100, random()) as column_name;


--Check the table exists
SELECT * FROM week_5


--Define the Python UDF function
CREATE OR REPLACE FUNCTION function_week_5 (i int)
returns int
language python
runtime_version = '3.8'
handler = 'function_week_5_py'
as
$$
def function_week_5_py (i):
    return i*3
$$;


--Apply my function to the choosed value from the table
SELECT function_week_5 (SELECT*FROM week_5);

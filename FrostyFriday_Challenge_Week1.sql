--Set the settings
create database FROSTYFRIDAY;
use database FROSTYFRIDAY;
create schema FROSTYFRIDAYSCHEMA;
use schema FROSTYFRIDAYSCHEMA;

--Create stage
create or replace stage frostyfridaystage
file_format = frostyfridayformat
url = 's3://frostyfridaychallenges/challenge_1/';

--check how many files have been staged
list @frostyfridaystage;

--Query metadata: how many columns do a table have?
select metadata$filename
, metadata$file_row_number
, $1
, $2
from @frostyfridaystage;  

--Create file format
create or replace file format frostyfridayformat
  type = 'CSV'
  field_delimiter = '|'
  skip_header = 1;
  
  
--Create table
create or replace table week_1 (
id varchar
);
  
--Copy data from the stage into the table
copy into week_1
from @frostyfridaystage;

--Check the table
select *
from week_1;

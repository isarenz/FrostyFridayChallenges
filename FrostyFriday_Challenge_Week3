
--Define the settings

use database FROSTYFRIDAY; 
use schema FROSTYFRIDAYSCHEMA;

--Create file format
create or replace file format frostyfridayformat_week3
  type = 'CSV'
  field_delimiter = ','
  skip_header = 1;
 
--Create stage
create or replace stage frostyfridaystage_week3
file_format = frostyfridayformat_week3
url = 's3://frostyfridaychallenges/challenge_3/';
  

--List the files in the stage  
list  @frostyfridaystage_week3;

--Check the content of the csv with the keywords
select metadata$filename as file_name
,      metadata$file_row_number as file_row_number
,      $1
,      $2 
from @frostyfridaystage_week3/keywords.csv
;

--Query one of the data files in the stage (eg.week3_data1)
select metadata$filename as file_name
,      metadata$file_row_number as file_row_number
,      $1
,      $2 
from @frostyfridaystage_week3/week3_data1.csv
;


--Create table 
create or replace table week_3 (
  file_name varchar
, number_of_rows varchar
, id VARCHAR
, first_name VARCHAR
, last_name VARCHAR
, desc_phrase VARCHAR
, time_stamp VARCHAR);

--Create table for the keywords
create or replace table week_3_keywords (
  file_name varchar
, file_row_number varchar    
, keyword varchar
, added_by varchar
, random_values varchar);

--Load the data from csv to table week_3
copy into week_3
from
(
    select 
    metadata$filename as file_name
  , metadata$file_row_number as file_row_number
  , $1 AS id
  , $2 AS first_name
  , $3 AS last_name
  , $4 AS desc_phrase
  , $5 AS timestamp
from   @frostyfridaystage_week3
);
  

--Load the data from keywords csv to keywords table
copy into week_3_keywords
from
(
    select 
    metadata$filename as file_name
  , metadata$file_row_number as file_row_number
  , $1 as keyword
  , $2 as added_by
  , $3 as random_values
    from   @frostyfridaystage_week3 
)
file_format = 'frostyfridayformat_week3',
pattern ='challenge_3/keywords.csv';


--Check the week_3 table
select * from week_3;

--Check the keywords table
select * from week_3_keywords;

--Create the view for the files that contain the keywords from the keywords table
create or replace view week3_kw_files
as
select
file_name
, count(*) AS number_of_rows
from week_3
where exists 
(
  select keyword
  from week_3_keywords
  where contains (week_3.file_name,week_3_keywords.keyword)
)
group by file_name;

select * from week3_kw_files;

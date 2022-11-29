use database frostyfriday;
use schema frostyfridayschema;

create or replace file format mycsvformat
  type = 'CSV'
  field_delimiter = ','
  skip_header = 1;

create stage week_11_frosty_stage
    url = 's3://frostyfridaychallenges/challenge_11/'
    file_format = mycsvformat;
    
create or replace table "frosty_friday.challenges.week11" as
select m.$1 as milking_datetime,
        m.$2 as cow_number,
        m.$3 as fat_percentage,
        m.$4 as farm_code,
        m.$5 as centrifuge_start_time,
        m.$6 as centrifuge_end_time,
        m.$7 as centrifuge_kwph,
        m.$8 as centrifuge_electricity_used,
        m.$9 as centrifuge_processing_time,
        m.$10 as task_used
from @week_11_frosty_stage (file_format => 'mycsvformat', pattern => '.*milk_data.*[.]csv') m;

select * from "frosty_friday.challenges.week11";

--Task Parent script | Whole Milk
create or replace task whole_milk_updates
   -- { warehouse = compute_wh(s) }
    schedule = '1400 minutes'
as
    UPDATE "frosty_friday.challenges.week11"
    SET    centrifuge_start_time = NULL
         , centrifuge_end_time = NULL
         , centrifuge_kwph = NULL
         , task_used = system$current_user_task_name()
WHERE  fat_percentage = 3;

-- Check that the task Whole Milk performed correctly
select * 
from "frosty_friday.challenges.week11"
where fat_percentage != 3;
   

--Task Children script | Skim Milk
create or replace task skim_milk_updates
warehouse = compute_wh
after whole_milk_updates
as
    UPDATE  "frosty_friday.challenges.week11"
    SET   centrifuge_processing_time = datediff(minute, centrifuge_start_time, centrifuge_end_time)  
         , task_used = system$current_user_task_name()
where fat_percentage != 3;

-- Manually execute the task.
select system$task_dependents_enable('WHOLE_MILK_UPDATES');


execute task whole_milk_updates;
execute task skim_milk_updates;

alter task whole_milk_updates suspend;


select * 
from "frosty_friday.challenges.week11"
where fat_percentage = 3;

select * 
from "frosty_friday.challenges.week11"
where fat_percentage != 3;



-- Check that the data looks as it should.
select * from "frosty_friday.challenges.week11";


-- Check that the numbers are correct.
select task_used, count(*) as row_count from "frosty_friday.challenges.week11" group by task_used;

--Use db and schema

USE DATABASE FROSTYFRIDAY;

USE WAREHOUSE COMPUTE_WH;

USE SCHEMA FROSTYFRIDAYSCHEMA;


-- create the table

CREATE OR REPLACE TABLE week_14 (
    superhero_name varchar(50),
    country_of_residence varchar(50),
    notable_exploits varchar(150),
    superpower varchar(100),
    second_superpower varchar(100),
    third_superpower varchar(100)
    );


--Populate the table with values

INSERT INTO week_14 VALUES ('Superpig', 'Ireland', 'Saved head of Irish Farmer\'s Association from terrorist cell', 'Super-Oinks', NULL, NULL);
INSERT INTO week_14 VALUES ('Señor Mediocre', 'Mexico', 'Defeated corrupt convention of fruit lobbyists by telling anecdote that lasted 33 hours, with 16 tangents that lead to 17 resignations from the board', 'Public speaking', 'Stamp collecting', 'Laser vision');
INSERT INTO week_14 VALUES ('The CLAW', 'USA', 'Horrifically violent duel to the death with mass murdering super villain accidentally created art installation last valued at $14,450,000 by Sotheby\'s', 'Back scratching', 'Extendable arms', NULL);
INSERT INTO week_14 VALUES ('Il Segreto', 'Italy', NULL, NULL, NULL, NULL);
INSERT INTO week_14 VALUES ('Frosty Man', 'UK', 'Rescued a delegation of data engineers from a DevOps conference', 'Knows, by memory, 15 definitions of an obscure codex known as "the data mesh"', 'can copy and paste from StackOverflow with the blink of an eye', NULL);

 
--View the content of the table 
SELECT * FROM week_14;


--Create the view FROSTYFRIDAY_JSON_VIEW
CREATE OR REPLACE VIEW JSON_VIEW
as                       
SELECT
    OBJECT_CONSTRUCT(
        'country_of_residence', country_of_residence
      , 'superhero_name', superhero_name
      , 'superpowers',
            coalesce(
                nullif(
                    ARRAY_CONSTRUCT_COMPACT(
                        superpower
                    , second_superpower
                    , third_superpower)
                  , ARRAY_CONSTRUCT_COMPACT(null) 
                      )
                , array_construct(null)  
                    )
                    )as SUPERHERO_JSON
FROM week_14;                     

--View the content of the view 
SELECT * FROM JSON_VIEW;

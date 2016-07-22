-- ***************************************************************************
-- Loading Data:
-- create external table mapping for events.csv and mortality_events.csv

-- IMPORTANT NOTES:
-- You need to put events.csv and mortality.csv under hdfs directory 
-- '/input/events/events.csv' and '/input/mortality/mortality.csv'
-- 
-- To do this, run the following commands for events.csv, 
-- 1. sudo su - hdfs
-- 2. hdfs dfs -mkdir -p /input/events
-- 3. hdfs dfs -chown -R vagrant /input
-- 4. exit 
-- 5. hdfs dfs -put /path/to/events.csv /input/events/
-- Follow the same steps 1 - 5 for mortality.csv, except that the path should be 
-- '/input/mortality'
-- ***************************************************************************
-- create events table 
DROP TABLE IF EXISTS events;
CREATE EXTERNAL TABLE events (
  patient_id STRING,
  event_id STRING,
  event_description STRING,
  time DATE,
  value DOUBLE)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/input/events';

-- create mortality events table 
DROP TABLE IF EXISTS mortality;
CREATE EXTERNAL TABLE mortality (
  patient_id STRING,
  time DATE,
  label INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/input/mortality';

-- ******************************************************
-- Task 1:
-- By manipulating the above two tables, 
-- generate two views for alive and dead patients' events
-- ******************************************************
-- find events for alive patients
DROP VIEW IF EXISTS alive_events;
CREATE VIEW alive_events 
AS
SELECT events.patient_id, events.event_id, events.time 
FROM  events
LEFT JOIN mortality
ON events.patient_id=mortality.patient_id
where mortality.label is null ;







-- find events for dead patients
DROP VIEW IF EXISTS dead_events;
CREATE VIEW dead_events 
AS
SELECT events.patient_id, events.event_id, events.time
FROM events 
LEFT JOIN mortality
ON events.patient_id=mortality.patient_id
where mortality.label==1 ;







-- ************************************************
-- Task 2: Event count metrics
-- Compute average, min and max of event counts 
-- for alive and dead patients respectively  
-- ************************************************
-- alive patients
SELECT avg(event_count), min(event_count), max(event_count)
-- ***** your code below *****
From (select count(*) as event_count FROM alive_events
group by patient_id) a;

--682.6474123539232       1       12627



-- dead patients
SELECT avg(event_count), min(event_count), max(event_count)
-- ***** your code below *****
From (select count(*) as event_count FROM dead_events
group by patient_id) a;

--1029.059        2       16829




-- ************************************************
-- Task 3: Encounter count metrics 
-- Compute average, min and max of encounter counts 
-- for alive and dead patients respectively
-- ************************************************
-- alive
SELECT avg(encounter_count), min(encounter_count), max(encounter_count)
-- ***** your code below *****
from (select count (distinct time) as encounter_count from alive_events group by patient_id) a;
--18.669449081803005      1       391




-- dead
SELECT avg(encounter_count), min(encounter_count), max(encounter_count)
-- ***** your code below *****
from (select count (distinct time) as encounter_count from dead_events group by patient_id) a;


--24.861  1       375




-- ************************************************
-- Task 4: Record length metrics
-- Compute average, min and max of record lengths
-- for alive and dead patients respectively
-- ************************************************
-- alive 
SELECT avg(record_length), min(record_length), max(record_length)
-- ***** your code below *****
from (select datediff(max(time),min(time)) as record_length from alive_events group by patient_id) a;

--194.65409015025043      0       3103



-- dead
SELECT avg(record_length), min(record_length), max(record_length)
-- ***** your code below *****
from (select datediff(max(time),min(time)) as record_length from dead_events group by patient_id) a;


--151.397 0       2601





-- ******************************************* 
-- Task 5: Common diag/lab/med
-- Compute the 5 most frequently occurring diag/lab/med
-- for alive and dead patients respectively
-- *******************************************
-- alive patients
---- diag
SELECT event_id, count(*) AS diag_count
FROM alive_events
-- ***** your code below *****
Where event_id like "DIAG%"

group by event_id
order by diag_count desc
limit 5;

/* DIAG320128      1019
DIAG319835      721
DIAG317576      719
DIAG42872402    674
DIAG313217      641 */

---- lab
SELECT event_id, count(*) AS lab_count
FROM alive_events
-- ***** your code below *****
Where event_id like "LAB%"
group by event_id
order by lab_count desc
limit 5;

/* LAB3009542      66910
LAB3000963      57733
LAB3023103      56967
LAB3018572      54667
LAB3007461      53548 */

---- med
SELECT event_id, count(*) AS med_count
FROM alive_events
-- ***** your code below *****
Where event_id like "DRUG%"
group by event_id
order by med_count desc
limit 5;

/* DRUG19095164    12452
DRUG43012825    10388
DRUG19049105    9329
DRUG19122121    7586
DRUG956874      7294 */


-- dead patients
---- diag
SELECT event_id, count(*) AS diag_count
FROM dead_events
-- ***** your code below *****
Where event_id like "DIAG%"
group by event_id
order by diag_count desc
limit 5;

/* DIAG320128      415
DIAG319835      413
DIAG313217      374
DIAG197320      346
DIAG132797      297 */


---- lab
SELECT event_id, count(*) AS lab_count
FROM dead_events
-- ***** your code below *****
Where event_id like "LAB%"
group by event_id
order by lab_count desc
limit 5;

/* LAB3009542      32747
LAB3023103      28376
LAB3000963      28288
LAB3018572      27364
LAB3016723      27041 */


---- med
SELECT event_id, count(*) AS med_count
FROM dead_events
-- ***** your code below *****
Where event_id like "DRUG%"
group by event_id
order by med_count desc
limit 5;


/* 
DRUG19095164    6394
DRUG43012825    5446
DRUG19049105    4323
DRUG956874      3962
DRUG19122121    3908 */






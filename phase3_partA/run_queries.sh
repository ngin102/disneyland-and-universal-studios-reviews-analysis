#!/bin/bash

# Phase 3 Part A - OLAP Queries
# Émilie Brazeau, Nicholas Gin, Gordon Tang

# IMPORTANT!!
# To execute these queries, you must have the staged_data.csv from our project
# saved locally on your machine (this csv file can be found in the updated_phase2
# subfolder, which is located in the directory this file was found in).
# On Line 140, update the path to staged_data.csv to reflect where you have
# saved it on your machine.
# (We first load the data mart before running the queries to ensure that we can run the queries!)

dropdb --if-exists reviewsDM

# Set up the PostgreSQL database.
createdb reviewsDM

# Connect to the database 
psql reviewsDM <<EOF

-- Create a table called date_dimension.
-- This table represents the Date dimension in the dimensional model. 
-- The date_key column is the primary key (it is autogenerated in sequence, hence it is serial); 
-- the month, quarter and year columns represent the Month, Quarter and Year attributes respectively. 
CREATE TABLE date_dimension (
    date_key SERIAL PRIMARY KEY,
    month INTEGER NOT NULL,
    quarter INTEGER NOT NULL,
    year INTEGER NOT NULL
);

-- Create a table called branch_attendance_outrigger_dimension. 
-- This table represents the Branch Attendance outrigger dimension in the dimensional model. 
-- The branch_attendance_key column is the primary key (it is autogenerated in sequence, hence it is serial); 
-- the year and attendance_millions columns represents the Year and Attendance (millions) attributes respectively.
CREATE TABLE branch_attendance_outrigger_dimension (
    branch_attendance_key SERIAL PRIMARY KEY,
    attendance_millions_2006 DECIMAL,
    attendance_millions_2007 DECIMAL,
    attendance_millions_2008 DECIMAL,
    attendance_millions_2009 DECIMAL,
    attendance_millions_2010 DECIMAL,
    attendance_millions_2011 DECIMAL,
    attendance_millions_2012 DECIMAL,
    attendance_millions_2013 DECIMAL,
    attendance_millions_2014 DECIMAL,
    attendance_millions_2015 DECIMAL,
    attendance_millions_2016 DECIMAL,
    attendance_millions_2017 DECIMAL,
    attendance_millions_2018 DECIMAL,
    attendance_millions_2019 DECIMAL,
    attendance_millions_2020 DECIMAL,
    attendance_millions_2021 DECIMAL
);

-- Create a table called branch_dimension. 
-- This table represents the Branch dimension in the dimensional model. 
-- The branch_key column is the primary key (it is autogenerated in sequence, hence it is serial); 
-- the branch_name column represents the Branch Name attribute. 
-- This dimension is linked to the Branch Attendance Outrigger Dimension.
CREATE TABLE branch_dimension (
    branch_key SERIAL PRIMARY KEY,
    branch_name VARCHAR(255) NOT NULL,
    branch_attendance_key INTEGER,
    FOREIGN KEY (branch_attendance_key) REFERENCES branch_attendance_outrigger_dimension    
    (branch_attendance_key)
);

/* Create a table called review_text_dimension. 
This table represents the Review dimension in the dimensional model. 
The review_text_key column is the primary key (it is autogenerated in sequence, hence it is serial); 
the review_text and rating columns represent the Review Text and Rating attributes respectively.
*/
CREATE TABLE review_text_dimension (
    review_text_key SERIAL PRIMARY KEY,
    review_text TEXT NOT NULL,
    rating INTEGER NOT NULL
);

-- Create a table called review_fact.
-- It represents the fact table from the dimensional model.
-- Note that the primary key for this table is a composite primary 
-- key consisting of the date_key, branch_key and review_text_key.
CREATE TABLE review_fact (
    surrogate_key SERIAL,
    date_key INTEGER NOT NULL,
    branch_key INTEGER NOT NULL,
    review_text_key INTEGER NOT NULL,
    monthly_percent_positive_reviews DECIMAL NOT NULL,
    monthly_percent_mixed_reviews DECIMAL NOT NULL,
    monthly_percent_negative_reviews DECIMAL NOT NULL,
    PRIMARY KEY (date_key, branch_key, review_text_key),
    FOREIGN KEY (date_key) REFERENCES date_dimension (date_key),
    FOREIGN KEY (branch_key) REFERENCES branch_dimension (branch_key),
    FOREIGN KEY (review_text_key) REFERENCES review_text_dimension (review_text_key)
);

-- Create a temporary table called csv_data (it only exists for 
-- the duration of the transaction).
CREATE TEMPORARY TABLE csv_data (
    surrogate_key INTEGER NOT NULL,
    review_text TEXT NOT NULL,
    rating INTEGER NOT NULL,
    month INTEGER NOT NULL,
	quarter INTEGER NOT NULL,
    year INTEGER NOT NULL,
    branch_name VARCHAR(255) NOT NULL,
    monthly_percent_positive_reviews DECIMAL NOT NULL,
    monthly_percent_mixed_reviews DECIMAL NOT NULL,
    monthly_percent_negative_reviews DECIMAL NOT NULL,
    attendance_millions_2006 DECIMAL,
    attendance_millions_2007 DECIMAL,
    attendance_millions_2008 DECIMAL,
    attendance_millions_2009 DECIMAL,
    attendance_millions_2010 DECIMAL,
    attendance_millions_2011 DECIMAL,
    attendance_millions_2012 DECIMAL,
    attendance_millions_2013 DECIMAL,
    attendance_millions_2014 DECIMAL,
    attendance_millions_2015 DECIMAL,
    attendance_millions_2016 DECIMAL,
    attendance_millions_2017 DECIMAL,
    attendance_millions_2018 DECIMAL,
    attendance_millions_2019 DECIMAL,
    attendance_millions_2020 DECIMAL,
    attendance_millions_2021 DECIMAL
);

-- Copy all of the data from staged_data.csv into the csv_data 
-- (columns in the csv file are separated by the , delimiter).

-- NOTE: Replace '/Users/nicholasgin/Desktop/staged_data.csv' with the absolute path 
-- you saved 'staged_data.csv' at.
COPY csv_data (surrogate_key, review_text, rating, month, quarter, year, branch_name, 
               monthly_percent_positive_reviews, monthly_percent_mixed_reviews, 
               monthly_percent_negative_reviews, attendance_millions_2006, 
               attendance_millions_2007, attendance_millions_2008, attendance_millions_2009, 
			   attendance_millions_2010, attendance_millions_2011, attendance_millions_2012,
			   attendance_millions_2013, attendance_millions_2014, attendance_millions_2015, 
			   attendance_millions_2016, attendance_millions_2017, attendance_millions_2018, 
			   attendance_millions_2019, attendance_millions_2020, attendance_millions_2021)
FROM '/Users/nicholasgin/Desktop/staged_data.csv' DELIMITER ',' CSV HEADER;


-- Load the appropriate data from csv_data into the date_dimension
INSERT INTO date_dimension (month, quarter, year)
SELECT DISTINCT month, quarter, year
FROM csv_data;

-- Load the appropriate data from csv_data into the review_text_dimension
INSERT INTO review_text_dimension (review_text, rating)
SELECT DISTINCT review_text, rating
FROM csv_data;

-- Load the appropriate data from csv_data into the branch_attendance_outrigger_dimension
INSERT INTO branch_attendance_outrigger_dimension (attendance_millions_2006, attendance_millions_2007, attendance_millions_2008, attendance_millions_2009, attendance_millions_2010, attendance_millions_2011, attendance_millions_2012, attendance_millions_2013, attendance_millions_2014, attendance_millions_2015, attendance_millions_2016, attendance_millions_2017, attendance_millions_2018, attendance_millions_2019, attendance_millions_2020, attendance_millions_2021)
SELECT DISTINCT attendance_millions_2006, attendance_millions_2007, attendance_millions_2008, attendance_millions_2009, attendance_millions_2010, attendance_millions_2011, attendance_millions_2012, attendance_millions_2013, attendance_millions_2014, attendance_millions_2015, attendance_millions_2016, attendance_millions_2017, attendance_millions_2018, attendance_millions_2019, attendance_millions_2020, attendance_millions_2021
FROM csv_data;

-- Load the appropriate data from csv_data into the branch_dimension
-- Use the JOIN statement to match the year and attendance_millions columns 
-- from the branch_attendance_outrigger_dimension and csv_data and then link 
-- them to their corresponding branch.
INSERT INTO branch_dimension (branch_name, branch_attendance_key)
SELECT DISTINCT csv_data.branch_name, branch_attendance_outrigger_dimension.branch_attendance_key
FROM csv_data
JOIN branch_attendance_outrigger_dimension ON (
    csv_data.attendance_millions_2016 = branch_attendance_outrigger_dimension.attendance_millions_2016 
    AND csv_data.attendance_millions_2017 = branch_attendance_outrigger_dimension.attendance_millions_2017 
    AND csv_data.attendance_millions_2018 = branch_attendance_outrigger_dimension.attendance_millions_2018 
    AND csv_data.attendance_millions_2019 = branch_attendance_outrigger_dimension.attendance_millions_2019 
    AND csv_data.attendance_millions_2020 = branch_attendance_outrigger_dimension.attendance_millions_2020 
    AND csv_data.attendance_millions_2021 = branch_attendance_outrigger_dimension.attendance_millions_2021
)
WHERE csv_data.attendance_millions_2016 = branch_attendance_outrigger_dimension.attendance_millions_2016 
  AND csv_data.attendance_millions_2017 = branch_attendance_outrigger_dimension.attendance_millions_2017 
  AND csv_data.attendance_millions_2018 = branch_attendance_outrigger_dimension.attendance_millions_2018 
  AND csv_data.attendance_millions_2019 = branch_attendance_outrigger_dimension.attendance_millions_2019 
  AND csv_data.attendance_millions_2020 = branch_attendance_outrigger_dimension.attendance_millions_2020 
  AND csv_data.attendance_millions_2021 = branch_attendance_outrigger_dimension.attendance_millions_2021;

-- Load the appropriate data from csv_data into review_fact
-- Use the JOIN statements to match the month and year columns from the date_dimension, 
-- the branch_name column from the branch_dimension and the review_text and rating 
-- columns from the review_text_dimension to their corresponding columns in csv_data;
-- we can link them to the review_fact.
INSERT INTO review_fact (date_key, branch_key, review_text_key, monthly_percent_positive_reviews, 
						 monthly_percent_mixed_reviews, 
						 monthly_percent_negative_reviews)
SELECT DISTINCT date_dimension.date_key, branch_dimension.branch_key, review_text_dimension.review_text_key, 
csv_data.monthly_percent_positive_reviews, csv_data.monthly_percent_mixed_reviews, 
csv_data.monthly_percent_negative_reviews
FROM csv_data
JOIN date_dimension ON (csv_data.month = date_dimension.month AND csv_data.year = date_dimension.year)
JOIN branch_dimension ON csv_data.branch_name = branch_dimension.branch_name
JOIN review_text_dimension ON csv_data.review_text = review_text_dimension.review_text AND 
csv_data.rating = review_text_dimension.rating;


EOF

psql reviewsDM <<EOF

-- 1. Drill Down --

SELECT b.branch_name, d.month, rf.surrogate_key, rtd.review_text
FROM review_fact AS rf, date_dimension AS d, review_text_dimension AS rtd, branch_dimension AS b
WHERE rf.date_key = d.date_key AND rf.review_text_key = rtd.review_text_key AND rf.review_text_key = rtd.review_text_key AND rf.branch_key = b.branch_key AND d.year = '2018'
GROUP BY b.branch_name, d.month, rf.surrogate_key, rtd.review_text;

EOF

psql reviewsDM <<EOF

-- 2. Roll Up --

SELECT d.year, AVG(rf.monthly_percent_positive_reviews)
FROM review_fact AS rf, date_dimension AS d WHERE rf.date_key = d.date_key
GROUP BY ROLLUP(d.year)
ORDER BY d.year;

EOF

psql reviewsDM <<EOF

-- 3. Slice --

SELECT rf.surrogate_key, rf.date_key, rf.branch_key, rf.review_text_key, rf.monthly_percent_positive_reviews, rf.monthly_percent_mixed_reviews, rf.monthly_percent_negative_reviews
FROM review_fact AS rf, date_dimension as d
WHERE rf.date_key = d.date_key AND d.year = 2010;

EOF

psql reviewsDM <<EOF

-- 4. Slice --

SELECT rf.surrogate_key, rf.date_key, rf.branch_key, rf.review_text_key, rf.monthly_percent_positive_reviews, rf.monthly_percent_mixed_reviews, rf.monthly_percent_negative_reviews
FROM review_fact AS rf, review_text_dimension as rt
WHERE rf.review_text_key = rt.review_text_key AND LENGTH(rt.review_text) < 100;

EOF

psql reviewsDM <<EOF

-- 5. Dice --

SELECT rt.review_text, b.branch_name
FROM review_fact AS rf, review_text_dimension as rt, branch_dimension AS b WHERE rf.branch_key = b.branch_key AND rf.review_text_key = rt.review_text_key AND rf.branch_key = 1;

EOF

psql reviewsDM <<EOF

-- 6. Dice --

SELECT d.quarter, rt.review_text
FROM review_fact AS rf, review_text_dimension as rt, date_dimension AS d, branch_dimension as b
WHERE rf.date_key = d.date_key AND rf.review_text_key = rt.review_text_key AND rf.branch_key = b.branch_key AND b.branch_key = 6

EOF

psql reviewsDM <<EOF

-- 7. Composite Query --

SELECT b.branch_key, d.year, AVG(rf.monthly_percent_positive_reviews) AS avg_monthly_percent_positive_reviews
FROM review_fact AS rf, date_dimension AS d, branch_dimension AS b WHERE rf.date_key = d.date_key AND rf.branch_key = b.branch_key
AND b.branch_key = 1 AND (d.year = 2015 OR d.year = 2016) GROUP BY ROLLUP (b.branch_key, d.year)
ORDER BY b.branch_key

EOF

psql reviewsDM <<EOF

-- 8. Composite Query --

SELECT b.branch_key, d.quarter, AVG(rf.monthly_percent_negative_reviews) AS avg_monthly_percent_negative_reviews
FROM review_fact AS rf, date_dimension AS d, branch_dimension AS b
WHERE rf.date_key = d.date_key AND rf.branch_key = b.branch_key
AND (b.branch_key = 2 OR b.branch_key = 3) AND d.quarter = 2 GROUP BY ROLLUP (b.branch_key, d.quarter)
ORDER BY b.branch_key;

EOF

psql reviewsDM <<EOF

-- 9. Iceberg --

SELECT b.branch_name, COUNT(*) AS count_5_star_reviews
FROM review_fact AS rf, branch_dimension AS b, review_text_dimension AS rt WHERE rf.branch_key = b.branch_key AND rf.review_text_key = rt.review_text_key AND rt.rating = 5
GROUP BY b.branch_name
ORDER BY count_5_star_reviews DESC
LIMIT 5;

EOF

psql reviewsDM <<EOF

-- 10. Windowing --

SELECT
b.branch_name,
COUNT(*) AS count_1_star_reviews, brand_averages.avg_1_star_reviews, RANK() OVER (
PARTITION BY CASE
WHEN b.branch_name LIKE '%Universal Studios%' THEN 'Universal Studios'
WHEN b.branch_name LIKE '%Disneyland%' THEN 'Disneyland'
ELSE 'Other' END
ORDER BY COUNT(*) DESC ) AS rank
FROM review_fact AS rf
JOIN branch_dimension AS b ON rf.branch_key = b.branch_key
JOIN review_text_dimension AS rt ON rf.review_text_key = rt.review_text_key JOIN (
SELECT CASE
WHEN b.branch_name LIKE '%Universal Studios%' THEN 'Universal Studios' WHEN b.branch_name LIKE '%Disneyland%' THEN 'Disneyland'
ELSE 'Other'
END AS brand,
AVG(review_counts.count_1_star_reviews) AS avg_1_star_reviews FROM (
SELECT
b.branch_name,
COUNT(*) AS count_1_star_reviews
FROM review_fact AS rf
JOIN branch_dimension AS b ON rf.branch_key = b.branch_key
JOIN review_text_dimension AS rt ON rf.review_text_key = rt.review_text_key WHERE rt.rating = 1 AND (b.branch_name LIKE '%Disneyland%' OR
b.branch_name LIKE '%Universal Studios%') GROUP BY b.branch_name
) AS review_counts
JOIN branch_dimension AS b ON review_counts.branch_name LIKE '%' || b.branch_name || '%'
WHERE b.branch_name IN ('Disneyland Paris', 'Disneyland California', 'Disneyland Hong Kong', 'Universal Studios Florida', 'Universal Studios Singapore', 'Universal Studios Japan')
GROUP BY brand
) AS brand_averages ON
CASE
WHEN b.branch_name LIKE '%Universal Studios%' THEN 'Universal Studios' WHEN b.branch_name LIKE '%Disneyland%' THEN 'Disneyland'
ELSE 'Other'
END = brand_averages.brand
WHERE rt.rating = 1 AND (b.branch_name LIKE '%Disneyland%' OR b.branch_name LIKE '%Universal Studios%')
GROUP BY b.branch_name, brand_averages.avg_1_star_reviews
ORDER BY b.branch_name;

EOF

psql reviewsDM <<EOF

-- 11. Window Clause --

SELECT DISTINCT make_date(d.year, 1, 1) AS year, AVG(rt.rating) OVER W AS movavg
FROM review_fact AS rf
JOIN date_dimension AS d ON rf.date_key = d.date_key
JOIN review_text_dimension as rt ON rf.review_text_key = rt.review_text_key JOIN branch_dimension as b ON rf.branch_key = b.branch_key
WHERE b.branch_key = 3
WINDOW W AS (
PARTITION BY make_date(d.year, 1, 1)
ORDER BY make_date(d.year, 1, 1)
RANGE BETWEEN INTERVAL '1' YEAR PRECEDING AND INTERVAL '1' YEAR FOLLOWING
)
ORDER BY make_date(d.year, 1, 1);

EOF

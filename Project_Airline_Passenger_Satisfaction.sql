USE airline_passenger_satisfaction;

-- Changing data types in Table review1
ALTER TABLE review1
    ADD PRIMARY KEY `Pr_index`(`index`),
    MODIFY `id` VARCHAR(6) NOT NULL,
    ADD CONSTRAINT `id_unique` UNIQUE(`id`),
    MODIFY `Gender` ENUM('Female','Male') NOT NULL,
    MODIFY `Age` VARCHAR(2) NOT NULL,
    MODIFY `Customer Type` ENUM(
        'disloyal Customer','Loyal Customer'
        ) NOT NULL,
    MODIFY `Type of Travel` ENUM(
        'Business travel',
        'Personal Travel') NOT NULL,
    MODIFY `Class` ENUM('Eco','Eco Plus','Business') NOT NULL,
    MODIFY `satisfaction` ENUM(
        'neutral or dissatisfied',
        'satisfied') NOT NULL;

-- Changing data types in Table review2
ALTER TABLE review2
    ADD PRIMARY KEY `Pr_index`(`index`),
    MODIFY `id` VARCHAR(6) NOT NULL,
    ADD CONSTRAINT `id_unique` UNIQUE(`id`),
    MODIFY `Gender` ENUM('Female','Male') NOT NULL,
    MODIFY `Age` VARCHAR(2) NOT NULL,
    MODIFY `Customer Type` ENUM(
        'disloyal Customer','Loyal Customer'
        ) NOT NULL,
    MODIFY `Type of Travel` ENUM(
        'Business travel',
        'Personal Travel') NOT NULL,
    MODIFY `Class` ENUM('Eco','Eco Plus','Business') NOT NULL,
    MODIFY `satisfaction` ENUM(
        'neutral or dissatisfied',
        'satisfied') NOT NULL;

ALTER TABLE review1
    MODIFY Age INT NOT NULL,
    MODIFY id INT NOT NULL;

ALTER TABLE review2
    MODIFY Age INT NOT NULL,
    MODIFY id INT NOT NULL;

-- Checking the Age Range from the Age column
SELECT r1.Age AS Age_r1, r2.Age AS Age_r2
FROM review1 AS r1
JOIN review2 AS r2 
    ON r1.Age = r2.Age
ORDER BY Age_r1, Age_r2;

-- Adding a new column to categorize based on age
ALTER TABLE review1
    ADD COLUMN `Age_category` ENUM(
        'Children',
        'Teenagers',
        'Young Adults',
        'Middle-aged Adults',
        'Elderly'
    );

ALTER TABLE review2
    ADD COLUMN `Age_category` ENUM(
        'Children',
        'Teenagers',
        'Young Adults',
        'Middle-aged Adults',
        'Elderly'
    );

/* 
    Mapping Age data to the Age_category column
    in tables review1 and review2
*/

UPDATE review1
SET Age_category = 'Children'
WHERE AGE BETWEEN 7 AND 12;

UPDATE review1
SET Age_category = 'Teenagers'
WHERE AGE BETWEEN 13 AND 19;

UPDATE review1
SET Age_category = 'Young Adults'
WHERE AGE BETWEEN 20 AND 39;

UPDATE review1
SET Age_category = 'Middle-aged Adults'
WHERE AGE BETWEEN 40 AND 59;

UPDATE review1
SET Age_category = 'Elderly'
WHERE AGE >= 60;

UPDATE review2
SET Age_category = 'Children'
WHERE AGE BETWEEN 7 AND 12;

UPDATE review2
SET Age_category = 'Teenagers'
WHERE AGE BETWEEN 13 AND 19;

UPDATE review2
SET Age_category = 'Young Adults'
WHERE AGE BETWEEN 20 AND 39;

UPDATE review2
SET Age_category = 'Middle-aged Adults'
WHERE AGE BETWEEN 40 AND 59;

UPDATE review2
SET Age_category = 'Elderly'
WHERE AGE >= 60;

-- Checking for NULL columns
SELECT 
    r1.Age as Age_r1, 
    r2.Age as Age_r2, 
    r1.Age_category as C1_Age, 
    r2.Age_category as C2_Age
FROM (SELECT Age, Age_category FROM review1) as r1
CROSS JOIN (SELECT Age, Age_category FROM review2) as r2
WHERE r1.Age_category IS NULL AND r2.Age_category IS NULL
ORDER BY r1.Age, r2.Age;

ALTER TABLE review1
    MODIFY Age_Category ENUM(
        'Children',
        'Teenagers',
        'Young Adults',
        'Middle-aged Adults',
        'Elderly'
    )NOT NULL AFTER Age;

ALTER TABLE review2
    MODIFY Age_Category ENUM(
        'Children',
        'Teenagers',
        'Young Adults',
        'Middle-aged Adults',
        'Elderly'
    )NOT NULL AFTER Age;

-- 1. Is customer satisfaction higher among female or male passengers?
SELECT r.Gender, r.satisfaction, SUM(r.Frequency) AS `Frq_satisfaction`
FROM (
    SELECT Gender, satisfaction, COUNT(satisfaction) AS Frequency 
    FROM review1
    WHERE satisfaction = 'satisfied' OR satisfaction = 'neutral or dissatisfied'
    GROUP BY Gender, satisfaction

UNION ALL
    
    SELECT Gender, satisfaction, COUNT(satisfaction) AS Frequency 
    FROM review2
    WHERE satisfaction = 'satisfied' OR satisfaction = 'neutral or dissatisfied'
    GROUP BY Gender, satisfaction
) AS r
GROUP BY r.Gender, r.satisfaction
ORDER BY r.`Gender` , Frq_satisfaction ASC;

-- 2. Does the type of travel (Personal Travel or Business Travel) affect customer satisfaction?
SELECT r.`Type of Travel`, r.satisfaction, SUM(r.Frequency) AS `Frq_satisfaction`
FROM (
    SELECT 
        `Type of Travel`, satisfaction,
        COUNT(satisfaction) AS Frequency
    FROM review1
    WHERE satisfaction = 'satisfied' OR satisfaction = 'neutral or dissatisfied'    
    GROUP BY `Type of Travel` , satisfaction

UNION ALL

    SELECT 
        `Type of Travel`, satisfaction,
        COUNT(satisfaction) AS Frequency
    FROM review2
    WHERE satisfaction = 'satisfied' OR satisfaction = 'neutral or dissatisfied'
    GROUP BY `Type of Travel` , satisfaction
    ) AS r

GROUP BY r.`Type of Travel`, r.satisfaction
ORDER BY r.`Type of Travel`, Frq_satisfaction ASC;

-- 3. Is there a difference in satisfaction levels among flight classes (Business, Eco, Eco Plus)?
SELECT r.`Class`, r.satisfaction, SUM(r.Frequency) AS `Frq_satisfaction`
FROM(
    SELECT
        `Class`, satisfaction,
        COUNT(satisfaction) AS Frequency
    FROM review1
    GROUP BY `Class`,satisfaction

UNION ALL

    SELECT
        `Class`, satisfaction,
        COUNT(satisfaction) AS Frequency
    FROM review2
    GROUP BY `Class`,satisfaction
) AS r

GROUP BY r.`Class`, r.satisfaction
ORDER BY r.`Class`, Frq_satisfaction ASC;

-- 4. Is there a difference in satisfaction levels between loyal and disloyal customers?
SELECT `r`.`Customer Type`, `r`.satisfaction , SUM(`r`.fr) AS Frq_satisfaction
FROM(
    SELECT 
        `Customer Type`, satisfaction,
        COUNT(satisfaction) AS Fr
    FROM review1
    GROUP BY `Customer Type`, satisfaction

UNION ALL

    SELECT
        `Customer Type`, satisfaction,
        COUNT(satisfaction) AS Fr
    FROM review2
    GROUP BY `Customer Type`, satisfaction
) AS r

GROUP BY `r`.`Customer Type`, `r`.satisfaction
ORDER BY `r`.`Customer Type`, Frq_satisfaction DESC;


/*
    Continuing with further analysis using Python
*/
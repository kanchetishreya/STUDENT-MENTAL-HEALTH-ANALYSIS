SELECT * FROM demo.`student mental health`;
SELECT * FROM demo.`student mental health`;
select * from demo.`student mental health` limit 10;

-- Retrieve all records where students have depression
select * from `student mental health` where `Do you have Depression?` ="yes";

-- Find how many students are male and how many are female
select `choose your gender` as gender,count(*) from `student mental health` group by `Choose your gender`;

-- Display the names of courses taken by students who don’t have anxiety
SELECT 
    `What is your course?` AS courses,
    `Do you have Anxiety?` AS anxiety
FROM
    `student mental health`
WHERE
    `Do you have Anxiety?` = 'No';

-- Count the number of students who have panic attacks.
select count(*) from `student mental health` where `Do you have Panic attack?`= "Yes";

-- Retrieve all students whose CGPA is '3.50 - 4.00'
select * from `student mental health` where `What is your CGPA?` ='3.50 - 4.00';

-- Find the average age of students who have anxiety.
select avg(Age) as avg_age from `student mental health` where `Do you have Anxiety?`;

-- Count how many students have both depression and anxiety.
select count(*) from `student mental health` where `Do you have Depression?`='Yes' and `Do you have Anxiety?`='Yes';

-- Show how many students in each year of study have panic attacks.
SELECT 
    COUNT(*) AS count,
    `Your current year of Study` AS study_year
FROM
    `student mental health`
GROUP BY `Your current year of Study`; 

-- Find how many married students suffer from any mental health issue (depression, anxiety, or panic attack).
SELECT 
    *
FROM
    `student mental health`
WHERE
    `Marital status` = 'Yes'
        AND (`Do you have Depression?` = 'Yes'
        OR `Do you have Anxiety?` = 'Yes'
        OR `Do you have Panic attack?` = 'Yes');

-- List students who have depression = 'Yes' but did not seek specialist treatment.
SELECT 
    *
FROM
    `student mental health`
WHERE
    `Do you have Depression?` = 'Yes'
        AND `Did you seek any specialist for a treatment?` = 'No';

-- Show the percentage of students (out of total) who have any one of depression/anxiety/panic attack.
select round(sum(case when `Do you have Depression?`='Yes' or
							`Do you have Anxiety?`='Yes' or
							`Do you have Panic attack?`='Yes'
                            then 1 else 0
                            end)*100/ count(*),2) as Suffering_Percentage from `student mental health`;
				
-- Find which CGPA range has the highest number of students with depression
select `What is your CGPA?` as cgpa_range, count(*) as Total_members from `student mental health` where `Do you have Depression?`='Yes' group by `What is your CGPA?` order by Total_members desc;

-- Display how many students per course have all three issues (depression, anxiety, panic).
select `What is your course?`,count(*) as total_students from `student mental health` where `Do you have Depression?`='Yes' And
                                                                           `Do you have Anxiety?`='Yes' And
                                                                           `Do you have Panic attack?`='Yes' 
                                                                             group by `What is your course?`;                         
                                                                             
-- Show a summary table with each year of study and counts of students who have:Depression, Anxiety, Panick attack
select `Your current year of Study` as Study_year,count(*) as No_of_Students from `student mental health` 
where `Do you have Depression?`='Yes' AND 
       `Do you have Anxiety?`='Yes'   AND
       `Do you have Panic attack?`='Yes'
       group by `Your current year of Study`;

-- Retrieve students who have no mental health issues at all (all three = ‘No’).
select * from `student mental health` where `Do you have Depression?`='No' AND
											`Do you have Anxiety?`='No'   AND
                                            `Do you have Panic attack?`='No';
								
-- Find which gender has a higher percentage of students with depression.
SELECT 
    `Choose your gender` AS gender,
    ROUND(SUM(CASE
                WHEN `Do you have Depression?` = 'Yes' THEN 1
                ELSE 0
            END) * 100 / COUNT(*),
            2) AS percentage
FROM
    `student mental health`
GROUP BY `Choose your gender`
ORDER BY gender DESC;

-- Among students who sought specialist treatment, what is the most common mental issue?
SELECT 
    issue, count AS total_students
FROM
    (SELECT 
        'Depression' AS issue,
            SUM(CASE
                WHEN `Do you have Depression?` = 'Yes' THEN 1
                ELSE 0
            END) AS count
    FROM
        `student mental health`
    WHERE
        `Did you seek any specialist for a treatment?` = 'Yes' UNION ALL SELECT 
        'Anxiety' AS issue,
            SUM(CASE
                WHEN `Do you have Anxiety?` = 'Yes' THEN 1
                ELSE 0
            END) AS count
    FROM
        `student mental health`
    WHERE
        `Did you seek any specialist for a treatment?` = 'Yes' UNION ALL SELECT 
        'Panick attack' AS issue,
            SUM(CASE
                WHEN `Do you have Panic attack?` = 'Yes' THEN 1
                ELSE 0
            END) AS count
    FROM
        `student mental health`
    WHERE
        `Did you seek any specialist for a treatment?` = 'Yes') AS t
ORDER BY total_students DESC
LIMIT 1;

-- Create a view that shows each student’s mental health score, where each “Yes” counts as 1 point.
CREATE VIEW Student_health_score AS
    SELECT 
        `Choose your gender`,
        `Age`,
        (CASE
            WHEN `Do you have Depression?` = 'Yes' THEN 1
            ELSE 0
        END) + (CASE
            WHEN `Do you have Anxiety?` = 'Yes' THEN 1
            ELSE 0
        END) + (CASE
            WHEN `Do you have Panic attack?` = 'Yes' THEN 1
            ELSE 0
        END) AS mental_health_score
    FROM
        `student mental health`;

select*from student_health_score;

-- Find the top 3 courses with the most students suffering from any issue.
SELECT 
    COUNT(*) AS total, `What is your course?`
FROM
    `student mental health`
WHERE
    `Do you have Depression?` = 'Yes'
        OR `Do you have Anxiety?` = 'Yes'
        OR `Do you have Panic attack?` = 'Yes'
GROUP BY `What is your course?`
ORDER BY total desc limit 3;

-- show the year and course combination that has the lowest mental health issues overall.
select `Your current year of Study`,`What is your course?`,count(*) as total_students from `student mental health` where 
 `Do you have Depression?` = 'Yes'
        OR `Do you have Anxiety?` = 'Yes'
        OR `Do you have Panic attack?` = 'Yes'
GROUP BY `What is your course?`, `Your current year of Study`
ORDER BY total_students asc limit 3;

--  Relation between CGPA and Depression
SELECT `What is your CGPA?`,
       SUM(CASE WHEN `Do you have Depression?`= 'Yes' THEN 1 ELSE 0 END) AS depression_count,
       COUNT(*) AS total,
       ROUND(100.0 * SUM(CASE WHEN `Do you have Depression?`= 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS depression_percent
FROM `student mental health`
GROUP BY `What is your CGPA?`
ORDER BY depression_percent DESC;

--  Percentage of students by year of study who have anxiety
 SELECT 
    `Your current year of Study`,
    ROUND(SUM(CASE
                WHEN `Do you have Anxiety?` = 'Yes' THEN 1
                ELSE 0
            END) * 100 / COUNT(*),
            2) AS Anxiety_per
FROM
    `student mental health`
GROUP BY  `Your current year of Study`
ORDER BY Anxiety_per;

--  Compare mental health issue distribution across marital status
SELECT `Marital status`,
       ROUND(100.0 * SUM(CASE WHEN  `Do you have Depression?`= 'Yes' OR  `Do you have Anxiety?`= 'Yes' OR  `Do you have Panic attack?`= 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS issue_percentage
FROM `student mental health`
GROUP BY `Marital status`;


--Step 1: Load and explore Data

CREATE TABLE hr_attrition (
    Age NUMBER,
    Attrition VARCHAR2(10),
    BusinessTravel VARCHAR2(30),
    DailyRate NUMBER,
    Department VARCHAR2(50),
    DistanceFromHome NUMBER,
    Education NUMBER,
    EducationField VARCHAR2(50),
    EmployeeCount NUMBER,
    EmployeeNumber NUMBER,
    EnvironmentSatisfaction NUMBER,
    Gender VARCHAR2(10),
    HourlyRate NUMBER,
    JobInvolvement NUMBER,
    JobLevel NUMBER,
    JobRole VARCHAR2(50),
    JobSatisfaction NUMBER,
    MaritalStatus VARCHAR2(20),
    MonthlyIncome NUMBER,
    MonthlyRate NUMBER,
    NumCompaniesWorked NUMBER,
    Over18 VARCHAR2(20),
    OverTime VARCHAR2(10),
    PercentSalaryHike NUMBER,
    PerformanceRating NUMBER,
    RelationshipSatisfaction NUMBER,
    StandardHours NUMBER,
    StockOptionLevel NUMBER,
    TotalWorkingYears NUMBER,
    TrainingTimesLastYear NUMBER,
    WorkLifeBalance NUMBER,
    YearsAtCompany NUMBER,
    YearsInCurrentRole NUMBER,
    YearsSinceLastPromotion NUMBER,
    YearsWithCurrManager NUMBER
);

--Overall Attrition rate

SELECT COUNT(*) AS total_employees,
    SUM(CASE 
            WHEN Attrition = 'Yes' THEN 1 
            ELSE 0 
        END) AS left_company,
    ROUND(
        100 * SUM(CASE 
                      WHEN Attrition = 'Yes' THEN 1 
                      ELSE 0 
                  END) / COUNT(*),
        2
    ) AS attrition_rate
FROM hr_attrition;

--Step2: Analyse Queries
-- 1: Attrition rate by department
SELECT Department,
       COUNT(*) AS total,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
       ROUND(
           100 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
           2
       ) AS attrition_pct
FROM hr_attrition
GROUP BY Department
ORDER BY attrition_pct DESC;

--2: Does salary affect attrition?
SELECT
    CASE
        WHEN MonthlyIncome < 3000 THEN 'Low (under 3k)'
        WHEN MonthlyIncome BETWEEN 3000 AND 6000 THEN 'Mid (3k-6k)'
        WHEN MonthlyIncome BETWEEN 6000 AND 12000 THEN 'Upper Mid (6k-12k)'
        ELSE 'High (12k+)'
    END AS salary_band,
    COUNT(*) AS employees,
    ROUND(
        100 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS attrition_pct
FROM hr_attrition
GROUP BY
    CASE
        WHEN MonthlyIncome < 3000 THEN 'Low (under 3k)'
        WHEN MonthlyIncome BETWEEN 3000 AND 6000 THEN 'Mid (3k-6k)'
        WHEN MonthlyIncome BETWEEN 6000 AND 12000 THEN 'Upper Mid (6k-12k)'
        ELSE 'High (12k+)'
    END
ORDER BY attrition_pct DESC;

--3: Overtime and attrition
SELECT OverTime,
       COUNT(*) AS employees,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
       ROUND(
           100 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
           2
       ) AS attrition_pct
FROM hr_attrition
GROUP BY OverTime
ORDER BY attrition_pct DESC;

--4: Job satisfaction vs attrition
SELECT JobSatisfaction,
       CASE JobSatisfaction
           WHEN 1 THEN 'Low'
           WHEN 2 THEN 'Medium'
           WHEN 3 THEN 'High'
           WHEN 4 THEN 'Very High'
       END AS satisfaction_label,
       COUNT(*) AS employees,
       ROUND(
           100 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
           2
       ) AS attrition_pct
FROM hr_attrition
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;

--5: Work-life balance impact
SELECT WorkLifeBalance,
       CASE WorkLifeBalance
           WHEN 1 THEN 'Bad'
           WHEN 2 THEN 'Good'
           WHEN 3 THEN 'Better'
           WHEN 4 THEN 'Best'
       END AS wlb_label,
       COUNT(*) AS employees,
       ROUND(
           100 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
           2
       ) AS attrition_pct
FROM hr_attrition
GROUP BY WorkLifeBalance
ORDER BY WorkLifeBalance;


--6: Age group analysis
SELECT
    CASE
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 35 THEN '25-35'
        WHEN Age BETWEEN 35 AND 45 THEN '35-45'
        ELSE 'Over 45'
    END AS age_group,
    COUNT(*) AS employees,
    ROUND(
        100 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS attrition_pct,
    ROUND(AVG(MonthlyIncome), 0) AS avg_salary
FROM hr_attrition
GROUP BY
    CASE
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 35 THEN '25-35'
        WHEN Age BETWEEN 35 AND 45 THEN '35-45'
        ELSE 'Over 45'
    END
ORDER BY attrition_pct DESC;


--7: Years since promotion — do stuck employees leave?
SELECT
    CASE
        WHEN YearsSinceLastPromotion = 0 THEN 'Just promoted'
        WHEN YearsSinceLastPromotion BETWEEN 1 AND 2 THEN '1-2 years'
        WHEN YearsSinceLastPromotion BETWEEN 3 AND 5 THEN '3-5 years'
        ELSE 'Over 5 years'
    END AS promotion_gap,
    COUNT(*) AS employees,
    ROUND(
        100 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS attrition_pct
FROM hr_attrition
GROUP BY
    CASE
        WHEN YearsSinceLastPromotion = 0 THEN 'Just promoted'
        WHEN YearsSinceLastPromotion BETWEEN 1 AND 2 THEN '1-2 years'
        WHEN YearsSinceLastPromotion BETWEEN 3 AND 5 THEN '3-5 years'
        ELSE 'Over 5 years'
    END
ORDER BY attrition_pct DESC;


--8: Profile of employees most likely to leave
SELECT *
FROM (
    SELECT
        Department,
        JobRole,
        OverTime,
        ROUND(AVG(MonthlyIncome), 0) AS avg_salary,
        ROUND(AVG(YearsSinceLastPromotion), 1) AS avg_years_since_promo,
        COUNT(*) AS employees,
        ROUND(
            100 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
            2
        ) AS attrition_pct
    FROM hr_attrition
    GROUP BY Department, JobRole, OverTime
    HAVING COUNT(*) >= 10
    ORDER BY attrition_pct DESC
)
WHERE ROWNUM <= 15;

--Step 3: Key Findings for README

--1:Overall Attrition
--% of employees left

select count(*)as total_employees,
    sum(case when attrition = 'Yes' then 1
    else 0 end) as company_left,
round(100 * sum(case when attrition = 'Yes' then 1 
    else 0 end)/count(*),2)
as attrition_rate from hr_attrition;

--2: Is overtime "the single biggest attrition driver?"
--compare attrition for overtime YES vs No

select 
    Overtime,
    count(*) as total_employees,
    sum(case when attrition = 'Yes' Then 1
    else 0 end) as left_employees,
    round(100 * sum(case when attrition = 'Yes' then 1
    else 0 end)/ count(*),2)
    as attrition_rate from hr_attrition
    group by overtime
    order by attrition_rate desc;
    
--3: which department loses the most employees
--department with highest attrition rate/count

select 
    department, count(*) as total_employees,
    sum(case when attrition = 'Yes' then 1
    else 0 end) as overall_attrition,
    round(100 * sum(case when attrition = 'Yes' then 1
    else 0 end)/count(*),2) as attrition_rate
    from hr_attrition group by department
    order by attrition_rate desc;
    
--4: Is salary more important than work_life balance
--"Salary"
select 
    case when MonthlyIncome < 7000 
    then 'Low_salary'
        when MonthlyIncome between 
    7000 and 13000 then 'Medium_salary'
        else 'High_salary'
    end as salary_group,
    count(*) as total_employeees,
    sum(case when attrition = 'Yes' then 1
    Else 0 end) as employee_left,
Round(100 * sum(case when attrition = 'Yes' then 1
    else 0 end)/ count(*),2)as attrition_rate
    from hr_attrition 
    group by 
        case when MonthlyIncome < 7000
            then 'Low_salary'
            when MonthlyIncome between 
            7000 and 13000 then 'Medium_salary'
                Else 'High_salary'
            end
        order by attrition_rate desc;
 
--"work-life"

select worklifebalance,
    count(*) as total_employees,
    sum(case when attrition = 'Yes' then 1
    else 0 end) as employee_left,
    Round(
        100 * sum(case when attrition = 'Yes' then 1
        else 0 end)/count(*),2) as attrition_rate
        from hr_attrition 
        group by worklifebalance
        order by attrition_rate desc;
                
--5: profile of the employees most likely to quit
--building an employee profile using multiple job factors

--"JOB SATISFACTION"

select 
    jobsatisfaction,
    count(*) as total_employees,
    sum(case when attrition = 'Yes' then 1
    Else 0 end) as employee_left,
    round(
        100 * sum(case when attrition = 'Yes' then 1
        Else 0 end)/ count (*),2)
    as Attrition_rate
    from hr_attrition
    group by jobsatisfaction
    order by attrition_rate desc;
    
--"Age"

select 
    case 
    when age < 30 then 'Under 30'
    when age between 30 and 40 then '30-40'
    Else 'Above 40'
    end as Age_group,    
    count(*) as total_employees,
    sum(case when attrition = 'Yes' then 1
    Else 0 end) as employee_left,
    round(
        100* sum(case when attrition = 'Yes' then 1
        else 0 end)/ count(*),2)
    as attrition_rate
    from hr_attrition
    group by
        case 
        when age < 30 then 'Under 30'
        when age between 30 and 40 then '30-40'
        Else 'Above 40' 
    end
order by Attrition_rate desc;

--cobining of strongest factors
--"Overtime and jobsatisfaction"
SELECT
    OverTime,
    JobSatisfaction,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS attrition_rate
FROM hr_attrition
GROUP BY OverTime, JobSatisfaction
ORDER BY attrition_rate DESC;



--"overtime and salary"

SELECT
    OverTime,
    CASE
        WHEN MonthlyIncome < 3000 THEN 'Low Salary'
        WHEN MonthlyIncome BETWEEN 3000 AND 6000 THEN 'Medium Salary'
        ELSE 'High Salary'
    END AS salary_group,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS attrition_rate
FROM hr_attrition
GROUP BY
    overtime,
    CASE
        WHEN MonthlyIncome < 3000 THEN 'Low Salary'
        WHEN MonthlyIncome BETWEEN 3000 AND 6000 THEN 'Medium Salary'
        ELSE 'High Salary'
    END
ORDER BY attrition_rate DESC;

SELECT
    OverTime,jobsatisfaction,
    CASE
        WHEN MonthlyIncome < 3000 THEN 'Low Salary'
        WHEN MonthlyIncome BETWEEN 3000 AND 6000 THEN 'Medium Salary'
        ELSE 'High Salary'
    END AS salary_group,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS attrition_rate
FROM hr_attrition
GROUP BY
    overtime,jobsatisfaction,
    CASE
        WHEN MonthlyIncome < 3000 THEN 'Low Salary'
        WHEN MonthlyIncome BETWEEN 3000 AND 6000 THEN 'Medium Salary'
        ELSE 'High Salary'
    END
ORDER BY attrition_rate DESC;

--"promotion gap"

SELECT
    CASE
        WHEN YearsSinceLastPromotion = 0 THEN 'Recently Promoted'
        WHEN YearsSinceLastPromotion BETWEEN 1 AND 3 THEN '1-3 Years'
        ELSE '4+ Years'
    END AS promotion_group,
    COUNT(*) AS total_employees,
    SUM(
        CASE 
            WHEN Attrition = 'Yes' THEN 1 
            ELSE 0 
        END
    ) AS employees_left,
    ROUND(
        100 * SUM(
            CASE 
                WHEN Attrition = 'Yes' THEN 1 
                ELSE 0 
            END
        ) / COUNT(*),
        2
    ) AS attrition_rate
FROM hr_attrition
GROUP BY
    CASE
        WHEN YearsSinceLastPromotion = 0 THEN 'Recently Promoted'
        WHEN YearsSinceLastPromotion BETWEEN 1 AND 3 THEN '1-3 Years'
        ELSE '4+ Years'
    END
ORDER BY attrition_rate DESC;



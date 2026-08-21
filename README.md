# HR Employee Attrition Analysis

## 1. Project Overview
Employee attrition is one of the most expensive and disruptive problems an organization can face — every employee who leaves takes institutional knowledge, ramp-up investment, and team stability with them. This project uses SQL to analyze an HR dataset of **1,470 employee records** and uncover **which factors are most strongly associated with attrition**, so HR and business leaders can move from guesswork to data-backed retention strategy.

Using Oracle SQL, I queried and segmented employee data across department, compensation, overtime status, job satisfaction, work-life balance, age, and promotion history to build a clear picture of *who* is leaving and *why*.

## 2. Business Questions
This analysis was designed to answer the questions HR and leadership actually care about:

1. What is the company's overall attrition rate?
2. Which departments have the highest attrition, and by how much?
3. Does overtime work meaningfully increase the likelihood of an employee leaving?
4. Does compensation (salary band) affect attrition more than work-life balance — or less?
5. How does job satisfaction correlate with attrition?
6. Are certain age groups more likely to leave than others?
7. Do employees who haven't been promoted in a long time leave at higher rates?
8. What does the "profile" of an employee most likely to quit look like when multiple risk factors combine (e.g., overtime + low satisfaction + low salary)?

## 3. Dataset
The analysis runs on an `hr_attrition` table containing **1,470 employees** and 35 fields per employee, including:

- **Demographics:** Age, Gender, MaritalStatus, DistanceFromHome, Education, EducationField
- **Job details:** Department, JobRole, JobLevel, BusinessTravel, OverTime
- **Compensation:** MonthlyIncome, DailyRate, HourlyRate, MonthlyRate, PercentSalaryHike, StockOptionLevel
- **Satisfaction & engagement:** JobSatisfaction, EnvironmentSatisfaction, RelationshipSatisfaction, WorkLifeBalance, JobInvolvement, PerformanceRating
- **Tenure & career progression:** TotalWorkingYears, YearsAtCompany, YearsInCurrentRole, YearsSinceLastPromotion, YearsWithCurrManager, NumCompaniesWorked, TrainingTimesLastYear
- **Target variable:** `Attrition` (Yes/No)

*(This schema matches the widely used IBM HR Analytics Employee Attrition dataset structure.)*

## 4. Tools & Technologies
- **Oracle SQL** — data querying, aggregation, and segmentation
- **SQL techniques used:** `CASE WHEN` bucketing, conditional aggregation (`SUM(CASE WHEN...)`), `GROUP BY` with derived categories, `ROUND()` for percentage calculations, subqueries with `ROWNUM` for top-N filtering, multi-dimensional `GROUP BY` for combined risk-factor analysis

## 5. SQL Analysis
The analysis was structured in three progressive stages:

**Stage 1 — Data Setup & Overview**
Created the `hr_attrition` table and calculated the baseline: total employees, number who left, and overall attrition rate.

**Stage 2 — Single-Factor Analysis**
Queried attrition rate broken out by one variable at a time:
- Department
- Salary band (Low / Medium / High)
- Overtime status (Yes/No)
- Job satisfaction level (1–Low → 4–Very High)
- Work-life balance rating (1–Bad → 4–Best)
- Age group (Under 30 / 30–40 / Above 40)
- Time since last promotion (Recently Promoted / 1–3 Years / 4+ Years)

**Stage 3 — Multi-Factor & Profile Analysis**
Combined multiple variables in a single query — Overtime + Job Satisfaction, and Overtime + Job Satisfaction + Salary Band — to identify compounding risk factors and pinpoint the specific employee segments with the highest attrition rates.

## 6. Key Findings

**1. Overall company attrition rate**
**16.12%** of employees left the company (237 out of 1,470). This is the baseline every other segment is measured against.

**2. Is overtime the single biggest attrition driver?**
Yes. Employees who work overtime leave at **30.53%**, nearly **3x** the rate of those who don't (**10.44%**) — the largest gap produced by any single factor in this analysis. Overtime is strong enough to override other protective factors: even the *most satisfied* overtime workers still leave at 21.13%, a higher rate than *dissatisfied* employees who don't work overtime (17.56%).

**3. Which department loses the most employees?**
**Sales**, at **20.63%** attrition — followed by Human Resources (19.05%). Research & Development, the largest department by headcount (961 employees), has the lowest attrition at 13.84%, meaning the company's attrition problem is concentrated rather than uniform across departments.

**4. Is salary more important than work-life balance?**
It depends on which end of the scale you look at:
- Employees in the **highest salary band** have the lowest attrition of any segment analyzed — just **4.86%** — lower than even the *best* work-life balance group (17.65%).
- But at the low end, **poor work-life balance does more damage than low pay**: employees rating work-life balance as "Bad" leave at **31.25%**, higher than even the *lowest* salary band (18.36%).
- **Takeaway:** high pay is the strongest single protector against attrition, but a poor work-life balance can drive attrition even higher than being underpaid does — neither factor alone tells the full story.

**5. Profile of the employee most likely to quit**
The highest-risk profile combines three factors: **works overtime + lowest job satisfaction + low salary band** — this group shows an attrition rate of **65.22%**, roughly **4x** the company average and the highest of any segment tested. (This segment is a relatively small sample of 23 employees, so the signal is strong but worth validating against a larger group before driving major policy decisions.)

**Supporting patterns:**
- Attrition falls steadily as job satisfaction rises — from 22.84% (lowest satisfaction) to 11.33% (highest) — a graded, ~2x relationship.
- Employees **under 30** leave at 27.91%, more than double the rate of employees over 40 (11.18%) — attrition risk drops sharply with age.
- Counterintuitively, **recently promoted employees have higher attrition (18.93%) than employees not promoted in 4+ years (13.08%)** — challenging the common assumption that promotion stagnation is the main driver of attrition.

## 7. Conclusion
This analysis shows that employee attrition is rarely driven by a single factor — it's the **combination** of overtime burden, low job satisfaction, and limited compensation that pushes employees toward the exit at dramatically elevated rates (up to 65% in the highest-risk segment, versus a 16% company average). Overtime stands out as the single most powerful individual driver, strong enough to override the usually-protective effect of high job satisfaction. Compensation matters most at the extremes — high pay meaningfully retains employees, but a poor work-life balance can do more damage than low pay alone. Notably, the data challenges the common assumption that "stuck," un-promoted employees are the ones most likely to leave — here, it's the *recently* promoted who show higher attrition, suggesting that promotions alone aren't a sufficient retention lever without addressing overtime and satisfaction as well.

## 8. Business Recommendations

1. **Make overtime reduction the top retention priority**, especially in Sales and HR. With overtime nearly tripling attrition risk on its own — and overriding the benefit of high job satisfaction — auditing workload and staffing levels in high-overtime teams is likely to have the single largest impact of any intervention tested here.

2. **Immediately flag and intervene on the highest-risk segment**: employees working overtime with low job satisfaction and low salary are leaving at 65%. HR should proactively check in with anyone matching this profile rather than waiting for exit interviews.

3. **Treat work-life balance and compensation as separate levers**, not substitutes for one another. A pay increase alone is unlikely to fix attrition driven by poor work-life balance, and vice versa — both should be assessed independently in retention planning.

4. **Re-examine the promotion process** for recently promoted employees — since this group shows *higher* attrition rather than lower, it's worth investigating whether promotions are coming with unsustainable new workloads, unclear role expectations, or insufficient compensation adjustment.

5. **Prioritize early-career retention programs** for the under-30 segment, which shows the highest age-based attrition (27.91%) — mentorship, clearer growth paths, and career-development conversations may reduce early exits more effectively than compensation changes alone.

6. **Build a monthly early-warning dashboard** tracking overtime %, job satisfaction scores, and salary band by department, so HR can identify emerging high-risk segments (like the 65% profile found here) before they show up in resignation numbers.
---
*Analysis performed using Oracle SQL. Full query file: `HR_Attrition_Analysis.sql`*

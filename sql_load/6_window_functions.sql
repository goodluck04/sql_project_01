
-- 1. Rank the Highest Paying Skills
SELECT
    skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary,
    RANK() OVER (
        ORDER BY AVG(salary_year_avg) DESC
    ) AS salary_rank
FROM job_postings_fact
JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short='Data Analyst'
AND salary_year_avg IS NOT NULL
AND job_work_from_home=True
GROUP BY skills
LIMIT 100;

-- 2. Rank the Most Demanded Skills
SELECT
    skills,
    COUNT(*) AS demand,
    DENSE_RANK() OVER(
        ORDER BY COUNT(*) DESC
    ) AS demand_rank
FROM job_postings_fact
JOIN skills_job_dim
ON job_postings_fact.job_id = skills_job_dim.job_id
JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short='Data Analyst'
AND job_work_from_home=True
GROUP BY skills
LIMIT 100;

-- 3. Percentile Ranking (PERCENT_RANK()-Find which skills belong to the top 10–20% by salary.)
SELECT
    skills,
    ROUND(AVG(salary_year_avg),0) avg_salary,
    PERCENT_RANK() OVER(
        ORDER BY AVG(salary_year_avg)
    ) salary_percentile
FROM job_postings_fact
JOIN skills_job_dim
ON job_postings_fact.job_id = skills_job_dim.job_id
JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE salary_year_avg IS NOT NULL
AND job_title_short='Data Analyst'
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 100;

-- 4. Quartile Ranking (NTILE()-Find which skills belong to the top 25% by salary.)
-- Skills are grouped into:

-- Top 25%
-- Upper-middle 25%
-- Lower-middle 25%
-- Bottom 25%
SELECT
    skills,
    ROUND(AVG(salary_year_avg),0) avg_salary,
    NTILE(4) OVER(
        ORDER BY AVG(salary_year_avg) DESC
    ) salary_quartile
FROM job_postings_fact
JOIN skills_job_dim
ON job_postings_fact.job_id = skills_job_dim.job_id
JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE salary_year_avg IS NOT NULL
AND job_title_short='Data Analyst'
GROUP BY skills
LIMIT 1000;

-- 5. Compare Each Skill to the Overall Average Salary
SELECT
    skills,
    ROUND(AVG(salary_year_avg),0) avg_salary,
    ROUND(
        AVG(salary_year_avg)
        - AVG(AVG(salary_year_avg)) OVER (),
    0) salary_difference
FROM job_postings_fact
JOIN skills_job_dim
ON job_postings_fact.job_id = skills_job_dim.job_id
JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE salary_year_avg IS NOT NULL
AND job_title_short='Data Analyst'
GROUP BY skills
ORDER BY avg_salary ASC;

-- 6. Rank Companies by Highest Salary
SELECT
    company_dim.name,
    salary_year_avg,
    DENSE_RANK() OVER(
        ORDER BY salary_year_avg DESC
    ) company_rank
FROM job_postings_fact
JOIN company_dim
ON job_postings_fact.company_id=company_dim.company_id
WHERE job_title_short='Data Analyst'
AND salary_year_avg IS NOT NULL;

-- 7. Rank Jobs Within Each Company
SELECT
    company_dim.name,
    job_title,
    salary_year_avg,
    ROW_NUMBER() OVER(
        PARTITION BY company_dim.name
        ORDER BY salary_year_avg DESC
    ) job_rank
FROM job_postings_fact
JOIN company_dim
ON company_dim.company_id=job_postings_fact.company_id
WHERE salary_year_avg IS NOT NULL;

-- 8. Running Total of Skill Demand
-- You can determine how much of the market demand is covered by the top skills—for example, whether the top five skills account for 60–70% of all skill mentions.
SELECT
    skills,
    COUNT(*) demand,
    SUM(COUNT(*)) OVER(
        ORDER BY COUNT(*) DESC
    ) cumulative_demand
FROM job_postings_fact
JOIN skills_job_dim
ON job_postings_fact.job_id=skills_job_dim.job_id
JOIN skills_dim
ON skills_job_dim.skill_id=skills_dim.skill_id
WHERE job_title_short='Data Analyst'
GROUP BY skills;

-- 9. Salary Gap Between Consecutive Skills
SELECT
    skills,
    ROUND(AVG(salary_year_avg),0) avg_salary,
    LAG(ROUND(AVG(salary_year_avg),0))
    OVER(
        ORDER BY AVG(salary_year_avg)
    ) previous_salary
FROM job_postings_fact
JOIN skills_job_dim
ON job_postings_fact.job_id=skills_job_dim.job_id
JOIN skills_dim
ON skills_job_dim.skill_id=skills_dim.skill_id
WHERE salary_year_avg IS NOT NULL
GROUP BY skills;

-- You can also use LEAD() to compare with the next highest-paying skill.
SELECT
    skills,
    ROUND(AVG(salary_year_avg),0) avg_salary,
    LEAD(ROUND(AVG(salary_year_avg),0))
    OVER(
        ORDER BY AVG(salary_year_avg)
    ) next_salary
FROM job_postings_fact
JOIN skills_job_dim
ON job_postings_fact.job_id=skills_job_dim.job_id
JOIN skills_dim
ON skills_job_dim.skill_id=skills_dim.skill_id
WHERE salary_year_avg IS NOT NULL
GROUP BY skills;

-- 10. Best Value Skills (High Demand + High Salary)
WITH skill_stats AS
(
SELECT
    skills,
    COUNT(*) demand,
    ROUND(AVG(salary_year_avg),0) avg_salary
FROM job_postings_fact
JOIN skills_job_dim
ON job_postings_fact.job_id=skills_job_dim.job_id
JOIN skills_dim
ON skills_job_dim.skill_id=skills_dim.skill_id
WHERE salary_year_avg IS NOT NULL
AND job_title_short='Data Analyst'
GROUP BY skills
)

SELECT *,
RANK() OVER(
ORDER BY demand DESC, avg_salary DESC
) overall_rank
FROM skill_stats;

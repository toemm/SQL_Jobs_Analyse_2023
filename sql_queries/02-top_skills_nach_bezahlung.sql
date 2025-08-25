-- Top Skills die in diesen Top 10 Jobs am meisten gefragt sind

-- Aus queries1.sql

WITH top_jobs AS (

    SELECT
        job_title as job_titel,
        company_dim.name as firma,
        job_via as job_via,
        job_id as job_id,
        salary_year_avg as durchschnittsgehalt,
        job_schedule_type as arbeitszeitmodell,
        job_posted_date::DATE as datum
    FROM
        job_postings_fact
    INNER JOIN
        company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_country IN ('Germany', 'Austria', 'Switzerland') AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 15

)

SELECT
    COUNT(skills_job_dim.skill_id) as skills_anzahl,
    skills_dim.skills as skill_name

FROM
    top_jobs
INNER JOIN skills_job_dim 
    ON top_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id

GROUP BY
    skill_name
ORDER BY
    skills_anzahl DESC;
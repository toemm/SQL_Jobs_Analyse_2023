-- Durchschnittsgehalälter für verschiedene Skills im DACH-Raum

SELECT
    skills_dim.skills as skill_name,    
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) as durchschnittsgehalt
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id 
WHERE
    job_country IN ('Germany', 'Austria', 'Switzerland') 
    AND
    job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
ORDER BY
    durchschnittsgehalt DESC
LIMIT 10;
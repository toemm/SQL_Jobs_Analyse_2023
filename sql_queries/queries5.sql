-- Top in-demand skills UND am besten bezahlte Skills im DACH-Raum

-- aus queries3.sql
-- Top in-demand skills im DACH-Raum
WITH top_skills AS (
    SELECT
        skills_dim.skill_id,
        COUNT(*) as anzahl_skills,
        skills_dim.skills as skill_name
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
),

-- aus queries4.sql
-- Durchschnittsgehalälter für verschiedene Skills im DACH-Raum
skills_salaries AS (
    SELECT
        skills_dim.skill_id,
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
)


SELECT
    top_skills.skill_id,
    top_skills.skill_name,
    top_skills.anzahl_skills,
    skills_salaries.durchschnittsgehalt
FROM top_skills

INNER JOIN skills_salaries
    ON top_skills.skill_id = skills_salaries.skill_id
WHERE
    top_skills.anzahl_skills > 10
ORDER BY
    skills_salaries.durchschnittsgehalt DESC,
    top_skills.anzahl_skills DESC
LIMIT 25;


-- in einem query

SELECT
    skills_dim.skill_id,
    skills_dim.skills as skill_name,
    COUNT(skills_dim.skill_id) as anzahl_skills,
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
HAVING
    COUNT(skills_dim.skill_id) > 10
ORDER BY
    durchschnittsgehalt DESC,
    anzahl_skills DESC
LIMIT 25;
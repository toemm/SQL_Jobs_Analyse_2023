-- Top in-demand skills im DACH-Raum


SELECT
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
GROUP BY
    skills_dim.skill_id
ORDER BY
    anzahl_skills DESC;
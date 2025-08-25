-- Top Jobs im Data-Bereich im DACH-Raum Analyse


-- Welcher Länder sind im Datensatz vorhanden und wie viele Jobs gibt es pro Land?

SELECT
    COUNT(*) as anzahl_jobs,
    job_country as job_land
FROM
    job_postings_fact
GROUP BY
    job_land

-- Liste der Jobs in Deutschland

SELECT DISTINCT
    job_title as job_titel,
    job_via as job_via,
    salary_year_avg as durchschnittsgehalt,
    job_posted_date::DATE as datum
FROM
    job_postings_fact
WHERE
    job_country = 'Germany'
--LIMIT 100;



-- Top 10 Jobs nach Gehalt + Firma
SELECT
    job_title as job_titel,
    company_dim.name as firma,
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
LIMIT 15;



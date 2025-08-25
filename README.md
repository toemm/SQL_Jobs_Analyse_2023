# Einleitung    

Das vorliegende Projekt gibt einen Einblick in den Jobmarkt für Data-Analysis-Jobs im DACH-Raum.
Der zugrundeliegende Datensatz stammt aus dem Jahr 2023, umfasst über 200.000 Einträge und aggregiert Job-Postings aus verschiedenen Quellen.

**Zentrale Fragestellungen:**

- Welche Jobs sind am gefragtesten?

- Welche Positionen gehören zu den bestbezahlten?

- Welche Skills sind am meisten nachgefragt und welche werden am besten vergütet?

Datensatz (2023 Job Postings): [Zum Datensatz](https://drive.google.com/drive/folders/1egWenKd_r3LRpdCf4SsqTeFZ1ZdY3DNx)


# Hintergrund

Ziel der Analyse war es herauszufinden, welche Tools und Technologien sich für die eigene Weiterbildung am meisten lohnen.
Die Hypothese: Es gibt sowohl Kernskills (z. B. Python, SQL), die fast überall gefordert sind, als auch Spezialskills, die zwar seltener vorkommen, aber bei hoher Vergütung besonders attraktiv sein können.

# Tools

- **SQL**: Zum Abfragen der Datenbank.
- **PostgreSQL**: relationaler Datenbankserver, lokal nutzbar, stabil und performant
- **VS Code**: Durch Addons lässt sich die Datenbank einfach verbinden und Abfragen darauf erstellen.
- **Git & GitHub**: Zur Versionskontrolle und Dokumentation.

# Analyse

Jede der folgenden SQL-Abfragen liefert konkrete Einblicke in den DACH-Jobmarkt.

## 1. Top Jobs nach Bezahlung

Zuerst wurden die bestbezahlten Jobs identifiziert.

[Zur SQL-Abfrage](/sql_queries/01-top_jobs_nach_bezahlung.sql)
```sql
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
LIMIT 10;
```

| Job Titel                                                            | Firma         | Gehalt (Ø p.a.) | Arbeitszeitmodell     | Datum      |
| -------------------------------------------------------------------- | ------------- | --------------- | --------------------- | ---------- |
| Senior Ai Research Engineer                                          | Worldcoin     | 224,500 €       | Full-time             | 2023-04-12 |
| Senior Machine Learning Engineer, Computer Vision                    | Worldcoin     | 224,500 €       | Full-time             | 2023-02-16 |
| Software Engineer: Stream Processing                                 | Observe       | 206,000 €       | Full-time             | 2023-02-02 |
| Technology Research Engineer for Power Semiconductors (f/m/div.)     | Bosch Group   | 200,000 €       | Full-time             | 2023-01-31 |
| Research Engineer PEMFC Fuel Cell Stack (f/m/div.)                   | Bosch Group   | 200,000 €       | Full-time             | 2023-01-16 |
| Research Engineer (f/m/div.)                                         | Bosch Group   | 200,000 €       | Full-time             | 2023-01-25 |
| Research Engineer Power Electronics (f/m/div.)                       | Bosch Group   | 200,000 €       | Full-time             | 2023-04-01 |
| Research Engineer for High Performance Cooling of eMobility…         | Bosch Group   | 200,000 €       | Full-time             | 2023-02-16 |
| Research Engineer - Laser Material Processing (f/m/div.)             | Bosch Group   | 200,000 €       | Full-time             | 2023-01-25 |
| Application and Research Engineer for Semiconductor (m/f/d)          | DENSO         | 200,000 €       | Full-time             | 2023-02-03 |
| Research Engineer for Security and Privacy (f/m/div.)                | Bosch Group   | 199,675 €       | Full-time             | 2023-04-28 |
| Research Engineer Bio-MEMS Sensors (f/m/div.)                        | Bosch Group   | 199,675 €       | Full-time             | 2023-04-25 |
| AI and ML Engineer, Lead                                             | Booz Allen H. | 198,000 €       | Part-time & Full-time | 2023-12-22 |
| Senior Data Science Manager – Visa Consulting & Analytics (m/f/div.) | Visa          | 192,000 €       | Full-time             | 2023-03-23 |
| Team Lead Data Scientist / Data Science Manager (f/m/x)              | AUTO1 Group   | 192,000 €       | Full-time             | 2023-03-07 |

**Insights:**
- Worldcoin bietet mit 224.500 € die höchsten Gehälter → vor allem für AI/ML Research Engineers.

- Bosch Group dominiert die Liste: 7 von 15 Stellen, alle um die 200.000 € → Fokus stark auf Research (Halbleiter, Power Electronics, Bio-Sensoren, Security).

- Observe (Stream Processing) ist mit 206.000 € ebenfalls hoch angesiedelt, was zeigt, dass Data Engineering / Realtime Processing auch Spitzengehälter erzielen kann.

## 2. Top Skills nach Bezahlung

Welche Skills tauchen in den bestbezahlten Stellen am häufigsten auf?

[Zur SQL-Abfrage](sql_queries\02-top_skills_nach_bezahlung.sql)

```sql
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
    LIMIT 10
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
```

| Skill      | Anzahl |
| ---------- | ------ |
| Spark      | 9      |
| Python     | 7      |
| GitHub     | 5      |
| AWS        | 3      |
| MongoDB    | 2      |
| C++        | 2      |
| SQL        | 2      |
| Go         | 1      |
| Hadoop     | 1      |
| Keras      | 1      |

**Insights:**

- Spark (9) und Python (7) dominieren → Data Engineering + Data Science Kernkompetenzen.

- GitHub (5) wird stark nachgefragt → zeigt, dass Collaboration & MLOps/DevOps Skills wichtig sind, nicht nur Programmieren.

- Cloud Skills: AWS (3), Azure (1), GCP (1) → Multi-Cloud-Wissen ist gefragt, AWS liegt vorne.

## 3. In-Demand Skills

Welche Skills tauchen insgesamt am häufigsten auf?

[Zur SQL-Abfrage](/sql_queries/02-top_skills_nach_bezahlung.sql)

```sql
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
    anzahl_skills DESC
LIMIT 10;
```

![Anzahl der Jobpostings nach Skill](assets\03_jobs_nach_skills.png)
*Balkendiagramm zur Visualisierung der Anzahl der Jobpostings nach den ausgeschriebenen Skills im DACH-Raum*


**Insights_**

- Python (22.8k) & SQL (19.3k) sind mit Abstand die wichtigsten Kernskills → fast in jeder Rolle ein Muss.

- Cloud Skills sind stark vertreten: Azure (8.3k) führt vor AWS (6.8k) → GCP taucht hier gar nicht in den Top 10 auf → im DACH-Raum klar Microsoft- und AWS-dominiert.

- Data Science Tools: R (7.6k) bleibt wichtig, aber Python ist deutlich voraus → R wird eher in Statistik-/Research-lastigen Rollen gebraucht.

## 4. Skills nach Bezahlung

Welche Skills sind mit den höchsten Durchschnittsgehältern verknüpft?

[Zur SQL-Abfrage](/sql_queries/04-skills_nach_bezahlung.sql)

```sql
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
```

| Skill     | Durchschnittsgehalt (€) |
| --------- | ----------------------- |
| Rust      | 224,500                 |
| FastAPI   | 166,681                 |
| Firebase  | 158,500                 |
| Vue       | 157,500                 |
| Kotlin    | 157,500                 |
| NLTK      | 157,500                 |
| OpenCV    | 156,800                 |
| Keras     | 156,500                 |
| Cassandra | 147,500                 |

**Insights:**

- Rust sticht mit Abstand heraus (224k €) → sehr selten, aber extrem hoch vergütet.

- FastAPI & Firebase (~160k €) zeigen, dass moderne Frameworks/Cloud-Stacks in gut bezahlten Data/AI-Rollen an Bedeutung gewinnen.

- ML/AI Libraries (NLTK, OpenCV, Keras) liegen ebenfalls im oberen Gehaltssegment (~156–157k €), was die starke Nachfrage nach praxisnahen AI-Skills bestätigt.


## 5. Optimale Skills nach Bezahlung und In-Demand

Welche Skills bieten gutes Gehalt UND hohe Nachfrage?

[Zur SQL-Abfrage](/sql_queries/05-optimale_skills.sql)

```sql
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
LIMIT 15;
```

| Skill      | Anzahl | Durchschnittsgehalt (€) |
| ---------- | ------ | ----------------------- |
| Hadoop     | 12     | 146,833                 |
| GitHub     | 15     | 143,411                 |
| Kafka      | 22     | 138,142                 |
| Pandas     | 16     | 137,991                 |
| Airflow    | 26     | 136,894                 |
| Terraform  | 17     | 135,634                 |
| Jenkins    | 14     | 135,536                 |
| BigQuery   | 12     | 135,475                 |
| PySpark    | 13     | 133,271                 |
| Databricks | 15     | 131,073                 |
| Snowflake  | 24     | 130,366                 |
| Spark      | 82     | 128,298                 |
| Redshift   | 19     | 127,919                 |
| AWS        | 67     | 126,901                 |
| TensorFlow | 18     | 126,352                 |


- Hadoop & GitHub (~144–147k €) liegen im oberen Gehaltsbereich, obwohl sie weniger häufig vorkommen → Nischen-Skills können besonders lukrativ sein.

- Spark & AWS sind mit Abstand die am weitesten verbreiteten Skills (82 bzw. 67 Vorkommen), zahlen aber „nur“ im Bereich ~126–128k €, also niedriger als viele Spezialtools.

- Moderne Cloud-/Data-Tools wie Airflow, Terraform, Snowflake und Databricks zeigen solide Nachfrage (10–25 Erwähnungen) mit Gehältern um 130–136k €, was sie zu wichtigen Zukunftsskills macht.


# Fazit

**Seltene Spezial-Skills bringen Spitzengehälter**

- Tools wie Hadoop (146k €) und GitHub (143k €) tauchen zwar weniger oft auf, sind aber stark mit hochbezahlten Rollen verknüpft. → Wer Nischenkompetenz hat, kann überdurchschnittlich verdienen.

**Massenskills wie Spark & AWS sind Pflicht, aber nicht Spitzenzahler**

- Spark (82x, 128k €) und AWS (67x, 127k €) sind die am häufigsten geforderten Skills.

- Sie gehören zum Standardstack, sind aber eher baseline-Skills mit solidem, aber nicht maximalem Gehalt.

**Moderne Cloud- & Orchestrierungs-Tools gewinnen an Bedeutung**

- Airflow, Terraform, Snowflake, Databricks liegen im Mittelfeld (130–136k €) → zeigen klar, dass Cloud-native Data Engineering zunehmend Voraussetzung ist.

**ML/AI-Frameworks sind präsent, aber nicht dominant in Gehältern**

- TensorFlow (~126k €) zahlt solide, aber niedriger als klassische Data Engineering Skills.

- Interpretation: In DACH treiben eher Cloud & Data Pipelines die höchsten Gehälter als reine ML-Frameworks.

## Abschlussgedanken

Das Projekt eignete sich hervorragend, um einen aktuellen Überblick über den Jobmarkt im Bereich Data Analysis zu gewinnen und darauf basierend zu priorisieren, welche Tools und Technologien für die eigene Weiterbildung am relevantesten sind. Gleichzeitig diente es als wertvolle Auffrischung meiner SQL- und Datenbankkenntnisse: Für die Beantwortung der Fragestellungen mussten zahlreiche Abfragen kombiniert sowie eine breite Palette an Aggregierungen, Joins und Funktionen eingesetzt werden.

Als nächster Schritt bietet es sich an, die Analyse auf Jobpostings der Jahre 2023–2025 auszuweiten, um Trends und Entwicklungen im Zeitverlauf sichtbar zu machen. Da entsprechende Datensätze derzeit noch nicht vorliegen, müssten diese entweder selbst generiert (z. B. per Scraping) oder durch externe Quellen beschafft werden.
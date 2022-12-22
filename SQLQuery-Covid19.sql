--CREATE DATABASE--

CREATE DATABASE portfolio_project1; 


--Display Data (Familiarize and observe the data)

SELECT *
FROM portfolio_project1..covid_deaths;

SELECT *
FROM portfolio_project1..covid_vaccinations;


--See Data Type and Size of Table
USE portfolio_project1
EXEC SP_HELP 'covid_deaths';

USE portfolio_project1
EXEC SP_HELP 'covid_vaccinations';

--Change the date format from datetime to date
ALTER TABLE covid_deaths
Add date_converted date;

ALTER TABLE covid_vaccinations
Add date_converted date;

UPDATE covid_deaths
SET date_converted = CONVERT(date, date);

UPDATE covid_vaccinations
SET date_converted = CONVERT(date, date);



--Select data 
SELECT *
FROM portfolio_project1..covid_deaths
WHERE continent = 'asia'
ORDER BY 3,4;

SELECT *
FROM portfolio_project1..covid_vaccinations
WHERE continent = 'asia'
ORDER BY 3,4;

--Total New Death vs New Cases in Asia
SELECT SUM(CAST(new_deaths as int)) as total_new_death, SUM(new_cases) as total_new_cases, SUM(CAST(new_deaths as INT))/SUM(new_cases)*100 as new_death_percentage
FROM portfolio_project1..covid_deaths
WHERE continent ='asia';

--The percentage of infected population
SELECT location, date_converted, population, total_cases, (total_cases/population)*100 as infected_percentage
FROM portfolio_project1..covid_deaths
WHERE continent ='asia'
ORDER BY 1,2

--The percentage of Deaths per population  
SELECT location, date_converted, population, total_deaths, (total_deaths/population)*100 as death_per_population_percentage 
FROM portfolio_project1..covid_deaths
WHERE continent ='asia'
ORDER BY 1,2

--The percentage of Deaths per Total Cases  
SELECT location, date_converted, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_per_cases_percentage 
FROM portfolio_project1..covid_deaths
WHERE continent ='asia'
ORDER BY 1,2

--Highest infection rate in ASIA
SELECT location, population, MAX(CAST(total_cases as int)) as highest_infection_count, MAX(total_cases/population)*100 as highest_infection_rate
FROM portfolio_project1..covid_deaths
WHERE continent ='asia'
GROUP BY location, population
ORDER BY highest_infection_rate desc;

--Highest death count per population in ASIA
SELECT location, MAX(CAST(total_deaths as int)) as highest_death_count, MAX(total_deaths/population)*100 as highest_death_rate
FROM portfolio_project1..covid_deaths
WHERE continent ='asia'
GROUP BY location
ORDER BY highest_death_count desc;


--Finding Percentage of Vaccinated People (Partially Vaccinated, Fully Vaccinated and Not Vaccinated People)
WITH cte_vaccinated as (
SELECT cva.location, cva.date_converted, cde.population, total_vaccinations, people_fully_vaccinated, 
	people_vaccinated as people_partially_vaccinated, 
	(cde.population-((CAST(people_fully_vaccinated as bigint))+(CAST(people_vaccinated as bigint)))) as people_not_vaccinated
FROM portfolio_project1..covid_vaccinations cva
	JOIN portfolio_project1..covid_deaths cde
	ON cva.location=cde.location
	AND cva.date_converted=cde.date_converted
WHERE cva.continent='asia'
)
SELECT *, 
	(people_partially_vaccinated/population)*100 as partially_vaccinated_percentage,
	(people_fully_vaccinated/population)*100 as fully_vaccinated_percentage,
	(people_not_vaccinated/population)*100 as not_vaccinated_percentage
FROM cte_vaccinated
ORDER BY 1,2;










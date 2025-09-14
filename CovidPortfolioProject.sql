select * 
from PortfolioProject.dbo.CovidDeaths
where continent is not null 
order by 3, 4 

--select * 
--from PortfolioProject.dbo.CovidVaccinations
--order by 3, 4


select location, date, total_cases, new_cases, total_deaths, population 
from PortfolioProject.dbo.CovidDeaths
where continent is not null 
order by 1, 2

--looking at total cases vs total deaths
--shows likelihood of dying if you contract covid in Nepal 

select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as PercentagePopulationInfected
from PortfolioProject.dbo.CovidDeaths
where location = 'Nepal' 
order by 1, 2

--Looking at Total Cases Vs Population
--Shows what percentage of population got Covid 
select location, date, population,total_cases,(total_cases/population) *100 as PercentagePopulationInfected
from PortfolioProject.dbo.CovidDeaths
where location = 'Nepal'
order by 1, 2

--what countries have the highest infection rate compared to Population 
select location, population,max(total_cases) as highestInfectionCount, max((total_cases/population)) *100 as 
PercentagePopulationInfected  
from PortfolioProject.dbo.CovidDeaths
where continent is not null 
--where location = 'Nepal'
group by location, population 
order by PercentagePopulationInfected desc

--showing countries with highest death count per population 
--using cast as int because the total_deaths data type is varchar in our database
--there is problem with our data because for location some of them are group by continent because they were null and not country
select location,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject.dbo.CovidDeaths
where continent is not null 
group by location, population 
order by TotalDeathCount desc

--LET'S BREAK THINGS DOWN BY CONTINENT 

--the data is not good because in North America, the total death count is only counting USA and not including Canada. 
select location,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject.dbo.CovidDeaths
where continent is null 
group by location
order by TotalDeathCount desc

--SHOWING THE CONTINTENTS WITH THE HIGHEST DEATH COUNT PER POPULATION 
select continent,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject.dbo.CovidDeaths
--where location like '%states%'
where continent is not null 
group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS 

select sum(new_cases)as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage 
from PortfolioProject.dbo.CovidDeaths
where continent is not null 
--group by date
order by 1, 2 

--total new cases and total deaths by each continent 

select continent, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths
from PortfolioProject.dbo.CovidDeaths
where continent is not null 
group by continent 
order by continent  


--USING COVID VACCINATIONS FILE 

SELECT * 
FROM PortfolioProject..CovidVaccinations


--JOINING THE TABLES TOGETHER USING LOCAITON AD DATE 

SELECT * 
FROM PortfolioProject..CovidDeaths DEA JOIN PortfolioProject..CovidVaccinations VAC
ON DEA.location = VAC.location
AND DEA.DATE= VAC.DATE

--LOOKING AT TOTAL POPULATION VS VACCINATIONS 
SELECT DEA.continent, DEA.LOCATION, DEA.DATE, DEA.population, VAC.new_vaccinations
FROM PortfolioProject..CovidDeaths DEA JOIN PortfolioProject..CovidVaccinations VAC
ON DEA.location = VAC.location
AND DEA.DATE= VAC.DATE
WHERE DEA.CONTINENT IS NOT NULL 
ORDER BY 2, 3

-- PARTION BY 
SELECT 
    DEA.continent, 
    DEA.location, 
    DEA.date, 
    DEA.population, 
    VAC.new_vaccinations, 
    SUM(CONVERT(BIGINT, VAC.new_vaccinations)) OVER (
        PARTITION BY DEA.location 
        ORDER BY DEA.location, DEA.date
    ) AS RollingPeopleVaccinated
FROM 
    PortfolioProject..CovidDeaths DEA 
JOIN 
    PortfolioProject..CovidVaccinations VAC
    ON DEA.location = VAC.location AND DEA.date = VAC.date
WHERE 
    DEA.continent IS NOT NULL 
ORDER BY 
    DEA.location, DEA.date;

    --USE CTE (common table expression is a temporary, named result set) 
    --with Population vs vaccination 
WITH PopvsVac (Continent, Location, Date, 
Population, new_vaccinations, RollingPeopleVaccinated) 
AS (
    SELECT 
        DEA.continent, 
        DEA.location, 
        DEA.date, 
        DEA.population, 
        VAC.new_vaccinations, 
        SUM(CONVERT(BIGINT, VAC.new_vaccinations)) OVER (
            PARTITION BY DEA.location 
            ORDER BY DEA.location, DEA.date
        ) AS RollingPeopleVaccinated
    FROM 
        PortfolioProject..CovidDeaths DEA 
    JOIN 
        PortfolioProject..CovidVaccinations VAC
        ON DEA.location = VAC.location AND DEA.date = VAC.date
    WHERE 
        DEA.continent IS NOT NULL 
)
SELECT *, (RollingPeopleVaccinated /Population) *100
FROM PopvsVac



--TEMP TABLE (temporary table is created and used temporarily during a session or stored procedure)
drop table if exists #PercentPopulationVaccinated

create table #PercentPopulationVaccinated 
(
continent nvarchar (255), 
location nvarchar(255), 
date datetime, 
Population numeric, 
new_vaccinations numeric, 
RollingPeopleVaccinated numeric) 

insert into #PercentPopulationVaccinated
SELECT 
        DEA.continent, 
        DEA.location, 
        DEA.date, 
        DEA.population, 
        VAC.new_vaccinations, 
        SUM(CONVERT(bigint, VAC.new_vaccinations)) OVER (
            PARTITION BY DEA.location 
            ORDER BY DEA.location, DEA.date
        ) AS RollingPeopleVaccinated
    FROM 
        PortfolioProject..CovidDeaths DEA 
    JOIN 
        PortfolioProject..CovidVaccinations VAC
        ON DEA.location = VAC.location AND DEA.date = VAC.date
  --  WHERE DEA.continent IS NOT NULL

SELECT *, (RollingPeopleVaccinated /Population) *100
FROM #PercentPopulationVaccinated

--CREATE A VIEW TO STORE DATA FOR LATER VISUALIZATIONS 

DROP VIEW IF EXISTS PercentPopulationVaccinated;
GO

CREATE VIEW PercentPopulationVaccinated AS
SELECT 
    DEA.continent, 
    DEA.location, 
    DEA.date, 
    DEA.population, 
    VAC.new_vaccinations, 
    SUM(CONVERT(BIGINT, VAC.new_vaccinations)) OVER (
        PARTITION BY DEA.location 
        ORDER BY DEA.location, DEA.date
    ) AS RollingPeopleVaccinated
FROM 
    PortfolioProject..CovidDeaths DEA 
JOIN 
    PortfolioProject..CovidVaccinations VAC
    ON DEA.location = VAC.location AND DEA.date = VAC.date
WHERE 
    DEA.continent IS NOT NULL;

select *
from PercentPopulationVaccinated

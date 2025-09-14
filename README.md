# 🦠 COVID-19 Data Exploration with SQL

This project explores global COVID-19 trends using SQL Server, analyzing data from the `CovidDeaths` and `CovidVaccinations` datasets provided by [Our World in Data](https://ourworldindata.org/coronavirus-source-data).

---

## 📊 Project Objectives

- Understand infection and death trends by country and continent.
- Compare total cases, deaths, and vaccination progress.
- Calculate rolling metrics and percentage rates.
- Use SQL techniques like joins, window functions, CTEs, temp tables, and views.

---

## 🧰 Tools Used

- **SQL Server Management Studio (SSMS)**
- **T-SQL (Transact-SQL)**
- **Data from Our World in Data (OWID)**

---

## 📁 Data Overview

- **CovidDeaths**: Includes total cases, new cases, total deaths, population, location, and date.
- **CovidVaccinations**: Contains vaccination data (e.g., new vaccinations) by location and date.

---

## 📈 Data Insights & Findings

- **Infection Rates**: Small countries like **Andorra** and **San Marino** had the highest infection rates relative to population.
- **Nepal Analysis**: Death rate ranged from **0.5% to 1.5%**, with about **20%** of the population infected at the peak.
- **Global Death Rate**: Averaged around **2–3%** of total reported cases.
- **Highest Death Counts**: The **USA**, **Brazil**, and **India** reported the most total deaths.
- **Continents Impacted**: **Europe** and **North America** had the highest total deaths, though some data (e.g., Canada) was incomplete in continent groupings.
- **Vaccination Rollout**: Developed nations led early efforts. Rolling totals and vaccination percentages were calculated using **window functions** and **temp tables**.

---

## 🧠 Techniques Used

- `JOIN`: Combined `CovidDeaths` and `CovidVaccinations` by location and date.
- `AGGREGATE FUNCTIONS`: Used `SUM()`, `MAX()` to get totals and peak values.
- `WINDOW FUNCTIONS`: Calculated rolling totals of vaccinations.
- `CTEs`: Created readable blocks for intermediate calculations.
- `TEMP TABLES`: Stored data for later reuse and calculations.
- `VIEWS`: Built reusable queries for dashboards or reporting tools.

---

## 📌 Example Queries

### Rolling People Vaccinated (Window Function)

```sql
SUM(CONVERT(BIGINT, VAC.new_vaccinations)) OVER (
    PARTITION BY DEA.location 
    ORDER BY DEA.location, DEA.date
) AS RollingPeopleVaccinated

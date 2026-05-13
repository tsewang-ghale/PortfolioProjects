# COVID-19 Data Exploration with SQL

This project uses SQL Server to explore global COVID-19 case, death, population, and vaccination data. The analysis is based on COVID-19 datasets from Our World in Data and focuses on practical SQL techniques used in data analysis and reporting.

## Project Objectives

- Compare COVID-19 cases, deaths, and population by country
- Calculate infection and death percentages
- Analyze Nepal-specific COVID-19 trends
- Identify countries with high infection rates relative to population
- Summarize death counts by country and continent
- Join death and vaccination tables for population-vaccination analysis
- Create reusable SQL views for later reporting or visualization

## File

| File | Purpose |
| --- | --- |
| `CovidPortfolioProject.sql` | Main SQL script for COVID-19 exploration and vaccination analysis |

## SQL Techniques Used

- `SELECT`, `WHERE`, `ORDER BY`, and filtering
- Aggregate functions including `SUM()` and `MAX()`
- Type conversion with `CAST()` and `CONVERT()`
- `JOIN` across deaths and vaccination tables
- Window functions for rolling vaccination totals
- Common table expressions
- Temporary tables
- SQL views

## Example Analysis Areas

- Total cases vs. total deaths
- Total cases vs. population
- Highest infection rate by country
- Highest death count by country
- Continent-level death totals
- Global case and death totals
- Rolling people vaccinated by country

## Findings Highlighted in the Script

- Nepal-specific queries compare total cases, deaths, and population impact over time.
- Global summary queries calculate total reported cases, total reported deaths, and death percentage.
- Country-level queries identify locations with the highest infection counts and death counts.
- Vaccination queries use rolling totals to compare vaccination progress against population.

## Tools

- SQL Server
- SQL Server Management Studio
- Our World in Data COVID-19 dataset

## Skills Demonstrated

- Data exploration with SQL
- Joining related datasets
- Building reusable analytical queries
- Working with messy real-world data types
- Preparing SQL outputs for dashboards or reporting

## Author

Tsewang Diki Ghale  
GitHub: [tsewang-ghale](https://github.com/tsewang-ghale)

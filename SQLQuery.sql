

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths$
Where continent is NOT NULL
order by 1,2 -- The 1,2 here is referring to the ones up above, in this case it sorts them out by location and date.


-- Total Cases vs Total Deaths
-- Shows likelihood of dying from covid throughout the covid period
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
Where location like '%india%'
order by DeathPercentage DESC;
--order by 1,2
-- The highest death percentage during covid in india was on the lower spectrum which makes it one of the best performing countries in the world.


-- Total Deaths vs Total Population
-- Shows likelihood of dying from covid throughout the covid period
Select location, date, Population, total_deaths, (total_deaths/Population)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
Where location like '%india%'
order by 1,2

-- Total Cases vs Total Population
-- Shows likelihood of dying from covid throughout the covid period
Select location, date, Population,total_cases, (total_cases/Population)*100 as CasePercentage
From PortfolioProject..CovidDeaths$
Where location like '%india%'
order by 1,2


-- Countries with highest infection rate
Select location, Population,Max(total_cases) as HighestInfectionRate, Max((total_cases/Population))*100 as CasePercentage
From PortfolioProject..CovidDeaths$
Group by location, population
order by CasePercentage Desc

-- Countries with highest death rate, Used cast here to cast nvarchar to int so that real data is available.
Select location, Population, Max(cast (total_deaths as int)) as HighestDeathRate
From PortfolioProject..CovidDeaths$
Where continent is NOT NULL
Group by location, population
order by HighestDeathRate Desc

-- Continents with highest deaths rate
Select location, Max(cast (total_deaths as int)) as HighestDeathRate
From PortfolioProject..CovidDeaths$
Where continent is NULL
Group by location
order by HighestDeathRate Desc

-- Continents with highest death counts	per population.
Select location, Max(cast (total_deaths as int)) as HighestDeathRate
From PortfolioProject..CovidDeaths$
Where continent is NULL
Group by location
order by HighestDeathRate Desc

--GLobal Numbers
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
where continent is not null
order by 1,2

-- LOOKING AT TOTAL POPULATION VS VACCINATIONS
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null AND vac.location like '%india%'
order by 1,2,3

-- USE CTE

With PopsvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null AND vac.location like '%india%'
--order by 1,2,3
)
SELECT *
From PopsvsVac

--Creating View for Visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3

Select *
From PercentPopulationVaccinated
Select *
From [Portfolio Project]..Coviddeaths
where continent is not null
Order by 3,4

Select *
From [Portfolio Project]..CovidVaccinations
Order by 3,4

Select Location,date,total_cases,total_deaths,new_cases,population
From [Portfolio Project]..Coviddeaths
Order by 1,2


--Looking at total cases vs total deaths - how many people got diagnosed and what was the percentage of that.

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
From [Portfolio Project]..Coviddeaths
Order by 1,2

--Looking at the total cases vs the population
--Shows what percentage of population got covid

Select Location, date, total_cases,population, (total_cases/population)*100 As PercentOfpopulationaffected
From [Portfolio Project]..Coviddeaths
Where location like '%Pakistan%'
Order by 1,2


-- Looking at countries have the highest infection rate compared to population.

Select Location,population, Max(total_cases), Max((total_cases/population))*100 As PercentOfpopulationaffected
From [Portfolio Project]..Coviddeaths
Group by
Population,location
Order by PercentOfpopulationaffected desc

--Showing countries with highest death count per population
Select Location, Max(cast(total_deaths as int)) AS totaldeathcount
From [Portfolio Project]..Coviddeaths
where continent is not null
Group by location
Order by
totaldeathcount desc

-- Let's break things down by continent.
Select continent, Max(cast(total_deaths as int)) AS TotalDeathCount
From [Portfolio Project]..Coviddeaths
where continent is not null
Group by continent
Order by
totaldeathcount desc

-- showing the continents with highest death counts

Select continent, Max(total_deaths) AS MaxDeathCountPerContinent
From [Portfolio Project]..Coviddeaths
Group by Continent
Order by 
MaxDeathCountPerContinent desc

-- Global Numbers
Select Sum(new_cases) as totalcases, SUM(cast(new_deaths as int)) as totaldeaths, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From [Portfolio Project]..Coviddeaths
--Where location like '%Pakistan%'
where continent is not null
--Group by Date
Order by 1,2


--Vaccination table Joining Death Table

Select * From
[Portfolio Project]..Coviddeaths dea
Join [Portfolio Project]..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date 

--Looking at total population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations )) OVER (Partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
FROM [Portfolio Project]..Coviddeaths dea
Join [Portfolio Project]..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date 
where dea.continent is not null
Order by 2,3

--USE CTE
With PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations )) OVER (Partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
FROM [Portfolio Project]..Coviddeaths dea
Join [Portfolio Project]..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date 
where dea.continent is not null
--Order by 2,3
)
Select * ,(Rollingpeoplevaccinated/population)*100
From
popvsvac


-- Creating view to store data for later visualisation

Create view Percentpopulationvaccinated as  
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations )) OVER (Partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
FROM [Portfolio Project]..Coviddeaths dea
Join [Portfolio Project]..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date 
where dea.continent is not null
--Order by 2,3

Create view Populationofpercentvaccinated as  
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations )) OVER (Partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
FROM [Portfolio Project]..Coviddeaths dea
Join [Portfolio Project]..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date 
where dea.continent is not null
--Order by 2,3

Select*From
Percentpopulationvaccinated
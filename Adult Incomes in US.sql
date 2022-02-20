SELECT *
FROM PortfoiloProject.dbo.adult

-- Looking at different Workclasses and the total count of each class


SELECT  workclass, COUNT(workclass) WorkClass_count
FROM PortfoiloProject.dbo.adult
WHERE workclass <> '?'
GROUP BY workclass
ORDER BY WorkClass_count DESC


-- Identifying the precentage of "high income" making > 50K versus "low income" making 50k or less
SELECT Income_label,	
	   COUNT(Income_label)Income_label_count,
	   COUNT(Income_label) * 100.0 / (SELECT COUNT(Income_label) FROM PortfoiloProject.dbo.adult) Income_label_Percent
FROM PortfoiloProject.dbo.adult
GROUP BY Income_label


-- Identifying how much each native country adds up of the total workforce 
SELECT native_country,	
	   COUNT(native_country) native_country_count,
	   COUNT(native_country) * 100.0 / (SELECT COUNT(native_country) FROM PortfoiloProject.dbo.adult) native_country_Percent
FROM PortfoiloProject.dbo.adult
WHERE native_country <> '?'
GROUP BY native_country
ORDER BY native_country_Percent DESC


/* Looking deeper into US data */


--Identifying Adults' income in relation to gender

WITH CTE_IncomeToSex AS
(Select *,
    CASE
		WHEN Income_label  = '>50k' 
		AND sex = 'male'  THEN 'high-income-male'
		WHEN Income_label  = '<=50k' 
		AND sex = 'male'  THEN 'low-income-male'
		WHEN Income_label  = '>50k'  
		AND sex = 'female'  THEN 'high-income-female'
		WHEN Income_label  = '<=50k' 
		AND sex = 'female'  THEN 'low-income-female'
	END AS income_sex
 FROM PortfoiloProject.dbo.adult
 WHERE native_country = 'united-states')
			SELECT DISTINCT income_sex, 
				   COUNT(income_sex) total_count 
			FROM CTE_IncomeToSex
			GROUP BY income_sex
			ORDER BY total_count DESC


-- Creating a Procedure generating results related to sex, education and workclass
CREATE PROCEDURE US_income_to
(
 @Sex nvarchar(50), 
 @Education nvarchar(50),
 @Workclass nvarchar(50)
) 
	AS
		Select *,
				CASE
				WHEN Income_label  = '>50k' 
				AND sex = 'male'  THEN 'high-income-male'
				WHEN Income_label  = '<=50k' 
				AND sex = 'male'  THEN 'low-income-male'
				WHEN Income_label  = '>50k'  
				AND sex = 'female'  THEN 'high-income-female'
				WHEN Income_label  = '<=50k' 
				AND sex = 'female'  THEN 'low-income-female'
				END AS income_sex
		 FROM PortfoiloProject.dbo.adult
		 WHERE native_country = 'united-states'
		 AND sex = @SEX
		 AND Education = @Education
		 AND workclass = @Workclass


EXEC US_income_to @education = 'Bachelors', @SEX = 'male', @Workclass= 'Private';

EXEC US_income_to @education = 'Masters', @SEX = 'male', @Workclass= 'Self-emp-not-inc';


-- Occupation in relation to high and low income 
SELECT occupation, Income_label, COUNT (Income_label) num_occupation, sex
FROM (
Select *,
				CASE
				WHEN Income_label  = '>50k' 
				AND sex = 'male'  THEN 'high-income-male'
				WHEN Income_label  = '<=50k' 
				AND sex = 'male'  THEN 'low-income-male'
				WHEN Income_label  = '>50k'  
				AND sex = 'female'  THEN 'high-income-female'
				WHEN Income_label  = '<=50k' 
				AND sex = 'female'  THEN 'low-income-female'
				END AS income_sex
		 FROM PortfoiloProject.dbo.adult) Adults
		 WHERE native_country = 'united-states'
		 GROUP BY occupation, Income_label, sex
		 ORDER BY Income_label DESC , num_occupation DESC

-- Identifying occupations with highest count for high and low income Adults   
SELECT occupation, Income_label, COUNT (Income_label) num_occupation
FROM PortfoiloProject.dbo.adult
WHERE occupation <> '?'
GROUP BY Income_label,occupation
ORDER BY Income_label DESC,num_occupation DESC
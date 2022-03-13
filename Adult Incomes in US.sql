SELECT *
FROM PortfoiloProject.dbo.adult

-- Looking at different Workclasses and the total count of each class


SELECT  workclass, COUNT(workclass) WorkClass_count
FROM PortfoiloProject.dbo.adult
GROUP BY workclass
ORDER BY WorkClass_count DESC

-- replacing '?' values with the overwhelmingly common value 'Private'
UPDATE 
    PortfoiloProject.dbo.adult
SET
    workclass = REPLACE(workclass, '?','Private')


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
GROUP BY native_country
ORDER BY native_country_Percent DESC

-- replacing '?' values with the overwhelmingly common value 'United-States'
UPDATE 
    PortfoiloProject.dbo.adult
SET
    native_country = REPLACE(native_country, '?','United-States')



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


-- Creating a Procedure generating results related to occupation, education and workclass
CREATE PROCEDURE US_Income_
(
 @Education nvarchar(50),
 @Workclass nvarchar(50),
 @occupation nvarchar(50)
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
		 AND Education = @Education
		 AND workclass = @Workclass
		 AND occupation = @occupation 


EXEC US_Income_ @education = 'Bachelors', @occupation = 'Prof-specialty', @Workclass= 'Private';

EXEC US_Income_ @education = 'Masters', @occupation = 'Exec-managerial', @Workclass= 'Self-emp-not-inc';


-- Identifying occupations with highest count for high and low income Adults   
SELECT occupation, Income_label, COUNT (Income_label) num_occupation
FROM PortfoiloProject.dbo.adult

GROUP BY Income_label,occupation
ORDER BY Income_label DESC,num_occupation DESC

-- replacing '?' values with the 'Not Available'
UPDATE 
    PortfoiloProject.dbo.adult
SET
    occupation = REPLACE(occupation, '?','Not Available')


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


## DATA CLEANING PROJECT

## STEPS
## 1. REMOVE DUPLICATES
## 2. STANDARDIZE THE DATA
## 3. NULL VALUES OR BLANK VALUES
## 4. REMOVE ANY COLUMNS OR ROWS

SELECT *
FROM world_layoffs.layoffs;

## 1. REMOVE DUPLICATES

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM world_layoffs.layoffs_staging;

INSERT world_layoffs.layoffs_staging
SELECT *
FROM world_layoffs.layoffs;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, 
				  percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM world_layoffs.layoffs_staging
WHERE company = 'Casper';

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM world_layoffs.layoffs_staging2;

INSERT INTO world_layoffs.layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, 
				  percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoffs_staging;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE row_num > 1;

DELETE
FROM world_layoffs.layoffs_staging2
WHERE row_num > 1;

## 2. STANDARDIZE THE DATA

SELECT *
FROM world_layoffs.layoffs_staging2;

SELECT company, TRIM(company)
FROM world_layoffs.layoffs_staging2;

UPDATE world_layoffs.layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2
ORDER BY 1;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE world_layoffs.layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT location
FROM world_layoffs.layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country
FROM world_layoffs.layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country
FROM world_layoffs.layoffs_staging2
WHERE country LIKE 'United States%';

UPDATE world_layoffs.layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM world_layoffs.layoffs_staging2;

UPDATE world_layoffs.layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE world_layoffs.layoffs_staging2
MODIFY COLUMN `date` DATE;

## 3. NULL VALUES OR BLANK VALUES

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE world_layoffs.layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL 
OR industry = '';

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company = 'Airbnb';

SELECT table1.industry, table2.industry
FROM world_layoffs.layoffs_staging2 AS table1
JOIN world_layoffs.layoffs_staging2 AS table2
	ON table1.company = table2.company
    AND table1.location = table2.location
WHERE table1.industry IS NULL
AND table2.industry IS NOT NULL;

UPDATE world_layoffs.layoffs_staging2 AS table1
JOIN world_layoffs.layoffs_staging2 AS table2
	ON table1.company = table2.company
    AND table1.location = table2.location
SET table1.industry = table2.industry
WHERE table1.industry IS NULL 
AND table2.industry IS NOT NULL;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company LIKE 'Bally%';

## 4. REMOVE ANY COLUMNS OR ROWS

SELECT *
FROM world_layoffs.layoffs_staging2;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE world_layoffs.layoffs_staging2
DROP COLUMN row_num;

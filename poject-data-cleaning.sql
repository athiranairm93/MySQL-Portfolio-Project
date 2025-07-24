-- Data Cleaning --
# Created new schema/DB then imported csv file using table data import wizard by right clicking tables
# Company name, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
SELECT * FROM layoffs;
-- Remove Duplicates
-- Standardize the data
-- Remove null or blank values
-- remove unnecessary cols or rows

create table layoffs_stagging
like layoffs; #create table like layoffs to work with, this only create blank table with cols only

#this only create blank table with cols only --no data
select * from layoffs_stagging;

#copying data from layoffs table to working table
insert into layoffs_stagging
select * from layoffs;

select * from layoffs_stagging;

-- Remove Duplicates --

-- Identifying Duplicates: If you have rows in layoffs_stagging where the company, industry, total_laid_off, percentage_laid_off, and date columns are identical--
-- then ROW NUMBE will apply one  to the first occurrence of that combination, 2 to the second, 3 to the third, and so on, all within the same partition --
-- By assigning a row_num, you can easily filter for rows where row_num > 1 to find the duplicate entries. You could then use a DELETE statement 
 -- (often within a Common Table Expression - CTE, or a subquery) --
 -- to remove these duplicate rows, keeping only one unique entry for each combination of the specified columns (typically row_num = 1). --

with duplicate_cte as
(
select *, 
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_stagging
)
select * from duplicate_cte
where row_num > 1;

select * from layoffs_stagging where company = 'Casper';
#Created new table by right clicking existing table and using copying clipboard and add extra column called row_num
#adding data to new table along with row num 

insert into layoffs_stagging2
select *, 
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_stagging;

select * from layoffs_stagging2;
select * from layoffs_stagging2 where row_num > 1;
#removing duplicates
delete from layoffs_stagging2 where row_num > 1;
select * from layoffs_stagging2 where row_num > 1;
select * from layoffs_stagging2;

-- Standardize the data
select * from layoffs_stagging2;
select company, trim(company) from layoffs_stagging2;

#removed white spaces from company col
update layoffs_stagging2
set company = trim(company);
select * from layoffs_stagging2;

#updating cryto curency to crypto only as both are same
select * from layoffs_stagging2 where industry like 'crypto%';
update layoffs_stagging2
set industry = 'Crypto'
where industry like 'crypto%';
select distinct(industry) from layoffs_stagging2;

select distinct country, trim(trailing '.' from country)
from layoffs_stagging2;

update layoffs_stagging2
set country = trim(trailing '.' from country)
where industry like 'United States%';

select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_stagging2;

update layoffs_stagging2
set `date` = str_to_date(`date`, '%m/%d/%Y');
select * from layoffs_stagging2;

#To change date type from text to date in schema section
ALTER TABLE layoffs_stagging2
Modify COLUMN date DATE;

select * from layoffs_stagging2;

select *
from layoffs_stagging2
where industry is null
or industry = '';

#Here we want to populate travel industry to the top row where industry is blank
select *
from layoffs_stagging2
where company = 'Airbnb';
#Here we want to populate travel industry to the top row where industry is blank
select t1.industry, t2.industry from layoffs_stagging2 t1
join layoffs_stagging2 t2
on t1.company = t2.company
and t1.location = t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

#Here we want to populate travel industry to the top row where industry is blank
update layoffs_stagging2
set industry = null
where industry = '';

update layoffs_stagging2 t1
join layoffs_stagging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

#deleteing unnessary
delete
from layoffs_stagging2
where total_laid_off is null
and percentage_laid_off is null;

select *
from layoffs_stagging2;

alter table layoffs_stagging2
drop column row_num;

select *
from layoffs_stagging2;
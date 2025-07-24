-- Exploratory data analysis --
select *
from layoffs_stagging2;

select max(total_laid_off), max(percentage_laid_off) from layoffs_stagging2;
select * from layoffs_stagging2 where percentage_laid_off = 1 order by total_laid_off desc ;
select * from layoffs_stagging2 where percentage_laid_off = 1 order by funds_raised_millions desc ;
select company, location, total_laid_off from layoffs_stagging2 order by total_laid_off desc limit 5;

#Total laid of company wise, max is amazon
select company, sum(total_laid_off)
from layoffs_stagging2
group by company
order by 2 desc;

select min(`date`), max(`date`)
from layoffs_stagging2;

#Total laid of in each industry from highest to lowest
select industry, sum(total_laid_off)
from layoffs_stagging2
group by industry
order by 2 desc;

#Total laid of made by each country from highest to lowest
select country, sum(total_laid_off)
from layoffs_stagging2
group by country
order by 2 desc;

#Total laid of each year
select year(`date`), sum(total_laid_off)
from layoffs_stagging2
group by year(`date`)
order by 1 desc;

#Total laid of 
select stage, sum(total_laid_off)
from layoffs_stagging2
group by stage
order by 2 desc;

#rolling total based on month
select substring(`date`,1,7) as Months, sum(total_laid_off)
from layoffs_stagging2
where substring(`date`,1,7) is not null
group by Months
order by 1;

with rolling_sum as
(
select substring(`date`,1,7) as Months, sum(total_laid_off) rolling_total
from layoffs_stagging2
where substring(`date`,1,7) is not null
group by Months
order by 1
)
select Months, rolling_total, sum(rolling_total) over (order by Months) from rolling_sum;
-- --
#Max total laid of by companies each year based on highest ranking
with company_year (company, years, total_laid_off) as
(
select company, year(date), sum(total_laid_off)
from layoffs_stagging2
#where year(date) is not null
group by company, year(date)
), company_year_rank as
(
select *, dense_rank() over(partition by years order by total_laid_off desc) ranking
from company_year
where years is not null
)
select * from company_year_rank where ranking <=5;

-- --
select *
from layoffs_stagging2;

select DATE_FORMAT(`date`, '%M') AS Months from layoffs_stagging2;

with company_month (company, Months, total_laid_off) as
(
select company, DATE_FORMAT(`date`, '%M') AS Months, sum(total_laid_off)
from layoffs_stagging2
group by company, Months
), company_month_rank as
(
select *, dense_rank() over(partition by Months order by total_laid_off desc) ranking
from company_month
where Months is not null
)
select * from company_month_rank where ranking <=5;

select *
from layoffs_stagging2;

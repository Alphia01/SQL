#Basic Queries

show tables;
desc sales;
select * from sales;
select SaleDate, Amount, Customers from sales;

#Calculations in queries

select SaleDate, Amount, Boxes, Amount / Boxes 'Amount per Boxes' from sales;

#Where clause & Order by

select * from sales
where Amount > 10000;

select * from sales
where Amount > 10000
order by Amount;

select * from sales
where Amount > 10000
order by Amount desc;

select * from sales
where GeoID = 'G1'
order by PID, Amount desc;

select * from sales
where Amount > 10000 and SaleDate > '2021-12-31';

select SaleDate, Amount from Sales
where Amount > 10000 and year(SaleDate) = 2022
order by Amount desc;

select * from sales
where Boxes > 0 and Boxes <= 50;

select * from sales
where Boxes between 0 and 50;

select SaleDate, Amount, Boxes, weekday(SaleDate) 'Day of Week' from sales
where weekday(SaleDate) = 4;

select * from people;

select * from people
where Team = 'Delish' or Team = 'Jucies';

select * from people
where Team in ('Delish','Jucies');

#Pattern Matching

select * from people 
where salesperson like 'B%';

select * from people
where Salesperson like '%B%';

select * from sales;

#Case Operator

select SaleDate, Amount,
	   case when Amount < 1000 then 'Under 1k'
			when Amount < 5000 then 'Under 5k'
            when Amount < 10000 then 'Under 10k'
            else '10k or More'
		end as 'Amount Category'
from sales;

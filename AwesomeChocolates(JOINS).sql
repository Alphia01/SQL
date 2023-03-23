#MJoining two tables

select * from sales;

select * from people;

select * from products;

select * from geo;

select s.SaleDate, s.Amount, p.Salesperson from sales as s
join people as p on p.SPID = s.SPID;

select s.SaleDate, s.Amount, p.Product from sales as s
left join products as p on p.PID = s.PID;

#Joining multiple tables

select s.SaleDate, s.Amount, p.Salesperson, pr.Product from sales as s
join people as p on p.SPID = s.SPID
join products as pr on pr.PID = s.PID;

#Conditions with Joins

select s.SaleDate, s.Amount, p.Salesperson, pr.Product, p.Team from sales as s
join people as p on p.SPID = s.SPID
join products as pr on pr.PID = s.PID
where Amount < 1000 and p.Team = 'Delish';

select s.SaleDate, s.Amount, p.Salesperson, pr.Product, p.Team from sales as s
join people as p on p.SPID = s.SPID
join products as pr on pr.PID = s.PID
where Amount < 1000 and p.Team = '';

select s.SaleDate, s.Amount, p.Salesperson, pr.Product, p.Team, g.Geo from sales as s
join people as p on p.SPID = s.SPID
join products as pr on pr.PID = s.PID
join geo as g on g.GeoID = s.GeoID
where Amount < 1000 and p.Team = ''
and Geo = 'India' or 'New Zealand'
order by SaleDate;

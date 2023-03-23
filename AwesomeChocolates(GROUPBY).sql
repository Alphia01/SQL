#GroupBy and Aggregations

select GeoID, sum(Amount), avg(Amount), sum(Boxes) from Sales
group by GeoID;

select g.Geo, sum(Amount), avg(Amount), sum(Boxes) from Sales as s
join Geo as g on g.GeoID = s.GeoID
group by Geo
order by Geo;

select pr.Category, p.Team, sum(Amount), sum(Boxes) from Sales as s
join products as pr on pr.PID = s.PID
join people as p on p.SPID = s.SPID
where p.Team <> ''
group by Category, Team
order by Category;

select pr.Product, sum(Amount) 'Total Amount' from Sales as s
join products as pr on pr.PID = s.PID
group by Product
order by sum(Amount) desc
limit 10;
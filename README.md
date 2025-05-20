# THIS IS A *PRACTICE QUERY AND OUTPUT STACK*


```sql
%%sql

select
	-- s.productkey,
	s.orderdate,
	round((s.netprice * s.quantity * s.exchangerate)::numeric, 2) as net_revenue,
	case
		when round((s.netprice * s.quantity * s.exchangerate)::numeric, 2) < 500 then 'Low Revenue'
		when round((s.netprice * s.quantity * s.exchangerate)::numeric, 2) between 500 and 1500 then 'Medium Revenue'
		when round((s.netprice * s.quantity * s.exchangerate)::numeric, 2) > 500 then 'High Revenue'
	end as "revenue category",
	c.givenname,
	c.surname,
	c.countryfull,
	c.continent,
	p.productname,
	p.manufacturer,
	p.categoryname
from 
	sales s
left join
	customer c on s.customerkey = c.customerkey
left join
	product p on s.productkey = p.productkey
where 
	extract(year from orderdate) >= 2020
limit
	3
```
|index|orderdate|net\_revenue|revenue category|givenname|surname|countryfull|continent|productname|manufacturer|categoryname|
|---|---|---|---|---|---|---|---|---|---|---|
|0|2020-01-01|"99\.47"|Low Revenue|Heike|Burger|Germany|Europe|MGS Bicycle Card Games2009 E166|Tailspin Toys|Games and Toys|
|1|2020-01-01|"139\.97"|Low Revenue|Heike|Burger|Germany|Europe|MGS Bicycle Board Games2009 E165|Tailspin Toys|Games and Toys|
|2|2020-01-01|"669\.39"|Medium Revenue|Heike|Burger|Germany|Europe|Proseware Wireless Photo All-in-One Printer M390 Grey|Proseware, Inc\.|Computers|

---
---

```sql
select 
	orderdate,
	count(distinct customerkey) as "Total Customers"
from
	sales
where 
	orderdate between '2015-06-01' and '2016-06-01'
group by
	orderdate
order by
	orderdate
limit
  3
```
|index|orderdate|Total Customers|
|---|---|---|
|0|2015-06-01|6|
|1|2015-06-02|7|
|2|2015-06-03|10|

![](1.png)

---
---

```sql

```
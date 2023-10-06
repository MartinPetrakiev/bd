--- |1| ---
select model,speed as 'MHz',hd as 'GB' from pc where price < 1200;
select distinct maker from product where type = 'Printer';
select model,ram,screen from laptop where price > 1000;
select prod.maker as printer_manufacturer, prt.model, prt.type ,prt.price from printer prt inner join product prod on prt.model = prod.model where prt.color = 'y';
select model, speed as MHz, hd as GB from pc where (cd = '12x' or cd = '16x') and price < 2000;

--- |2| ---
--2.1
select prod.maker, prod.model, lpt.speed as "MHz" from product as prod
inner join laptop as lpt on lpt.model = prod.model
where lpt.hd > 9;
--2.2
select 'Laptop' AS product_type,model,price from laptop
where model in (select model from product as prod where maker = 'B')
union
select 'PC' AS product_type,model,price from pc
where model in (select model from product as prod where maker = 'B')
union
select 'Printer' AS product_type,model,price from printer
where model in (select model from product as prod where maker = 'B');
--2.3
select distinct p1.maker from product as p1
where p1.type = 'Laptop'
and not exists (
    select 1
    from product p2
    where p2.maker = p1.maker
    and p2.type = 'PC'
);
--2.4
select hd from pc group by hd having count(distinct code)>=2;
--2.5
select distinct pc1.model,pc2.model from pc as pc1
inner join pc as pc2 on pc1.model < pc2.model
where pc1.speed = pc2.speed and pc1.ram = pc2.ram;
--2.6
select product.maker from product
inner join pc on pc.model = product.model
where pc.speed >= 400
group by product.maker
having count(distinct product.model) >= 2;

--- |3| ---
--3.1
select distinct p.maker from product as p
inner join pc on pc.model = p.model
where pc.speed > 500;
--3.2
select prt.code,prt.model,prt.price from printer as prt
where prt.price = (select max(prt2.price) from printer as prt2);
--3.3
select lpt.code,p.maker,lpt.model,lpt.speed from laptop as lpt
inner join product as p on p.model = lpt.model
where lpt.speed <= (select min(pc.speed) from pc);
--3.4
select top 1 prod.type, prod.maker, combinedProducts.model, price
from (
	select model,price from pc
	union all
	select model,price from laptop
	union all
	select model,price from printer
) as combinedProducts
inner join product as prod on prod.model = combinedProducts.model
order by price desc;
--3.5
select top 1 prod.maker from product as prod
inner join printer as prt on prt.model = prod.model
where prt.color ='Y'
order by price asc;
--3.6
select distinct prod.maker from pc
inner join product as prod on prod.model = pc.model
where pc.ram = (
	select min(ram) from pc
	where speed = (
		select max(speed) from pc
	)
);


--- |4| ---
--4.1
select p.maker, p.model, p.type from product as p
where p.model not in (
	select pc.model from pc
	union
	select prt.model from printer as prt
	union
	select lpt.model from laptop as lpt
);
--4.2
select distinct p1.maker from product as p1
inner join product as p2 on p2.maker = p1.maker
where p1.type = 'Laptop' and p2.type = 'Printer';
--4.3
select distinct hd from laptop
group by hd
having count(distinct model) >= 2;
--4.4
select pc.model from pc
where pc.model not in (
	select p.model from product as p
	where p.type = 'PC'
);

---|5| ---
--5.1
select avg(speed) as AvgSpeed from pc;
--5.2
select p.maker, avg(screen) as AvgScreen from product as p
inner join laptop as lpt on lpt.model = p.model
group by p.maker;
--5.3
select avg(speed) as AvgSpeed from laptop
where price > 1000;
--5.4
select p.maker, avg(pc.price) as AvgPrice from pc
inner join product as p on p.model = pc.model
where p.maker = 'A'
group by p.maker;
--5.5
select p.maker, avg(g.price) as AvgPrice from product as p
inner join (
	select pc.model, pc.price from pc
	union all
	select lpt.model, lpt.price from laptop as lpt
) as g on g.model = p.model
where p.maker = 'B'
group by p.maker;
--5.6
select speed, avg(price) as AvgPrice from pc
group by speed;
--5.7
select p.maker, count(pc.code) as number_of_pc from product as p
inner join pc on pc.model = p.model
group by p.maker
having count(distinct pc.code) >= 3;
--5.8
select top 1 p.maker, max(pc.price) as max_price from product as p
inner join pc on pc.model = p.model
group by p.maker;
--5.9
select pc.speed, avg(pc.price) as AvgPrice from pc
where pc.speed > 800
group by pc.speed;
-- 5.10
select p.maker, avg(pc.hd) as AvgHDD from product as p
inner join pc on pc.model = p.model
where p.maker in (
	select distinct p2.maker from product as p2
	inner join printer as prt on prt.model = p2.model
)
group by p.maker;

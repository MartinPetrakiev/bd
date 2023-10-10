--- |1| ---
select CLASS, COUNTRY from CLASSES where NUMGUNS < 10;
select NAME as shipName from SHIPS where LAUNCHED < 1918;
select outc.SHIP as shipName, b.NAME, convert(varchar, b.DATE, 103)as battleDate from OUTCOMES outc inner join BATTLES b on b.NAME = outc.BATTLE  where RESULT = 'sunk';
select NAME as shipName from SHIPS where NAME = CLASS;
select NAME as shipName from SHIPS where NAME like 'R%';
select NAME as shipName from SHIPS where NAME like '% %';

--- |2| ---
--2.1
select NAME as shipName from SHIPS
inner join CLASSES on CLASSES.CLASS = SHIPS.CLASS
where CLASSES.DISPLACEMENT	> 50000;
--2.2
select SHIPS.NAME,CLASSES.DISPLACEMENT,CLASSES.NUMGUNS from SHIPS
inner join OUTCOMES on OUTCOMES.SHIP = SHIPS.NAME
inner join CLASSES on CLASSES.CLASS = SHIPS.CLASS
where OUTCOMES.BATTLE = 'Guadalcanal';
--2.3
select COUNTRY from CLASSES
where TYPE in ('bb','bc')
group by COUNTRY having count(distinct TYPE) = 2;
--2.4
select distinct S1.NAME from SHIPS as S1
inner join OUTCOMES as O1 on S1.NAME = O1.SHIP
inner join BATTLES as B1 on O1.BATTLE = B1.NAME
where O1.RESULT = 'damaged'
and S1.NAME in (
    select distinct S1.NAME
    from SHIPS as S2
    inner join OUTCOMES as O2 on S2.NAME = O2.SHIP
    inner join BATTLES B2 ON O2.BATTLE = B2.NAME
    where O2.RESULT <> 'damaged' and B2.DATE > B1.DATE
);

--- |3| ---
--3.1
select distinct cls.COUNTRY from CLASSES as cls
where cls.NUMGUNS = (select max(NUMGUNS) from CLASSES);
--3.2
select distinct cls.CLASS from CLASSES as cls
inner join SHIPS as shp on shp.CLASS = cls.CLASS
inner join OUTCOMES as oc on oc.SHIP = shp.NAME
where oc.RESULT = 'sunk';
--3.3
select shp.NAME, cls.CLASS from SHIPS as shp
inner join CLASSES as cls on cls.CLASS = shp.CLASS
where cls.BORE = 16;
--3.4
select btt.NAME from SHIPS as shp
inner join OUTCOMES as oc on oc.SHIP = shp.NAME
inner join BATTLES as btt on btt.NAME = oc.BATTLE
where shp.CLASS = 'Kongo';
--3.5
select shp.CLASS, shp.NAME from SHIPS as shp
inner join CLASSES as cls on cls.CLASS = shp.CLASS
where cls.NUMGUNS >= all (
	select cls2.NUMGUNS from SHIPS as shp2
	inner join CLASSES as cls2 on cls2.CLASS = shp2.CLASS
	where cls.BORE = cls2.BORE
)
order by shp.CLASS asc;

--- |4| ---
--4.1
select shp.NAME as SHIP_NAME, shp.CLASS as SHIP_CLASS, shp.LAUNCHED, c.*
from SHIPS as shp
left join CLASSES as c on c.CLASS = shp.CLASS;
--4.2
select shp.NAME as SHIP_NAME, shp.CLASS as SHIP_CLASS, shp.LAUNCHED, c.*
from SHIPS as shp
right join CLASSES as c on c.CLASS = shp.CLASS
order by SHIP_NAME;
--4.3
select distinct c.COUNTRY, shp.NAME from SHIPS as shp
left join CLASSES as c on c.CLASS = shp.CLASS
left join OUTCOMES as oc on oc.SHIP = shp.NAME
where oc.RESULT is null or oc.BATTLE is null
order by c.COUNTRY;
--4.4
select shp.NAME as 'Ship Name' from SHIPS as shp
inner join CLASSES as c on c.CLASS = shp.CLASS
where c.NUMGUNS >= 7 and shp.LAUNCHED = 1916;
--4.5
select shp.NAME as ship, b.NAME as battle, b.DATE as date from SHIPS as shp
inner join OUTCOMES as oc on oc.SHIP = shp.NAME
inner join BATTLES as b on b.NAME = oc.BATTLE
where oc.RESULT = 'sunk'
order by battle;
--4.6
select shp.NAME as name, c.DISPLACEMENT as displacement, shp.LAUNCHED as launched
from SHIPS as shp
inner join CLASSES as c on c.CLASS = shp.CLASS
where name = shp.CLASS;
--4.7
select * from CLASSES as c
where not exists (
	select NAME from SHIPS
	where SHIPS.CLASS = c.CLASS
);
--4.8
select shp.NAME as name, c.DISPLACEMENT as displacement, c.NUMGUNS as numguns, oc.RESULT as result
from SHIPS as shp
inner join CLASSES as c on c.CLASS = shp.CLASS
inner join OUTCOMES as oc on oc.SHIP = shp.NAME
inner join BATTLES as b on b.NAME = oc.BATTLE
where b.NAME = 'North Atlantic';

--- |5| ---
--5.1
select count(c.CLASS) as NO_Classes from CLASSES as c
where c.TYPE = 'bb'
group by c.TYPE;
--5.2
select c.CLASS, avg(c.NUMGUNS) as avgGuns from CLASSES as c
where c.TYPE = 'bb'
group by c.CLASS;
--5.3
select avg(c.NUMGUNS) as avgGuns from CLASSES as c
where c.TYPE = 'bb'
group by c.TYPE;
--5.4
select c.CLASS, min(shp.LAUNCHED) as FirstYear, max(shp.LAUNCHED) 
from CLASSES as c
inner join SHIPS as shp on shp.CLASS = c.CLASS
group by c.CLASS;
--5.5
select c.CLASS, count(*) as NO_sunk from CLASSES as c
inner join SHIPS as shp on shp.CLASS = c.CLASS
inner join OUTCOMES as oc on oc.SHIP = shp.NAME
where oc.RESULT = 'sunk'
group by c.CLASS;
--5.6
select cs_reduced.CLASS, count(*) as NO_sunk from (
	select c.CLASS from CLASSES as c
	inner join SHIPS as shp on c.CLASS = shp.CLASS
	group by c.CLASS
	having count(*) > 2
) as cs_reduced
inner join SHIPS as shp2 on shp2.CLASS = cs_reduced.CLASS
inner join OUTCOMES as oc on oc.SHIP = shp2.NAME
where oc.RESULT = 'sunk'
group by cs_reduced.CLASS
--5.7
select c.COUNTRY, avg(c.BORE) as avg_bore from CLASSES as c
inner join SHIPS as shp on shp.CLASS = c.CLASS
group by c.COUNTRY;

---|6|---
--6.1
select distinct oc.SHIP from OUTCOMES as oc
where oc.SHIP like 'C%' or oc.SHIP like'K%'
--6.2
select shp.NAME, c.COUNTRY 
from SHIPS as shp
inner join CLASSES as c on shp.CLASS = c.CLASS 
where shp.NAME not in (select SHIP from OUTCOMES where RESULT = 'sunk');
--6.3
select g.country, sum(g.num_sunk_ships) as num_sunk_ships
from (
	select c.COUNTRY as country, count(oc.SHIP) as num_sunk_ships 
	from CLASSES as c
	left join SHIPS on c.CLASS = SHIPS.CLASS
	left join OUTCOMES as oc on SHIPS.NAME = oc.SHIP
	where oc.RESULT = 'sunk'
	group by c.COUNTRY
	union
	select c.COUNTRY as country, 0 as num_sunk_ships
	from CLASSES as c
	left join SHIPS ON c.CLASS = SHIPS.CLASS
	where SHIPS.NAME is null
	   or SHIPS.NAME not in (select SHIP from OUTCOMES where RESULT = 'sunk')
) as g
group by g.country;
--6.4
select o.BATTLE from OUTCOMES as o
group by o.BATTLE
having count(o.SHIP) > (
	select count(oc.SHIP)
	from OUTCOMES as oc
	where oc.BATTLE = 'Guadalcanal'
);
--6.5
select o.BATTLE from OUTCOMES as o
inner join SHIPS as shp on o.SHIP = o.SHIP
inner join CLASSES as c on c.CLASS = shp.CLASS
group by o.BATTLE
having count(c.COUNTRY) > (
	select count(c2.COUNTRY)
	from OUTCOMES as oc
	inner join SHIPS as shp2 on oc.SHIP = oc.SHIP
	inner join CLASSES as c2 on c2.CLASS = shp2.CLASS
	where oc.BATTLE = 'Surigao Strait'
);
--6.6
with MinDisplacement as (
	select min(DISPLACEMENT) as displacement
	from CLASSES
),
MaxGuns as (
	select CLASS, max(NUMGUNS) as numGuns
	from CLASSES
	group by CLASS
	having min(DISPLACEMENT) = (
			select top 1 displacement from MinDisplacement
		)
)
select 
	shp.NAME,
	c.DISPLACEMENT,
	MG.numGuns
from SHIPS as shp
inner join CLASSES as c on shp.CLASS = c.CLASS
inner join MaxGuns as MG on shp.CLASS = MG.CLASS
group by shp.NAME, c.DISPLACEMENT, MG.numGuns
having min(c.DISPLACEMENT) = (
			select top 1 displacement from MinDisplacement
		)
--6.7
with DamagedShips as (
    select distinct oc.SHIP
    from OUTCOMES as oc
    where oc.RESULT = 'damaged'
),
WinningShips AS (
    select distinct oc.SHIP
    from OUTCOMES as oc
    where oc.RESULT = 'ok'
)
select count(*) as num_ships
from DamagedShips as DS
join WinningShips as WS on DS.SHIP = WS.SHIP;

	


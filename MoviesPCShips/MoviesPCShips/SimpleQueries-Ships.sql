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

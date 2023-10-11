--- |1| ---
select ADDRESS from STUDIO where NAME = 'Disney';
select CONVERT(VARCHAR(10), BIRTHDATE, 101) BIRTHDATE from MOVIESTAR where NAME = 'Jack Nicholson';
select STARNAME, MOVIETITLE from STARSIN where MOVIEYEAR = 1980 OR MOVIETITLE LIKE '%Wars%';
select NAME,NETWORTH from MOVIEEXEC where NETWORTH > 10000000;
select NAME from MOVIESTAR where GENDER = 'M' or ADDRESS = 'Prefect Rd.';

--- |2| ---
--2.1
select actor.NAME from MOVIESTAR as actor 
inner join STARSIN as starsin on starsin.STARNAME = actor.NAME 
where actor.GENDER = 'M' and starsin.MOVIETITLE = 'The Usual Suspects';
--2.2
select actor.NAME as actorName from MOVIESTAR as actor 
inner join STARSIN as strarsin on strarsin.STARNAME = actor.NAME
inner join MOVIE as movie on strarsin.MOVIETITLE = movie.TITLE and strarsin.MOVIEYEAR = movie.YEAR
inner join STUDIO as studio on studio.NAME = movie.STUDIONAME
where movie.YEAR >= 1995 and movie.STUDIONAME = 'MGM';
--2.3
select mexec.NAME as producerName from MOVIEEXEC as mexec
inner join MOVIE as movie on movie.PRODUCERC# = mexec.CERT#
where movie.STUDIONAME = 'MGM';
--2.4
select a.TITLE from MOVIE as a, MOVIE as b 
where b.TITLE = 'Star Wars' and a.LENGTH > b.LENGTH;
--2.5
select a.NAME as producerName from MOVIEEXEC as a, MOVIEEXEC as b 
where b.NAME = 'Stephen Spielberg' and a.NETWORTH > b.NETWORTH;
--2.6
select movie.TITLE as movieTitle from MOVIE as movie
inner join MOVIEEXEC as me on movie.PRODUCERC# = me.CERT#
where me.NETWORTH > (select NETWORTH from MOVIEEXEC where NAME = 'Stephen Spielberg');

--- |3| ---
--3.1
select distinct ms.NAME from MOVIESTAR as ms
inner join MOVIEEXEC as mx on mx.NAME = ms.NAME
where ms.GENDER = 'F' and mx.NETWORTH > 10000000;
--3.2
select distinct ms.NAME from MOVIESTAR as ms 
where ms.GENDER IN ('M', 'F') and ms.NAME 
not in (select distinct mx.NAME from MOVIEEXEC as mx);
--3.3
select m1.TITLE, m1.LENGTH from MOVIE as m1
where m1.LENGTH > (select m2.LENGTH from MOVIE as m2 where m2.TITLE = 'Star Wars');
--3.4
select mx.NAME, m.TITLE from MOVIEEXEC as mx
inner join MOVIE as m on m.PRODUCERC# = mx.CERT#
where mx.NETWORTH > (select mx2.NETWORTH from MOVIEEXEC as mx2 where mx2.NAME = 'Merv Griffin');

--- |4| ---
--4.1
select m.TITLE, mx.NAME from MOVIEEXEC as mx
inner join MOVIE as m on m.PRODUCERC# = mx.CERT#
where m.PRODUCERC# = (
	select m2.PRODUCERC# from MOVIE as m2 
	where m2.TITLE = 'Star Wars'
);
--4.2
select distinct mx.NAME from MOVIEEXEC as mx
inner join MOVIE as m on m.PRODUCERC# = mx.CERT#
inner join STARSIN as st on st.MOVIETITLE = m.TITLE
where st.STARNAME = 'Harrison Ford';
--4.3
select distinct std.NAME, st.STARNAME from STUDIO as std
inner join MOVIE as m on m.STUDIONAME = std.NAME
inner join STARSIN as st on st.MOVIETITLE = m.TITLE
order by std.NAME asc;
--4.4
select st.STARNAME, mx.NETWORTH, m.TITLE from STARSIN as st
inner join MOVIE as m on m.TITLE = st.MOVIETITLE
inner join MOVIEEXEC as mx on mx.CERT# = m.PRODUCERC#
where mx.NETWORTH = (
	select distinct max(NETWORTH) from MOVIEEXEC
);
--4.5
select distinct ms.NAME, NULL AS movietitle from MOVIESTAR as ms
where ms.NAME not in (
	select distinct st.STARNAME from STARSIN as st
);

---|6|---
--6.1
select TITLE, YEAR, LENGTH from MOVIE 
where (LENGTH > 120 or LENGTH is NULL) and YEAR < 2000;
--6.2
select NAME, GENDER from MOVIESTAR
where NAME like 'J%' and BIRTHDATE > 1948
order by NAME desc;
--6.3
select st.NAME, count(distinct si.STARNAME) as num_actors from STUDIO as st
inner join MOVIE as mv on mv.STUDIONAME = st.NAME
inner join STARSIN as si on si.MOVIETITLE = mv.TITLE
group by st.NAME;
--6.4
select si.STARNAME, count(si.MOVIETITLE) as num_movies from STARSIN as si
group by si.STARNAME;
--6.5
select st.NAME as studioname, mv.TITLE, mv.YEAR from STUDIO as st
inner join (
    select STUDIONAME, MAX(YEAR) AS MaxYear
    from MOVIE
    group by STUDIONAME
) as LatestYearPerStudio on st.NAME = LatestYearPerStudio.STUDIONAME
inner join MOVIE as mv ON LatestYearPerStudio.STUDIONAME = mv.STUDIONAME 
and LatestYearPerStudio.MaxYear = mv.YEAR
order by mv.studioname desc;
--6.6
select top 1 ms.NAME from MOVIESTAR as ms
where ms.GENDER = 'M'
order by ms.BIRTHDATE desc;
--6.7
with ActorMovieCounts as (
	select
		mv.STUDIONAME AS studioname,
		si.STARNAME AS starname,
		count(*) AS count_movies
	from STARSIN as si
	inner join
		MOVIE as mv on si.MOVIETITLE = mv.TITLE and si.MOVIEYEAR = mv.YEAR
	group by si.STARNAME, mv.STUDIONAME
),
MaxMovieCounts as (
    select 
		studioname, 
		max(count_movies) as num_movies
    from ActorMovieCounts
    group by studioname
)
select 
	AMC.studioname, 
	AMC.starname, 
	AMC.count_movies as num_movies
from ActorMovieCounts as AMC
inner join
    MaxMovieCounts as MMC ON 
	AMC.StudioName = MMC.StudioName and AMC.count_movies = MMC.num_movies;
--6.8
select 
	mv.TITLE as movietitle, 
	mv.YEAR as movieyear, 
	count(si.STARNAME) as num_actors
from
	MOVIE as mv
inner join
	STARSIN as si on si.MOVIETITLE = mv.TITLE
group by mv.TITLE, mv.YEAR
having count(si.STARNAME) > 2;

--|7|--
--7.1
insert into MOVIESTAR
	values ('Nicole Kidman', null, 'F', '1967-06-20');
--7.2
update MOVIE
set PRODUCERC# = NULL
where PRODUCERC# in (
	select CERT# from MOVIEEXEC 
	where NETWORTH < 30000000
);
delete from MOVIEEXEC where NETWORTH < 30000000;
--7.3
delete MOVIESTAR from MOVIESTAR
where ADDRESS is null;
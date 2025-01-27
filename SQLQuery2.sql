--finding the team that hs won max number of gold medls
Select top 1 team, count (*) as total_gold
from atheletes a inner join athelete_events e on a.id = e.athlete_id
where medal = 'Gold'
group by team
order by total_gold desc

--finding total number of silver medals and year im which max number of silver medals have been won for each team
select team,best_year,total_silver_medals
from
(select team,year as best_year
from
(Select *,row_number() over (partition by team order by total_silver desc) as rank
from (select team,year,count(*) as total_silver
from atheletes a inner join athelete_events e on a.id = e.athlete_id
where medal = 'silver'
group by team,year) g)d
where rank =1)  q1  inner join
(select team as t,count(medal) as total_silver_medals
from athelete_events a inner join  atheletes e on a.athlete_id = e.id
where medal = 'silver'
group by team) q2 on q1.team = q2.t
--finding player who won max gold medals amongst players who only won gold medal
select top 1 name,len(k)
from
 (select name,STRING_AGG(medal,' ') as k
 from atheletes a inner join athelete_events e on a.id = e.athlete_id
 where medal in ('gold','silver','bronze')
 group by name
 having count(distinct(medal)) = 1)j
 where k like 'gold%'
 order by len(k) desc
 --find which player in which year won max gold medals
 select name ,year,count(medal) as total_gold_medals
  from atheletes a inner join athelete_events e on a.id = e.athlete_id
  where medal='gold'
  group by name,year
  order by count(medal) desc
  --Find year and event in which india has won first gold,silver and bronze medal
Select medal, event,year  
from(Select *, row_number() over (partition by medal order by year) as year_rank
  from
  (select  medal,event, year
   from atheletes a inner join athelete_events e on a.id = e.athlete_id
   where team = 'india' and medal in ('gold','silver','bronze'))g)t
   where year_rank =1
   --players who won gold in both summer and winter olympics
   select name, STRING_AGG(season,' ')
   from 
 atheletes a inner join athelete_events e on a.id = e.athlete_id
 where medal = 'gold'
 group by name
 having count(distinct(season)) = 2
 --find players who won gold ,silver and bronze in single olympics
 Select name,year
 from atheletes a inner join athelete_events e on a.id = e.athlete_id
 where medal <> 'NA'
 group by name, year,games
 having count(DISTINct(medal))  = 3
  --find players who won gold in 3 consecutive summer olympics 2000 onwards
 Select t1.*,t2.year
 from
 (Select q1.name,q1.event,q1.year as y,q2.year
  from
 (Select distinct name,event ,year 
 from atheletes a left join athelete_events e on a.id = e.athlete_id
 where medal ='Gold' and season = 'summer' and year > 2000) q1 inner join 
 (Select distinct name,event ,year 
 from atheletes a left join athelete_events e on a.id = e.athlete_id
 where medal ='Gold' and season = 'summer' and year > 2000) q2 
 on q1.name = q2.name and q1.event = q2.event and q1.year = q2.year+4)t1
 inner join
  (Select distinct name,event ,year 
 from atheletes a left join athelete_events e on a.id = e.athlete_id
 where medal ='Gold' and season = 'summer' and year > 2000)t2 
on t1.name = t2.name and t1.event = t2.event and t1.y = t2.year+8
 

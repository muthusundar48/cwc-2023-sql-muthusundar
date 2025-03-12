-- no of 4's hit
select count(*) as `4's_hit`
from deliveries
where runs_off_bat=4;

-- no of 6's hit
select count(*) as `6's_hit`
from deliveries
where runs_off_bat=6;

-- all team names
select distinct(batting_team) from deliveries
order by batting_team;

-- most runs players
select striker as batsman,runs
from
(select striker, sum(runs_off_bat) as runs
from deliveries
group by striker) as top
order by runs desc
limit 10;

-- most 6's in cwc23 top 10
select striker as batsman, count(runs_off_bat) as sixes, batting_team 
from deliveries
where runs_off_bat=6
group by batsman, batting_team
order by sixes desc
limit 10;

-- most 6's in single match
select match_id, striker as batsman, count(runs_off_bat) as sixes
from deliveries
where runs_off_bat=6
group by batsman, match_id
order by sixes desc
limit 10;

-- most no of 6's in a venue
select venue, count(runs_off_bat) as sixes
from deliveries
where runs_off_bat=6
group by venue
order by sixes desc
limit 10;

-- top 10 players who hit most no 4's
select striker, count(runs_off_bat) as fours
from deliveries
where runs_off_bat=4
group by striker
order by fours desc
limit 10;

-- Top 10 batsmen who hit most number of fours in sigle match
select match_id, striker, count(runs_off_bat) as fours
from deliveries
where runs_off_bat=4
group by striker, match_id
order by fours desc
limit 10;

-- Most fours hit in a Venue
select venue, count(runs_off_bat) as fours
from deliveries
where runs_off_bat=4
group by venue
order by fours desc
limit 10;

-- Top 10 Teams which scored most number of runs in a match
select match_id, batting_team, sum(runs_off_bat+extras) as runs
from deliveries
group by match_id, batting_team
order by runs desc
limit 10;

-- Top 10 Batsmen who scored most number of runs in a match
select match_id, striker, sum(runs_off_bat) as runs
from deliveries
group by match_id, striker
order by runs desc
limit 10;

-- Overall Team Score in the season
select batting_team, sum(runs_off_bat+extras) as runs
from deliveries
group by batting_team
order by runs desc
limit 10;

-- Overall Batsman Performance
select 
				striker,
				count(distinct (match_id)) as matches, 
                sum(runs_off_bat) as runs,
                count(runs_off_bat) as balls_faced,
                
                case
					when count(case 
						when player_dismissed=striker then 1 end)=0 then null
					else round(sum(runs_off_bat)/count(case 
						when player_dismissed=striker then 1 end),3)
				end as average,
                
                round((sum(runs_off_bat)/count(runs_off_bat))*100,3) as SR,
                
                (select max(total_runs) 
					from (select match_id, sum(runs_off_bat) as total_runs
					from deliveries
					where striker='V Kohli'
					group by match_id
					) as score) as HS,
                    
                    (select count(record) as 50s from(
					select
					case when runs between 0 and 49 then 'no fifty'
					when runs between 50 and 99 then 'fifty'
					else 'hundrd'
					end as record
					from
					(select match_id, sum(runs_off_bat) as runs
					from deliveries
					where striker='V Kohli'
					group by match_id
					order by match_id) as score) as 50s
					where record='fifty') as 50s,
                    
                    (select count(record) as 100s from(
					select
					case when runs between 0 and 49 then 'no fifty'
					when runs between 50 and 99 then 'fifty'
					else 'hundred'
					end as record
					from
					(select match_id, sum(runs_off_bat) as runs
					from deliveries
					where striker='V Kohli'
					group by match_id
					order by match_id) as score) as 100s
					where record='hundred') as 100s,
                    
                    count(case 
						when player_dismissed=striker then 1 end) as dimissed
from deliveries
where striker = 'V kohli'
group by striker;

-- matches venue wise
select distinct venue, count(distinct match_id) as matches from deliveries
group by venue;






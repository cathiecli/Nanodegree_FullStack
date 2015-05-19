-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--

-- Change History: 1. 05/05/2015: changed to create database if exist, instead of tables
-------- 1. DATABASE -----------------------------------------------------------------------------
\echo ' -- 1. Create and connect to database -- '
DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;
\c tournament

-- PostgreSQL: IF EXISTS - Do not throw an error if the table does not exist. A notice is issued in this case.
-- DROP TABLE IF EXISTS matches;
-- DROP TABLE IF EXISTS players;

-------- 2. TABLE -----------------------------------------------------------------------------
\echo ' -- 2. Create tables -- '
-- create players table
-- Change History: 1. 05/04/2015: changed data type from TEXT to VARCHAR(75) for name
CREATE TABLE players ( name VARCHAR(75),                     
                       id SERIAL primary key);

-- create matches table
-- Change History: 1. 05/04/2015: changed data type from SERIAL to INTEGER for player1, player2 and win_id (SERIAL will increase 1 each time it is created.)
--                 2. 05/04/2015: the reason I chose to use both player1, player2 and win_id is that I first built the table, and inserted 
--                                some testing data, which either player1 or player 2 can be the winner.  And it is relatively easy for me
--                                to build the view later on.  Basically my design goal is that to keep all data retrival in database layer
--                 3. 05/04/2015: changed to use two columns for player match information
CREATE TABLE matches ( seq_id SERIAL primary key,
             winner_id INTEGER references players(id),  
             loser_id INTEGER references players(id));

-------- 3. VIEW ----------------------------------------------------------------------------
\echo ' -- 3. Create View -- '
-- create view standings to be used by playerStandings() and swissPairings()
-- Change History: 1. 05/04/2015: added further comments:
--                    a) columns of id, name, wins and player_match are used in playerStandings() 
--                    b) column row_number is used in the query of swissPairings() to calculate 
--                       whether the row is in odd or even number
--                 2. 05/18/2015: re-formatted
CREATE OR replace VIEW standings 
AS
  SELECT a.id, 
         a.name, 
         a.wins, 
         SUM(player_cnt) AS player_match, 
         Row_number() 
           over (
             ORDER BY a.wins DESC) -- SUM to get the total matches count
  FROM (SELECT a.id, 
               a.name, 
               Count(b.winner_id) AS wins        -- wins count
          FROM players a 
               left join matches b 
                      ON a.id = b.winner_id
        GROUP BY a.id, 
                 a.name, 
                 b.winner_id) a 
        left join (SELECT a.id, 
                          a.name, 
                          Count(b.winner_id) AS player_cnt  
                   -- winner matches count
                   FROM players a 
                        left join matches b 
                               ON a.id = b.winner_id
                   GROUP BY a.id, 
                            a.name, 
                            b.winner_id
 	                 UNION
	                 SELECT a.id, 
                          a.name, 
                          Count(b.loser_id) AS player_cnt    
                   -- loser matches count
                   FROM players a 
                        left join matches b 
                               ON a.id = b.loser_id
                   GROUP BY a.id, 
                            a.name, 
                            b.loser_id) b 
               ON a.id = b.id
  GROUP BY a.id, 
           a.name, 
           a.wins
  ORDER BY a.wins DESC;

SELECT * FROM standings;
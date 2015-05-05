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

-------- 3. TABLE DATA ------------------------------------------------------------------------
\echo ' -- 3. Insert Testing Data -- '
-- insert data into players table
--INSERT INTO players VALUES ('John', nextval('players_id_seq'));
--INSERT INTO players VALUES ('Smith', nextval('players_id_seq'));
--INSERT INTO players VALUES ('Allen', nextval('players_id_seq'));
--INSERT INTO players VALUES ('Jack', nextval('players_id_seq'));
--INSERT INTO players VALUES ('Jane', nextval('players_id_seq'));
--INSERT INTO players VALUES ('Amy', nextval('players_id_seq'));
--INSERT INTO players VALUES ('Julie', nextval('players_id_seq'));
--INSERT INTO players VALUES ('Christie', nextval('players_id_seq'));

-- reset sequence number
--SELECT setval(pg_get_serial_sequence('players', 'id'), MAX(id)) FROM players;

SELECT nextval('players_id_seq');

-- insert data into matches table
--INSERT INTO matches VALUES (nextval('matches_seq_id_seq'), 2, 1);
--INSERT INTO matches VALUES (nextval('matches_seq_id_seq'), 3, 4);
--INSERT INTO matches VALUES (nextval('matches_seq_id_seq'), 6, 5);
--INSERT INTO matches VALUES (nextval('matches_seq_id_seq'), 7, 8);

--INSERT INTO matches VALUES (nextval('matches_seq_id_seq'), 3, 2);
--INSERT INTO matches VALUES (nextval('matches_seq_id_seq'), 6, 7);
--INSERT INTO matches VALUES (nextval('matches_seq_id_seq'), 4, 1);
--INSERT INTO matches VALUES (nextval('matches_seq_id_seq'), 8, 5);

--INSERT INTO matches VALUES (nextval('matches_seq_id_seq'), 3, 6);
--INSERT INTO matches VALUES (nextval('matches_seq_id_seq'), 7, 2);
--INSERT INTO matches VALUES (nextval('matches_seq_id_seq'), 8, 4);
--INSERT INTO matches VALUES (nextval('matches_seq_id_seq'), 5, 1);

-- reset sequence number
--SELECT setval(pg_get_serial_sequence('matches', 'seq_id'), MAX(seq_id)) FROM matches;

SELECT nextval('matches_seq_id_seq');

-------- 4. VIEW ----------------------------------------------------------------------------
\echo ' -- 4. Create View -- '
-- Query to get the number of matches the player has won, used as a subquery in view
--CREATE OR REPLACE VIEW player_standings AS
--SELECT a.id, a.name, COUNT(b.winner_id) AS wins
--  FROM players a LEFT JOIN matches b ON a.id = b.winner_id
--GROUP BY a.id, a.name, b.winner_id
--ORDER BY wins;

-- Query to get winner's number of matches that the player has played
--CREATE OR REPLACE VIEW winner_matches AS
--SELECT a.id, a.name, COUNT(b.winner_id) AS winner_cnt
--  FROM players a LEFT JOIN matches b ON a.id = b.winner_id
--GROUP BY a.id, a.name, b.winner_id;

--SELECT *
--FROM winner_matches;

-- Query to get loser's number of matches that the player has played
--CREATE OR REPLACE VIEW loser_matches AS
--SELECT a.id, a.name, COUNT(b.loser_id) AS loser_cnt
--  FROM players a LEFT JOIN matches b ON a.id = b.loser_id
--GROUP BY a.id, a.name, b.loser_id;

--SELECT *
--FROM player2_matches;

-- Query to get the number of matches the player has played
--CREATE OR REPLACE VIEW player_matches AS
--SELECT a.id, a.name, COUNT(b.winner_id) AS player_cnt
--  FROM players a LEFT JOIN matches b ON a.id = b.winner_id
--GROUP BY a.id, a.name, b.winner_id
--UNION
--SELECT a.id, a.name, COUNT(b.loser_id) AS player_cnt
--  FROM players a LEFT JOIN matches b ON a.id = b.loser_id
--GROUP BY a.id, a.name, b.loser_id;

-- Query to get the total number of matches each player has played
--SELECT id, name, SUM(player_cnt)
--FROM player_matches
--GROUP BY id, name;

-- Query to join the temporary views
--SELECT a.id, a.name, a.wins, SUM(player_cnt) AS player_match
--  FROM player_standings a LEFT JOIN player_matches b ON a.id = b.id
--GROUP BY a.id, a.name, a.wins;

-- create view standings to be used by playerStandings() and swissPairings()
-- Change History: 1. 05/04/2015: added further comments:
--                    a) columns of id, name, wins and player_match are used in playerStandings() 
--                    b) column row_number is used in the query of swissPairings() to calculate 
--                       whether the row is in odd or even number 
CREATE OR REPLACE VIEW standings AS
SELECT a.id, a.name, a.wins, SUM(player_cnt) AS player_match, ROW_NUMBER() OVER (ORDER BY a.wins DESC) -- SUM to get the total matches count
  FROM (
	  SELECT a.id, a.name, COUNT(b.winner_id) AS wins        -- wins count
      FROM players a LEFT JOIN matches b ON a.id = b.winner_id
  GROUP BY a.id, a.name, b.winner_id) a LEFT JOIN (
  	SELECT a.id, a.name, COUNT(b.winner_id) AS player_cnt  -- winner matches count
      FROM players a LEFT JOIN matches b ON a.id = b.winner_id
  GROUP BY a.id, a.name, b.winner_id
 	   UNION
	  SELECT a.id, a.name, COUNT(b.loser_id) AS player_cnt    -- loser matches count
      FROM players a LEFT JOIN matches b ON a.id = b.loser_id
  GROUP BY a.id, a.name, b.loser_id) b ON a.id = b.id
GROUP BY a.id, a.name, a.wins
ORDER BY a.wins DESC;

SELECT * FROM standings;
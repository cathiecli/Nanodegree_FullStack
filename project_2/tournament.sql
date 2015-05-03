-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--

-- PostgreSQL: IF EXISTS - Do not throw an error if the table does not exist. A notice is issued in this case.
DROP VIEW IF EXISTS player_matches;
DROP VIEW IF EXISTS player1_matches;
DROP VIEW IF EXISTS player2_matches;
DROP VIEW IF EXISTS player_standings;
DROP VIEW IF EXISTS swiss_pairings;
DROP VIEW IF EXISTS standings;
DROP TABLE IF EXISTS matches;
DROP TABLE IF EXISTS players;

-------- 1. TABLE -----------------------------------------------------------------------------
\echo ' -- 1. Create Table -- '
-- create players table
CREATE TABLE players ( name TEXT,                     
                       id SERIAL primary key);

-- create matches table
CREATE TABLE matches ( seq_id SERIAL primary key,
					   player1 SERIAL references players(id),  
					   player2 SERIAL references players(id),                   
                       win_id SERIAL references players(id));

-------- 2. TABLE DATA ------------------------------------------------------------------------
\echo ' -- 2. Insert Data -- '
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
--INSERT INTO matches VALUES (nextval('matches_seq_id_seq'), 1, 2, 2);
--INSERT INTO matches VALUES (nextval('matches_seq_id_seq'), 3, 4, 3);
--INSERT INTO matches VALUES (nextval('matches_seq_id_seq'), 5, 6, 6);
--INSERT INTO matches VALUES (nextval('matches_seq_id_seq'), 7, 8, 7);

--INSERT INTO matches VALUES (nextval('matches_seq_id_seq'), 2, 3, 3);
--INSERT INTO matches VALUES (nextval('matches_seq_id_seq'), 6, 7, 6);
--INSERT INTO matches VALUES (nextval('matches_seq_id_seq'), 1, 4, 4);
--INSERT INTO matches VALUES (nextval('matches_seq_id_seq'), 5, 8, 8);

--INSERT INTO matches VALUES (nextval('matches_seq_id_seq'), 3, 6, 3);
--INSERT INTO matches VALUES (nextval('matches_seq_id_seq'), 2, 7, 7);
--INSERT INTO matches VALUES (nextval('matches_seq_id_seq'), 4, 8, 8);
--INSERT INTO matches VALUES (nextval('matches_seq_id_seq'), 1, 5, 5);

-- reset sequence number
--SELECT setval(pg_get_serial_sequence('matches', 'seq_id'), MAX(seq_id)) FROM matches;

SELECT nextval('matches_seq_id_seq');

-------- 3. VIEW ----------------------------------------------------------------------------
\echo ' -- 3. Create View -- '
-- Query to get the number of matches the player has won, used as a subquery in view
--CREATE VIEW player_standings AS
--SELECT a.id, a.name, COUNT(b.win_id) AS wins
--  FROM players a JOIN matches b ON a.id = b.win_id
--GROUP BY a.id, a.name, b.win_id
--ORDER BY wins;

-- Query to get player1's number of matches the player has played
--CREATE VIEW player1_matches AS
--SELECT a.id, a.name, COUNT(b.player1) AS player_cnt
--FROM players a JOIN matches b ON a.id = b.player1
--GROUP BY a.id, a.name, b.player1;

--SELECT *
--FROM player1_matches;

-- Query to get player2's number of matches the player has played
--CREATE VIEW player2_matches AS
--SELECT a.id, a.name, COUNT(b.player2) AS player_cnt
--FROM players a JOIN matches b ON a.id = b.player2
--GROUP BY a.id, a.name, b.player2;

--SELECT *
--FROM player2_matches;

-- Query to get the number of matches the player has played
--CREATE VIEW player_matches AS
--SELECT a.id, a.name, COUNT(b.player1) AS player_cnt
--FROM players a JOIN matches b ON a.id = b.player1
--GROUP BY a.id, a.name, b.player1
--UNION
--SELECT a.id, a.name, COUNT(b.player2) AS player_cnt
--FROM players a JOIN matches b ON a.id = b.player2
--GROUP BY a.id, a.name, b.player2;

-- Query to get the total number of matches each player has played
--SELECT id, name, SUM(player_cnt)
--FROM player_matches
--GROUP BY id, name;

-- Query to join the temporary views
--SELECT a.id, a.name, a.wins, SUM(player_cnt) AS player_match
--FROM player_standings a JOIN player_matches b ON a.id = b.id
--GROUP BY a.id, a.name, a.wins;

-- create view standings to be used by playerStandings()
CREATE VIEW standings AS
SELECT a.id, a.name, a.wins, SUM(player_cnt) AS player_match
FROM (
	SELECT a.id, a.name, COUNT(b.win_id) AS wins
  	  FROM players a LEFT JOIN matches b ON a.id = b.win_id
  GROUP BY a.id, a.name, b.win_id
  ORDER BY wins) a LEFT JOIN (
  	SELECT a.id, a.name, COUNT(b.player1) AS player_cnt
	  FROM players a LEFT JOIN matches b ON a.id = b.player1
  GROUP BY a.id, a.name, b.player1
 	 UNION
	SELECT a.id, a.name, COUNT(b.player2) AS player_cnt
	  FROM players a LEFT JOIN matches b ON a.id = b.player2
  GROUP BY a.id, a.name, b.player2) b ON a.id = b.id
  GROUP BY a.id, a.name, a.wins
  ORDER BY a.wins;

SELECT * FROM standings;

-- create view swiss_pairings to be used by swissPairings()
CREATE VIEW swiss_pairings AS
SELECT p1.player1 AS id1, a.name AS name1, p1.player2 AS id2, b.name AS name2
  FROM matches p1 JOIN players a ON p1.player1 = a.id JOIN players b ON p1.player2 = b.id;

SELECT * FROM swiss_pairings;
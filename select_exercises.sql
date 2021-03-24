-- 2. Use the albums_db database.
USE albums_db;

-- 3. Explore the structure of the albums table.
DESCRIBE albums;

--		a. How many rows are in the albums table? 31
SELECT * FROM albums;
-- 		b. How many unique artist names are in the albums table? 23
SELECT DISTINCT artist FROM albums;

--	    c. What is the primary key for the albums table? id
DESCRIBE albums;

-- 		d. What is the oldest release date for any album in the albums table? What is the most recent release date? recent 2011 and oldest 1967
-- recent release
SELECT MAX(release_date) FROM albums;  
-- oldest release 
SELECT MIN(release_date) FROM albums; 

SELECT DISTINCT release_date FROM albums
ORDER BY release_date;

-- 4.a. The name of all albums by Pink Floyd
SELECT name, artist FROM albums
WHERE artist = 'Pink Floyd';

-- 4b. The year Sgt. Pepper's Lonely Hearts Club Band was released. 1967
SELECT  release_date FROM albums 
WHERE name = "Sgt. Pepper's Lonely Hearts Club Band";
SELECT  release_date FROM albums 
WHERE name = 'Sgt. Pepper\'s Lonely Hearts Club Band'; -- use \ to ignore ';



-- 4c. The genre for the album Nevermind. Grunge, Alternative rock. 
SELECT genre  FROM albums
WHERE name = "Nevermind";

-- 4d. Which albums were released in the 1990s (returns 11 records)
SELECT name 
FROM albums
WHERE release_date BETWEEN 1990 AND 1999;

-- 4e. Which albums had less than 20 million certified sales. (returns 13 records)
SELECT name, sales FROM albums
WHERE sales < 20;

-- 4f. All the albums with a genre of "Rock". 
SELECT name FROM albums
WHERE genre ='Rock';

-- Why do these query results not include albums with a genre of "Hard rock" or "Progressive rock"? because when we  use genre = Rock, it will display only 
-- the fields that have exact genre as Rock. whe can use LIKE to include albums with the word Rock in genre 
SELECT name, genre FROM albums
WHERE genre LIKE '%Rock%';



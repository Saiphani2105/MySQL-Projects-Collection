create database Netflix;

use Netflix;


CREATE TABLE Netflix (
    show_id VARCHAR(5) UNIQUE,
    Type VARCHAR(10),
    Title VARCHAR(255) NOT NULL,
    Director VARCHAR(255),
    Cast TEXT,
    Country VARCHAR(255),
    Date_added VARCHAR(50) NOT NULL,
    Release_year int NOT NULL,
    Rating VARCHAR(50) NOT NULL,
    Duration VARCHAR(100) NOT NULL,
    listed_in TEXT NOT NULL,
    description TEXT NOT NULL
);

select * from netflix;

select count(*) from netflix;

select type ,count(type) from netflix 
group by type;

SELECT Director, COUNT(*) AS content_count
FROM Netflix
WHERE Director IN ('Masahiko Murata', 'Delhiprasad Deenadayalan', 'Toshiya Shinohara', 'Hajime Kamegaki')
GROUP BY Director
ORDER BY content_count DESC;


SELECT Title, Date_added
FROM Netflix
WHERE Title IN ('The Women and the Murderer', 'JJ+E', 'The Circle', 'Paradise Hills')
ORDER BY Date_added DESC;

select type , min(Release_Year) from netflix 
group by type;

select country , count(country) from netflix
group by country  ;

SELECT Title, Duration
FROM Netflix
WHERE Title IN ('Avvai Shanmughi', 'Omo Ghetto: the Saga', 'Jeans', 'Minsara Kanavu')
ORDER BY LENGTH(Duration) DESC;


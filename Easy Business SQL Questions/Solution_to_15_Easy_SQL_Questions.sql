-------------------------------------------------------------------
-- EASY SQL Questions:

-- Q)1 Total Movies and TV Shows
SELECT type, COUNT(*) AS Total_Number
FROM netflix
GROUP BY type;

-- Q)2 Most Popular Genre
SELECT listed_in, COUNT(*) AS total
FROM netflix
GROUP BY listed_in
ORDER BY total DESC
LIMIT 5;

-- Q)3 Content by Year
SELECT YEAR(date_added) AS year_added,
       COUNT(*) AS content_count
FROM netflix
WHERE date_added IS NOT NULL
GROUP BY YEAR(date_added)
ORDER BY year_added ASC;

-- Q)4 Top Countries by Content
SELECT TRIM(country_name) AS country,
       COUNT(*) AS content_count
FROM (
    SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(country, ',', n.n), ',', -1) AS country_name
    FROM netflix
    JOIN (
        SELECT a.N + b.N * 10 + 1 AS n
        FROM (SELECT 0 N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a
        CROSS JOIN (SELECT 0 N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
    ) n
    ON n.n <= LENGTH(country) - LENGTH(REPLACE(country, ',', '')) + 1
) AS countries
GROUP BY TRIM(country_name)
ORDER BY content_count DESC;

-- Q)5 Recent Additions
SELECT title, date_added
FROM netflix
WHERE date_added IS NOT NULL
ORDER BY date_added DESC;

-- Q)6 Longest Movie or TV Show
SELECT title, duration, type
FROM netflix
ORDER BY duration DESC, title ASC;

-- Q)7 Genre Popularity by Year
SELECT *
FROM (
    SELECT
        release_year,
        SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', n.n), ',', -1) AS genre,
        COUNT(*) AS title_count,
        (SELECT COUNT(*)
         FROM (
           SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', n2.n), ',', -1) AS g
           FROM netflix n2
           JOIN (
             SELECT a.N + b.N * 10 + 1 AS n
             FROM (SELECT 0 N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a
             CROSS JOIN (SELECT 0 N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
           ) n2 ON n2.n <= LENGTH(listed_in) - LENGTH(REPLACE(listed_in, ',', '')) + 1
           WHERE release_year = n.release_year
         ) d
         WHERE d.g = genre AND release_year = n.release_year
        ) AS genre_rank
    FROM netflix n
    JOIN (
        SELECT a.N + b.N * 10 + 1 AS n
        FROM (SELECT 0 N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a
        CROSS JOIN (SELECT 0 N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
    ) n
    ON n.n <= LENGTH(listed_in) - LENGTH(REPLACE(listed_in, ',', '')) + 1
    GROUP BY release_year, genre
) AS x
WHERE genre_rank <= 3;

-- Q)8 Count the number of Movies vs TV Shows per Year
SELECT release_year, type, COUNT(*) AS no_of_types
FROM netflix
GROUP BY release_year, type
ORDER BY release_year DESC, type ASC;

-- Q)9 Find the top 3 common rating for movies and TV shows
SELECT type, rating
FROM (
    SELECT type, rating,
           COUNT(*) AS no_of_rating,
           RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranks
    FROM netflix
    GROUP BY type, rating
) x
WHERE ranks < 4;

-- Q)10 List all movies released in 2020
SELECT *
FROM netflix
WHERE release_year = 2020
AND type='Movie'
ORDER BY title ASC;

-- Q)11 List all Documentary Movies
SELECT DISTINCT title, type, TRIM(genre) AS genre
FROM (
    SELECT title, type,
    SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', n.n), ',', -1) AS genre
    FROM netflix
    JOIN (
        SELECT a.N + b.N * 10 + 1 AS n
        FROM (SELECT 0 N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a
        CROSS JOIN (SELECT 0 N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
    ) n ON n.n <= LENGTH(listed_in) - LENGTH(REPLACE(listed_in, ',', '')) + 1
) d
WHERE genre = 'Documentaries'
AND type='Movie';

-- Q)12 Find content added in last 5 years
SELECT date_added
FROM netflix
WHERE date_added BETWEEN
    DATE_SUB((SELECT MAX(date_added) FROM netflix), INTERVAL 4 YEAR)
    AND (SELECT MAX(date_added) FROM netflix)
ORDER BY date_added ASC;

    

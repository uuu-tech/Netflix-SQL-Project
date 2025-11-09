-------------------------------------------------------------------
-- MEDIUM DIFFICULTY SQL QUESTIONS:

-- 1 Director with Most Titles
SELECT director, COUNT(*) AS no_of_titles
FROM netflix
WHERE director IS NOT NULL
GROUP BY director
ORDER BY no_of_titles DESC
LIMIT 5;

-- 2 Multi-Country Productions
SELECT title, country
FROM netflix
WHERE country LIKE '%,%';

-- 3 Content by Rating
SELECT rating, COUNT(*) AS no_of_content
FROM netflix
WHERE rating IS NOT NULL AND rating NOT LIKE '% min'
GROUP BY rating
ORDER BY no_of_content DESC;

-- 4 Duplicate Titles
SELECT title, COUNT(*) AS no_of_dup
FROM netflix
GROUP BY title
HAVING COUNT(*) > 1;

-- 5 Yearly Additions
SELECT YEAR(date_added) AS year_of_addition,
       COUNT(*) AS no_of_content
FROM netflix
WHERE date_added IS NOT NULL
GROUP BY year_of_addition
ORDER BY year_of_addition DESC;

-- 6 Movies/TV shows by director Rajiv Chilaka
SELECT title 
FROM netflix
WHERE director REGEXP 'Rajiv Chilaka';

-- 7 TV Shows with more than 5 seasons
SELECT title
FROM netflix
WHERE type = 'TV Show'
AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;

-- 8 Content by Genre
SELECT TRIM(genre) AS genre, COUNT(*) AS no_of_content
FROM (
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', n.n), ',', -1)) AS genre
    FROM netflix
    JOIN (
        SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
    ) n ON LENGTH(listed_in) - LENGTH(REPLACE(listed_in, ',', '')) >= n.n - 1
) x
GROUP BY genre
ORDER BY no_of_content DESC;

-- 9 India Avg Content Per Year (Top 5)
SELECT year,
       total_titles,
       ROUND(total_titles/12) AS avg_titles_per_month
FROM (
    SELECT YEAR(date_added) AS year,
           COUNT(*) AS total_titles
    FROM netflix
    WHERE date_added IS NOT NULL
      AND country LIKE '%India%'
    GROUP BY year
) t
ORDER BY avg_titles_per_month DESC
LIMIT 5;

-- 10 categorize kill/violence
SELECT category, COUNT(*)
FROM (
    SELECT title, description,
           CASE WHEN description REGEXP 'kill|violence' THEN 'Bad' ELSE 'Good' END AS category
    FROM netflix
) x
GROUP BY category;

-- 11 content without director
SELECT * FROM netflix
WHERE director IS NULL;

-- 12 Most Popular Genre Per Year 

SELECT
    release_year,
    SUBSTRING_INDEX(listed_in, ',', 1) AS genre,
    COUNT(*) AS total_count
FROM netflix
GROUP BY release_year, genre
ORDER BY release_year DESC, total_count DESC;

-- 13 Content longevity
SELECT type,
       CASE
           WHEN type = 'Movie' THEN AVG(CAST(REGEXP_REPLACE(duration, '[^0-9]', '') AS UNSIGNED))
           WHEN type = 'TV Show' THEN ROUND(AVG(CAST(REGEXP_REPLACE(duration, '[^0-9]', '') AS UNSIGNED)))
       END AS avg_duration
FROM netflix
WHERE duration IS NOT NULL
GROUP BY type;

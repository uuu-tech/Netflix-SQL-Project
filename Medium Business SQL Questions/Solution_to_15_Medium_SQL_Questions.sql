-------------------------------------------------------------------
-- MEDIUM DIFFICULTY SQL QUESTIONS:

-- Q)1 Director with Most Titles
    SELECT director, COUNT(*) AS no_of_titles FROM netflix
    WHERE director IS NOT NULL
    GROUP BY director
    ORDER BY no_of_titles DESC
    LIMIT 5

-- Q)2 Multi-Country Productions
    SELECT
    title,
    country
    FROM netflix
    WHERE array_length(string_to_array(country, ','), 1) > 1;

-- Q)3 Content by Rating
    SELECT rating , COUNT(*) AS no_of_content
    FROM netflix
    WHERE rating IS NOT NULL AND NOT rating ~ ' min$'
    GROUP BY rating
    ORDER BY no_of_content DESC

-- Q)4 Duplicate Titles
    SELECT title, COUNT(*) AS no_of_dup
    FROM netflix
    GROUP BY title
    HAVING COUNT(*) > 1

-- Q)5 Yearly Additions
    SELECT EXTRACT(YEAR FROM date_added) AS year_of_addition,
    COUNT(*) AS no_of_content
    FROM NETFLIX
    WHERE date_added IS NOT NULL
    GROUP BY year_of_addition
    ORDER BY year_of_addition DESC

-- Q)6  Find all the movies/TV shows by director 'Rajiv Chilaka'
    SELECT title 
    FROM netflix
    WHERE director ~* '(Rajiv Chilaka)'

-- Q)7 List all TV shows with more than 5 seasons 
    SELECT title
    FROM netflix
    WHERE type='TV Show' AND CAST((string_to_array(duration,' '))[1] AS INTEGER)>5

-- Q)8 Count the number of content items in each genre
    SELECT TRIM(genre) AS genre,
    COUNT(*) AS no_of_content 
    FROM (
    SELECT UNNEST(string_to_array(listed_in,',')) AS genre
    	FROM netflix
    )
    GROUP BY genre
    ORDER BY no_of_content DESC

-- Q)9 Find each year and the average numbers of content released in India on Netflix. Return the top 5 years with the highest avg content release!
    WITH CTE AS (
        SELECT 
            EXTRACT(YEAR FROM date_added) AS year,
            UNNEST(string_to_array(country, ',')) AS country
        FROM 
            netflix
        WHERE 
            date_added IS NOT NULL
    )
    SELECT 
        year,
        COUNT(*) AS total_titles,
        ROUND(COUNT(*) * 1.0 / 12) AS avg_titles_per_month -- Assuming 12 months in a year
    FROM 
        CTE
    WHERE 
        country = 'India'
    GROUP BY 
        year
    ORDER BY 
        avg_titles_per_month DESC
    LIMIT 5;

-- Q)10 Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content as 'Bad' or 'Good' and count how many items fall into each category.
    WITH CTE AS (SELECT 
    title,
    description,
    CASE
     	WHEN description ~* '(kill|violence)' THEN 'Bad'
     	ELSE 'Good'
    END AS category
    FROM netflix 
    )
    
    SELECT category, COUNT(*)
    FROM CTE
    GROUP BY category

-- Q)11 Find all content without a director
    SELECT * FROM netflix
    WHERE director IS NULL

-- Q)12 Most Popular Genre Per Year
    WITH CTE AS (SELECT
    release_year, 
    UNNEST(string_to_array(listed_in, ',')) AS genre,
    COUNT(*) AS total_count,
    RANK() OVER (PARTITION BY release_year ORDER BY COUNT(*) DESC) AS genre_rank
    FROM 
        netflix
    GROUP BY 
        release_year, genre
    ORDER BY 
        release_year DESC, genre_rank)
    	
    SELECT release_year, genre, total_count FROM CTE
    WHERE genre_rank=1

-- Q)13 Content Longevity
    SELECT 
    type,
    CASE 
        WHEN type = 'Movie' THEN AVG(CAST(REGEXP_REPLACE(duration, '[^0-9]', '', 'g') AS INT)) -- replace text to just number 
        WHEN type = 'TV Show' THEN ROUND(AVG(CAST(REGEXP_REPLACE(duration, '[^0-9]', '', 'g') AS INT)))
    END AS avg_duration
    FROM 
        netflix
    WHERE 
        duration IS NOT NULL
    GROUP BY 
        type;

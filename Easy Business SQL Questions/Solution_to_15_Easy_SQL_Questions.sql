-------------------------------------------------------------------
-- EASY SQL Questions:

-- Q)1 Total Movies and TV Shows
  SELECT type, COUNT(*) AS Total_Number FROM netflix
  GROUP BY type

-- Q)2 Most Popular Genre
  SELECT listed_in  FROM NETFLIX
  GROUP BY listed_in
  ORDER BY COUNT(*) DESC
  LIMIT 5

-- Q)3 Content by Year
    SELECT EXTRACT(Year FROM date_added) AS year_added ,
    COUNT(*) as content_count
    FROM netflix
    WHERE date_added IS NOT NULL
    GROUP BY year_added
    ORDER BY year_added ASC

-- Q)4 Top Countries by Content
    SELECT 
        TRIM(country_name) AS country, 
        COUNT(*) AS content_count
    FROM (
        SELECT 
            UNNEST(string_to_array(country, ',')) AS country_name
        FROM 
            netflix
    ) AS countries
    GROUP BY 
        TRIM(country_name)
    ORDER BY 
        content_count DESC;
   
-- Q)5 Recent Additions
    SELECT title ,date_added FROM netflix
    WHERE date_added IS NOT NULL
    ORDER BY date_added DESC
      
-- Q)6 Longest Movie or TV Show
    SELECT title ,duration, type FROM netflix
    WHERE duration IS NOT NULL
    ORDER BY duration DESC, title ASC

-- Q)7 Genre Popularity by Year ; Find the top 3 common genre for each release year.
    WITH top_genre_ranks AS
    (
    SELECT 
        release_year, 
        genre, 
        COUNT(*) AS title_count,
        RANK() OVER (PARTITION BY release_year ORDER BY COUNT(*) DESC) AS genre_rank
    FROM (
        SELECT 
            release_year, 
            UNNEST(string_to_array(listed_in, ',')) AS genre
        FROM 
            netflix
    ) AS genres
    GROUP BY 
        release_year, genre
    ORDER BY 
        release_year DESC, genre_rank
    )
    
    SELECT * FROM top_genre_ranks
    WHERE genre_rank < 4
    
-- Q)8 Count the number of Movies vs TV Shows per Year
    SELECT release_year,
    type,
    count(*) AS no_of_types
    FROM netflix
    GROUP BY release_year, type
    ORDER BY release_year DESC, type ASC

-- Q)9 Find the top 3 common rating for movies and TV shows
    WITH rating_ranks AS(
    SELECT
    rating,
    count(*) AS no_of_rating,
    RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranks
    FROM netflix
    GROUP BY type, rating
    )
    
    SELECT type, rating FROM rating_ranks
    WHERE ranks < 4

-- Q)10 List all movies released in a specific year (e.g., 2020)
    SELECT * FROM netflix 
    WHERE release_year = 2020 AND type='Movie'
    ORDER BY title ASC
    
-- Q)11 List all movies that are documentaries
    SELECT DISTINCT(title),type, TRIM(genre) AS genre
    FROM(
    SELECT
    	title,
    	type,
    	UNNEST(string_to_array(listed_in,',')) AS genre
    	FROM netflix
    )

    WHERE genre = 'Documentaries' AND type='Movie'
    
-- Q)12 Find content added in the last 5 years
    SELECT date_added
    FROM netflix
    WHERE date_added BETWEEN 
          (SELECT MAX(date_added) FROM netflix) - INTERVAL '4 years'
          AND (SELECT MAX(date_added) FROM netflix)
    ORDER BY date_added ASC;
    

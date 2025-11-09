<h1>Medium SQL Questions with Answers and Objectives </h1>


### 1. **Director with Most Titles**

- **Question**: Find the director with the most titles on the platform.

- **Answer**:
  ```sql
  SELECT director, COUNT(*) AS no_of_titles 
  FROM netflix
  WHERE director IS NOT NULL
  GROUP BY director
  ORDER BY no_of_titles DESC
  LIMIT 5;
  
- **Objective**: This query identifies the top 5 directors with the most titles in the Netflix dataset, helping to identify prolific creators on the platform.

### 2. **Multi-Country Productions**

- **Question**: List the titles of content that were produced in multiple countries.

- **Answer**:
  ```sql
  SELECT title, country
  FROM netflix
  WHERE array_length(string_to_array(country, ','), 1) > 1;
  ```
- **Objective**: This query filters the dataset to find movies and TV shows produced in multiple countries, providing insights into global collaborations.

### 3. **Content by Rating**

- **Question**: Find the number of content items by each rating.

- **Answer**:
  ```sql
  SELECT rating, COUNT(*) AS no_of_content
  FROM netflix
  WHERE rating IS NOT NULL AND NOT rating ~ ' min$'
  GROUP BY rating
  ORDER BY no_of_content DESC;
  ```
- **Objective**: This query returns the count of content items grouped by their rating, excluding the 'min' rating to focus on standard ratings.

### 4. **Duplicate Titles**

- **Question**: Find all the titles that appear more than once in the dataset.

- **Answer**:
  ```sql
  SELECT title, COUNT(*) AS no_of_dup
  FROM netflix
  GROUP BY title
  HAVING COUNT(*) > 1;
  ```

- **Objective**:  This query helps identify duplicate titles in the dataset, which may be caused by different versions or misentries.

### 5. **Yearly Additions**

- **Question**: Find the number of content items added each year.

- **Answer**:
  ```sql
  SELECT EXTRACT(YEAR FROM date_added) AS year_of_addition,
         COUNT(*) AS no_of_content
  FROM NETFLIX
  WHERE date_added IS NOT NULL
  ORDER BY year_of_addition DESC;
  ```
- **Objective**: This query provides insights into the yearly addition of content to Netflix, showing trends in how much content is added annually.

### 6. **Find all Movies/TV Shows by Director 'Rajiv Chilaka'**

- **Question**: List all movies and TV shows directed by 'Rajiv Chilaka'.

- **Answer**:
  ```sql
  SELECT title
  FROM netflix
  WHERE director ~* '(Rajiv Chilaka)';
  ```
- **Objective**: This query filters content created by a specific director, in this case, 'Rajiv Chilaka', helping to gather all of his works on the platform.

### 7. **List all TV Shows with More Than 5 Seasons**

- **Question**: List all TV Shows that have more than 5 seasons.

- **Answer**:
  ```sql
  SELECT title
  FROM netflix
  WHERE type = 'TV Show' AND CAST((string_to_array(duration,' '))[1] AS INTEGER) > 5;
  ```
- **Objective**:  This query filters TV shows with more than 5 seasons, providing insights into longer-running series on Netflix.
### 8. **Count the Number of Content Items in Each Genre**

- **Question**: Count the number of content items in each genre.

- **Answer**:
  ```sql
  SELECT TRIM(genre) AS genre,
         COUNT(*) AS no_of_content
  FROM (
    SELECT UNNEST(string_to_array(listed_in, ',')) AS genre
    FROM netflix
  )
  GROUP BY genre
  ORDER BY no_of_content DESC;
  ```
- **Objective**:  This query counts the number of content items for each genre, helping to analyze the genre distribution in the dataset.

### 9. **Find Each Year and the Average Number of Content Released in India on Netflix**

- **Question**: Find the top 5 years with the highest average content release in India on Netflix.

- **Answer**:
  ```sql
  WITH CTE AS (
    SELECT 
        EXTRACT(YEAR FROM date_added) AS year,
        UNNEST(string_to_array(country, ',')) AS country
    FROM netflix
    WHERE date_added IS NOT NULL
  )
  SELECT 
      year,
      COUNT(*) AS total_titles,
      ROUND(COUNT(*) * 1.0 / 12) AS avg_titles_per_month
  FROM CTE
  WHERE country = 'India'
  GROUP BY year
  ORDER BY avg_titles_per_month DESC
  LIMIT 5;
  ```
- **Objective**: This query calculates the average number of content items released in India per year, helping to identify the top years with the highest content release rate.


### 10. **Categorize Content Based on Keywords 'Kill' and 'Violence'**

- **Question**: Categorize content as 'Bad' or 'Good' based on the presence of keywords 'kill' and 'violence' in the description field.

- **Answer**:
  ```sql
  WITH CTE AS (
    SELECT 
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
  GROUP BY category;
  ```
- **Objective**: This query categorizes content based on the presence of violent or harmful keywords, providing insights into the types of content available on the platform.

### 11. **Find All Content Without a Director**

- **Question**: Find all content items that do not have a director listed.

- **Answer**:
  ```sql
  SELECT * 
  FROM netflix
  WHERE director IS NULL;
  ```
- **Objective**: This query helps to identify content that doesn't have a director listed, which could be useful for data validation or for identifying missing metadata.

### 12. **Most Popular Genre Per Year**

- **Question**: Find the most popular genre for each year.

- **Answer**:
  ```sql
  WITH CTE AS (
    SELECT
        release_year, 
        UNNEST(string_to_array(listed_in, ',')) AS genre,
        COUNT(*) AS total_count,
        RANK() OVER (PARTITION BY release_year ORDER BY COUNT(*) DESC) AS genre_rank
    FROM netflix
    GROUP BY release_year, genre
    ORDER BY release_year DESC, genre_rank
  )
  SELECT release_year, genre, total_count
  FROM CTE
  WHERE genre_rank = 1;
  ```
- **Objective**:  This query identifies the most popular genre for each year based on the number of titles in that genre, helping to highlight trends in content preferences over time.
### 13. **Content Longevity**

- **Question**: Find the average duration for Movies and TV Shows.

- **Answer**:
  ```sql
  SELECT 
      type,
      CASE 
          WHEN type = 'Movie' THEN AVG(CAST(REGEXP_REPLACE(duration, '[^0-9]', '', 'g') AS INT))
          WHEN type = 'TV Show' THEN ROUND(AVG(CAST(REGEXP_REPLACE(duration, '[^0-9]', '', 'g') AS INT)))
      END AS avg_duration
  FROM netflix
  WHERE duration IS NOT NULL
  GROUP BY type;
  ```
- **Question**: This query calculates the average duration for movies and TV shows, helping to analyze the typical length of content by type.


  



 




  

<h1>Easy SQL Questions with Answers and Objectives </h1>


### 1. **Total Movies and TV Shows**


- **Question**: Write a query to find the total number of movies and TV shows available on the platform.

- **Answer**:

  ```sql
  SELECT type, COUNT(*) AS total_count
  FROM netflix
  GROUP BY type;
  
- **Objective**: This query reveals the total number of Movies and TV Shows available on the platform, broken down by their type

  

### 2. **Most Popular Genre**


- **Question**: Write a query to find the total number of movies and TV shows available on the platform.

- **Answer**:

  ```sql
  SELECT listed_in  FROM NETFLIX
  GROUP BY listed_in
  ORDER BY COUNT(*) DESC
  LIMIT 5
  
- **Objective**: This query reveals the total number of Movies and TV Shows available on the platform, broken down by their type




### 3. **Content by Year**


- **Question**: Retrieve the number of titles released each year, ordered from the newest to the oldest.
- **Answer**:

  ```sql
  SELECT YEAR(date_added) AS year_added,
         COUNT(*) AS content_count
  FROM netflix
  WHERE date_added IS NOT NULL
  GROUP BY YEAR(date_added)
  ORDER BY year_added ASC;

  
- **Objective**: This query provides a breakdown of the number of titles released each year, showing trends in content production over time.


### 4. **Top Countries by Content**

- **Question**: Which countries produce the most content on Amazon Prime? Display the top 5 countries.

- **Answer**:

  ```sql
  SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(country, ',', n.n), ',', -1)) AS country,
         COUNT(*) AS content_count
  FROM netflix
  JOIN (
      SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
  ) n
  WHERE n.n <= 1 + LENGTH(country) - LENGTH(REPLACE(country, ',', ''))
  GROUP BY country
  ORDER BY content_count DESC
  LIMIT 5;

  
- **Objective**: This query identifies the top 5 countries that produce the most content on the platform, helping to understand regional contributions to the library.



### 5. **Recent Additions**

- **Question**: List the top 10 most recently added titles (date_added).

- **Answer**:

  ```sql
  SELECT title, date_added
  FROM netflix
  WHERE date_added IS NOT NULL
  ORDER BY date_added DESC
  LIMIT 10;

  
  
- **Objective**: This query retrieves the 10 most recently added titles, providing insights into the latest content updates on the platform.



### 6. **Longest Movie or TV Show**

- **Question**: Find the title and duration of the longest movie or TV show available.

- **Answer**:

  ```sql
  SELECT title, duration, type
  FROM netflix
  WHERE duration IS NOT NULL
  ORDER BY duration DESC, title ASC;

  
- **Objective**: This query identifies the longest movie or TV show based on its duration, highlighting the title with the most extended runtime.



### 7. **Count the number of Movies vs TV Shows per Year**

- **Question**: Count the number of Movies vs TV Shows for each year.

- **Answer**:
  ```sql
  SELECT release_year,
         type,
         count(*) AS no_of_types
  FROM netflix
  GROUP BY release_year, type
  ORDER BY release_year DESC, type ASC;
  ```
  
- **Objective**: This query provides the number of Movies and TV Shows available for each release year, helping to analyze the content distribution by year and type.


### 8. **Find the top 3 common ratings for Movies and TV Shows**

- **Question**: Find the top 3 most common ratings for movies and TV shows.

- **Answer**:
  ```sql
  SELECT type, rating
  FROM (
      SELECT type, rating,
             COUNT(*) AS no_of_rating,
             RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranks
      FROM netflix
      GROUP BY type, rating
  ) x
  WHERE ranks < 4;

  ```

- **Objective**:  This query shows the top 3 most common ratings for Movies and TV Shows, helping to understand the content's suitability and classification by ratings.

### 9. **List all movies released in a specific year (e.g., 2020)**

- **Question**: List all movies released in a specific year, for example, 2020.

- **Answer**:
  ```sql
  SELECT * FROM netflix 
  WHERE release_year = 2020 AND type = 'Movie'
  ORDER BY title ASC;

- **Objective**:  This query filters the dataset to list all movies released in a specific year, in this case, 2020, providing insights into the movie releases of that year.

### 10. **List all movies that are documentaries**

- **Question**: List all movies that are documentaries.

- **Answer**:
  ```sql
  SELECT DISTINCT title, type, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', n.n), ',', -1)) AS genre
  FROM netflix
  JOIN (
      SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
  ) n
  WHERE n.n <= 1 + LENGTH(listed_in) - LENGTH(REPLACE(listed_in, ',', ''))
  AND genre = 'Documentaries'
  AND type = 'Movie';

  ```

- **Objective**: This query identifies and lists all movies categorized as documentaries, filtering the dataset based on the genre field.


### 11. **Find content added in the last 5 years**

- **Question**: Find the content added in the last 5 years.

- **Answer**:
  ```sql
  SELECT date_added
  FROM netflix
  WHERE date_added BETWEEN 
        (SELECT DATE_SUB(MAX(date_added), INTERVAL 4 YEAR) FROM netflix)
        AND
        (SELECT MAX(date_added) FROM netflix)
  ORDER BY date_added ASC;

  ```
- **Objective**: This query retrieves the content added to Netflix in the last 5 years, which is useful for identifying recent releases and trends.

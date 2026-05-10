-- Netflix Project
DROP TABLE IF EXISTS Netflix;
CREATE TABLE Netflix
(
	show_id varchar(6),
	type varchar(10),
	title varchar(150),
	director varchar(208),
	casts varchar(1000),
	country varchar(150),
	date_added varchar(50),
	release_year INT,
	rating varchar(10),
	duration varchar(15),
	listed_in varchar(100),
	description varchar(250)
);

Select * from netflix;

Select Count (*) as total_content
From netflix;

SELECT DISTINCT type
From netflix;

-- 15. Business Problems

-- 1. Count the number of Movies and TV shows.

SELECT
      type,
	  count (*) as total_content
From netflix
Group by type

-- 2. Find the most common rating for Movies and TV shows.

SELECT 
     type,
	 rating
FROM 
    
(
SELECT
      type,
	  rating,
	  COUNT(*),
	  RANK() Over(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
FROM netflix
GROUP BY 1,2
) as t1
WHERE ranking = 1

-- 3. List all the movies realised in a specific year (e.g., 2020)

-- Filter 2020
-- Movie

SELECT * FROM Netflix
WHERE 
    type = 'Movie'
	And
	release_year = 2020;

-- 4. Find the top 5 countries with the most content on Netflix

SELECT
      UNNEST(STRING_TO_ARRAY(country,'.')) as new_country,
	  count(show_id) as total_content
FROM Netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 5. Identify the longest Movie.

SELECT * FROM Netflix
WHERE
	type = 'Movie'
	AND
	duration = (SELECT MAX(duration) FROM Netflix);

-- 6. Find the content added in past 5 years.

SELECT * FROM Netflix
WHERE
	TO_DATE(date_added,'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

SELECT CURRENT_DATE - INTERVAL '5 years'

-- 7. Find all the Movies/TV shows by director 'Rajiv Chilaka'!

SELECT * FROM Netflix
WHERE director ILike '%Rajiv Chilaka%';

-- 8. List all TV shows more than 5 seasons.

SELECT * FROM Netflix
WHERE 
	type = 'TV Show'
	AND 
	SPLIT_PART(duration,' ', 1):: numeric > 5 

-- 9. Find the number of content items in each genre

SELECT 
	UNNEST(STRING_TO_ARRAY (listed_in,',')) as genre,
	COUNT(show_id) as total_content
FROM Netflix
GROUP BY 1

-- 10. Find each year and the average numbers of content release in India on Netflix and
--     return top 5 year with heightest avg content release!

SELECT 
	  EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD, YYYY')) as year,
	  COUNT(*)
FROM Netflix
WHERE country = 'India'
GROUP BY 1

-- 11. List all the movies that are documentaries

SELECT * FROM Netflix
WHERE 
     listed_in ILIKE '%documentaries%';

-- 12. Find all the content without a director

SELECT * FROM Netflix
WHERE director IS NULL

-- 13. How many movies actor 'Salan Khan' appeared in 10 years!

SELECT * FROM Netflix
WHERE
    casts ILIKE '%Salman Khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

-- 14. Find the top 10 actors who have appeared in the higtest number of movies produced in India.

SELECT
UNNEST(STRING_TO_ARRAY(casts,',')) AS actors,
COUNT (*) AS Total_content
FROM Netflix
WHERE country ILIKE '%india%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the 
-- description field. Lable content containing these keywords as 'Bad' and all other content 'Good'.
-- Count how many items fall into each category.

WITH new_table
AS
(
SELECT 
*,
CASE
WHEN
	description ILIKE '%kill%'
	OR
	description ILIKE '%violence%' THEN 'Bad_content'
	ELSE 'Good_content'
	END category
FROM Netflix
)
SELECT
	 category,
	 COUNT(*) AS total_content
FROM new_table
GROUP BY 1


WHERE 
    description ILIKE '%kill%'
	OR
	description ILIKE '%violence%'
	
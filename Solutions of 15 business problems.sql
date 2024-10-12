-- Netflix Data Analysis using SQL
-- Solutions of 15 business problems

SELECT * FROM netflix ;

SELECT COUNT(*) AS total_count FROM netflix;

SELECT 
	DISTINCT type 
FROM netflix;

-- 1. Count the Number of Movies vs TV Shows

SELECT 
	type,
	COUNT(*) AS total_count
FROM netflix 
GROUP BY type;

-- 2. Find the Most Common Rating for Movies and TV Shows

SELECT
	type,
	rating
FROM 
(SELECT 
	type,
	rating,
	COUNT(*) AS total_count,
	RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
FROM netflix
GROUP BY 1,2) as t1
WHERE ranking = 1;

-- 3. List All Movies Released in a Specific Year (e.g., 2020)

SELECT * FROM netflix WHERE type= 'Movie' AND release_year = 2020;

-- 4. Find the Top 5 Countries with the Most Content on Netflix

SELECT 
	UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
	COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 5. Identify the Longest Movie

SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND
	duration IS NOT NULL
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC
LIMIT 1;

-- 6. Find Content Added in the Last 5 Years

SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';

-- 8. List All TV Shows with More Than 5 Seasons

SELECT *
FROM netflix
WHERE 
	type = 'TV Show'
	AND SPLIT_PART(duration, ' ', 1)::INT > 5;

-- 9. Count the Number of Content Items in Each Genre

SELECT
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(*) AS count_content
FROM netflix
GROUP BY 1;

-- 10.Find each year and the percent numbers of content release in India on netflix.

SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	COUNT(*) AS yearly_content,
	ROUND(COUNT(*)::numeric / (SELECT COUNT(*) FROM netflix WHERE country='India')::numeric * 100) AS yearly_percent
FROM netflix
WHERE country = 'India'
GROUP BY year;

-- 11. List All Movies that are Documentaries

SELECT * 
FROM netflix
WHERE listed_in ILIKE '%Documentaries%';

-- 12. Find All Content Without a Director

SELECT * 
FROM netflix
WHERE director IS NULL;

-- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT *
FROM netflix
WHERE 
	casts ILIKE '%Salman Khan%'
	AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;

-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	COUNT(*)
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY actor
ORDER BY 2 DESC
LIMIT 10;


-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;



-- End of reports


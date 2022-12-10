CREATE DATABASE vg_global; -- Creates a new database in schema called vg_global

USE vg_global; -- i want to use vg_global database in schema
CREATE TABLE vg_global_sales(Rank_ INT,			-- Create vg_global_sales table with columns 
							PK VARCHAR(255),	
                            Name VARCHAR(255),	
                            Platform VARCHAR(255),	
                            Year_ NUMERIC(4,0),	
                            Genre VARCHAR(255),
                            Publisher VARCHAR(255),
                            NA_Sales DECIMAL(5,4),
                            EU_Sales DECIMAL(5,4),
                            JP_Sales DECIMAL(5,4),
                            Other_Sales DECIMAL(5,4),
                            Global_Sales DECIMAL(5,4)
								);
-- DROP TABLE vg_global_sales; -- to delete
-- Lets see what our table contains                                 
SELECT * 
FROM vg_global_sales;

-- Step 1. I want to write a query that selects the top 10 Video Game Publishers that are most popular
SELECT Publisher, 
	sum(Global_Sales) total_sales
FROM vg_global_sales
GROUP BY Publisher
ORDER BY total_sales DESC
LIMIT 10; 
-- Nintendo leads with more than US$ 850 Million followed by Electronic Arts and 
-- Sony Entertainment with US$ 709 Million and US$ 382 Million US$ respectively


/* Step 2. I want to write a query that shows which Platforms are the most popular and order this in descending order */
SELECT Platform, 
	SUM(Global_Sales) total_sales
FROM vg_global_sales
GROUP BY Platform
ORDER BY total_sales DESC;
-- The most popular platform is PS2 with an overall sales revenue of ~US$ 690 Million followed by 
-- X360, PS3, PS, Wii and DS all  recording over US$ 300 Million in sales volumes.

-- Now I want to know which Year and Platform had the most video games sold
SELECT Platform,
		Year_, 
        COUNT(Name) games_sold
FROM vg_global_sales
GROUP BY Platform, Year_
ORDER BY games_sold DESC;
-- Highest number of games sold was in 2004 which was recorded by PS2 after recording more than 57,000 games sold


-- 4. Please write a query that shows which genre has had the most games produced for it
SELECT genre,
		COUNT(DISTINCT Name) games_produced 
FROM vg_global_sales
GROUP BY genre
ORDER BY games_produced DESC;
-- In terms of genre, Action (272) and Sports (210) are leading with excess of 200 games produced during the period.

-- 5. Again, I want know which Video Game Publisher has produced the most games within the period?
SELECT	Publisher, 
		COUNT(DISTINCT Name) games_produced
FROM vg_global_sales
GROUP BY 1
ORDER BY games_produced DESC;
-- Both Nintendo (277) and Electronic Arts (212) produced in excess of 200 distinct games during the eperiod. 

/* 6. Please write a query that shows which Video Games for Electronic Arts or 
Activision brought in at least 5M Sales, Order this by Publisher and Sales
 */
SELECT	Name, 
		Publisher,
        SUM(Global_Sales) total_sales
FROM	vg_global_sales
WHERE	Publisher = "Electronic Arts" OR 
		Publisher = "Activision"
GROUP BY Name, Publisher
HAVING total_sales >= 5
ORDER BY total_sales DESC, Publisher;
-- Call of Duty: Advanced by Actiivision was the highest was the highest, grossing in excess of US$ 21 Million whilst the 
-- rest did  below US$ 20 Million.


/*
7. I now want to write a query that shows the count of how many Video Games have had Sales > 5M, 
the total sales for those video games, having been published by Electronic Arts, Nintendo, Activision or Ubisoft
*/

SELECT Name,
Publisher, 
COUNT(Name) number_of_games, 
SUM(Global_Sales) total_sales
FROM vg_global_sales 
WHERE Publisher IN ("Electronic Arts", "Nintendo", "Activision", "Ubisoft")
AND Global_Sales > 5
GROUP BY Name, Publisher
ORDER BY total_sales DESC, number_of_games DESC;
-- Call of Duty 4: Modern Warfare and Battlefield 3 by Activision and Electronic Arts grossed aproximately US$ 16 and 
-- US$ 14.6 Million respectively with 2 games each.

/*8. I want to output a query that shows the *percentage* of Revenues (Global_Sales) contribution that each Publisher 
has contributed. Please ensure that you round the Global_Sales and Percentage Contributions to 2 Decimal Places 
and Order the Query by the Global Sales.
*/
SELECT 
Publisher, 
SUM(Global_Sales) total_sales,
ROUND(SUM(Global_Sales) / (SELECT SUM(Global_Sales) FROM vg_global_sales) * 100, 2) AS Pct_Sales
FROM vg_global_sales
GROUP BY Publisher
ORDER BY total_sales DESC;
-- Nintendo (~19%) and Electronic Arts (~16%) dominate the Video Games Market accounting for a 
-- little over 35% of the Market share. 


/*
9. What is the *percentage* of Video Games developed for each Platform. 
 */
SELECT 
	Platform, 
    COUNT(DISTINCT Name) number_of_games,
    ROUND(COUNT(DISTINCT Name) / (SELECT COUNT(DISTINCT Name) FROM vg_global_sales) * 100, 2) Pct_Dev  
FROM vg_global_sales
GROUP BY Platform
ORDER BY Pct_Dev DESC;
-- Four Platforms, PS2(20.34%), PS3(15.34%), X360(14.13%) and PS(12.75%) recorded double digits in terms 
-- of percentage of number of games developed for them.


/* 10. For Genre, I want to know what *percentage* of Video Games that are developed for each Genre 
as well as the Total Revenues (Global_Sales) rounding the Percetange to 2 Decimal Places.*/

SELECT	Genre,
		COUNT(DISTINCT Name) number_of_games,
        ROUND(COUNT(DISTINCT Name) * 100 / (SELECT COUNT(DISTINCT Name) FROM vg_global_sales), 2) Pct_Dev,
        SUM(Global_Sales) Revenue
FROM vg_global_sales
GROUP BY GENRE
ORDER BY number_of_games DESC, Revenue DESC;
-- For Genre, Action games contributes the highest revenue as well as Perectage of games developed.


/* 11. Please write a query that shows the *percentage* of Video Games developed for each Platform with 
respect to Electronic Arts, Nintendo, Activision and Ubisoft */

SELECT	Platform,
		Publisher,
		COUNT(DISTINCT Name) number_of_games,
        ROUND(COUNT(DISTINCT Name) * 100 / (SELECT COUNT(DISTINCT Name) FROM vg_global_sales), 2) Pct_Dev
FROM vg_global_sales 
WHERE Publisher in ("Electronic Arts", "Nintendo", "Activision", "Ubisoft")
GROUP BY 1
ORDER BY Pct_Dev DESC;
-- PS2 had the most games develoved at 115 which accounts for 7.60% of the overall games developed.



/*
WINDOW FUNCTIONS
12. Finally, using window functions I would write a query that returns the top 3 video games per platform. 
The top 3 video games references sales.
*/

SELECT * 
FROM
(SELECT 
platform,
Name,
SUM(Global_Sales) total_sales,
ROW_NUMBER() OVER (PARTITION BY Platform ORDER BY  SUM(Global_Sales) DESC) number
FROM vg_global_sales
group by Platform, Name
ORDER BY Platform, Global_Sales DESC) New_ 
WHERE number < 4;


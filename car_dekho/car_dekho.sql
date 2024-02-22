use car;


------ Exploratory Analysis ------

-- Overall distribution of cars by their manufacturing year?
SELECT year, COUNT(*) AS num_cars
FROM Car_dekho
GROUP BY year
ORDER BY num_cars DESC;

-- Selling price variation based on the number of kilometers driven?
SELECT 
    CASE 
        WHEN km_driven < 50000 THEN 'Less than 50k km'
        WHEN km_driven BETWEEN 50000 AND 100000 THEN '50k - 100k km'
        ELSE 'More than 100k km'
    END AS km_range,
    AVG(selling_price) AS avg_selling_price
FROM Car_dekho
GROUP BY km_range;

-- Most common fuel type among the listed cars?
SELECT fuel, COUNT(*) AS num_cars
FROM Car_dekho
GROUP BY fuel
ORDER BY num_cars DESC
LIMIT 1;

-- Average mileage of cars?
SELECT AVG(CAST(REPLACE(mileage, ' kmpl', '') AS DECIMAL)) AS avg_mileage
FROM Car_dekho;

-- Distribution of cars based on the number of seats?
SELECT seats, COUNT(*) AS num_cars
FROM Car_dekho
GROUP BY seats
ORDER BY num_cars DESC;

-- Number of cars listed by individual sellers vs dealers?
SELECT seller_type, COUNT(*) AS num_cars
FROM Car_dekho
GROUP BY seller_type;


---- Price Analysis -----

-- What is the average selling price of cars for each manufacturing year?
SELECT year, AVG(selling_price) AS avg_selling_price
FROM car_dekho
GROUP BY year
ORDER BY year;

-- How does the selling price vary based on different fuel types?
SELECT fuel, AVG(selling_price) AS avg_selling_price
FROM car_dekho
GROUP BY fuel;

-- Is there a correlation between transmission type and selling price?
SELECT transmission, AVG(selling_price) AS avg_selling_price
FROM car_dekho
GROUP BY transmission;

-- What is the average selling price of cars based on the number of previous owners?
SELECT owner, AVG(selling_price) AS avg_selling_price
FROM car_dekho
GROUP BY owner
ORDER BY avg_selling_price DESC;

---- Marketing Analysis ----

-- Evolution of Number of Cars Listed Over the Years?

SELECT year, COUNT(*) AS num_cars_listed
FROM car_dekho
GROUP BY year
ORDER BY year;

-- Trend in Selling Prices Over the Years?
SELECT year, 
       (SELECT AVG(selling_price) 
        FROM car_dekho AS sub 
        WHERE sub.year = main.year) AS avg_selling_price
FROM (SELECT DISTINCT year FROM car_dekho) AS main
ORDER BY year;

-- Patterns in Distribution of Cars Based on Fuel Type Over Time?
SELECT year, fuel, num_cars
FROM (
    SELECT year, fuel, COUNT(*) AS num_cars
    FROM car_dekho
    GROUP BY year, fuel
) AS subquery
ORDER BY year, fuel;


-- Variation in Distribution of Cars Based on Seller Type Across Different Years?
SELECT year, seller_type, 
       COUNT(*) OVER(PARTITION BY year, seller_type) AS num_cars
FROM car_dekho
ORDER BY year, seller_type;

--- customer preference analysis --- 
-- Preferred Transmission Type Among Buyers?
WITH TransmissionCounts AS (
    SELECT transmission, COUNT(*) AS num_cars
    FROM car_dekho
    GROUP BY transmission
)
SELECT * FROM TransmissionCounts;

-- Selling Price Variation Between Cars Sold by Individual Sellers vs. Dealers?
SELECT 
    CASE 
        WHEN seller_type = 'Individual' THEN 'Individual'
        ELSE 'Dealer'
    END AS categorized_seller_type,
    AVG(selling_price) AS avg_selling_price
FROM car_dekho
GROUP BY categorized_seller_type;

-- Correlation between number of seats and selling price ? 

SELECT seats, AVG(selling_price) AS avg_selling_price
FROM car_dekho
GROUP BY seats
ORDER BY avg_selling_price;

-- Most Common Owner Type Among the Listed Cars?
SELECT owner, num_cars
FROM (
    SELECT owner, COUNT(*) AS num_cars
    FROM car_dekho
    GROUP BY owner
    ORDER BY num_cars DESC
    LIMIT 1
) AS top_owner;

--- comparative analysis -- 
-- Compare the average selling prices of cars with different fuel types?
SELECT DISTINCT fuel,
AVG(selling_price) OVER (PARTITION BY fuel) AS avg_selling_price
FROM car_dekho
ORDER BY avg_selling_price DESC;

-- Compare the average mileage of cars with different engine types?
SELECT engine, AVG(CAST(REPLACE(mileage, ' kmpl', '') AS DECIMAL)) AS avg_mileage
FROM car_dekho
GROUP BY engine
ORDER BY avg_mileage DESC;

--- Trend Forecasting -- 

-- Identifying Emerging Trends in Fuel Preferences?
SELECT year, fuel, COUNT(*) AS num_cars
FROM car_dekho
WHERE year >= (SELECT MAX(year) - 5 FROM car_dekho) -- Consider recent 5 years
GROUP BY year, fuel
ORDER BY year, fuel;

-- Trend Towards Higher Selling Prices for Certain Car Models Over Time?
SELECT name, year, AVG(selling_price) AS avg_selling_price
FROM car_dekho
GROUP BY name, year
ORDER BY name, year;

-- Predicting Future Demand for Cars?
WITH yearly_sales AS (
    SELECT year, COUNT(*) AS num_cars
    FROM car_dekho
    GROUP BY year
)
SELECT 
    year,
    num_cars,
    LAG(num_cars) OVER (ORDER BY year) AS prev_year_sales,
    (num_cars - LAG(num_cars) OVER (ORDER BY year)) / LAG(num_cars) OVER (ORDER BY year) AS yoy_growth_rate
FROM yearly_sales;

















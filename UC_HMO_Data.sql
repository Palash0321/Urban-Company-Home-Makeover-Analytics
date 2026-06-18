CREATE DATABASE UC_Data

EXEC sp_rename 'Fact_Leads$', 'UC_leads';
EXEC sp_rename 'Dim_KAM$', 'Manager_UC';
EXEC sp_rename 'Dim_Paint$', 'Paint_types';
EXEC sp_rename 'Dim_ProjectManager$', 'ProjectManager_UC';
EXEC sp_rename 'Dim_Region$', 'Region';
EXEC sp_rename 'Dim_Service$', 'HMO_Services';


-- Total Revenue
SELECT
SUM(Revenue) AS Total_Revenue
FROM uc_leads;

-- Monthly Revenue
SELECT MONTH, SUM(Revenue) as Monthly_Revenue
from uc_leads group by MONTH

-- Region-wise Revenue
SELECT
Region,
SUM(Revenue) AS Revenue
FROM uc_leads
GROUP BY Region
ORDER BY Revenue DESC;

-- Top Project Managers
SELECT
Project_Manager,
COUNT(*) AS Hires,
SUM(Revenue) AS Revenue
FROM uc_leads
WHERE Hired = 1
GROUP BY Project_Manager
ORDER BY Revenue DESC;

-- H2G Conversion
SELECT
Month,
ROUND(
COUNT(CASE WHEN Hired=1 THEN 1 END)*100.0 /
COUNT(*),2
) AS H2G_Percentage
FROM uc_leads
GROUP BY Month;

-- Service-wise Revenue
SELECT
Service_Category,
SUM(Revenue) AS Revenue
FROM uc_Leads
GROUP BY Service_Category
ORDER BY Revenue DESC;

-- Top 10 Regions by Leads
SELECT TOP 10
    Region,
    COUNT(*) AS Leads
FROM UC_Leads
GROUP BY Region
ORDER BY Leads DESC;

-- KAM Performance
SELECT
    KAM,
    COUNT(*) AS Leads,
    SUM(Revenue) AS Revenue
FROM UC_Leads
GROUP BY KAM;

-- Paint Brand Analysis
SELECT
    Paint_Brand,
    SUM(Revenue) AS Revenue
FROM UC_Leads
GROUP BY Paint_Brand
ORDER BY Revenue DESC;

-- Average Project Value
SELECT
AVG(Hired_Value) AS Avg_Project_Value
FROM UC_Leads
WHERE Hired = 1;

-- Property Type Analysis
SELECT
    Property_Type,
    SUM(Revenue) AS Revenue
FROM UC_Leads
GROUP BY Property_Type;

-- BHK Analysis
SELECT
    BHK,
    COUNT(*) AS Leads,
    SUM(Revenue) AS Revenue
FROM UC_Leads
GROUP BY BHK;

-- Top 10 Highest Revenue Projects
SELECT TOP 10
    Customer_Name,
    Region,
    Hired_Value
FROM UC_Leads
ORDER BY Hired_Value DESC;

-- Attach Sales Performance
SELECT
    COUNT(*) AS Attach_Hired
FROM UC_Leads
WHERE Attach_Hired = 1;

-- Customer Rating Analysis
SELECT
    Customer_Rating,
    COUNT(*) AS Customers
FROM UC_Leads
GROUP BY Customer_Rating
ORDER BY Customer_Rating DESC;

-- Payment Mode Analysis
SELECT
    Payment_Mode,
    SUM(Revenue) AS Revenue
FROM UC_Leads
GROUP BY Payment_Mode;

-- Lead Source Analysis
SELECT
    Lead_Source,
    COUNT(*) AS Leads,
    SUM(Revenue) AS Revenue
FROM UC_Leads
GROUP BY Lead_Source;

-- Revenue Rank by Region
SELECT 
    Region,
    SUM(Revenue) as Total_Revenue,
    RANK() OVER (ORDER BY SUM(Revenue) DESC) AS Revenue_Rank
FROM UC_leads
GROUP BY Region

-- Top Project Manager Every Month
WITH PM_Revenue AS
(
SELECT
    Month,
    Project_Manager,
    SUM(Revenue) Revenue
FROM UC_Leads
GROUP BY Month, Project_Manager
)

SELECT *
FROM
(
SELECT *,
ROW_NUMBER() OVER
(
PARTITION BY Month
ORDER BY Revenue DESC
) RN
FROM PM_Revenue
) A
WHERE RN = 1;

-- Revenue Contribution %
SELECT
    Region,
    SUM(Revenue) Revenue,
    ROUND(
        SUM(Revenue)*100.0/
        (SELECT SUM(Revenue) FROM UC_Leads),2
    ) AS Revenue_Percentage
FROM UC_Leads
GROUP BY Region;

-- Survey to Hire Funnel
SELECT
SUM(Survey_Completed) AS Surveys,
SUM(Quoted) AS Quotes,
SUM(Hired) AS Hires
FROM UC_Leads;

-- Business Summary Query
SELECT
COUNT(*) AS Total_Leads,
SUM(Hired) AS Total_Hires,
SUM(Revenue) AS Revenue,
AVG(Customer_Rating) AS Avg_Rating,
AVG(Hired_Value) AS Avg_Project_Value
FROM UC_Leads;



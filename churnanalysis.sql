---Create the Database
CREATE DATABASE churn_analysis;

---Create the Staging Table
CREATE TABLE stg_churn (
    Customer_ID VARCHAR,
    Gender VARCHAR,
    Age INT,
    Married VARCHAR,
    State VARCHAR,
    Number_of_Referrals INT,
    Tenure_in_Months INT,
    Value_Deal VARCHAR,
    Phone_Service VARCHAR,
    Multiple_Lines VARCHAR,
    Internet_Service VARCHAR,
    Internet_Type VARCHAR,
    Online_Security VARCHAR,
    Online_Backup VARCHAR,
    Device_Protection_Plan VARCHAR,
    Premium_Support VARCHAR,
    Streaming_TV VARCHAR,
    Streaming_Movies VARCHAR,
    Streaming_Music VARCHAR,
    Unlimited_Data VARCHAR,
    Contract VARCHAR,
    Paperless_Billing VARCHAR,
    Payment_Method VARCHAR,
    Monthly_Charge NUMERIC,
    Total_Charges NUMERIC,
    Total_Refunds NUMERIC,
    Total_Extra_Data_Charges NUMERIC,
    Total_Long_Distance_Charges NUMERIC,
    Total_Revenue NUMERIC,
    Customer_Status VARCHAR,
    Churn_Category VARCHAR,
    Churn_Reason VARCHAR
);


---see the data
SELECT * FROM stg_churn

---Check for Null Values

SELECT 
    COUNT(*) FILTER (WHERE Gender IS NULL) AS gender_nulls,
    COUNT(*) FILTER (WHERE Age IS NULL) AS age_nulls,
    COUNT(*) FILTER (WHERE State IS NULL) AS state_nulls,
    COUNT(*) FILTER (WHERE Churn_Reason IS NULL) AS churn_reason_nulls
FROM stg_churn;

---Clean the Data & Create Final Table

CREATE TABLE prod_churn AS
SELECT 
    Customer_ID,
    Gender,
    Age,
    Married,
    State,
    Number_of_Referrals,
    Tenure_in_Months,
    COALESCE(Value_Deal, 'None') AS Value_Deal,
    Phone_Service,
    COALESCE(Multiple_Lines, 'No') AS Multiple_Lines,
    Internet_Service,
    COALESCE(Internet_Type, 'None') AS Internet_Type,
    COALESCE(Online_Security, 'No') AS Online_Security,
    COALESCE(Online_Backup, 'No') AS Online_Backup,
    COALESCE(Device_Protection_Plan, 'No') AS Device_Protection_Plan,
    COALESCE(Premium_Support, 'No') AS Premium_Support,
    COALESCE(Streaming_TV, 'No') AS Streaming_TV,
    COALESCE(Streaming_Movies, 'No') AS Streaming_Movies,
    COALESCE(Streaming_Music, 'No') AS Streaming_Music,
    COALESCE(Unlimited_Data, 'No') AS Unlimited_Data,
    Contract,
    Paperless_Billing,
    Payment_Method,
    Monthly_Charge,
    Total_Charges,
    Total_Refunds,
    Total_Extra_Data_Charges,
    Total_Long_Distance_Charges,
    Total_Revenue,
    Customer_Status,
    COALESCE(Churn_Category, 'Others') AS Churn_Category,
    COALESCE(Churn_Reason, 'Others') AS Churn_Reason
FROM stg_churn;


---Create Views for Power BI / Analysis

-- Customers who stayed or churned
CREATE VIEW vw_churn_data AS
SELECT * FROM prod_churn
WHERE Customer_Status IN ('Churned', 'Stayed');

-- Customers who joined
CREATE VIEW vw_join_data AS
SELECT * FROM prod_churn
WHERE Customer_Status = 'Joined';

--Sample Analysis Queries
--Count by Gender
SELECT Gender, COUNT(*) AS count
FROM prod_churn
GROUP BY Gender;

---Churn by Contract Type
SELECT Contract, COUNT(*) AS total, 
       COUNT(*) * 1.0 / (SELECT COUNT(*) FROM prod_churn) AS percentage
FROM prod_churn
GROUP BY Contract;

--Revenue by Customer Status
SELECT Customer_Status, SUM(Total_Revenue) AS total_revenue
FROM prod_churn
GROUP BY Customer_Status;
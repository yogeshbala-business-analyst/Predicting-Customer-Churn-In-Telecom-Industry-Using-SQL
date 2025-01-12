# Predicting-Customer-Churn-In-Telecom-Industry-Using-SQL
## Problem Statement:
This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze
Predicting Customer Churn in Telecom Industry Data Set The project involves setting up a Customer_Churn database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries.

## Objectives
Data Collection: Use SQL to query the telecom database and extract relevant data.

Data Preprocessing: Clean and preprocess the data to handle missing values, outliers, and normalize features.


Exploratory Data Analysis (EDA): Perform basic exploratory data analysis to understand the dataset.

Business Analysis: Use SQL to answer specific business questions and derive insights from the sales data.

## Data Set Explanation:
Explain the content and context of the dataset(s), including any preprocessing steps required.

- Content: The dataset includes demographic information, account information, and service usage details of telecom customers.
- Context: The dataset aims to predict customer churn, where 'Churn' is the target variable indicating whether a customer has left the service.
- 
The dataset includes customer-related information such as demographic details, service usage patterns, billing information, and churn status. Preprocessing steps might include:

Handling missing values.

Normalizing numerical features.

Splitting data into relevant subsets for analysis.

## Database Setup 
Database Creation: The project starts by creating a database named project_1
Table Creation: A table named dbo.telecom  is created to store the sales data. The table structure includes columns for Customer ID, Gender, Age, Married, Number of Dependents, City, Zip Code, Latitude, Longitude, Number of Referrals, Tenure in Months, Offer, Phone Service, Avg Monthly Long Distance Charges, Multiple Lines, Internet Service, Internet Type, Avg Monthly GB Download, Online Security, Online Backup, Device Protection Plan, Premium Tech Support, Streaming TV, Streaming Movies, Streaming Music, Unlimited Data, Contract, Paperless Billing, Payment Method, Monthly Charge, Total Charges, Total Refunds, Total Extra Data Charges, Total Long Distance Charges, Total Revenue, Customer Status, Churn Category, Churn Reason

              CREATE TABLE Customers (
           CustomerID VARCHAR(50) PRIMARY KEY,
           Gender BIT,
           Age INT,
           Married BIT,
           Number_of_Dependents INT,
          City VARCHAR(255),
          Zip_Code VARCHAR(10),
          Latitude DECIMAL(9,6),
         Longitude DECIMAL(9,6),
    Number_of_Referrals INT,
    Tenure_in_Months INT,
    Offer VARCHAR(255),
    Phone_Service BIT,
    Avg_Monthly_Long_Distance_Charges DECIMAL(5,2),
    Multiple_Lines BIT,
    Internet_Service BIT,
    Internet_Type VARCHAR(50),
    Avg_Monthly_GB_Download DECIMAL(6,2),
    Online_Security BIT,
    Online_Backup BIT,
    Device_Protection_Plan BIT,
    Premium_Tech_Support BIT,
    Streaming_TV BIT,
    Streaming_Movies BIT,
    Streaming_Music BIT,
    Unlimited_Data BIT,
    Contract VARCHAR(50),
    Paperless_Billing BIT,
    Payment_Method VARCHAR(255),
    Monthly_Charge DECIMAL(5,2),
    Total_Charges DECIMAL(10,2),
    Total_Refunds DECIMAL(5,2),
    Total_Extra_Data_Charges DECIMAL(5,2),
    Total_Long_Distance_Charges DECIMAL(10,2),
    Total_Revenue DECIMAL(10,2),
    Customer_Status VARCHAR(50),
    Churn_Category VARCHAR(50),
    Churn_Reason TEXT

);

## Data Exploration & Cleaning
1. Record Count: Count Total Records in the Datase
   Customer Count: Count Distinct Customer IDs
   Category Count: List of Distinct Customer Statuses
                   List of Distinct Contract Types
   Identify Duplicate Records Based on Customer_ID
   Remove Duplicate Records from the Table


            SELECT COUNT(*) AS TOTAL_COUNT 
            FROM dbo.telecom;

            SELECT COUNT(DISTINCT Customer_ID) AS DISTINCT_CUSTOMERS 
            FROM dbo.telecom;

            SELECT DISTINCT Customer_Status 
            FROM dbo.telecom;

            SELECT DISTINCT Contract 
            FROM dbo.telecom;

       WITH duplicate_record AS (
         SELECT 
        Customer_ID,
        ROW_NUMBER() OVER (PARTITION BY Customer_ID ORDER BY Age) AS     COUNT_VALUE 
        FROM 
        dbo.telecom
       )   
       SELECT 
       Customer_ID
       FROM 
       duplicate_record 
       WHERE 
       COUNT_VALUE > 1;
       WITH duplicate_record AS (
        SELECT 
        Customer_ID,
        ROW_NUMBER() OVER (PARTITION BY Customer_ID ORDER BY Age) AS     COUNT_VALUE 
       FROM 
        dbo.telecom
        )
       DELETE FROM dbo.telecom
       WHERE Customer_ID IN (
       SELECT 
        Customer_ID
       FROM 
        duplicate_record 
       WHERE 
        COUNT_VALUE > 1
       );



## Data Analysis & Findings
### Identify the total number of customers and the churn rate


            SELECT 
            COUNT(*) AS TotalCustomers, 
            (CAST(SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) AS DECIMAL(10,2)) / CAST(COUNT(*) AS DECIMAL(10,2))) * 100 AS ChurnRate 
             FROM 
             dbo.telecom;

### Find the average age of churned customers

        select AVG(Age)as the_average_age_of_churned_customers
		from dbo.telecom 
		where Customer_Status = 'Churned';

### Discover the most common contract types among churned customers

        select contract , count(*) as common_contract 
		 from dbo.telecom where Customer_Status = 'Churned' 
		 group by contract;
### Analyze the distribution of monthly charges among churned customers

	      select 
	      case when Monthly_Charge <= 50 then '0 -50'
	      when Monthly_Charge >50 and Monthly_Charge < 100 then '51-100'
		  when  Monthly_Charge >101 and Monthly_Charge < 150 then '101-150'
		  else '+150'
		  end MonthlyChargeRange,
		  count (*) as churnedcustomer 
		  FROM 
          dbo.telecom where Customer_Status = 'Churned'
	      group by 
	      CASE
	      when Monthly_Charge <= 50 then '0 -50'
	      when Monthly_Charge >50 and Monthly_Charge < 100 then '51-100'
		  when  Monthly_Charge >101 and Monthly_Charge < 150 then '101-150'
		  else '+150'
		  END
	      order by 
	      min(Monthly_Charge) ;
          '''
Create a query to identify the contract types that are most prone to churn
       
         SELECT 
         Contract, 
        COUNT(*) AS TotalCustomers, 
        SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) AS  
         ChurnedCustomers,
        (CAST(SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) AS DECIMAL(10,2)) / CAST(COUNT(*) AS DECIMAL(10,2))) * 100 AS ChurnRate
        FROM 
        dbo.telecom
        GROUP BY 
        Contract
        ORDER BY 
        ChurnRate DESC;




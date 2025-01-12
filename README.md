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

'''sql
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
'''

						create database project_1


						SELECT COUNT(*)AS TOTAL_COUNT from dbo.telecom
						SELECT COUNT(DISTINCT Customer_ID) from dbo.telecom
						SELECT DISTINCT Customer_Status from dbo.telecom
						SELECT DISTINCT Contract from dbo.telecom


						select * from dbo.telecom;


						WITH duplicate_record AS (
							SELECT 
								Customer_ID,
								ROW_NUMBER() OVER (PARTITION BY Customer_ID ORDER BY Age) AS COUNT_VALUE 
							FROM 
								dbo.telecom
						) SELECT 
							Customer_ID
						FROM 
							duplicate_record 
						WHERE 
							COUNT_VALUE > 1;



							WITH duplicate_record AS (
							SELECT 
								Customer_ID,
								ROW_NUMBER() OVER (PARTITION BY Customer_ID ORDER BY Age) AS COUNT_VALUE 
							FROM 
								dbo.telecom
						)

						DELETE FROM  dbo.telecom
						WHERE Customer_ID in ( SELECT 
							Customer_ID
						FROM 
							duplicate_record 
						WHERE 
							COUNT_VALUE > 1 ) ;




						select * from dbo.telecom;
					   --- Identify the total number of customers and the churn rate

						SELECT 
						COUNT(*) AS TotalCustomers, 
						(CAST(SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) AS DECIMAL(10,2)) / CAST(COUNT(*) AS DECIMAL(10,2))) * 100 AS ChurnRate 
						 FROM 
						 dbo.telecom;

					   --Find the average age of churned customers

					select AVG(COALESCE(Age,0))as the_average_age_of_churned_customers
					from dbo.telecom 
					where Customer_Status = 'Churned';

				---	Discover the most common contract types among churned customers

					select contract , count(*) as common_contract 
					 from dbo.telecom where Customer_Status = 'Churned' 
					 group by contract;
	
				--- Analyze the distribution of monthly charges among churned customers

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
					  min(Monthly_Charge)  



				   ---Create a query to identify the contract types that are most prone to churn
				 SELECT 
				Contract, 
				COUNT(*) AS TotalCustomers, 
				SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) AS ChurnedCustomers,
				(CAST(SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) AS DECIMAL(10,2)) / CAST(COUNT(*) AS DECIMAL(10,2))) * 100 AS ChurnRate
			FROM 
				dbo.telecom
			GROUP BY 
				Contract
			ORDER BY 
				ChurnRate DESC;
 
				---	Identify customers with high total charges who have churned
  
			  select Customer_ID,Total_Charges
			   from dbo.telecom 
			   where Customer_Status = 'Churned' and Total_Charges > (select AVG(Total_Charges) from dbo.telecom 
			   where Customer_Status = 'Churned')
			   order by Total_Charges desc;

   ----  7. 	Calculate the total charges distribution for churned and non-churned customers
   
 
			 SELECT 
			  Customer_Status,
			  CASE 
				   WHEN Total_Charges >= 2000 THEN '2000'
				   when Total_Charges > 2000 and Total_Charges < = 5000 then '2000-5000'
				   when Total_Charges > 5000 and Total_Charges < = 7000 then '5000-9000'
				   when Total_Charges > 7000 and Total_Charges < = 10000 then '5000-9000'
				   ELSE '10000 +' 
				   END
				   AS 
				   Total_charges_distribution,
				   COUNT(*) as customer_count
			  from dbo.telecom
			  GROUP BY 
					Customer_Status,
			  CASE
					WHEN Total_Charges >= 2000 THEN '2000'
				   when Total_Charges >2000 and Total_Charges <= 5000 then '2000-5000'
				   when Total_Charges  >5000 and Total_Charges <= 7000 then '5000-9000'
				   when Total_Charges > 7000 and Total_Charges < = 10000 then '5000-9000'
				   ELSE '10000 +'
				   END
				ORDER BY 
				MIN(Total_Charges)

	

            ---Calculate the average monthly charges for different contract types among churned customers

				SELECT 
				Contract, 
				ROUND(AVG(Monthly_Charge),2) as avg_monthly_charges
				from dbo.telecom where Customer_Status = 'Churned'
				GROUP BY Contract


				-- 9. 	Identify customers who have both online security and online backup services and have not churned
				SELECT 
				Customer_ID
				from dbo.telecom where Online_Security = 1 and Online_Backup = 1 and  Customer_Status <> 'Churned';

				--10.  Determine the most common combinations of services among churned customers
					 SELECT 
					  Internet_Service,
					  Phone_Service,
					  count(*) as ChurnedCustomers
					  from dbo.telecom 
					  where Customer_Status = 'Churned'
					  group by 
					  Internet_Service,
					  Phone_Service
					  order by ChurnedCustomers desc

				--11.  Identify the average total charges for customers grouped by gender and marital status
       
					   SELECT 
					   Gender,
					   Married,
					   ROUND(AVG(Total_Charges),2) AS  average_total_charges
					   from dbo.telecom 
					   GROUP BY 
					   Gender,
					   Married
					   ORDER BY average_total_charges DESC

				--12.  Calculate the average monthly charges for different age groups among churned customers

					   SELECT 
					   CASE
						   WHEN Age <25 THEN '19-20'
						   WHEN Age > 25 and Age <=35 THEN '25-35'
						   WHEN Age > 35 and Age <=50 THEN '35-50'
						   WHEN Age > 50 and Age <=65 THEN '50-65'
						   WHEN Age > 65 and Age <=80 THEN '65-75'
						   ELSE '80'
						   END as age_groups,
						  Round(AVG( Monthly_Charge),2) as average_monthly_charges
					   from dbo.telecom
					   where Customer_Status = 'Churned'
					   group by
					   CASE
						   WHEN Age <25 THEN '19-20'
						   WHEN Age > 25 and Age <=35 THEN '25-35'
						   WHEN Age > 35 and Age <=50 THEN '35-50'
						   WHEN Age > 50 and Age <=65 THEN '50-65'
						   WHEN Age > 65 and Age <=80 THEN '65-75'
						   ELSE '80'
						   END 
						   order by 
						   max(Age) ;

				---13.  Determine the average age and total charges for customers with multiple lines and online backup

      
       
					   select 
					   AVG(Age) AS Avg_age ,
					   AVG(Total_Charges) AS AVG_Total_Charges
					   from dbo.telecom where Multiple_Lines = 1 and Online_Backup = 1


				---14.  Identify the contract types with the highest churn rate among senior citizens (age 65 and over)

          
						SELECT
						Contract,
						COUNT(*) AS TotalCustomers,
						SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) AS ChurnedCustomers,
					   (CAST(SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) AS DECIMAL(10,2)) / CAST(COUNT(*) AS DECIMAL(10,2))) * 100 AS ChurnRate
						FROM
					   dbo.telecom
						WHERE
					   Age >= 65
					   AND Customer_Status IS NOT NULL  -- Ensure CustomerStatus is not null
					   GROUP BY
					   Contract
					   ORDER BY
					   ChurnRate DESC;

				-- Calculate the average monthly charges for customers who have multiple lines and streaming TV

						 SELECT
						 AVG(Monthly_Charge) AS AVG_Monthly_Charge
						 FROM
						 dbo.telecom where Multiple_Lines = 1 and Streaming_TV = 1 and Customer_Status = 'Churned';

					--- Identify the customers who have churned and used the most online services
						WITH ChurnedCustomers AS (
					SELECT 
						Customer_ID, 
						Online_Security + Online_Backup + Device_Protection_Plan + Premium_Tech_Support + Streaming_TV + Streaming_Movies + Streaming_Music AS TotalOnlineServices
					   FROM 
						dbo.telecom
					WHERE 
						Customer_Status = 'Churned' )
				SELECT 
					Customer_ID, 
					TotalOnlineServices
				FROM 
					ChurnedCustomers
				ORDER BY 
					TotalOnlineServices DESC
     

				-- Calculate the average age and total charges for customers with different combinations of streaming services



				select
					 Streaming_Movies,
					 Streaming_Music,
					 Streaming_TV, 
					 avg(Age) as avg_age, 
					 ROUND(avg(Total_Charges),2) as total_charges
					 FROM 
					 dbo.telecom WHERE Customer_Status = 'Churned'
					 group by 
					  Streaming_Movies,
					 Streaming_Music,
					 Streaming_TV
					 ORDER BY total_charges DESC


				-- Identify the gender distribution among customers who have churned and are on yearly contracts


						SELECT 
						Gender,
						COUNT(*) AS yearly_contract_Count
						FROM  
						dbo.telecom
						WHERE Contract = 'One Year'  AND Customer_Status = 'Churned'
						GROUP BY Gender




				 --- Calculate the average monthly charges and total charges for customers who have churned, grouped by contract type and internet service type

					  select 
					  Contract,
					  Internet_Type ,
					  round(AVG(Monthly_Charge),2) AS AVG_Monthly_Charge,
					  round(AVG(Total_Charges),2) AS AVG_Total_Charges

					  FROM 
					  dbo.telecom WHERE Customer_Status = 'Churned'
					  group by 
					  Contract,
					  Internet_Type


				---Find the customers who have churned and are not using online services, and their average total charges

					 SELECT 
					 Customer_ID,
					 Total_Charges
					 FROM 
					  dbo.telecom 
					  where Customer_Status = 'Churned' 
					  and Online_Backup = 0 
					  and Online_Security = 0 
					  and Device_Protection_Plan = 0
					  and Premium_Tech_Support = 0
					  order by Total_Charges

				--- Calculate the average monthly charges and total charges for customers who have churned, grouped by the number of dependents


				SELECT  
				Number_of_Dependents, 
				ROUND(AVG(Monthly_Charge),2)AS AVG_Monthly_Charge,
				ROUND(AVG(Total_Charges),2) AS AVG_Total_Charge

				FROM 
				dbo.telecom WHERE Customer_Status = 'Churned' 
				GROUP BY Number_of_Dependents
				ORDER BY Number_of_Dependents 


				----Identify the customers who have churned, and their contract duration in months (for monthly contracts)
						  select 
						  Customer_ID,
						  CASE
							  WHEN 
							  Contract = 'Month-to-Month' THEN Tenure_in_Months
							  ELSE NULL
							  END 
							  AS 
							  Contract_Duration_InMonths
		    
							  FROM 
						  dbo.telecom WHERE Customer_Status = 'Churned' 

						  ORDER BY Contract_Duration_InMonths DESC


				---    Determine the average age and total charges for customers who have churned, grouped by internet service and phone service


						SELECT
						AVG(Age) AS Avg_age,
						ROUND(AVG(Total_Charges),2) as Avg_total_charges,
						Internet_Service,
		
						Phone_Service
						FROM 
						  dbo.telecom
						GROUP BY 
						Internet_Service,
						Phone_Service
		  

				-----  Create a view to find the customers with the highest monthly charges in each contract type
						CREATE VIEW HighCharge_Customers_ByContract AS
	

									SELECT
										Contract,
										Customer_ID,
										 Monthly_Charge
									  FROM
										 dbo.telecom t1
									  WHERE
										 Monthly_Charge = (
										 SELECT MAX(Monthly_Charge)
										 FROM dbo.telecom t2
										 WHERE t1.Contract = t2.Contract);
       

										SELECT * 
										FROM HighCharge_Customers_ByContract;


					----- Create a view to identify customers who have churned and the average monthly charges compared to the overall average

										  CREATE VIEW ChurnedCustomerAvgCharges AS

										  SELECT
										  Customer_ID,
										  Monthly_Charge,
										 (SELECT ROUND(AVG(Monthly_Charge),2) FROM dbo.telecom ) AS OverallAvgMonthlyCharge,
										 CASE
											 WHEN Monthly_Charge > (SELECT AVG(Monthly_Charge) FROM dbo.telecom) THEN 'Above Average'
											 WHEN Monthly_Charge < (SELECT AVG(Monthly_Charge) FROM dbo.telecom ) THEN 'Below Average'
											 ELSE 'Average'
											 END AS ChargeComparison
											 FROM
											 dbo.telecom 
											 WHERE
											 Customer_Status = 'Churned';

									SELECT * FROM ChurnedCustomerAvgCharges


				------------  Create a view to find the customers who have churned and their cumulative total charges over time
                
										   CREATE VIEW Churned_Customer_Cumulative_Charges AS

										   SELECT
										   t1.Customer_ID,
										   t1.Monthly_Charge,
						     
										   SUM (t2.Monthly_Charge) AS CumulativeTotalCharges
										   FROM
										   dbo.telecom t1
										   JOIN
										   dbo.telecom t2 ON t1.Customer_ID = t2.Customer_ID AND t2.Tenure_in_Months <= t1.Tenure_in_Months
										   WHERE
										   t1.Customer_Status = 'Churned'
										   GROUP BY
										   t1.Customer_ID,
										   t1.Monthly_Charge;

							SELECT * FROM Churned_Customer_Cumulative_Charges



									 ------Stored Procedure to Identify High-Value Customers at Risk of Churni

				CREATE PROCEDURE IdentifyHighValueCustomersAtRisk
				AS
				BEGIN
					-- Define threshold for high-value customers (e.g., top 20% by TotalCharges)
					DECLARE @Percentile DECIMAL(5,2) = 0.8; 

					-- Calculate threshold for high-value customers
					DECLARE @HighValueChargeThreshold DECIMAL(10,2);
					SELECT @HighValueChargeThreshold = PERCENTILE_CONT(@Percentile) WITHIN GROUP (ORDER BY Total_Charges) OVER () FROM dbo.telecom; 

					-- Identify high-value customers
					;WITH HighValueCustomers AS (
						SELECT Customer_ID
						FROM dbo.telecom
						WHERE Total_Charges >= @HighValueChargeThreshold
					)

					-- Identify high-value customers at risk (churned)
					SELECT 
						hvc.Customer_ID, 
						c.Total_Charges 
					FROM 
						HighValueCustomers hvc
					JOIN 
						dbo.telecom c ON hvc.Customer_ID = c.Customer_ID
					WHERE 
						c.Customer_Status = 'Churned';

					  END;

					   EXEC IdentifyHighValueCustomersAtRisk;
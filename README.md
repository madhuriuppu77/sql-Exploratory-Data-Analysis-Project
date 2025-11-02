
#  Exploratory Data Analysis (EDA) on SQL Data Warehouse

This project performs **Exploratory Data Analysis (EDA)** on the **Gold Layer** of a SQL-based Data Warehouse that I built using the **Bronze → Silver → Gold** architecture.(check on my last project END-END DATA WAREHOUSE PROJECT(**Bronze → Silver → Gold**)

---

##  Project Description

This project demonstrates how analytical insights can be derived from a **well-structured data warehouse**.  
The data warehouse was designed in three layers:
- **Bronze Layer:** Raw data ingestion from multiple sources (CRM & ERP).
- **Silver Layer:** Cleaned and standardized data with transformations.
- **Gold Layer:** Business-ready fact and dimension models for analytics.

Using the **Gold Layer**, this EDA uncovers:
- Key performance metrics (Total Sales, Orders, Revenue)
- Customer demographics and behavior
- Product category insights
- Country-wise and gender-wise trends
- Top and worst-performing products

The purpose of this project is to showcase how SQL can be used for **data storytelling**, **insight generation**, and **business decision support**.

---

##  Project Overview

###The EDA aims to uncover key insights such as:
**-Total sales, quantity, and average price
-Customer distribution by country and gender
-Product performance by category and subcategory
-Revenue analysis by customer and region
-Top and bottom performing products
-Sales trends and growth patterns over time (yearly, monthly)
-Cumulative and moving average performance tracking
-Product performance compared to average and previous year
-Category contribution to overall revenue (part-to-whole analysis)
-Customer segmentation based on lifetime spending and activity (VIP, Regular, New)
-Customer report and product report**


Final business reporting layer combining all insights for decision-making 

All analysis is performed on **Gold Layer** views:
- `gold.fact_sales`
- `gold.dim_customers`
- `gold.dim_products`

---

##  SQL Analysis Sections

| **Section**                    | **Description**                                                               |
| ------------------------------ | ----------------------------------------------------------------------------- |
| **Database Exploration**       | View all tables, columns, and metadata in the Gold Layer                      |
| **Dimension Exploration**      | Explore customer, country, and product hierarchies                            |
| **Date Exploration**           | Analyze the range and timeline of order activity                              |
| **Customer Insights**          | Identify youngest and oldest customers, and age distribution                  |
| **Business Metrics**           | Compute total sales, quantity, orders, and customers                          |
| **Distribution Analysis**      | Analyze customer distribution by gender and country                           |
| **Product & Revenue Analysis** | Examine total revenue and product performance by category                     |
| **Top/Bottom Analysis**        | Rank top 5 and bottom 5 products based on sales performance                   |
| **Change Over Time Analysis**  | Analyze year-wise, month-wise, and monthly-over-year sales trends             |
| **Cumulative Analysis**        | Compute cumulative sales and moving averages over time using window functions |
| **Performance Analysis**       | Compare each product’s yearly performance with its average and previous years |
| **Part-to-Whole Analysis**     | Identify category contribution percentages to overall sales                   |
| **Customer Segmentation**      | Group customers as VIP, Regular, or New based on spending and lifespan        |
| **Final Reporting View**       | Create business-ready SQL views combining all analytical insights             |


---

##  Example Output

| measure_name         | measure_value |
|----------------------|---------------|
| Total Sales          | 29,356,250    |
| Total Quantity       | 60,423        |
| Average Price        | 486           |
| Total Nr. Orders     | 27,659        |
| Total Nr. Products   | 295           |
| Total Nr. Customers  | 18,484        |

---

##  Tools & Skills Used

- **SQL Server Management Studio (SSMS)**
- **Data Warehousing (Bronze → Silver → Gold Architecture)**
- **SQL Joins, Aggregations, Grouping**
- **Exploratory Data Analysis (EDA)**
- **Data Modeling & Star Schema Design**

---

##  Learning Credit

This project was inspired by concepts and hands-on practice from **Data With Baraa’s SQL and Data Warehouse course**.  
Thanks to the guidance from his tutorials, I could confidently build this end-to-end project independently.

---

##  About Me

Hi, I'm **Madhuri Uppunuthula**   
I'm a **data enthusiast** passionate about converting raw data into actionable insights using **SQL, Python, and visualization tools**.  
I enjoy exploring **healthcare data**, **data analytics**, and **end-to-end data warehouse design**.  
My goal is to build impactful projects that connect **technical skills with real-world business outcomes**.


 *This project showcases not just SQL queries — but the full journey from raw data to insights.*

# Data Analysis Project - Technical Test 1

## Description
This project analyzes users, transactions, and credit card data. 
The analysis focuses on demographic characteristics and transaction errors. 
It includes SQL scripts, Presentation, and a Looker Studio dashboard.

---

## Folder Structure
- `sql/` : SQL scripts for data cleaning, exploratory data analysis (EDA) and reseach question  
- `Presentation/` : Presentation file on PDF    
- `dashboard/` : Link of the dashboard on Looker Studio

---

## How to Run the Code

### 1. Set up MySQL Database
1. Install MySQL or use an existing MySQL server.  
2. Create a new database:

CREATE DATABASE technical_test_1;
USE technical_test_1;

### 2. Import Raw data
1. Load raw CSV files into MySQL (users_data, transactions_data, cards_data) in MySQL Workbench at menu Table data Import Wizard
2. Choose the file path
3. Choose craate new table
4. Check mark on source column and the rest of column
5. Import

### 3. Run the SQL Scripts
1. Execute the SQL Scripts/Data Cleaning.sql
2. Execute the SQL Scripts/EDA.sql
3. Execute the SQL Scripts/Research Query.sql

Export the tables as CSV

### 4. Visualize Data in Looker Studio
1. Open the Looker Studio
2. Import the CSV or make it spreadsheet first with different sheet for every table

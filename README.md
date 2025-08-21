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
```sql
CREATE DATABASE technical_test_1;
USE technical_test_1;
```

### 2. Import Raw data
1. Load the raw CSV files (users_data, transactions_data, cards_data) using MySQL Workbench.
2. Go to Table Data Import Wizard.
3. Choose the CSV file path.
4. Choose craate new table.
5. Map the source columns to the table columns.
6. Click Import to load the data

### 3. Run the SQL Scripts
1. Execute the `SQL Scripts/Data Cleaning.sql`
2. Execute the `SQL Scripts/EDA.sql`
3. Execute the `SQL Scripts/Research Query.sql`
4. Export the tables as CSV for visualization.

### 4. Visualize Data in Looker Studio
1. Open the Looker Studio
2. Import the cleaned CSV files (or convert them to Google Sheets with separate sheets for each table).
3. Build visualizations and dashboards.

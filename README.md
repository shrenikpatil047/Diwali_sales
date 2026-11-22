# Diwali Sales Analysis | Python + MySQL

Exploratory analysis of Diwali sales data to find **who buys the most, where, and what**.
The same analysis is done in **two tools**, Python and SQL, and the results match.

## Project Overview
- **Dataset:** 11,251 records, 15 columns (11,239 rows after cleaning)
- **Goal:** understand customer behavior and find the strongest buyer segments to support marketing decisions
- **Approach:** clean the data, analyze it, visualize it in Python, then repeat the analysis in SQL

## Tools & Technologies
| Area | Tools |
|---|---|
| Python | Pandas, NumPy, Matplotlib, Seaborn, Jupyter Notebook |
| SQL | MySQL 8.0, MySQL Workbench |
| SQL concepts | GROUP BY, CASE WHEN, CTEs, window functions (RANK, DENSE_RANK, ROW_NUMBER) |

## Repository Files
| File | Description |
|---|---|
| `Diwali_Sales_Analysis.ipynb` | Python analysis with charts |
| `sql/Diwali_Sales_Analysis_MySQL.sql` | SQL version of the same analysis |
| `Diwali Sales Data.csv` | Dataset |

## Data Cleaning
- Dropped two completely empty columns (`Status`, `unnamed1`)
- Removed 12 rows with a missing `Amount`
- Renamed `Age Group` to `age_group` for SQL

## Key Insights
- **Women** generate about **70%** of total sales (7,832 buyers vs 3,407 men).
- The **26-35** age group spends the most (about ₹4.26 crore), followed by 36-45 and 18-25.
- **Uttar Pradesh, Maharashtra and Karnataka** are the top 3 states by orders and sales.
- Most buyers are **unmarried** (6,518 vs 4,721 married).
- Top occupations by sales: **IT Sector, Healthcare and Aviation**.
- **Food** is the top product category by sales, followed by Clothing & Apparel and Electronics & Gadgets.
- The **Central** zone generates the most sales.

## Python vs SQL
| Question | Python | SQL |
|---|---|---|
| Sales by gender | `groupby('Gender')['Amount'].sum()` | `GROUP BY gender` + `SUM(amount)` |
| Top 10 states | `.sort_values().head(10)` | `ORDER BY ... LIMIT 10` |
| Drop missing values | `df.dropna()` | `DELETE ... WHERE amount IS NULL` |
| Top 3 categories per zone | not covered | CTE + `ROW_NUMBER() OVER (PARTITION BY zone ...)` |

## Advanced SQL Queries
- Top 3 product categories in each zone (CTE + `ROW_NUMBER`)
- Top 10 customers by total spend (`DENSE_RANK`)
- State ranking and cumulative % of sales (`RANK`, running `SUM() OVER`)
- Best buyer segments by gender + age group + marital status

## Screenshots
**Chart 1: Sales by gender**
<img width="900" height="1080" alt="image" src="https://github.com/user-attachments/assets/2436a7d3-113a-46ab-ace5-09986a6a8df4" />
**Chart 2: Top 10 states by sales**
<img width="900" height="1080" alt="image" src="https://github.com/user-attachments/assets/9c7b65fd-c5da-492b-be4f-fd9b7dbb39bf" />

**Query 1: Sales by gender**
<img width="900" height="1080" alt="image" src="https://github.com/user-attachments/assets/359d36e4-49d0-41e9-a6ed-295803607746" />
**Query 2: Top 5 states**
<img width="900" height="1080" alt="image" src="https://github.com/user-attachments/assets/ebf523f8-1d1a-4c69-8487-97a0eb150033" />


## How to Run
**Python**
1. Clone this repository.
2. Run `pip install pandas numpy matplotlib seaborn jupyter`
3. Open `Diwali_Sales_Analysis.ipynb` and run the cells in order.

**SQL**
1. Import `Diwali Sales Data.csv` into MySQL as a table named `diwali_sales`.
2. Open `sql/Diwali_Sales_Analysis_MySQL.sql` in MySQL Workbench.
3. Run the queries one section at a time.

## Conclusion
Women aged 26-35 from Uttar Pradesh, Maharashtra and Karnataka are the strongest buyer segment. Marketing should focus on Food, Clothing and Electronics for this group.

## Author
**Shrenik Sachin Patil**
Aspiring Data Analyst

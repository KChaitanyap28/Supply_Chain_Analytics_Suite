# Supply Chain & Customer Retention Intelligence Suite

![Dashboard Preview](05_Exports/PowerBI_Demo.gif)

## 📌 Project Overview
**Goal:** As an MBA student specializing in Analytics, I aimed to solve a core E-commerce problem: *High Revenue masking Low Retention.* 
Using the **Olist Brazilian E-Commerce Dataset** (100k+ orders), I built an end-to-end data pipeline to identify high-value customers and shipping inefficiencies.

**Business Impact:**
- Identified **"Hibernating"** customers (High spenders who stopped buying), revealing a potential **15% revenue recovery opportunity**.
- Applied **Pareto Analysis (80/20)** to identify the top 20% of products driving 80% of revenue.
- Engineered a **Star Schema** to optimize query performance by 40%.

## 🛠️ Tech Stack
- **Data Engineering:** Python (Pandas, SQLAlchemy) for ETL.
- **Database:** PostgreSQL (Hosted locally).
- **Transformation:** SQL (Window Functions, CTEs) for Data Cleaning & RFM Segmentation.
- **Visualization:** Microsoft Power BI (DAX, Field Parameters, Drill-throughs).

## 📊 Key Features
1.  **RFM Segmentation:**
    - Segmented base into "Champions", "Loyal", "At Risk", and "Hibernating" using SQL Window Functions.
2.  **Pareto Principle (DAX):**
    - Calculated cumulative revenue dynamically to isolate top performing products.
3.  **Dynamic Dashboard:**
    - Implemented Field Parameters to allow users to toggle between Revenue, Orders, and AOV views.

## 📂 Project Structure
- `02_Python_Scripts/`: ETL Scripts.
- `03_SQL_Queries/`: Logic for RFM & Cleaning.
- `04_PowerBI_Report/`: Dashboard source file.

## ⚙️ Replication Steps
*Note: The raw data is not included due to size constraints.*
1.  Download the dataset from [Kaggle: Olist E-Commerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).
2.  Place CSVs in `01_Raw_Data` folder.
3.  Run `python 02_Python_Scripts/db_ingestion.py`.
4.  Run SQL scripts in `03_SQL_Queries`.
5.  Open the Power BI file.
# SQL — Database Tables, Queries & Views

Relational database covering table design, analytical queries and view creation across a multi-region orders dataset.

## Tech Stack

PostgreSQL

## What's in this project

**Database Design** — six tables created with primary and foreign key constraints: users, returns and four regional orders tables (Central, East, West, South).

**Analytical Queries** — six queries covering: top customers by sales in East region, top product subcategories by order count, average margin and profit by month with subquery filtering, top 5 subcategories ranked by sales using window functions, manager ranking by total profit, and most returned product subcategory.

**Views** — three views created: combined orders across all regions, full orders enriched with return status and manager via joins, and customer summary with total discounts, profits and sales.

**Data Cleaning** — trimming whitespace from order priority column across all regional tables.

**Fact Table** — single fact_orders table created by unioning all four regional tables, ready for reporting and BI tools.

# Power BI

Multi-page interactive dashboard built in Power BI for analyzing sales, profit, customers and delivery performance across regions, product categories and time periods.

## Tech Stack

Power BI, DAX

## Data Model

Star schema with Fact Orders as the central fact table connected to three dimension tables: Date (one-to-many), Users (one-to-many) and Returns (one-to-many).

## Dashboard Pages

**Overview** — KPI cards showing unique orders, unique customers, total sales and total profit. Donut charts for top 5 customers by sales, profit and order count. Bar chart showing product count and total profit by product category.

**Geographic View** — map visual showing total sales and total profit by state, city and postal code. Bubble size represents sales amount, green bubbles indicate positive profit and red bubbles indicate negative profit.

**Order Details** — filterable table with slicers for order priority, product category, state/city and date range. KPI cards for total orders, average sales per order, average profit per order and profit margin. Detailed table with profit indicators per row.

**Sales Decomposition** — decomposition tree breaking down total sales by product category and sub-category. Bar chart for unique orders by city. Pie chart for order count by priority. KPI cards for profit by category and sub-category.

**Time Series & Delivery** — daily profit and sales trend charts with anomaly detection. Heatmap for average shipping cost by order priority. Line chart showing average and median delivery days by order priority.

**Profit Matrix** — cross-tab matrix showing total profit and unique orders by product sub-category and month, with graph/table/all toggle and state filter.

**Drill-through** — detailed drill-through page showing state, city, postal code and total profit KPI cards, with a full order-level table filtered by location.


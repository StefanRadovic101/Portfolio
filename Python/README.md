# Exploratory Data Analysis 

EDA on a multi-region retail orders dataset loaded directly from a PostgreSQL database view, covering univariate, bivariate, multivariate analysis, statistical testing and customer segmentation.

## Tech Stack

Python, pandas, NumPy, matplotlib, seaborn, Plotly, scikit-learn, statsmodels, scipy, SQLAlchemy, PostgreSQL

## What's in this project

**Data Loading** — data loaded directly from a PostgreSQL view combining orders, returns and users tables via SQLAlchemy.

**Data Cleaning** — null value analysis by column and row, missing numeric values filled with median, days between order and ship date calculated as a new feature, postal codes formatted to 5 digits.

**Univariate Analysis** — descriptive statistics, skewness and kurtosis for numeric columns, distribution histograms and boxplots, outlier detection using 3-sigma method, frequency and percentage breakdown for categorical columns, top and bottom 3 categories per column, top and bottom order dates by volume.

**Bivariate Analysis** — correlation analysis for key numeric pairs with scatter plots and regression lines, OLS regression with beta coefficients, p-values and R², crosstab analysis with heatmaps for categorical pairs, group aggregations for categorical vs numeric pairs with bar charts.

**Time Series Analysis** — daily sales and profit trends, 7-day rolling average, monthly aggregations, animated bar chart race for cumulative sales by state and cumulative profit by order priority (weekly).

**Multivariate Analysis** — OLS regression run separately per customer segment to identify how sales, discount, shipping cost, unit price and quantity impact profit across Consumer, Corporate and Home Office segments.

**Customer Segmentation** — customer-level aggregation, StandardScaler normalization, KMeans clustering with elbow method, 3 clusters identified: high-value customers, average customers and financially risky customers with negative profit contribution.

**Statistical Testing** — normality tested via Shapiro-Wilk with log, sqrt and Box-Cox transformations, regional sales differences tested with Kruskal-Wallis test.

## Preview

![Cumulative Profit by Order Priority](profit_by_priority.gif)

## Key Findings

Sales distribution is heavily right-skewed with a small number of orders driving disproportionate impact on total results. High sales does not guarantee profit — discounts, shipping costs and pricing structure are key factors. East region generates the highest profit while South operates at a loss. 9.9% of customers belong to the high-value cluster and contribute the most to overall profitability, while 13.7% are financially risky with negative profit. Medium order priority generated the highest cumulative profit, while Low and Critical priorities ended with cumulative losses.

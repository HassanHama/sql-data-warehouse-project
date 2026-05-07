# 📖 Data Dictionary: Gold Layer (Star Schema)

## 🌟 Overview
The **Gold Layer** represents the final, curated state of the data warehouse. It is modeled using a **Star Schema** to provide high-performance querying and intuitive access for Business Intelligence (BI) tools and stakeholders.

---

## 👥 1. `gold.dim_customers`
**Purpose:** Acts as the "Single Source of Truth" for customer information, integrating data from both CRM and ERP systems.

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| **customer_key** | `INT` | **Primary Key (Surrogate):** Unique identifier generated for the data warehouse. |
| **customer_id** | `INT` | Natural key from the source system. |
| **customer_number** | `VARCHAR(50)` | Business identifier for the customer (e.g., used in cross-referencing). |
| **first_name** | `VARCHAR(50)` | Customer's first name. |
| **last_name** | `VARCHAR(50)` | Customer's last name or surname. |
| **country** | `VARCHAR(50)` | Normalized country of residence (e.g., 'Germany', 'United States'). |
| **marital_status** | `VARCHAR(50)` | Current marital status (e.g., 'Married', 'Single'). |
| **gender** | `VARCHAR(50)` | Standardized gender (e.g., 'Male', 'Female', 'n/a'). |
| **birth_date** | `DATE` | Customer's date of birth (YYYY-MM-DD). |
| **create_date** | `DATE` | Date when the customer record was first created in the source system. |

---

## 🚲 2. `gold.dim_products`
**Purpose:** Stores detailed attributes for all products, enabling filtering and grouping by category and product line.

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| **product_key** | `INT` | **Primary Key (Surrogate):** Unique identifier generated for the warehouse. |
| **product_id** | `INT` | Internal numerical identifier for the product. |
| **product_number** | `VARCHAR(50)` | Unique business code/SKU for the product. |
| **product_name** | `VARCHAR(50)` | Full descriptive name of the product. |
| **category_id** | `VARCHAR(50)` | Identifier linking the product to its specific category code. |
| **category** | `VARCHAR(50)` | High-level product grouping (e.g., 'Bikes', 'Accessories'). |
| **subcategory** | `VARCHAR(50)` | Detailed product classification (e.g., 'Mountain Bikes'). |
| **maintenance** | `VARCHAR(50)` | Flag indicating if the product requires scheduled maintenance ('Yes'/'No'). |
| **cost** | `INT` | Unit cost of the product in whole currency units. |
| **product_line** | `VARCHAR(50)` | Target series for the product (e.g., 'Road', 'Mountain', 'Touring'). |
| **start_date** | `DATE` | Date when this product version was introduced. |

---

## 💰 3. `gold.fact_sales`
**Purpose:** The central fact table containing transactional sales data, linked to dimensions for multi-dimensional analysis.

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| **order_number** | `VARCHAR(50)` | **Unique Identifier:** The transaction ID for the sales order. |
| **product_key** | `INT` | **Foreign Key:** Links to `gold.dim_products`. |
| **customer_key** | `INT` | **Foreign Key:** Links to `gold.dim_customers`. |
| **order_date** | `DATE` | The date the transaction occurred. |
| **shipping_date** | `DATE` | The date the product was dispatched. |
| **due_date** | `DATE` | The expected payment or delivery deadline. |
| **sales_amount** | `INT` | Total revenue for the line item (Quantity x Price). |
| **quantity** | `INT` | Number of units sold. |
| **price** | `INT` | Unit price at the time of sale. |

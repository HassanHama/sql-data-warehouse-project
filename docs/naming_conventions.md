# 🏷️ Naming Conventions

## 🌟 Overview
To ensure the Data Warehouse remains scalable, maintainable, and easy to navigate for all stakeholders, the following naming conventions have been established. These rules apply to all objects across the **Bronze**, **Silver**, and **Gold** layers.

---

## 🏗️ 1. Database & Schema Objects

| Object Type | Convention | Example |
| :--- | :--- | :--- |
| **Schemas** | Short, lowercase layer names | `bronze`, `silver`, `gold` |
| **Tables (Bronze)** | `source_tablename` | `crm_cust_info`, `erp_loc_a101` |
| **Tables (Silver)** | `source_tablename` | `crm_cust_info` (cleaned version) |
| **Views (Gold)** | `dim_` or `fact_` prefix | `dim_customers`, `fact_sales` |
| **Stored Procs** | `load_` + layer name | `load_silver`, `load_gold` |

---

## 📑 2. Column Naming Standards

### **Bronze & Silver Layers**
*In these layers, we maintain a link to the source system naming to simplify debugging.*
- **Prefix:** Use the source system initials (e.g., `cst_` for CRM Customer, `sls_` for CRM Sales).
- **Format:** `snake_case` (all lowercase with underscores).
- **Example:** `cst_firstname`, `sls_ord_num`.

### **Gold Layer (Business Ready)**
*In this layer, we prioritize readability for Business Analysts and BI tools.*
- **Format:** `snake_case` using full, descriptive English words.
- **Rules:**
    - Avoid abbreviations (e.g., use `customer_id` instead of `cust_id`).
    - Use `_key` for Surrogate Keys (Internal DWH identifiers).
    - Use `_id` for Natural Keys (Source system identifiers).
    - Use `_date` for date-only fields.
- **Example:** `customer_key`, `order_number`, `first_name`.

---

## 📂 3. File & Folder Organization

| Folder/File | Convention | Example |
| :--- | :--- | :--- |
| **Layer Folders** | Lowercase layer name | `/bronze`, `/silver`, `/gold` |
| **DDL Scripts** | `ddl_` + table/view name | `ddl_silver.sql`, `ddl_gold.sql` |
| **Load Scripts** | `proc_load_` + layer name | `proc_load_silver.sql` |
| **Test Scripts** | `test_` + layer name | `test_silver.sql` |
| **Master Script** | Prefix with `000_` for priority | `000_master_execute.sql` |

---

## 🛠️ 4. SQL Coding Style

- **Keywords:** All SQL keywords must be in **UPPERCASE** (e.g., `SELECT`, `FROM`, `WHERE`).
- **Aliasing:** Always use the `AS` keyword for explicit column aliasing.
- **Indentation:** Use 4 spaces or a single tab for readability within `SELECT` and `JOIN` blocks.
- **Comments:** Use block comments `/* ... */` for headers and inline comments `--` for specific logic explanations.

---

## ✅ 5. Boolean & Flag Naming
- Use descriptive "Yes/No" strings or 1/0 integers.
- Field names should imply the status.
- **Example:** `is_current`, `maintenance_required`.

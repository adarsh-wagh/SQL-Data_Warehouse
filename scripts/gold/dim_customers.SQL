/*
===============================================================================
View: gold.dim_customers
===============================================================================
Purpose:
    Creates the customer dimension by combining CRM customer information
    with ERP demographic and location data.

Source Tables:
    - silver.crm_cust_info
    - silver.erp_cust_az12
    - silver.erp_loc_a101

Business Rules:
    - Generates a surrogate key using ROW_NUMBER().
    - Uses CRM gender when available.
    - Falls back to ERP gender when CRM gender is UNKNOWN.
    - Enriches customer records with country and birthdate information.

Output:
    One record per customer for analytical reporting.
===============================================================================
*/

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    la.cntry AS country,
    ci.cst_marital_status AS marital_status,
    CASE
        WHEN ci.cst_gndr != 'UNKNOWN' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen,'UNKNOWN')
    END AS gender,
    ca.bdate AS birthdate,
    ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid;

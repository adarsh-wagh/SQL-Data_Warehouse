/*
===============================================================================
View: gold.dim_product
===============================================================================
Purpose:
    Creates the product dimension by combining CRM product data
    with ERP product category information.

Source Tables:
    - silver.crm_prd_info
    - silver.erp_px_cat_g1v2

Business Rules:
    - Generates a surrogate key using ROW_NUMBER().
    - Enriches products with category and subcategory attributes.
    - Excludes historical products by filtering inactive records.
    - Retains only current active products.

Output:
    One record per active product for reporting and analytics.
===============================================================================
*/

CREATE VIEW gold.dim_product AS
SELECT
    ROW_NUMBER() OVER(ORDER BY prd_start_dt) AS product_key,
    pn.prd_id AS product_id,
    pn.prd_key AS product_number,
    pn.prd_nm AS product_name,
    pn.cat_id AS category_id,
    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintenance,
    pn.prd_cost AS cost,
    pn.prd_line AS product_line,
    pn.prd_start_dt AS start_dt
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL;

use supermart;
-- Daily Insights for Category Level Report

-- Set dynamic dates
SET @yesterday = DATE_SUB(CURDATE(), INTERVAL 1 DAY);
SET @two_days_ago = DATE_SUB(CURDATE(), INTERVAL 2 DAY);

SELECT 
    ph.category,
    COUNT(DISTINCT od.order_id) AS orders_yesterday,
    SUM(od.selling_price) AS gmv_yesterday,
    SUM(od.selling_price) * 0.9 AS revenue_yesterday, -- Assuming 10% cost deduction
    COUNT(DISTINCT od.customer_id) AS customers_yesterday,
    COUNT(DISTINCT od.product_id) AS live_products_yesterday,
    COUNT(DISTINCT od.store_id) AS live_stores_yesterday,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date = @yesterday THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date = @yesterday THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    product_hierarchy  ph
    ON od.product_id = ph.product_id
JOIN 
    store_cities  sc
    ON od.store_id = sc.store_id
WHERE 
    od.order_date IN (@yesterday, @two_days_ago)
GROUP BY 
    ph.category;
    
-- Daily Insights for Top 20 Brands Report
SELECT 
    ph.brand,
    COUNT(DISTINCT od.order_id) AS orders_yesterday,
    SUM(od.selling_price) AS gmv_yesterday,
    SUM(od.selling_price) * 0.9 AS revenue_yesterday, 
    COUNT(DISTINCT od.customer_id) AS customers_yesterday,
    COUNT(DISTINCT od.product_id) AS live_products_yesterday,
    COUNT(DISTINCT od.store_id) AS live_stores_yesterday,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date = @yesterday THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date = @yesterday THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    product_hierarchy  ph
    ON od.product_id = ph.product_id
WHERE 
    od.order_date IN (@yesterday, @two_days_ago)
GROUP BY 
    ph.brand
ORDER BY 
    gmv_yesterday DESC
LIMIT 20;

-- Daily Insights for Top 50 Products Report
SELECT 
    od.product_id,
    ph.product,
    ph.brand,
    COUNT(DISTINCT od.order_id) AS orders_yesterday,
    SUM(od.selling_price) AS gmv_yesterday,
    SUM(od.selling_price) * 0.9 AS revenue_yesterday, 
    COUNT(DISTINCT od.customer_id) AS customers_yesterday,
    COUNT(DISTINCT od.product_id) AS live_products_yesterday,
    COUNT(DISTINCT od.store_id) AS live_stores_yesterday,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date = @yesterday THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date = @yesterday THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    product_hierarchy  ph
    ON od.product_id = ph.product_id
WHERE 
    od.order_date IN (@yesterday, @two_days_ago)
GROUP BY 
    od.product_id, ph.product, ph.brand
ORDER BY 
    gmv_yesterday DESC
LIMIT 50;

-- Daily Insights for StoreType_Id Report
SELECT 
    sc.storetype_id,
    COUNT(DISTINCT od.order_id) AS orders_yesterday,
    SUM(od.selling_price) AS gmv_yesterday,
    SUM(od.selling_price) * 0.9 AS revenue_yesterday, 
    COUNT(DISTINCT od.customer_id) AS customers_yesterday,
    COUNT(DISTINCT od.product_id) AS live_products_yesterday,
    COUNT(DISTINCT od.store_id) AS live_stores_yesterday,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date = @yesterday THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date = @yesterday THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date = @two_days_ago THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date = @yesterday THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date = @two_days_ago THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    store_cities  sc
    ON od.store_id = sc.store_id
WHERE 
    od.order_date IN (@yesterday, @two_days_ago)
GROUP BY 
    sc.storetype_id
ORDER BY 
    gmv_yesterday DESC;
    
-- Month-To-Date (MTD) Insights for Category Level Report

-- Set dynamic dates
SET @start_of_month = DATE_FORMAT(CURDATE(), '%Y-%m-01');
SET @start_of_last_month = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01');
SET @end_of_last_month = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));

SELECT 
    ph.category,
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END) AS orders_mtd,
    SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) AS gmv_mtd,
    SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9 AS revenue_mtd, 
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END) AS customers_mtd,
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END) AS live_products_mtd,
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END) AS live_stores_mtd,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    product_hierarchy  ph
    ON od.product_id = ph.product_id
WHERE 
    od.order_date >= @start_of_last_month
GROUP BY 
    ph.category
ORDER BY 
    gmv_mtd DESC;
    
-- Month-To-Date (MTD) Insights for Top 20 Brands Report
SELECT 
    ph.brand,
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END) AS orders_mtd,
    SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) AS gmv_mtd,
    SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9 AS revenue_mtd, 
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END) AS customers_mtd,
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END) AS live_products_mtd,
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END) AS live_stores_mtd,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    product_hierarchy  ph
    ON od.product_id = ph.product_id
WHERE 
    od.order_date >= @start_of_last_month
GROUP BY 
    ph.brand
ORDER BY 
    gmv_mtd DESC
LIMIT 20;

-- Month-To-Date (MTD) Insights for Top 50 Products Report
SELECT 
    od.product_id,
    ph.product,
    ph.brand,
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END) AS orders_mtd,
    SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) AS gmv_mtd,
    SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9 AS revenue_mtd, 
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END) AS customers_mtd,
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END) AS live_products_mtd,
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END) AS live_stores_mtd,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    product_hierarchy  ph
    ON od.product_id = ph.product_id
WHERE 
    od.order_date >= @start_of_last_month
GROUP BY 
    od.product_id, ph.product, ph.brand
ORDER BY 
    gmv_mtd DESC
LIMIT 50;

-- Month-To-Date (MTD) Insights for StoreType_Id Report
SELECT 
    sc.storetype_id,
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END) AS orders_mtd,
    SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) AS gmv_mtd,
    SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9 AS revenue_mtd, 
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END) AS customers_mtd,
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END) AS live_products_mtd,
    COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END) AS live_stores_mtd,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    store_cities  sc
    ON od.store_id = sc.store_id
WHERE 
    od.order_date >= @start_of_last_month
GROUP BY 
    sc.storetype_id
ORDER BY 
    gmv_mtd DESC;

-- Last Month-To-Date (LMTD) Insights for Category Level Report

-- Set dynamic dates
SET @start_of_same_period_last_month = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-%d');
SET @end_of_same_period_last_month = DATE_SUB(CURDATE(), INTERVAL 1 MONTH);
SELECT 
    ph.category,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.order_id END) AS orders_lmtd,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) AS gmv_lmtd,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) * 0.9 AS revenue_lmtd, 
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.customer_id END) AS customers_lmtd,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.product_id END) AS live_products_lmtd,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.store_id END) AS live_stores_lmtd,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    product_hierarchy  ph
    ON od.product_id = ph.product_id
WHERE 
    od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month
GROUP BY 
    ph.category
ORDER BY 
    gmv_lmtd DESC;
    
-- Last Month-To-Date (LMTD) Insights for Top 20 Brands Report
SELECT 
    ph.brand,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.order_id END) AS orders_lmtd,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) AS gmv_lmtd,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) * 0.9 AS revenue_lmtd,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.customer_id END) AS customers_lmtd,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.product_id END) AS live_products_lmtd,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.store_id END) AS live_stores_lmtd,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    product_hierarchy  ph
    ON od.product_id = ph.product_id
WHERE 
    od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month
GROUP BY 
    ph.brand
ORDER BY 
    gmv_lmtd DESC
LIMIT 20;

-- Last Month-To-Date (LMTD) Insights for Top 50 Products Report
SELECT 
    od.product_id,
    ph.product,
    ph.brand,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.order_id END) AS orders_lmtd,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) AS gmv_lmtd,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) * 0.9 AS revenue_lmtd, 
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.customer_id END) AS customers_lmtd,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.product_id END) AS live_products_lmtd,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.store_id END) AS live_stores_lmtd,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    product_hierarchy  ph
    ON od.product_id = ph.product_id
WHERE 
    od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month
GROUP BY 
    od.product_id, ph.product, ph.brand
ORDER BY 
    gmv_lmtd DESC
LIMIT 50;

--  Last Month-To-Date (LMTD) Insights for StoreType_Id Report
SELECT 
    sc.storetype_id,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.order_id END) AS orders_lmtd,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) AS gmv_lmtd,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) * 0.9 AS revenue_lmtd, 
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.customer_id END) AS customers_lmtd,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.product_id END) AS live_products_lmtd,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.store_id END) AS live_stores_lmtd,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    store_cities  sc
    ON od.store_id = sc.store_id
WHERE 
    od.order_date BETWEEN @start_of_last_month AND @end_of_same_period_last_month
GROUP BY 
    sc.storetype_id
ORDER BY 
    gmv_lmtd DESC;
    
-- Last Month (LM) Insights for Category Level Report

SELECT 
    ph.category,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END) AS orders_lm,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) AS gmv_lm,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9 AS revenue_lm, 
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END) AS customers_lm,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END) AS live_products_lm,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END) AS live_stores_lm,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    product_hierarchy  ph
    ON od.product_id = ph.product_id
WHERE 
    od.order_date BETWEEN @start_of_last_month AND @end_of_last_month
GROUP BY 
    ph.category
ORDER BY 
    gmv_lm DESC;
    
-- Last Month (LM) Insights for Top 20 Brands Report
SELECT 
    ph.brand,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END) AS orders_lm,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) AS gmv_lm,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9 AS revenue_lm, 
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END) AS customers_lm,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END) AS live_products_lm,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END) AS live_stores_lm,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    product_hierarchy  ph
    ON od.product_id = ph.product_id
WHERE 
    od.order_date BETWEEN @start_of_last_month AND @end_of_last_month
GROUP BY 
    ph.brand
ORDER BY 
    gmv_lm DESC
LIMIT 20;

-- Last Month (LM) Insights for Top 50 Products Report
SELECT 
    od.product_id,
    ph.product,
    ph.brand,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END) AS orders_lm,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) AS gmv_lm,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9 AS revenue_lm, 
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END) AS customers_lm,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END) AS live_products_lm,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END) AS live_stores_lm,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    product_hierarchy  ph
    ON od.product_id = ph.product_id
WHERE 
    od.order_date BETWEEN @start_of_last_month AND @end_of_last_month
GROUP BY 
    od.product_id, ph.product, ph.brand
ORDER BY 
    gmv_lm DESC
LIMIT 50;

-- Last Month (LM) Insights for StoreType_Id Report
SELECT 
    sc.storetype_id,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END) AS orders_lm,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) AS gmv_lm,
    SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9 AS revenue_lm, 
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END) AS customers_lm,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END) AS live_products_lm,
    COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END) AS live_stores_lm,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.order_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.order_id END), 0)) * 100 AS orders_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END))
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END), 0)) * 100 AS gmv_growth_percent,
    ((SUM(CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.selling_price END) * 0.9 - 
      SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9)
     / NULLIF(SUM(CASE WHEN od.order_date >= @start_of_month THEN od.selling_price END) * 0.9, 0)) * 100 AS revenue_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.customer_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.customer_id END), 0)) * 100 AS customers_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.product_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.product_id END), 0)) * 100 AS live_products_growth_percent,
    ((COUNT(DISTINCT CASE WHEN od.order_date BETWEEN @start_of_last_month AND @end_of_last_month THEN od.store_id END) - 
      COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END))
     / NULLIF(COUNT(DISTINCT CASE WHEN od.order_date >= @start_of_month THEN od.store_id END), 0)) * 100 AS live_stores_growth_percent

FROM 
    order_details  od
JOIN 
    store_cities  sc
    ON od.store_id = sc.store_id
WHERE 
    od.order_date BETWEEN @start_of_last_month AND @end_of_last_month
GROUP BY 
    sc.storetype_id
ORDER BY 
    gmv_lm DESC;






-- Joining both orders and warehouse tables
-- using AS to temporarily rename tables 
SELECT *
FROM [Warehourse Orders].dbo.Orders as orders
JOIN [Warehourse Orders].dbo.Warehouse as warehouse
ON Warehouse.warehouse_id = Orders.warehouse_id; 


--Select every field from orders table and warehouse_alias and state from warehouse table
SELECT orders.*, warehouse.warehouse_alias, warehouse.state	
FROM [Warehourse Orders].dbo.Orders as orders
JOIN [Warehourse Orders].dbo.Warehouse as warehouse
ON Warehouse.warehouse_id = Orders.warehouse_id; 

--How many different states are these warehouses located in?
-- Should use distinct or else same states will be counted more than once. 
SELECT COUNT (DISTINCT warehouse.state)	
FROM [Warehourse Orders].dbo.Orders as orders
JOIN [Warehourse Orders].dbo.Warehouse as warehouse
ON Warehouse.warehouse_id = Orders.warehouse_id; 

-- How many distinct warehouse are there per state?
SELECT COUNT (DISTINCT warehouse.warehouse_id) as Distinct_ID, warehouse.state
FROM [Warehourse Orders].dbo.Orders as orders
JOIN [Warehourse Orders].dbo.Warehouse as warehouse
ON Warehouse.warehouse_id = Orders.warehouse_id
GROUP BY warehouse.state; 

-- Show name of each distinct warehouse in each state.
SELECT DISTINCT warehouse.warehouse_alias, warehouse.state
FROM [Warehourse Orders].dbo.Orders as orders
JOIN [Warehourse Orders].dbo.Warehouse as warehouse
ON Warehouse.warehouse_id = Orders.warehouse_id;

--Which states have orders that still need to be fulfilled?
-- And how many orders does each state need to fulfill?
SELECT 
	COUNT (warehouse.state) as fulfilledOrders, 
	warehouse_alias
FROM [Warehourse Orders].dbo.Orders as orders
JOIN [Warehourse Orders].dbo.Warehouse as warehouse
ON Warehouse.warehouse_id = Orders.warehouse_id
GROUP BY warehouse_alias
ORDER BY fulfilledOrders DESC;

--Need to know the Max, Min, and Avg days it takes for an order to be made and it to be fulfilled.
SELECT
    *,
	DATEDIFF(DAY, order_date, shipper_date) as days_diff
FROM [Warehourse Orders].dbo.Orders
WHERE days_diff = 2;

-- I couldn't add a WHERE clause to the end of the above query because it would return a "INVALID COLUMN NAME" error
-- Below is a way to avoid this error. 

SELECT * 
FROM ( SELECT *, DATEDIFF(DAY, order_date, shipper_date) as days_diff 
		FROM [Warehourse Orders].dbo.Orders) as InnerTable
WHERE days_diff < 2;

--We can finally see the Max, Min, and Avg days it takes the warehouse to fulfill an order. 
SELECT 
	MAX(days_diff) as Max, 
	MIN(days_diff) as Min, 
	AVG(days_diff) as Avg
FROM 
	( SELECT *, DATEDIFF(DAY, order_date, shipper_date) as days_diff 
		FROM [Warehourse Orders].dbo.Orders) 
	as InnerTable;
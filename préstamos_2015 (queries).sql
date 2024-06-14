#2.1
SELECT `country`, `status`,
COUNT(*) AS total_operaciones,
ROUND(AVG(amount), 3) AS importe_promedio
FROM orders
WHERE order_id > 01-07-2015 AND country in ('Francia', 'Portugal', 'España') 
AND amount > 100 AND amount <1500
GROUP BY `country`, `status`;

#2.2
SELECT `country` AS `País`,
COUNT(*) AS total_operaciones,
MAX(`amount`) AS Operación_nivel_máximo,
MIN(`amount`) AS Operación_nivel_mínimo
FROM orders
WHERE `status` NOT IN ('Delinquent', 'Cancelled')
AND `amount` > 100
GROUP BY `country`
ORDER BY total_operaciones DESC
LIMIT 3;

#3.1
SELECT `country` AS País, m.`merchant_id` AS ID_Comercio, `name` AS Nombre,
COUNT(o.`order_id`) AS Total_Operaciones,
ROUND(AVG(o.`amount`), 2) AS Valor_Promedio,
SUM(CASE WHEN r.`order_id` IS NOT NULL THEN 1 ELSE 0 END) AS Total_Devoluciones,
CASE WHEN SUM(CASE WHEN r.order_id IS NOT NULL THEN 1 ELSE 0 END) = 0 THEN 'NO' ELSE 'SÍ' END AS 'acepta devoluciones'
FROM `merchants` AS m
INNER JOIN `orders` AS o ON m.`merchant_id`=o.`merchant_id`
LEFT JOIN `refunds` AS r ON o.order_id = r.order_id
GROUP BY ID_Comercio, `country`, `name`
HAVING COUNT(ID_Comercio) > 10 AND `country` IN ('Marruecos', 'Italia', 'Espana', 'Portugal')
ORDER BY Total_Operaciones ASC;

#3.2
CREATE VIEW orders_view AS
SELECT o.`order_id` AS ID_Operación,
o.`created_at` AS Fecha_Creación,
o.`status` AS Estado,
o.`amount` AS Cantidad,
o.`merchant_id` AS ID_Comercio,
o.`country` AS País,
m.`name` AS Nombre,
COUNT(r.`order_id`) AS Conteo_Devoluciones,
ROUND(SUM(r.`amount`), 2) AS Suma_Valor_Devoluciones
FROM `orders` AS o
INNER JOIN `merchants` AS m ON o.`merchant_id`=m.`merchant_id`
INNER JOIN `refunds` AS r ON o.`order_id` = r.`order_id`
GROUP BY ID_Operación, Fecha_Creación, Estado, Cantidad, ID_Comercio, País, Nombre;

#4
SELECT
m.merchant_id AS ID_Comercio,
m.name AS Nombre,
COUNT(o.order_id) AS total_operaciones,
SUM(CASE WHEN o.`status` = 'CLOSED' THEN 1 ELSE 0 END) AS operaciones_cerradas,
SUM(CASE WHEN o.`status` = 'DELINQUENT' THEN 1 ELSE 0 END) AS operaciones_vencidas,
SUM(CASE WHEN o.`status` = 'ACTIVE' AND o.`created_at` <= '2015-12-31' THEN 1 ELSE 0 END) AS operaciones_activas_a_fin_de_año
FROM `merchants` AS m
JOIN `orders` AS o ON m.merchant_id = o.merchant_id
LEFT JOIN `refunds` AS r ON o.order_id = r.order_id
WHERE o.`created_at` <= '2015-12-31' 
GROUP BY ID_Comercio, Nombre;

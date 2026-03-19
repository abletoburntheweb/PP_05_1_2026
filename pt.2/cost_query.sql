SELECT 
    co.order_number AS "Номер заказа",
    SUM(oi.quantity * si.quantity * mp.price) AS "Полная стоимость материалов"
FROM customer_orders co
JOIN order_items oi ON co.id = oi.order_id
JOIN specifications s ON s.product_id = oi.product_id
JOIN specification_items si ON si.specification_id = s.id
JOIN material_prices mp ON mp.material_id = si.material_id
GROUP BY co.order_number;
\copy customers(customer_id, name, email, phone, city, state, signup_date)
FROM 'C:/Users/DELL/GitHubProjects/ecommerce_db_project/datasets/customers.csv'
DELIMITER ',' CSV HEADER;

\copy products(product_id, name, category, price, stock)
FROM 'C:/Users/DELL/GitHubProjects/ecommerce_db_project/datasets/products.csv'
DELIMITER ',' CSV HEADER;

\copy orders(order_id, customer_id, order_date, status)
FROM 'C:/Users/DELL/GitHubProjects/ecommerce_db_project/datasets/orders.csv'
DELIMITER ',' CSV HEADER;

\copy order_items(order_item_id, order_id, product_id, quantity, total_price)
FROM 'C:/Users/DELL/GitHubProjects/ecommerce_db_project/datasets/order_items.csv'
DELIMITER ',' CSV HEADER;

\copy payments(payment_id, order_id, payment_mode, payment_date, amount)
FROM 'C:/Users/DELL/GitHubProjects/ecommerce_db_project/datasets/payments.csv'
DELIMITER ',' CSV HEADER;

\copy shipments(shipment_id, order_id, shipped_date, delivery_date, delivery_status)
FROM 'C:/Users/DELL/GitHubProjects/ecommerce_db_project/datasets/shipments.csv'
DELIMITER ',' CSV HEADER;

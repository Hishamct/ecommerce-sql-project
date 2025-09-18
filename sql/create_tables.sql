-- Customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(15),
    city VARCHAR(100),
    state VARCHAR(100),
    signup_date DATE
);

-- Products
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(150),
    category VARCHAR(50),
    price NUMERIC(10,2),
    stock INT
);

-- Orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date TIMESTAMP,
    status VARCHAR(50)
);

-- Order Items
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    total_price NUMERIC(10,2)
);

-- Payments
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    payment_mode VARCHAR(50),
    payment_date TIMESTAMP,
    amount NUMERIC(10,2)
);

-- Shipments
CREATE TABLE shipments (
    shipment_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    shipped_date TIMESTAMP,
    delivery_date TIMESTAMP,
    delivery_status VARCHAR(50)
);

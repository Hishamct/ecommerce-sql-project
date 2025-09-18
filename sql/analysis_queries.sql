--Sale by Product Category
SELECT p.category,SUM(oi.total_price) AS category_revenue
FROM products p
JOIN order_items oi
ON p.product_id =oi.product_id
GROUP BY p.category
ORDER BY category_revenue
DESC;

-- TOP 5 Best selling products
SELECT p.name, SUM(oi.total_price) AS product_revenue
FROM products p 
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.name
ORDER BY product_revenue DESC
LIMIT 5;

-- TOP 5 Worst selling products
SELECT p.name, SUM(oi.total_price) AS product_revenue
FROM products p 
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.name
ORDER BY product_revenue ASC
LIMIT 5;

-- Top spending customers
SELECT c.name , SUM(p.amount) AS amount_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY c.name
ORDER BY amount_spent
DESC 
LIMIT 5;

-- loyal customers
SELECT c.name,COUNT(o.order_id) AS total_orders
FROM customers c 
JOIN orders o
ON c.customer_id = o.order_id

--percentage of late deliveries
SELECT COUNT(*) FILTER (WHERE delivery_date > shipped_date + INTERVAL '5 days') * 100.0 / COUNT(*) AS late_delivery_percentage
FROM shipments;

--payment modes
SELECT payment_mode,COUNT(payment_id) AS transactions ,SUM(amount) AS total_amount
FROM payments
GROUP BY payment_mode
ORDER BY transactions
DESC
LIMIT 5;

--Sales in each month
SELECT TO_CHAR(payment_date, 'YYYY-MM') AS month, SUM(amount) AS revenue
FROM payments
GROUP BY TO_CHAR(payment_date, 'YYYY-MM')
ORDER BY month;

--Find monthly revenue for a year using stored procedure

DROP FUNCTION IF EXISTS find_monthly_revenue(INT);

CREATE OR REPLACE FUNCTION find_monthly_revenue(from_year INT)
RETURNS TABLE(month TEXT, revenue NUMERIC) AS $$
BEGIN
    RETURN QUERY
    SELECT TO_CHAR(payment_date, 'Mon') AS month, SUM(amount) AS revenue
    FROM payments
    WHERE EXTRACT(YEAR FROM payment_date) = from_year
    GROUP BY TO_CHAR(payment_date, 'Mon'),, EXTRACT(MONTH FROM payment_date)
    ORDER BY EXTRACT(MONTH FROM payment_date);
END;
$$ LANGUAGE plpgsql;

SELECT proname, proargtypes, prorettype::regtype
FROM pg_proc
WHERE proname = 'find_monthly_revenue';
SELECT * FROM find_monthly_revenue(2025);

--Trigger to prevent invalid orders
CREATE OR REPLACE FUNCTION validate_order_status()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status NOT IN ('Pending', 'Shipped', 'Delivered', 'Cancelled') THEN
        RAISE EXCEPTION 'Invalid order status: %', NEW.status;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_validate_order_status ON orders;

CREATE TRIGGER trg_validate_order_status
BEFORE INSERT OR UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION validate_order_status();


CREATE OR REPLACE FUNCTION update_delivery_status()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.delivery_date < CURRENT_DATE THEN
        NEW.delivery_status := 'Delivered';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_delivery_status ON shipments;
CREATE TRIGGER trg_update_delivery_status
BEFORE INSERT OR UPDATE ON shipments
FOR EACH ROW
EXECUTE FUNCTION update_delivery_status();


CREATE TABLE customer_logs (
    log_id SERIAL PRIMARY KEY,
    customer_id INT,
    signup_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    message TEXT
);
CREATE OR REPLACE FUNCTION log_new_customer()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO customer_logs(customer_id, message)
    VALUES(NEW.customer_id, 'New customer signed up');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_customer_signup
AFTER INSERT ON customers
FOR EACH ROW
EXECUTE FUNCTION log_new_customer();

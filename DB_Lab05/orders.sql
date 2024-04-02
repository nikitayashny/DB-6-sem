use SHOP_DB;

select * from orders;
select * from composition_of_orders;
select * from customers;

-- add_order(customer_id, total_amount, status_id);
-- delete_order(order_id);
-- add_order_composition(order_id, product_id, quantity);
-- delete_order_composition(order_id)

-------------------------------------------------------- ЗАКАЗЫ ----------------------------------------------------------------

-- процедура создания заказа
CREATE OR ALTER PROCEDURE add_order
    @p_customer_id INT,
    @p_total_amount DECIMAL,
    @p_status_id INT
AS
BEGIN
    DECLARE @p_order_id INT;

    SELECT @p_order_id = MAX(order_id)
    FROM orders;

    SET @p_order_id = ISNULL(@p_order_id, 0) + 1;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO orders (order_id, customer_id, order_date, total_amount, status_id)
        VALUES (@p_order_id, @p_customer_id, GETDATE(), @p_total_amount, @p_status_id);

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;

        THROW;
    END CATCH;
END;

-- удаление заказа
CREATE OR ALTER PROCEDURE delete_order
    @p_order_id INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM orders
        WHERE order_id = @p_order_id;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('Заказ %d не найден.', 16, 1, @p_order_id);
            ROLLBACK;
            RETURN;
        END

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;

        THROW;
    END CATCH;
END;

-- добавление состава заказа
CREATE OR ALTER PROCEDURE add_order_composition
    @p_order_id INT,
    @p_product_id INT,
    @p_quantity INT
AS
BEGIN
    DECLARE @p_composition_id INT;

    SELECT @p_composition_id = MAX(composition_id)
    FROM composition_of_orders;

    SET @p_composition_id = ISNULL(@p_composition_id, 0) + 1;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO composition_of_orders (order_id, product_id, quantity, composition_id)
        VALUES (@p_order_id, @p_product_id, @p_quantity, @p_composition_id);

        UPDATE products
        SET quantity = quantity - @p_quantity
        WHERE product_id = @p_product_id;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;

        THROW;
    END CATCH;
END;

-- удаление состава заказа
CREATE OR ALTER PROCEDURE delete_order_composition
    @p_order_id INT
AS
BEGIN
    DECLARE @p_quantity INT;
    DECLARE @p_product_id INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        SELECT @p_quantity = quantity
        FROM composition_of_orders
        WHERE order_id = @p_order_id;

        SELECT @p_product_id = product_id
        FROM composition_of_orders
        WHERE order_id = @p_order_id;

        UPDATE products
        SET quantity = quantity + @p_quantity
        WHERE product_id = @p_product_id;

        DELETE FROM composition_of_orders
        WHERE order_id = @p_order_id;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;

        THROW;
    END CATCH;
END;

-- оформление заказа со стороны пользователя
CREATE OR ALTER PROCEDURE make_order
    @p_product_name VARCHAR(200),
    @p_quantity INT,
	@p_customer_name varchar(200)
AS
BEGIN
    DECLARE @p_order_id INT;
    DECLARE @p_customer_id INT;
    DECLARE @p_total_amount NUMERIC(10, 2);
    DECLARE @p_product_id INT;
    DECLARE @p_current_quantity INT;

    SELECT @p_current_quantity = quantity
    FROM products
    WHERE product_name = @p_product_name;

    IF (@p_quantity > @p_current_quantity)
    BEGIN
        PRINT 'Количество не может превышать имеющееся';
        RETURN;
    END;

    SELECT @p_customer_id = customer_id
    FROM customers
    WHERE name = @p_customer_name;

    SELECT @p_total_amount = @p_quantity * price
    FROM products
    WHERE product_name = @p_product_name;

    SELECT @p_order_id = MAX(order_id)
    FROM orders;

    SET @p_order_id = ISNULL(@p_order_id, 0) + 1;

    SELECT @p_product_id = product_id
    FROM products
    WHERE product_name = @p_product_name;

    BEGIN TRY
        BEGIN TRANSACTION;

        EXEC add_order @p_customer_id, @p_total_amount, 4;

        EXEC add_order_composition @p_order_id, @p_product_id, @p_quantity;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;

        THROW;
    END CATCH;
END;

-- отмена заказа со стороны пользователя
CREATE OR ALTER PROCEDURE undo_order
    @p_order_id INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        EXEC delete_order_composition @p_order_id;
        EXEC delete_order @p_order_id;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;

        THROW;
    END CATCH;
END;
    

-- просмотр своих заказов
-- не создана
CREATE OR REPLACE PROCEDURE GetCustomerOrders
AS
    v_order_id      NUMBER;
    v_order_date    DATE;
    v_total_amount  NUMBER;
    v_status_name   VARCHAR2(50);
    v_product_name  VARCHAR2(200);
    v_product_qty   NUMBER;
    p_customer_id   number;
    p_customer_name varchar2(200);
BEGIN
 select user 
        into p_customer_name 
        from dual;
    
    select customer_id
        into p_customer_id
        from customers
        where first_name = p_customer_name;
    FOR order_rec IN (
    
        SELECT o.order_id, o.order_date, o.total_amount, os.status_name, p.product_name, co.quantity
        FROM orders o
        INNER JOIN order_statuses os ON o.status_id = os.status_id
        INNER JOIN composition_of_orders co ON o.order_id = co.order_id
        INNER JOIN products p ON co.product_id = p.product_id
        WHERE o.customer_id = p_customer_id
    ) LOOP
        v_order_id := order_rec.order_id;
        v_order_date := order_rec.order_date;
        v_total_amount := order_rec.total_amount;
        v_status_name := order_rec.status_name;
        v_product_name := order_rec.product_name;
        v_product_qty := order_rec.quantity;
      
        -- Обработка полученных данных, например, вывод на экран или сохранение в переменные
        DBMS_OUTPUT.PUT_LINE('Order ID: ' || v_order_id || ', Order Date: ' || v_order_date || ', Total Amount: ' || v_total_amount || ', Status: ' || v_status_name || ', Product: ' || v_product_name || ', Quantity: ' || v_product_qty);
    END LOOP;
END;




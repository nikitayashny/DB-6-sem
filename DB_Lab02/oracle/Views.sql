-- select * from sales_by_period_view;          
-- select * from popular_products;
-- select * from total_amount_of_products;
select * from products;

begin
    view_sales_by_period();
end;

begin
    display_popular_products();
end;

begin
    display_total_amount_of_products();
end;
 
begin
    display_product_categories();
end;

begin 
    display_order_information();
end;
    
begin
    display_customer_information();
end;

create public synonym display_customer_information for SYSTEM.display_customer_information;
create public synonym display_order_information for SYSTEM.display_order_information;
create public synonym display_product_categories for SYSTEM.display_product_categories;
create public synonym display_total_amount_of_products for SYSTEM.display_total_amount_of_products;
create public synonym display_popular_products for SYSTEM.display_popular_products;
create public synonym view_sales_by_period for SYSTEM.view_sales_by_period;
create public synonym sales_by_period_view for SYSTEM.sales_by_period_view;
create public synonym popular_products for SYSTEM.popular_products;
create public synonym total_amount_of_products for SYSTEM.total_amount_of_products;

-- количество проданных товаров по периодам
create materialized view sales_by_period_view
refresh complete on commit
as
    select to_char(o.order_date, 'YYYY-MM') as month, p.product_name, sum(co.quantity) as total_quantity
    from orders o
    join composition_of_orders co on o.order_id = co.order_id
    join products p on co.product_id = p.product_id
    group by to_char(o.order_date, 'YYYY-MM'), p.product_name
    order by month desc;
    
-- Процедура для просмотра количества проданных товаров по периодам
create or replace procedure view_sales_by_period
as
begin
    for rec in (select * from sales_by_period_view)
    loop
        dbms_output.put_line('Month: ' || rec.month || ', Product Name: ' || rec.product_name || ', Total Quantity: ' || rec.total_quantity);
    end loop;
end;

-- популярные товары
create materialized view popular_products
refresh complete on commit
as
    select p.product_name, sum(co.quantity) as total_quantity
    from composition_of_orders co
    join products p on co.product_id = p.product_id
    group by p.product_name
    order by total_quantity desc;
    
-- Процедура для просмотра популярных товаров
create or replace procedure display_popular_products
as
begin
    for rec in (select * from popular_products)
    loop
        dbms_output.put_line('Product Name: ' || rec.product_name || ', Total Quantity: ' || rec.total_quantity);
    end loop;
end;
    
-- общее количество товара
create materialized view total_amount_of_products
refresh complete on commit
as
    select product_name, quantity
    from products;

-- процедура которая выводит общее количество товара
create or replace procedure display_total_amount_of_products
as
begin
    for rec in (select *
    from total_amount_of_products
    where product_name not like 'Product%' )
    loop
        dbms_output.put_line('Product Name: ' || rec.product_name || ', Quantity: ' || rec.quantity);
    end loop;
end;

-- процедура которая выводит информацию о существующих категориях
create or replace procedure display_product_categories
as
begin
    for rec in (select * from product_categories)
    loop
        dbms_output.put_line('Category Name: ' || rec.category_name);
    end loop;
end;
    
-- процедура выводящая информацию о всех заказах
create or replace procedure display_order_information
as
begin
    for rec in (
        select c.name as customer_name,
               p.product_name,
               o.order_date,
               o.total_amount,
               os.status_name as order_status
        from customers c
        join orders o on c.customer_id = o.customer_id
        join composition_of_orders co on o.order_id = co.order_id
        join products p on co.product_id = p.product_id
        join order_statuses os on o.status_id = os.status_id
    )
    loop
        dbms_output.put_line('Customer Name: ' || rec.customer_name ||
                             ', Product Name: ' || rec.product_name ||
                             ', Order Date: ' || to_char(rec.order_date, 'DD-MON-YYYY') ||
                             ', Total Amount: ' || rec.total_amount ||
                             ', Order Status: ' || rec.order_status);
    end loop;
    exception
        when others then
        dbms_output.put_line('Ошибка при выполнении процедуры');
        rollback;
        raise;
end;

-- процедура для вывода юзеров
create or replace procedure display_customer_information
as
begin
    for rec in (select * from customers)
    loop
        dbms_output.put_line('Customer ID: ' || rec.customer_id ||
                             ', Name: ' || rec.name ||
                             ', Email: ' || rec.email ||
                             ', Phone Number: ' || rec.phone_number ||
                             ', Address: ' || rec.address);
    end loop;
    exception
        when others then
        dbms_output.put_line('Ошибка при выполнении процедуры');
        rollback;
        raise;
end;
    
    
    
    
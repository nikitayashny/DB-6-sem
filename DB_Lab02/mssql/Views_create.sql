use SHOP_DB;
-- select * from sales_by_period_view;          
-- select * from popular_products;
-- select * from total_amount_of_products;
select * from products;

exec view_sales_by_period;
exec display_popular_products;
exec display_total_amount_of_products;
exec display_product_categories;
exec display_order_information;
exec display_customer_information;

-- количество проданных товаров по периодам
create view sales_by_period_view
with schemabinding
as
select convert(varchar(7), o.order_date, 120) as month,
       p.product_name,
       sum(co.quantity) as total_quantity
from dbo.orders o
join dbo.composition_of_orders co on o.order_id = co.order_id
join dbo.products p on co.product_id = p.product_id
group by convert(varchar(7), o.order_date, 120), p.product_name;
go

-- Процедура для просмотра количества проданных товаров по периодам
create procedure view_sales_by_period
as
begin
    select * from sales_by_period_view;
end;

-- популярные товары
create view popular_products
with schemabinding
as
    select p.product_name, sum(co.quantity) as total_quantity
    from dbo.composition_of_orders co
    join dbo.products p on co.product_id = p.product_id
	group by p.product_name;
go
    
-- Процедура для просмотра популярных товаров
create procedure display_popular_products
as
begin
    select * from popular_products;
end;

-- общее количество товара
create view total_amount_of_products
with schemabinding
as
    select product_name, quantity
    from dbo.products;

-- процедура которая выводит общее количество товара
create procedure display_total_amount_of_products
as
begin
    select * from total_amount_of_products;
end;

-- процедура которая выводит информацию о существующих категориях
create or alter procedure display_product_categories
as
begin
    declare @category_name varchar(100);

    declare cur_product_categories cursor for
    select category_name from product_categories;

    open cur_product_categories;

    fetch next from cur_product_categories into @category_name;

    while @@fetch_status = 0
    begin
        print 'Category Name: ' + @category_name;

        fetch next from cur_product_categories into @category_name;
    end;

    close cur_product_categories;
    deallocate cur_product_categories;
end;

-- процедура выводящая информацию о всех заказах
create or alter procedure display_order_information
as
begin
    set nocount on;

    begin try
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
        order by o.order_date;

    end try
    begin catch
        print 'Ошибка при выполнении процедуры';
        throw;
    end catch;
end;

-- процедура для вывода юзеров
create or alter procedure display_customer_information
as
begin
    set nocount on;

    begin try
        select customer_id, name, email, phone_number, address
        FROM customers;
    end try
    begin catch
        print 'Ошибка при выполнении процедуры';
        throw;
    end catch;
end;
    
    
    
    
select * from orders;
select * from composition_of_orders;
select * from customers;

begin 
    make_order('Джинсы', 1, 'user1');
end;

-- add_order(customer_id, total_amount, status_id);
-- delete_order(order_id);
-- add_order_composition(order_id, product_id, quantity);
-- delete_order_composition(order_id)

-------------------------------------------------------- ЗАКАЗЫ ----------------------------------------------------------------
-- процедура создания заказа
create or replace procedure add_order (
    p_customer_id  in number,
    p_total_amount in number,
    p_status_id    in number
) as
    p_order_id number;
begin
    select max(order_id)
    into p_order_id
    from orders;

    insert into orders
    values (p_order_id + 1, p_customer_id, sysdate, p_total_amount, p_status_id);
    commit;
exception
    when no_data_found then 
        insert into orders
        values (1, p_customer_id, sysdate, p_total_amount, p_status_id);
        commit; 
    when others then
        dbms_output.put_line('Ошибка при добавлении заказа.');
        rollback;
        raise;
end;

-- удаление заказа
create or replace procedure delete_order (
    p_order_id in number
) as
begin
    delete from orders
    where order_id = p_order_id;
    commit;
exception
    when others then 
        dbms_output.put_line('Заказ ' || p_order_id || ' не найден.'); 
        rollback;
        raise;
end;

-- добавление состава заказа
create or replace procedure add_order_composition (
    p_order_id      in number,
    p_product_id    in number,
    p_quantity        in number
) as
    p_composition_id number;
begin
    select max(composition_id)
    into p_composition_id
    from composition_of_orders;

    insert into composition_of_orders
    values (p_order_id, p_product_id, p_quantity, p_composition_id + 1);
    commit;
    
    update products
    set quantity = quantity - p_quantity
    where product_id = p_product_id;
    commit;
exception
    when no_data_found then 
        insert into composition_of_orders
        values (p_order_id, p_product_id, p_quantity, 1);
        commit;
        
    when others then
        dbms_output.put_line('Ошибка при добавлении композиции.');
        rollback;
        raise;
end;

-- удаление состава заказа
create or replace procedure delete_order_composition (
    p_order_id in number
) as
    p_quantity number;
    p_product_id number;
begin
    select quantity
    into p_quantity
    from composition_of_orders
    where order_id = p_order_id;
    
    select product_id
    into p_product_id
    from composition_of_orders
    where order_id = p_order_id;
    
    update products
    set quantity = quantity + p_quantity
    where product_id = p_product_id;
    commit;

    delete from composition_of_orders
    where order_id = p_order_id;
    commit;
exception
    when others then 
        dbms_output.put_line('Композиция ' || p_order_id || ' не найден.'); 
        rollback;
        raise;
end;

-- оформление заказа со стороны пользователя
create or replace procedure make_order (
    p_product_name      in varchar,
    p_quantity          in number,
    p_customer_name     in varchar
) as 
    p_order_id          number;
    p_customer_id       number;
    p_total_amount      number;
    p_product_id        number;
    p_current_quantity  number;
begin
    select quantity 
    into p_current_quantity
    from products
    where product_name = p_product_name;
    
    if (p_quantity > p_current_quantity) then
        dbms_output.put_line('Количество не может превышать имеющееся');
        return;
    end if;
    
    select customer_id 
    into p_customer_id
    from customers 
    where name = p_customer_name;
    
    select p_quantity * price
    into p_total_amount
    from products
    where product_name = p_product_name;
    
    select max(order_id)
    into p_order_id
    from orders; 
    
    select product_id 
    into p_product_id
    from products
    where product_name = p_product_name;
    
    add_order(p_customer_id, p_total_amount, 4);
    add_order_composition(p_order_id + 1, p_product_id, p_quantity); 
exception
    when no_data_found then
        dbms_output.put_line('Такого товара нет.'); 
    when others then 
        dbms_output.put_line('Ошибка при оформлении заказа.'); 
        rollback;
        raise;
end;














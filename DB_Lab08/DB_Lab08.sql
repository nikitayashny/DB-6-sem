-- Задание 2 (создать объектные типы данных (товары и заказы))
create type product_type as object (
    product_id number,
    product_name varchar2(200),
    category_id number,
    price number(10,2),
    description varchar2(255),
    image_url varchar2(200),
    quantity number,

    -- Дополнительный конструктор
    constructor function product_type(
        product_id number,
        product_name varchar2,
        category_id number,
        price number,
        description varchar2,
        image_url varchar2,
        quantity number
    ) return self as result,

    -- Метод сравнения MAP
    map member function product_map return varchar2,

    -- Функция в качестве метода экземпляра
    member function get_total_price return number,

    -- Процедура в качестве метода экземпляра
    member procedure increase_quantity(p_quantity number)
);

create type body product_type as
    -- Дополнительный конструктор
    constructor function product_type(
        product_id number,
        product_name varchar2,
        category_id number,
        price number,
        description varchar2,
        image_url varchar2,
        quantity number
    ) return self as result is
    begin
        self.product_id := product_id;
        self.product_name := product_name;
        self.category_id := category_id;
        self.price := price;
        self.description := description;
        self.image_url := image_url;
        self.quantity := quantity;
        return;
    end;

    -- Метод сравнения MAP
    map member function product_map return varchar2 is
    begin
        return product_name || ' | ' || price || ' | ' || quantity;
    end;

    -- функция в качестве метода экземпляра
    member function get_total_price return number is
    begin
        return price * quantity;
    end;

    -- процедура в качестве метода экземпляра
    member procedure increase_quantity(p_quantity number) is
    begin
        quantity := quantity + p_quantity;
    end;
end;

create type order_type as object (
    order_id number,
    customer_id number,
    order_date date,
    total_amount number,
    status_id number,

    -- дополнительный конструктор
    constructor function order_type(
        order_id number,
        customer_id number,
        order_date date,
        total_amount number,
        status_id number
    ) return self as result,

    -- метод сравнения MAP
    map member function order_map return varchar2,

    -- функция в качестве метода экземпляра
    member function get_status_description return varchar2,

    -- процедура в качестве метода экземпляра
    member procedure update_status(p_status_id number)
);

create type body order_type as
    -- дополнительный конструктор
    constructor function order_type(
        order_id number,
        customer_id number,
        order_date date,
        total_amount number,
        status_id number
    ) return self as result is
    begin
        self.order_id := order_id;
        self.customer_id := customer_id;
        self.order_date := order_date;
        self.total_amount := total_amount;
        self.status_id := status_id;
        return;
    end;

    -- метод сравнения map
    map member function order_map return varchar2 is
    begin
        return 'order id: ' || order_id || ', customer id: ' || customer_id || ', order date: ' || 
        to_char(order_date, 'dd-mon-yyyy') || ', total amount: ' || total_amount;
    end;

    -- функция в качестве метода экземпляра
    member function get_status_description return varchar2 is
        status_desc varchar2(100);
    begin
        -- описание статуса по его идентификатору
        if status_id = 1 then
            status_desc := 'оплачено';
        elsif status_id = 2 then
            status_desc := 'доставлено';
        elsif status_id = 3 then
            status_desc := 'отменено';
        elsif status_id = 4 then
            status_desc := 'в обработке';
        end if;

        return status_desc;
    end;

    -- процедура в качестве метода экземпляра
    member procedure update_status(p_status_id number) is
    begin
        status_id := p_status_id;
    end;
end;

-- Задание 3 (скопировать данные из реляционных таблиц в объектные)
create table object_products of product_type;
create table object_orders of order_type;

insert into object_products
select * from object_products;

insert into object_orders
select * from object_orders;

select product.get_total_price() from object_products product; -- просто пример использования

-- Задание 4 (продемонстрировать применение объектных представлений)
create view product_view of product_type
with object identifier (product_id) as 
select *
from object_products;

select product_name, price from product_view;

-- Задание 5 (Продемонстрировать применение индексов для индексирования по атрибуту и по методу в объектной таблице)
create index idx_product_name on object_products(product_name);
create bitmap index idx_total_price on object_products(op.get_total_price());

select * from object_products where product_name = 'Джинсы';
select * from object_products op where op.get_total_price() > 400;
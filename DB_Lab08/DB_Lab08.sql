-- ������� 2 (������� ��������� ���� ������ (������ � ������))
create type product_type as object (
    product_id number,
    product_name varchar2(200),
    category_id number,
    price number(10,2),
    description varchar2(255),
    image_url varchar2(200),
    quantity number,

    -- �������������� �����������
    constructor function product_type(
        product_id number,
        product_name varchar2,
        category_id number,
        price number,
        description varchar2,
        image_url varchar2,
        quantity number
    ) return self as result,

    -- ����� ��������� MAP
    map member function product_map return varchar2,

    -- ������� � �������� ������ ����������
    member function get_total_price return number,

    -- ��������� � �������� ������ ����������
    member procedure increase_quantity(p_quantity number)
);

create type body product_type as
    -- �������������� �����������
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

    -- ����� ��������� MAP
    map member function product_map return varchar2 is
    begin
        return product_name || ' | ' || price || ' | ' || quantity;
    end;

    -- ������� � �������� ������ ����������
    member function get_total_price return number is
    begin
        return price * quantity;
    end;

    -- ��������� � �������� ������ ����������
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

    -- �������������� �����������
    constructor function order_type(
        order_id number,
        customer_id number,
        order_date date,
        total_amount number,
        status_id number
    ) return self as result,

    -- ����� ��������� MAP
    map member function order_map return varchar2,

    -- ������� � �������� ������ ����������
    member function get_status_description return varchar2,

    -- ��������� � �������� ������ ����������
    member procedure update_status(p_status_id number)
);

create type body order_type as
    -- �������������� �����������
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

    -- ����� ��������� map
    map member function order_map return varchar2 is
    begin
        return 'order id: ' || order_id || ', customer id: ' || customer_id || ', order date: ' || 
        to_char(order_date, 'dd-mon-yyyy') || ', total amount: ' || total_amount;
    end;

    -- ������� � �������� ������ ����������
    member function get_status_description return varchar2 is
        status_desc varchar2(100);
    begin
        -- �������� ������� �� ��� ��������������
        if status_id = 1 then
            status_desc := '��������';
        elsif status_id = 2 then
            status_desc := '����������';
        elsif status_id = 3 then
            status_desc := '��������';
        elsif status_id = 4 then
            status_desc := '� ���������';
        end if;

        return status_desc;
    end;

    -- ��������� � �������� ������ ����������
    member procedure update_status(p_status_id number) is
    begin
        status_id := p_status_id;
    end;
end;

-- ������� 3 (����������� ������ �� ����������� ������ � ���������)
create table object_products of product_type;
create table object_orders of order_type;

insert into object_products
select * from object_products;

insert into object_orders
select * from object_orders;

select product.get_total_price() from object_products product; -- ������ ������ �������������

-- ������� 4 (������������������ ���������� ��������� �������������)
create view product_view of product_type
with object identifier (product_id) as 
select *
from object_products;

select product_name, price from product_view;

-- ������� 5 (������������������ ���������� �������� ��� �������������� �� �������� � �� ������ � ��������� �������)
create index idx_product_name on object_products(product_name);
create bitmap index idx_total_price on object_products(op.get_total_price());

select * from object_products where product_name = '������';
select * from object_products op where op.get_total_price() > 400;
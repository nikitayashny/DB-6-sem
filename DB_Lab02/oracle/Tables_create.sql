alter session set container = SHOP_PDB;

create table product_categories 
(
    category_id   number primary key,
    category_name varchar(200) not null
);

create table products
(
    product_id   number primary key,
    product_name varchar(200) not null,
    category_id  number,
    price        number(10,2) not null,
    description  varchar(255),
    image_url    varchar(200),
    quantity     number default 0,
    foreign key (category_id) references product_categories(category_id)
);

create table customers 
(
    customer_id  number primary key,
    name         varchar2(100) unique,
    email        varchar2(100),
    phone_number varchar2(20),
    address      varchar2(200)
);

create table order_statuses 
(
  status_id   number primary key,
  status_name varchar2(50) not null
);

create table orders 
(
  order_id     number primary key,
  customer_id  number,
  order_date   date,
  total_amount number,
  status_id    number,
  foreign key (customer_id) references customers(customer_id),
  foreign key (status_id) references order_statuses(status_id)
);

create table composition_of_orders
(
  order_id     number,
  product_id   number,
  quantity     number,
  composition_id number primary key,
  foreign key (order_id) references orders(order_id),
  foreign key (product_id) references products(product_id)
);

create table user_cart
(
  cart_id     number primary key,
  customer_id number,
  foreign key (customer_id) references customers(customer_id)
);

create table cart_items
(
  cart_item_id number primary key,
  cart_id      number,
  product_id   number,
  quantity     number,
  foreign key (cart_id) references user_cart(cart_id),
  foreign key (product_id) references products(product_id)
);

select * from user_tables;






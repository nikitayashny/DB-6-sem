use SHOP_DB;

create table product_categories 
(
    category_id   int primary key,
    category_name varchar(200) not null
);

create table products
(
    product_id   int primary key,
    product_name varchar(200) not null,
    category_id  int,
    price        int not null,
    description  varchar(255),
    image_url    varchar(200),
    quantity     int default 0,
    foreign key (category_id) references product_categories(category_id)
);

create table customers 
(
    customer_id  int primary key,
    name         varchar(100) unique,
    email        varchar(100),
    phone_number varchar(20),
    address      varchar(200)
);

create table order_statuses 
(
  status_id   int primary key,
  status_name varchar(50) not null
);

create table orders 
(
  order_id     int primary key,
  customer_id  int,
  order_date   date,
  total_amount int,
  status_id    int,
  foreign key (customer_id) references customers(customer_id),
  foreign key (status_id) references order_statuses(status_id)
);

create table composition_of_orders
(
  order_id     int,
  product_id   int,
  quantity     int,
  composition_id int primary key,
  foreign key (order_id) references orders(order_id),
  foreign key (product_id) references products(product_id)
);

create table user_cart
(
  cart_id     int primary key,
  customer_id int,
  foreign key (customer_id) references customers(customer_id)
);

create table cart_items
(
  cart_item_id int primary key,
  cart_id      int,
  product_id   int,
  quantity     int,
  foreign key (cart_id) references user_cart(cart_id),
  foreign key (product_id) references products(product_id)
);
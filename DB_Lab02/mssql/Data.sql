use SHOP_DB;

insert into product_categories values (1, 'Штаны');
insert into product_categories values (2, 'Рубашка');
insert into product_categories values (3, 'Футболка');
insert into product_categories values (4, 'Юбка');
insert into product_categories values (5, 'Куртка');
insert into product_categories values (6, 'Кофта');

insert into products values (1, 'Джинсы', 1, 60, 'Классические джинсы синего цвета', 'https://example.com/images/jeans.jpg', 10);
insert into products values (2, 'Рубашка поло', 2, 30, 'Мужская рубашка поло белого цвета', 'https://example.com/images/polo-shirt.jpg', 20);
insert into products values (3, 'Футболка с логотипом', 3, 20, 'Женская футболка черного цвета с логотипом', 'https://example.com/images/logo-tshirt.jpg', 15);
insert into products values (4, 'Мини-юбка', 4, 40, 'Мини-юбка из искусственной кожи', 'https://example.com/images/mini-skirt.jpg', 5);
insert into products values (5, 'Куртка пуховая', 5, 100, 'Женская пуховая куртка с капюшоном', 'https://example.com/images/puffer-jacket.jpg', 8);
insert into products values (6, 'Кофта с капюшоном', 6, 50, 'Мужская кофта серого цвета с капюшоном', 'https://example.com/images/hoodie.jpg', 12);
insert into products values (7, 'Штаны спортивные', 1, 50, 'Спортивные штаны черного цвета', 'https://example.com/images/sports-pants.jpg', 20);
insert into products values (8, 'Штаны джоггеры', 1, 40, 'Мужские джоггеры с карманами', 'https://example.com/images/jogger-pants.jpg', 15);
insert into products values (9, 'Рубашка с длинными рукавами', 2, 35, 'Женская рубашка с длинными рукавами', 'https://example.com/images/long-sleeve-shirt.jpg', 10);
insert into products values (10, 'Рубашка с короткими рукавами', 2, 25, 'Мужская рубашка с короткими рукавами', 'https://example.com/images/short-sleeve-shirt.jpg', 18);
insert into products values (11, 'Футболка с принтом', 3, 15, 'Мужская футболка с принтом', 'https://example.com/images/print-tshirt.jpg', 25);
insert into products values (12, 'Футболка поло', 3, 20, 'Женская футболка поло с короткими рукавами', 'https://example.com/images/polo-tshirt.jpg', 12);
insert into products values (13, 'Мини-юбка в клетку', 4, 30, 'Мини-юбка в клетку черно-белого цвета', 'https://example.com/images/checkered-skirt.jpg', 8);
insert into products values (14, 'Макси-юбка', 4, 50, 'Женская макси-юбка с цветочным принтом', 'https://example.com/images/maxi-skirt.jpg', 5);
insert into products values (15, 'Куртка кожаная', 5, 150, 'Мужская кожаная куртка с молнией', 'https://example.com/images/leather-jacket.jpg', 10);
insert into products values (16, 'Куртка ветровка', 5, 80, 'Женская ветровка с капюшоном', 'https://example.com/images/windbreaker-jacket.jpg', 15);
insert into products values (17, 'Кофта с высоким воротником', 6, 40, 'Мужская кофта с высоким воротником', 'https://example.com/images/turtleneck-sweater.jpg', 20);
insert into products values (18, 'Кофта с карманами', 6, 30, 'Женская кофта с карманами', 'https://example.com/images/pocket-sweater.jpg', 18);

insert into customers values (1, 'nikita', 'nikita.yashny@gmail.com', '+375445721239', 'Belarus, Minsk');
insert into customers values (2, 'vitalya', 'evilarthas@mail.ru', '+141141141141', 'Ukraine, Vinnitsa');
insert into customers values (3, 'SHOP_ADMIN', 'admin@gmail.com', '+375447777777', 'USA, Boston');
insert into customers values (4, 'user1', 'user1@gmail.com', '+375446677777', 'Belarus, Minsk');
insert into customers values (5, 'user2', 'user2@gmail.com', '+375445577777', 'Belarus, Minsk');
insert into customers values (6, 'user3', 'user3@gmail.com', '+37544555555', 'Belarus, Minsk');

insert into order_statuses values (1, 'Оплачено');
insert into order_statuses values (2, 'Доставлено');
insert into order_statuses values (3, 'Отменено');
insert into order_statuses values (4, 'В обработке');

insert into orders values (1, 1, getdate(), 50, 2);
insert into orders values (2, 2, getdate(), 30, 1);
insert into orders values(6, 2, '2023-11-06', 50, 2);
insert into orders values(7, 1, '2023-11-08', 40, 2);
insert into orders values(8, 1, '2023-11-08', 40, 2);

insert into composition_of_orders values (1, 8, 1, 1);
insert into composition_of_orders values (1, 11, 1, 2);
insert into composition_of_orders values (2, 13, 1, 3);
insert into composition_of_orders values (6, 16, 1, 7);
insert into composition_of_orders values (7, 5, 1, 8);
insert into composition_of_orders values (8, 5, 1, 9);


insert into user_cart values (1, 1);
insert into user_cart values (2, 2);
insert into user_cart values (3, 3);
insert into user_cart values (4, 4);
insert into user_cart values (5, 5);

insert into cart_items values (1, 1, 1, 1);
insert into cart_items values (2, 2, 5, 2);
insert into cart_items values (3, 2, 6, 1);
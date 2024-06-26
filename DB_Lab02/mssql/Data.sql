use SHOP_DB;

insert into product_categories values (1, '�����');
insert into product_categories values (2, '�������');
insert into product_categories values (3, '��������');
insert into product_categories values (4, '����');
insert into product_categories values (5, '������');
insert into product_categories values (6, '�����');

insert into products values (1, '������', 1, 60, '������������ ������ ������ �����', 'https://example.com/images/jeans.jpg', 10);
insert into products values (2, '������� ����', 2, 30, '������� ������� ���� ������ �����', 'https://example.com/images/polo-shirt.jpg', 20);
insert into products values (3, '�������� � ���������', 3, 20, '������� �������� ������� ����� � ���������', 'https://example.com/images/logo-tshirt.jpg', 15);
insert into products values (4, '����-����', 4, 40, '����-���� �� ������������� ����', 'https://example.com/images/mini-skirt.jpg', 5);
insert into products values (5, '������ �������', 5, 100, '������� ������� ������ � ���������', 'https://example.com/images/puffer-jacket.jpg', 8);
insert into products values (6, '����� � ���������', 6, 50, '������� ����� ������ ����� � ���������', 'https://example.com/images/hoodie.jpg', 12);
insert into products values (7, '����� ����������', 1, 50, '���������� ����� ������� �����', 'https://example.com/images/sports-pants.jpg', 20);
insert into products values (8, '����� ��������', 1, 40, '������� �������� � ���������', 'https://example.com/images/jogger-pants.jpg', 15);
insert into products values (9, '������� � �������� ��������', 2, 35, '������� ������� � �������� ��������', 'https://example.com/images/long-sleeve-shirt.jpg', 10);
insert into products values (10, '������� � ��������� ��������', 2, 25, '������� ������� � ��������� ��������', 'https://example.com/images/short-sleeve-shirt.jpg', 18);
insert into products values (11, '�������� � �������', 3, 15, '������� �������� � �������', 'https://example.com/images/print-tshirt.jpg', 25);
insert into products values (12, '�������� ����', 3, 20, '������� �������� ���� � ��������� ��������', 'https://example.com/images/polo-tshirt.jpg', 12);
insert into products values (13, '����-���� � ������', 4, 30, '����-���� � ������ �����-������ �����', 'https://example.com/images/checkered-skirt.jpg', 8);
insert into products values (14, '�����-����', 4, 50, '������� �����-���� � ��������� �������', 'https://example.com/images/maxi-skirt.jpg', 5);
insert into products values (15, '������ �������', 5, 150, '������� ������� ������ � �������', 'https://example.com/images/leather-jacket.jpg', 10);
insert into products values (16, '������ ��������', 5, 80, '������� �������� � ���������', 'https://example.com/images/windbreaker-jacket.jpg', 15);
insert into products values (17, '����� � ������� ����������', 6, 40, '������� ����� � ������� ����������', 'https://example.com/images/turtleneck-sweater.jpg', 20);
insert into products values (18, '����� � ���������', 6, 30, '������� ����� � ���������', 'https://example.com/images/pocket-sweater.jpg', 18);

insert into customers values (1, 'nikita', 'nikita.yashny@gmail.com', '+375445721239', 'Belarus, Minsk');
insert into customers values (2, 'vitalya', 'evilarthas@mail.ru', '+141141141141', 'Ukraine, Vinnitsa');
insert into customers values (3, 'SHOP_ADMIN', 'admin@gmail.com', '+375447777777', 'USA, Boston');
insert into customers values (4, 'user1', 'user1@gmail.com', '+375446677777', 'Belarus, Minsk');
insert into customers values (5, 'user2', 'user2@gmail.com', '+375445577777', 'Belarus, Minsk');
insert into customers values (6, 'user3', 'user3@gmail.com', '+37544555555', 'Belarus, Minsk');

insert into order_statuses values (1, '��������');
insert into order_statuses values (2, '����������');
insert into order_statuses values (3, '��������');
insert into order_statuses values (4, '� ���������');

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
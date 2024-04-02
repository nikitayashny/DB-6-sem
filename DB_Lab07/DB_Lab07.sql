select * from products;
select * from orders;
select * from customers;

update orders set order_date = '12.03.2024' where order_id = 1;

begin
    display_order_information;
end;

begin
    make_order('Ўтаны спортивные', 1, 'user2');
end;

-- «адание 1 (план продаж дл€ каждого товара на следующий год, увеличива€ продажи 0.5% каждый мес€ц от предыдущего)
with sales_data as (
    select
        co.product_id,
        extract(month from o.order_date) as order_month,
        sum(co.quantity) as total_quantity
    from
        composition_of_orders co
        join orders o on co.order_id = o.order_id
    where
        extract(year from o.order_date) = extract(year from current_date)
    group by
        co.product_id,
        extract(month from o.order_date)
)
select
    product_id,
    order_month,
    total_quantity,
    round(total_quantity * power(1.005, order_month - 1), 2) as sales_plan
from
    sales_data
model
    dimension by (product_id)
    measures (order_month, total_quantity, 0 as sales_plan)
    rules (
        sales_plan[any] = total_quantity[cv()] * power(1.005, order_month[cv()] - 1)
    )
order by
    product_id,
    order_month;
    
-- «адание 2 (–ост, падение, рост стоимости заказа дл€ каждого покупател€)
select *
from orders
match_recognize (
  partition by customer_id
  order by order_date
  measures
    A.order_id as start_order_id,
    B.order_id as dip_order_id,
    C.order_id as end_order_id,
    A.total_amount as start_amount,
    B.total_amount as dip_amount,
    C.total_amount as end_amount
  one row per match
  pattern (A B C)
  define
    B as B.total_amount < A.total_amount,
    C as C.total_amount > B.total_amount
)


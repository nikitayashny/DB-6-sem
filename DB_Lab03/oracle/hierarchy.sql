alter session set container = SHOP_PDB;

select * from product_categories;

-- добавление столбца для иерархии
alter table product_categories
add pid int;

-- добавление процедуры для вывода иерархии
create or replace procedure GetChildCategories (
    p_parent_category_name in varchar
) as
    p_parent_category_id int;
begin
    select category_id into p_parent_category_id
    from product_categories
    where category_name = p_parent_category_name;

    for rec in (select category_id, pid, category_name, level
                from product_categories
                start with pid = p_parent_category_id
                connect by prior category_id = pid)
    loop
        dbms_output.put_line('Category ID: ' || rec.category_id || ', Parent ID: ' || rec.pid || 
                             ', Level: ' || rec.level || ', Category Name: ' || rec.category_name);
    end loop;
end;

begin
    GetChildCategories('Штаны');
end;

-- добавление процедуры для добавления узла
create or replace procedure AddCategoryNode (
    p_parent_category_name in varchar,
    p_new_category_name in varchar
) as
    p_parent_category_id int;
    p_new_category_id int;
begin
    select category_id into p_parent_category_id
    from product_categories
    where category_name = p_parent_category_name;

    select max(category_id) + 1 into p_new_category_id
    from product_categories;

    insert into product_categories (category_id, category_name, pid)
    values (p_new_category_id, p_new_category_name, p_parent_category_id);

    commit;

    dbms_output.put_line('New category "' || p_new_category_name || '" added as a child of "' || p_parent_category_name || '".');
end;

begin
    AddCategoryNode('Юбка','Короткая юбка');
end;

-- добавление процедуры для переноса всех подчинённых узлов
create or replace procedure MoveChildCategories (
    p_old_parent_category_name in varchar,
    p_new_parent_category_name in varchar
) as
    p_old_parent_category_id int;
    p_new_parent_category_id int;
begin
    select category_id into p_old_parent_category_id
    from product_categories
    where category_name = p_old_parent_category_name;

    select category_id into p_new_parent_category_id
    from product_categories
    where category_name = p_new_parent_category_name;
        
    update product_categories
    set pid = p_new_parent_category_id
    where pid = p_old_parent_category_id;

    commit;

    dbms_output.put_line('Child categories moved from "' || p_old_parent_category_name || '" to "' || p_new_parent_category_name || '".');
end;

begin
    MoveChildCategories('Юбка', 'Штаны');
end;

select * from product_categories;




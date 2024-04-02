use SHOP_DB;

-- добавление столбца иерархического типа
alter table product_categories 
add category_path hierarchyid;

--update product_categories set category_name = 'Брюки' WHERE category_id = 8;
--update product_categories set category_path = '/4/' WHERE category_id = 4;

-- создание процедуры, которая отображает все подчинённые узлы с указанием уровня иерархии
create or alter procedure GetChildNodes
@nodeId hierarchyid
as
begin
    select category_id, category_name, category_path.ToString() as category_path
    from product_categories
    where category_path.IsDescendantOf(@nodeId) = 1
    order by category_path
end

exec GetChildNodes @nodeId = '/';

-- создание процедуры, которая добавляет подчинённый узел
create or alter procedure AddChildNode
@parent_category nvarchar(50),
@new_category nvarchar(50)
as 
begin  
    declare @parent_path hierarchyid;
    declare @new_id int;
    set @new_id = (select max(category_id) from product_categories) + 1; 

    select @parent_path = category_path
    from product_categories
    where category_name = @parent_category;
    
    declare @last_child hierarchyid;
    select @last_child = max(category_path) 
    from product_categories  
    where category_path.GetAncestor(1) = @parent_path;
    
    insert into product_categories (category_id, category_name, category_path)  
    select @new_id, @new_category, @parent_path.GetDescendant(@last_child, null);
end;

exec AddChildNode @parent_category = 'Штаны', @new_category = 'Шорты';

-- создание процедуры, которая переместит всех подчинённые узлы
create or alter procedure MoveNodes
@oldMgr nvarchar(256),
@newMgr nvarchar(256)
as
begin
    declare @nold hierarchyid, @nnew hierarchyid;
    select @nold = category_path from product_categories where category_name = @oldMgr;

    set transaction isolation level serializable;
    begin transaction;
    select @nnew = category_path from product_categories where category_name = @newMgr;

    select @nnew = @nnew.GetDescendant(max(category_path), null)
    from product_categories where category_path.GetAncestor(1) = @nnew;

    update product_categories
    set category_path = category_path.GetReparentedValue(@nold, @nnew)
    where category_path.IsDescendantOf(@nold) = 1;

    commit transaction;
end;

exec MoveNodes @oldMgr = 'Брюки', @newMgr = 'Юбка';

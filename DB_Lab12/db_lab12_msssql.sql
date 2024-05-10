use SHOP_DB;

-- 1.	Создайте таблицу Report, содержащую два столбца – id и XML-столбец в базе данных SQL Server.
create table Report (
    id int primary key,
    xmlData xml
);

-- 2.	Создайте процедуру генерации XML. XML должен включать данные из как минимум 3 соединенных таблиц, различные промежуточные итоги и штамп времени.
create procedure GenerateXML
as
begin
    declare @xmlData xml;

    set @xmlData = (
        select
            (select * from products for xml path('products'), type),
            (select * from orders for xml path('orders'), type),
            (select * from customers for xml path('customers'), type),
            getdate() as Timestamp for xml path('Data')
    );

    select @xmlData as GeneratedXML;
end;

exec GenerateXML;

-- 3.	Создайте процедуру вставки этого XML в таблицу Report.
create or alter procedure InsertXMLIntoReport
as
begin
	declare @xmlData xml;
	declare @newId int;

	if ((select count(*) from Report) > 0)
		begin
			set @newId = (select max(id) from Report) + 1;
		end
	else
		begin
			set @newId = 1;
		end

	create table #TempXML (GeneratedXML xml);

	insert into #TempXML (GeneratedXML)
    exec GenerateXML;

	set @xmlData = (select GeneratedXML from #TempXML);
	
    insert into Report (id, xmlData)
    values (@newId, @xmlData);

	drop table #TempXML;
end;

exec InsertXMLIntoReport;

select * from Report;

-- 4.	Создайте индекс над XML-столбцом в таблице Report. 
create primary xml index IX_Report_xmlData on Report(xmlData);

-- 5.	Создайте процедуру извлечения значений элементов и/или атрибутов из XML -столбца в таблице Report (параметр – значение атрибута или элемента).
create or alter procedure GetInfoColumnData
    @XPath nvarchar(max)
as
begin
    set nocount on;
    declare @SQL NVARCHAR(MAX);
    SET @SQL = '
        SELECT xmlData.query(''/Data/products/' + @XPath + ''') AS [xmlData]
        FROM Report
        FOR XML AUTO, TYPE
    ';
    EXEC sp_executesql @SQL;
END;

execute GetInfoColumnData  'product_name'


select xmlData.query('
    for $product in (/Data/products)
    return $product
') as Result
from Report
where xmlData.exist('/Data/products') = 1
select * from customers

-- 1. Создайте таблицу Report, содержащую два столбца – id и XML-столбец в базе данных Oracle.
create table report (
    id number primary key,
    xmldata xmltype
);

-- 2. Создайте процедуру генерации XML. XML должен включать данные из как минимум 3 соединенных таблиц, различные промежуточные итоги и штамп времени.
create or replace procedure generatexml
as
    xmldata xmltype;
begin
    select xmlelement("data",
    (select xmlagg(xmlelement("products", xmlforest(p.product_id as "product_id", p.product_name as "product_name"))) from products p),
    (select xmlagg(xmlelement("orders", xmlforest(o.order_id as "order_id", o.order_date as "order_date"))) from orders o),
    (select xmlagg(xmlelement("customers", xmlforest(c.customer_id as "customer_id", c.name as "name"))) from customers c),
    systimestamp)
    into xmldata
    from dual;
    insert into report (id, xmldata)
    values ((select nvl(max(id), 0) + 1 from report), xmldata);
    commit;
    dbms_output.put_line('XML generated and inserted into Report table.');
end;

exec GenerateXML;
select * from Report;

-- 4. Создайте индекс над XML-столбцом в таблице Report.
create index ix_report_xmldata on report(xmldata) indextype is xdb.xmlindex;

-- 5. Создайте процедуру извлечения значений элементов и/или атрибутов из XML-столбца в таблице Report (параметр – значение атрибута или элемента).
create or replace procedure extractxmlvalue (
  attributename in nvarchar2,
  extractedvalues out sys_refcursor
)
as
  sqlstatement nvarchar2(1000);
begin
  sqlstatement := 'SELECT x.ExtractedValue
                   FROM Report,
                     XMLTABLE(''/data/*''
                       PASSING xmlData
                       COLUMNS ExtractedValue NVARCHAR2(100) PATH ''' || attributename || ''') x';

  open extractedvalues for sqlstatement;
end;

declare
  extractedvaluescursor sys_refcursor;
  extractedvalue nvarchar2(100);
begin
  extractxmlvalue(attributename => 'product_name', extractedvalues => extractedvaluescursor);
  
  loop
    fetch extractedvaluescursor into extractedvalue;
    exit when extractedvaluescursor%notfound;
    dbms_output.put_line(extractedvalue);
  end loop;
  
  close extractedvaluescursor;
end;




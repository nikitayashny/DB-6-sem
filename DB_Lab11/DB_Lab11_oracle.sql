select * from products

alter table products 
add date_column date

update products set date_column = '02.02.2024' where product_id < 10

CREATE OR REPLACE FUNCTION getData(start_date IN DATE, end_date IN DATE)
RETURN SYS_REFCURSOR
IS
  result_cursor SYS_REFCURSOR;
BEGIN
  OPEN result_cursor FOR
    SELECT * FROM products WHERE date_column BETWEEN start_date AND end_date;
  RETURN result_cursor;
END;


SET SERVEROUTPUT ON
SET VERIFY OFF
SET PAGESIZE 0
SET LINESIZE 1000

VAR result_cursor REFCURSOR

EXEC :result_cursor := getData(TO_DATE('01.02.24', 'DD.MM.RR'), TO_DATE('01.03.24', 'DD.MM.RR'));

SPOOL output_oracle.txt

PRINT result_cursor

SPOOL OFF
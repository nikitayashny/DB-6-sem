-- 1.	Создайте отдельное табличное пространство для хранения LOB.
create tablespace lob_ts
datafile 'lob_ts.dbf'
size 100m
autoextend on;

-- 2.	Создайте отдельную папку для хранения внешних WORD (или PDF) документов. 
create directory LOBDIR as 'C:/LOBDIR'

-- 3.	Создайте пользователя lob_user с необходимыми привилегиями для вставки, обновления и удаления больших объектов.
create user lob_user identified by 1111;
grant create session to lob_user;
grant connect, resource to lob_user;
grant unlimited tablespace to lob_user;
grant create any directory to lob_user;
grant execute on utl_file to lob_user;

-- 4.	Добавьте квоту на данное табличное пространство пользователю lob_user.
alter user lob_user quota unlimited on lob_ts;

-- 5.	Добавьте в какую-либо таблицу следующие столбцы:
-- FOTO BLOB: для хранения фотографии;
-- DOC (или PDF) BFILE: для хранения внешних WORD (или PDF) документов.
create table lab10_table (
  id number primary key,
  FOTO BLOB,
  DOC BFILE
);

drop table lab10_table

-- 6.	Добавьте (INSERT) фотографии и документы в таблицу.
select * from lab10_table
delete from lab10_table

DECLARE
  src_file bfile;
  dst_file_photo blob;
  lgh_file_photo binary_integer;
  dst_file_doc bfile;
BEGIN
  src_file := bfilename('LOBDIR', 'skirtprada.jpg');
  
  insert into lab10_table values(1, EMPTY_BLOB(), null) returning FOTO into dst_file_photo;
  select FOTO into dst_file_photo from lab10_table where id = 1 for update;
  
  dbms_lob.fileopen(src_file, dbms_lob.file_readonly);
  lgh_file_photo := dbms_lob.getlength(src_file);
  dbms_lob.loadfromfile(dst_file_photo, src_file, lgh_file_photo);
  
  update lab10_table set FOTO = dst_file_photo where id = 1;
  dbms_lob.fileclose(src_file);

  dst_file_doc := bfilename('LOBDIR', 'document.doc');
  update lab10_table set DOC = dst_file_doc where id = 1;
  
  commit;
END;
/



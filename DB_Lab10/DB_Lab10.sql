-- 1.	�������� ��������� ��������� ������������ ��� �������� LOB.
create tablespace lob_ts
datafile 'lob_ts.dbf'
size 100m
autoextend on;

-- 2.	�������� ��������� ����� ��� �������� ������� WORD (��� PDF) ����������. 
create directory LOBDIR as 'C:/LOBDIR'

-- 3.	�������� ������������ lob_user � ������������ ������������ ��� �������, ���������� � �������� ������� ��������.
create user lob_user identified by 1111;
grant create session to lob_user;
grant connect, resource to lob_user;
grant unlimited tablespace to lob_user;
grant create any directory to lob_user;
grant execute on utl_file to lob_user;

-- 4.	�������� ����� �� ������ ��������� ������������ ������������ lob_user.
alter user lob_user quota unlimited on lob_ts;

-- 5.	�������� � �����-���� ������� ��������� �������:
-- FOTO BLOB: ��� �������� ����������;
-- DOC (��� PDF) BFILE: ��� �������� ������� WORD (��� PDF) ����������.
create table lab10_table (
  id number primary key,
  FOTO BLOB,
  DOC BFILE
);

drop table lab10_table

-- 6.	�������� (INSERT) ���������� � ��������� � �������.
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



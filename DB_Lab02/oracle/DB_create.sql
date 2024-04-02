alter session set container = cdb$root;

create pluggable database SHOP_PDB
   admin user SHOP_ADMIN identified by 1234 
   file_name_convert = ('C:\OracleDB\oradata\XE\pdbseed', 'C:\OracleDB\oradata\XE\shop_pdb')
   default tablespace users
   datafile 'C:\OracleDB\oradata\XE\shop_pdb\system01.dbf' SIZE 100M AUTOEXTEND ON;
   
grant all privileges to SHOP_ADMIN;
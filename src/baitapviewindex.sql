create database exercise_view;
use exercise_view;
create table producst
(
    id                 int,
    productCode        int,
    productName        varchar(255),
    productPrice       int,
    productAmount      int,
    productDescription varchar(255),
    productStatus      varchar(255)
);

create unique index prcode on producst (productCode);
create index compositIndex on producst (productName, productPrice);
explain
select productAmount
from producst
where productName = 'c'
  and productPrice = 13;

create view products as
select *
from producst;

create or replace view products as
select id, productPrice, productCode, productName, productAmount
from producst;

update exercise_view.products
set id = 10
where productCode = 4;

delimiter //
create procedure selectall()
begin
    select * from producst;
end //
delimiter ;

call selectall();

delimiter //
create procedure creatNewProduct(id int, pcode int, namep varchar(255), price int)
begin
    insert into producst(id, productCode, productName, productPrice) value (id, pcode, namep, price);
end //
delimiter ;

call creatNewProduct(7,90,'f',50000);

delimiter //
create procedure editProduct(idd int, pcode int, namep varchar(255), price int)
begin
    update producst set productCode = pcode, productName = namep, productPrice = price where id= idd;
end //
delimiter ;

call editProduct(7,15,'h',24);

delimiter //
create procedure deleteProduct(idd int)
begin
    delete from producst where id = idd;
end //
delimiter ;

call deleteProduct(10);
call deleteProduct(7);
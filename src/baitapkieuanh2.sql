create table meterial
(
    id_met   int auto_increment primary key,
    code_met varchar(3)  not null,
    name_met varchar(11) not null,
    unit     varchar(3)  not null,
    price    int         not null
);
create table inventory
(
    id_in        int auto_increment primary key,
    id_met       int,
    old_in       int,
    total_import int,
    total_export int,
    foreign key (id_met) references meterial (id_met)
);

create table products
(
    id_pro     int auto_increment primary key,
    code_pro   varchar(3),
    name_pro   varchar(11),
    adress_pro varchar(255),
    phone_pro  varchar(255)
);
create table oder
(
    id_oder   int auto_increment primary key,
    code_oder varchar(3),
    date_oder date,
    in_pro    int,
    foreign key (in_pro) references products (id_pro)
);
create table importlist
(
    id_imp   int auto_increment primary key,
    code_imp varchar(3),
    date_imp date,
    id_oder  int,
    foreign key (id_oder) references oder (id_oder)
);
create table exportlist
(
    id_exp    int auto_increment primary key,
    code_exp  varchar(3),
    date_exp  date,
    customner varchar(11)
);

create table oderDetail
(
    id_o_detail int auto_increment primary key,
    id_oder     int,
    id_met      int,
    oder_quanty int,
    foreign key (id_oder) references oder (id_oder),
    foreign key (id_met) references meterial (id_met)
);

create table importlistdetail
(
    id_i_detail   int auto_increment primary key,
    id_imp        int,
    id_met        int,
    import_quanty int,
    price_imp     int,
    note          varchar(255),
    foreign key (id_met) references meterial (id_met),
    foreign key (id_imp) references importlist (id_imp)
);

create table exportlistdetail
(
    id_e_detail   int auto_increment primary key,
    id_exp        int,
    id_met        int,
    export_quanty int,
    price_exp     int,
    note          varchar(255),
    foreign key (id_met) references meterial (id_met),
    foreign key (id_exp) references exportlist (id_exp)

);
use kieuanh2;

create view CTPNHAP as
select count(id_met),
       id_met,
       sum(import_quanty),
       price_imp,
       sum(price_imp * import_quanty) 'total'
from importlistdetail
group by id_met;

# create view CTPNHAP_VT as
# select count(importlistdetail.id_met),
#        name_met,
#        code_met,
#        sum(import_quanty),
#        price_imp,
#        sum(price_imp * import_quanty) 'total'
# from importlistdetail.price_imp
#          join meterial on importlistdetail.id_met = meterial.id_met
# group by importlistdetail.id_met;

create view CTPNHAP_VT_PN as
select code_imp,
       date_imp,
       code_oder,
       code_met,
       name_met,
       import_quanty,
       price_imp,
       import_quanty * price_imp 'total'
from importlistdetail
         join importlist on importlistdetail.id_imp = importlist.id_imp
         join oder on importlist.id_oder = oder.id_oder
         join meterial on importlistdetail.id_met = meterial.id_met;

create view CTPNHAP_VT_PN_DH as
select code_imp,
       date_imp,
       code_oder,
       code_pro,
       code_met,
       name_met,
       import_quanty,
       price_imp,
       import_quanty * price_imp 'total'
from importlistdetail
         join importlist on importlistdetail.id_imp = importlist.id_imp
         join oder on importlist.id_oder = oder.id_oder
         join meterial on importlistdetail.id_met = meterial.id_met
         join products on oder.in_pro = products.id_pro;

create view CTPNHAP_LOC as
select code_imp,
       code_met,
       import_quanty,
       price_imp,
       import_quanty * price_imp 'total'
from importlistdetail
         join importlist on importlistdetail.id_imp = importlist.id_imp
         join oder on importlist.id_oder = oder.id_oder
         join meterial on importlistdetail.id_met = meterial.id_met
         join products on oder.in_pro = products.id_pro
where import_quanty > 5;

create view CTPNHAP_VT_LOC as
select code_imp,
       code_met,
       import_quanty,
       price_imp,
       import_quanty * price_imp 'total'
from importlistdetail
         join importlist on importlistdetail.id_imp = importlist.id_imp
         join oder on importlist.id_oder = oder.id_oder
         join meterial on importlistdetail.id_met = meterial.id_met
         join products on oder.in_pro = products.id_pro
where unit = 'kg';

delimiter //
create procedure totalInvertory(in code_metin varchar(3))
begin
    select meterial.code_met, old_in + total_import - total_export as quantityInventory
    from inventory
             join meterial on inventory.id_met = meterial.id_met
    where meterial.code_met = code_metin;
end//
delimiter ;

call totalInvertory('m01');

delimiter //
create procedure totalPriceExp(in code_metin varchar(3))
begin
    select meterial.code_met, export_quanty * price_exp, date_exp
    from exportlistdetail
             join meterial on exportlistdetail.id_met = meterial.id_met
             join exportlist on exportlistdetail.id_exp = exportlist.id_exp
    where code_met = code_metin;
end //

call totalPriceExp('m05');

delimiter //
create procedure totalOder(in oder_code varchar(3))
begin
    select code_oder, sum(oder_quanty)
    from oderdetail
             join oder on oderDetail.id_oder = oder.id_oder
    where code_oder = oder_code;
end //
delimiter ;

call totalOder('o03');

delimiter //
create procedure insertOder(in odercode varchar(3), in dateoder date, in idpro int)
begin
    insert into oder(code_oder, date_oder, in_pro) VALUE (odercode, dateoder, idpro);
end //
delimiter ;

call insertOder('o04', now(),1);

call insertOder('o05', 19/08/2021,2);
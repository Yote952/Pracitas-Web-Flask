drop database if exists pythondb;
create database pythondb;
use pythondb;

drop table if exists Users;
create table Users(
	username varchar(64) primary key not null,
	password varchar(64) not null,
    email varchar(256) not null,
    privilegios char not null default('C'),
	created_at timestamp,
    updated_at timestamp,
    active boolean default(1),
    check(privilegios='C'| privilegios='E' | privilegios= 'A')
);

drop table if exists Direccion;
create table Direccion(
	id bigint auto_increment primary key,
    calle varchar(256),
    active boolean,
    colonia varchar(256),
    pais varchar(256),
    estado varchar(256),
    ciudad varchar(256),
    codigo_postal varchar(5)
);

drop table if exists Empleados;
create table Empleados(
	id bigint auto_increment primary key not null,
	name varchar(128) not null,
    lastname varchar(64),
    middlename varchar(64),
    RFC varchar(30) unique,
    idDireccion bigint not null,
    created_at timestamp,
    updated_at timestamp,
    constraint fk_EmpleadoTieneDirrecion 
    foreign key(idDireccion) references Direccion(id),
    fk_username varchar(64),
    constraint fk_EmpleadoTieneUsuario foreign key(fk_username) references Users(username)
);

create view EmpleadosC as
	select * from Users as U 
	join (select E.name, E.lastname, E.middlename, E.RFC, E.idDireccion, E.fk_username, D.id, D.calle, D.colonia, D.pais, D.estado, D.ciudad, D.codigo_postal
    from Empleados as E
		left join Direccion as D
		on E.idDireccion = D.id) as E
    on E.fk_username = U.username;
drop table if exists Clientes;
create table Clientes(
	id bigint auto_increment primary key not null,
    name varchar(128),
    lastname varchar(64),
    middlename varchar(64),
    idDireccion bigint,
	constraint fk_ClienteTieneDireccion 
    foreign key(idDireccion) references Direccion(id),
    username varchar(64),
    constraint fk_ClienteTieneUsuario
    foreign key (username) references Users(username)
);

drop table if exists Productos;
create table Productos(
	id bigint auto_increment primary key,
    name varchar(256) not null,
    gender char not null,
    check(gender = 'M'| gender = 'F'|gender='S'),
    price decimal default(0),
    description varchar(1024)
    );

ALTER TABLE R_CategoriaProducto
DROP FOREIGN KEY fk_ProductoTieneCategoria;
ALTER TABLE R_CategoriaProducto
DROP FOREIGN KEY fk_CategoriaPertenceProducto;
drop table if exists Categorias;
create table Categorias(
	id bigint not null primary key auto_increment,
    name varchar(64)
);
drop table if exists R_CategoriaProducto;
create table R_CategoriaProducto(
	id bigint primary key not null auto_increment,
    idProducto bigint not null,
    idCategoria bigint not null,
    constraint fk_ProductoTieneCategoria foreign key(idProducto) references Productos(id),
    constraint fk_CategoriaPertenceProducto foreign key(idCategoria) references Categorias(id)
);

drop procedure if exists gestion_usuario;
delimiter //
create procedure gestion_usuario(in 
	i_username varchar(128), 
	i_password varchar(64),
    i_email varchar(64),
    i_privilegios char,
    i_opcion char,
    pagina int)
begin
	case i_opcion
		when 'i' then 
			insert into users(username,password,email,privilegios,created_at,updated_at)
			values (i_username,i_password,i_email,i_privilegios,now(),now());
         when 't' then 
			select username, email, privilegios, active from users where ROWNUM >= pagina*10 limit 10;
		when 's' then 
			select username, email, privilegios 
            where active=1 and username = i_username and password = i_password;
		when 'u' then
			update users
            set password = i_password, updated_at = now()
            where username = i_username;
		when 'b' then 
			update users
            set active =0
            where active=1 and username = i_username and password = i_password;
		when 'd' then
			delete from users where username = i_username;
    end case;
end //
delimiter ;
drop procedure if exists gestion_Empleados;
delimiter //
create procedure gestion_Empleados(in
	in_name varchar(128),
	in_lastname varchar(64), 
	in_middlenama varchar(64),
	in_RFC varchar(30),
    in_idDireccion bigint,
    in_username varchar(64),
    opcion char,
    pagina int
) begin
	case opcion
		when 'i' then
			insert into Empleados(name,lastname, middlename, RFC, idDirrecion,created_at,updated_at,username)
            values(in_name,in_lastname,in_middlename,in_RFC,in_idDireccion,	now(),now(),in_username);
		when 'u' then
			update Empleados
			set name = in_name, lastname = in_lastname,
            middlename = in_middlename, RFC = in_RFC, Direccion = in_Direccion,
            updated_at = now()
            where username = in_username
		when 's' then
    end case;
end //
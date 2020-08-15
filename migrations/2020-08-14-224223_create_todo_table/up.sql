-- Your SQL goes here
--CREATE TABLE posts (
--  id SERIAL PRIMARY KEY,
--  title VARCHAR NOT NULL,
--  body TEXT NOT NULL,
--  published BOOLEAN NOT NULL DEFAULT FALSE
--)
create table giftcards (
    id serial primary key,
    gift_company varchar(50) not null,
    gift_id varchar(255) not null,
    gift_value integer not null,
    gift_code varchar(50) not null,
    active boolean not null default true
);
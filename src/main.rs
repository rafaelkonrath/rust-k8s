#![feature(decl_macro)]

#[macro_use]
extern crate diesel;

mod schema;

use crate::schema::giftcards;
use diesel::prelude::*;
use diesel::{Insertable, Queryable};
use rocket::{self, get, post, put, routes};
use rocket_contrib::databases::{database, diesel::PgConnection};
use rocket_contrib::json::Json;
use serde::{Deserialize, Serialize};

#[database("postgres")]
struct DbConn(PgConnection);

#[derive(Queryable, Serialize)]
struct GiftCard {
    id: i32,
    gift_company: String,
    gift_id: String,
    gift_value: i32,
    gift_code: String,
    active: bool,
}

#[derive(Insertable, Deserialize)]
#[table_name = "giftcards"]
struct NewGiftCard {
    gift_company: String,
    gift_id: String,
    gift_value: i32,
    gift_code: String,
}

#[get("/")]
fn get_todos(conn: DbConn) -> Json<Vec<GiftCard>> {
    let todos = giftcards::table
        .order(giftcards::columns::id.desc())
        .load::<GiftCard>(&*conn)
        .unwrap();
    Json(todos)
}

#[post("/", data = "<gift_card>")]
fn create_todo(conn: DbConn, gift_card: Json<NewGiftCard>) -> Json<GiftCard> {
    let result = diesel::insert_into(giftcards::table)
        .values(&*gift_card)
        .get_result(&*conn)
        .unwrap();
    Json(result)
}

#[put("/<id>")]
fn check_todo(conn: DbConn, id: i32) -> Json<GiftCard> {
    let target = giftcards::table.filter(giftcards::columns::id.eq(id));
    let result = diesel::update(target)
        .set(giftcards::columns::active.eq(false))
        .get_result(&*conn)
        .unwrap();

    Json(result)
}

#[get("/")]
fn hello() -> &'static str {
    "Hello, World!"
}

#[get("/<name>")]
fn hello_name(name: String) -> String {
    format!("Hello, {}!", name)
}

fn main() {
    rocket::ignite()
        .attach(DbConn::fairing())
        .mount("/", routes![hello, hello_name])
        .mount("/todos", routes![get_todos, create_todo, check_todo])
        .launch();
}

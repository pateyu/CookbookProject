CREATE DATABASE recipeLibrary

CREATE TABLE account (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL
)

CREATE TABLE admin (
    
)

CREATE TABLE user (

)

CREATE TABLE cuisine (

)

CREATE TABLE regional_cuisine (

)

CREATE TABLE religious_cuisine (

)

CREATE TABLE recipe (

)

CREATE TABLE recipe_restrictions (

)

CREATE TABLE ingredients (

)

CREATE TABLE religious_restrictions (

)

CREATE TABLE user_restrictions (

)

CREATE TABLE cookbook (

)

CREATE TABLE favorite_recipes (

)

CREATE TABLE prefers (

)

CREATE TABLE contains (
    CookBook_ID INT FOREIGN KEY
)

CREATE TABLE deletes (
    Admin_id INT FOREGIN KEY
    recipe_name VARCHAR(80) FOREIGN KEY

)

CREATE TABLE creates (
    User_ID INT FOREIGN KEY 
    recipe_name VARCHAR(80) FOREIGN KEY
);

CREATE TABLE rates (
    User_ID INTEGER FOREIGN KEY NOT NULL
    recipe_name VARCHAR(80) FOREIGN KEY NOT NULL
    user_rating INTEGER CHECK (BETWEEN 0 AND 5)
);
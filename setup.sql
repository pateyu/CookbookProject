--CREATE DATABASE recipeLibrary;

CREATE TABLE IF NOT EXISTS account (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS admin (
    Account_ID INT PRIMARY KEY,
    FOREIGN KEY(Account_ID) REFERENCES account(id)
);

CREATE TABLE IF NOT EXISTS user (    
    Account_ID INT PRIMARY KEY,
    FOREIGN KEY(Account_ID) REFERENCES account(id)
);

CREATE TABLE IF NOT EXISTS cuisine (
    Cuisine_ID INT PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS regional_cuisine (
    religion_name VARCHAR
);

CREATE TABLE IF NOT EXISTS religious_cuisine (

);

CREATE TABLE IF NOT EXISTS recipe (

);

CREATE TABLE IF NOT EXISTS recipe_restrictions (

);

CREATE TABLE IF NOT EXISTS ingredients (

);

CREATE TABLE IF NOT EXISTS religious_restrictions (
    religion_name VARCHAR(20) FOREIGN KEY
    RelRestriction VARCHAR(80) PRIMARY KEY
);


CREATE TABLE IF NOT EXISTS user_restrictions (
    User_ID INTEGER FOREIGN KEY
    UserRestriction VARCHAR(30) PRIMARY KEY
);


CREATE TABLE IF NOT EXISTS cookbook (
    CookBook_ID INT PRIMARY KEY,
    FOREIGN KEY(CookBook_ID) REFERENCES user(Account_ID)
);


CREATE TABLE IF NOT EXISTS favorite_recipes (
    CookBook_ID INT FOREIGN KEY
    Crecipe_name VARCHAR(80) PRIMARY KEY
);


CREATE TABLE IF NOT EXISTS prefers (
    User_ID INTEGER FOREIGN KEY NOT NULL
    ingredient_name VARCHAR(80) FOREIGN KEY
);


CREATE TABLE IF NOT EXISTS contains (
    CookBook_ID INT FOREIGN KEY
    recipe_name VARCHAR(80) FOREIGN KEY
);


CREATE TABLE IF NOT EXISTS deletes (
    Admin_id INT FOREIGN KEY
    recipe_name VARCHAR(80) FOREIGN KEY


);


CREATE TABLE IF NOT EXISTS creates (
    User_ID INT FOREIGN KEY
    recipe_name VARCHAR(80) FOREIGN KEY
);


CREATE TABLE IF NOT EXISTS rates (
    User_ID INTEGER FOREIGN KEY NOT NULL
    recipe_name VARCHAR(80) FOREIGN KEY NOT NULL
    user_rating INTEGER CHECK (BETWEEN 0 AND 5)
)

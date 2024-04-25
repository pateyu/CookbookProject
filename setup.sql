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

);

CREATE TABLE IF NOT EXISTS user_restrictions (
    User_ID INT PRIMARY KEY,
    UserRestriction VARCHAR(30),
    FOREIGN KEY(User_ID) REFERENCES account(id)
);

CREATE TABLE IF NOT EXISTS cookbook (

);

CREATE TABLE IF NOT EXISTS favorite_recipes (

);

CREATE TABLE IF NOT EXISTS prefers (

);

CREATE TABLE IF NOT EXISTS contains (

);

CREATE TABLE IF NOT EXISTS deletes (
 
);

CREATE TABLE IF NOT EXISTS creates (

);

CREATE TABLE IF NOT EXISTS rates (

);

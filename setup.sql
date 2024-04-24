CREATE DATABASE recipeLibrary

CREATE TABLE account (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL
);

CREATE TABLE admin (
    Account_ID INT PRIMARY KEY,
    FOREIGN KEY(Account_ID) REFERENCES account(id)
);

CREATE TABLE user (    
    Account_ID INT PRIMARY KEY,
    FOREIGN KEY(Account_ID) REFERENCES account(id)
);

CREATE TABLE cuisine (

);

CREATE TABLE regional_cuisine (

);

CREATE TABLE religious_cuisine (

);

CREATE TABLE recipe (

);

CREATE TABLE recipe_restrictions (

);

CREATE TABLE ingredients (

);

CREATE TABLE religious_restrictions (

);

CREATE TABLE user_restrictions (
    User_ID INT PRIMARY KEY,
    UserRestriction VARCHAR(30) PRIMARY KEY,
    FOREIGN KEY(User_ID) REFERENCES account(id)
);

CREATE TABLE cookbook (

);

CREATE TABLE favorite_recipes (

);

CREATE TABLE prefers (

);

CREATE TABLE contains (

);

CREATE TABLE deletes (
 
);

CREATE TABLE creates (

);

CREATE TABLE rates (

);
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

)

CREATE TABLE deletes (

)

CREATE TABLE creates (

)

CREATE TABLE rates (

)
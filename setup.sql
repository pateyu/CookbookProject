--CREATE DATABASE recipeLibrary;

CREATE TABLE IF NOT EXISTS account (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS admin (
    Account_ID INT PRIMARY KEY,
    admin_name TEXT UNIQUE NOT NULL,
    FOREIGN KEY(Account_ID) REFERENCES account(id),
    FOREIGN KEY(admin_name) REFERENCES account(username)
);

CREATE TABLE IF NOT EXISTS users (    
    Account_ID INT PRIMARY KEY,
    FOREIGN KEY(Account_ID) REFERENCES account(id)
);

CREATE TABLE IF NOT EXISTS cuisine (
    Cuisine_ID INT PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS regional_cuisine (
    region_name VARCHAR(20) PRIMARY KEY,
    Cuisine_ID INT,
    FOREIGN KEY(Cuisine_ID) REFERENCES cuisine(Cuisine_ID)
);

CREATE TABLE IF NOT EXISTS religious_cuisine (
    religion_name VARCHAR(80) PRIMARY KEY,
    Cuisine_ID INT,
    FOREIGN KEY(Cuisine_ID) REFERENCES cuisine(Cuisine_ID)
);

CREATE TABLE IF NOT EXISTS recipe (
    recipe_name VARCHAR(80) PRIMARY KEY
    Cuisine_ID INT,
    UserID INT,
    prep_time TIME,
    cook_time TIME,
    recipe image BLOB,
    instructions TEXT,
    FOREIGN KEY(Cuisine_ID) REFERENCES cuisine(Cuisine_ID),
    FOREIGN KEY(UserID) REFERENCES users(Account_ID)
);

CREATE TABLE IF NOT EXISTS recipe_restrictions (
    recipe_name VARCHAR(80),
    RecRestriction VARCHAR(30),
    FOREIGN KEY(recipe_name) REFERENCES recipe(recipe_name),
    PRIMARY KEY (recipe_name, RecRestriction)
);

CREATE TABLE IF NOT EXISTS ingredients (
    recipe_name VARCHAR(80),
    ingredient_name VARCHAR(80),
    ingredient_type VARCHAR(30),
    FOREIGN KEY(recipe_name) REFERENCES recipe(recipe_name),
    PRIMARY KEY (recipe_name, ingredient_name)
);

CREATE TABLE IF NOT EXISTS religious_restrictions (
    religion_name VARCHAR(20),
    RelRestriction VARCHAR(80),
    FOREIGN KEY(religion_name) REFERENCES religious_cuisine(religion_name),
    PRIMARY KEY (religion_name, RelRestriction)
);


CREATE TABLE IF NOT EXISTS user_restrictions (
    User_ID INTEGER,
    UserRestriction VARCHAR(30),
    FOREIGN KEY(User_ID) REFERENCES users(User_ID),
    PRIMARY KEY (User_ID, UserRestriction)
);


CREATE TABLE IF NOT EXISTS cookbook (
    CookBook_ID INT PRIMARY KEY,
    FOREIGN KEY(CookBook_ID) REFERENCES users(Account_ID)
);


CREATE TABLE IF NOT EXISTS favorite_recipes (
    CookBook_ID INT 
    Crecipe_name VARCHAR(80)
    FOREIGN KEY(CookBook_ID) REFERENCES cookbook(CookBook_ID),
    PRIMARY KEY (CookBook_ID, Crecipe_name)    
);


CREATE TABLE IF NOT EXISTS prefers (
    User_ID INTEGER NOT NULL,
    ingredient_name VARCHAR(80),
    FOREIGN KEY(User_ID) REFERENCES users(User_ID),
    FOREIGN KEY(ingredient_name) REFERENCES ingredients(ingredient_name),
    PRIMARY KEY (User_ID, ingredient_name)  
);


CREATE TABLE IF NOT EXISTS contains (
    CookBook_ID INT,
    recipe_name VARCHAR(80),
    FOREIGN KEY(CookBook_ID) REFERENCES cookbook(CookBook_ID),
    FOREIGN KEY(recipe_name) REFERENCES recipe(recipe_name),
    PRIMARY KEY (CookBook_ID, recipe_name)  
);


CREATE TABLE IF NOT EXISTS deletes (
    Admin_ID INT
    recipe_name VARCHAR(80)
    FOREIGN KEY(Admin_ID) REFERENCES admin(Account_ID),
    FOREIGN KEY(recipe_name) REFERENCES recipe(recipe_name),
    PRIMARY KEY (Admin_ID, recipe_name)  
);


CREATE TABLE IF NOT EXISTS creates (
    User_ID INT 
    recipe_name VARCHAR(80)
    FOREIGN KEY(User_ID) REFERENCES users(Account_ID),
    FOREIGN KEY(recipe_name) REFERENCES recipe(recipe_name),
    PRIMARY KEY (User_ID, recipe_name)  
);


CREATE TABLE IF NOT EXISTS rates (
    User_ID INTEGER NOT NULL,
    recipe_name VARCHAR(80) NOT NULL,
    user_rating INTEGER CHECK (BETWEEN 0 AND 5),
    FOREIGN KEY(User_ID) REFERENCES users(Account_ID),
    FOREIGN KEY(recipe_name) REFERENCES recipe(recipe_name),
    PRIMARY KEY (User_ID, recipe_name)  
)

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS account (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS admin (
    Account_ID INTEGER PRIMARY KEY,
    admin_name TEXT UNIQUE NOT NULL,
    FOREIGN KEY(Account_ID) REFERENCES account(id) ON DELETE CASCADE,
    FOREIGN KEY(admin_name) REFERENCES account(username) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS users (
    Account_ID INTEGER PRIMARY KEY,
    FOREIGN KEY(Account_ID) REFERENCES account(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS cuisine (
    Cuisine_ID TEXT PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS regional_cuisine (
    region_desc TEXT,
    Cuisine_ID TEXT PRIMARY KEY,
    FOREIGN KEY(Cuisine_ID) REFERENCES cuisine(Cuisine_ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS cuisine_type (
    type_description TEXT,
    Cuisine_ID TEXT PRIMARY KEY,
    FOREIGN KEY(Cuisine_ID) REFERENCES cuisine(Cuisine_ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS recipe (
    recipe_id INTEGER PRIMARY KEY AUTOINCREMENT,
    recipe_name TEXT UNIQUE,
    Cuisine_ID TEXT,
    UserID INTEGER,
    recipe_description TEXT,
    prep_time INTEGER,  
    cook_time INTEGER,  
    recipe_image TEXT,  
    instructions TEXT,
    FOREIGN KEY(Cuisine_ID) REFERENCES cuisine(Cuisine_ID) ON DELETE SET NULL,
    FOREIGN KEY(UserID) REFERENCES users(Account_ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS recipe_restrictions (
    recipe_name VARCHAR(80),
    RecRestriction VARCHAR(30),
    FOREIGN KEY(recipe_name) REFERENCES recipe(recipe_name) ON DELETE CASCADE,
    PRIMARY KEY (recipe_name, RecRestriction)
);

CREATE TABLE IF NOT EXISTS ingredients (
    recipe_name VARCHAR(80),
    ingredient_name VARCHAR(80),
    ingredient_type VARCHAR(30),
    FOREIGN KEY(recipe_name) REFERENCES recipe(recipe_name) ON DELETE CASCADE,
    PRIMARY KEY (recipe_name, ingredient_name)
);

CREATE TABLE IF NOT EXISTS user_restrictions (
    User_ID INTEGER,
    UserRestriction VARCHAR(30),
    FOREIGN KEY(User_ID) REFERENCES users(Account_ID) ON DELETE CASCADE,
    PRIMARY KEY (User_ID, UserRestriction)
);

CREATE TABLE IF NOT EXISTS cookbook (
    CookBook_ID INTEGER PRIMARY KEY,
    FOREIGN KEY(CookBook_ID) REFERENCES users(Account_ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS favorite_recipes (
    CookBook_ID INTEGER,
    Crecipe_name VARCHAR(80),
    FOREIGN KEY(CookBook_ID) REFERENCES cookbook(CookBook_ID) ON DELETE CASCADE,
    FOREIGN KEY(Crecipe_name) REFERENCES recipe(recipe_name) ON DELETE CASCADE,
    PRIMARY KEY (CookBook_ID, Crecipe_name)
);

CREATE TABLE IF NOT EXISTS prefers (
    User_ID INTEGER NOT NULL,
    ingredient_name VARCHAR(80),
    FOREIGN KEY(User_ID) REFERENCES users(Account_ID) ON DELETE CASCADE,
    FOREIGN KEY(ingredient_name) REFERENCES ingredients(ingredient_name) ON DELETE CASCADE,
    PRIMARY KEY (User_ID, ingredient_name)
);

CREATE TABLE IF NOT EXISTS contains (
    CookBook_ID INTEGER,
    recipe_name VARCHAR(80),
    FOREIGN KEY(CookBook_ID) REFERENCES cookbook(CookBook_ID) ON DELETE CASCADE,
    FOREIGN KEY(recipe_name) REFERENCES recipe(recipe_name) ON DELETE CASCADE,
    PRIMARY KEY (CookBook_ID, recipe_name)
);

CREATE TABLE IF NOT EXISTS deletes (
    Admin_ID INTEGER,
    recipe_name VARCHAR(80),
    FOREIGN KEY(Admin_ID) REFERENCES admin(Account_ID) ON DELETE CASCADE,
    FOREIGN KEY(recipe_name) REFERENCES recipe(recipe_name) ON DELETE CASCADE,
    PRIMARY KEY (Admin_ID, recipe_name)
);

CREATE TABLE IF NOT EXISTS creates (
    User_ID INTEGER, 
    recipe_name VARCHAR(80),
    FOREIGN KEY(User_ID) REFERENCES users(Account_ID) ON DELETE CASCADE,
    FOREIGN KEY(recipe_name) REFERENCES recipe(recipe_name) ON DELETE CASCADE,
    PRIMARY KEY (User_ID, recipe_name)
);

CREATE TABLE IF NOT EXISTS rates (
    User_ID INTEGER NOT NULL,
    recipe_name VARCHAR(80) NOT NULL,
    user_rating INTEGER CHECK (user_rating BETWEEN 0 AND 5),
    FOREIGN KEY(User_ID) REFERENCES users(Account_ID) ON DELETE CASCADE,
    FOREIGN KEY(recipe_name) REFERENCES recipe(recipe_name) ON DELETE CASCADE,
    PRIMARY KEY (User_ID, recipe_name)
);

-- Insert into 'cuisine' only if the cuisine does not already exist
INSERT OR IGNORE INTO cuisine (Cuisine_ID) VALUES
('American'),
('Mexican'),
('Indian'),
('Breakfast'),
('Lunch'),
('Dinner'),
('Dessert');

-- Insert into 'regional_cuisine' only if the cuisine does not already exist
INSERT OR IGNORE INTO regional_cuisine (region_desc, Cuisine_ID) VALUES
('North American cuisine includes foods like burgers and barbecue', 'American'),
('Mexican cuisine features staples like tacos and enchiladas', 'Mexican'),
('Indian cuisine is characterized by its use of various spices and herbs', 'Indian');

-- Insert into 'cuisine_type' only if the cuisine does not already exist
INSERT OR IGNORE INTO cuisine_type (type_description, Cuisine_ID) VALUES
('Foods eaten first thing in the morning', 'Breakfast'),
('Good midday meals', 'Lunch'),
('Dinners eaten in the evening', 'Dinner'),
('Sweet treats.', 'Dessert');

CREATE TABLE IF NOT EXISTS account (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS admin (
    Account_ID INTEGER PRIMARY KEY,
    FOREIGN KEY(Account_ID) REFERENCES account(id)
);

CREATE TABLE IF NOT EXISTS user (    
    Account_ID INTEGER PRIMARY KEY,
    FOREIGN KEY(Account_ID) REFERENCES account(id)
);

CREATE TABLE IF NOT EXISTS user_restrictions (
    User_ID INTEGER,
    UserRestriction VARCHAR(30),
    PRIMARY KEY(User_ID, UserRestriction),
    FOREIGN KEY(User_ID) REFERENCES account(id)
);

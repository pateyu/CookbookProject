from flask import Flask, render_template, request, jsonify
import sqlite3

app = Flask(__name__)
DATABASE = 'database.db'

def get_db_connection():
    conn = sqlite3.connect(DATABASE)
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    with app.app_context():
        db = get_db_connection()
        db.execute('''
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT UNIQUE NOT NULL,
                email TEXT UNIQUE NOT NULL,
                password TEXT NOT NULL
            ) 
        ''')
        db.commit()
        db.close()

@app.route('/')
def index():
    return render_template('login.html')

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        data = request.get_json()
        username = data['username']
        password = data['password']
        email = data['email']
        conn = get_db_connection()
        try:
            conn.execute('INSERT INTO users (username, email, password) VALUES (?, ?, ?)',
                         (username, email, password))
            conn.commit()
        except sqlite3.IntegrityError:
            return jsonify({'success': False, 'message': 'Username or email already exists'}), 409
        finally:
            conn.close()
        return jsonify({'success': True, 'message': 'User created successfully'})
    return render_template('signup.html')

from flask import Flask, render_template, request, jsonify, redirect, url_for

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    if data is None:
        return 'Content-Type not set to application/json', 415
    
    username = data['username']
    password = data['password']
    conn = get_db_connection()
    user = conn.execute('SELECT * FROM users WHERE username = ? AND password = ?', (username, password)).fetchone()
    conn.close()
    
    if user:
        return jsonify({'logged_in': True, 'redirect': url_for('settings')})
    else:
        return jsonify({'logged_in': False}), 401

if __name__ == '__main__':
    init_db()
    app.run(debug=True)

@app.route('/settings')
def settings():
    return render_template('settings.html')

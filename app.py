from flask import Flask, render_template, request, jsonify, redirect, url_for
import sqlite3

app = Flask(__name__)
DATABASE = 'database.db'  # Your SQLite database file

def get_db_connection():
    """Establishes a connection to the SQLite database."""
    conn = sqlite3.connect(DATABASE)
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    """Initializes the database by running the SQL script."""
    with app.app_context():
        db = get_db_connection()
        with open('setup.sql', 'r') as f:
            db.cursor().executescript(f.read())
        db.commit()
        db.close()

@app.route('/')
def index():
    """Render the main login page."""
    return render_template('login.html')

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    """Handles user signup requests."""
    if request.method == 'POST':
        data = request.get_json()
        username = data['username']
        password = data['password']  # Consider hashing this password with bcrypt or similar
        email = data['email']
        conn = get_db_connection()
        try:
            conn.execute('INSERT INTO account (username, email, password) VALUES (?, ?, ?)',
                         (username, email, password))
            conn.commit()
        except sqlite3.IntegrityError:
            return jsonify({'success': False, 'message': 'Username or email already exists'}), 409
        finally:
            conn.close()
        return jsonify({'success': True, 'message': 'User created successfully'})
    return render_template('signup.html')

@app.route('/login', methods=['POST'])
def login():
    """Handles user login requests."""
    data = request.get_json()
    if data and 'username' in data and 'password' in data:
        username = data['username']
        conn = get_db_connection()
        user = conn.execute('SELECT * FROM account WHERE username = ? AND password = ?', (username, data['password'])).fetchone()
        conn.close()
        if user:
            return redirect(url_for('settings'))
        else:
            return jsonify({'message': 'Login failed'}), 401
    else:
        return jsonify({'message': 'Bad request, username or password missing'}), 400

@app.route('/settings')
def settings():
    """Render the settings page."""
    return render_template('settings.html')

if __name__ == '__main__':
    init_db()  # Initialize the database tables from setup.sql on start
    app.run(debug=True)

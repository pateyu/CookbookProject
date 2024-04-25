from flask import Flask, render_template, request, jsonify, redirect, url_for, session
import sqlite3
import os

app = Flask(__name__)
app.secret_key = os.urandom(24)  # Generates a random key for the session

DATABASE = 'database.db'

def get_db_connection():
    conn = sqlite3.connect(DATABASE)
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    with app.app_context():
        db = get_db_connection()
        with open('setup.sql', 'r') as f:
            db.cursor().executescript(f.read())
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
            conn.execute('INSERT INTO account (username, email, password) VALUES (?, ?, ?)', (username, email, password))
            conn.commit()
        except sqlite3.IntegrityError:
            return jsonify({'success': False, 'message': 'Username or email already exists'}), 409
        finally:
            conn.close()
        return jsonify({'success': True, 'message': 'User created successfully'})
    return render_template('signup.html')

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()  # Use get_json() to parse incoming JSON data
    username = data['username']
    password = data['password']
    conn = get_db_connection()
    user = conn.execute('SELECT * FROM account WHERE username = ? AND password = ?', (username, password)).fetchone()
    conn.close()
    if user:
        session['user_id'] = user['id']
        return jsonify({'message': 'Login successful', 'redirect': url_for('settings')}), 200
    else:
        return jsonify({'message': 'Login failed'}), 401

@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('index'))

@app.route('/settings')
def settings():
    return render_template('settings.html')

@app.route('/change_username', methods=['POST'])
def change_username():
    username = request.form['username']
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'message': 'User not logged in'}), 403
    conn = get_db_connection()
    try:
        conn.execute('UPDATE account SET username = ? WHERE id = ?', (username, user_id))
        conn.commit()
        response = {'message': 'Username successfully updated'}
        status_code = 200
    except Exception as e:
        conn.rollback()
        response = {'message': 'Failed to update username', 'error': str(e)}
        status_code = 500
    finally:
        conn.close()
    return jsonify(response), status_code


@app.route('/change_password', methods=['POST'])
def change_password():
    current_password = request.form['current_password']
    new_password = request.form['new_password']
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'message': 'User not logged in'}), 403

    conn = get_db_connection()
    try:
        user = conn.execute('SELECT * FROM account WHERE id = ? AND password = ?', (user_id, current_password)).fetchone()
        if user:
            conn.execute('UPDATE account SET password = ? WHERE id = ?', (new_password, user_id))
            conn.commit()
            response = {'message': 'Password successfully updated'}
            status_code = 200
        else:
            response = {'message': 'Current password is incorrect'}
            status_code = 401
    except Exception as e:
        conn.rollback()
        response = {'message': 'Failed to update password', 'error': str(e)}
        status_code = 500
    finally:
        conn.close()

    return jsonify(response), status_code
@app.route('/change_email', methods=['POST'])
def change_email():
    email = request.form['email']
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'message': 'User not logged in'}), 403

    conn = get_db_connection()
    try:
        conn.execute('UPDATE account SET email = ? WHERE id = ?', (email, user_id))
        conn.commit()
        response = {'message': 'Email successfully updated'}
        status_code = 200
    except Exception as e:
        conn.rollback()
        response = {'message': 'Failed to update email', 'error': str(e)}
        status_code = 500
    finally:
        conn.close()

    return jsonify(response), status_code


if __name__ == '__main__':
    init_db()  # Initialize the database tables from setup.sql on start
    app.run(debug=True)

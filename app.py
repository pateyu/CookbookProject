from flask import Flask, render_template, request, jsonify, redirect, url_for, session
import sqlite3
import os
import urllib.parse
from werkzeug.utils import secure_filename

app = Flask(__name__)
app.secret_key = os.urandom(24)  
app.config['UPLOAD_FOLDER'] = r'C:\Users\Yug\OneDrive\Pictures\Screenshots'
DATABASE = 'database.db'


def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in {'png', 'jpg', 'jpeg', 'gif'}


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

            # Get the account ID of the newly created account
            account_id = conn.execute('SELECT id FROM account WHERE username = ?', (username,)).fetchone()[0]

            # Insert the account ID into the users table
            conn.execute('INSERT INTO users (Account_ID) VALUES (?)', (account_id,))
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


@app.route('/dashboard')
def dashboard():
    if 'user_id' not in session:
        return redirect(url_for('index'))
    return render_template('dashboard.html')


@app.route('/settings')
def settings():
    if 'user_id' not in session:
        return redirect(url_for('index'))
    return render_template('settings.html')


@app.route('/change_username', methods=['POST'])
def change_username():
    new_username = request.form['username']
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'message': 'User not logged in'}), 403
    
    conn = get_db_connection()
    try:
        # Update account table
        conn.execute('UPDATE account SET username = ? WHERE id = ?', (new_username, user_id))
        conn.commit()
        
        # Check if the user is an admin and update the admin table
        if conn.execute('SELECT Account_ID FROM admin WHERE Account_ID = ?', (user_id,)).fetchone():
            conn.execute('UPDATE admin SET admin_name = ? WHERE Account_ID = ?', (new_username, user_id))
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

@app.route('/update_security_key', methods=['POST'])
def update_security_key():
    security_key = request.form['security_key']
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'message': 'User not logged in'}), 403

    if security_key == 'admin':
        conn = get_db_connection()
        try:
            # First check if the user is already an admin
            admin_check = conn.execute('SELECT Account_ID FROM admin WHERE Account_ID = ?', (user_id,)).fetchone()
            if not admin_check:
                # Fetch username from the account table
                user_info = conn.execute('SELECT username FROM account WHERE id = ?', (user_id,)).fetchone()
                if user_info:
                    username = user_info['username']
                    # Insert into admin table including username
                    conn.execute('INSERT INTO admin (Account_ID, admin_name) VALUES (?, ?)', (user_id, username))
                    conn.commit()

                    # Remove the account from the users table
                    conn.execute('DELETE FROM users WHERE Account_ID = ?', (user_id,))
                    conn.commit()

                    response = {'message': 'User granted admin privileges'}
                else:
                    response = {'message': 'User not found'}
                    status_code = 404
                    return jsonify(response), status_code
            else:
                response = {'message': 'User already has admin privileges'}
            status_code = 200
        except Exception as e:
            conn.rollback()
            response = {'message': 'Failed to grant admin privileges', 'error': str(e)}
            status_code = 500
        finally:
            conn.close()
    else:
        response = {'message': 'Invalid security key'}
        status_code = 400

    return jsonify(response), status_code


@app.route('/update_diet_restrictions', methods=['POST'])
def update_diet_restrictions():
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'message': 'User not logged in'}), 403

    restrictions = request.form.getlist('diet[]')  # This captures all checked boxes
    conn = get_db_connection()
    try:
        # Clear existing restrictions for simplicity, or check and update
        conn.execute('DELETE FROM user_restrictions WHERE User_ID = ?', (user_id,))
        for restriction in restrictions:
            conn.execute('INSERT INTO user_restrictions (User_ID, UserRestriction) VALUES (?, ?)', (user_id, restriction))
        conn.commit()
        response = {'message': 'Dietary restrictions updated successfully'}
        status_code = 200
    except Exception as e:
        conn.rollback()
        response = {'message': 'Failed to update dietary restrictions', 'error': str(e)}
        status_code = 500
    finally:
        conn.close()

    return jsonify(response), status_code

@app.route('/delete_account', methods=['POST'])
def delete_account():
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'message': 'User not logged in'}), 403

    conn = get_db_connection()
    try:
        # Delete account from admin table (if it exists)
        conn.execute('DELETE FROM admin WHERE Account_ID = ?', (user_id,))
        
        # Delete account from users table
        conn.execute('DELETE FROM users WHERE Account_ID = ?', (user_id,))
        
        # Delete corresponding rows from user_restrictions table
        conn.execute('DELETE FROM user_restrictions WHERE User_ID = ?', (user_id,))
        
        # Delete account from account table
        conn.execute('DELETE FROM account WHERE id = ?', (user_id,))
        
        conn.commit()
        
        response = {'message': 'Account deleted successfully'}
        status_code = 200
    except Exception as e:
        conn.rollback()
        response = {'message': 'Failed to delete account', 'error': str(e)}
        status_code = 500
    finally:
        conn.close()

    return jsonify(response), status_code


def slugify(text):
    """Create a URL slug from the recipe name."""
    return urllib.parse.quote_plus(text.lower().replace(" ", "-"))

@app.route('/create-recipe', methods=['GET', 'POST'])
def create_recipe():
    if 'user_id' not in session:
        return redirect(url_for('index'))

    if request.method == 'POST':
        recipe_name = request.form['recipe_name']
        description = request.form['description']
        prep_time = request.form['prep_time']
        cook_time = request.form['cook_time']
        ingredients = request.form['ingredients']
        instructions = request.form['instructions']
        cuisine_type = request.form['cuisine_type']
        user_id = session.get('user_id', 1)  # Default to user ID 1 if not logged in
        tags = request.form.getlist('tags[]')

        file = request.files['recipe_image']
        filename = secure_filename(file.filename) if file else None
        if filename and allowed_file(filename):
            file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            file.save(file_path)
        else:
            file_path = None  # Handle cases where no file is provided or file type is not allowed

        conn = get_db_connection()
        cursor = conn.cursor()
        try:
            cursor.execute('''
                INSERT INTO recipe (recipe_name, recipe_description, Cuisine_ID, UserID, prep_time, cook_time, recipe_image, instructions)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            ''', (recipe_name, description, cuisine_type, user_id, prep_time, cook_time, file_path, instructions))

            ingredient_list = ingredients.split(',')
            for ingredient in ingredient_list:
                cursor.execute('''
                    INSERT INTO ingredients (recipe_name, ingredient_name)
                    VALUES (?, ?)
                ''', (recipe_name, ingredient.strip()))

            for tag in tags:
                cursor.execute('''
                    INSERT INTO recipe_restrictions (recipe_name, RecRestriction)
                    VALUES (?, ?)
                ''', (recipe_name, tag))

            conn.commit()
        except sqlite3.IntegrityError as e:
            conn.rollback()
            return jsonify({'error': 'Failed to insert recipe into database', 'details': str(e)}), 500
        finally:
            conn.close()

        return redirect(url_for('view_recipe', slug=recipe_name))  # Adjust according to your URL structure
    else:
        return render_template('create_recipe.html')
    


@app.route('/recipe/<slug>')
def view_recipe(slug):
    conn = get_db_connection()
    try:
        recipe_title = slug.replace("-", " ")  # Convert slug back to title
        recipe = conn.execute('SELECT * FROM recipe WHERE recipe_name = ?', (recipe_title,)).fetchone()
        ingredients = conn.execute('SELECT ingredient_name FROM ingredients WHERE recipe_name = ?', (recipe_title,)).fetchall()
        tags = conn.execute('SELECT RecRestriction FROM recipe_restrictions WHERE recipe_name = ?', (recipe_title,)).fetchall()

        if recipe:
            # Pass all these details to the template
            return render_template('recipe.html', recipe=recipe, ingredients=ingredients, tags=tags)
        else:
            return 'Recipe not found', 404
    finally:
        conn.close()



if __name__ == '__main__':
    init_db()  
    app.run(debug=True)

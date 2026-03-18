from flask import Flask, request, jsonify
from flask_cors import CORS
import json

app = Flask(__name__)
CORS(app)  # Enable CORS for Flutter app

@app.route('/api/auth/register/user/', methods=['POST'])
def register_user():
    try:
        data = request.get_json()

        # Validate required fields
        required_fields = ['full_name', 'email', 'username', 'password', 'confirm_password']
        for field in required_fields:
            if field not in data or not data[field]:
                return jsonify({
                    'success': False,
                    'message': f'{field.replace("_", " ").title()} is required'
                }), 400

        # Check if passwords match
        if data['password'] != data['confirm_password']:
            return jsonify({
                'success': False,
                'message': 'Passwords do not match'
            }), 400

        # Simulate successful registration
        return jsonify({
            'success': True,
            'message': 'User registered successfully',
            'data': {
                'user_id': 123,
                'email': data['email'],
                'username': data['username']
            }
        }), 201

    except Exception as e:
        return jsonify({
            'success': False,
            'message': 'Server error occurred'
        }), 500

@app.route('/api/auth/register/worker/', methods=['POST'])
def register_worker():
    try:
        data = request.get_json()

        # Validate required fields
        required_fields = ['full_name', 'email', 'username', 'password', 'confirm_password']
        for field in required_fields:
            if field not in data or not data[field]:
                return jsonify({
                    'success': False,
                    'message': f'{field.replace("_", " ").title()} is required'
                }), 400

        # Check if passwords match
        if data['password'] != data['confirm_password']:
            return jsonify({
                'success': False,
                'message': 'Passwords do not match'
            }), 400

        # Simulate successful registration
        return jsonify({
            'success': True,
            'message': 'Worker registered successfully',
            'data': {
                'worker_id': 456,
                'email': data['email'],
                'username': data['username']
            }
        }), 201

    except Exception as e:
        return jsonify({
            'success': False,
            'message': 'Server error occurred'
        }), 500

@app.route('/api/auth/login/', methods=['POST'])
def login():
    try:
        data = request.get_json()

        # Validate required fields
        if 'username' not in data or not data['username']:
            return jsonify({
                'success': False,
                'message': 'Username is required'
            }), 400

        if 'password' not in data or not data['password']:
            return jsonify({
                'success': False,
                'message': 'Password is required'
            }), 400

        username = data['username']
        password = data['password']

        # Mock authentication logic
        # For demo purposes, we'll check some hardcoded credentials
        # In real app, this would check against database

        # Mock users (you can modify these for testing)
        mock_users = {
            'user123': {'password': 'password123', 'type': 'user', 'name': 'John Doe', 'email': 'john@example.com'},
            'worker123': {'password': 'password123', 'type': 'worker', 'name': 'Jane Smith', 'email': 'jane@example.com'},
        }

        if username in mock_users and mock_users[username]['password'] == password:
            user_data = mock_users[username]
            return jsonify({
                'success': True,
                'message': 'Login successful',
                'user_type': user_data['type'],
                'user_data': {
                    'id': 123 if user_data['type'] == 'user' else 456,
                    'username': username,
                    'name': user_data['name'],
                    'email': user_data['email'],
                    'type': user_data['type']
                }
            }), 200
        else:
            return jsonify({
                'success': False,
                'message': 'Invalid username or password'
            }), 401

    except Exception as e:
        return jsonify({
            'success': False,
            'message': 'Server error occurred'
        }), 500

@app.route('/', methods=['GET'])
def health_check():
    return jsonify({
        'status': 'Mock API Server Running',
        'endpoints': [
            'POST /api/auth/register/user/',
            'POST /api/auth/register/worker/',
            'POST /api/auth/login/'
        ],
        'test_credentials': {
            'user': {'username': 'user123', 'password': 'password123'},
            'worker': {'username': 'worker123', 'password': 'password123'}
        }
    })

if __name__ == '__main__':
    print("Starting Mock API Server...")
    print("User Registration: POST http://127.0.0.1:8000/api/auth/register/user/")
    print("Worker Registration: POST http://127.0.0.1:8000/api/auth/register/worker/")
    print("Login: POST http://127.0.0.1:8000/api/auth/login/")
    print("Health Check: GET http://127.0.0.1:8000/")
    print("\nTest Credentials:")
    print("User: username='user123', password='password123'")
    print("Worker: username='worker123', password='password123'")
    app.run(host='0.0.0.0', port=8000, debug=True)
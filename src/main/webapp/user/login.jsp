<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Movie Rental System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #121212;
            color: #e0e0e0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .container {
            margin-top: 50px;
        }

        .card {
            background-color: #1e1e1e;
            border: 1px solid #333;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(138, 43, 226, 0.4);
        }

        .card-header {
            background-color: #2d2d2d;
            color: #ff00ff;
            font-weight: bold;
            border-bottom: 1px solid #444;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        .form-control {
            background-color: #333;
            border: 1px solid #444;
            color: #fff;
        }

        .form-control:focus {
            background-color: #3a3a3a;
            color: #fff;
            border-color: #8a2be2;
            box-shadow: 0 0 0 0.25rem rgba(138, 43, 226, 0.25);
        }

        .btn-primary {
            background: linear-gradient(to right, #8a2be2, #ff00ff);
            border: none;
            box-shadow: 0 0 10px rgba(138, 43, 226, 0.5);
        }

        .btn-primary:hover {
            background: linear-gradient(to right, #9b4dff, #ff66ff);
            transform: translateY(-2px);
            box-shadow: 0 0 15px rgba(138, 43, 226, 0.7);
        }

        .form-label {
            color: #ff00ff;
            font-weight: 500;
        }

        .alert-danger {
            background-color: #330000;
            color: #ff6666;
            border-color: #550000;
        }

        .text-neon {
            color: #8a2be2;
            text-shadow: 0 0 5px rgba(138, 43, 226, 0.7);
        }

        .link-neon {
            color: #ff00ff;
            text-decoration: none;
            position: relative;
        }

        .link-neon:hover {
            color: #ff66ff;
            text-shadow: 0 0 8px rgba(255, 0, 255, 0.8);
        }

        .link-neon::after {
            content: '';
            position: absolute;
            width: 100%;
            height: 1px;
            bottom: -2px;
            left: 0;
            background: linear-gradient(to right, #8a2be2, #ff00ff);
            transform: scaleX(0);
            transform-origin: bottom right;
            transition: transform 0.3s;
        }

        .link-neon:hover::after {
            transform: scaleX(1);
            transform-origin: bottom left;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header text-center py-3">
                        <h3 class="mb-0">Create Your Account</h3>
                    </div>
                    <div class="card-body p-4">
                        <% if(request.getAttribute("errorMessage") != null) { %>
                            <div class="alert alert-danger">
                                <%= request.getAttribute("errorMessage") %>
                            </div>
                        <% } %>

                        <form action="<%= request.getContextPath() %>/register" method="post">
                            <div class="mb-3">
                                <label for="username" class="form-label">Username</label>
                                <input type="text" class="form-control" id="username" name="username" required>
                            </div>

                            <div class="mb-3">
                                <label for="fullName" class="form-label">Full Name</label>
                                <input type="text" class="form-control" id="fullName" name="fullName" required>
                            </div>

                            <div class="mb-3">
                                <label for="email" class="form-label">Email Address</label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>

                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>

                            <div class="mb-4">
                                <label for="confirmPassword" class="form-label">Confirm Password</label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary py-2">Register</button>
                            </div>
                        </form>
                    </div>
                    <div class="card-footer text-center py-3">
                        <p class="mb-0">Already have an account? <a href="<%= request.getContextPath() %>/login" class="link-neon">Login here</a></p>
                    </div>
                </div>

                <div class="text-center mt-4">
                    <a href="<%= request.getContextPath() %>/" class="link-neon">← Back to Home</a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
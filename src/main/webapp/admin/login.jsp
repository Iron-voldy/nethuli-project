<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - FilmFlux</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        :root {
            --admin-primary: #6200ea;
            --admin-secondary: #b388ff;
            --admin-accent: #9c27b0;
            --dark-bg: #121212;
            --card-bg: #1e1e1e;
            --text-primary: #e0e0e0;
            --text-secondary: #a0a0a0;
        }

        body {
            background-color: var(--dark-bg);
            color: var(--text-primary);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            background-image:
                radial-gradient(circle at 90% 10%, rgba(98, 0, 234, 0.15) 0%, transparent 30%),
                radial-gradient(circle at 10% 90%, rgba(155, 39, 176, 0.1) 0%, transparent 30%);
        }

        .login-container {
            margin-top: 2rem;
            margin-bottom: 2rem;
        }

        .card {
            background-color: var(--card-bg);
            border-radius: 15px;
            border: 1px solid #333;
            box-shadow: 0 0 30px rgba(98, 0, 234, 0.2);
            overflow: hidden;
        }

        .card-header {
            background: linear-gradient(135deg, rgba(98, 0, 234, 0.2), rgba(155, 39, 176, 0.2));
            color: var(--admin-primary);
            font-weight: 700;
            text-align: center;
            padding: 1.5rem;
            border-bottom: 1px solid #333;
        }

        .card-body {
            padding: 2rem;
        }

        .login-logo {
            font-size: 2.5rem;
            font-weight: 700;
            background: linear-gradient(to right, var(--admin-primary), var(--admin-secondary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            margin-bottom: 1rem;
            display: block;
            text-align: center;
        }

        .form-label {
            color: var(--admin-primary);
            font-weight: 500;
            margin-bottom: 0.5rem;
        }

        .form-control {
            background-color: #2d2d2d;
            border: 1px solid #444;
            color: var(--text-primary);
            border-radius: 8px;
            padding: 12px 15px;
        }

        .form-control:focus {
            background-color: #333;
            color: var(--text-primary);
            border-color: var(--admin-primary);
            box-shadow: 0 0 0 0.25rem rgba(98, 0, 234, 0.25);
        }

        .input-group-text {
            background-color: #2d2d2d;
            border: 1px solid #444;
            color: var(--admin-primary);
        }

        .btn-login {
            background: linear-gradient(to right, var(--admin-primary), var(--admin-accent));
            border: none;
            color: white;
            font-weight: 600;
            padding: 12px;
            border-radius: 8px;
            width: 100%;
            margin-top: 1rem;
            transition: all 0.3s;
            box-shadow: 0 0 15px rgba(98, 0, 234, 0.3);
        }

        .btn-login:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(98, 0, 234, 0.4);
        }

        .back-link {
            text-align: center;
            margin-top: 1.5rem;
            color: var(--text-secondary);
        }

        .back-link a {
            color: var(--admin-secondary);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
        }

        .back-link a:hover {
            color: var(--admin-primary);
        }

        .back-link i {
            margin-right: 0.5rem;
        }

        .alert {
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
        }

        .alert-danger {
            background-color: rgba(220, 53, 69, 0.2);
            color: #ff6b6b;
            border-color: #dc3545;
        }

        .alert-success {
            background-color: rgba(40, 167, 69, 0.2);
            color: #51cf66;
            border-color: #28a745;
        }

        .admin-badge {
            background-color: var(--admin-primary);
            color: white;
            font-size: 0.8rem;
            padding: 3px 10px;
            border-radius: 20px;
            margin-top: 8px;
            display: inline-block;
        }
    </style>
</head>
<body>
    <div class="container login-container">
        <div class="row justify-content-center">
            <div class="col-lg-5 col-md-7">
                <div class="card">
                    <div class="card-header">
                        <span class="login-logo">FilmFlux</span>
                        <h4 class="mb-0">Admin Panel</h4>
                        <span class="admin-badge">Restricted Access</span>
                    </div>
                    <div class="card-body">
                        <% if(request.getAttribute("errorMessage") != null) { %>
                            <div class="alert alert-danger">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                <%= request.getAttribute("errorMessage") %>
                            </div>
                        <% } %>

                        <% if(session.getAttribute("successMessage") != null) { %>
                            <div class="alert alert-success">
                                <i class="bi bi-check-circle-fill me-2"></i>
                                <%= session.getAttribute("successMessage") %>
                                <% session.removeAttribute("successMessage"); %>
                            </div>
                        <% } %>

                        <form action="<%= request.getContextPath() %>/admin/login" method="post">
                            <div class="mb-3">
                                <label for="username" class="form-label">Username</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-person-badge"></i></span>
                                    <input type="text" class="form-control" id="username" name="username" placeholder="Enter your admin username" required>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label for="password" class="form-label">Password</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-shield-lock"></i></span>
                                    <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-login">
                                <i class="bi bi-box-arrow-in-right me-2"></i> Admin Login
                            </button>
                        </form>

                        <div class="back-link">
                            <a href="<%= request.getContextPath() %>/">
                                <i class="bi bi-house-fill"></i> Back to Main Site
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
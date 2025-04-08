<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.admin.Admin" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel - FilmFlux</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css">
    <!-- Custom Admin CSS -->
    <style>
        :root {
            --admin-primary: #6200ea;
            --admin-secondary: #b388ff;
            --admin-accent: #9c27b0;
            --dark-bg: #121212;
            --darker-bg: #0a0a0a;
            --card-bg: #1e1e1e;
            --card-header: #252525;
            --text-primary: #e0e0e0;
            --text-secondary: #a0a0a0;
            --success: #4caf50;
            --warning: #ff9800;
            --danger: #f44336;
            --info: #2196f3;
        }

        body {
            background-color: var(--dark-bg);
            color: var(--text-primary);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Sidebar Styles */
        .admin-sidebar {
            background-color: var(--darker-bg);
            min-height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            width: 250px;
            border-right: 1px solid #333;
            transition: all 0.3s;
            z-index: 1000;
        }

        .sidebar-sticky {
            position: sticky;
            top: 0;
            height: calc(100vh);
            padding-top: 0.5rem;
            overflow-x: hidden;
            overflow-y: auto;
        }

        .sidebar-header {
            padding: 1.5rem 1rem;
            border-bottom: 1px solid #333;
        }

        .sidebar-brand {
            font-size: 1.5rem;
            font-weight: 700;
            background: linear-gradient(to right, var(--admin-primary), var(--admin-secondary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            margin: 0;
            display: flex;
            align-items: center;
        }

        .sidebar-brand i {
            margin-right: 0.5rem;
            color: var(--admin-primary);
        }

        .admin-badge {
            background-color: var(--admin-primary);
            color: white;
            font-size: 0.7rem;
            padding: 3px 8px;
            border-radius: 20px;
            margin-left: 8px;
        }

        .nav-heading {
            text-transform: uppercase;
            font-size: 0.8rem;
            color: var(--text-secondary);
            padding: 1rem 1rem 0.5rem;
            font-weight: 500;
        }

        .sidebar-link {
            display: flex;
            align-items: center;
            color: var(--text-secondary);
            padding: 0.8rem 1rem;
            text-decoration: none;
            transition: all 0.3s;
            border-left: 3px solid transparent;
        }

        .sidebar-link:hover, .sidebar-link.active {
            color: var(--admin-secondary);
            background-color: rgba(98, 0, 234, 0.1);
            border-left-color: var(--admin-primary);
        }

        .sidebar-link i {
            font-size: 1.1rem;
            margin-right: 0.8rem;
            color: inherit;
        }

        .content-wrapper {
            margin-left: 250px;
            width: calc(100% - 250px);
            min-height: 100vh;
            transition: all 0.3s;
        }

        .admin-navbar {
            background-color: var(--card-bg);
            border-bottom: 1px solid #333;
            padding: 0.75rem 1.5rem;
        }

        .admin-container {
            padding: 1.5rem;
        }

        /* Card Styles */
        .card {
            background-color: var(--card-bg);
            border: 1px solid #333;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .card-header {
            background-color: var(--card-header);
            color: var(--text-primary);
            font-weight: 600;
            padding: 1rem 1.25rem;
            border-bottom: 1px solid #333;
        }

        .card-body {
            padding: 1.25rem;
        }

        /* Form Styles */
        .form-label {
            color: var(--admin-secondary);
            font-weight: 500;
        }

        .form-control, .form-select {
            background-color: #2d2d2d;
            border: 1px solid #444;
            color: var(--text-primary);
            border-radius: 6px;
        }

        .form-control:focus, .form-select:focus {
            background-color: #333;
            color: var(--text-primary);
            border-color: var(--admin-primary);
            box-shadow: 0 0 0 0.25rem rgba(98, 0, 234, 0.25);
        }

        /* Button Styles */
        .btn-admin {
            background: linear-gradient(to right, var(--admin-primary), var(--admin-accent));
            border: none;
            color: white;
            transition: all 0.3s;
        }

        .btn-admin:hover {
            box-shadow: 0 4px 8px rgba(98, 0, 234, 0.3);
            transform: translateY(-2px);
        }

        .btn-outline-admin {
            border: 1px solid var(--admin-primary);
            color: var(--admin-primary);
            background: transparent;
        }

        .btn-outline-admin:hover {
            background-color: var(--admin-primary);
            color: white;
        }

        /* Table Styles */
        .table {
            color: var(--text-primary);
        }

        .table th {
            color: var(--admin-secondary);
            border-color: #333;
        }

        .table td {
            border-color: #333;
        }

        .table-hover tbody tr:hover {
            background-color: rgba(98, 0, 234, 0.05);
        }

        /* Alert Styles */
        .alert {
            border-radius: 6px;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }

        .alert-success {
            background-color: rgba(76, 175, 80, 0.1);
            color: #81c784;
            border-color: #388e3c;
        }

        .alert-danger {
            background-color: rgba(244, 67, 54, 0.1);
            color: #e57373;
            border-color: #d32f2f;
        }

        /* Badge Styles */
        .badge-admin {
            background-color: var(--admin-primary);
            color: white;
        }

        .badge-success {
            background-color: var(--success);
            color: white;
        }

        .badge-warning {
            background-color: var(--warning);
            color: #212529;
        }

        .badge-danger {
            background-color: var(--danger);
            color: white;
        }

        .badge-info {
            background-color: var(--info);
            color: white;
        }

        /* Dashboard Stat Card */
        .stat-card {
            border-radius: 8px;
            padding: 1.5rem;
            height: 100%;
            border-bottom: 4px solid var(--admin-primary);
            transition: all 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            color: var(--admin-secondary);
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            background: linear-gradient(to right, var(--admin-primary), var(--admin-secondary));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .stat-label {
            color: var(--text-secondary);
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* DataTables Styling */
        .dataTables_wrapper .dataTables_length,
        .dataTables_wrapper .dataTables_filter,
        .dataTables_wrapper .dataTables_info {
            color: var(--text-secondary);
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button {
            color: var(--text-secondary) !important;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button.current {
            background: var(--admin-primary) !important;
            border-color: var(--admin-primary) !important;
            color: white !important;
        }

        .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
            background: var(--admin-secondary) !important;
            border-color: var(--admin-secondary) !important;
            color: white !important;
        }

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .admin-sidebar {
                width: 70px;
            }

            .sidebar-brand span, .sidebar-link span, .nav-heading {
                display: none;
            }

            .sidebar-link i {
                font-size: 1.5rem;
                margin-right: 0;
            }

            .content-wrapper {
                margin-left: 70px;
                width: calc(100% - 70px);
            }
        }
    </style>
</head>
<body>
<%
    // Get admin from session
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login");
        return;
    }

    // Current page for active link highlighting
    String currentPage = request.getRequestURI();
%>

<!-- Sidebar -->
<div class="admin-sidebar">
    <div class="sidebar-sticky">
        <div class="sidebar-header">
            <h2 class="sidebar-brand">
                <i class="bi bi-film"></i>
                <span>FilmFlux</span>
                <span class="admin-badge">Admin</span>
            </h2>
        </div>

        <div class="nav-heading">Dashboard</div>
        <a href="<%= request.getContextPath() %>/admin/dashboard"
           class="sidebar-link <%= currentPage.contains("/admin/dashboard") ? "active" : "" %>">
            <i class="bi bi-speedometer2"></i>
            <span>Dashboard</span>
        </a>

        <div class="nav-heading">Content Management</div>
        <a href="<%= request.getContextPath() %>/admin/movies"
           class="sidebar-link <%= currentPage.contains("/admin/movies") ? "active" : "" %>">
            <i class="bi bi-film"></i>
            <span>Movies</span>
        </a>
        <a href="<%= request.getContextPath() %>/admin/rentals"
           class="sidebar-link <%= currentPage.contains("/admin/rentals") ? "active" : "" %>">
            <i class="bi bi-collection-play"></i>
            <span>Rentals</span>
        </a>
        <a href="<%= request.getContextPath() %>/admin/reviews"
           class="sidebar-link <%= currentPage.contains("/admin/reviews") ? "active" : "" %>">
            <i class="bi bi-star"></i>
            <span>Reviews</span>
        </a>

        <div class="nav-heading">User Management</div>
        <a href="<%= request.getContextPath() %>/admin/users"
           class="sidebar-link <%= currentPage.contains("/admin/users") ? "active" : "" %>">
            <i class="bi bi-people"></i>
            <span>Users</span>
        </a>

        <% if (admin.isSuperAdmin()) { %>
        <a href="<%= request.getContextPath() %>/admin/manage-admins"
           class="sidebar-link <%= currentPage.contains("/admin/manage-admins") ? "active" : "" %>">
            <i class="bi bi-person-badge"></i>
            <span>Admins</span>
        </a>
        <% } %>

        <div class="nav-heading">Account</div>
        <a href="<%= request.getContextPath() %>/admin/profile"
           class="sidebar-link <%= currentPage.contains("/admin/profile") ? "active" : "" %>">
            <i class="bi bi-person-circle"></i>
            <span>My Profile</span>
        </a>
        <a href="<%= request.getContextPath() %>/admin/logout" class="sidebar-link">
            <i class="bi bi-box-arrow-right"></i>
            <span>Logout</span>
        </a>
    </div>
</div>

<!-- Content Wrapper -->
<div class="content-wrapper">
    <!-- Top Navigation -->
    <nav class="admin-navbar d-flex justify-content-between align-items-center">
        <div>
            <span class="text-secondary">
                <i class="bi bi-calendar3"></i> <%= new java.text.SimpleDateFormat("EEEE, MMMM d, yyyy").format(new java.util.Date()) %>
            </span>
        </div>
        <div>
            <span class="me-3">
                <i class="bi bi-person-circle me-1"></i>
                <%= admin.getFullName() %>
                <% if (admin.isSuperAdmin()) { %>
                    <span class="badge badge-admin ms-1">Super Admin</span>
                <% } else { %>
                    <span class="badge bg-secondary ms-1">Admin</span>
                <% } %>
            </span>
        </div>
    </nav>

    <!-- Main Content Container -->
    <div class="admin-container">
        <% if(session.getAttribute("successMessage") != null) { %>
            <div class="alert alert-success">
                <i class="bi bi-check-circle me-2"></i>
                <%= session.getAttribute("successMessage") %>
                <% session.removeAttribute("successMessage"); %>
            </div>
        <% } %>

        <% if(session.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger">
                <i class="bi bi-exclamation-triangle me-2"></i>
                <%= session.getAttribute("errorMessage") %>
                <% session.removeAttribute("errorMessage"); %>
            </div>
        <% } %>
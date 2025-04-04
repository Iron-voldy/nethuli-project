<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.recommendation.Recommendation" %>
<%@ page import="com.movierental.model.recommendation.PersonalRecommendation" %>
<%@ page import="com.movierental.model.recommendation.GeneralRecommendation" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Recommendations - Movie Rental System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        :root {
            --neon-blue: #00c8ff;
            --neon-purple: #8a2be2;
            --neon-pink: #ff00ff;
            --dark-bg: #121212;
            --card-bg: #1e1e1e;
            --card-secondary: #2d2d2d;
            --text-primary: #e0e0e0;
            --text-secondary: #aaaaaa;
            --input-bg: #333;
            --input-border: #444;
        }

        body {
            background-color: var(--dark-bg);
            color: var(--text-primary);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            padding-bottom: 60px;
            background-image:
                radial-gradient(circle at 90% 10%, rgba(0, 200, 255, 0.15) 0%, transparent 30%),
                radial-gradient(circle at 10% 90%, rgba(255, 0, 255, 0.1) 0%, transparent 30%);
        }

        .navbar {
            background-color: rgba(30, 30, 30, 0.8);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid #333;
            box-shadow: 0 2px 20px rgba(0, 0, 0, 0.3);
        }

        .navbar-brand {
            font-weight: bold;
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            font-size: 1.5rem;
        }

        .nav-link {
            color: var(--text-primary);
            margin: 0 10px;
            position: relative;
        }

        .nav-link:hover {
            color: var(--neon-blue);
        }

        .nav-link::after {
            content: '';
            position: absolute;
            width: 100%;
            height: 2px;
            bottom: 0;
            left: 0;
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            transform: scaleX(0);
            transform-origin: bottom right;
            transition: transform 0.3s;
        }

        .nav-link:hover::after {
            transform: scaleX(1);
            transform-origin: bottom left;
        }

        .container {
            margin-top: 30px;
        }

        .page-header {
            background: linear-gradient(135deg, rgba(0, 200, 255, 0.2), rgba(138, 43, 226, 0.2));
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            border: 1px solid #333;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-title {
            font-size: 2rem;
            font-weight: 700;
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .card {
            background-color: var(--card-bg);
            border: 1px solid #333;
            border-radius: 15px;
            margin-bottom: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }

        .card-header {
            background-color: var(--card-secondary);
            color: var(--neon-blue);
            font-weight: 600;
            border-bottom: 1px solid #444;
            padding: 15px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .card-header i {
            margin-right: 10px;
            color: var(--neon-purple);
            font-size: 1.2rem;
        }

        .btn-neon {
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            border: none;
            border-radius: 8px;
            color: white;
            font-weight: 600;
            padding: 10px 20px;
            transition: all 0.3s ease;
            box-shadow: 0 0 15px rgba(0, 200, 255, 0.3);
        }

        .btn-neon:hover {
            transform: translateY(-2px);
            box-shadow: 0 0 20px rgba(0, 200, 255, 0.6);
            color: white;
        }

        .btn-sm {
            padding: 5px 10px;
            font-size: 0.85rem;
        }

        .btn-outline-neon {
            background: transparent;
            border: 1px solid var(--neon-blue);
            color: var(--neon-blue);
        }

        .btn-outline-neon:hover {
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            color: white;
        }

        .btn-danger-neon {
            background: linear-gradient(to right, #ff416c, #ff4b2b);
            border: none;
            border-radius: 8px;
            color: white;
            font-weight: 600;
            padding: 10px 20px;
            transition: all 0.3s ease;
            box-shadow: 0 0 15px rgba(255, 65, 108, 0.3);
        }

        .btn-danger-neon:hover {
            transform: translateY(-2px);
            box-shadow: 0 0 20px rgba(255, 65, 108, 0.6);
            color: white;
        }

        .table {
            color: var(--text-primary);
            border-color: #333;
        }

        .table th {
            background-color: var(--card-secondary);
            color: var(--neon-blue);
            border-color: #444;
        }

        .table td {
            border-color: #333;
        }

        .table-row {
            background-color: rgba(30, 30, 30, 0.7);
            transition: all 0.2s;
        }

        .table-row:hover {
            background-color: rgba(0, 200, 255, 0.1);
        }

        .badge-personal {
            background: linear-gradient(to right, var(--neon-purple), var(--neon-pink));
            color: white;
            font-weight: 600;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
        }

        .badge-general {
            background: linear-gradient(to right, var(--neon-blue), #4db5ff);
            color: white;
            font-weight: 600;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
        }

        .alert-success {
            background-color: rgba(0, 51, 0, 0.7);
            color: #66ff66;
            border-color: #005500;
            border-radius: 8px;
        }

        .alert-danger {
            background-color: rgba(51, 0, 0, 0.7);
            color: #ff6666;
            border-color: #550000;
            border-radius: 8px;
        }

        .empty-state {
            text-align: center;
            padding: 50px 20px;
        }

        .empty-state i {
            font-size: 4rem;
            color: #444;
            margin-bottom: 20px;
        }

        .empty-message {
            color: var(--text-secondary);
            margin-bottom: 20px;
        }

        .dropdown-menu {
            background-color: var(--card-bg);
            border: 1px solid #444;
        }

        .dropdown-item {
            color: var(--text-primary);
        }

        .dropdown-item:hover {
            background-color: var(--card-secondary);
            color: var(--neon-blue);
        }
    </style>
</head>
<body>
    <%
        // Get user from session
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get data from request attributes
        List<Recommendation> recommendations = (List<Recommendation>) request.getAttribute("recommendations");
        Map<String, Movie> movieMap = (Map<String, Movie>) request.getAttribute("movieMap");
        Map<String, User> userMap = new HashMap<>();

        // Get user objects for personal recommendations if available
        List<User> allUsers = (List<User>) request.getAttribute("allUsers");
        if (allUsers != null) {
            for (User u : allUsers) {
                userMap.put(u.getUserId(), u);
            }
        }

        // Date formatter
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
    %>

    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="<%= request.getContextPath() %>/">FilmFlux</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/">
                            <i class="bi bi-house-fill"></i> Home
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/search-movie">
                            <i class="bi bi-film"></i> Movies
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/rental-history">
                            <i class="bi bi-collection-play"></i> My Rentals
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/view-watchlist">
                            <i class="bi bi-bookmark-star"></i> Watchlist
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/view-recommendations">
                            <i class="bi bi-lightning-fill"></i> Recommendations
                        </a>
                    </li>
                </ul>
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/user/profile.jsp">
                            <i class="bi bi-person-circle"></i> <%= user.getUsername() %>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/logout">
                            <i class="bi bi-box-arrow-right"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <!-- Flash messages -->
        <%
            // Check for messages from session
            String successMessage = (String) session.getAttribute("successMessage");
            String errorMessage = (String) session.getAttribute("errorMessage");

            if(successMessage != null) {
                out.println("<div class='alert alert-success'>");
                out.println("<i class='bi bi-check-circle-fill me-2'></i>");
                out.println(successMessage);
                out.println("</div>");
                session.removeAttribute("successMessage");
            }

            if(errorMessage != null) {
                out.println("<div class='alert alert-danger'>");
                out.println("<i class='bi bi-exclamation-triangle-fill me-2'></i>");
                out.println(errorMessage);
                out.println("</div>");
                session.removeAttribute("errorMessage");
            }
        %>

        <!-- Page Header -->
        <div class="page-header">
            <h1 class="header-title">Manage Recommendations</h1>
            <div class="dropdown">
                <button class="btn btn-neon dropdown-toggle" type="button" id="addRecommendationDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="bi bi-plus-circle"></i> Add Recommendation
                </button>
                <ul class="dropdown-menu" aria-labelledby="addRecommendationDropdown">
                    <li><a class="dropdown-item" href="<%= request.getContextPath() %>/manage-recommendations?action=add&type=general">
                        <i class="bi bi-globe me-2"></i> Add General Recommendation
                    </a></li>
                    <li><a class="dropdown-item" href="<%= request.getContextPath() %>/manage-recommendations?action=add&type=personal">
                        <i class="bi bi-person me-2"></i> Add Personal Recommendation
                    </a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item" href="<%= request.getContextPath() %>/generate-recommendations?type=general">
                        <i class="bi bi-magic me-2"></i> Generate All Recommendations
                    </a></li>
                </ul>
            </div>
        </div>

        <!-- Recommendations Table -->
        <div class="card">
            <div class="card-header">
                <i class="bi bi-list-ul"></i> All Recommendations
            </div>
            <div class="card-body">
                <% if (recommendations == null || recommendations.isEmpty()) { %>
                    <div class="empty-state">
                        <i class="bi bi-lightning"></i>
                        <p class="empty-message">No recommendations available</p>
                        <a href="<%= request.getContextPath() %>/manage-recommendations?action=add&type=general" class="btn btn-neon">
                            <i class="bi bi-plus-circle"></i> Add Recommendation
                        </a>
                    </div>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th style="width: 5%">#</th>
                                    <th style="width: 15%">Type</th>
                                    <th style="width: 25%">Movie</th>
                                    <th style="width: 15%">User</th>
                                    <th style="width: 15%">Generated</th>
                                    <th style="width: 10%">Score</th>
                                    <th style="width: 15%">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                int count = 1;
                                for (Recommendation rec : recommendations) {
                                    Movie movie = movieMap.get(rec.getMovieId());
                                    boolean isPersonal = rec.isPersonalized();
                                    String userDisplayName = "N/A";

                                    if (isPersonal && rec.getUserId() != null) {
                                        User recUser = userMap.get(rec.getUserId());
                                        if (recUser != null) {
                                            userDisplayName = recUser.getUsername();
                                        } else {
                                            userDisplayName = "User ID: " + rec.getUserId();
                                        }
                                    }
                                %>
                                <tr class="table-row">
                                    <td><%= count++ %></td>
                                    <td>
                                        <% if (isPersonal) { %>
                                            <span class="badge-personal">
                                                <i class="bi bi-person-fill"></i> Personal
                                            </span>
                                        <% } else { %>
                                            <span class="badge-general">
                                                <i class="bi bi-globe"></i> General
                                            </span>
                                            <%
                                            if (rec instanceof GeneralRecommendation) {
                                                GeneralRecommendation genRec = (GeneralRecommendation) rec;
                                                String category = genRec.getCategory();
                                                if (category != null && !category.isEmpty()) {
                                            %>
                                                <div class="mt-1 small text-muted"><%= category %></div>
                                            <%
                                                }
                                            }
                                            %>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if (movie != null) { %>
                                            <strong><%= movie.getTitle() %></strong>
                                            <div class="small text-muted"><%= movie.getDirector() %> (<%= movie.getReleaseYear() %>)</div>
                                        <% } else { %>
                                            <span class="text-danger">Unknown Movie</span>
                                            <div class="small text-muted">ID: <%= rec.getMovieId() %></div>
                                        <% } %>
                                    </td>
                                    <td><%= userDisplayName %></td>
                                    <td><%= dateFormat.format(rec.getGeneratedDate()) %></td>
                                    <td><%= String.format("%.1f", rec.getScore()) %></td>
                                    <td>
                                        <div class="d-flex gap-2">
                                            <a href="<%= request.getContextPath() %>/manage-recommendations?action=edit&id=<%= rec.getRecommendationId() %>"
                                               class="btn btn-sm btn-outline-neon">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <a href="<%= request.getContextPath() %>/manage-recommendations?action=delete&id=<%= rec.getRecommendationId() %>"
                                               class="btn btn-sm btn-danger-neon"
                                               onclick="return confirm('Are you sure you want to delete this recommendation?')">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
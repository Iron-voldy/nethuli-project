<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.recommendation.Recommendation" %>
<%@ page import="com.movierental.model.recommendation.PersonalRecommendation" %>
<%@ page import="com.movierental.model.recommendation.GeneralRecommendation" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Recommendation - Movie Rental System</title>
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
        }

        .header-title {
            font-size: 2rem;
            font-weight: 700;
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            margin-bottom: 10px;
        }

        .header-subtitle {
            color: var(--text-secondary);
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
        }

        .card-header i {
            margin-right: 10px;
            color: var(--neon-purple);
            font-size: 1.2rem;
        }

        .form-control, .form-select {
            background-color: var(--input-bg);
            border: 1px solid var(--input-border);
            color: white;
            border-radius: 8px;
            padding: 10px 15px;
        }

        .form-control:focus, .form-select:focus {
            background-color: #3a3a3a;
            color: white;
            border-color: var(--neon-blue);
            box-shadow: 0 0 0 0.25rem rgba(0, 200, 255, 0.25);
        }

        .form-select {
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%23ffffff' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M2 5l6 6 6-6'/%3e%3c/svg%3e");
        }

        .form-label {
            color: var(--neon-blue);
            font-weight: 500;
            margin-bottom: 0.5rem;
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

        .btn-secondary {
            background-color: #444;
            border: none;
            color: var(--text-primary);
        }

        .btn-secondary:hover {
            background-color: #555;
            color: var(--text-primary);
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

        .alert-danger {
            background-color: rgba(51, 0, 0, 0.7);
            color: #ff6666;
            border-color: #550000;
            border-radius: 8px;
        }

        .header-personal {
            background: linear-gradient(135deg, rgba(138, 43, 226, 0.2), rgba(255, 0, 255, 0.2));
        }

        .personal-title {
            background: linear-gradient(to right, var(--neon-purple), var(--neon-pink));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .personal-header i {
            color: var(--neon-pink);
        }

        .additional-fields {
            background-color: rgba(30, 30, 30, 0.5);
            border-radius: 10px;
            padding: 15px;
            margin-top: 20px;
            border: 1px dashed #444;
        }

        .additional-fields-title {
            color: var(--neon-blue);
            margin-bottom: 15px;
            font-weight: 600;
        }

        .meta-info {
            background-color: rgba(30, 30, 30, 0.7);
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
        }

        .meta-item {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .meta-label {
            color: var(--text-secondary);
            font-size: 0.8rem;
            margin-bottom: 5px;
        }

        .meta-value {
            font-weight: 600;
            font-size: 0.9rem;
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
        Recommendation recommendation = (Recommendation) request.getAttribute("recommendation");
        Movie movie = (Movie) request.getAttribute("movie");
        List<Movie> allMovies = (List<Movie>) request.getAttribute("allMovies");

        if (recommendation == null) {
            response.sendRedirect(request.getContextPath() + "/manage-recommendations");
            return;
        }

        boolean isPersonal = recommendation.isPersonalized();
        List<User> allUsers = null;
        PersonalRecommendation personalRec = null;
        GeneralRecommendation generalRec = null;

        if (isPersonal) {
            personalRec = (PersonalRecommendation) recommendation;
            allUsers = (List<User>) request.getAttribute("allUsers");
        } else {
            generalRec = (GeneralRecommendation) recommendation;
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
            // Check for messages from request
            String errorMessage = (String) request.getAttribute("errorMessage");

            if(errorMessage != null) {
                out.println("<div class='alert alert-danger'>");
                out.println("<i class='bi bi-exclamation-triangle-fill me-2'></i>");
                out.println(errorMessage);
                out.println("</div>");
            }
        %>

        <!-- Page Header -->
        <div class="page-header <%= isPersonal ? "header-personal" : "" %>">
            <h1 class="header-title <%= isPersonal ? "personal-title" : "" %>">
                Edit <%= isPersonal ? "Personal" : "General" %> Recommendation
            </h1>
            <p class="header-subtitle">
                Update <%= isPersonal ? "personalized" : "general" %> recommendation details
            </p>
        </div>

        <!-- Recommendation Meta Information -->
        <div class="meta-info">
            <div class="meta-item">
                <div class="meta-label">Recommendation ID</div>
                <div class="meta-value"><%= recommendation.getRecommendationId() %></div>
            </div>
            <div class="meta-item">
                <div class="meta-label">Generated</div>
                <div class="meta-value"><%= dateFormat.format(recommendation.getGeneratedDate()) %></div>
            </div>
            <div class="meta-item">
                <div class="meta-label">Type</div>
                <div class="meta-value"><%= isPersonal ? "Personal" : "General" %></div>
            </div>
            <% if (!isPersonal && generalRec != null) { %>
                <div class="meta-item">
                    <div class="meta-label">Category</div>
                    <div class="meta-value"><%= generalRec.getCategory() %></div>
                </div>
            <% } %>
        </div>

        <!-- Edit Recommendation Form -->
        <div class="card">
            <div class="card-header <%= isPersonal ? "personal-header" : "" %>">
                <i class="bi bi-<%= isPersonal ? "person-gear" : "gear" %>"></i>
                Edit <%= isPersonal ? "Personal" : "General" %> Recommendation
            </div>
            <div class="card-body p-4">
                <form action="<%= request.getContextPath() %>/manage-recommendations" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="recType" value="<%= isPersonal ? "personal" : "general" %>">
                    <input type="hidden" name="recId" value="<%= recommendation.getRecommendationId() %>">

                    <div class="mb-3">
                        <label for="movieId" class="form-label">Movie</label>
                        <select class="form-select" id="movieId" name="movieId" required>
                            <% if (allMovies != null) {
                                for (Movie m : allMovies) { %>
                                    <option value="<%= m.getMovieId() %>"
                                            <%= m.getMovieId().equals(recommendation.getMovieId()) ? "selected" : "" %>>
                                        <%= m.getTitle() %> (<%= m.getReleaseYear() %>) - <%= m.getDirector() %>
                                    </option>
                                <% }
                            } %>
                        </select>
                    </div>

                    <% if (isPersonal && personalRec != null) { %>
                        <div class="mb-3">
                            <label for="userId" class="form-label">User</label>
                            <select class="form-select" id="userId" name="userId" required>
                                <% if (allUsers != null) {
                                    for (User u : allUsers) { %>
                                        <option value="<%= u.getUserId() %>"
                                                <%= u.getUserId().equals(personalRec.getUserId()) ? "selected" : "" %>>
                                            <%= u.getUsername() %> (<%= u.getFullName() %>)
                                        </option>
                                    <% }
                                } %>
                            </select>
                        </div>
                    <% } %>

                    <div class="mb-3">
                        <label for="reason" class="form-label">Recommendation Reason</label>
                        <textarea class="form-control" id="reason" name="reason" rows="3"
                                  placeholder="Why are you recommending this movie?" required><%= recommendation.getReason() %></textarea>
                    </div>

                    <div class="mb-3">
                        <label for="score" class="form-label">Recommendation Score (0.0-10.0)</label>
                        <input type="number" class="form-control" id="score" name="score"
                               min="0" max="10" step="0.1" value="<%= recommendation.getScore() %>" required>
                    </div>

                    <!-- Additional fields based on recommendation type -->
                    <div class="additional-fields">
                        <h5 class="additional-fields-title">
                            <i class="bi bi-sliders me-2"></i>
                            Additional <%= isPersonal ? "Personal" : "General" %> Recommendation Settings
                        </h5>

                        <% if (isPersonal && personalRec != null) { %>
                            <div class="mb-3">
                                <label for="baseSource" class="form-label">Recommendation Source</label>
                                <select class="form-select" id="baseSource" name="baseSource">
                                    <option value="manual" <%= "manual".equals(personalRec.getBaseSource()) ? "selected" : "" %>>Manual</option>
                                    <option value="genre-preference" <%= "genre-preference".equals(personalRec.getBaseSource()) ? "selected" : "" %>>Genre Preference</option>
                                    <option value="watch-history" <%= "watch-history".equals(personalRec.getBaseSource()) ? "selected" : "" %>>Watch History</option>
                                    <option value="top-rated" <%= "top-rated".equals(personalRec.getBaseSource()) ? "selected" : "" %>>Top Rated</option>
                                    <option value="similar-movies" <%= "similar-movies".equals(personalRec.getBaseSource()) ? "selected" : "" %>>Similar Movies</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="relevanceScore" class="form-label">Relevance Score (0.0-1.0)</label>
                                <input type="number" class="form-control" id="relevanceScore" name="relevanceScore"
                                       min="0" max="1" step="0.1" value="<%= personalRec.getRelevanceScore() %>">
                                <div class="form-text text-secondary">
                                    How relevant this recommendation is to the user (higher value = more relevant)
                                </div>
                            </div>
                        <% } else if (generalRec != null) { %>
                            <div class="mb-3">
                                <label for="category" class="form-label">Category</label>
                                <select class="form-select" id="category" name="category">
                                    <option value="manual" <%= "manual".equals(generalRec.getCategory()) ? "selected" : "" %>>Manual</option>
                                    <option value="top-rated" <%= "top-rated".equals(generalRec.getCategory()) ? "selected" : "" %>>Top Rated</option>
                                    <option value="new-release" <%= "new-release".equals(generalRec.getCategory()) ? "selected" : "" %>>New Release</option>
                                    <option value="classic" <%= "classic".equals(generalRec.getCategory()) ? "selected" : "" %>>Classic</option>
                                    <option value="trending" <%= "trending".equals(generalRec.getCategory()) ? "selected" : "" %>>Trending</option>
                                    <%
                                    // Check if it's a genre-based category
                                    if (generalRec.getCategory() != null && generalRec.getCategory().startsWith("genre-")) {
                                        String genre = generalRec.getCategory().substring(6);
                                    %>
                                        <option value="<%= generalRec.getCategory() %>" selected>
                                            Genre: <%= genre %>
                                        </option>
                                    <% } %>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="rank" class="form-label">Rank</label>
                                <input type="number" class="form-control" id="rank" name="rank"
                                       min="1" max="100" step="1" value="<%= generalRec.getRank() %>">
                                <div class="form-text text-secondary">
                                    Ranking position for this recommendation (lower number = higher rank)
                                </div>
                            </div>
                        <% } %>
                    </div>

                    <div class="mt-4 d-flex justify-content-between">
                        <div>
                            <a href="<%= request.getContextPath() %>/manage-recommendations" class="btn btn-secondary me-2">
                                <i class="bi bi-arrow-left"></i> Cancel
                            </a>
                            <a href="<%= request.getContextPath() %>/manage-recommendations?action=delete&id=<%= recommendation.getRecommendationId() %>"
                               class="btn btn-danger-neon"
                               onclick="return confirm('Are you sure you want to delete this recommendation?')">
                                <i class="bi bi-trash"></i> Delete
                            </a>
                        </div>
                        <button type="submit" class="btn btn-neon">
                            <i class="bi bi-save"></i> Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
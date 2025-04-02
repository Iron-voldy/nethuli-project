<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.recommendation.GeneralRecommendation" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Top Rated Movies - Movie Rental System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        :root {
            --neon-blue: #00c8ff;
            --neon-purple: #8a2be2;
            --neon-pink: #ff00ff;
            --neon-gold: #ffd700;
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
                radial-gradient(circle at 90% 10%, rgba(255, 215, 0, 0.15) 0%, transparent 30%),
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
            background: linear-gradient(135deg, rgba(255, 215, 0, 0.2), rgba(255, 165, 0, 0.2));
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            border: 1px solid #333;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }

        .header-icon {
            font-size: 3rem;
            margin-bottom: 15px;
            color: var(--neon-gold);
            text-shadow: 0 0 10px rgba(255, 215, 0, 0.5);
        }

        .header-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
            background: linear-gradient(to right, var(--neon-gold), #FFA500);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .header-subtitle {
            color: var(--text-secondary);
            max-width: 600px;
            margin: 0 auto;
        }

        .recommendation-tabs {
            display: flex;
            justify-content: center;
            margin-bottom: 30px;
            position: relative;
            z-index: 1;
        }

        .recommendation-tabs::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 1px;
            background-color: #333;
            z-index: -1;
        }

        .rec-tab {
            padding: 10px 20px;
            font-weight: 600;
            border-bottom: 3px solid transparent;
            color: var(--text-secondary);
            text-decoration: none;
            transition: all 0.3s;
            position: relative;
            z-index: 2;
        }

        .rec-tab:hover {
            color: var(--neon-gold);
        }

        .rec-tab.active {
            border-bottom: 3px solid var(--neon-gold);
            color: var(--neon-gold);
        }

        .genre-nav {
            background-color: rgba(30, 30, 30, 0.7);
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid #333;
            overflow-x: auto;
            white-space: nowrap;
            scrollbar-width: thin;
            scrollbar-color: var(--neon-gold) var(--card-bg);
        }

        .genre-nav::-webkit-scrollbar {
            height: 6px;
        }

        .genre-nav::-webkit-scrollbar-track {
            background: var(--card-bg);
            border-radius: 3px;
        }

        .genre-nav::-webkit-scrollbar-thumb {
            background: var(--neon-gold);
            border-radius: 3px;
        }

        .genre-badge {
            display: inline-block;
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            margin-right: 10px;
            text-decoration: none;
            transition: all 0.3s;
            background-color: var(--card-bg);
            color: var(--text-secondary);
            border: 1px solid #444;
        }

        .genre-badge:hover {
            background: linear-gradient(to right, var(--neon-gold), #FFA500);
            color: var(--dark-bg);
            box-shadow: 0 0 15px rgba(255, 215, 0, 0.4);
            border-color: transparent;
        }

        .top-rated-list {
            margin-top: 30px;
        }

        .top-movie {
            background-color: var(--card-bg);
            border: 1px solid #333;
            border-radius: 15px;
            margin-bottom: 20px;
            overflow: hidden;
            display: flex;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .top-movie:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
        }

        .top-movie-rank {
            display: flex;
            align-items: center;
            justify-content: center;
            min-width: 60px;
            font-size: 1.8rem;
            font-weight: 700;
            background: linear-gradient(to bottom, var(--neon-gold), #FFA500);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            position: relative;
        }

        .top-movie-rank::after {
            content: '';
            position: absolute;
            top: 15px;
            bottom: 15px;
            right: 0;
            width: 1px;
            background: linear-gradient(to bottom, transparent, var(--neon-gold), transparent);
        }

        .top-movie-poster {
            width: 100px;
            min-width: 100px;
            height: 150px;
            background: linear-gradient(135deg, #333, #222);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .top-movie-poster i {
            font-size: 2rem;
            color: #444;
        }

        .top-movie-info {
            flex-grow: 1;
            padding: 15px;
            display: flex;
            flex-direction: column;
        }

        .top-movie-title {
            font-weight: 600;
            font-size: 1.1rem;
            margin-bottom: 5px;
            color: var(--text-primary);
        }

        .top-movie-details {
            color: var(--text-secondary);
            font-size: 0.9rem;
            margin-bottom: 10px;
        }

        .top-movie-rating {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .rating-stars {
            color: var(--neon-gold);
            margin-right: 5px;
        }

        .rating-value {
            font-weight: 600;
        }

        .top-movie-reason {
            margin-top: auto;
            padding: 10px;
            border-radius: 8px;
            background-color: rgba(30, 30, 30, 0.5);
            font-size: 0.9rem;
            color: var(--text-secondary);
        }

        .top-movie-actions {
            padding: 15px;
            display: flex;
            flex-direction: column;
            gap: 10px;
            justify-content: center;
            min-width: 120px;
            border-left: 1px solid #333;
        }

        .movie-action-btn {
            text-align: center;
            padding: 8px;
            border-radius: 5px;
            transition: all 0.2s;
            background-color: #333;
            color: var(--text-primary);
            text-decoration: none;
            font-size: 0.85rem;
        }

        .movie-action-btn:hover {
            background-color: #444;
            color: var(--neon-gold);
        }

        .movie-action-btn i {
            margin-right: 3px;
        }

        .btn-neon-gold {
            background: linear-gradient(to right, var(--neon-gold), #FFA500);
            border: none;
            border-radius: 8px;
            color: var(--dark-bg);
            font-weight: 600;
            padding: 10px 20px;
            transition: all 0.3s ease;
            box-shadow: 0 0 15px rgba(255, 215, 0, 0.3);
        }

        .btn-neon-gold:hover {
            transform: translateY(-2px);
            box-shadow: 0 0 20px rgba(255, 215, 0, 0.6);
            color: var(--dark-bg);
        }

        .refresh-section {
            text-align: center;
            margin-top: 30px;
            margin-bottom: 30px;
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

        .alert-success {
            background-color: rgba(0, 51, 0, 0.7);
            color: #66ff66;
            border-color: #005500;
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <%
        // Get user from session
        User user = (User) request.getSession(false).getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get data from request attributes
        List<GeneralRecommendation> recommendations = (List<GeneralRecommendation>) request.getAttribute("recommendations");
        Map<String, Movie> movieMap = (Map<String, Movie>) request.getAttribute("movieMap");
        List<String> allGenres = (List<String>) request.getAttribute("allGenres");

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
                        <a class="nav-link active" href="<%= request.getContextPath() %>/view-recommendations">
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
            String successMessage = (String) request.getSession().getAttribute("successMessage");
            String errorMessage = (String) request.getSession().getAttribute("errorMessage");

            if(successMessage != null) {
                out.println("<div class='alert alert-success'>");
                out.println("<i class='bi bi-check-circle-fill me-2'></i>");
                out.println(successMessage);
                out.println("</div>");
                request.getSession().removeAttribute("successMessage");
            }

            if(errorMessage != null) {
                out.println("<div class='alert alert-danger'>");
                out.println("<i class='bi bi-exclamation-triangle-fill me-2'></i>");
                out.println(errorMessage);
                out.println("</div>");
                request.getSession().removeAttribute("errorMessage");
            }
        %>

        <!-- Page Header -->
        <div class="page-header">
            <div class="header-icon">
                <i class="bi bi-star-fill"></i>
            </div>
            <h1 class="header-title">Top Rated Movies</h1>
            <p class="header-subtitle">
                The highest-rated films in our collection, as rated by our community of movie lovers
            </p>
        </div>

        <!-- Recommendation Tabs -->
        <div class="recommendation-tabs">
            <a href="<%= request.getContextPath() %>/view-recommendations?type=personal" class="rec-tab">
                <i class="bi bi-person-check"></i> Personalized
            </a>
            <a href="<%= request.getContextPath() %>/view-recommendations?type=general" class="rec-tab">
                <i class="bi bi-globe"></i> General
            </a>
            <a href="<%= request.getContextPath() %>/top-rated" class="rec-tab active">
                <i class="bi bi-star-fill"></i> Top Rated
            </a>
        </div>

        <!-- Genre Navigation -->
        <div class="genre-nav">
            <% for (String genre : allGenres) { %>
                <a href="<%= request.getContextPath() %>/genre-recommendations?genre=<%= genre %>" class="genre-badge">
                    <%= genre %>
                </a>
            <% } %>
        </div>

        <!-- Top Rated Movies List -->
        <% if (recommendations == null || recommendations.isEmpty()) { %>
            <div class="empty-state">
                <i class="bi bi-star"></i>
                <p class="empty-message">No top-rated movies available</p>
                <a href="<%= request.getContextPath() %>/generate-recommendations?type=top-rated" class="btn btn-neon-gold">
                    <i class="bi bi-arrow-repeat"></i> Generate Top Rated
                </a>
            </div>
        <% } else { %>
            <div class="top-rated-list">
                <%
                    int displayRank = 1;
                    for (GeneralRecommendation recommendation : recommendations) {
                        Movie movie = movieMap.get(recommendation.getMovieId());
                        if (movie != null) {
                %>
                    <div class="top-movie">
                        <div class="top-movie-rank">
                            <%= displayRank++ %>
                        </div>
                        <div class="top-movie-poster">
                            <i class="bi bi-film"></i>
                        </div>
                        <div class="top-movie-info">
                            <h3 class="top-movie-title"><%= movie.getTitle() %></h3>
                            <div class="top-movie-details">
                                <%= movie.getDirector() %> &bull; <%= movie.getReleaseYear() %> &bull; <%= movie.getGenre() %>
                            </div>

                            <div class="top-movie-rating">
                                <div class="rating-stars">
                                    <%
                                        // Display stars based on rating
                                        double rating = movie.getRating();
                                        int fullStars = (int) Math.floor(rating / 2);
                                        boolean halfStar = (rating / 2) - fullStars >= 0.5;

                                        for (int i = 0; i < fullStars; i++) {
                                            out.print("<i class='bi bi-star-fill'></i> ");
                                        }

                                        if (halfStar) {
                                            out.print("<i class='bi bi-star-half'></i> ");
                                        }

                                        int emptyStars = 5 - fullStars - (halfStar ? 1 : 0);
                                        for (int i = 0; i < emptyStars; i++) {
                                            out.print("<i class='bi bi-star'></i> ");
                                        }
                                    %>
                                </div>
                                <span class="rating-value"><%= movie.getRating() %>/10</span>
                            </div>

                            <div class="top-movie-reason">
                                "<%= recommendation.getReason() %>"
                            </div>
                        </div>
                        <div class="top-movie-actions">
                            <a href="<%= request.getContextPath() %>/movie-details?id=<%= movie.getMovieId() %>" class="movie-action-btn">
                                <i class="bi bi-info-circle"></i> Details
                            </a>
                            <a href="<%= request.getContextPath() %>/add-to-watchlist?movieId=<%= movie.getMovieId() %>" class="movie-action-btn">
                                <i class="bi bi-bookmark-plus"></i> Watchlist
                            </a>
                            <% if (movie.isAvailable()) { %>
                                <a href="<%= request.getContextPath() %>/rent-movie?id=<%= movie.getMovieId() %>" class="movie-action-btn">
                                    <i class="bi bi-cart-plus"></i> Rent
                                </a>
                            <% } %>
                        </div>
                    </div>
                <%
                        }
                    }
                %>
            </div>

            <div class="refresh-section">
                <a href="<%= request.getContextPath() %>/generate-recommendations?type=top-rated" class="btn btn-neon-gold">
                    <i class="bi bi-arrow-repeat"></i> Refresh Top Rated
                </a>
            </div>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
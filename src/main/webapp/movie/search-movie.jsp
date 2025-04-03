<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.movie.NewRelease" %>
<%@ page import="com.movierental.model.movie.ClassicMovie" %>
<%@ page import="com.movierental.model.movie.MovieManager" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movies - Movie Rental System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        /* Keep all existing CSS styles */
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

        .form-control {
            background-color: var(--input-bg);
            border: 1px solid var(--input-border);
            color: white;
            border-radius: 8px;
            padding: 10px 15px;
        }

        .form-control:focus {
            background-color: #3a3a3a;
            color: white;
            border-color: var(--neon-blue);
            box-shadow: 0 0 0 0.25rem rgba(0, 200, 255, 0.25);
        }

        .form-select {
            background-color: var(--input-bg);
            border: 1px solid var(--input-border);
            color: white;
            border-radius: 8px;
            padding: 10px 15px;
        }

        .form-select:focus {
            background-color: #3a3a3a;
            color: white;
            border-color: var(--neon-blue);
            box-shadow: 0 0 0 0.25rem rgba(0, 200, 255, 0.25);
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

        .movie-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .movie-card {
            background-color: var(--card-bg);
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
            border: 1px solid #333;
        }

        .movie-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0, 200, 255, 0.2);
        }

        .movie-poster {
            height: 300px;
            background: linear-gradient(135deg, #333, #222);
            position: relative;
            overflow: hidden;
        }

        .movie-poster img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .movie-card:hover .movie-poster img {
            transform: scale(1.05);
        }

        .movie-poster .poster-placeholder {
            display: flex;
            align-items: center;
            justify-content: center;
            color: #555;
            font-size: 3rem;
            height: 100%;
        }

        .movie-info {
            padding: 15px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .movie-title {
            font-weight: 600;
            margin-bottom: 5px;
            font-size: 1.1rem;
            color: var(--text-primary);
        }

        .movie-subtitle {
            font-size: 0.9rem;
            color: var(--text-secondary);
            margin-bottom: 10px;
        }

        .movie-badges {
            margin-bottom: 10px;
            display: flex;
            flex-wrap: wrap;
            gap: 5px;
        }

        .badge-blue {
            background: linear-gradient(to right, #0277bd, #00c8ff);
            color: white;
            padding: 3px 8px;
            border-radius: 5px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .badge-purple {
            background: linear-gradient(to right, #8a2be2, #ff00ff);
            color: white;
            padding: 3px 8px;
            border-radius: 5px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .badge-gold {
            background: linear-gradient(to right, #ffa000, #ffcf40);
            color: #333;
            padding: 3px 8px;
            border-radius: 5px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .rating {
            display: flex;
            align-items: center;
            margin-top: auto;
            padding-top: 10px;
            border-top: 1px solid #333;
        }

        .rating-stars {
            color: #ffd700;
            margin-right: 5px;
        }

        .card-actions {
            display: flex;
            gap: 5px;
            margin-top: 10px;
        }

        .card-action-btn {
            flex: 1;
            text-align: center;
            padding: 8px;
            border-radius: 5px;
            transition: all 0.2s;
            background-color: #333;
            color: var(--text-primary);
            text-decoration: none;
            font-size: 0.85rem;
        }

        .card-action-btn:hover {
            background-color: #444;
            color: var(--neon-blue);
        }

        .card-action-btn i {
            margin-right: 3px;
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

        .availability-indicator {
            position: absolute;
            top: 10px;
            right: 10px;
            width: 15px;
            height: 15px;
            border-radius: 50%;
            z-index: 2;
        }

        .available {
            background-color: #4CAF50;
            box-shadow: 0 0 10px #4CAF50;
        }

        .unavailable {
            background-color: #F44336;
            box-shadow: 0 0 10px #F44336;
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

        // Get search parameters and movie list from request attributes
        String searchQuery = (String) request.getAttribute("searchQuery");
        String searchType = (String) request.getAttribute("searchType");
        List<Movie> movies = (List<Movie>) request.getAttribute("movies");

        if (searchQuery == null) searchQuery = "";
        if (searchType == null) searchType = "title";
        if (movies == null) movies = new ArrayList<Movie>();

        // Create MovieManager to get image URLs
        MovieManager movieManager = new MovieManager(application);
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
                        <a class="nav-link active" href="<%= request.getContextPath() %>/search-movie">
                            <i class="bi bi-film"></i> Movies
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/rental/rental-history.jsp">
                            <i class="bi bi-collection-play"></i> My Rentals
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/watchlist/watchlist.jsp">
                            <i class="bi bi-bookmark-star"></i> Watchlist
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

        <!-- Search Card -->
        <div class="card">
            <div class="card-header">
                <div>
                    <i class="bi bi-search"></i> Search Movies
                </div>
                <a href="<%= request.getContextPath() %>/add-movie" class="btn btn-sm btn-neon">
                    <i class="bi bi-plus-circle"></i> Add Movie
                </a>
            </div>
            <div class="card-body p-4">
                <form action="<%= request.getContextPath() %>/search-movie" method="get">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <input type="text" class="form-control" id="searchQuery" name="searchQuery"
                                   placeholder="Search movies..." value="<%= searchQuery %>">
                        </div>
                        <div class="col-md-4">
                            <select class="form-select" id="searchType" name="searchType">
                                <option value="title" <%= "title".equals(searchType) ? "selected" : "" %>>Title</option>
                                <option value="director" <%= "director".equals(searchType) ? "selected" : "" %>>Director</option>
                                <option value="genre" <%= "genre".equals(searchType) ? "selected" : "" %>>Genre</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-neon w-100">
                                <i class="bi bi-search"></i> Search
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Movies Grid -->
        <% if(movies.isEmpty()) { %>
            <div class="card mt-4">
                <div class="card-body empty-state">
                    <i class="bi bi-film"></i>
                    <p class="empty-message">No movies found</p>
                    <a href="<%= request.getContextPath() %>/add-movie" class="btn btn-neon">
                        <i class="bi bi-plus-circle"></i> Add a Movie
                    </a>
                </div>
            </div>
        <% } else { %>
            <div class="movie-grid">
                <% for(Movie movie : movies) {
                    boolean isNewRelease = movie instanceof NewRelease;
                    boolean isClassic = movie instanceof ClassicMovie;
                    boolean hasAwards = isClassic && ((ClassicMovie)movie).hasAwards();
                    String movieType = isNewRelease ? "New Release" : (isClassic ? "Classic" : "Regular");

                    // Get cover photo URL if available
                    String coverPhotoUrl = movieManager.getCoverPhotoUrl(movie);
                    boolean hasCoverPhoto = coverPhotoUrl != null && !coverPhotoUrl.isEmpty();
                %>
                    <div class="movie-card">
                        <div class="movie-poster">
                            <% if(hasCoverPhoto) { %>
                                <img src="<%= request.getContextPath() %>/image-servlet?movieId=<%= movie.getMovieId() %>" alt="<%= movie.getTitle() %>">
                            <% } else { %>
                                <div class="poster-placeholder">
                                    <i class="bi bi-film"></i>
                                </div>
                            <% } %>
                            <div class="availability-indicator <%= movie.isAvailable() ? "available" : "unavailable" %>"></div>
                        </div>
                        <div class="movie-info">
                            <h3 class="movie-title"><%= movie.getTitle() %></h3>
                            <p class="movie-subtitle">
                                <%= movie.getDirector() %> &bull; <%= movie.getReleaseYear() %>
                            </p>

                            <div class="movie-badges">
                                <span class="badge-blue"><%= movie.getGenre() %></span>
                                <% if(isNewRelease) { %>
                                    <span class="badge-purple">New Release</span>
                                <% } else if(isClassic) { %>
                                    <span class="badge-purple">Classic</span>
                                    <% if(hasAwards) { %>
                                        <span class="badge-gold">Award Winner</span>
                                    <% } %>
                                <% } %>
                            </div>

                            <div class="rating">
                                <div class="rating-stars">
                                    <%
                                        double rating = movie.getRating();
                                        int fullStars = (int) Math.floor(rating / 2);
                                        boolean halfStar = (rating / 2) - fullStars >= 0.5;

                                        for(int i = 0; i < fullStars; i++) {
                                            out.print("<i class='bi bi-star-fill'></i>");
                                        }

                                        if(halfStar) {
                                            out.print("<i class='bi bi-star-half'></i>");
                                        }

                                        int emptyStars = 5 - fullStars - (halfStar ? 1 : 0);
                                        for(int i = 0; i < emptyStars; i++) {
                                            out.print("<i class='bi bi-star'></i>");
                                        }
                                    %>
                                </div>
                                <span><%= movie.getRating() %>/10</span>
                            </div>

                            <div class="card-actions">
                                <a href="<%= request.getContextPath() %>/movie-details?id=<%= movie.getMovieId() %>" class="card-action-btn">
                                    <i class="bi bi-info-circle"></i> Details
                                </a>
                                <a href="<%= request.getContextPath() %>/update-movie?id=<%= movie.getMovieId() %>" class="card-action-btn">
                                    <i class="bi bi-pencil"></i> Edit
                                </a>
                                <a href="<%= request.getContextPath() %>/delete-movie?id=<%= movie.getMovieId() %>" class="card-action-btn">
                                    <i class="bi bi-trash"></i> Delete
                                </a>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
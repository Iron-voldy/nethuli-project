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
    <jsp:include page="../includes/navbar.jsp" />

    <div class="container mt-4">
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
        <div class="page-header text-center mb-4">
            <h1>
                Top Rated Movies
            </h1>
            <p class="text-muted">
                The highest-rated films in our collection, as rated by our community of movie lovers
            </p>
        </div>

        <!-- Recommendation Tabs -->
        <div class="recommendation-tabs mb-4">
            <ul class="nav nav-tabs justify-content-center">
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/view-recommendations?type=personal">
                        <i class="bi bi-person-check"></i> Personalized
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/view-recommendations?type=general">
                        <i class="bi bi-globe"></i> General
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="<%= request.getContextPath() %>/top-rated">
                        <i class="bi bi-star-fill"></i> Top Rated
                    </a>
                </li>
            </ul>
        </div>

        <!-- Genre Navigation -->
        <div class="genre-nav mb-4 p-3 bg-light rounded">
            <div class="d-flex flex-wrap">
                <% for (String genre : allGenres) { %>
                    <a href="<%= request.getContextPath() %>/genre-recommendations?genre=<%= genre %>" class="badge bg-secondary text-decoration-none me-2 mb-2">
                        <%= genre %>
                    </a>
                <% } %>
            </div>
        </div>

        <!-- Top Rated Movies List -->
        <% if (recommendations == null || recommendations.isEmpty()) { %>
            <div class="text-center p-5">
                <i class="bi bi-star display-1 text-muted"></i>
                <p class="text-muted mt-3">No top-rated movies available</p>
                <a href="<%= request.getContextPath() %>/generate-recommendations?type=top-rated" class="btn btn-primary">
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
                    <div class="card mb-3">
                        <div class="row g-0">
                            <div class="col-md-1 d-flex align-items-center justify-content-center bg-light">
                                <h2 class="m-0 text-primary"><%= displayRank++ %></h2>
                            </div>
                            <div class="col-md-2">
                                <div class="bg-dark text-center h-100" style="min-height: 150px;">
                                    <% if (movie.getCoverPhotoPath() != null && !movie.getCoverPhotoPath().isEmpty()) { %>
                                        <img src="<%= request.getContextPath() %>/image-servlet?movieId=<%= movie.getMovieId() %>"
                                             alt="<%= movie.getTitle() %>" class="img-fluid h-100" style="object-fit: cover;">
                                    <% } else { %>
                                        <i class="bi bi-film text-muted" style="font-size: 3rem; margin-top: 50px;"></i>
                                    <% } %>
                                </div>
                            </div>
                            <div class="col-md-7">
                                <div class="card-body">
                                    <h5 class="card-title"><%= movie.getTitle() %></h5>
                                    <p class="card-text text-muted">
                                        <%= movie.getDirector() %> • <%= movie.getReleaseYear() %> • <%= movie.getGenre() %>
                                    </p>

                                    <div class="mb-2">
                                        <%
                                            // Display stars based on rating
                                            double rating = movie.getRating();
                                            int fullStars = (int) Math.floor(rating / 2);
                                            boolean halfStar = (rating / 2) - fullStars >= 0.5;

                                            for (int i = 0; i < fullStars; i++) {
                                                out.print("<i class='bi bi-star-fill text-warning'></i> ");
                                            }

                                            if (halfStar) {
                                                out.print("<i class='bi bi-star-half text-warning'></i> ");
                                            }

                                            int emptyStars = 5 - fullStars - (halfStar ? 1 : 0);
                                            for (int i = 0; i < emptyStars; i++) {
                                                out.print("<i class='bi bi-star text-warning'></i> ");
                                            }
                                        %>
                                        <span class="ms-1"><%= movie.getRating() %>/10</span>
                                    </div>

                                    <p class="card-text bg-light p-2 rounded">
                                        "<%= recommendation.getReason() %>"
                                    </p>
                                </div>
                            </div>
                            <div class="col-md-2 d-flex flex-column justify-content-center p-3 border-start">
                                <a href="<%= request.getContextPath() %>/movie-details?id=<%= movie.getMovieId() %>" class="btn btn-sm btn-outline-primary mb-2">
                                    <i class="bi bi-info-circle"></i> Details
                                </a>
                                <a href="<%= request.getContextPath() %>/add-to-watchlist?movieId=<%= movie.getMovieId() %>" class="btn btn-sm btn-outline-secondary mb-2">
                                    <i class="bi bi-bookmark-plus"></i> Watchlist
                                </a>
                                <% if (movie.isAvailable()) { %>
                                    <a href="<%= request.getContextPath() %>/rent-movie?id=<%= movie.getMovieId() %>" class="btn btn-sm btn-outline-success">
                                        <i class="bi bi-cart-plus"></i> Rent
                                    </a>
                                <% } %>
                            </div>
                        </div>
                    </div>
                <%
                        }
                    }
                %>
            </div>

            <div class="text-center my-4">
                <a href="<%= request.getContextPath() %>/generate-recommendations?type=top-rated" class="btn btn-primary">
                    <i class="bi bi-arrow-repeat"></i> Refresh Top Rated
                </a>
            </div>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
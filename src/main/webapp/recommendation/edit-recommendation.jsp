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
    <jsp:include page="../includes/navbar.jsp" />

    <div class="container mt-4">
        <!-- Error message -->
        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            if(errorMessage != null) {
                out.println("<div class='alert alert-danger'>");
                out.println("<i class='bi bi-exclamation-triangle-fill me-2'></i>");
                out.println(errorMessage);
                out.println("</div>");
            }
        %>

        <!-- Page Header -->
        <div class="page-header mb-4">
            <h1>
                Edit <%= isPersonal ? "Personal" : "General" %> Recommendation
            </h1>
            <p class="text-muted">
                Update <%= isPersonal ? "personalized" : "general" %> recommendation details
            </p>
        </div>

        <!-- Recommendation Meta Information -->
        <div class="card mb-4 bg-light">
            <div class="card-body">
                <div class="row text-center">
                    <div class="col">
                        <div class="text-muted small">Recommendation ID</div>
                        <div class="fw-bold"><%= recommendation.getRecommendationId() %></div>
                    </div>
                    <div class="col">
                        <div class="text-muted small">Generated</div>
                        <div class="fw-bold"><%= dateFormat.format(recommendation.getGeneratedDate()) %></div>
                    </div>
                    <div class="col">
                        <div class="text-muted small">Type</div>
                        <div class="fw-bold"><%= isPersonal ? "Personal" : "General" %></div>
                    </div>
                    <% if (!isPersonal && generalRec != null) { %>
                        <div class="col">
                            <div class="text-muted small">Category</div>
                            <div class="fw-bold"><%= generalRec.getCategory() %></div>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Edit Recommendation Form -->
        <div class="card">
            <div class="card-header">
                <i class="bi bi-<%= isPersonal ? "person-gear" : "gear" %>"></i>
                Edit <%= isPersonal ? "Personal" : "General" %> Recommendation
            </div>
            <div class="card-body">
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
                    <div class="border p-3 rounded mb-3 bg-light">
                        <h5 class="mb-3">
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
                                <div class="form-text small">
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
                                <div class="form-text small">
                                    Ranking position for this recommendation (lower number = higher rank)
                                </div>
                            </div>
                        <% } %>
                    </div>

                    <div class="d-flex justify-content-between">
                        <div>
                            <a href="<%= request.getContextPath() %>/manage-recommendations" class="btn btn-secondary me-2">
                                <i class="bi bi-arrow-left"></i> Cancel
                            </a>
                            <a href="<%= request.getContextPath() %>/manage-recommendations?action=delete&id=<%= recommendation.getRecommendationId() %>"
                               class="btn btn-danger"
                               onclick="return confirm('Are you sure you want to delete this recommendation?')">
                                <i class="bi bi-trash"></i> Delete
                            </a>
                        </div>
                        <button type="submit" class="btn btn-primary">
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
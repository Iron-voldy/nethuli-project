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
        List<User> allUsers = (List<User>) request.getAttribute("allUsers");
        Map<String, User> userMap = new java.util.HashMap<>();

        if (allUsers != null) {
            for (User u : allUsers) {
                userMap.put(u.getUserId(), u);
            }
        }

        // Date formatter
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
    %>

    <!-- Navigation Bar -->
    <jsp:include page="../includes/navbar.jsp" />

    <div class="container mt-4">
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
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Manage Recommendations</h1>
            <div class="dropdown">
                <button class="btn btn-primary dropdown-toggle" type="button" id="addRecommendationDropdown" data-bs-toggle="dropdown" aria-expanded="false">
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
                    <div class="text-center p-5">
                        <i class="bi bi-lightning display-1 text-muted"></i>
                        <p class="text-muted mt-3">No recommendations available</p>
                        <a href="<%= request.getContextPath() %>/manage-recommendations?action=add&type=general" class="btn btn-primary">
                            <i class="bi bi-plus-circle"></i> Add Recommendation
                        </a>
                    </div>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover">
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
                                <tr>
                                    <td><%= count++ %></td>
                                    <td>
                                        <% if (isPersonal) { %>
                                            <span class="badge bg-purple">
                                                <i class="bi bi-person-fill"></i> Personal
                                            </span>
                                        <% } else { %>
                                            <span class="badge bg-info">
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
                                               class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <a href="<%= request.getContextPath() %>/manage-recommendations?action=delete&id=<%= rec.getRecommendationId() %>"
                                               class="btn btn-sm btn-outline-danger"
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

        <!-- Back to Recommendations Link -->
        <div class="mt-3">
            <a href="<%= request.getContextPath() %>/view-recommendations" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left"></i> Back to Recommendations
            </a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
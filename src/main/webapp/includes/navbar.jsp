<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
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
                <%
                    String currentUri = request.getRequestURI();
                    boolean isRecommendationPage = currentUri.contains("/recommendation/") ||
                                                  request.getServletPath().contains("recommendations") ||
                                                  request.getServletPath().contains("top-rated") ||
                                                  request.getServletPath().contains("genre-recommendations");
                %>
               <li class="nav-item dropdown">
                   <a class="nav-link dropdown-toggle <%= isRecommendationPage ? "active" : "" %>" href="#" id="recommendationsDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                       <i class="bi bi-lightning-fill"></i> Recommendations
                   </a>
                   <ul class="dropdown-menu" aria-labelledby="recommendationsDropdown">
                       <li><a class="dropdown-item" href="<%= request.getContextPath() %>/view-recommendations">View Recommendations</a></li>
                       <li><a class="dropdown-item" href="<%= request.getContextPath() %>/top-rated">Top Rated</a></li>
                       <li><hr class="dropdown-divider"></li>
                       <li><a class="dropdown-item" href="<%= request.getContextPath() %>/manage-recommendations">Manage Recommendations</a></li>
                       <li><a class="dropdown-item" href="<%= request.getContextPath() %>/manage-recommendations?action=add&type=general">Add Recommendation</a></li>
                   </ul>
               </li>
            </ul>
            <ul class="navbar-nav ms-auto">
                <%
                    User currentUser = (User) session.getAttribute("user");
                    if (currentUser != null) {
                %>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/user/profile.jsp">
                            <i class="bi bi-person-circle"></i> <%= currentUser.getUsername() %>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/logout">
                            <i class="bi bi-box-arrow-right"></i> Logout
                        </a>
                    </li>
                <% } else { %>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/login">
                            <i class="bi bi-box-arrow-in-right"></i> Login
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/register">
                            <i class="bi bi-person-plus"></i> Register
                        </a>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>
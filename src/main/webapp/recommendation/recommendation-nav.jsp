<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<!-- Recommendation Navigation Include -->
<div class="recommendation-menu mb-4">
    <div class="card">
        <div class="card-header">
            <i class="bi bi-lightning-fill"></i> Recommendation Navigation
        </div>
        <div class="card-body p-3">
            <div class="row">
                <div class="col-md-6">
                    <div class="mb-2"><strong>View Recommendations</strong></div>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link ps-0" href="<%= request.getContextPath() %>/view-recommendations?type=personal">
                                <i class="bi bi-person-check"></i> Personal Recommendations
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ps-0" href="<%= request.getContextPath() %>/view-recommendations?type=general">
                                <i class="bi bi-globe"></i> General Recommendations
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ps-0" href="<%= request.getContextPath() %>/top-rated">
                                <i class="bi bi-star-fill"></i> Top Rated Movies
                            </a>
                        </li>
                    </ul>
                </div>
                <div class="col-md-6">
                    <div class="mb-2"><strong>Actions</strong></div>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link ps-0" href="<%= request.getContextPath() %>/recommendation-action?action=generate-personal">
                                <i class="bi bi-arrow-repeat"></i> Refresh Personal Recommendations
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ps-0" href="<%= request.getContextPath() %>/recommendation-action?action=generate-general">
                                <i class="bi bi-arrow-repeat"></i> Refresh General Recommendations
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ps-0" href="<%= request.getContextPath() %>/manage-recommendations">
                                <i class="bi bi-gear"></i> Manage Recommendations
                            </a>
                        </li>
                    </ul>
                </div>
            </div>

            <%
            // Display genre navigation if available
            List<String> allGenres = (List<String>) request.getAttribute("allGenres");
            if (allGenres != null && !allGenres.isEmpty()) {
            %>
            <div class="mt-3">
                <div class="mb-2"><strong>Genres</strong></div>
                <div class="d-flex flex-wrap">
                    <% for (String genre : allGenres) { %>
                        <a href="<%= request.getContextPath() %>/genre-recommendations?genre=<%= genre %>"
                           class="genre-badge me-2 mb-2">
                            <%= genre %>
                        </a>
                    <% } %>
                </div>
            </div>
            <% } %>
        </div>
    </div>
</div>
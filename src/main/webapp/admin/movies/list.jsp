<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.movie.NewRelease" %>
<%@ page import="com.movierental.model.movie.ClassicMovie" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!-- Include Admin Header -->
<%@ include file="../includes/header.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Manage Movies</h2>
    <a href="<%= request.getContextPath() %>/admin/movies?action=add" class="btn btn-admin">
        <i class="bi bi-plus-circle me-2"></i> Add New Movie
    </a>
</div>

<div class="card">
    <div class="card-header">
        <i class="bi bi-film me-2"></i> Movie Listing
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover datatable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Director</th>
                        <th>Genre</th>
                        <th>Year</th>
                        <th>Type</th>
                        <th>Rating</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    List<Movie> movies = (List<Movie>)request.getAttribute("movies");
                    if(movies != null && !movies.isEmpty()) {
                        for(Movie movie : movies) {
                            String movieType = "Regular";
                            if(movie instanceof NewRelease) {
                                movieType = "New Release";
                            } else if(movie instanceof ClassicMovie) {
                                movieType = "Classic";
                            }
                    %>
                    <tr>
                        <td><%= movie.getMovieId().substring(0, 8) %>...</td>
                        <td><%= movie.getTitle() %></td>
                        <td><%= movie.getDirector() %></td>
                        <td><%= movie.getGenre() %></td>
                        <td><%= movie.getReleaseYear() %></td>
                        <td>
                            <% if(movieType.equals("New Release")) { %>
                                <span class="badge bg-info">New Release</span>
                            <% } else if(movieType.equals("Classic")) { %>
                                <span class="badge bg-warning">Classic</span>
                            <% } else { %>
                                <span class="badge bg-secondary">Regular</span>
                            <% } %>
                        </td>
                        <td><%= movie.getRating() %> / 10</td>
                        <td>
                            <% if(movie.isAvailable()) { %>
                                <span class="badge bg-success">Available</span>
                            <% } else { %>
                                <span class="badge bg-danger">Rented</span>
                            <% } %>
                        </td>
                        <td>
                            <div class="btn-group">
                                <a href="<%= request.getContextPath() %>/admin/movies?action=edit&id=<%= movie.getMovieId() %>" class="btn btn-sm btn-outline-admin">
                                    <i class="bi bi-pencil"></i>
                                </a>
                                <a href="<%= request.getContextPath() %>/admin/movies?action=delete&id=<%= movie.getMovieId() %>"
                                   class="btn btn-sm btn-outline-danger confirm-delete"
                                   onclick="return confirm('Are you sure you want to delete this movie?')">
                                    <i class="bi bi-trash"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="9" class="text-center">No movies found</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Include Admin Footer -->
<%@ include file="../includes/footer.jsp" %>
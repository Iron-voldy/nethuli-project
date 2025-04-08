<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.movierental.model.review.Review" %>
<%@ page import="com.movierental.model.review.VerifiedReview" %>
<%@ page import="com.movierental.model.review.GuestReview" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!-- Include Admin Header -->
<%@ include file="../includes/header.jsp" %>

<%
    List<Review> reviews = (List<Review>)request.getAttribute("reviews");
    Map<String, Movie> movieMap = (Map<String, Movie>)request.getAttribute("movieMap");
    Map<String, User> userMap = (Map<String, User>)request.getAttribute("userMap");
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Manage Reviews</h2>
</div>

<div class="card">
    <div class="card-header">
        <i class="bi bi-star me-2"></i> Review Listing
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover datatable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Date</th>
                        <th>Movie</th>
                        <th>User</th>
                        <th>Rating</th>
                        <th>Comment</th>
                        <th>Type</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    if(reviews != null && !reviews.isEmpty()) {
                        for(Review review : reviews) {
                            Movie movie = movieMap.get(review.getMovieId());
                            User user = (review.getUserId() != null) ? userMap.get(review.getUserId()) : null;

                            String movieTitle = (movie != null) ? movie.getTitle() : "Unknown Movie";
                            String userName = review.getUserName();

                            boolean isVerified = review.isVerified();
                            boolean isGuest = (review instanceof GuestReview);
                    %>
                    <tr>
                        <td><%= review.getReviewId().substring(0, 8) %>...</td>
                        <td><%= dateFormat.format(review.getReviewDate()) %></td>
                        <td><%= movieTitle %></td>
                        <td>
                            <% if(isGuest) { %>
                                <span class="text-secondary"><%= userName %> <small>(Guest)</small></span>
                            <% } else if(user != null) { %>
                                <%= user.getUsername() %>
                            <% } else { %>
                                <%= userName %>
                            <% } %>
                        </td>
                        <td>
                            <div class="rating-stars">
                                <% for(int i = 1; i <= 5; i++) { %>
                                    <% if(i <= review.getRating()) { %>
                                        <i class="bi bi-star-fill text-warning"></i>
                                    <% } else { %>
                                        <i class="bi bi-star text-secondary"></i>
                                    <% } %>
                                <% } %>
                            </div>
                        </td>
                        <td>
                            <%
                                String comment = review.getComment();
                                if(comment.length() > 50) {
                                    comment = comment.substring(0, 47) + "...";
                                }
                            %>
                            <%= comment %>
                        </td>
                        <td>
                            <% if(isVerified) { %>
                                <span class="badge bg-success">Verified</span>
                            <% } else if(isGuest) { %>
                                <span class="badge bg-secondary">Guest</span>
                            <% } else { %>
                                <span class="badge bg-primary">Regular</span>
                            <% } %>
                        </td>
                        <td>
                            <div class="btn-group">
                                <a href="<%= request.getContextPath() %>/admin/reviews?action=moderate&id=<%= review.getReviewId() %>" class="btn btn-sm btn-outline-admin">
                                    <i class="bi bi-pencil"></i>
                                </a>
                                <a href="<%= request.getContextPath() %>/admin/reviews?action=delete&id=<%= review.getReviewId() %>"
                                   class="btn btn-sm btn-outline-danger confirm-delete"
                                   onclick="return confirm('Are you sure you want to delete this review?')">
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
                        <td colspan="8" class="text-center">No reviews found</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Include Admin Footer -->
<%@ include file="../includes/footer.jsp" %>
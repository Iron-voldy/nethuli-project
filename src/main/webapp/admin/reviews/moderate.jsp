<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.review.Review" %>
<%@ page import="com.movierental.model.review.VerifiedReview" %>
<%@ page import="com.movierental.model.review.GuestReview" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!-- Include Admin Header -->
<%@ include file="../includes/header.jsp" %>

<%
    Review review = (Review) request.getAttribute("review");
    Movie movie = (Movie) request.getAttribute("movie");
    User user = (User) request.getAttribute("user");

    SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");

    boolean isVerified = review.isVerified();
    boolean isGuest = (review instanceof GuestReview);

    // Get guest-specific information if applicable
    String emailAddress = "";
    String ipAddress = "";
    if(isGuest) {
        GuestReview guestReview = (GuestReview) review;
        emailAddress = guestReview.getEmailAddress();
        ipAddress = guestReview.getIpAddress();
    }

    // Get verified-specific information if applicable
    String transactionId = "";
    Date watchDate = null;
    if(isVerified) {
        VerifiedReview verifiedReview = (VerifiedReview) review;
        transactionId = verifiedReview.getTransactionId();
        watchDate = verifiedReview.getWatchDate();
    }
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Moderate Review</h2>
    <a href="<%= request.getContextPath() %>/admin/reviews" class="btn btn-outline-admin">
        <i class="bi bi-arrow-left me-2"></i> Back to Reviews
    </a>
</div>

<div class="row">
    <div class="col-md-8">
        <!-- Review Details and Edit Form -->
        <div class="card mb-4">
            <div class="card-header">
                <i class="bi bi-pencil-square me-2"></i> Edit Review Content
            </div>
            <div class="card-body">
                <form action="<%= request.getContextPath() %>/admin/reviews" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="reviewId" value="<%= review.getReviewId() %>">
                    <input type="hidden" name="movieId" value="<%= review.getMovieId() %>">

                    <div class="mb-3">
                        <label for="rating" class="form-label">Rating</label>
                        <select class="form-select" id="rating" name="rating" required>
                            <option value="1" <%= review.getRating() == 1 ? "selected" : "" %>>1 - Poor</option>
                            <option value="2" <%= review.getRating() == 2 ? "selected" : "" %>>2 - Fair</option>
                            <option value="3" <%= review.getRating() == 3 ? "selected" : "" %>>3 - Good</option>
                            <option value="4" <%= review.getRating() == 4 ? "selected" : "" %>>4 - Very Good</option>
                            <option value="5" <%= review.getRating() == 5 ? "selected" : "" %>>5 - Excellent</option>
                        </select>
                        <div class="rating-stars mt-2">
                            <% for(int i = 1; i <= 5; i++) { %>
                                <i class="bi bi-star<%= (i <= review.getRating()) ? "-fill" : "" %> <%= (i <= review.getRating()) ? "text-warning" : "text-secondary" %>"></i>
                            <% } %>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="comment" class="form-label">Review Comment</label>
                        <textarea class="form-control" id="comment" name="comment" rows="5" required><%= review.getComment() %></textarea>
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <a href="<%= request.getContextPath() %>/admin/reviews?action=delete&id=<%= review.getReviewId() %>"
                           class="btn btn-danger"
                           onclick="return confirm('Are you sure you want to delete this review? This action cannot be undone.')">
                            <i class="bi bi-trash me-2"></i> Delete Review
                        </a>
                        <button type="submit" class="btn btn-admin">
                            <i class="bi bi-save me-2"></i> Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Review Information -->
        <div class="card">
            <div class="card-header">
                <i class="bi bi-info-circle me-2"></i> Review Information
            </div>
            <div class="card-body">
                <div class="row mb-3">
                    <div class="col-md-4 text-secondary">Review ID:</div>
                    <div class="col-md-8"><%= review.getReviewId() %></div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-4 text-secondary">Review Date:</div>
                    <div class="col-md-8"><%= dateFormat.format(review.getReviewDate()) %></div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-4 text-secondary">Review Type:</div>
                    <div class="col-md-8">
                        <% if(isVerified) { %>
                            <span class="badge bg-success">Verified Purchase</span>
                        <% } else if(isGuest) { %>
                            <span class="badge bg-secondary">Guest Review</span>
                        <% } else { %>
                            <span class="badge bg-primary">User Review</span>
                        <% } %>
                    </div>
                </div>

                <% if(isVerified && transactionId != null && !transactionId.isEmpty()) { %>
                <div class="row mb-3">
                    <div class="col-md-4 text-secondary">Transaction ID:</div>
                    <div class="col-md-8">
                        <%= transactionId %>
                        <a href="<%= request.getContextPath() %>/admin/rentals?action=view&id=<%= transactionId %>" class="btn btn-sm btn-outline-admin ms-2">
                            <i class="bi bi-eye"></i> View
                        </a>
                    </div>
                </div>

                <% if(watchDate != null) { %>
                <div class="row mb-3">
                    <div class="col-md-4 text-secondary">Watch Date:</div>
                    <div class="col-md-8"><%= dateFormat.format(watchDate) %></div>
                </div>
                <% } %>
                <% } %>

                <% if(isGuest) { %>
                <div class="row mb-3">
                    <div class="col-md-4 text-secondary">Guest Name:</div>
                    <div class="col-md-8"><%= review.getUserName() %></div>
                </div>

                <% if(emailAddress != null && !emailAddress.isEmpty()) { %>
                <div class="row mb-3">
                    <div class="col-md-4 text-secondary">Email:</div>
                    <div class="col-md-8"><%= emailAddress %></div>
                </div>
                <% } %>

                <% if(ipAddress != null && !ipAddress.isEmpty()) { %>
                <div class="row mb-3">
                    <div class="col-md-4 text-secondary">IP Address:</div>
                    <div class="col-md-8"><%= ipAddress %></div>
                </div>
                <% } %>
                <% } %>
            </div>
        </div>
    </div>

    <div class="col-md-4">
        <!-- User Information if available -->
        <% if(user != null) { %>
        <div class="card mb-4">
            <div class="card-header">
                <i class="bi bi-person me-2"></i> User Information
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <div class="fw-bold mb-1"><%= user.getFullName() %></div>
                    <div><i class="bi bi-person-badge me-2"></i> <%= user.getUsername() %></div>
                    <div><i class="bi bi-envelope me-2"></i> <%= user.getEmail() %></div>
                </div>
                <a href="<%= request.getContextPath() %>/admin/users?action=edit&id=<%= user.getUserId() %>" class="btn btn-sm btn-outline-admin">
                    <i class="bi bi-pencil me-1"></i> Edit User
                </a>
            </div>
        </div>
        <% } %>

        <!-- Movie Information -->
        <div class="card">
            <div class="card-header">
                <i class="bi bi-film me-2"></i> Movie Information
            </div>
            <div class="card-body">
                <% if(movie != null) { %>
                <div class="mb-3 text-center">
                    <% if(movie.getCoverPhotoPath() != null && !movie.getCoverPhotoPath().isEmpty()) { %>
                    <img src="<%= request.getContextPath() %>/image-servlet?movieId=<%= movie.getMovieId() %>"
                         alt="<%= movie.getTitle() %>"
                         class="mb-3"
                         style="max-width: 100%; max-height: 200px; object-fit: contain;">
                    <% } %>

                    <h5 class="mb-1"><%= movie.getTitle() %> (<%= movie.getReleaseYear() %>)</h5>
                    <div class="text-secondary mb-1"><%= movie.getDirector() %></div>
                    <div class="badge bg-secondary mb-2"><%= movie.getGenre() %></div>
                    <div>
                        <span class="badge bg-warning text-dark">
                            <i class="bi bi-star-fill me-1"></i> <%= movie.getRating() %>/10
                        </span>
                    </div>
                </div>
                <a href="<%= request.getContextPath() %>/admin/movies?action=edit&id=<%= movie.getMovieId() %>" class="btn btn-sm btn-outline-admin d-block">
                    <i class="bi bi-pencil me-1"></i> Edit Movie
                </a>
                <% } else { %>
                <div class="text-secondary">Movie information not available</div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<script>
    // Update stars when rating changes
    document.getElementById('rating').addEventListener('change', function() {
        const rating = this.value;
        const stars = document.querySelectorAll('.rating-stars i');

        stars.forEach((star, index) => {
            if (index < rating) {
                star.classList.remove('bi-star');
                star.classList.add('bi-star-fill');
                star.classList.add('text-warning');
                star.classList.remove('text-secondary');
            } else {
                star.classList.add('bi-star');
                star.classList.remove('bi-star-fill');
                star.classList.remove('text-warning');
                star.classList.add('text-secondary');
            }
        });
    });
</script>

<!-- Include Admin Footer -->
<%@ include file="../includes/footer.jsp" %>
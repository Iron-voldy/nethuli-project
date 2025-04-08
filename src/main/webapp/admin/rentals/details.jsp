<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.rental.Transaction" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!-- Include Admin Header -->
<%@ include file="../includes/header.jsp" %>

<%
    Transaction transaction = (Transaction) request.getAttribute("transaction");
    User user = (User) request.getAttribute("user");
    Movie movie = (Movie) request.getAttribute("movie");

    SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");
    SimpleDateFormat fullDateFormat = new SimpleDateFormat("MMMM dd, yyyy 'at' hh:mm a");

    String statusClass = "";
    String statusText = "";

    if(transaction.isReturned()) {
        statusClass = "bg-success";
        statusText = "Returned";
    } else if(transaction.isCanceled()) {
        statusClass = "bg-secondary";
        statusText = "Canceled";
    } else if(transaction.isOverdue()) {
        statusClass = "bg-danger";
        statusText = "Overdue";
    } else {
        statusClass = "bg-primary";
        statusText = "Active";
    }
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Rental Details</h2>
    <a href="<%= request.getContextPath() %>/admin/rentals" class="btn btn-outline-admin">
        <i class="bi bi-arrow-left me-2"></i> Back to Rentals
    </a>
</div>

<div class="row">
    <!-- Transaction Details -->
    <div class="col-md-8">
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <div>
                    <i class="bi bi-info-circle me-2"></i> Transaction Information
                </div>
                <span class="badge <%= statusClass %>"><%= statusText %></span>
            </div>
            <div class="card-body">
                <div class="row mb-3">
                    <div class="col-md-4 text-secondary">Transaction ID:</div>
                    <div class="col-md-8 fw-bold"><%= transaction.getTransactionId() %></div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-4 text-secondary">Rental Date:</div>
                    <div class="col-md-8"><%= fullDateFormat.format(transaction.getRentalDate()) %></div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-4 text-secondary">Due Date:</div>
                    <div class="col-md-8 <%= transaction.isOverdue() ? "text-danger fw-bold" : "" %>">
                        <%= dateFormat.format(transaction.getDueDate()) %>
                        <% if(transaction.isOverdue()) { %>
                            <span class="badge bg-danger ms-2">Overdue by <%= transaction.calculateDaysOverdue() %> days</span>
                        <% } else if(!transaction.isReturned() && !transaction.isCanceled()) { %>
                            <span class="badge bg-info ms-2"><%= transaction.calculateDaysRemaining() %> days remaining</span>
                        <% } %>
                    </div>
                </div>

                <% if(transaction.isReturned() && transaction.getReturnDate() != null) { %>
                <div class="row mb-3">
                    <div class="col-md-4 text-secondary">Return Date:</div>
                    <div class="col-md-8 text-success">
                        <%= fullDateFormat.format(transaction.getReturnDate()) %>
                    </div>
                </div>
                <% } %>

                <% if(transaction.isCanceled()) { %>
                <div class="row mb-3">
                    <div class="col-md-4 text-secondary">Cancellation Date:</div>
                    <div class="col-md-8">
                        <%= transaction.getCancellationDate() != null ? fullDateFormat.format(transaction.getCancellationDate()) : "N/A" %>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-4 text-secondary">Cancellation Reason:</div>
                    <div class="col-md-8">
                        <%= transaction.getCancellationReason() != null ? transaction.getCancellationReason() : "No reason provided" %>
                    </div>
                </div>
                <% } %>

                <div class="row mb-3">
                    <div class="col-md-4 text-secondary">Rental Duration:</div>
                    <div class="col-md-8"><%= transaction.getRentalDuration() %> days</div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-4 text-secondary">Rental Fee:</div>
                    <div class="col-md-8">$<%= String.format("%.2f", transaction.getRentalFee()) %></div>
                </div>

                <% if(transaction.getLateFee() > 0) { %>
                <div class="row mb-3">
                    <div class="col-md-4 text-secondary">Late Fee:</div>
                    <div class="col-md-8 text-danger">$<%= String.format("%.2f", transaction.getLateFee()) %></div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-4 text-secondary">Total:</div>
                    <div class="col-md-8 fw-bold">$<%= String.format("%.2f", transaction.getRentalFee() + transaction.getLateFee()) %></div>
                </div>
                <% } %>

                <% if(!transaction.isReturned() && !transaction.isCanceled()) { %>
                <div class="d-flex justify-content-end mt-4">
                    <a href="<%= request.getContextPath() %>/admin/rentals?action=return&id=<%= transaction.getTransactionId() %>"
                       class="btn btn-success me-2"
                       onclick="return confirm('Are you sure you want to mark this rental as returned?')">
                        <i class="bi bi-check-circle me-2"></i> Mark as Returned
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/rentals?action=cancel&id=<%= transaction.getTransactionId() %>"
                       class="btn btn-secondary"
                       onclick="return confirm('Are you sure you want to cancel this rental?')">
                        <i class="bi bi-x-circle me-2"></i> Cancel Rental
                    </a>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- User and Movie Info -->
    <div class="col-md-4">
        <!-- User Info -->
        <div class="card mb-4">
            <div class="card-header">
                <i class="bi bi-person me-2"></i> User Information
            </div>
            <div class="card-body">
                <% if(user != null) { %>
                <div class="mb-3">
                    <div class="fw-bold mb-1"><%= user.getFullName() %></div>
                    <div><i class="bi bi-person-badge me-2"></i> <%= user.getUsername() %></div>
                    <div><i class="bi bi-envelope me-2"></i> <%= user.getEmail() %></div>
                </div>
                <a href="<%= request.getContextPath() %>/admin/users?action=edit&id=<%= user.getUserId() %>" class="btn btn-sm btn-outline-admin">
                    <i class="bi bi-pencil me-1"></i> Edit User
                </a>
                <% } else { %>
                <div class="text-secondary">User information not available</div>
                <% } %>
            </div>
        </div>

        <!-- Movie Info -->
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

<!-- Include Admin Footer -->
<%@ include file="../includes/footer.jsp" %>
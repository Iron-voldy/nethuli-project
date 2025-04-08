<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.movierental.model.rental.Transaction" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!-- Include Admin Header -->
<%@ include file="includes/header.jsp" %>

<h2 class="mb-4">Admin Dashboard</h2>

<!-- Statistics Cards -->
<div class="row mb-4">
    <div class="col-md-3 mb-3">
        <div class="card stat-card">
            <div class="stat-icon">
                <i class="bi bi-film"></i>
            </div>
            <div class="stat-number"><%= request.getAttribute("totalMovies") %></div>
            <div class="stat-label">Total Movies</div>
            <div class="text-secondary mt-2">
                <span class="text-success"><i class="bi bi-check-circle-fill"></i> <%= request.getAttribute("availableMovies") %> Available</span>
            </div>
        </div>
    </div>

    <div class="col-md-3 mb-3">
        <div class="card stat-card">
            <div class="stat-icon">
                <i class="bi bi-people"></i>
            </div>
            <div class="stat-number"><%= request.getAttribute("totalUsers") %></div>
            <div class="stat-label">Registered Users</div>
            <div class="text-secondary mt-2">
                <span><i class="bi bi-person-circle"></i> Active Accounts</span>
            </div>
        </div>
    </div>

    <div class="col-md-3 mb-3">
        <div class="card stat-card">
            <div class="stat-icon">
                <i class="bi bi-collection-play"></i>
            </div>
            <div class="stat-number"><%= request.getAttribute("totalRentals") %></div>
            <div class="stat-label">Total Rentals</div>
            <div class="text-secondary mt-2">
                <span class="text-primary"><i class="bi bi-arrow-right-circle-fill"></i> <%= request.getAttribute("activeRentals") %> Active</span>
            </div>
        </div>
    </div>

    <div class="col-md-3 mb-3">
        <div class="card stat-card">
            <div class="stat-icon">
                <i class="bi bi-star"></i>
            </div>
            <div class="stat-number"><%= request.getAttribute("totalReviews") %></div>
            <div class="stat-label">Total Reviews</div>
            <div class="text-secondary mt-2">
                <span><i class="bi bi-chat-quote-fill"></i> User Feedback</span>
            </div>
        </div>
    </div>
</div>

<!-- Recent Activity Card -->
<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <i class="bi bi-activity me-2"></i> Recent Rental Transactions
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover datatable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Date</th>
                                <th>User</th>
                                <th>Movie</th>
                                <th>Due Date</th>
                                <th>Status</th>
                                <th>Fee</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            List<Transaction> recentTransactions = (List<Transaction>)request.getAttribute("recentTransactions");
                            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

                            if(recentTransactions != null && !recentTransactions.isEmpty()) {
                                for(Transaction transaction : recentTransactions) {
                            %>
                            <tr>
                                <td><%= transaction.getTransactionId().substring(0, 8) %>...</td>
                                <td><%= dateFormat.format(transaction.getRentalDate()) %></td>
                                <td><%= transaction.getUserId().substring(0, 8) %>...</td>
                                <td><%= transaction.getMovieId().substring(0, 8) %>...</td>
                                <td><%= dateFormat.format(transaction.getDueDate()) %></td>
                                <td>
                                    <% if(transaction.isReturned()) { %>
                                        <span class="badge bg-success">Returned</span>
                                    <% } else if(transaction.isCanceled()) { %>
                                        <span class="badge bg-secondary">Canceled</span>
                                    <% } else if(transaction.isOverdue()) { %>
                                        <span class="badge bg-danger">Overdue</span>
                                    <% } else { %>
                                        <span class="badge bg-primary">Active</span>
                                    <% } %>
                                </td>
                                <td>
                                    $<%= String.format("%.2f", transaction.getRentalFee()) %>
                                    <% if(transaction.getLateFee() > 0) { %>
                                        <span class="text-danger">+ $<%= String.format("%.2f", transaction.getLateFee()) %></span>
                                    <% } %>
                                </td>
                                <td>
                                    <a href="<%= request.getContextPath() %>/admin/rentals?action=view&id=<%= transaction.getTransactionId() %>" class="btn btn-sm btn-outline-admin">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                </td>
                            </tr>
                            <%
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="8" class="text-center">No rental transactions found</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Quick Action Buttons -->
<div class="row mt-4">
    <div class="col-md-12">
        <div class="d-flex justify-content-center gap-3">
            <a href="<%= request.getContextPath() %>/admin/movies?action=add" class="btn btn-admin px-4 py-2">
                <i class="bi bi-plus-circle me-2"></i> Add New Movie
            </a>
            <a href="<%= request.getContextPath() %>/admin/users" class="btn btn-outline-admin px-4 py-2">
                <i class="bi bi-people me-2"></i> Manage Users
            </a>
            <a href="<%= request.getContextPath() %>/admin/rentals" class="btn btn-outline-admin px-4 py-2">
                <i class="bi bi-collection-play me-2"></i> Manage Rentals
            </a>
            <a href="<%= request.getContextPath() %>/admin/reviews" class="btn btn-outline-admin px-4 py-2">
                <i class="bi bi-star me-2"></i> Moderate Reviews
            </a>
        </div>
    </div>
</div>

<!-- Include Admin Footer -->
<%@ include file="includes/footer.jsp" %>
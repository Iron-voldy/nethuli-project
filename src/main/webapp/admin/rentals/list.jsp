<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.movierental.model.rental.Transaction" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!-- Include Admin Header -->
<%@ include file="../includes/header.jsp" %>

<%
    List<Transaction> transactions = (List<Transaction>)request.getAttribute("transactions");
    Map<String, User> userMap = (Map<String, User>)request.getAttribute("userMap");
    Map<String, Movie> movieMap = (Map<String, Movie>)request.getAttribute("movieMap");
    String filter = (String)request.getAttribute("filter");
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Manage Rentals</h2>
</div>

<!-- Filter Tabs -->
<div class="card mb-3">
    <div class="card-body p-0">
        <ul class="nav nav-pills nav-fill">
            <li class="nav-item">
                <a class="nav-link <%= "all".equals(filter) ? "active" : "" %>"
                   href="<%= request.getContextPath() %>/admin/rentals?filter=all">
                    <i class="bi bi-grid-3x3-gap me-1"></i> All Rentals
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= "active".equals(filter) ? "active" : "" %>"
                   href="<%= request.getContextPath() %>/admin/rentals?filter=active">
                    <i class="bi bi-play-circle me-1"></i> Active
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= "returned".equals(filter) ? "active" : "" %>"
                   href="<%= request.getContextPath() %>/admin/rentals?filter=returned">
                    <i class="bi bi-check-circle me-1"></i> Returned
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= "canceled".equals(filter) ? "active" : "" %>"
                   href="<%= request.getContextPath() %>/admin/rentals?filter=canceled">
                    <i class="bi bi-x-circle me-1"></i> Canceled
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= "overdue".equals(filter) ? "active" : "" %>"
                   href="<%= request.getContextPath() %>/admin/rentals?filter=overdue">
                    <i class="bi bi-exclamation-circle me-1"></i> Overdue
                </a>
            </li>
        </ul>
    </div>
</div>

<div class="card">
    <div class="card-header">
        <i class="bi bi-collection-play me-2"></i> Rental Transactions
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover datatable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>User</th>
                        <th>Movie</th>
                        <th>Rental Date</th>
                        <th>Due Date</th>
                        <th>Status</th>
                        <th>Fee</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    if(transactions != null && !transactions.isEmpty()) {
                        for(Transaction transaction : transactions) {
                            // Get user and movie info
                            User user = userMap.get(transaction.getUserId());
                            Movie movie = movieMap.get(transaction.getMovieId());

                            String userName = (user != null) ? user.getUsername() : "Unknown User";
                            String movieTitle = (movie != null) ? movie.getTitle() : "Unknown Movie";
                    %>
                    <tr>
                        <td><%= transaction.getTransactionId().substring(0, 8) %>...</td>
                        <td><%= userName %></td>
                        <td><%= movieTitle %></td>
                        <td><%= dateFormat.format(transaction.getRentalDate()) %></td>
                        <td><%= dateFormat.format(transaction.getDueDate()) %></td>
                        <td>
                            <% if(transaction.isReturned()) { %>
                                <span class="badge bg-success">Returned</span>
                                <% if(transaction.getReturnDate() != null) { %>
                                    <small class="d-block text-muted"><%= dateFormat.format(transaction.getReturnDate()) %></small>
                                <% } %>
                            <% } else if(transaction.isCanceled()) { %>
                                <span class="badge bg-secondary">Canceled</span>
                                <% if(transaction.getCancellationDate() != null) { %>
                                    <small class="d-block text-muted"><%= dateFormat.format(transaction.getCancellationDate()) %></small>
                                <% } %>
                            <% } else if(transaction.isOverdue()) { %>
                                <span class="badge bg-danger">Overdue</span>
                                <small class="d-block text-danger"><%= transaction.calculateDaysOverdue() %> days</small>
                            <% } else { %>
                                <span class="badge bg-primary">Active</span>
                                <small class="d-block text-muted"><%= transaction.calculateDaysRemaining() %> days left</small>
                            <% } %>
                        </td>
                        <td>
                            $<%= String.format("%.2f", transaction.getRentalFee()) %>
                            <% if(transaction.getLateFee() > 0) { %>
                                <small class="d-block text-danger">+ $<%= String.format("%.2f", transaction.getLateFee()) %> late fee</small>
                            <% } %>
                        </td>
                        <td>
                            <div class="btn-group">
                                <a href="<%= request.getContextPath() %>/admin/rentals?action=view&id=<%= transaction.getTransactionId() %>" class="btn btn-sm btn-outline-admin">
                                    <i class="bi bi-eye"></i>
                                </a>
                                <% if(!transaction.isReturned() && !transaction.isCanceled()) { %>
                                    <a href="<%= request.getContextPath() %>/admin/rentals?action=return&id=<%= transaction.getTransactionId() %>"
                                       class="btn btn-sm btn-outline-success"
                                       onclick="return confirm('Are you sure you want to mark this rental as returned?')">
                                        <i class="bi bi-check"></i>
                                    </a>
                                    <a href="<%= request.getContextPath() %>/admin/rentals?action=cancel&id=<%= transaction.getTransactionId() %>"
                                       class="btn btn-sm btn-outline-secondary"
                                       onclick="return confirm('Are you sure you want to cancel this rental?')">
                                        <i class="bi bi-x"></i>
                                    </a>
                                <% } %>
                                <a href="<%= request.getContextPath() %>/admin/rentals?action=delete&id=<%= transaction.getTransactionId() %>"
                                   class="btn btn-sm btn-outline-danger confirm-delete"
                                   onclick="return confirm('Are you sure you want to delete this rental record? This action cannot be undone.')">
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
                        <td colspan="8" class="text-center">No rental transactions found</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Include Admin Footer -->
<%@ include file="../includes/footer.jsp" %>
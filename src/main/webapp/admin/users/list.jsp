<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.user.PremiumUser" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!-- Include Admin Header -->
<%@ include file="../includes/header.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Manage Users</h2>
</div>

<div class="card">
    <div class="card-header">
        <i class="bi bi-people me-2"></i> User Listing
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover datatable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Account Type</th>
                        <th>Premium Expiry</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    List<User> users = (List<User>)request.getAttribute("users");
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

                    if(users != null && !users.isEmpty()) {
                        for(User user : users) {
                            boolean isPremium = user instanceof PremiumUser;
                    %>
                    <tr>
                        <td><%= user.getUserId().substring(0, 8) %>...</td>
                        <td><%= user.getUsername() %></td>
                        <td><%= user.getFullName() %></td>
                        <td><%= user.getEmail() %></td>
                        <td>
                            <% if(isPremium) { %>
                                <span class="badge badge-admin">Premium</span>
                            <% } else { %>
                                <span class="badge bg-secondary">Regular</span>
                            <% } %>
                        </td>
                        <td>
                            <% if(isPremium) {
                                PremiumUser premiumUser = (PremiumUser) user;
                                String expiryDate = dateFormat.format(premiumUser.getSubscriptionExpiryDate());
                                boolean isActive = premiumUser.isSubscriptionActive();
                            %>
                                <span class="<%= isActive ? "text-success" : "text-danger" %>">
                                    <%= expiryDate %>
                                    <% if(!isActive) { %>
                                        <i class="bi bi-exclamation-circle ms-1" title="Expired"></i>
                                    <% } %>
                                </span>
                            <% } else { %>
                                <span class="text-secondary">N/A</span>
                            <% } %>
                        </td>
                        <td>
                            <div class="btn-group">
                                <a href="<%= request.getContextPath() %>/admin/users?action=edit&id=<%= user.getUserId() %>" class="btn btn-sm btn-outline-admin">
                                    <i class="bi bi-pencil"></i>
                                </a>
                                <a href="<%= request.getContextPath() %>/admin/users?action=delete&id=<%= user.getUserId() %>"
                                   class="btn btn-sm btn-outline-danger confirm-delete"
                                   onclick="return confirm('Are you sure you want to delete this user? This will also delete all their rentals, reviews, and watchlists.')">
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
                        <td colspan="7" class="text-center">No users found</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Include Admin Footer -->
<%@ include file="../includes/footer.jsp" %>
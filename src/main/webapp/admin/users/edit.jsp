<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.user.PremiumUser" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!-- Include Admin Header -->
<%@ include file="../includes/header.jsp" %>

<%
    User userToEdit = (User) request.getAttribute("user");
    boolean isPremium = (Boolean) request.getAttribute("isPremium");

    // Get premium expiry date if applicable
    String premiumExpiry = "";
    if (isPremium) {
        PremiumUser premiumUser = (PremiumUser) userToEdit;
        premiumExpiry = new SimpleDateFormat("yyyy-MM-dd").format(premiumUser.getSubscriptionExpiryDate());
    }
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Edit User</h2>
    <a href="<%= request.getContextPath() %>/admin/users" class="btn btn-outline-admin">
        <i class="bi bi-arrow-left me-2"></i> Back to Users
    </a>
</div>

<div class="card">
    <div class="card-header">
        <i class="bi bi-person me-2"></i> Edit User Information
    </div>
    <div class="card-body">
        <form action="<%= request.getContextPath() %>/admin/users" method="post">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="userId" value="<%= userToEdit.getUserId() %>">

            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" class="form-control" id="username" name="username" value="<%= userToEdit.getUsername() %>" required>
                </div>
                <div class="col-md-6">
                    <label for="fullName" class="form-label">Full Name</label>
                    <input type="text" class="form-control" id="fullName" name="fullName" value="<%= userToEdit.getFullName() %>" required>
                </div>
            </div>

            <div class="mb-3">
                <label for="email" class="form-label">Email Address</label>
                <input type="email" class="form-control" id="email" name="email" value="<%= userToEdit.getEmail() %>" required>
            </div>

            <div class="mb-3">
                <label for="newPassword" class="form-label">New Password</label>
                <input type="password" class="form-control" id="newPassword" name="newPassword">
                <div class="form-text">Leave blank to keep the current password.</div>
            </div>

            <div class="mb-3">
                <label for="accountType" class="form-label">Account Type</label>
                <select class="form-select" id="accountType" name="accountType" onchange="togglePremiumFields()">
                    <option value="regular" <%= !isPremium ? "selected" : "" %>>Regular</option>
                    <option value="premium" <%= isPremium ? "selected" : "" %>>Premium</option>
                </select>
            </div>

            <div class="mb-3" id="premiumFields" style="display: <%= isPremium ? "block" : "none" %>;">
                <label for="premiumExpiry" class="form-label">Premium Subscription Expiry</label>
                <input type="date" class="form-control" id="premiumExpiry" name="premiumExpiry" value="<%= premiumExpiry %>">
                <div class="form-text">The date when the premium subscription expires.</div>
            </div>

            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                <a href="<%= request.getContextPath() %>/admin/users" class="btn btn-secondary me-md-2">
                    <i class="bi bi-x-circle me-2"></i> Cancel
                </a>
                <button type="submit" class="btn btn-admin">
                    <i class="bi bi-save me-2"></i> Save Changes
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    // Function to toggle premium-specific fields
    function togglePremiumFields() {
        const accountType = document.getElementById('accountType').value;
        const premiumFields = document.getElementById('premiumFields');

        if (accountType === 'premium') {
            premiumFields.style.display = 'block';
        } else {
            premiumFields.style.display = 'none';
        }
    }
</script>

<!-- Include Admin Footer -->
<%@ include file="../includes/footer.jsp" %>
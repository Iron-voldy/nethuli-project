<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.admin.Admin" %>

<!-- Include Admin Header -->
<%@ include file="../includes/header.jsp" %>

<%
    // Check if current admin is a super admin
    if (!admin.isSuperAdmin()) {
        session.setAttribute("errorMessage", "Access denied. Super admin privileges required.");
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        return;
    }

    Admin editAdmin = (Admin) request.getAttribute("editAdmin");
    boolean isSelf = editAdmin.getAdminId().equals(admin.getAdminId());
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Edit Administrator</h2>
    <a href="<%= request.getContextPath() %>/admin/manage-admins" class="btn btn-outline-admin">
        <i class="bi bi-arrow-left me-2"></i> Back to Admins
    </a>
</div>

<div class="card">
    <div class="card-header">
        <i class="bi bi-person-badge me-2"></i> Edit Administrator Information
        <% if(isSelf) { %>
            <span class="badge bg-info ms-2">Your Account</span>
        <% } %>
    </div>
    <div class="card-body">
        <form action="<%= request.getContextPath() %>/admin/manage-admins" method="post">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="adminId" value="<%= editAdmin.getAdminId() %>">

            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" class="form-control" id="username" name="username" value="<%= editAdmin.getUsername() %>" required>
                    <div class="form-text">Username must be unique in the system.</div>
                </div>
                <div class="col-md-6">
                    <label for="fullName" class="form-label">Full Name</label>
                    <input type="text" class="form-control" id="fullName" name="fullName" value="<%= editAdmin.getFullName() %>" required>
                </div>
            </div>

            <div class="mb-3">
                <label for="email" class="form-label">Email Address</label>
                <input type="email" class="form-control" id="email" name="email" value="<%= editAdmin.getEmail() %>" required>
            </div>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="newPassword" class="form-label">New Password</label>
                    <input type="password" class="form-control" id="newPassword" name="newPassword">
                    <div class="form-text">Leave blank to keep current password.</div>
                </div>
                <div class="col-md-6">
                    <label for="confirmPassword" class="form-label">Confirm New Password</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword">
                </div>
            </div>

            <div class="mb-3">
                <label for="role" class="form-label">Administrator Role</label>
                <select class="form-select" id="role" name="role" <%= isSelf && editAdmin.isSuperAdmin() ? "disabled" : "" %>>
                    <option value="ADMIN" <%= !editAdmin.isSuperAdmin() ? "selected" : "" %>>Regular Admin</option>
                    <option value="SUPER_ADMIN" <%= editAdmin.isSuperAdmin() ? "selected" : "" %>>Super Admin</option>
                </select>
                <% if(isSelf && editAdmin.isSuperAdmin()) { %>
                    <div class="form-text text-warning">You cannot demote yourself from Super Admin.</div>
                    <input type="hidden" name="role" value="SUPER_ADMIN">
                <% } else { %>
                    <div class="form-text">Super Admins have additional privileges such as managing other admin accounts.</div>
                <% } %>
            </div>

            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                <a href="<%= request.getContextPath() %>/admin/manage-admins" class="btn btn-secondary me-md-2">
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
    // Client-side validation
    document.querySelector('form').addEventListener('submit', function(e) {
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        if (newPassword !== '' && newPassword !== confirmPassword) {
            e.preventDefault();
            alert('Passwords do not match!');
        }
    });
</script>

<!-- Include Admin Footer -->
<%@ include file="../includes/footer.jsp" %>
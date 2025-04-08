<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Include Admin Header -->
<%@ include file="../includes/header.jsp" %>

<%
    // Check if current admin is a super admin
    if (!admin.isSuperAdmin()) {
        session.setAttribute("errorMessage", "Access denied. Super admin privileges required.");
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        return;
    }
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Add New Administrator</h2>
    <a href="<%= request.getContextPath() %>/admin/manage-admins" class="btn btn-outline-admin">
        <i class="bi bi-arrow-left me-2"></i> Back to Admins
    </a>
</div>

<div class="card">
    <div class="card-header">
        <i class="bi bi-person-plus me-2"></i> Administrator Information
    </div>
    <div class="card-body">
        <form action="<%= request.getContextPath() %>/admin/manage-admins" method="post">
            <input type="hidden" name="action" value="add">

            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" class="form-control" id="username" name="username" required>
                    <div class="form-text">Username must be unique in the system.</div>
                </div>
                <div class="col-md-6">
                    <label for="fullName" class="form-label">Full Name</label>
                    <input type="text" class="form-control" id="fullName" name="fullName" required>
                </div>
            </div>

            <div class="mb-3">
                <label for="email" class="form-label">Email Address</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" name="password" required>
                </div>
                <div class="col-md-6">
                    <label for="confirmPassword" class="form-label">Confirm Password</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                </div>
            </div>

            <div class="mb-3">
                <label for="role" class="form-label">Administrator Role</label>
                <select class="form-select" id="role" name="role">
                    <option value="ADMIN">Regular Admin</option>
                    <option value="SUPER_ADMIN">Super Admin</option>
                </select>
                <div class="form-text">Super Admins have additional privileges such as managing other admin accounts.</div>
            </div>

            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                <button type="reset" class="btn btn-secondary me-md-2">
                    <i class="bi bi-arrow-counterclockwise me-2"></i> Reset
                </button>
                <button type="submit" class="btn btn-admin">
                    <i class="bi bi-save me-2"></i> Add Administrator
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    // Client-side validation
    document.querySelector('form').addEventListener('submit', function(e) {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        if (password !== confirmPassword) {
            e.preventDefault();
            alert('Passwords do not match!');
        }
    });
</script>

<!-- Include Admin Footer -->
<%@ include file="../includes/footer.jsp" %>
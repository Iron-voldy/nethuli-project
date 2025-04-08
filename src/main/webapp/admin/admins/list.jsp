<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
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

    List<Admin> admins = (List<Admin>)request.getAttribute("admins");
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Manage Administrators</h2>
    <a href="<%= request.getContextPath() %>/admin/manage-admins?action=add" class="btn btn-admin">
        <i class="bi bi-person-plus me-2"></i> Add New Admin
    </a>
</div>

<div class="card">
    <div class="card-header">
        <i class="bi bi-person-badge me-2"></i> Administrator Accounts
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    if(admins != null && !admins.isEmpty()) {
                        for(Admin adminUser : admins) {
                            boolean isSuperAdmin = adminUser.isSuperAdmin();
                            boolean isSelf = adminUser.getAdminId().equals(admin.getAdminId());
                    %>
                    <tr class="<%= isSelf ? "table-primary" : "" %>">
                        <td><%= adminUser.getAdminId().substring(0, 8) %>...</td>
                        <td><%= adminUser.getUsername() %> <%= isSelf ? "<span class=\"badge bg-info\">You</span>" : "" %></td>
                        <td><%= adminUser.getFullName() %></td>
                        <td><%= adminUser.getEmail() %></td>
                        <td>
                            <% if(isSuperAdmin) { %>
                                <span class="badge badge-admin">Super Admin</span>
                            <% } else { %>
                                <span class="badge bg-secondary">Admin</span>
                            <% } %>
                        </td>
                        <td>
                            <div class="btn-group">
                                <a href="<%= request.getContextPath() %>/admin/manage-admins?action=edit&id=<%= adminUser.getAdminId() %>" class="btn btn-sm btn-outline-admin">
                                    <i class="bi bi-pencil"></i>
                                </a>
                                <% if(!isSelf) { %>
                                <a href="<%= request.getContextPath() %>/admin/manage-admins?action=delete&id=<%= adminUser.getAdminId() %>"
                                   class="btn btn-sm btn-outline-danger confirm-delete"
                                   onclick="return confirm('Are you sure you want to delete this admin account?')">
                                    <i class="bi bi-trash"></i>
                                </a>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="6" class="text-center">No administrators found</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Include Admin Footer -->
<%@ include file="../includes/footer.jsp" %>
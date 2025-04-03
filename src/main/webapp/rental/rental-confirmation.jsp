<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.rental.Transaction" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rental Confirmation - Movie Rental System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <!-- Use the same styles as rental/return-movie.jsp or rent-movie.jsp -->
    <style>
        /* Add the neon dark theme styles here */
    </style>
</head>
<body>
    <%
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        <%
            Transaction transaction = (Transaction) request.getAttribute("transaction");
            Movie movie = (Movie) request.getAttribute("movie");
            Integer rentalDays = (Integer) request.getAttribute("rentalDays");

            if (transaction == null || movie == null || rentalDays == null) {
                response.sendRedirect(request.getContextPath() + "/rental-history");
                return;
            }

            SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
        %>

        <!-- In the existing confirmation page content, you can now use these attributes -->
        <div class="col-md-6 mb-3">
            <strong>Rental Period:</strong>
            <%= rentalDays %> day<%= rentalDays > 1 ? "s" : "" %>
        </div>

    %>

    <!-- Navigation similar to other pages -->

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-header">
                        <i class="bi bi-check-circle"></i> Rental Confirmation
                    </div>
                    <div class="card-body text-center p-5">
                        <i class="bi bi-film text-success" style="font-size: 4rem;"></i>
                        <h2 class="mt-3 mb-2">Movie Rented Successfully!</h2>
                        <p class="text-secondary mb-4">Enjoy your movie</p>

                        <div class="rental-details">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <strong>Movie:</strong>
                                    <%= movie.getTitle() %>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <strong>Rental ID:</strong>
                                    <%= transaction.getTransactionId().substring(0, 8) %>...
                                </div>
                                <div class="col-md-6 mb-3">
                                    <strong>Rental Date:</strong>
                                    <%= dateFormat.format(transaction.getRentalDate()) %>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <strong>Due Date:</strong>
                                    <%= dateFormat.format(transaction.getDueDate()) %>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <strong>Rental Fee:</strong>
                                    $<%= String.format("%.2f", transaction.getRentalFee()) %>
                                </div>
                            </div>
                        </div>

                        <div class="mt-4">
                            <a href="<%= request.getContextPath() %>/rental-history" class="btn btn-neon me-2">
                                <i class="bi bi-collection-play"></i> View Rentals
                            </a>
                            <a href="<%= request.getContextPath() %>/search-movie" class="btn btn-secondary">
                                <i class="bi bi-film"></i> Browse More Movies
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
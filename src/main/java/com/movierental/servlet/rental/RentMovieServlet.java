package com.movierental.servlet.rental;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.movierental.model.movie.Movie;
import com.movierental.model.movie.MovieManager;
import com.movierental.model.rental.RentalManager;
import com.movierental.model.rental.Transaction;
import com.movierental.model.user.User;
import com.movierental.model.user.UserManager;

@WebServlet("/rent-movie")
public class RentMovieServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String movieId = request.getParameter("id");
        if (movieId == null || movieId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        // Get movie from database
        MovieManager movieManager = new MovieManager(getServletContext());
        Movie movie = movieManager.getMovieById(movieId);

        if (movie == null) {
            System.out.println("RentMovieServlet (GET): Movie not found - ID: " + movieId);
            session.setAttribute("errorMessage", "Movie not found");
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        if (!movie.isAvailable()) {
            System.out.println("RentMovieServlet (GET): Movie not available - ID: " + movieId);
            session.setAttribute("errorMessage", "Movie is currently not available for rent");
            response.sendRedirect(request.getContextPath() + "/movie-details?id=" + movieId);
            return;
        }

        // Set movie in request attributes
        request.setAttribute("movie", movie);

        // Forward to the rental form page
        request.getRequestDispatcher("/rental/rent-movie.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user ID from session
        String userId = (String) session.getAttribute("userId");

        // Get form parameters
        String movieId = request.getParameter("movieId");
        String rentalDaysStr = request.getParameter("rentalDays");

        System.out.println("RentMovieServlet (POST): Attempting to rent - MovieID: " + movieId + ", RentalDays: " + rentalDaysStr);

        // Validate inputs
        if (movieId == null || rentalDaysStr == null ||
                movieId.trim().isEmpty() || rentalDaysStr.trim().isEmpty()) {
            System.out.println("RentMovieServlet (POST): Invalid input parameters");
            session.setAttribute("errorMessage", "Invalid request parameters");
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        try {
            int rentalDays = Integer.parseInt(rentalDaysStr);

            // Validate rental days
            if (rentalDays < 1 || rentalDays > 30) {
                System.out.println("RentMovieServlet (POST): Invalid rental days - " + rentalDays);
                session.setAttribute("errorMessage", "Rental period must be between 1 and 30 days");
                response.sendRedirect(request.getContextPath() + "/rent-movie?id=" + movieId);
                return;
            }

            // Create Managers
            RentalManager rentalManager = new RentalManager();
            UserManager userManager = new UserManager(getServletContext());
            MovieManager movieManager = new MovieManager(getServletContext());

            // Get user and verify rental limit
            User user = userManager.getUserById(userId);
            int activeRentals = rentalManager.getActiveRentalsByUser(userId).size();

            System.out.println("RentMovieServlet (POST): User active rentals - " + activeRentals + ", Rental Limit: " + user.getRentalLimit());

            if (activeRentals >= user.getRentalLimit()) {
                System.out.println("RentMovieServlet (POST): Rental limit exceeded");
                session.setAttribute("errorMessage",
                        "You have reached your rental limit of " + user.getRentalLimit() + " movies");
                response.sendRedirect(request.getContextPath() + "/rent-movie?id=" + movieId);
                return;
            }

            // Check movie availability
            Movie movie = movieManager.getMovieById(movieId);

            if (movie == null) {
                System.out.println("RentMovieServlet (POST): Movie not found - ID: " + movieId);
                session.setAttribute("errorMessage", "Movie not found");
                response.sendRedirect(request.getContextPath() + "/search-movie");
                return;
            }

            if (!movie.isAvailable()) {
                System.out.println("RentMovieServlet (POST): Movie not available - ID: " + movieId);
                session.setAttribute("errorMessage", "Movie is currently not available for rent");
                response.sendRedirect(request.getContextPath() + "/movie-details?id=" + movieId);
                return;
            }

            // Process rental
            Transaction transaction = rentalManager.rentMovie(userId, movieId, rentalDays);

            if (transaction != null) {
                System.out.println("RentMovieServlet (POST): Rental successful - TransactionID: " + transaction.getTransactionId());

                // Store transaction details in session
                session.setAttribute("lastTransactionId", transaction.getTransactionId());
                session.setAttribute("lastRentalMovieId", movieId);
                session.setAttribute("lastRentalDays", rentalDays);

                // Redirect to rental confirmation page
                response.sendRedirect(request.getContextPath() + "/rental-confirmation");
            } else {
                System.out.println("RentMovieServlet (POST): Rental failed - MovieID: " + movieId);
                session.setAttribute("errorMessage", "Failed to rent movie. Please try again.");
                response.sendRedirect(request.getContextPath() + "/rent-movie?id=" + movieId);
            }

        } catch (NumberFormatException e) {
            System.out.println("RentMovieServlet (POST): Invalid rental days format");
            session.setAttribute("errorMessage", "Invalid rental days. Please enter a valid number.");
            response.sendRedirect(request.getContextPath() + "/rent-movie?id=" + movieId);
        } catch (Exception e) {
            System.out.println("RentMovieServlet (POST): Unexpected error - " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An unexpected error occurred. Please try again.");
            response.sendRedirect(request.getContextPath() + "/rent-movie?id=" + movieId);
        }
    }
}
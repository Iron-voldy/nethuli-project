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

/**
 * Servlet for handling movie rental
 */
@WebServlet("/rent-movie")
public class RentMovieServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display the rental form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            // Not logged in, redirect to login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String movieId = request.getParameter("id");
        if (movieId == null || movieId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        // Get movie from database
        MovieManager movieManager = new MovieManager();
        Movie movie = movieManager.getMovieById(movieId);

        if (movie == null) {
            request.getSession().setAttribute("errorMessage", "Movie not found");
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        if (!movie.isAvailable()) {
            request.getSession().setAttribute("errorMessage", "Movie is currently not available for rent");
            response.sendRedirect(request.getContextPath() + "/movie-details?id=" + movieId);
            return;
        }

        // Set movie in request attributes
        request.setAttribute("movie", movie);

        // Forward to the rental form page
        request.getRequestDispatcher("/rental/rent-movie.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process the rental
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            // Not logged in, redirect to login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user ID from session
        String userId = (String) session.getAttribute("userId");

        // Get form parameters
        String movieId = request.getParameter("movieId");
        String rentalDaysStr = request.getParameter("rentalDays");

        // Validate inputs
        if (movieId == null || rentalDaysStr == null ||
                movieId.trim().isEmpty() || rentalDaysStr.trim().isEmpty()) {

            request.getSession().setAttribute("errorMessage", "Invalid request parameters");
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        try {
            int rentalDays = Integer.parseInt(rentalDaysStr);

            // Validate rental days
            if (rentalDays < 1 || rentalDays > 30) {
                request.getSession().setAttribute("errorMessage", "Rental period must be between 1 and 30 days");
                response.sendRedirect(request.getContextPath() + "/rent-movie?id=" + movieId);
                return;
            }

            // Create RentalManager
            RentalManager rentalManager = new RentalManager();

            // Get user and verify rental limit
            UserManager userManager = new UserManager();
            User user = userManager.getUserById(userId);
            int activeRentals = rentalManager.getActiveRentalsByUser(userId).size();

            if (activeRentals >= user.getRentalLimit()) {
                request.getSession().setAttribute("errorMessage",
                        "You have reached your rental limit of " + user.getRentalLimit() + " movies");
                response.sendRedirect(request.getContextPath() + "/rent-movie?id=" + movieId);
                return;
            }

            // Check movie availability
            MovieManager movieManager = new MovieManager();
            Movie movie = movieManager.getMovieById(movieId);

            if (movie == null) {
                request.getSession().setAttribute("errorMessage", "Movie not found");
                response.sendRedirect(request.getContextPath() + "/search-movie");
                return;
            }

            if (!movie.isAvailable()) {
                request.getSession().setAttribute("errorMessage", "Movie is currently not available for rent");
                response.sendRedirect(request.getContextPath() + "/movie-details?id=" + movieId);
                return;
            }

            // Process rental
            Transaction transaction = rentalManager.rentMovie(userId, movieId, rentalDays);

            if (transaction != null) {
                // Success
                request.getSession().setAttribute("successMessage",
                        "Movie \"" + movie.getTitle() + "\" rented successfully for " + rentalDays + " days");
                response.sendRedirect(request.getContextPath() + "/rental-history");
            } else {
                // Failed
                request.getSession().setAttribute("errorMessage", "Failed to rent movie. Please try again.");
                response.sendRedirect(request.getContextPath() + "/rent-movie?id=" + movieId);
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid rental days. Please enter a valid number.");
            response.sendRedirect(request.getContextPath() + "/rent-movie?id=" + movieId);
        }
    }
}
package com.movierental.servlet.rental;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

/**
 * Servlet for displaying rental history
 */
@WebServlet("/rental-history")
public class RentalHistoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display rental history
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

        // Get user ID from session
        String userId = (String) session.getAttribute("userId");

        // Get rental history from database
        RentalManager rentalManager = new RentalManager();
        List<Transaction> rentals = rentalManager.getTransactionsByUser(userId);

        // Get active rentals (not returned)
        List<Transaction> activeRentals = new ArrayList<>();
        List<Transaction> rentalHistory = new ArrayList<>();

        // Separate active rentals and history
        for (Transaction rental : rentals) {
            if (!rental.isReturned()) {
                activeRentals.add(rental);
            } else {
                rentalHistory.add(rental);
            }
        }

        // Get overdue rentals
        List<Transaction> overdueRentals = rentalManager.getOverdueRentalsByUser(userId);

        // Fetch movie details for each transaction
        MovieManager movieManager = new MovieManager();
        Map<String, Movie> movieMap = new HashMap<>();

        // Fill movie map for all rentals
        for (Transaction rental : rentals) {
            String movieId = rental.getMovieId();
            if (!movieMap.containsKey(movieId)) {
                Movie movie = movieManager.getMovieById(movieId);
                if (movie != null) {
                    movieMap.put(movieId, movie);
                }
            }
        }

        // Set data in request attributes
        request.setAttribute("activeRentals", activeRentals);
        request.setAttribute("rentalHistory", rentalHistory);
        request.setAttribute("overdueRentals", overdueRentals);
        request.setAttribute("movieMap", movieMap);

        // Forward to the rental history page
        request.getRequestDispatcher("/rental/rental-history.jsp").forward(request, response);
    }
}
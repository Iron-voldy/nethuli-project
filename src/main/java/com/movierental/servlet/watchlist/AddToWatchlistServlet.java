package com.movierental.servlet.watchlist;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.movierental.model.movie.Movie;
import com.movierental.model.movie.MovieManager;
import com.movierental.model.watchlist.Watchlist;
import com.movierental.model.watchlist.WatchlistManager;

/**
 * Servlet handling adding movies to the watchlist
 */
@WebServlet("/add-to-watchlist")
public class AddToWatchlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display the add to watchlist form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get movie ID from request
        String movieId = request.getParameter("movieId");

        if (movieId == null || movieId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        // Get movie details
        MovieManager movieManager = new MovieManager();
        Movie movie = movieManager.getMovieById(movieId);

        if (movie == null) {
            request.getSession().setAttribute("errorMessage", "Movie not found");
            response.sendRedirect(request.getContextPath() + "/search-movie");
            return;
        }

        // Check if movie is already in watchlist
        String userId = (String) session.getAttribute("userId");
        WatchlistManager watchlistManager = new WatchlistManager();

        if (watchlistManager.isInWatchlist(userId, movieId)) {
            // Movie is already in watchlist, redirect to manage watchlist
            Watchlist existingEntry = watchlistManager.getWatchlistByUserAndMovie(userId, movieId);
            request.getSession().setAttribute("infoMessage", "Movie is already in your watchlist.");
            response.sendRedirect(request.getContextPath() + "/manage-watchlist?id=" + existingEntry.getWatchlistId());
            return;
        }

        // Set movie in request attributes
        request.setAttribute("movie", movie);

        // Forward to add to watchlist form
        request.getRequestDispatcher("/watchlist/add-to-watchlist.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process adding movie to watchlist
     */
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
        String priorityStr = request.getParameter("priority");
        String notes = request.getParameter("notes");
        String redirect = request.getParameter("redirect");

        // Validate required fields
        if (movieId == null || movieId.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Movie ID is required");
            doGet(request, response);
            return;
        }

        try {
            // Default priority to medium (3) if not specified
            int priority = 3;
            if (priorityStr != null && !priorityStr.trim().isEmpty()) {
                priority = Integer.parseInt(priorityStr);
            }

            // Add to watchlist
            WatchlistManager watchlistManager = new WatchlistManager();
            Watchlist watchlist = watchlistManager.addToWatchlist(userId, movieId, priority, notes);

            if (watchlist != null) {
                // Success
                request.getSession().setAttribute("successMessage", "Movie added to your watchlist");

                // Redirect based on redirect parameter
                if (redirect != null && !redirect.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/" + redirect);
                } else {
                    response.sendRedirect(request.getContextPath() + "/view-watchlist");
                }
            } else {
                // Failed
                request.setAttribute("errorMessage", "Failed to add movie to watchlist");
                doGet(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid priority");
            doGet(request, response);
        }
    }
}
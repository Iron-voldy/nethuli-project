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
 * Servlet handling watchlist item management
 */
@WebServlet("/manage-watchlist")
public class ManageWatchlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display the watchlist management form
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

        // Get watchlist ID from request
        String watchlistId = request.getParameter("id");

        if (watchlistId == null || watchlistId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/view-watchlist");
            return;
        }

        // Get user ID from session
        String userId = (String) session.getAttribute("userId");

        // Get watchlist entry
        WatchlistManager watchlistManager = new WatchlistManager();
        Watchlist watchlist = watchlistManager.getWatchlistById(watchlistId);

        if (watchlist == null) {
            request.getSession().setAttribute("errorMessage", "Watchlist entry not found");
            response.sendRedirect(request.getContextPath() + "/view-watchlist");
            return;
        }

        // Check if entry belongs to the user
        if (!watchlist.getUserId().equals(userId)) {
            request.getSession().setAttribute("errorMessage", "You do not have permission to manage this entry");
            response.sendRedirect(request.getContextPath() + "/view-watchlist");
            return;
        }

        // Get movie details
        MovieManager movieManager = new MovieManager();
        Movie movie = movieManager.getMovieById(watchlist.getMovieId());

        if (movie == null) {
            request.getSession().setAttribute("errorMessage", "Movie not found");
            response.sendRedirect(request.getContextPath() + "/view-watchlist");
            return;
        }

        // Set attributes for JSP
        request.setAttribute("watchlist", watchlist);
        request.setAttribute("movie", movie);

        // Forward to management page
        request.getRequestDispatcher("/watchlist/manage-watchlist.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - update watchlist item
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
        String watchlistId = request.getParameter("watchlistId");
        String priorityStr = request.getParameter("priority");
        String notes = request.getParameter("notes");
        String watchedStr = request.getParameter("watched");

        // Validate required fields
        if (watchlistId == null || priorityStr == null ||
                watchlistId.trim().isEmpty() || priorityStr.trim().isEmpty()) {

            request.setAttribute("errorMessage", "Required fields are missing");
            doGet(request, response);
            return;
        }

        // Get watchlist entry
        WatchlistManager watchlistManager = new WatchlistManager();
        Watchlist watchlist = watchlistManager.getWatchlistById(watchlistId);

        if (watchlist == null) {
            request.getSession().setAttribute("errorMessage", "Watchlist entry not found");
            response.sendRedirect(request.getContextPath() + "/view-watchlist");
            return;
        }

        // Check if entry belongs to the user
        if (!watchlist.getUserId().equals(userId)) {
            request.getSession().setAttribute("errorMessage", "You do not have permission to manage this entry");
            response.sendRedirect(request.getContextPath() + "/view-watchlist");
            return;
        }

        try {
            // Update watchlist entry
            int priority = Integer.parseInt(priorityStr);
            boolean watched = "on".equals(watchedStr) || "true".equals(watchedStr);

            watchlist.setPriority(priority);
            watchlist.setNotes(notes);

            // Handle watched status
            if (watched && !watchlist.isWatched()) {
                // Mark as watched if previously unwatched
                watchlist.markAsWatched();
                // Add to recently watched
                watchlistManager.addToRecentlyWatched(userId, watchlist.getMovieId());
            } else if (!watched && watchlist.isWatched()) {
                // Mark as unwatched if previously watched
                watchlist.setWatched(false);
            }

            // Update the entry
            boolean updated = watchlistManager.updateWatchlist(watchlist);

            if (updated) {
                request.getSession().setAttribute("successMessage", "Watchlist entry updated");
                response.sendRedirect(request.getContextPath() + "/view-watchlist");
            } else {
                request.setAttribute("errorMessage", "Failed to update watchlist entry");
                doGet(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid priority");
            doGet(request, response);
        }
    }
}
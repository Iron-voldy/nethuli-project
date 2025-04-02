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
 * Servlet handling removal from watchlist
 */
@WebServlet("/remove-from-watchlist")
public class RemoveFromWatchlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - confirm removal from watchlist
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

        // Get parameters
        String watchlistId = request.getParameter("id");
        String confirm = request.getParameter("confirm");

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
            request.getSession().setAttribute("errorMessage", "You do not have permission to remove this entry");
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

        // If confirmation parameter is provided, remove directly
        if ("yes".equals(confirm)) {
            boolean removed = watchlistManager.removeFromWatchlist(watchlistId);

            if (removed) {
                request.getSession().setAttribute("successMessage", "Movie removed from watchlist");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to remove movie from watchlist");
            }

            response.sendRedirect(request.getContextPath() + "/view-watchlist");
            return;
        }

        // Set attributes for confirmation page
        request.setAttribute("watchlist", watchlist);
        request.setAttribute("movie", movie);

        // Forward to confirmation page
        request.getRequestDispatcher("/watchlist/remove-from-watchlist.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process removal from watchlist
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

        // Get parameters
        String watchlistId = request.getParameter("watchlistId");
        String confirmRemove = request.getParameter("confirmRemove");

        if (watchlistId == null || watchlistId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/view-watchlist");
            return;
        }

        if (!"yes".equals(confirmRemove)) {
            // User didn't confirm removal
            response.sendRedirect(request.getContextPath() + "/manage-watchlist?id=" + watchlistId);
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
            request.getSession().setAttribute("errorMessage", "You do not have permission to remove this entry");
            response.sendRedirect(request.getContextPath() + "/view-watchlist");
            return;
        }

        // Remove from watchlist
        boolean removed = watchlistManager.removeFromWatchlist(watchlistId);

        if (removed) {
            request.getSession().setAttribute("successMessage", "Movie removed from watchlist");
        } else {
            request.getSession().setAttribute("errorMessage", "Failed to remove movie from watchlist");
        }

        // Redirect to watchlist
        response.sendRedirect(request.getContextPath() + "/view-watchlist");
    }
}
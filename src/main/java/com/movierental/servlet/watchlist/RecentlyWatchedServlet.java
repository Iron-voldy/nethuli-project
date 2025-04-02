package com.movierental.servlet.watchlist;

import java.io.IOException;
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
import com.movierental.model.watchlist.RecentlyWatched;
import com.movierental.model.watchlist.WatchlistManager;

/**
 * Servlet handling viewing and managing recently watched movies
 */
@WebServlet("/recently-watched")
public class RecentlyWatchedServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display recently watched movies
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

        // Get user ID from session
        String userId = (String) session.getAttribute("userId");

        // Get action parameter
        String action = request.getParameter("action");

        // Handle clear action
        if ("clear".equals(action)) {
            WatchlistManager watchlistManager = new WatchlistManager();
            watchlistManager.clearRecentlyWatched(userId);

            request.getSession().setAttribute("successMessage", "Recently watched list cleared");
            response.sendRedirect(request.getContextPath() + "/recently-watched");
            return;
        }

        // Get recently watched movies
        WatchlistManager watchlistManager = new WatchlistManager();
        RecentlyWatched recentlyWatched = watchlistManager.getRecentlyWatched(userId);
        List<String> recentMovieIds = recentlyWatched.getMovieIds();

        // Get movie details for recently watched
        MovieManager movieManager = new MovieManager();
        Map<String, Movie> movieMap = new HashMap<>();

        for (String movieId : recentMovieIds) {
            Movie movie = movieManager.getMovieById(movieId);
            if (movie != null) {
                movieMap.put(movieId, movie);
            }
        }

        // Set attributes for JSP
        request.setAttribute("recentMovieIds", recentMovieIds);
        request.setAttribute("movieMap", movieMap);
        request.setAttribute("watchDates", recentlyWatched.getWatchDates());

        // Forward to recently watched JSP
        request.getRequestDispatcher("/watchlist/recently-watched.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - add movie to recently watched
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

        // Get movie ID from request
        String movieId = request.getParameter("movieId");

        if (movieId == null || movieId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/recently-watched");
            return;
        }

        // Add to recently watched
        WatchlistManager watchlistManager = new WatchlistManager();
        watchlistManager.addToRecentlyWatched(userId, movieId);

        // Get redirect parameter
        String redirect = request.getParameter("redirect");

        if (redirect != null && !redirect.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/" + redirect);
        } else {
            response.sendRedirect(request.getContextPath() + "/recently-watched");
        }
    }
}
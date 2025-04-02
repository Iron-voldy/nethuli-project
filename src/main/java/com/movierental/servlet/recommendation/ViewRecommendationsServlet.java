package com.movierental.servlet.recommendation;

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
import com.movierental.model.recommendation.GeneralRecommendation;
import com.movierental.model.recommendation.PersonalRecommendation;
import com.movierental.model.recommendation.Recommendation;
import com.movierental.model.recommendation.RecommendationManager;

/**
 * Servlet for viewing different types of recommendations
 */
@WebServlet("/view-recommendations")
public class ViewRecommendationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display recommendations
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        String userId = (session != null) ? (String) session.getAttribute("userId") : null;

        // Get recommendation type
        String type = request.getParameter("type");
        if (type == null) {
            type = (userId != null) ? "personal" : "general";
        }

        RecommendationManager recommendationManager = new RecommendationManager();
        MovieManager movieManager = new MovieManager();

        List<? extends Recommendation> recommendations;

        // Get appropriate recommendations based on type
        if ("personal".equals(type) && userId != null) {
            recommendations = recommendationManager.getPersonalRecommendations(userId);
        } else {
            recommendations = recommendationManager.getGeneralRecommendations();
            type = "general"; // Fallback to general if personal requested without login
        }

        // Get movies for the recommendations
        Map<String, Movie> movieMap = new HashMap<>();
        for (Recommendation recommendation : recommendations) {
            String movieId = recommendation.getMovieId();
            if (!movieMap.containsKey(movieId)) {
                Movie movie = movieManager.getMovieById(movieId);
                if (movie != null) {
                    movieMap.put(movieId, movie);
                }
            }
        }

        // Filter recommendations to include only those with valid movies
        List<Recommendation> filteredRecommendations = new ArrayList<>();
        for (Recommendation recommendation : recommendations) {
            if (movieMap.containsKey(recommendation.getMovieId())) {
                filteredRecommendations.add(recommendation);
            }
        }

        // Get all available genres for the genre navigation
        List<String> allGenres = recommendationManager.getAllGenres();

        // Set attributes for JSP
        request.setAttribute("recommendations", filteredRecommendations);
        request.setAttribute("movieMap", movieMap);
        request.setAttribute("recommendationType", type);
        request.setAttribute("allGenres", allGenres);

        // Forward to recommendations page
        request.getRequestDispatcher("/recommendation/recommendations.jsp").forward(request, response);
    }
}

/**
 * Servlet for viewing top-rated recommendations
 */
@WebServlet("/top-rated")
class TopRatedRecommendationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display top-rated recommendations
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RecommendationManager recommendationManager = new RecommendationManager();
        MovieManager movieManager = new MovieManager();

        // Get top-rated recommendations
        List<GeneralRecommendation> recommendations = recommendationManager.getTopRatedRecommendations();

        // Get movies for the recommendations
        Map<String, Movie> movieMap = new HashMap<>();
        for (Recommendation recommendation : recommendations) {
            String movieId = recommendation.getMovieId();
            if (!movieMap.containsKey(movieId)) {
                Movie movie = movieManager.getMovieById(movieId);
                if (movie != null) {
                    movieMap.put(movieId, movie);
                }
            }
        }

        // Filter recommendations to include only those with valid movies
        List<GeneralRecommendation> filteredRecommendations = new ArrayList<>();
        for (GeneralRecommendation recommendation : recommendations) {
            if (movieMap.containsKey(recommendation.getMovieId())) {
                filteredRecommendations.add(recommendation);
            }
        }

        // Get all available genres for the genre navigation
        List<String> allGenres = recommendationManager.getAllGenres();

        // Set attributes for JSP
        request.setAttribute("recommendations", filteredRecommendations);
        request.setAttribute("movieMap", movieMap);
        request.setAttribute("allGenres", allGenres);

        // Forward to top-rated page
        request.getRequestDispatcher("/recommendation/top-rated.jsp").forward(request, response);
    }
}

/**
 * Servlet for viewing genre-based recommendations
 */
@WebServlet("/genre-recommendations")
class GenreRecommendationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display genre-based recommendations
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String genre = request.getParameter("genre");

        if (genre == null || genre.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/top-rated");
            return;
        }

        RecommendationManager recommendationManager = new RecommendationManager();
        MovieManager movieManager = new MovieManager();

        // Get genre-based recommendations
        List<GeneralRecommendation> recommendations = recommendationManager.getGenreRecommendations(genre);

        // Get movies for the recommendations
        Map<String, Movie> movieMap = new HashMap<>();
        for (Recommendation recommendation : recommendations) {
            String movieId = recommendation.getMovieId();
            if (!movieMap.containsKey(movieId)) {
                Movie movie = movieManager.getMovieById(movieId);
                if (movie != null) {
                    movieMap.put(movieId, movie);
                }
            }
        }

        // Filter recommendations to include only those with valid movies
        List<GeneralRecommendation> filteredRecommendations = new ArrayList<>();
        for (GeneralRecommendation recommendation : recommendations) {
            if (movieMap.containsKey(recommendation.getMovieId())) {
                filteredRecommendations.add(recommendation);
            }
        }

        // Get all available genres for the genre navigation
        List<String> allGenres = recommendationManager.getAllGenres();

        // Set attributes for JSP
        request.setAttribute("recommendations", filteredRecommendations);
        request.setAttribute("movieMap", movieMap);
        request.setAttribute("selectedGenre", genre);
        request.setAttribute("allGenres", allGenres);

        // Forward to genre recommendations page
        request.getRequestDispatcher("/recommendation/genre-recommendations.jsp").forward(request, response);
    }
}
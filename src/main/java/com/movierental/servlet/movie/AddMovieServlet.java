package com.movierental.servlet.movie;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.movierental.model.movie.ClassicMovie;
import com.movierental.model.movie.Movie;
import com.movierental.model.movie.MovieManager;
import com.movierental.model.movie.NewRelease;

/**
 * Servlet for handling movie addition
 */
@WebServlet("/add-movie")
public class AddMovieServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - display the add movie form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to the add movie page
        request.getRequestDispatcher("/movie/add-movie.jsp").forward(request, response);
    }

    /**
     * Handles POST requests - process the add movie form
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form parameters
        String title = request.getParameter("title");
        String director = request.getParameter("director");
        String genre = request.getParameter("genre");
        String releaseYearStr = request.getParameter("releaseYear");
        String ratingStr = request.getParameter("rating");
        String movieType = request.getParameter("movieType");

        // Additional parameters for specific movie types
        String releaseDateStr = request.getParameter("releaseDate");
        String significance = request.getParameter("significance");
        String hasAwardsStr = request.getParameter("hasAwards");

        // Validate required fields
        if (title == null || director == null || genre == null ||
                releaseYearStr == null || ratingStr == null || movieType == null ||
                title.trim().isEmpty() || director.trim().isEmpty() || genre.trim().isEmpty() ||
                releaseYearStr.trim().isEmpty() || ratingStr.trim().isEmpty()) {

            request.setAttribute("errorMessage", "All fields are required");
            request.getRequestDispatcher("/movie/add-movie.jsp").forward(request, response);
            return;
        }

        try {
            // Parse numeric values
            int releaseYear = Integer.parseInt(releaseYearStr);
            double rating = Double.parseDouble(ratingStr);

            // Validate rating range (0-10)
            if (rating < 0 || rating > 10) {
                request.setAttribute("errorMessage", "Rating must be between 0 and 10");
                request.getRequestDispatcher("/movie/add-movie.jsp").forward(request, response);
                return;
            }

            // Create MovieManager
            MovieManager movieManager = new MovieManager();

            // Create movie based on type
            Movie movie = null;

            switch (movieType) {
                case "newRelease":
                    Date releaseDate = new Date(); // Default to current date
                    if (releaseDateStr != null && !releaseDateStr.trim().isEmpty()) {
                        try {
                            releaseDate = new SimpleDateFormat("yyyy-MM-dd").parse(releaseDateStr);
                        } catch (ParseException e) {
                            // Use default date if parsing fails
                        }
                    }

                    NewRelease newRelease = movieManager.addNewRelease(title, director, genre, releaseYear, rating);
                    newRelease.setReleaseDate(releaseDate);
                    movieManager.updateMovie(newRelease);
                    movie = newRelease;
                    break;

                case "classic":
                    boolean hasAwards = "on".equals(hasAwardsStr) || "true".equals(hasAwardsStr);
                    movie = movieManager.addClassicMovie(title, director, genre, releaseYear, rating,
                            significance != null ? significance : "", hasAwards);
                    break;

                default: // Regular movie
                    movie = movieManager.addRegularMovie(title, director, genre, releaseYear, rating);
                    break;
            }

            // Set success message
            request.getSession().setAttribute("successMessage", "Movie added successfully: " + movie.getTitle());

            // Redirect to movie list or details
            response.sendRedirect(request.getContextPath() + "/search-movie");

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid number format. Please check your input.");
            request.getRequestDispatcher("/movie/add-movie.jsp").forward(request, response);
        }
    }
}
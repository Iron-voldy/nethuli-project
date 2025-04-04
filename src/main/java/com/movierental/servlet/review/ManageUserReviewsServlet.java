package com.movierental.servlet.review;

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
import com.movierental.model.review.Review;
import com.movierental.model.review.ReviewManager;
import com.movierental.model.user.User;

/**
 * Servlet for managing user reviews (listing, editing, deleting)
 */
@WebServlet("/manage-user-reviews")
public class ManageUserReviewsServlet extends HttpServlet {
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

        String userId = (String) session.getAttribute("userId");
        String action = request.getParameter("action");

        // Handle different actions
        if ("delete".equals(action)) {
            String reviewId = request.getParameter("reviewId");
            if (reviewId != null && !reviewId.trim().isEmpty()) {
                deleteReview(request, response, userId, reviewId);
                return;
            }
        } else if ("edit".equals(action)) {
            String reviewId = request.getParameter("reviewId");
            if (reviewId != null && !reviewId.trim().isEmpty()) {
                showEditForm(request, response, userId, reviewId);
                return;
            }
        } else if ("update".equals(action)) {
            updateReview(request, response, userId);
            return;
        }

        // Default: show all user reviews
        showUserReviews(request, response, userId);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // Show all reviews by the user
    private void showUserReviews(HttpServletRequest request, HttpServletResponse response, String userId)
            throws ServletException, IOException {
        ReviewManager reviewManager = new ReviewManager();
        List<Review> userReviews = reviewManager.getReviewsByUser(userId);

        // Get movies for each review
        MovieManager movieManager = new MovieManager(getServletContext());
        Map<String, Movie> movieMap = new HashMap<>();

        for (Review review : userReviews) {
            String movieId = review.getMovieId();
            if (!movieMap.containsKey(movieId)) {
                Movie movie = movieManager.getMovieById(movieId);
                if (movie != null) {
                    movieMap.put(movieId, movie);
                }
            }
        }

        // Set attributes for the JSP
        request.setAttribute("userReviews", userReviews);
        request.setAttribute("movieMap", movieMap);

        // Forward to the user reviews page
        request.getRequestDispatcher("/review/user-reviews.jsp").forward(request, response);
    }

    // Show the edit review form
    private void showEditForm(HttpServletRequest request, HttpServletResponse response, String userId, String reviewId)
            throws ServletException, IOException {
        ReviewManager reviewManager = new ReviewManager();
        Review review = reviewManager.getReviewById(reviewId);

        if (review == null) {
            request.getSession().setAttribute("errorMessage", "Review not found");
            response.sendRedirect(request.getContextPath() + "/manage-user-reviews");
            return;
        }

        // Check if the review belongs to the user
        if (!userId.equals(review.getUserId())) {
            request.getSession().setAttribute("errorMessage", "You do not have permission to edit this review");
            response.sendRedirect(request.getContextPath() + "/manage-user-reviews");
            return;
        }

        // Get movie details
        MovieManager movieManager = new MovieManager(getServletContext());
        Movie movie = movieManager.getMovieById(review.getMovieId());

        if (movie == null) {
            request.getSession().setAttribute("errorMessage", "Movie not found");
            response.sendRedirect(request.getContextPath() + "/manage-user-reviews");
            return;
        }

        // Set attributes for the JSP
        request.setAttribute("review", review);
        request.setAttribute("movie", movie);

        // Forward to the edit review page
        request.getRequestDispatcher("/review/edit-review.jsp").forward(request, response);
    }

    // Update a review
    private void updateReview(HttpServletRequest request, HttpServletResponse response, String userId)
            throws ServletException, IOException {
        String reviewId = request.getParameter("reviewId");
        String rating = request.getParameter("rating");
        String comment = request.getParameter("comment");
        String movieId = request.getParameter("movieId");

        // Validate required inputs
        if (reviewId == null || rating == null || comment == null || movieId == null ||
                reviewId.trim().isEmpty() || rating.trim().isEmpty() || comment.trim().isEmpty() || movieId.trim().isEmpty()) {

            request.getSession().setAttribute("errorMessage", "All fields are required");
            response.sendRedirect(request.getContextPath() + "/manage-user-reviews");
            return;
        }

        try {
            int ratingValue = Integer.parseInt(rating);

            // Check if rating is valid (1-5)
            if (ratingValue < 1 || ratingValue > 5) {
                request.getSession().setAttribute("errorMessage", "Rating must be between 1 and 5");
                response.sendRedirect(request.getContextPath() + "/manage-user-reviews?action=edit&reviewId=" + reviewId);
                return;
            }

            // Get review manager
            ReviewManager reviewManager = new ReviewManager();

            // Check if review exists and belongs to the user
            Review existingReview = reviewManager.getReviewById(reviewId);

            if (existingReview == null) {
                request.getSession().setAttribute("errorMessage", "Review not found");
                response.sendRedirect(request.getContextPath() + "/manage-user-reviews");
                return;
            }

            if (!userId.equals(existingReview.getUserId())) {
                request.getSession().setAttribute("errorMessage", "You do not have permission to edit this review");
                response.sendRedirect(request.getContextPath() + "/manage-user-reviews");
                return;
            }

            // Update the review
            boolean success = reviewManager.updateReview(reviewId, userId, comment, ratingValue);

            if (success) {
                request.getSession().setAttribute("successMessage", "Review updated successfully");
                response.sendRedirect(request.getContextPath() + "/view-movie-reviews?movieId=" + movieId);
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to update review");
                response.sendRedirect(request.getContextPath() + "/manage-user-reviews?action=edit&reviewId=" + reviewId);
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid rating format");
            response.sendRedirect(request.getContextPath() + "/manage-user-reviews?action=edit&reviewId=" + reviewId);
        }
    }

    // Delete a review
    private void deleteReview(HttpServletRequest request, HttpServletResponse response, String userId, String reviewId)
            throws ServletException, IOException {
        ReviewManager reviewManager = new ReviewManager();
        Review review = reviewManager.getReviewById(reviewId);

        if (review == null) {
            request.getSession().setAttribute("errorMessage", "Review not found");
            response.sendRedirect(request.getContextPath() + "/manage-user-reviews");
            return;
        }

        // Check if the review belongs to the user (unless the user is an admin)
        if (!userId.equals(review.getUserId())) {
            request.getSession().setAttribute("errorMessage", "You do not have permission to delete this review");
            response.sendRedirect(request.getContextPath() + "/manage-user-reviews");
            return;
        }

        // Store the movie ID before deleting
        String movieId = review.getMovieId();

        // Delete the review
        boolean deleted = reviewManager.deleteReview(reviewId, userId);

        if (deleted) {
            request.getSession().setAttribute("successMessage", "Review deleted successfully");
        } else {
            request.getSession().setAttribute("errorMessage", "Failed to delete review");
        }

        // Redirect based on the provided redirect parameter
        String redirectTo = request.getParameter("redirectTo");
        if ("movie".equals(redirectTo)) {
            response.sendRedirect(request.getContextPath() + "/view-movie-reviews?movieId=" + movieId);
        } else {
            response.sendRedirect(request.getContextPath() + "/manage-user-reviews");
        }
    }
}
package com.movierental.servlet.recommendation;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.movierental.model.recommendation.GeneralRecommendation;
import com.movierental.model.recommendation.PersonalRecommendation;
import com.movierental.model.recommendation.RecommendationManager;

import java.util.List;

/**
 * Servlet for generating recommendations
 */
@WebServlet("/generate-recommendations")
public class GenerateRecommendationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests - generate and redirect to view recommendations
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get recommendation type
        String type = request.getParameter("type");
        if (type == null) {
            type = "general"; // Default to general recommendations
        }

        RecommendationManager recommendationManager = new RecommendationManager();

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        String userId = (session != null) ? (String) session.getAttribute("userId") : null;

        // Generate appropriate recommendations based on type
        if ("personal".equals(type) && userId != null) {
            // Generate personal recommendations
            List<PersonalRecommendation> recommendations =
                    recommendationManager.generatePersonalRecommendations(userId);

            if (recommendations != null && !recommendations.isEmpty()) {
                request.getSession().setAttribute("successMessage",
                        "Personal recommendations generated successfully");
            } else {
                request.getSession().setAttribute("errorMessage",
                        "Failed to generate personal recommendations");
            }

            // Redirect to personal recommendations view
            response.sendRedirect(request.getContextPath() + "/view-recommendations?type=personal");

        } else if ("top-rated".equals(type)) {
            // Generate general recommendations which includes top-rated
            List<GeneralRecommendation> recommendations =
                    recommendationManager.generateGeneralRecommendations();

            if (recommendations != null && !recommendations.isEmpty()) {
                request.getSession().setAttribute("successMessage",
                        "Top-rated recommendations generated successfully");
            } else {
                request.getSession().setAttribute("errorMessage",
                        "Failed to generate top-rated recommendations");
            }

            // Redirect to top-rated view
            response.sendRedirect(request.getContextPath() + "/top-rated");

        } else {
            // Generate general recommendations
            List<GeneralRecommendation> recommendations =
                    recommendationManager.generateGeneralRecommendations();

            if (recommendations != null && !recommendations.isEmpty()) {
                request.getSession().setAttribute("successMessage",
                        "General recommendations generated successfully");
            } else {
                request.getSession().setAttribute("errorMessage",
                        "Failed to generate general recommendations");
            }

            // Redirect to general recommendations view
            response.sendRedirect(request.getContextPath() + "/view-recommendations?type=general");
        }
    }
}
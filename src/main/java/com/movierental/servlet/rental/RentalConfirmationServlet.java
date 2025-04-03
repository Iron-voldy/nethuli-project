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

@WebServlet("/rental-confirmation")
public class RentalConfirmationServlet extends HttpServlet {
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

        // Get transaction ID from session
        String transactionId = (String) session.getAttribute("lastTransactionId");
        String movieId = (String) session.getAttribute("lastRentalMovieId");
        Integer rentalDays = (Integer) session.getAttribute("lastRentalDays");

        System.out.println("RentalConfirmationServlet: TransactionID: " + transactionId);
        System.out.println("RentalConfirmationServlet: MovieID: " + movieId);
        System.out.println("RentalConfirmationServlet: RentalDays: " + rentalDays);

        if (transactionId == null || movieId == null || rentalDays == null) {
            System.out.println("RentalConfirmationServlet: Missing session attributes");
            response.sendRedirect(request.getContextPath() + "/rental-history");
            return;
        }

        // Create managers
        RentalManager rentalManager = new RentalManager();
        MovieManager movieManager = new MovieManager(getServletContext());

        // Get transaction details
        Transaction transaction = rentalManager.getTransactionById(transactionId);
        Movie movie = movieManager.getMovieById(movieId);

        if (transaction == null || movie == null) {
            System.out.println("RentalConfirmationServlet: Transaction or Movie not found");
            response.sendRedirect(request.getContextPath() + "/rental-history");
            return;
        }

        // Set attributes for confirmation page
        request.setAttribute("transaction", transaction);
        request.setAttribute("movie", movie);
        request.setAttribute("rentalDays", rentalDays);

        // Remove transaction details from session
        session.removeAttribute("lastTransactionId");
        session.removeAttribute("lastRentalMovieId");
        session.removeAttribute("lastRentalDays");

        // Forward to confirmation page
        request.getRequestDispatcher("/rental/rental-confirmation.jsp").forward(request, response);
    }
}
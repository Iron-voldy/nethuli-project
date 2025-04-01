package com.movierental.model.rental;

import java.io.*;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import com.movierental.model.movie.Movie;
import com.movierental.model.movie.MovieManager;
import com.movierental.model.user.PremiumUser;
import com.movierental.model.user.RegularUser;
import com.movierental.model.user.User;
import com.movierental.model.user.UserManager;

/**
 * RentalManager class handles all rental-related operations
 */
public class RentalManager {
    private static final String RENTAL_FILE_PATH = "data/rentals.txt";
    private List<Transaction> transactions;
    private MovieManager movieManager;
    private UserManager userManager;

    // Constructor
    public RentalManager() {
        transactions = new ArrayList<>();
        movieManager = new MovieManager();
        userManager = new UserManager();
        loadTransactions();
    }

    // Constructor with existing managers
    public RentalManager(MovieManager movieManager, UserManager userManager) {
        transactions = new ArrayList<>();
        this.movieManager = movieManager;
        this.userManager = userManager;
        loadTransactions();
    }

    // Load transactions from file
    private void loadTransactions() {
        File file = new File(RENTAL_FILE_PATH);

        // Create directory if it doesn't exist
        file.getParentFile().mkdirs();

        if (!file.exists()) {
            try {
                file.createNewFile();
            } catch (IOException e) {
                System.err.println("Error creating rentals file: " + e.getMessage());
            }
            return;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) {
                    continue;
                }

                Transaction transaction = Transaction.fromFileString(line);
                if (transaction != null) {
                    transactions.add(transaction);
                }
            }
        } catch (IOException e) {
            System.err.println("Error loading transactions: " + e.getMessage());
        }
    }

    // Save transactions to file
    private void saveTransactions() {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(RENTAL_FILE_PATH))) {
            for (Transaction transaction : transactions) {
                writer.write(transaction.toFileString());
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error saving transactions: " + e.getMessage());
        }
    }

    // Rent a movie
    public Transaction rentMovie(String userId, String movieId, int rentalDays) {
        // Check if user exists
        User user = userManager.getUserById(userId);
        if (user == null) {
            return null;
        }

        // Check if movie exists and is available
        Movie movie = movieManager.getMovieById(movieId);
        if (movie == null || !movie.isAvailable()) {
            return null;
        }

        // Check if user has reached rental limit
        List<Transaction> userActiveRentals = getActiveRentalsByUser(userId);
        if (userActiveRentals.size() >= user.getRentalLimit()) {
            return null;
        }

        // Calculate rental fee based on user type and movie type
        double rentalFee = calculateRentalFee(user, movie, rentalDays);

        // Calculate due date
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DAY_OF_MONTH, rentalDays);
        Date dueDate = calendar.getTime();

        // Create new transaction
        Transaction transaction = new Transaction();
        transaction.setTransactionId(UUID.randomUUID().toString());
        transaction.setUserId(userId);
        transaction.setMovieId(movieId);
        transaction.setRentalDate(new Date());
        transaction.setDueDate(dueDate);
        transaction.setRentalFee(rentalFee);
        transaction.setReturned(false);

        // Update movie availability
        movie.setAvailable(false);
        movieManager.updateMovie(movie);

        // Add transaction to list and save
        transactions.add(transaction);
        saveTransactions();

        return transaction;
    }

    // Return a movie
    public boolean returnMovie(String transactionId) {
        Transaction transaction = getTransactionById(transactionId);
        if (transaction == null || transaction.isReturned()) {
            return false;
        }

        // Set return date and update returned status
        Date returnDate = new Date();
        transaction.setReturnDate(returnDate);
        transaction.setReturned(true);

        // Calculate late fee if applicable
        if (returnDate.after(transaction.getDueDate())) {
            int daysLate = transaction.calculateDaysOverdue();
            User user = userManager.getUserById(transaction.getUserId());

            double lateFee = calculateLateFee(user, daysLate);
            transaction.setLateFee(lateFee);
        }

        // Update movie availability
        Movie movie = movieManager.getMovieById(transaction.getMovieId());
        if (movie != null) {
            movie.setAvailable(true);
            movieManager.updateMovie(movie);
        }

        // Save updated transaction
        saveTransactions();

        return true;
    }

    // Calculate rental fee based on user type and movie
    private double calculateRentalFee(User user, Movie movie, int days) {
        double movieFee = movie.calculateRentalPrice(days);

        // Apply user discount if applicable
        if (user instanceof PremiumUser) {
            return movieFee * 0.8; // 20% discount for premium users
        }

        return movieFee; // Regular price for regular users
    }

    // Calculate late fee based on user type and days late
    private double calculateLateFee(User user, int daysLate) {
        if (daysLate <= 0) {
            return 0.0;
        }

        if (user instanceof PremiumUser) {
            return ((PremiumUser) user).calculateLateFee(daysLate);
        } else if (user instanceof RegularUser) {
            return ((RegularUser) user).calculateLateFee(daysLate);
        } else {
            // Default late fee calculation
            return 1.0 * daysLate;
        }
    }

    // Get transaction by ID
    public Transaction getTransactionById(String transactionId) {
        for (Transaction transaction : transactions) {
            if (transaction.getTransactionId().equals(transactionId)) {
                return transaction;
            }
        }
        return null;
    }

    // Get all transactions
    public List<Transaction> getAllTransactions() {
        return new ArrayList<>(transactions);
    }

    // Get transactions by user ID
    public List<Transaction> getTransactionsByUser(String userId) {
        List<Transaction> userTransactions = new ArrayList<>();
        for (Transaction transaction : transactions) {
            if (transaction.getUserId().equals(userId)) {
                userTransactions.add(transaction);
            }
        }
        return userTransactions;
    }

    // Get active (not returned) rentals by user ID
    public List<Transaction> getActiveRentalsByUser(String userId) {
        List<Transaction> activeRentals = new ArrayList<>();
        for (Transaction transaction : transactions) {
            if (transaction.getUserId().equals(userId) && !transaction.isReturned()) {
                activeRentals.add(transaction);
            }
        }
        return activeRentals;
    }

    // Get overdue rentals
    public List<Transaction> getOverdueRentals() {
        List<Transaction> overdueRentals = new ArrayList<>();
        Date currentDate = new Date();

        for (Transaction transaction : transactions) {
            if (!transaction.isReturned() && currentDate.after(transaction.getDueDate())) {
                overdueRentals.add(transaction);
            }
        }
        return overdueRentals;
    }

    // Get overdue rentals by user
    public List<Transaction> getOverdueRentalsByUser(String userId) {
        List<Transaction> overdueRentals = new ArrayList<>();
        Date currentDate = new Date();

        for (Transaction transaction : transactions) {
            if (transaction.getUserId().equals(userId) &&
                    !transaction.isReturned() &&
                    currentDate.after(transaction.getDueDate())) {
                overdueRentals.add(transaction);
            }
        }
        return overdueRentals;
    }

    // Get rental history for a movie
    public List<Transaction> getRentalHistoryForMovie(String movieId) {
        List<Transaction> movieRentals = new ArrayList<>();
        for (Transaction transaction : transactions) {
            if (transaction.getMovieId().equals(movieId)) {
                movieRentals.add(transaction);
            }
        }
        return movieRentals;
    }

    // Delete a transaction
    public boolean deleteTransaction(String transactionId) {
        for (int i = 0; i < transactions.size(); i++) {
            if (transactions.get(i).getTransactionId().equals(transactionId)) {
                // If the transaction is for a movie that hasn't been returned,
                // make the movie available again
                Transaction transaction = transactions.get(i);
                if (!transaction.isReturned()) {
                    Movie movie = movieManager.getMovieById(transaction.getMovieId());
                    if (movie != null) {
                        movie.setAvailable(true);
                        movieManager.updateMovie(movie);
                    }
                }

                transactions.remove(i);
                saveTransactions();
                return true;
            }
        }
        return false;
    }

    // Check if a user has a specific movie rented
    public boolean hasUserRentedMovie(String userId, String movieId) {
        for (Transaction transaction : transactions) {
            if (transaction.getUserId().equals(userId) &&
                    transaction.getMovieId().equals(movieId) &&
                    !transaction.isReturned()) {
                return true;
            }
        }
        return false;
    }

    // Get total rental fees for a given user
    public double getTotalRentalFeesByUser(String userId) {
        double total = 0.0;
        for (Transaction transaction : transactions) {
            if (transaction.getUserId().equals(userId)) {
                total += transaction.getRentalFee();
                total += transaction.getLateFee();
            }
        }
        return total;
    }
}
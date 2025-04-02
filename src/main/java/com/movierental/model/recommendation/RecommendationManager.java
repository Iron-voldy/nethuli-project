package com.movierental.model.recommendation;

import java.io.*;
import java.util.*;

import com.movierental.model.movie.Movie;
import com.movierental.model.movie.MovieManager;
import com.movierental.model.rental.RentalManager;
import com.movierental.model.rental.Transaction;
import com.movierental.model.review.Review;
import com.movierental.model.review.ReviewManager;
import com.movierental.model.watchlist.WatchlistManager;
import com.movierental.model.watchlist.Watchlist;
import com.movierental.model.watchlist.RecentlyWatched;

/**
 * RecommendationManager class handles all recommendation-related operations
 */
public class RecommendationManager {
    private static final String RECOMMENDATION_FILE_PATH = "data/recommendations.txt";
    private List<Recommendation> recommendations;
    private MovieManager movieManager;
    private ReviewManager reviewManager;
    private RentalManager rentalManager;
    private WatchlistManager watchlistManager;

    // Constructor
    public RecommendationManager() {
        recommendations = new ArrayList<>();
        movieManager = new MovieManager();
        reviewManager = new ReviewManager();
        rentalManager = new RentalManager();
        watchlistManager = new WatchlistManager();
        loadRecommendations();
    }

    // Constructor with existing managers
    public RecommendationManager(MovieManager movieManager, ReviewManager reviewManager,
                                 RentalManager rentalManager, WatchlistManager watchlistManager) {
        recommendations = new ArrayList<>();
        this.movieManager = movieManager;
        this.reviewManager = reviewManager;
        this.rentalManager = rentalManager;
        this.watchlistManager = watchlistManager;
        loadRecommendations();
    }

    // Load recommendations from file
    private void loadRecommendations() {
        File file = new File(RECOMMENDATION_FILE_PATH);

        // Create directory if it doesn't exist
        file.getParentFile().mkdirs();

        if (!file.exists()) {
            try {
                file.createNewFile();
            } catch (IOException e) {
                System.err.println("Error creating recommendations file: " + e.getMessage());
            }
            return;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) {
                    continue;
                }

                Recommendation recommendation = null;
                if (line.startsWith("PERSONAL_RECOMMENDATION,")) {
                    recommendation = PersonalRecommendation.fromFileString(line);
                } else if (line.startsWith("GENERAL_RECOMMENDATION,")) {
                    recommendation = GeneralRecommendation.fromFileString(line);
                } else if (line.startsWith("RECOMMENDATION,")) {
                    recommendation = Recommendation.fromFileString(line);
                }

                if (recommendation != null) {
                    recommendations.add(recommendation);
                }
            }
        } catch (IOException e) {
            System.err.println("Error loading recommendations: " + e.getMessage());
        }
    }

    // Save recommendations to file
    private void saveRecommendations() {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(RECOMMENDATION_FILE_PATH))) {
            for (Recommendation recommendation : recommendations) {
                writer.write(recommendation.toFileString());
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error saving recommendations: " + e.getMessage());
        }
    }

    // Generate general recommendations
    public List<GeneralRecommendation> generateGeneralRecommendations() {
        // Clear existing general recommendations
        recommendations.removeIf(rec -> !rec.isPersonalized());

        List<GeneralRecommendation> generalRecommendations = new ArrayList<>();

        // Generate top-rated recommendations
        List<Movie> topRatedMovies = movieManager.getTopRatedMovies(20); // Get top 20 rated movies

        int rank = 1;
        for (Movie movie : topRatedMovies) {
            GeneralRecommendation recommendation = new GeneralRecommendation();
            recommendation.setRecommendationId(UUID.randomUUID().toString());
            recommendation.setMovieId(movie.getMovieId());
            recommendation.setGeneratedDate(new Date());
            recommendation.setScore(movie.getRating()); // Use movie rating as score
            recommendation.setReason("This movie is one of our top-rated films with a rating of " + movie.getRating());
            recommendation.setCategory("top-rated");
            recommendation.setRank(rank++);

            generalRecommendations.add(recommendation);
            recommendations.add(recommendation);
        }

        // Get all unique genres
        Set<String> genres = new HashSet<>();
        for (Movie movie : movieManager.getAllMovies()) {
            genres.add(movie.getGenre());
        }

        // Generate recommendations by genre
        for (String genre : genres) {
            List<Movie> genreMovies = new ArrayList<>();
            for (Movie movie : movieManager.getAllMovies()) {
                if (movie.getGenre().equals(genre)) {
                    genreMovies.add(movie);
                }
            }

            // Sort by rating
            genreMovies.sort((m1, m2) -> Double.compare(m2.getRating(), m1.getRating()));

            // Take top 5 movies per genre
            int genreRank = 1;
            for (int i = 0; i < Math.min(5, genreMovies.size()); i++) {
                Movie movie = genreMovies.get(i);

                GeneralRecommendation recommendation = new GeneralRecommendation();
                recommendation.setRecommendationId(UUID.randomUUID().toString());
                recommendation.setMovieId(movie.getMovieId());
                recommendation.setGeneratedDate(new Date());
                recommendation.setScore(movie.getRating());
                recommendation.setReason("This is one of the top-rated " + genre + " movies");
                recommendation.setCategory("genre-" + genre.toLowerCase());
                recommendation.setRank(genreRank++);

                generalRecommendations.add(recommendation);
                recommendations.add(recommendation);
            }
        }

        saveRecommendations();
        return generalRecommendations;
    }

    // Generate personal recommendations for a user
    public List<PersonalRecommendation> generatePersonalRecommendations(String userId) {
        // Remove existing personal recommendations for this user
        recommendations.removeIf(rec -> rec.isPersonalized() && userId.equals(rec.getUserId()));

        List<PersonalRecommendation> personalRecommendations = new ArrayList<>();

        // Get user's watched movies, rentals, and watchlist
        RecentlyWatched recentlyWatched = watchlistManager.getRecentlyWatched(userId);
        List<Transaction> rentalHistory = rentalManager.getTransactionsByUser(userId);
        List<Watchlist> watchlist = watchlistManager.getWatchlistByUser(userId);

        // Get movies the user has already seen or in their watchlist
        Set<String> userMovieIds = new HashSet<>();
        if (recentlyWatched != null) {
            userMovieIds.addAll(recentlyWatched.getMovieIds());
        }

        for (Transaction transaction : rentalHistory) {
            userMovieIds.add(transaction.getMovieId());
        }

        for (Watchlist item : watchlist) {
            userMovieIds.add(item.getMovieId());
        }

        // Get user's preferred genres
        Map<String, Integer> genreCounts = new HashMap<>();
        for (String movieId : userMovieIds) {
            Movie movie = movieManager.getMovieById(movieId);
            if (movie != null) {
                String genre = movie.getGenre();
                genreCounts.put(genre, genreCounts.getOrDefault(genre, 0) + 1);
            }
        }

        // Sort genres by preference
        List<Map.Entry<String, Integer>> sortedGenres = new ArrayList<>(genreCounts.entrySet());
        sortedGenres.sort((g1, g2) -> g2.getValue().compareTo(g1.getValue()));

        // Recommend movies based on preferred genres
        int recommendationCount = 0;
        for (Map.Entry<String, Integer> genreEntry : sortedGenres) {
            String genre = genreEntry.getKey();

            // Get movies of this genre not seen by the user
            List<Movie> genreMovies = new ArrayList<>();
            for (Movie movie : movieManager.getAllMovies()) {
                if (movie.getGenre().equals(genre) && !userMovieIds.contains(movie.getMovieId()) && movie.isAvailable()) {
                    genreMovies.add(movie);
                }
            }

            // Sort by rating
            genreMovies.sort((m1, m2) -> Double.compare(m2.getRating(), m1.getRating()));

            // Take top movies per genre
            for (int i = 0; i < Math.min(5, genreMovies.size()); i++) {
                Movie movie = genreMovies.get(i);

                PersonalRecommendation recommendation = new PersonalRecommendation();
                recommendation.setRecommendationId(UUID.randomUUID().toString());
                recommendation.setMovieId(movie.getMovieId());
                recommendation.setUserId(userId);
                recommendation.setGeneratedDate(new Date());
                recommendation.setScore(movie.getRating());
                recommendation.setReason("Based on your interest in " + genre + " movies");
                recommendation.setBaseSource("genre-preference");
                recommendation.setRelevanceScore(0.8);

                personalRecommendations.add(recommendation);
                recommendations.add(recommendation);

                recommendationCount++;
                if (recommendationCount >= 15) {
                    break;  // Limit to 15 recommendations total
                }
            }

            if (recommendationCount >= 15) {
                break;
            }
        }

        // If we don't have enough recommendations, add some based on top-rated movies
        if (recommendationCount < 15) {
            List<Movie> topRatedMovies = movieManager.getTopRatedMovies(30);

            for (Movie movie : topRatedMovies) {
                if (!userMovieIds.contains(movie.getMovieId()) && movie.isAvailable()) {
                    PersonalRecommendation recommendation = new PersonalRecommendation();
                    recommendation.setRecommendationId(UUID.randomUUID().toString());
                    recommendation.setMovieId(movie.getMovieId());
                    recommendation.setUserId(userId);
                    recommendation.setGeneratedDate(new Date());
                    recommendation.setScore(movie.getRating());
                    recommendation.setReason("This is one of our highest-rated movies");
                    recommendation.setBaseSource("top-rated");
                    recommendation.setRelevanceScore(0.6);

                    personalRecommendations.add(recommendation);
                    recommendations.add(recommendation);

                    recommendationCount++;
                    if (recommendationCount >= 15) {
                        break;
                    }
                }
            }
        }

        saveRecommendations();
        return personalRecommendations;
    }

    // Get personal recommendations for a user
    public List<PersonalRecommendation> getPersonalRecommendations(String userId) {
        List<PersonalRecommendation> userRecs = new ArrayList<>();

        for (Recommendation rec : recommendations) {
            if (rec.isPersonalized() && userId.equals(rec.getUserId())) {
                userRecs.add((PersonalRecommendation) rec);
            }
        }

        // Check if we need to generate new recommendations
        if (userRecs.isEmpty() || isRecommendationsStale(userRecs)) {
            userRecs = generatePersonalRecommendations(userId);
        }

        return userRecs;
    }

    // Get general recommendations
    public List<GeneralRecommendation> getGeneralRecommendations() {
        List<GeneralRecommendation> generalRecs = new ArrayList<>();

        for (Recommendation rec : recommendations) {
            if (!rec.isPersonalized()) {
                generalRecs.add((GeneralRecommendation) rec);
            }
        }

        // Check if we need to generate new recommendations
        if (generalRecs.isEmpty() || isRecommendationsStale(generalRecs)) {
            generalRecs = generateGeneralRecommendations();
        }

        return generalRecs;
    }

    // Get top-rated recommendations
    public List<GeneralRecommendation> getTopRatedRecommendations() {
        List<GeneralRecommendation> topRated = new ArrayList<>();

        for (Recommendation rec : recommendations) {
            if (!rec.isPersonalized() &&
                    rec instanceof GeneralRecommendation &&
                    "top-rated".equals(((GeneralRecommendation) rec).getCategory())) {
                topRated.add((GeneralRecommendation) rec);
            }
        }

        // Sort by rank
        topRated.sort(Comparator.comparingInt(GeneralRecommendation::getRank));

        // Generate if empty
        if (topRated.isEmpty()) {
            generateGeneralRecommendations();
            return getTopRatedRecommendations();
        }

        return topRated;
    }

    // Get genre-based recommendations
    public List<GeneralRecommendation> getGenreRecommendations(String genre) {
        String categoryPattern = "genre-" + genre.toLowerCase();
        List<GeneralRecommendation> genreRecs = new ArrayList<>();

        for (Recommendation rec : recommendations) {
            if (!rec.isPersonalized() &&
                    rec instanceof GeneralRecommendation &&
                    categoryPattern.equals(((GeneralRecommendation) rec).getCategory())) {
                genreRecs.add((GeneralRecommendation) rec);
            }
        }

        // Sort by rank
        genreRecs.sort(Comparator.comparingInt(GeneralRecommendation::getRank));

        // Generate if empty
        if (genreRecs.isEmpty()) {
            generateGeneralRecommendations();
            return getGenreRecommendations(genre);
        }

        return genreRecs;
    }

    // Check if recommendations are stale (older than 24 hours)
    private boolean isRecommendationsStale(List<? extends Recommendation> recs) {
        if (recs.isEmpty()) {
            return true;
        }

        Date now = new Date();
        long dayInMillis = 24 * 60 * 60 * 1000; // 24 hours

        // Check if any recommendation is older than 24 hours
        for (Recommendation rec : recs) {
            if (now.getTime() - rec.getGeneratedDate().getTime() > dayInMillis) {
                return true;
            }
        }

        return false;
    }

    // Delete all recommendations for a user (e.g. when user is deleted)
    public void deleteUserRecommendations(String userId) {
        recommendations.removeIf(rec -> userId.equals(rec.getUserId()));
        saveRecommendations();
    }

    // Get all available genres
    public List<String> getAllGenres() {
        Set<String> genres = new HashSet<>();
        for (Movie movie : movieManager.getAllMovies()) {
            genres.add(movie.getGenre());
        }
        return new ArrayList<>(genres);
    }

    // Get all recommendations
    public List<Recommendation> getAllRecommendations() {
        return new ArrayList<>(recommendations);
    }
}
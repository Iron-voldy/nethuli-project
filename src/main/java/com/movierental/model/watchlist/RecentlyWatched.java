package com.movierental.model.watchlist;

import java.util.Date;
import java.util.LinkedList;

/**
 * RecentlyWatched class implements a stack to manage recently watched movies
 */
public class RecentlyWatched {
    private String userId;
    private LinkedList<String> movieIds;     // using LinkedList as a stack
    private LinkedList<Date> watchDates;     // parallel stack for watch dates
    private int maxSize;                     // maximum movies to keep track of

    // Constructor
    public RecentlyWatched(String userId) {
        this.userId = userId;
        this.movieIds = new LinkedList<>();
        this.watchDates = new LinkedList<>();
        this.maxSize = 10;  // default to track last 10 movies
    }

    // Constructor with customizable size
    public RecentlyWatched(String userId, int maxSize) {
        this.userId = userId;
        this.movieIds = new LinkedList<>();
        this.watchDates = new LinkedList<>();
        this.maxSize = maxSize;
    }

    // Getters and Setters
    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public int getMaxSize() {
        return maxSize;
    }

    public void setMaxSize(int maxSize) {
        this.maxSize = maxSize;
    }

    // Get all movie IDs in the recently watched list
    public LinkedList<String> getMovieIds() {
        return new LinkedList<>(movieIds);
    }

    // Get all watch dates
    public LinkedList<Date> getWatchDates() {
        return new LinkedList<>(watchDates);
    }

    // Add a movie to recently watched (implementing stack push)
    public void addMovie(String movieId) {
        // Check if movie is already in the list
        int existingIndex = movieIds.indexOf(movieId);
        if (existingIndex >= 0) {
            // Remove existing entry
            movieIds.remove(existingIndex);
            watchDates.remove(existingIndex);
        }

        // Add to the front (push)
        movieIds.addFirst(movieId);
        watchDates.addFirst(new Date());

        // Check if we exceed maximum size
        if (movieIds.size() > maxSize) {
            // Remove last element
            movieIds.removeLast();
            watchDates.removeLast();
        }
    }

    // Get the most recently watched movie (peek)
    public String getMostRecentMovie() {
        if (movieIds.isEmpty()) {
            return null;
        }
        return movieIds.getFirst();
    }

    // Get the date of the most recently watched movie
    public Date getMostRecentWatchDate() {
        if (watchDates.isEmpty()) {
            return null;
        }
        return watchDates.getFirst();
    }

    // Remove the most recently watched movie (pop)
    public String removeRecentMovie() {
        if (movieIds.isEmpty()) {
            return null;
        }
        watchDates.removeFirst();
        return movieIds.removeFirst();
    }

    // Check if a movie is in the recently watched list
    public boolean contains(String movieId) {
        return movieIds.contains(movieId);
    }

    // Get the watch date for a specific movie
    public Date getWatchDateForMovie(String movieId) {
        int index = movieIds.indexOf(movieId);
        if (index >= 0) {
            return watchDates.get(index);
        }
        return null;
    }

    // Get the number of movies in the recently watched list
    public int size() {
        return movieIds.size();
    }

    // Clear the recently watched list
    public void clear() {
        movieIds.clear();
        watchDates.clear();
    }

    // Convert to string representation for file storage
    public String toFileString() {
        StringBuilder sb = new StringBuilder();
        sb.append(userId).append(",").append(maxSize);

        for (int i = 0; i < movieIds.size(); i++) {
            sb.append(",").append(movieIds.get(i))
                    .append(",").append(watchDates.get(i).getTime());
        }

        return sb.toString();
    }

    // Create RecentlyWatched from string representation (from file)
    public static RecentlyWatched fromFileString(String fileString) {
        String[] parts = fileString.split(",");

        if (parts.length >= 2) {
            String userId = parts[0];
            int maxSize = Integer.parseInt(parts[1]);

            RecentlyWatched recentlyWatched = new RecentlyWatched(userId, maxSize);

            // Parse movie IDs and watch dates
            for (int i = 2; i < parts.length; i += 2) {
                if (i + 1 < parts.length) {
                    String movieId = parts[i];
                    Date watchDate = new Date(Long.parseLong(parts[i + 1]));

                    recentlyWatched.movieIds.add(movieId);
                    recentlyWatched.watchDates.add(watchDate);
                }
            }

            return recentlyWatched;
        }

        return null;
    }
}
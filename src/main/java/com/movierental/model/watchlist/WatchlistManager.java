package com.movierental.model.watchlist;

import java.io.*;
import java.util.*;

import com.movierental.model.movie.Movie;
import com.movierental.model.movie.MovieManager;

/**
 * WatchlistManager class handles all watchlist related operations
 */
public class WatchlistManager {
    private static final String WATCHLIST_FILE_PATH = "data/watchlists.txt";
    private static final String RECENTLY_WATCHED_FILE_PATH = "data/recently_watched.txt";

    private List<Watchlist> watchlists;
    private Map<String, RecentlyWatched> recentlyWatchedMap; // userId -> RecentlyWatched

    // Constructor
    public WatchlistManager() {
        watchlists = new ArrayList<>();
        recentlyWatchedMap = new HashMap<>();
        loadWatchlists();
        loadRecentlyWatched();
    }

    // Load watchlists from file
    private void loadWatchlists() {
        File file = new File(WATCHLIST_FILE_PATH);

        // Create directory if it doesn't exist
        file.getParentFile().mkdirs();

        if (!file.exists()) {
            try {
                file.createNewFile();
            } catch (IOException e) {
                System.err.println("Error creating watchlists file: " + e.getMessage());
            }
            return;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) {
                    continue;
                }

                Watchlist watchlist = Watchlist.fromFileString(line);
                if (watchlist != null) {
                    watchlists.add(watchlist);
                }
            }
        } catch (IOException e) {
            System.err.println("Error loading watchlists: " + e.getMessage());
        }
    }

    // Save watchlists to file
    private void saveWatchlists() {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(WATCHLIST_FILE_PATH))) {
            for (Watchlist watchlist : watchlists) {
                writer.write(watchlist.toFileString());
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error saving watchlists: " + e.getMessage());
        }
    }

    // Load recently watched from file
    private void loadRecentlyWatched() {
        File file = new File(RECENTLY_WATCHED_FILE_PATH);

        // Create directory if it doesn't exist
        file.getParentFile().mkdirs();

        if (!file.exists()) {
            try {
                file.createNewFile();
            } catch (IOException e) {
                System.err.println("Error creating recently watched file: " + e.getMessage());
            }
            return;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) {
                    continue;
                }

                RecentlyWatched recentlyWatched = RecentlyWatched.fromFileString(line);
                if (recentlyWatched != null) {
                    recentlyWatchedMap.put(recentlyWatched.getUserId(), recentlyWatched);
                }
            }
        } catch (IOException e) {
            System.err.println("Error loading recently watched: " + e.getMessage());
        }
    }

    // Save recently watched to file
    private void saveRecentlyWatched() {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(RECENTLY_WATCHED_FILE_PATH))) {
            for (RecentlyWatched recentlyWatched : recentlyWatchedMap.values()) {
                writer.write(recentlyWatched.toFileString());
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error saving recently watched: " + e.getMessage());
        }
    }

    // Add a movie to watchlist
    public Watchlist addToWatchlist(String userId, String movieId, int priority, String notes) {
        // Check if movie exists
        MovieManager movieManager = new MovieManager();
        Movie movie = movieManager.getMovieById(movieId);

        if (movie == null) {
            return null; // Movie doesn't exist
        }

        // Check if already in watchlist
        for (Watchlist watchlist : watchlists) {
            if (watchlist.getUserId().equals(userId) && watchlist.getMovieId().equals(movieId)) {
                return watchlist; // Already in watchlist
            }
        }

        // Create a new watchlist entry
        Watchlist watchlist = new Watchlist();
        watchlist.setWatchlistId(UUID.randomUUID().toString());
        watchlist.setUserId(userId);
        watchlist.setMovieId(movieId);
        watchlist.setAddedDate(new Date());
        watchlist.setWatched(false);
        watchlist.setWatchedDate(null);
        watchlist.setPriority(priority);
        watchlist.setNotes(notes);

        // Add to list and save
        watchlists.add(watchlist);
        saveWatchlists();

        return watchlist;
    }

    // Get all movies in a user's watchlist
    public List<Watchlist> getWatchlistByUser(String userId) {
        List<Watchlist> userWatchlist = new ArrayList<>();

        for (Watchlist watchlist : watchlists) {
            if (watchlist.getUserId().equals(userId)) {
                userWatchlist.add(watchlist);
            }
        }

        return userWatchlist;
    }

    // Get unwatched movies in a user's watchlist
    public List<Watchlist> getUnwatchedByUser(String userId) {
        List<Watchlist> unwatched = new ArrayList<>();

        for (Watchlist watchlist : watchlists) {
            if (watchlist.getUserId().equals(userId) && !watchlist.isWatched()) {
                unwatched.add(watchlist);
            }
        }

        return unwatched;
    }

    // Get watched movies in a user's watchlist
    public List<Watchlist> getWatchedByUser(String userId) {
        List<Watchlist> watched = new ArrayList<>();

        for (Watchlist watchlist : watchlists) {
            if (watchlist.getUserId().equals(userId) && watchlist.isWatched()) {
                watched.add(watchlist);
            }
        }

        return watched;
    }

    // Check if a movie is in a user's watchlist
    public boolean isInWatchlist(String userId, String movieId) {
        for (Watchlist watchlist : watchlists) {
            if (watchlist.getUserId().equals(userId) && watchlist.getMovieId().equals(movieId)) {
                return true;
            }
        }

        return false;
    }

    // Get a specific watchlist entry
    public Watchlist getWatchlistById(String watchlistId) {
        for (Watchlist watchlist : watchlists) {
            if (watchlist.getWatchlistId().equals(watchlistId)) {
                return watchlist;
            }
        }

        return null;
    }

    // Get a user's watchlist entry for a specific movie
    public Watchlist getWatchlistByUserAndMovie(String userId, String movieId) {
        for (Watchlist watchlist : watchlists) {
            if (watchlist.getUserId().equals(userId) && watchlist.getMovieId().equals(movieId)) {
                return watchlist;
            }
        }

        return null;
    }

    // Update watchlist entry
    public boolean updateWatchlist(Watchlist watchlist) {
        for (int i = 0; i < watchlists.size(); i++) {
            if (watchlists.get(i).getWatchlistId().equals(watchlist.getWatchlistId())) {
                watchlists.set(i, watchlist);
                saveWatchlists();
                return true;
            }
        }

        return false;
    }

    // Mark movie as watched
    public boolean markAsWatched(String watchlistId) {
        Watchlist watchlist = getWatchlistById(watchlistId);

        if (watchlist == null) {
            return false;
        }

        watchlist.markAsWatched();
        saveWatchlists();

        // Add to recently watched
        addToRecentlyWatched(watchlist.getUserId(), watchlist.getMovieId());

        return true;
    }

    // Remove from watchlist
    public boolean removeFromWatchlist(String watchlistId) {
        for (int i = 0; i < watchlists.size(); i++) {
            if (watchlists.get(i).getWatchlistId().equals(watchlistId)) {
                watchlists.remove(i);
                saveWatchlists();
                return true;
            }
        }

        return false;
    }

    // Remove movie from a user's watchlist
    public boolean removeFromWatchlist(String userId, String movieId) {
        for (int i = 0; i < watchlists.size(); i++) {
            if (watchlists.get(i).getUserId().equals(userId) &&
                    watchlists.get(i).getMovieId().equals(movieId)) {
                watchlists.remove(i);
                saveWatchlists();
                return true;
            }
        }

        return false;
    }

    // Get a user's recently watched
    public RecentlyWatched getRecentlyWatched(String userId) {
        if (recentlyWatchedMap.containsKey(userId)) {
            return recentlyWatchedMap.get(userId);
        } else {
            // Create new entry if doesn't exist
            RecentlyWatched recentlyWatched = new RecentlyWatched(userId);
            recentlyWatchedMap.put(userId, recentlyWatched);
            saveRecentlyWatched();
            return recentlyWatched;
        }
    }

    // Add to recently watched
    public void addToRecentlyWatched(String userId, String movieId) {
        RecentlyWatched recentlyWatched = getRecentlyWatched(userId);
        recentlyWatched.addMovie(movieId);
        saveRecentlyWatched();
    }

    // Clear a user's recently watched
    public void clearRecentlyWatched(String userId) {
        if (recentlyWatchedMap.containsKey(userId)) {
            recentlyWatchedMap.get(userId).clear();
            saveRecentlyWatched();
        }
    }

    // Get all watchlists
    public List<Watchlist> getAllWatchlists() {
        return new ArrayList<>(watchlists);
    }

    // Sort watchlist by priority
    public List<Watchlist> sortByPriority(List<Watchlist> watchlistToSort) {
        List<Watchlist> sorted = new ArrayList<>(watchlistToSort);
        Collections.sort(sorted, new Comparator<Watchlist>() {
            @Override
            public int compare(Watchlist w1, Watchlist w2) {
                return Integer.compare(w1.getPriority(), w2.getPriority());
            }
        });
        return sorted;
    }

    // Sort watchlist by date added
    public List<Watchlist> sortByDateAdded(List<Watchlist> watchlistToSort, boolean ascending) {
        List<Watchlist> sorted = new ArrayList<>(watchlistToSort);
        Collections.sort(sorted, new Comparator<Watchlist>() {
            @Override
            public int compare(Watchlist w1, Watchlist w2) {
                return ascending ?
                        w1.getAddedDate().compareTo(w2.getAddedDate()) :
                        w2.getAddedDate().compareTo(w1.getAddedDate());
            }
        });
        return sorted;
    }

    // Get count of movies in watchlist
    public int getWatchlistCount(String userId) {
        int count = 0;
        for (Watchlist watchlist : watchlists) {
            if (watchlist.getUserId().equals(userId)) {
                count++;
            }
        }
        return count;
    }

    // Get count of unwatched movies
    public int getUnwatchedCount(String userId) {
        int count = 0;
        for (Watchlist watchlist : watchlists) {
            if (watchlist.getUserId().equals(userId) && !watchlist.isWatched()) {
                count++;
            }
        }
        return count;
    }

    // Get count of watched movies
    public int getWatchedCount(String userId) {
        int count = 0;
        for (Watchlist watchlist : watchlists) {
            if (watchlist.getUserId().equals(userId) && watchlist.isWatched()) {
                count++;
            }
        }
        return count;
    }
}
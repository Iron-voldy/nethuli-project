package com.movierental.model.watchlist;

import java.io.*;
import java.util.*;

import javax.servlet.ServletContext;

import com.movierental.model.movie.Movie;
import com.movierental.model.movie.MovieManager;

/**
 * WatchlistManager class handles all watchlist related operations
 */
public class WatchlistManager {
    private static final String WATCHLIST_FILE_NAME = "watchlists.txt";
    private static final String RECENTLY_WATCHED_FILE_NAME = "recently_watched.txt";

    private String watchlistFilePath;
    private String recentlyWatchedFilePath;
    private List<Watchlist> watchlists;
    private Map<String, RecentlyWatched> recentlyWatchedMap; // userId -> RecentlyWatched
    private ServletContext servletContext;

    // Constructor without ServletContext
    public WatchlistManager() {
        this(null);
    }

    // Constructor with ServletContext
    public WatchlistManager(ServletContext servletContext) {
        this.servletContext = servletContext;
        watchlists = new ArrayList<>();
        recentlyWatchedMap = new HashMap<>();
        initializeFilePaths();
        loadWatchlists();
        loadRecentlyWatched();
    }

    // Initialize file paths
    private void initializeFilePaths() {
        if (servletContext != null) {
            // Use WEB-INF/data within the application context
            String webInfDataPath = "/WEB-INF/data";
            watchlistFilePath = servletContext.getRealPath(webInfDataPath) + File.separator + WATCHLIST_FILE_NAME;
            recentlyWatchedFilePath = servletContext.getRealPath(webInfDataPath) + File.separator + RECENTLY_WATCHED_FILE_NAME;

            // Ensure directories exist
            File dataDir = new File(servletContext.getRealPath(webInfDataPath));
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created WEB-INF/data directory: " + dataDir.getAbsolutePath() + " - Success: " + created);
            }
        } else {
            // Fallback to simple data directory if not in web context
            String dataPath = "data";
            watchlistFilePath = dataPath + File.separator + WATCHLIST_FILE_NAME;
            recentlyWatchedFilePath = dataPath + File.separator + RECENTLY_WATCHED_FILE_NAME;

            // Ensure directories exist
            File dataDir = new File(dataPath);
            if (!dataDir.exists()) {
                boolean created = dataDir.mkdirs();
                System.out.println("Created fallback data directory: " + dataPath + " - Success: " + created);
            }
        }

        System.out.println("WatchlistManager: Using watchlist file path: " + watchlistFilePath);
        System.out.println("WatchlistManager: Using recently watched file path: " + recentlyWatchedFilePath);
    }

    // Load watchlists from file
    private void loadWatchlists() {
        File file = new File(watchlistFilePath);

        // Create directory if it doesn't exist
        if (file.getParentFile() != null) {
            file.getParentFile().mkdirs();
        }

        if (!file.exists()) {
            try {
                file.createNewFile();
                System.out.println("Created new watchlists file: " + watchlistFilePath);
            } catch (IOException e) {
                System.err.println("Error creating watchlists file: " + e.getMessage());
                e.printStackTrace();
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
            System.out.println("Loaded " + watchlists.size() + " watchlist entries");
        } catch (IOException e) {
            System.err.println("Error loading watchlists: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Save watchlists to file
    private void saveWatchlists() {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(watchlistFilePath))) {
            for (Watchlist watchlist : watchlists) {
                writer.write(watchlist.toFileString());
                writer.newLine();
            }
            System.out.println("Saved " + watchlists.size() + " watchlist entries");
        } catch (IOException e) {
            System.err.println("Error saving watchlists: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Load recently watched from file
    private void loadRecentlyWatched() {
        File file = new File(recentlyWatchedFilePath);

        // Create directory if it doesn't exist
        if (file.getParentFile() != null) {
            file.getParentFile().mkdirs();
        }

        if (!file.exists()) {
            try {
                file.createNewFile();
                System.out.println("Created new recently watched file: " + recentlyWatchedFilePath);
            } catch (IOException e) {
                System.err.println("Error creating recently watched file: " + e.getMessage());
                e.printStackTrace();
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
            System.out.println("Loaded " + recentlyWatchedMap.size() + " recently watched entries");
        } catch (IOException e) {
            System.err.println("Error loading recently watched: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Save recently watched to file
    private void saveRecentlyWatched() {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(recentlyWatchedFilePath))) {
            for (RecentlyWatched recentlyWatched : recentlyWatchedMap.values()) {
                writer.write(recentlyWatched.toFileString());
                writer.newLine();
            }
            System.out.println("Saved " + recentlyWatchedMap.size() + " recently watched entries");
        } catch (IOException e) {
            System.err.println("Error saving recently watched: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Add a movie to watchlist
    public Watchlist addToWatchlist(String userId, String movieId, int priority, String notes) {
        System.out.println("Adding to watchlist - User ID: " + userId + ", Movie ID: " + movieId);

        // Check if movie exists
        MovieManager movieManager = new MovieManager(servletContext);
        Movie movie = movieManager.getMovieById(movieId);

        if (movie == null) {
            System.out.println("Movie not found: " + movieId);
            return null; // Movie doesn't exist
        }

        // Check if already in watchlist
        for (Watchlist watchlist : watchlists) {
            if (watchlist.getUserId().equals(userId) && watchlist.getMovieId().equals(movieId)) {
                System.out.println("Movie already in watchlist");
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

        System.out.println("Added to watchlist successfully");
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

    // Set ServletContext (can be used to update the context after initialization)
    public void setServletContext(ServletContext servletContext) {
        this.servletContext = servletContext;
        initializeFilePaths();
        // Reload data with the new file paths
        watchlists.clear();
        recentlyWatchedMap.clear();
        loadWatchlists();
        loadRecentlyWatched();
    }
}
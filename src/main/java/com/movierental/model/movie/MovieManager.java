package com.movierental.model.movie;

import java.io.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * MovieManager class handles all movie-related operations
 */
public class MovieManager {
    private static final String MOVIE_FILE_PATH = "data/movies.txt";
    private List<Movie> movies;

    // Constructor
    public MovieManager() {
        movies = new ArrayList<>();
        loadMovies();
    }

    // Load movies from file
    private void loadMovies() {
        File file = new File(MOVIE_FILE_PATH);

        // Create directory if it doesn't exist
        file.getParentFile().mkdirs();

        if (!file.exists()) {
            try {
                file.createNewFile();
            } catch (IOException e) {
                System.err.println("Error creating movies file: " + e.getMessage());
            }
            return;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) {
                    continue;
                }

                Movie movie = null;
                if (line.startsWith("NEW_RELEASE,")) {
                    movie = NewRelease.fromFileString(line);
                } else if (line.startsWith("CLASSIC,")) {
                    movie = ClassicMovie.fromFileString(line);
                } else if (line.startsWith("REGULAR,")) {
                    movie = Movie.fromFileString(line);
                }

                if (movie != null) {
                    movies.add(movie);
                }
            }
        } catch (IOException e) {
            System.err.println("Error loading movies: " + e.getMessage());
        }
    }

    // Save movies to file
    private void saveMovies() {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(MOVIE_FILE_PATH))) {
            for (Movie movie : movies) {
                writer.write(movie.toFileString());
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error saving movies: " + e.getMessage());
        }
    }

    // Add a new movie
    public boolean addMovie(Movie movie) {
        // Generate a unique ID if not provided
        if (movie.getMovieId() == null || movie.getMovieId().isEmpty()) {
            movie.setMovieId(UUID.randomUUID().toString());
        }

        movies.add(movie);
        saveMovies();
        return true;
    }

    // Add a new regular movie
    public Movie addRegularMovie(String title, String director, String genre,
                                 int releaseYear, double rating) {
        Movie movie = new Movie();
        movie.setMovieId(UUID.randomUUID().toString());
        movie.setTitle(title);
        movie.setDirector(director);
        movie.setGenre(genre);
        movie.setReleaseYear(releaseYear);
        movie.setRating(rating);
        movie.setAvailable(true);

        movies.add(movie);
        saveMovies();
        return movie;
    }

    // Add a new release movie
    public NewRelease addNewRelease(String title, String director, String genre,
                                    int releaseYear, double rating) {
        NewRelease movie = new NewRelease();
        movie.setMovieId(UUID.randomUUID().toString());
        movie.setTitle(title);
        movie.setDirector(director);
        movie.setGenre(genre);
        movie.setReleaseYear(releaseYear);
        movie.setRating(rating);
        movie.setAvailable(true);
        movie.setReleaseDate(new Date());

        movies.add(movie);
        saveMovies();
        return movie;
    }

    // Add a classic movie
    public ClassicMovie addClassicMovie(String title, String director, String genre,
                                        int releaseYear, double rating,
                                        String significance, boolean hasAwards) {
        ClassicMovie movie = new ClassicMovie();
        movie.setMovieId(UUID.randomUUID().toString());
        movie.setTitle(title);
        movie.setDirector(director);
        movie.setGenre(genre);
        movie.setReleaseYear(releaseYear);
        movie.setRating(rating);
        movie.setAvailable(true);
        movie.setSignificance(significance);
        movie.setHasAwards(hasAwards);

        movies.add(movie);
        saveMovies();
        return movie;
    }

    // Get movie by ID
    public Movie getMovieById(String movieId) {
        for (Movie movie : movies) {
            if (movie.getMovieId().equals(movieId)) {
                return movie;
            }
        }
        return null;
    }

    // Get all movies
    public List<Movie> getAllMovies() {
        return new ArrayList<>(movies);
    }

    // Search movies by title
    public List<Movie> searchByTitle(String titleQuery) {
        List<Movie> results = new ArrayList<>();
        String query = titleQuery.toLowerCase();

        for (Movie movie : movies) {
            if (movie.getTitle().toLowerCase().contains(query)) {
                results.add(movie);
            }
        }

        return results;
    }

    // Search movies by director
    public List<Movie> searchByDirector(String directorQuery) {
        List<Movie> results = new ArrayList<>();
        String query = directorQuery.toLowerCase();

        for (Movie movie : movies) {
            if (movie.getDirector().toLowerCase().contains(query)) {
                results.add(movie);
            }
        }

        return results;
    }

    // Search movies by genre
    public List<Movie> searchByGenre(String genreQuery) {
        List<Movie> results = new ArrayList<>();
        String query = genreQuery.toLowerCase();

        for (Movie movie : movies) {
            if (movie.getGenre().toLowerCase().contains(query)) {
                results.add(movie);
            }
        }

        return results;
    }

    // Get available movies
    public List<Movie> getAvailableMovies() {
        List<Movie> results = new ArrayList<>();

        for (Movie movie : movies) {
            if (movie.isAvailable()) {
                results.add(movie);
            }
        }

        return results;
    }

    // Update movie details
    public boolean updateMovie(Movie updatedMovie) {
        for (int i = 0; i < movies.size(); i++) {
            if (movies.get(i).getMovieId().equals(updatedMovie.getMovieId())) {
                movies.set(i, updatedMovie);
                saveMovies();
                return true;
            }
        }
        return false;
    }

    // Update movie availability
    public boolean updateAvailability(String movieId, boolean available) {
        Movie movie = getMovieById(movieId);
        if (movie != null) {
            movie.setAvailable(available);
            saveMovies();
            return true;
        }
        return false;
    }

    // Delete movie
    public boolean deleteMovie(String movieId) {
        for (int i = 0; i < movies.size(); i++) {
            if (movies.get(i).getMovieId().equals(movieId)) {
                movies.remove(i);
                saveMovies();
                return true;
            }
        }
        return false;
    }

    // Sort movies by rating (bubble sort implementation)
    public List<Movie> sortByRating() {
        List<Movie> sortedMovies = new ArrayList<>(movies);
        int n = sortedMovies.size();

        for (int i = 0; i < n - 1; i++) {
            for (int j = 0; j < n - i - 1; j++) {
                if (sortedMovies.get(j).getRating() < sortedMovies.get(j + 1).getRating()) {
                    // Swap movies
                    Movie temp = sortedMovies.get(j);
                    sortedMovies.set(j, sortedMovies.get(j + 1));
                    sortedMovies.set(j + 1, temp);
                }
            }
        }

        return sortedMovies;
    }

    // Get top rated movies
    public List<Movie> getTopRatedMovies(int count) {
        List<Movie> sortedMovies = sortByRating();
        int limit = Math.min(count, sortedMovies.size());
        return sortedMovies.subList(0, limit);
    }
}
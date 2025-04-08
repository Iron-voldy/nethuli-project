<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.movie.Movie" %>
<%@ page import="com.movierental.model.movie.NewRelease" %>
<%@ page import="com.movierental.model.movie.ClassicMovie" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!-- Include Admin Header -->
<%@ include file="../includes/header.jsp" %>

<%
    Movie movie = (Movie) request.getAttribute("movie");
    String movieType = (String) request.getAttribute("movieType");

    // Get type-specific properties
    boolean isNewRelease = "newRelease".equals(movieType);
    boolean isClassic = "classic".equals(movieType);

    // Format for release date if applicable
    String releaseDate = "";
    if (isNewRelease) {
        NewRelease newRelease = (NewRelease) movie;
        releaseDate = new SimpleDateFormat("yyyy-MM-dd").format(newRelease.getReleaseDate());
    }

    // Get classic-specific fields if applicable
    String significance = "";
    boolean hasAwards = false;
    if (isClassic) {
        ClassicMovie classicMovie = (ClassicMovie) movie;
        significance = classicMovie.getSignificance();
        hasAwards = classicMovie.hasAwards();
    }
%>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Edit Movie</h2>
    <a href="<%= request.getContextPath() %>/admin/movies" class="btn btn-outline-admin">
        <i class="bi bi-arrow-left me-2"></i> Back to Movies
    </a>
</div>

<div class="card">
    <div class="card-header">
        <i class="bi bi-film me-2"></i> Edit Movie Information
    </div>
    <div class="card-body">
        <form action="<%= request.getContextPath() %>/admin/movies" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="movieId" value="<%= movie.getMovieId() %>">
            <input type="hidden" name="movieType" value="<%= movieType %>">

            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="title" class="form-label">Movie Title</label>
                    <input type="text" class="form-control" id="title" name="title" value="<%= movie.getTitle() %>" required>
                </div>
                <div class="col-md-6">
                    <label for="director" class="form-label">Director</label>
                    <input type="text" class="form-control" id="director" name="director" value="<%= movie.getDirector() %>" required>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-4">
                    <label for="genre" class="form-label">Genre</label>
                    <input type="text" class="form-control" id="genre" name="genre" value="<%= movie.getGenre() %>" required>
                </div>
                <div class="col-md-4">
                    <label for="releaseYear" class="form-label">Release Year</label>
                    <input type="number" class="form-control" id="releaseYear" name="releaseYear" min="1900" max="2099" value="<%= movie.getReleaseYear() %>" required>
                </div>
                <div class="col-md-4">
                    <label for="rating" class="form-label">Rating (0-10)</label>
                    <input type="number" class="form-control" id="rating" name="rating" min="0" max="10" step="0.1" value="<%= movie.getRating() %>" required>
                </div>
            </div>

            <div class="mb-3 form-check">
                <input type="checkbox" class="form-check-input" id="available" name="available" <%= movie.isAvailable() ? "checked" : "" %>>
                <label class="form-check-label" for="available">Available for Rent</label>
            </div>

            <!-- New Release specific fields -->
            <% if (isNewRelease) { %>
            <div class="mb-3" id="newReleaseFields">
                <label for="releaseDate" class="form-label">Release Date</label>
                <input type="date" class="form-control" id="releaseDate" name="releaseDate" value="<%= releaseDate %>">
            </div>
            <% } %>

            <!-- Classic Movie specific fields -->
            <% if (isClassic) { %>
            <div id="classicFields">
                <div class="mb-3">
                    <label for="significance" class="form-label">Historical/Cultural Significance</label>
                    <textarea class="form-control" id="significance" name="significance" rows="3"><%= significance %></textarea>
                </div>
                <div class="mb-3 form-check">
                    <input type="checkbox" class="form-check-input" id="hasAwards" name="hasAwards" <%= hasAwards ? "checked" : "" %>>
                    <label class="form-check-label" for="hasAwards">Has Major Awards</label>
                </div>
            </div>
            <% } %>

            <div class="row mb-3">
                <div class="col-md-8">
                    <label for="coverPhoto" class="form-label">Cover Photo</label>
                    <input type="file" class="form-control" id="coverPhoto" name="coverPhoto" accept="image/*">
                    <div class="form-text">Upload a new image to replace the current cover photo (JPG, PNG, GIF). Max 5MB.</div>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Current Cover Photo</label>
                    <div>
                        <% if (movie.getCoverPhotoPath() != null && !movie.getCoverPhotoPath().isEmpty()) { %>
                            <img src="<%= request.getContextPath() %>/image-servlet?movieId=<%= movie.getMovieId() %>"
                                 style="max-width: 100px; max-height: 150px; object-fit: contain;" alt="Current Cover">
                        <% } else { %>
                            <div class="text-secondary">No cover photo</div>
                        <% } %>
                    </div>
                </div>
            </div>

            <div class="mb-3">
                <div id="imagePreview" class="mt-2" style="display: none;">
                    <p>New Image Preview:</p>
                    <img src="" id="preview" style="max-width: 100px; max-height: 150px; object-fit: contain;">
                </div>
            </div>

            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                <a href="<%= request.getContextPath() %>/admin/movies" class="btn btn-secondary me-md-2">
                    <i class="bi bi-x-circle me-2"></i> Cancel
                </a>
                <button type="submit" class="btn btn-admin">
                    <i class="bi bi-save me-2"></i> Save Changes
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    // Image preview
    document.getElementById('coverPhoto').addEventListener('change', function(event) {
        const file = event.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('preview').src = e.target.result;
                document.getElementById('imagePreview').style.display = 'block';
            }
            reader.readAsDataURL(file);
        } else {
            document.getElementById('imagePreview').style.display = 'none';
        }
    });
</script>

<!-- Include Admin Footer -->
<%@ include file="../includes/footer.jsp" %>
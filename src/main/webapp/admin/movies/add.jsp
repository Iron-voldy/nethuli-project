<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Include Admin Header -->
<%@ include file="../includes/header.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Add New Movie</h2>
    <a href="<%= request.getContextPath() %>/admin/movies" class="btn btn-outline-admin">
        <i class="bi bi-arrow-left me-2"></i> Back to Movies
    </a>
</div>

<div class="card">
    <div class="card-header">
        <i class="bi bi-film me-2"></i> Movie Information
    </div>
    <div class="card-body">
        <form action="<%= request.getContextPath() %>/admin/movies" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="add">

            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="title" class="form-label">Movie Title</label>
                    <input type="text" class="form-control" id="title" name="title" required>
                </div>
                <div class="col-md-6">
                    <label for="director" class="form-label">Director</label>
                    <input type="text" class="form-control" id="director" name="director" required>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-4">
                    <label for="genre" class="form-label">Genre</label>
                    <input type="text" class="form-control" id="genre" name="genre" required>
                </div>
                <div class="col-md-4">
                    <label for="releaseYear" class="form-label">Release Year</label>
                    <input type="number" class="form-control" id="releaseYear" name="releaseYear" min="1900" max="2099" required>
                </div>
                <div class="col-md-4">
                    <label for="rating" class="form-label">Rating (0-10)</label>
                    <input type="number" class="form-control" id="rating" name="rating" min="0" max="10" step="0.1" required>
                </div>
            </div>

            <div class="mb-3">
                <label for="movieType" class="form-label">Movie Type</label>
                <select class="form-select" id="movieType" name="movieType" onchange="toggleTypeFields()">
                    <option value="regular">Regular</option>
                    <option value="newRelease">New Release</option>
                    <option value="classic">Classic</option>
                </select>
            </div>

            <!-- New Release specific fields -->
            <div class="mb-3" id="newReleaseFields" style="display: none;">
                <label for="releaseDate" class="form-label">Release Date</label>
                <input type="date" class="form-control" id="releaseDate" name="releaseDate">
            </div>

            <!-- Classic Movie specific fields -->
            <div id="classicFields" style="display: none;">
                <div class="mb-3">
                    <label for="significance" class="form-label">Historical/Cultural Significance</label>
                    <textarea class="form-control" id="significance" name="significance" rows="3"></textarea>
                </div>
                <div class="mb-3 form-check">
                    <input type="checkbox" class="form-check-input" id="hasAwards" name="hasAwards">
                    <label class="form-check-label" for="hasAwards">Has Major Awards</label>
                </div>
            </div>

            <div class="mb-3">
                <label for="coverPhoto" class="form-label">Cover Photo</label>
                <input type="file" class="form-control" id="coverPhoto" name="coverPhoto" accept="image/*">
                <div class="form-text">Upload an image for the movie cover (JPG, PNG, GIF). Max 5MB.</div>
            </div>

            <div class="mb-3">
                <div id="imagePreview" class="mt-2" style="display: none;">
                    <p>Image Preview:</p>
                    <img src="" id="preview" style="max-width: 200px; max-height: 300px; object-fit: contain;">
                </div>
            </div>

            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                <button type="reset" class="btn btn-secondary">
                    <i class="bi bi-arrow-counterclockwise me-2"></i> Reset
                </button>
                <button type="submit" class="btn btn-admin">
                    <i class="bi bi-save me-2"></i> Add Movie
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    // Function to toggle type-specific fields
    function toggleTypeFields() {
        const movieType = document.getElementById('movieType').value;
        const newReleaseFields = document.getElementById('newReleaseFields');
        const classicFields = document.getElementById('classicFields');

        // Hide all fields first
        newReleaseFields.style.display = 'none';
        classicFields.style.display = 'none';

        // Show relevant fields based on type
        if (movieType === 'newRelease') {
            newReleaseFields.style.display = 'block';
        } else if (movieType === 'classic') {
            classicFields.style.display = 'block';
        }
    }

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
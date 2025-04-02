<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.movierental.model.user.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FilmFlux - Your Ultimate Movie Rental Platform</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Neon Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

    <style>
        :root {
            /* Dark Theme Variables */
            --background-dark: #121212;
            --card-dark: #1E1E1E;
            --text-primary: #E0E0E0;
            --text-secondary: #A0A0A0;

            /* Neon Colors */
            --neon-blue: #00C8FF;
            --neon-purple: #8A2BE2;
            --neon-pink: #FF00FF;
            --neon-green: #39FF14;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--background-dark);
            color: var(--text-primary);
            line-height: 1.6;
            overflow-x: hidden;
        }

        /* Hero Section Styles */
        .hero-section {
            min-height: 100vh;
            display: flex;
            align-items: center;
            position: relative;
            overflow: hidden;
            background:
                linear-gradient(135deg, rgba(0, 200, 255, 0.1), rgba(138, 43, 226, 0.1)),
                var(--background-dark);
        }

        .hero-content {
            position: relative;
            z-index: 2;
        }

        .hero-title {
            font-size: 3.5rem;
            font-weight: 700;
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            text-shadow: 0 0 20px rgba(0, 200, 255, 0.3);
        }

        .hero-subtitle {
            color: var(--text-secondary);
            font-size: 1.2rem;
            margin-bottom: 30px;
        }

        /* Neon Button Styles */
        .btn-neon {
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            color: white;
            border: none;
            padding: 12px 30px;
            font-weight: 600;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .btn-neon::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(
                120deg,
                transparent,
                rgba(255,255,255,0.3),
                transparent
            );
            transition: all 0.6s;
        }

        .btn-neon:hover::before {
            left: 100%;
        }

        .btn-neon:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 200, 255, 0.4);
        }

        /* Features Section */
        .features-section {
            background-color: var(--card-dark);
            padding: 80px 0;
        }

        .feature-card {
            background: rgba(30, 30, 30, 0.7);
            border: 1px solid #333;
            border-radius: 15px;
            padding: 30px;
            text-align: center;
            transition: transform 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0, 200, 255, 0.2);
        }

        .feature-icon {
            font-size: 3rem;
            background: linear-gradient(to right, var(--neon-blue), var(--neon-purple));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            margin-bottom: 20px;
        }

        /* Lightning Background Effect */
        .lightning-bg {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            opacity: 0.2;
            z-index: 1;
        }

        .lightning-bg::before,
        .lightning-bg::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background:
                radial-gradient(circle at 90% 10%, rgba(0, 200, 255, 0.15) 0%, transparent 30%),
                radial-gradient(circle at 10% 90%, rgba(255, 0, 255, 0.1) 0%, transparent 30%);
            animation: lightning 10s infinite;
        }

        @keyframes lightning {
            0%, 100% { opacity: 0.2; }
            50% { opacity: 0.4; }
        }

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.5rem;
            }
        }
    </style>
</head>
<body>
    <%
        // Check if user is logged in
        User user = (User) session.getAttribute("user");
    %>

    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark fixed-top" style="background-color: rgba(30, 30, 30, 0.8); backdrop-filter: blur(10px);">
        <div class="container">
            <a class="navbar-brand" href="#" style="background: linear-gradient(to right, var(--neon-blue), var(--neon-purple)); -webkit-background-clip: text; background-clip: text; color: transparent;">
                FilmFlux
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="#features">Features</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#how-it-works">How It Works</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <% if (user == null) { %>
                        <li class="nav-item">
                            <a href="/login" class="nav-link">Login</a>
                        </li>
                        <li class="nav-item">
                            <a href="/register" class="nav-link btn btn-neon">Sign Up</a>
                        </li>
                    <% } else { %>
                        <li class="nav-item">
                            <a href="/search-movie" class="nav-link">Browse Movies</a>
                        </li>
                        <li class="nav-item">
                            <a href="/user/profile.jsp" class="nav-link">
                                <i class="bi bi-person-circle me-2"></i><%= user.getUsername() %>
                            </a>
                        </li>
                    <% } %>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="lightning-bg"></div>
        <div class="container hero-content">
            <div class="row align-items-center">
                <div class="col-lg-7">
                    <h1 class="hero-title mb-4">Welcome to FilmFlux</h1>
                    <p class="hero-subtitle">
                        Experience movies like never before. Stream, rent, and discover
                        your next favorite film with our cutting-edge platform.
                    </p>
                    <div class="d-flex gap-3">
                        <% if (user == null) { %>
                            <a href="${pageContext.request.contextPath}/register" class="nav-link btn btn-neon">Sign Up</a>
                            <a href="${pageContext.request.contextPath}/login">Login</a>
                        <% } else { %>
                            <a href="${pageContext.request.contextPath}/search-movie" class="btn btn-neon">Browse Movies</a>
                            <a href="${pageContext.request.contextPath}/rental-history" class="btn btn-outline-light">My Rentals</a>
                        <% } %>
                    </div>
                </div>
                <div class="col-lg-5 d-none d-lg-block text-center">
                    <div style="background: rgba(30, 30, 30, 0.5); border-radius: 15px; padding: 30px;">
                        <i class="bi bi-film" style="font-size: 6rem; color: var(--neon-blue);"></i>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="features-section">
        <div class="container">
            <div class="text-center mb-5">
                <h2 style="color: var(--neon-blue);">Platform Features</h2>
                <p class="text-secondary">Discover what makes FilmFlux unique</p>
            </div>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="bi bi-search"></i>
                        </div>
                        <h4>Extensive Library</h4>
                        <p class="text-secondary">
                            Browse through thousands of movies across multiple genres.
                        </p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="bi bi-stars"></i>
                        </div>
                        <h4>Personalized Recommendations</h4>
                        <p class="text-secondary">
                            Get movie suggestions tailored to your viewing history.
                        </p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="bi bi-cloud-download"></i>
                        </div>
                        <h4>Easy Rental</h4>
                        <p class="text-secondary">
                            Rent and stream movies with just a few clicks.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer style="background-color: var(--card-dark); color: var(--text-secondary); padding: 40px 0;">
        <div class="container text-center">
            <p>&copy; 2024 FilmFlux. All Rights Reserved.</p>
            <div class="mt-3">
                <a href="#" class="text-secondary me-3">Privacy Policy</a>
                <a href="#" class="text-secondary me-3">Terms of Service</a>
                <a href="#" class="text-secondary">Contact Us</a>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
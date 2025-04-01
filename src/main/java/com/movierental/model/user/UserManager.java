package com.movierental.model.user;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * UserManager class handles all user-related operations
 */
public class UserManager {
    private static final String USER_FILE_PATH = "data/users.txt";
    private List<User> users;

    // Constructor
    public UserManager() {
        users = new ArrayList<>();
        loadUsers();
    }

    // Load users from file
    private void loadUsers() {
        File file = new File(USER_FILE_PATH);

        // Create directory if it doesn't exist
        file.getParentFile().mkdirs();

        if (!file.exists()) {
            try {
                file.createNewFile();
            } catch (IOException e) {
                System.err.println("Error creating users file: " + e.getMessage());
            }
            return;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) {
                    continue;
                }

                User user = null;
                if (line.startsWith("REGULAR,")) {
                    user = RegularUser.fromFileString(line);
                } else if (line.startsWith("PREMIUM,")) {
                    user = PremiumUser.fromFileString(line);
                } else {
                    user = User.fromFileString(line);
                }

                if (user != null) {
                    users.add(user);
                }
            }
        } catch (IOException e) {
            System.err.println("Error loading users: " + e.getMessage());
        }
    }

    // Save users to file
    private void saveUsers() {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(USER_FILE_PATH))) {
            for (User user : users) {
                writer.write(user.toFileString());
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error saving users: " + e.getMessage());
        }
    }

    // Add a new user
    public boolean addUser(User user) {
        // Check if username already exists
        if (getUserByUsername(user.getUsername()) != null) {
            return false;
        }

        // Generate a unique ID if not provided
        if (user.getUserId() == null || user.getUserId().isEmpty()) {
            user.setUserId(UUID.randomUUID().toString());
        }

        users.add(user);
        saveUsers();
        return true;
    }

    // Get user by ID
    public User getUserById(String userId) {
        for (User user : users) {
            if (user.getUserId().equals(userId)) {
                return user;
            }
        }
        return null;
    }

    // Get user by username
    public User getUserByUsername(String username) {
        for (User user : users) {
            if (user.getUsername().equals(username)) {
                return user;
            }
        }
        return null;
    }

    // Update user details
    public boolean updateUser(User updatedUser) {
        for (int i = 0; i < users.size(); i++) {
            if (users.get(i).getUserId().equals(updatedUser.getUserId())) {
                users.set(i, updatedUser);
                saveUsers();
                return true;
            }
        }
        return false;
    }

    // Delete user
    public boolean deleteUser(String userId) {
        for (int i = 0; i < users.size(); i++) {
            if (users.get(i).getUserId().equals(userId)) {
                users.remove(i);
                saveUsers();
                return true;
            }
        }
        return false;
    }

    // Get all users
    public List<User> getAllUsers() {
        return new ArrayList<>(users);
    }

    // Authenticate user
    public User authenticateUser(String username, String password) {
        User user = getUserByUsername(username);
        if (user != null && user.authenticate(password)) {
            return user;
        }
        return null;
    }

    // Upgrade regular user to premium
    public boolean upgradeToPremium(String userId) {
        User user = getUserById(userId);
        if (user != null && user instanceof RegularUser) {
            PremiumUser premiumUser = new PremiumUser(
                    user.getUserId(),
                    user.getUsername(),
                    user.getPassword(),
                    user.getEmail(),
                    user.getFullName()
            );

            return updateUser(premiumUser);
        }
        return false;
    }
}
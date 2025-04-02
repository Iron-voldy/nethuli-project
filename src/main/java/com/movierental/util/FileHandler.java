package com.movierental.util;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.List;

public class FileHandler {
    // Generic method to write content to a file
    public static void writeToFile(String filePath, String content, boolean append) {
        try {
            Files.write(
                    Paths.get(filePath),
                    content.getBytes(),
                    append ? StandardOpenOption.APPEND : StandardOpenOption.CREATE
            );
        } catch (IOException e) {
            System.err.println("Error writing to file: " + e.getMessage());
        }
    }

    // Generic method to read lines from a file
    public static List<String> readFromFile(String filePath) {
        List<String> lines = new ArrayList<>();
        try {
            lines = Files.readAllLines(Paths.get(filePath));
        } catch (IOException e) {
            System.err.println("Error reading from file: " + e.getMessage());
        }
        return lines;
    }

    // Method to create a directory if it doesn't exist
    public static void createDirectoryIfNotExists(String directoryPath) {
        try {
            Files.createDirectories(Paths.get(directoryPath));
        } catch (IOException e) {
            System.err.println("Error creating directory: " + e.getMessage());
        }
    }

    // Method to delete a file
    public static void deleteFile(String filePath) {
        try {
            Files.deleteIfExists(Paths.get(filePath));
        } catch (IOException e) {
            System.err.println("Error deleting file: " + e.getMessage());
        }
    }
}
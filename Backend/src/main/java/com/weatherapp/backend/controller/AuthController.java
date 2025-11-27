package com.weatherapp.backend.controller;

import com.weatherapp.backend.entity.User;
import com.weatherapp.backend.repository.UserRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class AuthController {

    private final UserRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    public AuthController(UserRepository userRepository) {
        this.userRepository = userRepository;
        this.passwordEncoder = new BCryptPasswordEncoder();
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody(required = false) Map<String, Object> credentials) {
        String username = credentials != null ? String.valueOf(credentials.get("username")) : "";
        String password = credentials != null ? String.valueOf(credentials.get("password")) : "";

        if (username == null || username.trim().isEmpty() || "null".equals(username)) {
            return ResponseEntity.badRequest().body(Map.of("error", "Username is required"));
        }

        if (password == null || password.trim().isEmpty() || "null".equals(password)) {
            return ResponseEntity.badRequest().body(Map.of("error", "Password is required"));
        }

        // Check against database
        Optional<User> userOpt = userRepository.findByUsername(username);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            String storedPassword = user.getPassword();

            System.out.println("Login attempt: username=" + username + ", input_password='" + password + "', stored_password='" + storedPassword + "'");

            // Check if password matches the stored password (using BCrypt)
            if (passwordEncoder.matches(password, storedPassword)) {
                return ResponseEntity.ok(Map.of("token", "demo-jwt-token-" + System.currentTimeMillis(), "message", "Login successful"));
            } else {
                System.out.println("Password mismatch!");
                return ResponseEntity.badRequest().body(Map.of("error", "Invalid password"));
            }
        } else {
            return ResponseEntity.badRequest().body(Map.of("error", "User not found"));
        }
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody Map<String, String> userData) {
        String username = userData.get("username");
        String password = userData.get("password");
        String email = userData.get("email"); // Optional, depending on frontend

        if (username == null || username.trim().isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("error", "Username is required"));
        }
        if (password == null || password.trim().isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("error", "Password is required"));
        }

        if (userRepository.existsByUsername(username)) {
            return ResponseEntity.badRequest().body(Map.of("error", "Username already exists"));
        }

        // Create new user
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(passwordEncoder.encode(password));
        newUser.setEmail(email != null ? email : username + "@example.com"); // Default email if not provided
        newUser.setCreatedAt(java.time.LocalDateTime.now());

        userRepository.save(newUser);

        return ResponseEntity.ok(Map.of("message", "User registered successfully"));
    }

    @GetMapping("/db-test")
    public ResponseEntity<?> testDatabaseConnection() {
        try {
            long count = userRepository.count();
            return ResponseEntity.ok(Map.of(
                "status", "Connected",
                "message", "Database connection successful",
                "userCount", count
            ));
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(Map.of(
                "status", "Error",
                "message", "Database connection failed: " + e.getMessage()
            ));
        }
    }

    @GetMapping("/health")
    public ResponseEntity<?> health() {
        return ResponseEntity.ok(Map.of("status", "UP"));
    }
}
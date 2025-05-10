<?php
// filepath: /var/www/fexend-theme/test/functions.php

/**
 * Test PHP functions file
 * Contains common utility functions and examples
 */

// Database connection function
function connectToDatabase($host = 'localhost', $user = 'root', $pass = '', $db = 'test_db')
{
    try {
        $conn = new PDO("mysql:host=$host;dbname=$db", $user, $pass);
        // Set the PDO error mode to exception
        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        return $conn;
    } catch (PDOException $e) {
        echo "Connection failed: " . $e->getMessage();
        return null;
    }
}

// Example class for user management
class User
{
    private $id;
    private $username;
    private $email;

    public function __construct($id = null, $username = '', $email = '')
    {
        $this->id = $id;
        $this->username = $username;
        $this->email = $email;
    }

    public function getId()
    {
        return $this->id;
    }

    public function getUsername()
    {
        return $this->username;
    }

    public function getEmail()
    {
        return $this->email;
    }

    public function save($conn)
    {
        if ($this->id) {
            // Update existing user
            $stmt = $conn->prepare("UPDATE users SET username = ?, email = ? WHERE id = ?");
            return $stmt->execute([$this->username, $this->email, $this->id]);
        } else {
            // Insert new user
            $stmt = $conn->prepare("INSERT INTO users (username, email) VALUES (?, ?)");
            $result = $stmt->execute([$this->username, $this->email]);
            if ($result) {
                $this->id = $conn->lastInsertId();
            }
            return $result;
        }
    }
}

// Helper function to sanitize input
function sanitizeInput($data)
{
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}

// Example of a template function
function renderTemplate($template, $vars = [])
{
    // Extract variables to make them accessible in the template
    extract($vars);

    // Start output buffering
    ob_start();

    // Include the template file
    include "templates/$template.php";

    // Return the buffered content
    return ob_get_clean();
}

// Example usage
// $db = connectToDatabase();
// $user = new User(null, 'john_doe', 'john@example.com');
// $user->save($db);

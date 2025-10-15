-- -----------------------------------------------------------------------------
-- SQL SCHEMA FOR A NEWS CONTENT MANAGEMENT SYSTEM
-- -----------------------------------------------------------------------------
-- This script creates the tables, relationships, and sample data for a
-- fully-featured news CMS database.
--
-- Database: MySQL / MariaDB
-- -----------------------------------------------------------------------------


-- =============================================================================
-- SECTION 1: TABLE CREATION (SCHEMA)
-- =============================================================================

-- Stores user accounts and their roles within the system.
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    full_name VARCHAR(100),
    role ENUM('admin', 'editor', 'subscriber', 'guest') DEFAULT 'guest',
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_role (role)
);

-- Stores individual news articles and their core content.
CREATE TABLE articles (
    article_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    summary VARCHAR(500),
    author_id INT NOT NULL,
    publish_date DATETIME,
    status ENUM('draft', 'published', 'archived') DEFAULT 'draft',
    views INT DEFAULT 0,
    likes INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FULLTEXT(title, content)
);

-- Stores hierarchical categories for organizing articles.
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    parent_category_id INT DEFAULT NULL,
    FOREIGN KEY (parent_category_id) REFERENCES categories(category_id) ON DELETE SET NULL,
    INDEX idx_category_parent (parent_category_id)
);

-- Junction table for the many-to-many relationship between articles and categories.
CREATE TABLE article_categories (
    article_id INT,
    category_id INT,
    PRIMARY KEY (article_id, category_id),
    FOREIGN KEY (article_id) REFERENCES articles(article_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE
);

-- Stores tags for more granular content classification.
CREATE TABLE tags (
    tag_id INT AUTO_INCREMENT PRIMARY KEY,
    tag_name VARCHAR(50) NOT NULL UNIQUE
);

-- Junction table for the many-to-many relationship between articles and tags.
CREATE TABLE article_tags (
    article_id INT,
    tag_id INT,
    PRIMARY KEY (article_id, tag_id),
    FOREIGN KEY (article_id) REFERENCES articles(article_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(tag_id) ON DELETE CASCADE
);

-- Stores user comments on articles, with support for nested replies.
CREATE TABLE comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    article_id INT NOT NULL,
    user_id INT,
    parent_comment_id INT DEFAULT NULL,
    comment_content TEXT NOT NULL,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (article_id) REFERENCES articles(article_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (parent_comment_id) REFERENCES comments(comment_id) ON DELETE CASCADE,
    INDEX idx_comment_status (status)
);

-- =============================================================================
-- SECTION 2: SAMPLE DATA INSERTION
-- =============================================================================

INSERT INTO users (username, password_hash, email, full_name, role) VALUES
('admin_user', 'hashed_pw_1', 'admin@example.com', 'Admin User', 'admin'),
('editor_user', 'hashed_pw_2', 'editor@example.com', 'Editor User', 'editor'),
('subscriber_user', 'hashed_pw_3', 'subscriber@example.com', 'Subscriber User', 'subscriber');

INSERT INTO categories (category_name, description) VALUES
('Technology', 'Articles about technology and gadgets.'),
('World News', 'Global news and current events.');

INSERT INTO articles (title, content, summary, author_id, publish_date, status) VALUES
('The AI Revolution in 2025', 'Full text content of the article about AI...', 'A summary of the AI article.', 2, NOW(), 'published');

INSERT INTO article_categories (article_id, category_id) VALUES (1, 1);
INSERT INTO tags (tag_name) VALUES ('AI'), ('Innovation');
INSERT INTO article_tags (article_id, tag_id) VALUES (1, 1), (1, 2);
INSERT INTO comments (article_id, user_id, comment_content, status) VALUES (1, 3, 'This is a fascinating read!', 'approved');


-- =============================================================================
-- SECTION 3: EXAMPLE QUERIES
-- =============================================================================

-- Get an article with its author's name
SELECT a.title, a.publish_date, u.username AS author
FROM articles a
JOIN users u ON a.author_id = u.user_id
WHERE a.article_id = 1;

-- Full-text search for articles containing a specific keyword
SELECT article_id, title, summary FROM articles WHERE MATCH(title, content) AGAINST('Revolution' IN NATURAL LANGUAGE MODE);

-- Get all articles in the 'Technology' category
SELECT a.title
FROM articles a
JOIN article_categories ac ON a.article_id = ac.article_id
JOIN categories c ON ac.category_id = c.category_id
WHERE c.category_name = 'Technology' AND a.status = 'published';

# 📰 News Content Management System (Backend)
![Python](https://img.shields.io/badge/Python-3.7%2B-blue?logo=python)

This repository contains the backend components for a comprehensive **News Content Management System (CMS)**.  
It includes a robust SQL database schema for storing and managing news content, and a Python-based web scraper for acquiring articles from URLs.

---

## 📁 Project Components

This project is divided into two main parts:

1. **Database Schema (`schema.sql`)** — The blueprint for the entire CMS backend.  
2. **Article Scraper (`main.py`)** — A command-line tool to fetch content from news websites.

---

## 🧩 1. Database Schema (`schema.sql`)

This file contains the complete SQL code to create the database structure for the News CMS.  
It is designed for relational databases such as **MySQL** or **PostgreSQL**.

### 🔑 Key Features

- **User Management:**  
  `users` table with roles (`admin`, `editor`, `subscriber`).

- **Content Structure:**  
  `articles` table to store titles, content, summaries, and metadata.

- **Taxonomy:**  
  `categories` and `tags` tables with many-to-many relationships to `articles`.

- **User Interaction:**  
  `comments` table with support for nested replies.

- **Auditing:**  
  `audit_log` table to track important administrative actions.

- **Advanced Features:**  
  Includes sample queries, a stored procedure to publish articles, and a trigger for logging deletions.

---

### ⚙️ How to Use

1. Set up a new database (e.g., `news_cms`) in your preferred SQL server (MySQL or PostgreSQL).  
2. Import the schema file to create all tables and insert sample data:

   ```bash
   # Example for MySQL
   mysql -u your_username -p news_cms < schema.sql
## 🕸️ 2. Article Scraper (main.py)
A Python-based CLI tool that extracts key information such as title, author, summary, and main content from online news articles.

### 🧠 Prerequisites
1.Python 3.7+

2.Install required libraries:

      pip install requests beautifulsoup4

### ▶️ How to Run
Navigate to the project directory in your terminal.

Run the script:
    
       python main.py
When prompted, enter the full URL of a news article you wish to scrape.

The scraped content will be printed directly to your console.

## 🔄 How the Components Work Together
This repository provides the foundational backend for a news publishing platform.

The main.py tool acts as the content acquisition pipeline.

The scraped data can then be processed and inserted into the database defined in schema.sql to populate the CMS with articles, categories, and user interactions.

## 🧱 Tech Stack
|**Component**|**Technology**|
|----- |-----|
|**Backend Language**|Python|
|----- |-----|
|**Web Scraping**|Requests, BeautifulSoup|
|----- |-----|
|**Database**|MySQL / PostgreSQL|
|----- |-----|
|**Schema Definition**|	SQL (DDL, DML, Triggers, Procedures)|

### ⚠️ Disclaimer
This project is intended for educational and personal development purposes.
Web scraping should be performed responsibly and in compliance with each website’s Terms of Service.


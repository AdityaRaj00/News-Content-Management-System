import requests
from bs4 import BeautifulSoup
import re

def scrape_news_article(url):
    try:
        headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'}
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()
        
        soup = BeautifulSoup(response.text, 'html.parser')
        
        title_tag = soup.find('h1', class_='article-title')
        title = title_tag.get_text(strip=True) if title_tag else 'Title Not Found'
        
        summary_tag = soup.find('p', class_='article-summary')
        summary = summary_tag.get_text(strip=True) if summary_tag else 'Summary Not Found'
        
        content_paragraphs = soup.find_all('p', class_='article-content-paragraph')
        content = '\n'.join([p.get_text(strip=True) for p in content_paragraphs])
        
        author_tag = soup.find('span', class_='article-author')
        author = author_tag.get_text(strip=True) if author_tag else 'Author Not Found'
        
        return {
            'url': url,
            'title': title,
            'summary': summary,
            'content': content,
            'author': author
        }
    except requests.exceptions.RequestException as e:
        print(f"Error fetching URL {url}: {e}")
        return None
    except Exception as e:
        print(f"An error occurred during scraping: {e}")
        return None

if __name__ == "__main__":
    print("Welcome to the News Article Scraper!")
    print("Enter a news article URL to scrape, or type 'exit' to quit.")
    
    while True:
        user_url = input("\nEnter URL: ")
        
        if user_url.lower() == 'exit':
            print("Exiting scraper. Goodbye!")
            break
        
        if not user_url.startswith(('http://', 'https://')):
            print("Invalid URL. Please enter a full URL starting with http:// or https://")
            continue
            
        print(f"Scraping {user_url}...")
        article_data = scrape_news_article(user_url)
        
        if article_data:
            print("\n" + "="*50)
            print("Scraped Article Data")
            print("="*50)
            print(f"Title: {article_data['title']}")
            print(f"Author: {article_data['author']}")
            print(f"Summary: {article_data['summary']}")
            print(f"\nContent:\n{article_data['content']}")
            print("="*50 + "\n")
        else:
            print("\nCould not scrape the article. Please check the URL and the website's structure.")
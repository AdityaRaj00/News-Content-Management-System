# -----------------------------------------------------------------------------
# News Article Scraper
# -----------------------------------------------------------------------------
# A command-line tool to scrape the title, author, summary, and content
# from a given news article URL.
#
# Libraries: requests, beautifulsoup4
# -----------------------------------------------------------------------------

import requests
from bs4 import BeautifulSoup

def scrape_news_article(url):
    """
    Scrapes a news article from a URL to extract its title, author, and content.

    Args:
        url (str): The URL of the news article to scrape.

    Returns:
        dict: A dictionary containing the scraped data, or None if scraping fails.
    """
    try:
        # Use a common user-agent to mimic a real browser visit
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        }
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()  # Raises an HTTPError for bad responses (4xx or 5xx)

        soup = BeautifulSoup(response.text, 'html.parser')

        # NOTE: These selectors are examples and will need to be adapted for different news sites.
        title_tag = soup.find('h1') # A common tag for main titles
        title = title_tag.get_text(strip=True) if title_tag else 'Title Not Found'

        # Attempt to find common author tags or meta tags
        author_tag = soup.find('span', class_=lambda c: c and 'author' in c.lower()) or \
                     soup.find('a', rel='author')
        author = author_tag.get_text(strip=True) if author_tag else 'Author Not Found'

        # Combine all paragraph tags for the main content
        content_paragraphs = soup.find_all('p')
        content = '\n'.join([p.get_text(strip=True) for p in content_paragraphs if p.get_text(strip=True)])

        return {
            'url': url,
            'title': title,
            'author': author,
            'content': content
        }
    except requests.exceptions.RequestException as e:
        print(f"\nError: Could not fetch URL '{url}'. Details: {e}")
        return None
    except Exception as e:
        print(f"\nAn unexpected error occurred during scraping: {e}")
        return None

def main():
    """Main function to run the interactive scraper loop."""
    print("--- News Article Scraper ---")
    print("Enter a news article URL to scrape, or type 'exit' to quit.")

    while True:
        user_url = input("\nEnter URL: ").strip()

        if user_url.lower() == 'exit':
            print("Exiting scraper. Goodbye!")
            break

        if not user_url.startswith(('http://', 'https://')):
            print("Invalid URL format. Please enter a full URL (e.g., https://www.example.com/article).")
            continue

        print(f"Scraping {user_url}...")
        article_data = scrape_news_article(user_url)

        if article_data:
            print("\n" + "="*50)
            print(" Scraped Article Data ".center(50, "="))
            print("="*50)
            print(f"Title: {article_data['title']}")
            print(f"Author: {article_data['author']}")
            print("\n--- Content ---")
            print(article_data['content'])
            print("="*50)
        else:
            print("\nScraping failed. The website may be structured differently or blocking requests.")

if __name__ == "__main__":
    main()

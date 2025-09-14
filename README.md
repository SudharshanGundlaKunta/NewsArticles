
# 📰 NewsArticles App

NewsArticles - Application through which users can read daily news around the world.
This is a simple iOS app that shows news articles.   
You can read the latest articles, see images (loaded with Kingfisher), and even save your favorite ones as bookmarks to read later.  
It works in both **light** and **dark** mode.

---

## ✨ What the app can do
- Fetches news articles from the internet
- Shows article title, description, author, and image
- Loads images using **Kingfisher** (fast and cached)
- Lets you **bookmark** articles
- Bookmarks are stored with **Core Data**, so they stay even if you close the app
- Works offline (articles you already opened are available later)
- Switch between **light and dark mode** with a button in the navigation bar

---

## 🛠 Built With
- **Swift 5**
- **UIKit**
- **Kingfisher** for images Caching
- **Core Data** for saving articles and bookmarks
- **URLSession** for API calls

---

## 📂 Project Overview
- **Models** → Article and Bookmark objects  
- **ViewModels** → Fetching and business logic  
- **Views** → Screens built with UIKit/SwiftUI  
- **CoreData** → Handles saving and loading data  
- **Networking** → Handles API requests  

---

## 🚀 How to Run
1. First, clone the project:
   ```bash
   git clone https://github.com/SudharshanGundlaKunta/NewsArticles.git

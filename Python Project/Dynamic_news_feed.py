import json
def saveFile(newsList, fileName="newsFeed.txt"):  
    with open(fileName, "w") as file:
        for news in newsList:
            file.write(f"Title: {news['title']}\n")
            file.write(f"Details: {news['details']}\n")
            file.write(f"Image: {news['image']}\n")
            file.write("-" * 40 + "\n")

def loadFile(fileName="newsFeed.txt"):
    newsList = []
    try:
        with open(fileName, "r") as file:
            lines = file.readlines()
            newsItem = {}
            for line in lines:
                line = line.strip()
                if line.startswith("Title:"):
                    newsItem["title"] = line.replace("Title: ", "")
                elif line.startswith("Details:"):
                    newsItem["details"] = line.replace("Details: ", "")
                elif line.startswith("Image:"):
                    newsItem["image"] = line.replace("Image: ", "")
                elif line == "-" * 40:  # Separator
                    newsList.append(newsItem)
                    newsItem = {}
            if newsItem:  
                newsList.append(newsItem)
    except FileNotFoundError:
        print("No saved news found. Starting fresh.")
    return newsList

def addNews(newsList):
    title = input("Enter News Title: ")
    details = input("Enter News Details: ")
    imagePath = input("Enter Photo Path or URL: ")
    newsList.append({'title': title, 'details': details, 'image': imagePath})
    saveFile(newsList)  
    print("\nNews added successfully!\n")

def listNews(newsList, page=1, perPage=3):
    if not newsList:
        print("No news available!\n")
        return
    
    totalPages = (len(newsList) + perPage - 1) // perPage  
    start = (page - 1) * perPage
    end = start + perPage
    
    print(f"\nShowing page {page}/{totalPages}\n")
    for i, news in enumerate(newsList[start:end], start=start + 1):
        print(f"{i}. {news['title']}")
        print(f"   Details: {news['details']}")
        print(f"   Image: {news['image']}\n")
    
    if page < totalPages:
        nextPage = input("Press Enter for next page or type 'exit' to go back: ")
        if nextPage.lower() != 'exit':
            listNews(newsList, page + 1, perPage)

def main():
    newsList = loadFile()
    
    while True:
        print("\nDynamic News Feed Application")
        print("1. Add News")
        print("2. List News")
        print("3. Exit App")
        choice = input("Select your choice: ")
        
        if choice == '1':
            addNews(newsList)
        elif choice == '2':
            listNews(newsList)
        elif choice == '3':
            print("Exiting application. Goodbye!")
            break
        else:
            print("Invalid choice! Please try again.")
main()


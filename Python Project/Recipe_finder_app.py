
def getIngredients(ingredients, recipes):
    matchingRecipes = [];
    for recipe in recipes:
        for ing in ingredients:
            if ing in recipe['ingredients']:
                matchingRecipes.append(recipe)
                break  # Stop checking 
    return matchingRecipes
def filterRecipes(recipeType, recipes):
    return [recipe for recipe in recipes
            if recipe['type'].lower() == recipeType.lower()]

def displayRecipes(recipes):
    if not recipes:
        print("No recipes found!")
        return
    for index, recipe in enumerate(recipes, 1):
        print(f"{index}. {recipe['name']} (Type: {recipe['type']})")
        print(f"   Ingredients: {', '.join(recipe['ingredients'])}")
        print("......")


def main():
    # All recipes
    recipes = [
        {
         'name': 'Pancakes',
         'type': 'Breakfast',
         'ingredients': ['flour', 'milk', 'eggs', 'sugar']
        },
        
        {
         'name': 'Chicken Salad',
         'type': 'Lunch',
         'ingredients': ['chicken', 'lettuce', 'tomato', 'cucumber']
        },
        
        {
         'name': 'Apple Pie',
         'type': 'Dessert',
         'ingredients': ['apple', 'sugar', 'butter', 'flour', 'eggs']
        },
        
        {
         'name': 'Omelette',
         'type': 'Breakfast',
         'ingredients': ['eggs', 'cheese', 'onion', 'tomato']
        },
        
        {
         'name': 'Pasta',
         'type': 'Dinner',
         'ingredients': ['pasta', 'tomato sauce', 'cheese', 'garlic']
        },
    ]
    
    while True:
        print("\nRecipe Finder Application")
        print("1. Search recipes by ingredients")
        print("2. Filter recipes by type")
        print("3. Exit")
        choice = input("Enter your choice: ")
        
        if choice == '1':
            ingredients = input("Enter ingredients with comma: ")
            ingredients = ingredients.split(',')
            ingredients = [ing.strip().lower() for ing in ingredients]
            results = getIngredients(ingredients, recipes)
            displayRecipes(results)
        
        elif choice == '2':
            recipeType = input("Enter recipe type (Breakfast, Lunch, Dinner): ")
            results = filterRecipes(recipeType, recipes)
            displayRecipes(results)
        
        elif choice == '3':
            print("Thankyou for comming. Goodbye!")
            break
        else:
            print("Invalid choice. Please try again.")
main();

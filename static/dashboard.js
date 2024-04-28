document.addEventListener("DOMContentLoaded", function() {
    const recipesContainer = document.querySelector('.recipes-container');

    function fetchRecipes() {
        fetch('/api/recipes')
            .then(response => response.json())
            .then(data => {
                displayRecipes(data.recipes);
            })
            .catch(error => {
                console.error('Error loading recipes:', error);
                recipesContainer.innerHTML = '<p>Error loading recipes.</p>';
            });
    }

    function displayRecipes(recipes) {
        recipesContainer.innerHTML = ''; // Clear existing recipes
        recipes.forEach(recipe => {
            const recipeElem = document.createElement('div');
            recipeElem.className = 'bg-white rounded-lg shadow p-4';
            recipeElem.innerHTML = `
                <img src="${recipe.recipe_image}" alt="${recipe.recipe_name}" class="rounded mt-2">
                <h3 class="font-bold text-lg mt-2">${recipe.recipe_name}</h3>
                <p class="text-gray-600">${recipe.recipe_description}</p>
                <button onclick="location.href='/recipe/${encodeURIComponent(recipe.recipe_name.replace(/ /g, '-'))}';" class="mt-3 px-4 py-2 bg-green-500 text-white rounded hover:bg-green-700 transition">View Recipe</button>
            `;
            recipesContainer.appendChild(recipeElem);
        });
    }

    fetchRecipes(); // Initial fetch of recipes
});

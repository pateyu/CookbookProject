document.addEventListener("DOMContentLoaded", function() {
    const recipesContainer = document.querySelector('.recipes-container');
    const searchForm = document.querySelector('form');

    function fetchRecipes(query = '') {
        let url = '/api/recipes';
        if (query) {
            url += '?search=' + encodeURIComponent(query);
        }

        fetch(url)
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
        recipesContainer.innerHTML = ''; 
        recipes.forEach(recipe => {
            const recipeElem = document.createElement('div');
            recipeElem.className = 'bg-white rounded-lg shadow p-4 flex flex-col';
            recipeElem.innerHTML = `
                <div class="h-48 w-full overflow-hidden rounded-lg">
                    <img src="${recipe.recipe_image}" alt="${recipe.recipe_name}" class="w-full h-full object-cover">
                </div>
                <div class="flex-grow">
                    <h3 class="font-bold text-lg mt-2">${recipe.recipe_name}</h3>
                    <p class="text-gray-600">${recipe.recipe_description}</p>
                </div>
                <button onclick="location.href='/recipe/${encodeURIComponent(recipe.recipe_name.replace(/ /g, '-'))}';" class="mt-3 px-4 py-2 bg-green-500 text-white rounded hover:bg-green-700 transition">View Recipe</button>
            `;
            recipesContainer.appendChild(recipeElem);
        });
    }

    // Listen for search form submission to re-fetch recipes based on search query
    searchForm.addEventListener('submit', function(event) {
        event.preventDefault();
        const searchValue = this.querySelector('input[name="search"]').value;
        fetchRecipes(searchValue);
    });

    fetchRecipes(); // Initial fetch of recipes when the page loads
});

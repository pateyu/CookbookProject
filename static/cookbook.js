document.addEventListener('DOMContentLoaded', function() {
    fetch('/api/cookbook-recipes')
    .then(response => response.json())
    .then(data => {
        const container = document.querySelector('.recipes-container');
        data.recipes.forEach(recipe => {
            const div = document.createElement('div');
            div.className = 'bg-white rounded-lg shadow p-4';
            div.innerHTML = `<h3 class="font-bold text-lg">${recipe.recipe_name}</h3>
                             <img src="/static/images/${recipe.recipe_image}" alt="${recipe.recipe_name}" class="rounded mt-2">
                             <p class="text-gray-600 mt-2">${recipe.recipe_description}</p>`;
            container.appendChild(div);
        });
    })
    .catch(error => console.error('Error loading cookbook recipes:', error));
});

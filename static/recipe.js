function deleteRecipe(recipeName) {
  if (!confirm("Are you sure you want to delete this recipe?")) {
    return;
  }

  fetch(`/delete-recipe/${encodeURIComponent(recipeName)}`, {
    method: 'DELETE',
  })
  .then(response => {
    if (response.ok) {
      alert("Recipe deleted successfully.");
      window.location.href = '/dashboard'; // Redirect to dashboard
    } else {
      alert("Failed to delete the recipe.");
    }
  })
  .catch(error => {
    console.error('Error:', error);
    alert("An error occurred while deleting the recipe.");
  });
}

function toggleCookbook(recipeName) {
fetch(`/toggle-cookbook/${encodeURIComponent(recipeName)}`, {
    method: 'POST'
})
.then(response => response.json())
.then(data => {
    alert(data.message);  // Display a message returned from the server
    updateCookbookButton(recipeName);  // Update button text based on the current state
})
.catch(error => {
    console.error('Error updating cookbook:', error);
    alert('Error updating cookbook.');
});
}

function updateCookbookButton(recipeName) {
fetch(`/check-cookbook/${encodeURIComponent(recipeName)}`)
.then(response => response.json())
.then(data => {
    const button = document.getElementById('cookbookButton');
    button.textContent = data.in_cookbook ? 'Delete from Cookbook' : 'Save to Cookbook';
    button.classList.toggle('bg-red-600', data.in_cookbook);
    button.classList.toggle('bg-green-500', !data.in_cookbook);
})
.catch(error => console.error('Error checking cookbook status:', error));
}

document.addEventListener('DOMContentLoaded', function () {
  const recipeName = document.getElementById('cookbookButton').getAttribute('data-recipe-name');
  if (recipeName) {
      updateCookbookButton(recipeName);
  }
});

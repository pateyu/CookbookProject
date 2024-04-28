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

function saveToCookbook(recipeName) {
  fetch(`/save-to-cookbook/${encodeURIComponent(recipeName)}`, {
      method: 'POST'
  })
  .then(response => response.json())
  .then(data => {
      if (data.message) {
          alert(data.message);
      }
  })
  .catch(error => console.error('Error saving to cookbook:', error));
}

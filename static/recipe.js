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
  
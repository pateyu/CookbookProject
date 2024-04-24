document.addEventListener("DOMContentLoaded", function() {
    const loginForm = document.getElementById('loginForm');
    loginForm.addEventListener('submit', function(event) {
        event.preventDefault();
        const formData = new FormData(loginForm);
        const data = {};
        formData.forEach((value, key) => {data[key] = value;});
        fetch('/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',  // This should specify the content type as JSON.
            },
            body: JSON.stringify(data)
        })
        .then(response => response.json())
        .then(data => {
            if(data.logged_in) {
                window.location.href = data.redirect;  // Redirect based on server response
            } else {
                alert('Login failed. Please try again.');
            }
        })
        .catch((error) => {
            console.error('Error:', error);
            alert('An error occurred. Please try again later.');
        });
    });
});

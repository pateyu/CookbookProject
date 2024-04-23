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
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data)
        })
        .then(response => response.json())
        .then(data => {
            if(data.logged_in) {
                window.location.href = '/dashboard'; 
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

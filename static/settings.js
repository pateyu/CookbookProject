document.addEventListener("DOMContentLoaded", function () {
  const usernameForm = document.getElementById("username-form");
  const passwordForm = document.getElementById("password-form");
  const emailForm = document.getElementById("email-form");
  const securityKeyForm = document.getElementById("securityKeyForm");
  const messageDisplay = document.getElementById('messageDisplay'); // Get the message display element

  usernameForm.addEventListener("submit", function (event) {
      event.preventDefault();
      submitForm(usernameForm, "/change_username");
  });

  passwordForm.addEventListener("submit", function (event) {
      event.preventDefault();
      submitForm(passwordForm, "/change_password");
  });

  emailForm.addEventListener("submit", function (event) {
      event.preventDefault();
      submitForm(emailForm, "/change_email");
  });

  securityKeyForm.addEventListener("submit", function(event) {
      event.preventDefault();
      submitForm(securityKeyForm, "/update_security_key");
  });

  function submitForm(form, actionUrl) {
      const formData = new FormData(form);
      
      fetch(actionUrl, {
          method: "POST",
          body: formData,
      })
      .then(response => response.json()) // Parse JSON response
      .then(data => {
          if (data.message) {
              messageDisplay.textContent = data.message; // Display the message in the div
              messageDisplay.style.color = 'green'; // Set the text color to green for success
          } else {
              throw new Error("Unexpected response from server");
          }
      })
      .catch(error => {
          console.error("Error:", error);
          messageDisplay.textContent = "An error occurred: " + error.message; // Display the error message
          messageDisplay.style.color = 'red'; // Set the text color to red for errors
      });
  }
});

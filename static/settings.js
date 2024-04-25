document.addEventListener("DOMContentLoaded", function () {
  const usernameForm = document.getElementById("username-form");
  const passwordForm = document.getElementById("password-form");
  const emailForm = document.getElementById("email-form");

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

  function submitForm(form, actionUrl) {
    const formData = new FormData(form);
    fetch(actionUrl, {
      method: "POST",
      body: formData,
    })
      .then((response) => response.json()) // Parse JSON response
      .then((data) => {
        if (data.message) {
          alert(data.message);
        } else {
          throw new Error("Unexpected response from server");
        }
      })
      .catch((error) => {
        console.error("Error:", error);
        alert("An error occurred: " + error.message);
      });
  }
});

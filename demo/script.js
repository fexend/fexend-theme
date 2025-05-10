// Test JavaScript File

// DOM Ready event handler
document.addEventListener("DOMContentLoaded", function () {
  console.log("Document is ready!");

  // Test button click event
  const testButton = document.getElementById("testButton");
  if (testButton) {
    testButton.addEventListener("click", function () {
      alert("Button clicked!");
    });
  }

  // Example fetch API call
  function fetchData() {
    fetch("/api/hello")
      .then((response) => response.json())
      .then((data) => {
        console.log("API Response:", data);
      })
      .catch((error) => {
        console.error("Error fetching data:", error);
      });
  }

  // Simple form validation function
  function validateForm(formId) {
    const form = document.getElementById(formId);
    if (!form) return false;

    const inputs = form.querySelectorAll("input[required]");
    let isValid = true;

    inputs.forEach((input) => {
      if (!input.value.trim()) {
        isValid = false;
        input.classList.add("error");
      } else {
        input.classList.remove("error");
      }
    });

    return isValid;
  }

  // Example of a class
  class TestComponent {
    constructor(element) {
      this.element = element;
      this.init();
    }

    init() {
      console.log("Component initialized");
    }

    update(data) {
      this.element.textContent = data;
    }
  }
});

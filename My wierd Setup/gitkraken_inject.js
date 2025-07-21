// Function to update the window title based on the text content of an element with the class "repo"
function updateWindowTitle() {
  const repoElement = document.querySelector('.repo');
  if (repoElement) {
    document.title = "Gitkraken - "+repoElement.textContent;
  }
}

// Create a new MutationObserver
const observer = new MutationObserver(updateWindowTitle);

// Define the options for the observer (watch for changes to the body's child nodes)
const observerConfig = {
  childList: true,  // Watch for changes in the child nodes of the body
  subtree: true,    // Watch for changes in the entire subtree of the body
};

// Start observing the body for changes
observer.observe(document.body, observerConfig);

// Initial update of the window title
updateWindowTitle();

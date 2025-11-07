document.addEventListener("DOMContentLoaded", () => {
  const addButton = document.getElementById("add-item");
  const container = document.getElementById("items-container");

  addButton.addEventListener("click", () => {
    const newItem = container.children[0].cloneNode(true);

    newItem.querySelectorAll("input").forEach(input => input.value = "");
    container.appendChild(newItem);
  });

  container.addEventListener("click", (event) => {
    if (event.target.classList.contains("remove-item")) {
      if (container.children.length > 1) {
        event.target.parentNode.remove();
      }
    }
  });
});

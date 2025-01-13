const submitBtn = document.querySelector("#submit");
const btns = document.querySelectorAll(".dessert");
const csrf = document.querySelector("#csrf_token").value;

window.addEventListener("load", () => {
  btns.forEach((button) => {
    button.addEventListener("click", (e) => {
      e.preventDefault();
      fetch("http://localhost:4567/dessert/fav", {
        method: "POST",
        headers: { "X-CSRF-TOKEN": csrf },
        body: e.currentTarget.innerText.trim(),
      });
    });
  });
});

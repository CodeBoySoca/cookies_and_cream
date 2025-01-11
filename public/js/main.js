const submitBtn = document.querySelector('#submit');
const btns = document.querySelectorAll('.dessert');
const csrf = document.querySelector('#csrf_token').value;

window.addEventListener('load', () => {
  btns.forEach((button) => {
    button.addEventListener('click', (e) => {
        e.preventDefault();
        fetch('http://localhost:4567/dessert/favs', {
            method: 'POST',
            body: JSON.stringify({favorite_dessert: e.currentTarget.innerText}),
            headers: {
               'Content-Type': 'application/json',
               'X-CSRF-TOKEN': csrf
            }
        })
    })
  })
})

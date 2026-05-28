document.addEventListener('DOMContentLoaded', (event) => {
 function fetchPokemon() {
 const id = document.getElementById('pokemonId').value;
 // Validar que el ID sea un número
 if (!id || isNaN(id) || id <= 0) {
 alert('Por favor, ingrese un ID válido');
 return;
 }
 // Limpiar el área de resultados
 document.getElementById('pokemonData').innerHTML = '';
 // Realizar la solicitud a la API de Pokémon
 fetch(`https://pokeapi.co/api/v2/pokemon/${id}`)
 .then(response => {
 if (!response.ok) {
 throw new Error('Error en la solicitud: ' +
response.status);
 }
 return response.json();
 })
 .then(data => {
 let output = `<p>Nombre: ${data.name}</p>`;
output += `<p>Peso: ${data.weight} kg</p>`;
 output += `<p>Altura: ${data.height} cm</p>`;
 output += `<img src="${data.sprites.front_default}"
alt="Imagen de ${data.name}">`;
 document.getElementById('pokemonData').innerHTML =
output;
 })
 .catch(error => {
 document.getElementById('pokemonData').innerHTML =
`<p>Error: ${error.message}</p>`;
 });
 }
 // Hacer que la función fetchPokemon esté disponible globalmente
 window.fetchPokemon = fetchPokemon;
});

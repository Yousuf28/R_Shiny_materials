// document.getElementById("free_text").addEventListener("focus", function(){
// 	let num = Math.random()
// 	// console.log("number  generated: " + num)
// 	document.getElementById("free_text").style.backgroundColor("green")
	
// 	// Shiny.setInputValue("click_event", "clicked", {priority : "event"})
// })

const form = document.getElementById('free_text');

form.addEventListener('focus', (event) => {
  event.target.style.background = 'pink';
}, true);
form.addEventListener('blur', (event) => {
	event.target.style.background = '';
  }, true);
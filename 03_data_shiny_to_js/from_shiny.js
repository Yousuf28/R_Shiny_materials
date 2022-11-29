Shiny.addCustomMessageHandler("rtojs", function(data){
var data_from_r = data;
console.log("direct_r_data")
console.log(data_from_r);



}
)

Shiny.addCustomMessageHandler("jsondata", function(data){
let jsondata = data;
console.log("from json data")
console.log(jsondata)
console.log(typeof(jsondata))
// console.table(jsondata)
}
)

Shiny.addCustomMessageHandler("send_console", function(data){
let input_value = data;

const car_array = [
    "Saab",
    "Volvo",
    "BMW"
  ];
const car_obj = {type:"Fiat", model:"500", color:"white"};

    const car_arr_of_obj_row = [
      { mpg: 21, cyl: 6, disp: 160, hp: 110 },
      { mpg: 21, cyl: 6, disp: 160, hp: 110 },
      { mpg: 22.8, cyl: 4, disp: 108, hp: 93 },
      { mpg: 21.4, cyl: 6, disp: 258, hp: 110 },
      { mpg: 18.7, cyl: 8, disp: 360, hp: 175 },
      { mpg: 18.1, cyl: 6, disp: 225, hp: 105 },
    ];
    
//     const arr_of_obj_row = [
// {mpg: 21, cyl: 6, disp: 160, hp: 110}, 
// {mpg: 21, cyl: 6, disp: 160, hp: 110}, 
// {mpg: 22.8, cyl: 4, disp: 108, hp: 93},
// {mpg: 21.4, cyl: 6, disp: 258, hp: 110}, 
// {mpg: 18.7, cyl: 8, disp: 360, hp: 175},
// {mpg: 18.1, cyl: 6, disp: 225, hp: 105}
//     ]

// const obj_of_array_json = {
//   cyl: [6, 6, 4, 6, 8, 6],
//   disp: [160, 160, 108, 258, 360, 225],
//   hp: [110, 110, 93, 110, 175, 105],
//   mpg: [21, 21, 22.8, 21.4, 18.7, 18.1],
// };
const car_arr_of_obj = {
  mpg: [21, 21, 22.8, 21.4, 18.7, 18.1],
  cyl: [6, 6, 4, 6, 8, 6],
  disp: [160, 160, 108, 258, 360, 225],
  hp: [110, 110, 93, 110, 175, null],
}; 




if(input_value === "Array"){
    const car_array_json = JSON.stringify(car_array)
     Shiny.setInputValue("from_js_data", car_array_json, {priority : "event"})
} else if (input_value === "Object") {
    const car_obj_json = JSON.stringify(car_obj)
    //  Shiny.setInputValue("from_js_data", car_obj, {priority : "event"})
     Shiny.setInputValue("from_js_data", car_obj_json, {priority : "event"})
    
} else {
    const json_obj = JSON.stringify(car_arr_of_obj_row)
     Shiny.setInputValue("from_js_data", json_obj, {priority : "event"})
    
}


}
)

function showPage(id){

document.querySelectorAll(".page")
.forEach(x=>x.classList.add("hidden"));

document.getElementById(id)
.classList.remove("hidden");
}

async function checkStatus(){

let r = await fetch("/api/status");
let d = await r.json();

document.getElementById("statusOutput")
.textContent =
JSON.stringify(d,null,2);
}

async function sendChat(){

let msg =
document.getElementById("chatInput").value;

let r =
await fetch("/api/chat",{
method:"POST",
headers:{
"Content-Type":"application/json"
},
body:JSON.stringify({
message:msg
})
});

let d = await r.json();

document.getElementById("chatOutput")
.textContent = d.reply;
}

#!/usr/bin/env bash

set -e

echo "========================================="
echo " GhostWriter Komitan v0.5 Upgrade"
echo "========================================="

mkdir -p backup

echo "[1/8] Backup file lama..."

cp -f app.py backup/app.py.bak 2>/dev/null || true
cp -f frontend/index.html backup/index.html.bak 2>/dev/null || true

echo "[2/8] Membuat struktur baru..."

mkdir -p backend/api
mkdir -p backend/services

mkdir -p frontend

mkdir -p WritingBrain/chats
mkdir -p WritingBrain/drafts
mkdir -p WritingBrain/lessons
mkdir -p WritingBrain/style_profile
mkdir -p WritingBrain/profiles
mkdir -p WritingBrain/backups

echo '{"memories":[]}' > WritingBrain/memory.json

echo "[3/8] models.json"

cat > models.json <<'EOF'
[
{
"name":"Qwen3 4B",
"repo":"unsloth/Qwen3-4B-GGUF",
"file":"Qwen3-4B-Q4_K_M.gguf"
},
{
"name":"Qwen3 8B",
"repo":"unsloth/Qwen3-8B-GGUF",
"file":"Qwen3-8B-Q4_K_M.gguf"
}
]
EOF

echo "[4/8] frontend/index.html"

cat > frontend/index.html <<'EOF'

<!DOCTYPE html>

<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>GhostWriter Komitan</title>
<link rel="stylesheet" href="/frontend/style.css">
</head>
<body>

<div class="sidebar">

<h2>GhostWriter</h2>

<button onclick="showPage('chat')">Chat</button> <button onclick="showPage('writer')">Writer</button> <button onclick="showPage('training')">Training</button> <button onclick="showPage('settings')">Settings</button>

</div>

<div class="content">

<div id="chat" class="page">

<h2>Chat</h2>

<textarea id="chatInput"></textarea>

<button onclick="sendChat()">Kirim</button>

<pre id="chatOutput"></pre>

</div>

<div id="writer" class="page hidden">
<h2>Writer</h2>
<p>Coming Soon</p>
</div>

<div id="training" class="page hidden">
<h2>Training</h2>
<p>Coming Soon</p>
</div>

<div id="settings" class="page hidden">

<h2>Settings</h2>

<button onclick="checkStatus()">
Check Status
</button>

<pre id="statusOutput"></pre>

</div>

</div>

<script src="/frontend/app.js"></script>

</body>
</html>
EOF

echo "[5/8] frontend/style.css"

cat > frontend/style.css <<'EOF'
body{
margin:0;
display:flex;
font-family:Arial;
}

.sidebar{
width:220px;
background:#222;
color:white;
height:100vh;
padding:20px;
}

.sidebar button{
display:block;
width:100%;
margin-bottom:10px;
padding:10px;
}

.content{
flex:1;
padding:20px;
}

.hidden{
display:none;
}

textarea{
width:100%;
height:200px;
}

pre{
background:#111;
color:#0f0;
padding:10px;
}
EOF

echo "[6/8] frontend/app.js"

cat > frontend/app.js <<'EOF'
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
EOF

echo "[7/8] app.py"

cat > app.py <<'EOF'
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from pydantic import BaseModel

app = FastAPI()

app.mount(
"/frontend",
StaticFiles(directory="frontend"),
name="frontend"
)

class ChatRequest(BaseModel):
message:str

@app.get("/")
def home():
return FileResponse("frontend/index.html")

@app.get("/api/status")
def status():
return {
"status":"online",
"app":"GhostWriter Komitan",
"version":"0.5"
}

@app.post("/api/chat")
def chat(req:ChatRequest):

```
return {
    "reply":
    f"GhostWriter menerima: {req.message}"
}
```

EOF

echo "[8/8] requirements.txt"

cat > requirements.txt <<'EOF'
fastapi
uvicorn
pydantic
EOF

echo ""
echo "========================================="
echo "SELESAI"
echo "========================================="
echo ""
echo "Lanjut:"
echo "git add ."
echo "git commit -m 'Upgrade GhostWriter v0.5'"
echo "git push"
echo ""
echo "Tunggu GitHub Action deploy ke HF Space."

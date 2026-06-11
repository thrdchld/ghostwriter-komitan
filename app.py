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


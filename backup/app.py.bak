from fastapi import FastAPI
from fastapi.responses import FileResponse

app = FastAPI()

@app.get("/")
def home():
    return FileResponse("frontend/index.html")

@app.get("/api/status")
def status():
    return {
        "status": "online",
        "app": "GhostWriter Komitan",
        "version": "0.1.0"
    }
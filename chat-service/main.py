from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from prometheus_fastapi_instrumentator import Instrumentator

app = FastAPI(title="Chat Service")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/health")
def health():
    return {"status": "healthy"}

@app.get("/")
def read_root():
    return {"message": "Chat Service is running"}

@app.get("/messages")
def get_messages():
    return [
        {"from": "admin", "msg": "System status: OK"},
        {"from": "sre", "msg": "Load test completed"},
        {"from": "user_1", "text": "Hello, I need help!"}
    ]

Instrumentator().instrument(app).expose(app)

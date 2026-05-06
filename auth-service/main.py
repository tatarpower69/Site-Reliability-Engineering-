from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from prometheus_fastapi_instrumentator import Instrumentator

app = FastAPI(title="Auth Service")

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
    return {"message": "Auth Service is running"}

@app.get("/info")
def get_info():
    return {
        "version": "1.0.0",
        "description": "Authentication & JWT Provider",
        "methods": ["JWT", "OAuth2"]
    }

@app.post("/login")
def login():
    return {"status": "success", "token": "fake-jwt-token"}

@app.post("/register")
def register():
    return {"status": "user created"}

Instrumentator().instrument(app).expose(app)

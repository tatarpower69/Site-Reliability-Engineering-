from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from prometheus_fastapi_instrumentator import Instrumentator

app = FastAPI(title="User Service")

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
    return {"message": "User Service is running"}

@app.get("/users")
def get_users():
    return [
        {"id": 1, "username": "admin", "role": "superuser"},
        {"id": 2, "username": "sre_engineer", "role": "staff"}
    ]

@app.get("/profile/{user_id}")
def get_profile(user_id: int):
    return {"user_id": user_id, "username": f"user_{user_id}", "email": f"user_{user_id}@example.com"}

Instrumentator().instrument(app).expose(app)

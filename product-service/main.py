from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from prometheus_fastapi_instrumentator import Instrumentator

app = FastAPI(title="Product Service")

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
    return {"message": "Product Service is running"}

@app.get("/products")
def get_products():
    return [
        {"id": 101, "name": "Cloud Server", "price": 99.99},
        {"id": 102, "name": "Monitoring Pack", "price": 49.99},
        {"id": 1, "name": "Laptop", "price": 1200},
        {"id": 2, "name": "Smartphone", "price": 800}
    ]

Instrumentator().instrument(app).expose(app)

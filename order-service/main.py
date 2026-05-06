from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from prometheus_fastapi_instrumentator import Instrumentator, metrics
from prometheus_client import Gauge, Counter
import os
import httpx
import psycopg2
import time

import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger("order-service")

app = FastAPI(title="Order Service")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Database configuration from environment variables
DB_USER = os.getenv("POSTGRES_USER", "user")
DB_PASSWORD = os.getenv("POSTGRES_PASSWORD", "password")
DB_NAME = os.getenv("POSTGRES_DB", "microservices")
DB_HOST = os.getenv("DB_HOST", "db")
DB_PORT = os.getenv("DB_PORT", "5432")

DATABASE_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

PRODUCT_SERVICE_URL = os.getenv("PRODUCT_SERVICE_URL", "http://product-service:8000")

ACTIVE_ORDERS = Gauge('active_orders_total', 'Total active orders')
ORDER_CREATION_COUNT = Counter('orders_created_total', 'Total orders created')
DB_CONNECTED = Gauge('database_connected', 'Database connection status (1 for connected, 0 for failed)')

def get_db_connection():
    return psycopg2.connect(
        host=DB_HOST,
        port=DB_PORT,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
        connect_timeout=3
    )

@app.get("/health")
def health():
    """Health check endpoint with DB verification."""
    try:
        conn = get_db_connection()
        conn.close()
        DB_CONNECTED.set(1)
        return {"status": "healthy", "database": "connected"}
    except Exception as e:
        DB_CONNECTED.set(0)
        logger.error(f"DATABASE_CONNECTION_FAILURE: Unable to connect to {DB_HOST}:{DB_PORT}. Error: {str(e)}")
        raise HTTPException(status_code=503, detail=f"Database connection failed: {str(e)}")

@app.get("/")
def read_root():
    return {"message": "Order Service is running"}

@app.get("/orders")
def get_orders():
    ACTIVE_ORDERS.set(10)
    return [
        {"id": 5001, "item": "Laptop", "status": "shipped"},
        {"id": 5002, "item": "Monitor", "status": "pending"}
    ]

@app.post("/orders")
async def create_order(product_id: int, quantity: int):
    try:
        async with httpx.AsyncClient() as client:
            response = await client.get(f"{PRODUCT_SERVICE_URL}/products")
            if response.status_code != 200:
                raise HTTPException(status_code=503, detail="Product Service unavailable")
                
            products = response.json()
            product_exists = any(p["id"] == product_id for p in products)
            
            if not product_exists:
                raise HTTPException(status_code=404, detail=f"Product with ID {product_id} not found")
                
            product_name = next(p["name"] for p in products if p["id"] == product_id)
            
            ORDER_CREATION_COUNT.inc()
            return {
                "status": "order created",
                "product_id": product_id,
                "product_name": product_name,
                "quantity": quantity
            }
            
    except httpx.RequestError as exc:
        logger.error(f"SERVICE_COMMUNICATION_FAILURE: Error communicating with Product Service at {PRODUCT_SERVICE_URL}. Error: {exc}")
        raise HTTPException(status_code=503, detail=f"Service communication error: {exc}")

Instrumentator().add(metrics.default()).instrument(app).expose(app)

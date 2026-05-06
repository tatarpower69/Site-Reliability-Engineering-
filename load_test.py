#!/usr/bin/env python3
import asyncio
import aiohttp
import time
import json
from datetime import datetime
import sys

# Testing against the Proxy (Port 80)
BASE_URL = "http://localhost"
SERVICES = {
    "auth": "http://localhost/api/auth",
    "user": "http://localhost/api/user",
    "product": "http://localhost/api/product",
    "order": "http://localhost/api/order",
}

results = {
    "total_requests": 0,
    "success": 0,
    "errors": 0,
    "latencies": []
}

async def send_request(session, url, endpoint="/health"):
    start = time.time()
    try:
        async with session.get(f"{url}{endpoint}", timeout=aiohttp.ClientTimeout(total=5)) as resp:
            latency = time.time() - start
            results["latencies"].append(latency)
            results["total_requests"] += 1
            if resp.status < 400:
                results["success"] += 1
            else:
                results["errors"] += 1
            return resp.status, latency
    except Exception as e:
        results["errors"] += 1
        results["total_requests"] += 1
        return 0, time.time() - start

async def load_test(concurrent_users=10, duration_seconds=30):
    print(f"Testing... {datetime.now().strftime('%H:%M:%S')}")
    
    async with aiohttp.ClientSession() as session:
        start_time = time.time()
        while time.time() - start_time < duration_seconds:
            tasks = []
            for name, url in SERVICES.items():
                tasks.append(send_request(session, url))
            await asyncio.gather(*tasks)
            await asyncio.sleep(1 / concurrent_users)

    # Summary
    avg_lat = sum(results["latencies"])/len(results["latencies"]) if results["latencies"] else 0
    print(f"\nRequests: {results['total_requests']}")
    print(f"Success: {results['success']}")
    print(f"Errors: {results['errors']}")
    print(f"Avg Latency: {avg_lat:.4f}s")

if __name__ == "__main__":
    asyncio.run(load_test(20, 10))

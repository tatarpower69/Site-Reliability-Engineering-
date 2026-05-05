#!/usr/bin/env python3
"""
Load Testing Script for Assignment 6 - Capacity Planning
Simulates concurrent requests to test system behavior under load.
"""

import asyncio
import aiohttp
import time
import json
from datetime import datetime
import sys

BASE_URL = "http://localhost"
SERVICES = {
    "auth": "http://localhost:8001",
    "user": "http://localhost:8002",
    "product": "http://localhost:8003",
    "order": "http://localhost:8004",
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
    print(f"\n{'='*50}")
    print(f"Load Test Started: {datetime.now().strftime('%H:%M:%S')}")
    print(f"Concurrent Users: {concurrent_users}")
    print(f"Duration: {duration_seconds}s")
    print(f"{'='*50}\n")

    async with aiohttp.ClientSession() as session:
        start_time = time.time()
        tasks = []

        while time.time() - start_time < duration_seconds:
            for service, url in SERVICES.items():
                for _ in range(concurrent_users):
                    task = asyncio.create_task(send_request(session, url, "/health"))
                    tasks.append(task)

            await asyncio.sleep(1)

        await asyncio.gather(*tasks, return_exceptions=True)

    if results["latencies"]:
        avg_latency = sum(results["latencies"]) / len(results["latencies"])
        max_latency = max(results["latencies"])
        min_latency = min(results["latencies"])
        rps = results["total_requests"] / duration_seconds
        error_rate = (results["errors"] / results["total_requests"]) * 100 if results["total_requests"] > 0 else 0

        print(f"\n{'='*50}")
        print("LOAD TEST RESULTS")
        print(f"{'='*50}")
        print(f"Total Requests:    {results['total_requests']}")
        print(f"Successful:        {results['success']}")
        print(f"Errors:            {results['errors']}")
        print(f"Error Rate:        {error_rate:.2f}%")
        print(f"Requests/Second:   {rps:.2f}")
        print(f"Avg Latency:       {avg_latency*1000:.2f}ms")
        print(f"Min Latency:       {min_latency*1000:.2f}ms")
        print(f"Max Latency:       {max_latency*1000:.2f}ms")
        print(f"{'='*50}\n")

        output = {
            "timestamp": datetime.now().isoformat(),
            "config": {"concurrent_users": concurrent_users, "duration_seconds": duration_seconds},
            "results": {
                "total_requests": results["total_requests"],
                "success": results["success"],
                "errors": results["errors"],
                "error_rate_percent": round(error_rate, 2),
                "requests_per_second": round(rps, 2),
                "avg_latency_ms": round(avg_latency * 1000, 2),
                "min_latency_ms": round(min_latency * 1000, 2),
                "max_latency_ms": round(max_latency * 1000, 2),
            }
        }
        with open("load_test_results.json", "w") as f:
            json.dump(output, f, indent=2)
        print("Results saved to load_test_results.json")

if __name__ == "__main__":
    concurrent = int(sys.argv[1]) if len(sys.argv) > 1 else 10
    duration = int(sys.argv[2]) if len(sys.argv) > 2 else 30
    asyncio.run(load_test(concurrent, duration))

from fastapi import FastAPI


app = FastAPI(
    title="SentinelOps Alert Service",
    description="Evaluates security events and creates alerts for SentinelOps Phase 1.",
    version="0.1.0",
)


@app.get("/health")
def health_check():
    return {
        "service": "alert-service",
        "status": "healthy",
    }

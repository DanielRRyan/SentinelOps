from fastapi import FastAPI
from pydantic import BaseModel
from datetime import datetime
from typing import Optional


app = FastAPI(
    title="SentinelOps Event Ingestion Service",
    description="Accepts normalized security events for SentinelOps Phase 1.",
    version="0.1.0",
)


class SecurityEvent(BaseModel):
    event_type: str
    source_system: str
    source_ip: Optional[str] = None
    destination_ip: Optional[str] = None
    username: Optional[str] = None
    hostname: Optional[str] = None
    severity: str
    raw_message: Optional[str] = None
    event_timestamp: datetime


@app.get("/health")
def health_check():
    return {
        "service": "event-ingestion-service",
        "status": "healthy",
    }


@app.post("/events")
def receive_event(event: SecurityEvent):
    return {
        "message": "event received",
        "event_type": event.event_type,
        "source_system": event.source_system,
        "status": "New",
    }

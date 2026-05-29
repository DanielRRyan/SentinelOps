from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from datetime import datetime
from typing import Optional
import psycopg2
import os


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


def get_db_connection():
    return psycopg2.connect(
        host=os.getenv("DATABASE_HOST", "postgres"),
        port=os.getenv("DATABASE_PORT", "5432"),
        dbname=os.getenv("DATABASE_NAME", "sentinelops"),
        user=os.getenv("DATABASE_USER", "sentinelops_user"),
        password=os.getenv("DATABASE_PASSWORD", "sentinelops_password"),
    )


@app.get("/health")
def health_check():
    try:
        conn = get_db_connection()
        conn.close()

        return {
            "service": "event-ingestion-service",
            "status": "healthy",
            "database": "connected"
        }

    except Exception as e:
        return {
            "service": "event-ingestion-service",
            "status": "unhealthy",
            "database": str(e)
        }


@app.post("/events")
def receive_event(event: SecurityEvent):

    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        insert_query = """
        INSERT INTO events (
            event_type,
            source_system,
            source_ip,
            destination_ip,
            username,
            hostname,
            severity,
            raw_message,
            event_timestamp,
            processed_status
        )
        VALUES (
            %s, %s, %s, %s, %s,
            %s, %s, %s, %s, %s
        )
        RETURNING event_id;
        """

        cursor.execute(
            insert_query,
            (
                event.event_type,
                event.source_system,
                event.source_ip,
                event.destination_ip,
                event.username,
                event.hostname,
                event.severity,
                event.raw_message,
                event.event_timestamp,
                "New"
            )
        )

        event_id = cursor.fetchone()[0]

        conn.commit()

        cursor.close()
        conn.close()

        return {
            "message": "event stored",
            "event_id": str(event_id),
            "status": "New"
        }

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Database error: {str(e)}"
        )

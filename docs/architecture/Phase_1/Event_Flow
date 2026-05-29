Phase 1 Event Flow

Phase 1 begins with a security event being submitted to the Event Ingestion Service through a REST API endpoint.

The Event Ingestion Service validates the incoming event, stores the event in PostgreSQL, and returns a response containing the event identifier and submission status.

After the event is stored, the Alert Service evaluates the event and determines whether an alert should be created. In Phase 1, this evaluation is intentionally simple. The Alert Service may create an alert based on event type, source IP, username, or other basic event attributes.

If an alert is created, the Alert Service stores the alert in PostgreSQL and assigns it an initial status of `Open`.

The basic Phase 1 flow is:

```text
Security Event
     |
     v
Event Ingestion Service
     |
     v
PostgreSQL Events Table
     |
     v
Alert Service
     |
     v
PostgreSQL Alerts Table
```

This flow establishes the first production-style service boundary in SentinelOps. The Event Ingestion Service is responsible for accepting and storing events, while the Alert Service is responsible for evaluating events and managing alerts.

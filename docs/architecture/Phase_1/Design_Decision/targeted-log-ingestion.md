### Targeted Log Ingestion
Status

Accepted

Context

SentinelOps is intended to simulate a production-style security operations platform. A complete log ingestion platform could support many log sources, formats, parsers, collectors, and integrations. However, attempting to support all possible log types during Phase 1 would increase complexity before the core microservices architecture is working.

Phase 1 needs a focused ingestion scope that is realistic enough to demonstrate security event processing while remaining small enough to build, test, and explain clearly.

### Decision

Phase 1 will use targeted log ingestion.

The platform will initially focus on a limited set of simulated security event sources:

Windows authentication events
Linux SSH authentication events
Firewall connection events

These sources were selected because they represent common enterprise security telemetry and provide useful examples for failed logins, successful logins, suspicious access attempts, blocked connections, and network activity.

### Ingestion Model

During Phase 1, logs will not be collected directly from live endpoints.

Instead, sample log events will be submitted to the Event Ingestion Service through a REST API.

The Event Ingestion Service will validate the submitted event, normalize it into the SentinelOps event format, store it in PostgreSQL, and return a submission response.

### Processing Flow
Simulated Log Source
     |
     v
Event Submission
     |
     v
Event Ingestion Service
     |
     v
Event Validation
     |
     v
Event Normalization
     |
     v
PostgreSQL Events Table
     |
     v
Alert Service Polling Process

### Supported Phase 1 Event Types

Phase 1 will initially support the following event types:

failed_login
successful_login
firewall_block
suspicious_ip_connection

Additional event types may be added in later phases.

Normalized Event Fields

Each submitted event should be converted into a common event structure.

Initial normalized fields include:

event_id
event_type
source_system
source_ip
destination_ip
username
hostname
severity
raw_message
event_timestamp
received_timestamp
processed_status
Out of Scope for Phase 1

The following capabilities are intentionally out of scope for Phase 1:

Live endpoint log collection
Syslog ingestion
Windows Event Forwarding
Filebeat or agent-based collection
Kafka-based streaming
Cloud-native log integrations
Full SIEM-scale normalization
Complex parsing pipelines
Future Considerations

A future Log Collector service may be introduced to read logs from files, endpoints, syslog streams, or cloud services.

When introduced, the Log Collector should submit events to the Event Ingestion Service rather than writing directly to PostgreSQL. This preserves validation, normalization, and audit consistency.

Future ingestion enhancements may include:

File-based log ingestion
Syslog listener support
Agent-based collection
Cloud provider log ingestion
Parser libraries for different log formats
Kafka or RabbitMQ event streaming
Dead-letter queues for malformed events
Schema versioning
Rationale

Targeted log ingestion keeps Phase 1 focused on proving the microservices foundation. The selected scope supports realistic cybersecurity workflows without creating unnecessary complexity before the core architecture is implemented.

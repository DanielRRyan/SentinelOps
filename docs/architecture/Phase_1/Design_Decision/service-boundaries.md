Service Boundaries
Status

Accepted

Context

SentinelOps Phase 1 requires clear service boundaries to prevent responsibility overlap between components.

Without defined boundaries, services can become tightly coupled, difficult to test, and difficult to replace. Clear boundaries also support future migration from database polling to event-driven messaging using Kafka or RabbitMQ.

Decision

Phase 1 will define three primary system components:

Event Ingestion Service
Alert Service
PostgreSQL Database

Each component will have a specific responsibility and will not perform work owned by another component.

Event Ingestion Service

The Event Ingestion Service is responsible for receiving security events through a REST API.

Responsibilities
Accept incoming security events
Validate required event fields
Normalize event data into the SentinelOps event format
Store validated events in PostgreSQL
Return event submission status to the client
Out of Scope

The Event Ingestion Service will not:

Generate alerts
Suppress events
Score risk
Manage alert status
Collect logs directly from endpoints or files
Alert Service

The Alert Service is responsible for evaluating stored events and creating alerts when appropriate.

Responsibilities
Poll PostgreSQL for unprocessed events
Apply event suppression rules
Evaluate events against alert logic
Create alerts when conditions are met
Mark events as processed
Manage basic alert lifecycle states
Out of Scope

The Alert Service will not:

Accept raw logs from external sources
Store raw events directly from clients
Normalize incoming log formats
Manage authentication
Perform long-term analytics
PostgreSQL Database

PostgreSQL provides persistent storage for Phase 1.

Responsibilities
Store normalized security events
Store generated alerts
Store event processing status
Preserve records needed for auditing and troubleshooting
Out of Scope

PostgreSQL will not:

Make alerting decisions
Apply suppression logic
Validate business rules beyond basic constraints
Replace application-level processing
Future Log Collector

A Log Collector may be introduced in a later phase.

The Log Collector would be responsible for reading or receiving logs from external systems, parsing them, and forwarding normalized events to the Event Ingestion Service.

The Log Collector will not write directly to PostgreSQL. All event data must pass through the Event Ingestion Service to preserve validation, normalization, and audit consistency.

Consequences
Positive Consequences
Clear ownership between services
Reduced coupling
Easier testing
Easier troubleshooting
Cleaner path to future event-driven architecture
Negative Consequences
More explicit coordination is required between components
Some logic may feel duplicated early in development
Future services must respect established boundaries
Rationale

The selected service boundaries keep Phase 1 focused while supporting future growth. The Event Ingestion Service owns event intake, the Alert Service owns alert decisions, and PostgreSQL owns persistence.

This separation creates a realistic microservices foundation without overcomplicating the first implementation phase.

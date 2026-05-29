Phase 1 Design Decision: Database Polling

SentinelOps Phase 1 will use a database polling model for communication between the Event Ingestion Service and the Alert Service.

In this design, the Event Ingestion Service is responsible for receiving, validating, and storing security events in PostgreSQL. The Alert Service operates independently and periodically checks the database for new events that have not yet been processed.

This approach was selected because it creates a cleaner separation of responsibilities between services. The Event Ingestion Service does not directly call the Alert Service, which reduces tight coupling and better prepares the platform for a future event-driven architecture using Kafka or RabbitMQ.

Processing Flow
Security Event
     |
     v
Event Ingestion Service
     |
     v
PostgreSQL Events Table
     |
     v
Alert Service Polling Process
     |
     v
Event Suppression Engine
     |
     v
Alert Evaluation Logic
     |
     v
PostgreSQL Alerts Table
Event Suppression Engine

To reduce alert fatigue, the Alert Service will include an Event Suppression Engine before generating alerts.

The purpose of the Event Suppression Engine is to identify known benign activity that should not generate analyst-facing alerts. This mirrors real-world Security Operations Center practices where excessive alert volume can reduce analyst effectiveness and increase the likelihood of missing legitimate threats.

Initially, event suppression will be implemented using rule-based logic.

Examples of suppressible events include:

Approved vulnerability scanners
Authorized administrative service accounts
Internal testing activities
Approved maintenance windows
Laboratory or training systems
Known benign network traffic patterns

When an event matches a suppression rule, the event will be marked as processed without generating an alert.

When an event does not match a suppression rule, the Alert Service will continue evaluating the event and determine whether an alert should be created.

Future Enhancements

Future phases may expand suppression capabilities through:

Centralized suppression rule management
Asset-based allowlists
Threat intelligence enrichment
Analyst feedback mechanisms
Alert correlation
Risk-based alert prioritization
Machine learning assisted classification

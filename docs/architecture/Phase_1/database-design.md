# Phase 1 Database Design

## Purpose

This document defines the initial PostgreSQL database design for SentinelOps Phase 1.

The database supports event storage, alert creation, suppression rule tracking, and processing auditability.

## Database Technology

SentinelOps Phase 1 will use PostgreSQL as the primary relational database.

PostgreSQL was selected because it supports structured data, relational integrity, indexing, timestamps, JSON fields, and reliable transactional behavior.

## Phase 1 Tables

The initial database will include four tables:

- events
- alerts
- suppression_rules
- event_processing_log

## events Table

The events table stores normalized security events submitted to the Event Ingestion Service.

### Purpose

The table provides a persistent record of security events before and after processing by the Alert Service.

### Fields

| Field | Type | Description |
|---------|---------|---------|
| event_id | UUID | Unique identifier for the event |
| event_type | VARCHAR | Type of event, such as failed_login or firewall_block |
| source_system | VARCHAR | System or tool that generated the event |
| source_ip | INET | Source IP address associated with the event |
| destination_ip | INET | Destination IP address associated with the event |
| username | VARCHAR | User account associated with the event |
| hostname | VARCHAR | Hostname associated with the event |
| severity | VARCHAR | Initial event severity |
| raw_message | TEXT | Original event message |
| event_timestamp | TIMESTAMP | Time the event occurred |
| received_timestamp | TIMESTAMP | Time SentinelOps received the event |
| processed_status | VARCHAR | Processing state of the event |
| created_at | TIMESTAMP | Record creation timestamp |
| updated_at | TIMESTAMP | Record update timestamp |

### Processing Status Values

Initial values:

- New
- Processing
- Processed
- Suppressed
- Error

## alerts Table

The alerts table stores analyst-facing alerts created by the Alert Service.

### Purpose

The table supports alert tracking, analyst review, and basic alert lifecycle management.

### Fields

| Field | Type | Description |
|---------|---------|---------|
| alert_id | UUID | Unique identifier for the alert |
| event_id | UUID | Related event that generated the alert |
| title | VARCHAR | Human-readable alert title |
| description | TEXT | Alert details |
| severity | VARCHAR | Alert severity |
| status | VARCHAR | Alert lifecycle status |
| created_at | TIMESTAMP | Alert creation timestamp |
| updated_at | TIMESTAMP | Alert update timestamp |

### Alert Status Values

Initial values:

- Open
- In Progress
- Closed
- Suppressed

## suppression_rules Table

The suppression_rules table stores known benign conditions that should not generate analyst-facing alerts.

### Purpose

Although Phase 1 may begin with simple rule-based suppression logic, this table establishes a future-ready structure for managing suppression rules outside application code.

### Fields

| Field | Type | Description |
|---------|---------|---------|
| rule_id | UUID | Unique identifier for the suppression rule |
| rule_name | VARCHAR | Human-readable name of the rule |
| rule_description | TEXT | Explanation of the suppression condition |
| event_type | VARCHAR | Event type affected by the rule |
| source_ip | INET | Source IP condition |
| username | VARCHAR | Username condition |
| hostname | VARCHAR | Hostname condition |
| active | BOOLEAN | Determines whether the rule is enabled |
| created_at | TIMESTAMP | Rule creation timestamp |
| updated_at | TIMESTAMP | Rule update timestamp |

## event_processing_log Table

The event_processing_log table records processing actions taken against events.

### Purpose

This table provides auditability and troubleshooting support by recording how each event was handled by the Alert Service.

### Fields

| Field | Type | Description |
|---------|---------|---------|
| log_id | UUID | Unique identifier for the processing log entry |
| event_id | UUID | Event associated with the processing action |
| action | VARCHAR | Processing action taken |
| action_reason | TEXT | Explanation of the action |
| service_name | VARCHAR | Service that performed the action |
| created_at | TIMESTAMP | Log entry creation timestamp |

### Example Processing Actions

- Event received
- Event selected for processing
- Event suppressed
- Alert created
- Event marked processed
- Processing error

## Relationships

The events table is the central record for submitted security events.

The alerts table references the events table through event_id.

The event_processing_log table references the events table through event_id.

Suppression rules are evaluated against event attributes but do not require a direct relationship to a specific event.

## Design Notes

The database design intentionally separates raw event storage, alert records, suppression rules, and processing logs.

This separation supports:

- Cleaner service responsibilities
- Easier troubleshooting
- Auditability
- Future reporting
- Future migration to event streaming

## Future Enhancements

Future phases may add:

- Asset inventory tables
- User identity tables
- Threat intelligence indicators
- Alert assignment tracking
- Case management
- Notification history
- Schema versioning
- Data retention policies
- Partitioning for high-volume event storage

## Rationale

The selected database design provides enough structure to support realistic Phase 1 functionality without overbuilding the system.

It supports the current requirements for event ingestion, alert generation, suppression, and auditability while leaving room for later expansion.

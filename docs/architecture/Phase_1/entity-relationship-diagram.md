# Phase 1 Entity Relationship Diagram

## Purpose

This document describes the initial entity relationships for the SentinelOps Phase 1 PostgreSQL database.

The purpose of this diagram is to show how security events, alerts, suppression rules, and processing logs relate to each other before the database schema is implemented.

## Entity Overview

Phase 1 includes four primary database entities:

- events
- alerts
- suppression_rules
- event_processing_log

## Relationship Summary

The `events` table is the central entity in the Phase 1 database design.

An event may generate zero or one alert.

An event may have many processing log entries.

Suppression rules are evaluated against event attributes but are not directly tied to a specific event record.

## Diagram

    +--------------------+
    | events             |
    +--------------------+
    | event_id (PK)      |
    | event_type         |
    | source_system      |
    | source_ip          |
    | destination_ip     |
    | username           |
    | hostname           |
    | severity           |
    | processed_status   |
    +---------+----------+
              |
              | 1 to 0..1
              v
    +--------------------+
    | alerts             |
    +--------------------+
    | alert_id (PK)      |
    | event_id (FK)      |
    | title              |
    | description        |
    | severity           |
    | status             |
    +--------------------+


    +--------------------+
    | events             |
    +--------------------+
    | event_id (PK)      |
    +---------+----------+
              |
              | 1 to many
              v
    +-------------------------+
    | event_processing_log    |
    +-------------------------+
    | log_id (PK)             |
    | event_id (FK)           |
    | action                  |
    | action_reason           |
    | service_name            |
    | created_at              |
    +-------------------------+


    +-------------------------+
    | suppression_rules       |
    +-------------------------+
    | rule_id (PK)            |
    | rule_name               |
    | event_type              |
    | source_ip               |
    | username                |
    | hostname                |
    | active                  |
    +------------+------------+
                 |
                 | evaluated against
                 v
    +-------------------------+
    | events                  |
    +-------------------------+
    | event_type              |
    | source_ip               |
    | username                |
    | hostname                |
    +-------------------------+

## Relationship Details

### events to alerts

Each event may generate zero or one alert.

This means not every event becomes an alert. Some events may be benign, suppressed, informational, or not significant enough to require analyst action.

The `alerts` table references the `events` table using `event_id`.

### events to event_processing_log

Each event may have multiple processing log entries.

This allows SentinelOps to preserve a history of actions taken against the event, such as when it was received, selected for processing, suppressed, converted into an alert, or marked as processed.

The `event_processing_log` table references the `events` table using `event_id`.

### suppression_rules to events

Suppression rules are evaluated against event attributes such as event type, source IP, username, and hostname.

Suppression rules do not require a direct foreign key relationship to the events table during Phase 1.

This allows suppression rules to act as reusable conditions that may apply to many different events.

## Cardinality

| Relationship | Cardinality | Description |
|---|---:|---|
| events to alerts | 1 to 0..1 | One event may generate zero or one alert |
| events to event_processing_log | 1 to many | One event may have many processing log entries |
| suppression_rules to events | many to many logical evaluation | Many rules may evaluate many events without a direct foreign key |

## Design Notes

The database design keeps event storage, alert records, suppression rules, and processing audit logs separate.

This separation supports clear service boundaries and avoids placing alerting logic directly inside the database.

The database stores the state of the system, while the Event Ingestion Service and Alert Service perform application-level processing.

## Future Enhancements

Future database enhancements may include:

- Linking suppression rule matches to specific events
- Adding an asset inventory table
- Adding user identity context
- Adding threat intelligence indicators
- Adding alert assignment and ownership
- Adding case management
- Adding notification history
- Adding data retention and archival policies
- Adding table partitioning for large event volumes

## Rationale

The Phase 1 entity relationship design supports the current SentinelOps architecture without overcomplicating the first implementation.

The design preserves auditability, supports alert suppression, and provides a stable foundation for future microservices, event streaming, and SOC workflow enhancements.

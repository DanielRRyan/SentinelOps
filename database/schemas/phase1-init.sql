-- SentinelOps Phase 1 Initial Database Schema
-- Database: PostgreSQL

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS events (
    event_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_type VARCHAR(100) NOT NULL,
    source_system VARCHAR(100) NOT NULL,
    source_ip INET,
    destination_ip INET,
    username VARCHAR(100),
    hostname VARCHAR(255),
    severity VARCHAR(50) NOT NULL,
    raw_message TEXT,
    event_timestamp TIMESTAMP NOT NULL,
    received_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    processed_status VARCHAR(50) NOT NULL DEFAULT 'New',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS alerts (
    alert_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID NOT NULL REFERENCES events(event_id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    severity VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'Open',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS suppression_rules (
    rule_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    rule_name VARCHAR(255) NOT NULL,
    rule_description TEXT,
    event_type VARCHAR(100),
    source_ip INET,
    username VARCHAR(100),
    hostname VARCHAR(255),
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS event_processing_log (
    log_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID NOT NULL REFERENCES events(event_id) ON DELETE CASCADE,
    action VARCHAR(100) NOT NULL,
    action_reason TEXT,
    service_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_events_processed_status
ON events(processed_status);

CREATE INDEX IF NOT EXISTS idx_events_event_type
ON events(event_type);

CREATE INDEX IF NOT EXISTS idx_events_source_ip
ON events(source_ip);

CREATE INDEX IF NOT EXISTS idx_alerts_status
ON alerts(status);

CREATE INDEX IF NOT EXISTS idx_alerts_severity
ON alerts(severity);

CREATE INDEX IF NOT EXISTS idx_suppression_rules_active
ON suppression_rules(active);

CREATE INDEX IF NOT EXISTS idx_event_processing_log_event_id
ON event_processing_log(event_id);

INSERT INTO suppression_rules (
    rule_name,
    rule_description,
    event_type,
    source_ip,
    username,
    hostname,
    active
)
VALUES
(
    'Approved Vulnerability Scanner',
    'Suppresses known vulnerability scanner traffic from the approved internal scanner.',
    'firewall_block',
    '192.168.100.10',
    NULL,
    NULL,
    TRUE
),
(
    'Authorized Service Account Login',
    'Suppresses expected successful login events from an approved service account.',
    'successful_login',
    NULL,
    'svc_backup',
    NULL,
    TRUE
),
(
    'Internal Lab System Activity',
    'Suppresses known test activity from the internal lab host.',
    NULL,
    NULL,
    NULL,
    'lab-system-01',
    TRUE
);

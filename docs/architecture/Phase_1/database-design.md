### Phase 1, PostgreSQL should have four tables:

events
alerts
suppression_rules
event_processing_log

### Reason:

events stores normalized security events.
alerts stores analyst-facing alerts.
suppression_rules supports the Event Suppression Engine.
event_processing_log gives you auditability and troubleshooting evidence.

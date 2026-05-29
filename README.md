# SentinelOps
Production-Style Security Operations Platform
SentinelOps is a production-style Security Operations Center (SOC) platform built using a microservices architecture. The platform simulates the collection, processing, enrichment, scoring, and management of cybersecurity events generated from enterprise systems. The project is designed to demonstrate real-world software engineering, cloud-native architecture, DevSecOps practices, observability, and cybersecurity operations workflows.

The primary objective of SentinelOps is to provide hands-on experience building and operating production-grade microservices while showcasing the skills commonly expected of Software Engineers, Site Reliability Engineers (SREs), DevOps Engineers, Cloud Engineers, Security Engineers, and Cybersecurity Architects.

---

# Project Goals

This project is intended to demonstrate practical experience with:

- Microservices Architecture
- REST API Development
- Event-Driven Design
- Containerization
- Database Design
- Authentication and Authorization
- CI/CD Pipelines
- Infrastructure as Code
- Cloud-Native Operations
- Distributed Tracing
- Monitoring and Logging
- Secure Software Development Lifecycle (SSDLC)
- Security Operations Center (SOC) Workflows

---

# Business Scenario

A mid-sized enterprise requires a centralized platform capable of ingesting cybersecurity events from multiple security tools and infrastructure components.

Current security systems generate logs independently, creating visibility gaps and slowing incident response efforts.

SentinelOps addresses these challenges by:

- Collecting security events from various sources
- Enriching event data with asset context
- Scoring risk levels
- Generating actionable alerts
- Supporting analyst workflows
- Providing dashboards and operational metrics

The platform serves as a simulated enterprise SOC environment.

---

# System Architecture

The platform consists of multiple independent services communicating through APIs and event messaging.

## Planned Services

| Service | Purpose |
|----------|---------|
| API Gateway | Centralized routing and API management |
| Auth Service | Authentication and authorization |
| Event Ingestion Service | Accepts security events |
| Asset Service | Maintains asset inventory |
| Threat Intelligence Service | Provides enrichment data |
| Risk Scoring Service | Calculates event risk scores |
| Alert Service | Creates and manages alerts |
| Notification Service | Sends notifications |
| Dashboard API | Provides reporting and analytics |

---

# Phase 1 Scope

The first phase focuses on establishing the foundational architecture.

## Included Components

### Event Ingestion Service

Accepts incoming security events via REST API.

Example event:

```json
{
  "event_type": "failed_login",
  "source_ip": "192.168.1.10",
  "username": "jdoe",
  "timestamp": "2026-05-29T18:00:00Z"
}
```

### Alert Service

Receives processed events and generates alerts.

Example alert:

```json
{
  "alert_id": 1001,
  "severity": "Medium",
  "status": "Open",
  "title": "Multiple Failed Logins"
}
```

### PostgreSQL Database

Stores:

- Events
- Alerts
- Audit records

### Docker Compose

Provides local development environment including:

- Event Ingestion Service
- Alert Service
- PostgreSQL

### Initial Integration Testing

Validate:

- Event creation
- Alert generation
- Database persistence

---

# Phase 1 Architecture

```text
+--------------------+
| Event Producer     |
+---------+----------+
          |
          v
+--------------------+
| Event Ingestion    |
| Service            |
+---------+----------+
          |
          v
+--------------------+
| PostgreSQL         |
+---------+----------+
          |
          v
+--------------------+
| Alert Service      |
+---------+----------+
          |
          v
+--------------------+
| Alert Database     |
+--------------------+
```

---

# Technology Stack

## Backend

- Python 3.12
- FastAPI
- SQLAlchemy
- Pydantic

## Database

- PostgreSQL

## Containerization

- Docker
- Docker Compose

## Testing

- Pytest
- HTTPX

## Documentation

- OpenAPI
- Markdown

---

# Future Enhancements

## Phase 2

Event-driven architecture using:

- Apache Kafka
or
- RabbitMQ

## Phase 3

Identity and Access Management

- Keycloak
- JWT Authentication
- RBAC

## Phase 4

Observability

- OpenTelemetry
- Prometheus
- Grafana
- Jaeger

## Phase 5

DevSecOps

- GitHub Actions
- Semgrep
- Trivy
- Dependabot

## Phase 6

Container Orchestration

- Kubernetes
- Helm

## Phase 7

Infrastructure as Code

- Terraform

---

# Repository Structure

```text
sentinelops/
│
├── services/
│   ├── event-ingestion-service/
│   └── alert-service/
│
├── database/
│   ├── migrations/
│   └── schemas/
│
├── docs/
│   ├── architecture/
│   ├── runbooks/
│   ├── threat-model/
│   └── adr/
│
├── tests/
│   ├── unit/
│   └── integration/
│
├── infrastructure/
│   ├── docker/
│   └── kubernetes/
│
├── .github/
│   └── workflows/
│
└── README.md
```

---

# Learning Objectives

Upon completion of this project, the developer will have demonstrated experience with:

- Designing distributed systems
- Building RESTful microservices
- Database modeling
- Containerized application deployment
- CI/CD automation
- Security engineering concepts
- Monitoring and observability
- Cloud-native architecture
- Production operations practices

---

# Project Roadmap

## Phase 1: Foundation
- Event Ingestion Service
- Alert Service
- PostgreSQL
- Docker Compose

## Phase 2: Event Streaming
- Kafka
- Async Processing

## Phase 3: Authentication
- Keycloak
- JWT
- RBAC

## Phase 4: Observability
- OpenTelemetry
- Prometheus
- Grafana
- Jaeger

## Phase 5: DevSecOps
- GitHub Actions
- Semgrep
- Trivy

## Phase 6: Kubernetes
- Deployments
- Services
- Ingress

## Phase 7: Infrastructure as Code
- Terraform

# Author

Daniel Ryan

## Professional Development Project

This repository serves as a portfolio project demonstrating production-style microservices engineering, DevSecOps practices, cybersecurity operations workflows, and enterprise application architecture.

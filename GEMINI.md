# Gemini Workspace Context: Smart University Management Platform

This document provides a comprehensive overview of the "Smart University Management Platform" project, intended to be used as a guiding context for the Gemini AI assistant.

## Project Overview

The project is a "Smart University Management Platform" developed as part of a Software Analysis and Design course. It is built using a microservices architecture and is designed to be a scalable and resilient system. The platform includes features for user management, resource booking, a marketplace, online exams, and IoT device integration.

The core of the project is a set of loosely coupled microservices that communicate via REST APIs and a message broker (RabbitMQ). The system is designed to be multi-tenant, with data isolation between different faculties or sellers.

## Technology Stack

*   **Backend:** Java 17/21 with Spring Boot 3.2+
*   **Frontend:** React 18+ or Vue 3+
*   **Databases:**
    *   PostgreSQL 15+ (Primary relational data)
    *   TimescaleDB (Time-series data for IoT)
    *   Redis 7+ (Caching, session management)
*   **Messaging:** RabbitMQ 3.12+
*   **API Gateway:** Spring Cloud Gateway
*   **Resilience:** Resilience4j (for Circuit Breaker pattern)
*   **Containerization:** Docker and Docker Compose
*   **Build Tool:** Maven

## Microservices

The architecture consists of the following microservices:

| Service               | Port | Description                                      |
| --------------------- | ---- | ------------------------------------------------ |
| API Gateway           | 8080 | Entry point, routing, authentication             |
| Auth Service          | 8081 | Authentication, JWT generation                   |
| User Service          | 8082 | User management                                  |
| Resource Service      | 8083 | Management of bookable resources                 |
| Booking Service       | 8084 | Handling resource reservations                   |
| Marketplace Service   | 8085 | Product and order management, implements Saga    |
| Payment Service       | 8086 | Payment processing, Saga participant             |
| Exam Service          | 8087 | Online exams, implements Circuit Breaker         |
| Notification Service  | 8088 | Sending notifications (email, SMS)               |
| IoT Service           | 8089 | Processing and serving sensor data               |
| Tracking Service      | 8090 | Tracking shuttle locations                       |

## Key Design Patterns

The following design patterns are mandatory for this project:

1.  **Saga Pattern (Choreography-based):** For the purchase flow in the Marketplace Service to ensure data consistency across services.
2.  **Circuit Breaker Pattern:** Implemented in the Exam Service when communicating with the Notification Service to prevent cascading failures.
3.  **Strategy Pattern:** Used in the Payment Service to handle different payment methods.
4.  **Observer Pattern:** Used in the Notification Service to allow multiple notification channels to subscribe to events.
5.  **State Pattern:** Used in the Exam Service to manage the lifecycle of an exam (Draft, Active, Closed).

## Building and Running

*   **Build the project:**
    ```bash
    # To build all services, you might need a parent pom.xml or a script.
    # To build a single service:
    cd services/<service-name>
    mvn clean install
    ```
*   **Run the entire system (for development):**
    ```bash
    docker-compose up
    ```
*   **Run tests:**
    ```bash
    # To run tests for a single service:
    cd services/<service-name>
    mvn test
    ```

## Development Conventions

*   **Microservices Architecture:** The system is composed of independent services, each with its own database (Database per Service pattern).
*   **Communication:** Services communicate synchronously via REST APIs and asynchronously via RabbitMQ for event-driven communication.
*   **Multi-Tenancy:** Data is isolated on a per-tenant basis using a schema-per-tenant strategy in PostgreSQL. The tenant ID is extracted from the JWT token.
*   **Authentication:** JWT-based authentication is used, with Role-Based Access Control (RBAC).
*   **Code Style:** Follow SOLID principles and the existing code style.
*   **Documentation:** All major architecture decisions must be documented as Architecture Decision Records (ADRs) in the `docs/architecture/adrs/` directory.

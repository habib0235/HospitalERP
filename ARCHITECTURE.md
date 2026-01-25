# HospitalERP - Architecture Documentation

## Architectural Overview

HospitalERP follows a **Clean Architecture** pattern with a modular Maven structure, ensuring separation of concerns, maintainability, and testability.

## Architecture Style

### Clean Architecture Layers
```
┌─────────────────────────────────────────────┐
│         hospitalerp-boot (Entry Point)      │
│         (Spring Boot Configuration)         │
└────────────────┬────────────────────────────┘
                 │
┌────────────────▼────────────────────────────┐
│         hospitalerp-api (Controllers)       │
│         (REST API / Presentation Layer)     │
└────────────────┬────────────────────────────┘
                 │
┌────────────────▼────────────────────────────┐
│      hospitalerp-service (Use Cases)        │
│         (Business Logic Layer)              │
└────────────────┬────────────────────────────┘
                 │
┌────────────────▼────────────────────────────┐
│   hospitalerp-persistence (Repositories)    │
│         (Data Access Layer)                 │
└────────────────┬────────────────────────────┘
                 │
┌────────────────▼────────────────────────────┐
│     hospitalerp-domain (Entities/Models)    │
│         (Core Domain Layer)                 │
└─────────────────────────────────────────────┘
```

## Module Breakdown

### 1. hospitalerp-domain
**Purpose**: Core business entities and domain logic

**Responsibilities**:
- JPA Entity definitions
- Domain value objects
- Domain-specific exceptions
- Business rules and constraints

**Key Characteristics**:
- **No dependencies** on other application modules
- Framework dependencies only (JPA, Lombok)
- Represents the core domain model
- Should be database-agnostic at the domain level

**Current Entities**:
- `Doctor` - Medical practitioners
- `Patient` - Hospital patients
- `Department` - Hospital departments
- `Nurse` - Nursing staff
- `Appointment` - Doctor-patient appointments
- `Admission` - Patient admissions
- `Room` - Hospital rooms
- `Prescription` - Medical prescriptions
- `MedicalRecord` - Patient medical history
- `InventoryItem` - Medical supplies
- `InventoryStock` - Stock levels
- `Supplier` - Supply vendors

### 2. hospitalerp-persistence
**Purpose**: Data access and repository implementations

**Responsibilities**:
- Spring Data JPA repositories
- Custom query implementations
- Database-specific operations
- Transaction management

**Dependencies**:
- `hospitalerp-domain`
- Spring Data JPA
- Database drivers

**Status**: ⚠️ Currently empty - to be implemented

**Planned Structure**:
```
com.example.hospitalerp.repository/
├── DoctorRepository
├── PatientRepository
├── AppointmentRepository
├── AdmissionRepository
├── DepartmentRepository
└── [other repositories]
```

### 3. hospitalerp-service
**Purpose**: Business logic and use case implementations

**Responsibilities**:
- Business logic orchestration
- Transaction boundaries
- Business rule validation
- Service-level exception handling
- DTO transformations

**Dependencies**:
- `hospitalerp-domain`
- `hospitalerp-persistence`
- Spring Framework

**Status**: ⚠️ Currently empty - to be implemented

**Planned Structure**:
```
com.example.hospitalerp.service/
├── DoctorService
├── PatientService
├── AppointmentService
├── AdmissionService
└── [other services]

com.example.hospitalerp.dto/
├── DoctorDTO
├── PatientDTO
└── [other DTOs]

com.example.hospitalerp.mapper/
├── DoctorMapper
└── [other mappers]
```

### 4. hospitalerp-api
**Purpose**: REST API controllers and presentation layer

**Responsibilities**:
- HTTP request/response handling
- REST endpoint definitions
- Request validation
- Response formatting
- API-level exception handling

**Dependencies**:
- `hospitalerp-service`
- `hospitalerp-domain` (for DTOs)
- Spring Web

**Current Implementation**:
- `DoctorController` - Doctor management endpoints

**Recommended Structure**:
```
com.example.hospitalerp.controller/
├── DoctorController
├── PatientController
├── AppointmentController
└── [other controllers]

com.example.hospitalerp.request/
├── CreateDoctorRequest
├── UpdateDoctorRequest
└── [other request objects]

com.example.hospitalerp.response/
├── DoctorResponse
├── ApiErrorResponse
└── [other response objects]
```

### 5. hospitalerp-boot
**Purpose**: Application entry point and configuration

**Responsibilities**:
- Spring Boot application configuration
- Bean definitions
- Profile management
- Global exception handling
- Cross-cutting concerns (security, logging, etc.)

**Dependencies**:
- All other modules
- Spring Boot starters
- Database drivers
- Monitoring tools

**Key Files**:
- `HospitalErpApplication.java` - Main entry point
- `ApiErrorHandler.java` - Global exception handler
- `application.properties` - Configuration properties

## Data Flow

### Request Flow (Typical REST API Call)
```
1. Client HTTP Request
        ↓
2. Spring DispatcherServlet
        ↓
3. Controller (hospitalerp-api)
   - Validates request
   - Maps to service call
        ↓
4. Service (hospitalerp-service)
   - Executes business logic
   - Applies business rules
   - Calls repository
        ↓
5. Repository (hospitalerp-persistence)
   - Executes database query
   - Maps results to entities
        ↓
6. Entity (hospitalerp-domain)
   - Domain object returned
        ↓
7. Service transforms Entity → DTO
        ↓
8. Controller formats DTO → Response
        ↓
9. Client receives HTTP Response
```

### Current Flow (Temporary Pattern)
```
Controller → EntityManager (Direct) → Database
```
⚠️ **Note**: DoctorController currently uses EntityManager directly. This should be refactored to use the repository pattern once the persistence module is implemented.

## Design Patterns

### 1. Layered Architecture
- Clear separation between presentation, business logic, and data access
- Each layer depends only on the layer below it

### 2. Repository Pattern (Planned)
- Abstracts data access logic
- Provides a collection-like interface for domain objects
- Enables easier testing and database switching

### 3. DTO Pattern (Planned)
- Separates internal domain models from API contracts
- Prevents over-exposure of domain details
- Allows independent evolution of API and domain

### 4. Builder Pattern
- Used in domain entities via Lombok's `@Builder`
- Provides fluent API for object construction

### 5. Dependency Injection
- Spring's IoC container manages dependencies
- Promotes loose coupling and testability

## Database Architecture

### Database: Oracle XE 21
- **Type**: Relational Database
- **Deployment**: Docker container (gvenzl/oracle-xe:21-slim)
- **Port**: 1521
- **Service Name**: XEPDB1
- **Schema Owner**: hospitalerp

### Schema Management Strategy
1. **Liquibase** - Version control for database
2. **Migration Files** - Located in `db/changelog/`
3. **DDL Scripts** - `sql/001-hospital-ddl.sql`
4. **Data Scripts** - `sql/002-hospital-data.sql`

### Database Connection Pooling
- **Provider**: HikariCP (Spring Boot default)
- **Max Pool Size**: 10 connections
- **Connection Timeout**: 30 seconds
- **Validation Timeout**: 5 seconds

### Key Database Design Principles
1. **Normalized Schema** - 3NF normalization
2. **Foreign Key Constraints** - Referential integrity
3. **Lazy Loading** - Performance optimization for relationships
4. **Audit Fields** - Consider adding created_at, updated_at, created_by, updated_by

## Infrastructure Architecture

### Containerization Strategy

#### Multi-Stage Docker Build
```dockerfile
Stage 1: Builder
- Maven build environment
- Compiles and packages application
- Output: hospitalerp-boot JAR

Stage 2: Runtime
- Lightweight JRE image
- Only includes runtime dependencies
- Smaller final image size
```

#### Docker Compose Stack
```yaml
Services:
  1. oracle (database)
     - Health checks enabled
     - Persistent volume for data
     - Custom initialization scripts
  
  2. backend (Spring Boot app)
     - Depends on oracle health
     - Environment-based configuration
     - Restart policy: unless-stopped
```

### Deployment Model
```
Docker Compose
├── oracle container (1521)
│   └── Volume: oracle-data
│
└── backend container (8081)
    └── Depends on: oracle (healthy)
```

## Security Architecture

### Current State
⚠️ **No security implemented** - Development stage

### Recommended Security Architecture

#### 1. Authentication
- Spring Security + JWT
- Token-based authentication
- Refresh token mechanism

#### 2. Authorization
- Role-based access control (RBAC)
- Permissions: READ, WRITE, DELETE
- Roles: ADMIN, DOCTOR, NURSE, RECEPTIONIST, PATIENT

#### 3. Security Layers
```
┌─────────────────────────────────┐
│    API Gateway / Load Balancer  │ ← HTTPS/TLS, Rate Limiting
└────────────────┬────────────────┘
                 │
┌────────────────▼────────────────┐
│    Spring Security Filter Chain │ ← JWT Validation, CORS
└────────────────┬────────────────┘
                 │
┌────────────────▼────────────────┐
│    Controller Authorization     │ ← @PreAuthorize, Role Checks
└────────────────┬────────────────┘
                 │
┌────────────────▼────────────────┐
│    Service Layer Validation     │ ← Business Rules, ACL
└─────────────────────────────────┘
```

#### 4. Data Security
- Encrypt sensitive data at rest
- Use SSL/TLS for data in transit
- Implement audit logging
- Apply principle of least privilege

## Error Handling Architecture

### Current Implementation
- Global exception handler: `ApiErrorHandler`
- Spring Boot error configuration
- Custom error responses for API endpoints

### Error Handling Strategy
```
Exception Occurs
    ↓
Try to handle at Service Layer
    ↓ (if not handled)
Controller handles specific exceptions
    ↓ (if not handled)
Global Exception Handler (@ControllerAdvice)
    ↓
Format error response (JSON)
    ↓
Return HTTP error response
```

### Recommended Error Categories
1. **400 Bad Request** - Invalid input
2. **401 Unauthorized** - Authentication failure
3. **403 Forbidden** - Authorization failure
4. **404 Not Found** - Resource not found
5. **409 Conflict** - Business rule violation
6. **500 Internal Server Error** - Unexpected errors
7. **503 Service Unavailable** - Database/external service down

## Scalability Considerations

### Horizontal Scaling
- Stateless application design
- Externalized session management (Redis recommended)
- Load balancer distribution

### Vertical Scaling
- JVM tuning (heap size, GC strategy)
- Connection pool optimization
- Database connection management

### Caching Strategy (Recommended)
```
Level 1: Application Cache (Caffeine)
Level 2: Distributed Cache (Redis)
Level 3: Database Query Cache
```

### Async Processing (Future)
- Message Queue (RabbitMQ/Kafka)
- Background jobs for reports
- Email notifications
- Audit log processing

## Monitoring Architecture

### Application Metrics
- Spring Boot Actuator endpoints
- JVM metrics (memory, threads, GC)
- Custom business metrics

### Health Checks
- Database connectivity
- External service availability
- Application readiness

### Recommended Monitoring Stack
```
Application (Micrometer)
    ↓
Prometheus (Metrics Collection)
    ↓
Grafana (Visualization)

Logs (Logback) → ELK Stack or Loki
Traces (Sleuth) → Zipkin or Jaeger
```

## API Architecture

### REST Principles
- Resource-based URLs
- HTTP verbs for operations (GET, POST, PUT, DELETE, PATCH)
- Stateless communication
- JSON response format
- Hypermedia controls (HATEOAS) - future consideration

### API Versioning Strategy (Recommended)
- URI versioning: `/api/v1/doctors`
- Header versioning: `Accept: application/vnd.hospitalerp.v1+json`

### Response Structure
```json
{
  "data": {},
  "metadata": {},
  "errors": [],
  "timestamp": "2026-01-25T10:00:00Z"
}
```

## Testing Architecture

### Testing Pyramid
```
       ┌─────────────┐
       │   E2E Tests │  ← Few, high-value scenarios
       └─────────────┘
      ┌───────────────┐
      │Integration Tests│ ← API + Database tests
      └───────────────┘
    ┌──────────────────┐
    │   Unit Tests      │ ← Majority of tests
    └──────────────────┘
```

### Testing Layers
1. **Unit Tests** - Service/Controller logic (JUnit 5, Mockito)
2. **Integration Tests** - Repository/Database (Testcontainers)
3. **API Tests** - REST endpoints (MockMvc, RestAssured)
4. **Contract Tests** - API contracts (Spring Cloud Contract)

## Technology Decision Log

### Why Oracle Database?
- Enterprise-grade reliability
- Strong ACID compliance
- Advanced features for healthcare data
- Robust transaction management

### Why Spring Boot?
- Rapid development
- Production-ready features
- Large ecosystem
- Industry standard for Java applications

### Why Multi-Module Maven?
- Clear separation of concerns
- Reusable modules
- Independent versioning potential
- Better build management

### Why Docker?
- Consistent environments
- Easy local development
- Production-ready deployment
- Infrastructure as code

## Future Architecture Enhancements

1. **Microservices Migration** (if needed)
   - Split by bounded contexts
   - API Gateway pattern
   - Service mesh (Istio)

2. **Event-Driven Architecture**
   - Domain events
   - Event sourcing
   - CQRS pattern

3. **Cloud-Native**
   - Kubernetes deployment
   - Cloud provider integration
   - Auto-scaling

4. **API Gateway**
   - Centralized routing
   - Authentication
   - Rate limiting
   - API composition

---
*Last Updated: January 25, 2026*
*Architecture Version: 1.0*

# HospitalERP - Project Context

## Project Overview
HospitalERP is a comprehensive hospital management system built with Spring Boot and Oracle Database. The system manages hospital operations including patient records, doctor schedules, appointments, admissions, inventory, and departmental operations.

## Technology Stack

### Backend
- **Java 17** - Primary programming language
- **Spring Boot 3.3.2** - Application framework
- **Spring Data JPA** - Data persistence layer
- **Hibernate** - ORM implementation
- **Oracle Database XE 21** - Primary database
- **Liquibase** - Database migration management
- **Lombok** - Code generation for POJOs

### Build & DevOps
- **Maven 3.9+** - Build automation and dependency management
- **Docker** - Containerization
- **Docker Compose** - Multi-container orchestration
- **Jenkins** - CI/CD pipeline (Jenkinsfile present)

### Database
- **Oracle Database XE 21** (via gvenzl/oracle-xe:21-slim)
- **JDBC Driver**: ojdbc11 (23.3.0.23.09)
- **Connection Pool**: HikariCP (Spring Boot default)

## Project Structure

This is a multi-module Maven project following clean architecture principles:

```
HospitalERP/
├── hospitalerp-domain       # Core domain models (JPA entities)
├── hospitalerp-persistence  # Repository layer (currently empty)
├── hospitalerp-service      # Business logic layer (currently empty)
├── hospitalerp-api          # REST API controllers
└── hospitalerp-boot         # Spring Boot application (executable module)
```

### Module Dependencies
```
hospitalerp-boot
  ├─> hospitalerp-api
  ├─> hospitalerp-service
  ├─> hospitalerp-persistence
  └─> hospitalerp-domain
```

## Key Features

### Current Implementation
1. **Doctor Management** - CRUD operations for doctor information
2. **Patient Management** - Patient records with demographics
3. **Appointment System** - Doctor-patient appointment scheduling
4. **Admission Management** - Hospital admission tracking
5. **Department Management** - Hospital department organization
6. **Inventory Management** - Medical supplies and stock tracking
7. **Prescription Management** - Medical prescriptions
8. **Medical Records** - Patient medical history
9. **Room Management** - Hospital room allocation
10. **Nurse Management** - Nursing staff information
11. **Supplier Management** - Medical supply vendors

## Configuration

### Application Configuration
- **Port**: 8081 (configurable via `SERVER_PORT`)
- **Active Profile**: default (configurable via `SPRING_PROFILES_ACTIVE`)
- **Database URL**: jdbc:oracle:thin:@//oracle:1521/XEPDB1
- **Database User**: hospitalerp
- **Database Password**: hospitalerp (change in production!)

### Environment Variables
- `SERVER_PORT` - Application server port
- `SPRING_DATASOURCE_URL` - Database connection URL
- `SPRING_DATASOURCE_USERNAME` - Database username
- `SPRING_DATASOURCE_PASSWORD` - Database password
- `SPRING_PROFILES_ACTIVE` - Active Spring profile

## Development Setup

### Prerequisites
- JDK 17 or higher
- Maven 3.9+
- Docker & Docker Compose
- Oracle SQL Developer (optional, for database management)

### Quick Start
```bash
# Start Oracle database and application
docker-compose up --build

# Application will be available at:
# http://localhost:8081

# Health check endpoint:
# http://localhost:8081/actuator/health
```

### Local Development
```bash
# Build all modules
mvn clean install

# Run Spring Boot application
cd hospitalerp-boot
mvn spring-boot:run
```

## Database Management

### Liquibase Migrations
- **Change Log Location**: `src/main/resources/db/changelog/master.xml`
- **Enabled**: true
- **DDL Script**: `sql/001-hospital-ddl.sql`
- **Data Script**: `sql/002-hospital-data.sql`

### Database Schema
The database schema is managed through Liquibase with the following key tables:
- doctors
- patients
- departments
- nurses
- appointments
- admissions
- rooms
- prescriptions
- medical_records
- inventory_items
- inventory_stock
- suppliers

## API Endpoints

### Currently Implemented
- `GET /doctors` - List all doctor names
- `GET /actuator/health` - Health check
- `GET /actuator/info` - Application info
- `GET /actuator/mappings` - Endpoint mappings

## Security Considerations

### Current State
- ⚠️ **No authentication/authorization implemented**
- ⚠️ **Database credentials in docker-compose.yml (development only)**
- ⚠️ **No HTTPS/TLS configuration**

### Recommendations for Production
1. Implement Spring Security with JWT/OAuth2
2. Use secrets management (Vault, AWS Secrets Manager, etc.)
3. Enable HTTPS/TLS
4. Implement rate limiting
5. Add request validation and sanitization
6. Configure CORS policies
7. Enable audit logging

## Testing Strategy

### Current State
- Tests are skipped during Docker build (`-DskipTests`)
- No test files visible in current structure

### Recommended Testing Layers
1. **Unit Tests** - Service and controller logic
2. **Integration Tests** - Database operations
3. **API Tests** - REST endpoint validation
4. **Contract Tests** - API contract verification

## Monitoring & Observability

### Current Implementation
- Spring Boot Actuator enabled
- Health checks configured
- Endpoints exposed: health, info, mappings

### Recommended Additions
1. **Logging**: Structured logging (JSON format)
2. **Metrics**: Micrometer + Prometheus
3. **Tracing**: Spring Cloud Sleuth + Zipkin
4. **APM**: New Relic, DataDog, or Elastic APM

## Known Issues & Technical Debt

1. **Empty Modules**: hospitalerp-persistence and hospitalerp-service have no implementations yet
2. **Direct EntityManager Usage**: DoctorController uses EntityManager directly instead of repositories
3. **Error Handling**: Basic error handling in place, needs enhancement
4. **Validation**: No input validation on API endpoints
5. **Testing**: No test coverage
6. **Documentation**: No API documentation (Swagger/OpenAPI)

## Future Enhancements

1. Implement repository pattern in persistence module
2. Add business logic to service module
3. Complete REST API for all entities
4. Add authentication and authorization
5. Implement comprehensive error handling
6. Add API documentation (Swagger/OpenAPI)
7. Create comprehensive test suite
8. Add caching layer (Redis)
9. Implement event-driven architecture for notifications
10. Add reporting and analytics features

## Contributing Guidelines

### Code Style
- Follow Java naming conventions
- Use Lombok annotations to reduce boilerplate
- Keep methods small and focused
- Write self-documenting code with meaningful names

### Commit Guidelines
- Use conventional commits format
- Write clear commit messages
- Reference issue numbers in commits

### Branch Strategy
- `main` - Production-ready code
- `develop` - Integration branch
- `feature/*` - Feature branches
- `bugfix/*` - Bug fix branches
- `hotfix/*` - Production hotfixes

## Support & Contact

For questions or issues, please:
1. Check existing documentation
2. Search for similar issues in the project tracker
3. Create a new issue with detailed information
4. Contact the development team

## License
[Specify your license here]

---
*Last Updated: January 25, 2026*
*Version: 0.0.1-SNAPSHOT*

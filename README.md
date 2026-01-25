# Context Engineering Documentation - Index

Welcome to the HospitalERP context engineering documentation. This comprehensive documentation set provides AI assistants and developers with complete context about the project architecture, conventions, and implementation details.

## 📚 Documentation Structure

### Root Level Documentation

#### 1. [PROJECT_CONTEXT.md](./PROJECT_CONTEXT.md)
**Purpose**: High-level project overview and getting started guide

**Contains**:
- Project overview and purpose
- Technology stack
- Module structure
- Configuration details
- Development setup instructions
- Known issues and technical debt
- Future enhancements

**Use When**: You need to understand what the project does and how to set it up.

---

#### 2. [ARCHITECTURE.md](./ARCHITECTURE.md)
**Purpose**: Detailed system architecture documentation

**Contains**:
- Clean architecture layers
- Module breakdown and responsibilities
- Data flow diagrams
- Design patterns
- Database architecture
- Infrastructure setup (Docker, Oracle)
- Security architecture
- Scalability considerations
- Testing architecture

**Use When**: You need to understand how the system is structured and how components interact.

---

#### 3. [CONVENTIONS.md](./CONVENTIONS.md)
**Purpose**: Coding standards and best practices

**Contains**:
- Java naming conventions
- Package structure standards
- Lombok usage guidelines
- JPA mapping conventions
- REST API conventions
- Service layer patterns
- Exception handling standards
- Testing conventions
- Git commit message format

**Use When**: You're writing or reviewing code and need to follow project standards.

---

#### 4. [DOMAIN_MODEL.md](./DOMAIN_MODEL.md)
**Purpose**: Complete domain model documentation

**Contains**:
- All domain entities (12 entities)
- Entity attributes and relationships
- Business rules per entity
- Database mapping details
- Entity lifecycle states
- Common query patterns
- Data validation rules
- Security and privacy considerations

**Use When**: You need to understand the business domain and entity relationships.

---

#### 5. [API_STYLE_GUIDE.md](./API_STYLE_GUIDE.md)
**Purpose**: RESTful API design standards

**Contains**:
- URL structure conventions
- HTTP method usage
- Request/response formats
- Error handling patterns
- Pagination and filtering
- API versioning strategy
- Security headers
- Rate limiting
- Documentation standards (OpenAPI/Swagger)

**Use When**: You're designing or implementing REST API endpoints.

---

### Module-Specific Documentation

#### 6. [hospitalerp-api/MODULE_CONTEXT.md](./hospitalerp-api/MODULE_CONTEXT.md)
**Module**: REST API Controllers (Presentation Layer)

**Contains**:
- Controller patterns
- Request/response DTOs
- Input validation
- Error handling
- Planned endpoints
- Testing strategies
- Migration notes from current implementation

**Status**: ⚡ Partially implemented (1 controller exists)

---

#### 7. [hospitalerp-domain/MODULE_CONTEXT.md](./hospitalerp-domain/MODULE_CONTEXT.md)
**Module**: Core Domain Entities

**Contains**:
- Entity design patterns
- JPA mapping strategies
- Lombok usage in entities
- Relationship mappings
- Business logic in entities
- Performance considerations
- Future enhancements (value objects, enums, audit fields)

**Status**: ✅ Fully implemented (12 entities)

---

#### 8. [hospitalerp-persistence/MODULE_CONTEXT.md](./hospitalerp-persistence/MODULE_CONTEXT.md)
**Module**: Data Access Layer (Repositories)

**Contains**:
- Repository pattern
- Spring Data JPA interfaces
- Custom query implementations
- JPA Specifications
- Query method naming conventions
- Performance optimization
- Testing strategies
- Planned implementations

**Status**: ⚠️ Not yet implemented

---

#### 9. [hospitalerp-service/MODULE_CONTEXT.md](./hospitalerp-service/MODULE_CONTEXT.md)
**Module**: Business Logic Layer

**Contains**:
- Service interfaces and implementations
- DTO definitions
- Entity-DTO mapping (MapStruct)
- Business validators
- Custom exceptions
- Transaction management
- Testing strategies
- Planned implementations

**Status**: ⚠️ Not yet implemented

---

## 🎯 Quick Navigation by Task

### Starting a New Feature
1. Read [PROJECT_CONTEXT.md](./PROJECT_CONTEXT.md) for overview
2. Review [ARCHITECTURE.md](./ARCHITECTURE.md) to understand layers
3. Check [DOMAIN_MODEL.md](./DOMAIN_MODEL.md) for relevant entities
4. Follow [CONVENTIONS.md](./CONVENTIONS.md) for coding standards
5. Reference [API_STYLE_GUIDE.md](./API_STYLE_GUIDE.md) if adding endpoints

### Implementing a Repository
1. Read [hospitalerp-persistence/MODULE_CONTEXT.md](./hospitalerp-persistence/MODULE_CONTEXT.md)
2. Review [DOMAIN_MODEL.md](./DOMAIN_MODEL.md) for entity details
3. Follow [CONVENTIONS.md](./CONVENTIONS.md) for naming and patterns

### Creating a Service
1. Read [hospitalerp-service/MODULE_CONTEXT.md](./hospitalerp-service/MODULE_CONTEXT.md)
2. Review [ARCHITECTURE.md](./ARCHITECTURE.md) for service layer patterns
3. Check [CONVENTIONS.md](./CONVENTIONS.md) for transaction management

### Adding a REST Endpoint
1. Read [hospitalerp-api/MODULE_CONTEXT.md](./hospitalerp-api/MODULE_CONTEXT.md)
2. Follow [API_STYLE_GUIDE.md](./API_STYLE_GUIDE.md) for endpoint design
3. Review [CONVENTIONS.md](./CONVENTIONS.md) for controller patterns

### Understanding the Domain
1. Start with [DOMAIN_MODEL.md](./DOMAIN_MODEL.md)
2. Review [hospitalerp-domain/MODULE_CONTEXT.md](./hospitalerp-domain/MODULE_CONTEXT.md)
3. Check [ARCHITECTURE.md](./ARCHITECTURE.md) for relationship diagrams

---

## 📊 Documentation Coverage

### By Module
- ✅ **hospitalerp-domain**: Fully documented and implemented
- ⚡ **hospitalerp-api**: Documented, partially implemented
- ⏳ **hospitalerp-persistence**: Documented, not yet implemented
- ⏳ **hospitalerp-service**: Documented, not yet implemented
- ✅ **hospitalerp-boot**: Configuration documented in PROJECT_CONTEXT

### By Topic
- ✅ Architecture and Design Patterns
- ✅ Domain Model and Business Rules
- ✅ API Design Standards
- ✅ Coding Conventions
- ✅ Database Schema and Mappings
- ⏳ Security Implementation (planned)
- ⏳ Testing Strategy (partially documented)
- ⏳ Deployment and DevOps (Docker files exist)

---

## 🔄 Current Implementation Status

### Implemented ✅
- Domain entities (12 entities)
- JPA mappings
- Database schema (Liquibase)
- Docker setup
- Basic REST endpoint (DoctorController)
- Global error handler

### In Progress ⚡
- REST API layer expansion
- Additional controllers

### Planned ⏳
- Repository layer
- Service layer
- Complete REST API
- Authentication & Authorization
- Comprehensive testing
- API documentation (Swagger)

---

## 🚀 Next Steps for Development

### Priority 1: Foundation
1. Implement repositories (hospitalerp-persistence)
2. Implement services (hospitalerp-service)
3. Refactor DoctorController to use services

### Priority 2: Core Features
1. Complete CRUD operations for all entities
2. Add comprehensive validation
3. Enhance error handling

### Priority 3: Advanced Features
1. Add authentication and authorization
2. Implement search and filtering
3. Add API documentation
4. Write comprehensive tests

---

## 📖 How to Use This Documentation

### For AI Assistants
Each markdown file is optimized for AI context:
- Clear structure with headers
- Code examples included
- Best practices highlighted
- Implementation patterns provided
- Common pitfalls documented

### For Human Developers
- Use as reference during development
- Follow patterns and conventions
- Understand business rules
- Navigate between related topics
- Update as the project evolves

### For Onboarding
Recommended reading order:
1. PROJECT_CONTEXT.md (30 min)
2. ARCHITECTURE.md (45 min)
3. DOMAIN_MODEL.md (30 min)
4. CONVENTIONS.md (20 min)
5. Relevant MODULE_CONTEXT.md files (15 min each)

---

## 🔧 Maintaining This Documentation

### When to Update
- Adding new features
- Changing architecture
- Modifying conventions
- Implementing planned features
- Discovering issues or improvements

### How to Update
1. Update relevant markdown file(s)
2. Update last modified date at bottom
3. Update this index if structure changes
4. Keep code examples in sync with actual code

---

## 📝 Documentation Conventions

### File Naming
- `UPPERCASE.md` for root-level documentation
- `MODULE_CONTEXT.md` for module-specific documentation

### Structure
- Clear headers (H1, H2, H3)
- Code blocks with language specification
- Tables for structured data
- Lists for enumeration
- Diagrams using ASCII art or mermaid

### Metadata
Each file includes:
- Last Updated date
- Version number
- Status indicators (✅ ⚡ ⏳ ⚠️)

---

## 🤝 Contributing to Documentation

### Guidelines
- Keep documentation in sync with code
- Use clear, concise language
- Include practical examples
- Document "why" not just "what"
- Update related documents when making changes

### Review Checklist
- [ ] Information is accurate
- [ ] Examples are current
- [ ] Links work correctly
- [ ] No typos or grammar issues
- [ ] Follows documentation structure
- [ ] Date and version updated

---

## 🌟 Documentation Philosophy

This documentation follows these principles:

1. **Context-Rich**: Provides complete context for AI assistants and developers
2. **Practical**: Includes real examples and patterns
3. **Structured**: Organized by concern and responsibility
4. **Current**: Reflects actual implementation state
5. **Actionable**: Shows how to implement features
6. **Comprehensive**: Covers architecture, design, and implementation

---

## 📞 Getting Help

If documentation is unclear or missing information:
1. Check related documentation files
2. Review actual code implementation
3. Consult Git history for context
4. Ask development team
5. Update documentation with findings

---

## 🎓 Learning Resources

### External References
- Spring Boot Documentation
- Spring Data JPA Guide
- JPA Specification
- Clean Architecture (Robert C. Martin)
- Domain-Driven Design (Eric Evans)
- RESTful API Design Best Practices

### Internal References
- Source code examples in each module
- Unit tests (when implemented)
- Integration tests (when implemented)
- Docker configuration files

---

*Documentation Structure Version: 1.0*  
*Last Updated: January 25, 2026*  
*Total Documents: 9 files*

---

## File Tree
```
HospitalERP/
├─ 📄 PROJECT_CONTEXT.md           # Start here!
├─ 📄 ARCHITECTURE.md               # System design
├─ 📄 CONVENTIONS.md                # Coding standards
├─ 📄 DOMAIN_MODEL.md               # Business entities
├─ 📄 API_STYLE_GUIDE.md            # REST API standards
├─ 📄 README.md                     # This index file
│
├─ hospitalerp-api/
│  └─ 📄 MODULE_CONTEXT.md          # API layer context
│
├─ hospitalerp-domain/
│  └─ 📄 MODULE_CONTEXT.md          # Domain layer context
│
├─ hospitalerp-persistence/
│  └─ 📄 MODULE_CONTEXT.md          # Persistence layer context
│
└─ hospitalerp-service/
   └─ 📄 MODULE_CONTEXT.md          # Service layer context
```

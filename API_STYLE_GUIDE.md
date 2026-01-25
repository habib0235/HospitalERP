# HospitalERP - API Style Guide

## Introduction

This guide defines the RESTful API standards and conventions for the HospitalERP system. Following these guidelines ensures consistency, maintainability, and a good developer experience.

## General Principles

### REST Principles
1. **Resource-Based** - URLs represent resources (nouns), not actions (verbs)
2. **Stateless** - Each request contains all information needed to process it
3. **Standard HTTP Methods** - Use GET, POST, PUT, PATCH, DELETE appropriately
4. **Uniform Interface** - Consistent patterns across all endpoints
5. **JSON Format** - All requests and responses use JSON

### API Versioning
```
/api/v1/doctors
/api/v1/patients
/api/v1/appointments
```

**Strategy**: URL-based versioning (v1, v2, etc.)

**When to Version**:
- Breaking changes to request/response structure
- Removal of fields
- Change in behavior that affects clients

**Backward Compatibility**:
- Adding new optional fields: No version change needed
- Adding new endpoints: No version change needed
- Deprecation period: Minimum 6 months before removal

## URL Structure

### Resource Naming

#### Collections (Plural Nouns)
```
GET    /api/v1/doctors              # List all doctors
POST   /api/v1/doctors              # Create a doctor
```

#### Individual Resources
```
GET    /api/v1/doctors/{id}         # Get specific doctor
PUT    /api/v1/doctors/{id}         # Update entire doctor
PATCH  /api/v1/doctors/{id}         # Partial update
DELETE /api/v1/doctors/{id}         # Delete doctor
```

#### Sub-Resources
```
GET    /api/v1/doctors/{id}/appointments
POST   /api/v1/doctors/{id}/appointments
GET    /api/v1/doctors/{id}/appointments/{appointmentId}

GET    /api/v1/patients/{id}/admissions
GET    /api/v1/patients/{id}/prescriptions
GET    /api/v1/patients/{id}/medical-records
```

#### Filtering & Searching
```
# Query parameters for filtering
GET /api/v1/doctors?specialty=cardiology
GET /api/v1/doctors?departmentId=5&specialty=surgery
GET /api/v1/patients?gender=female&minAge=18&maxAge=65

# Search endpoint
GET /api/v1/doctors/search?q=smith&specialty=cardiology
GET /api/v1/patients/search?q=john+doe&nationalId=123
```

#### Pagination
```
GET /api/v1/doctors?page=0&size=20&sort=fullName,asc
GET /api/v1/patients?page=2&size=50&sort=dateOfBirth,desc

# Multiple sort fields
GET /api/v1/doctors?sort=specialty,asc&sort=fullName,asc
```

### URL Conventions

#### ✓ Good
```
/api/v1/doctors
/api/v1/patients/{id}/appointments
/api/v1/inventory-items
/api/v1/medical-records
```

#### ✗ Bad
```
/api/v1/getDoctor              # No verbs in URLs
/api/v1/Doctor                 # Use lowercase
/api/v1/doctor_list            # Use hyphens, not underscores
/api/v1/doctors/delete/{id}    # Use HTTP DELETE method instead
```

## HTTP Methods

### GET - Retrieve Resources
```
GET /api/v1/doctors              # List all (with pagination)
GET /api/v1/doctors/{id}         # Get one by ID
GET /api/v1/doctors?specialty=cardiology  # Filter

Response: 200 OK
```

**Characteristics**:
- Safe (no side effects)
- Idempotent (multiple calls same result)
- Cacheable
- Never modify data

### POST - Create Resources
```
POST /api/v1/doctors
Content-Type: application/json

{
  "fullName": "Dr. John Smith",
  "specialty": "Cardiology",
  "licenseNumber": "MD123456",
  "departmentId": 5,
  "hireDate": "2026-01-15"
}

Response: 201 Created
Location: /api/v1/doctors/123
```

**Characteristics**:
- Not idempotent (creates new resource each time)
- Returns 201 Created with Location header
- Response body contains created resource

### PUT - Full Update
```
PUT /api/v1/doctors/{id}
Content-Type: application/json

{
  "fullName": "Dr. John Smith",
  "specialty": "Cardiology",
  "licenseNumber": "MD123456",
  "departmentId": 5,
  "hireDate": "2026-01-15"
}

Response: 200 OK
```

**Characteristics**:
- Idempotent (same call = same result)
- Replaces entire resource
- All fields must be provided
- Returns updated resource

### PATCH - Partial Update
```
PATCH /api/v1/doctors/{id}
Content-Type: application/json

{
  "specialty": "Neurology",
  "departmentId": 7
}

Response: 200 OK
```

**Characteristics**:
- Idempotent
- Updates only provided fields
- More flexible than PUT
- Returns updated resource

### DELETE - Remove Resources
```
DELETE /api/v1/doctors/{id}

Response: 204 No Content
```

**Characteristics**:
- Idempotent (multiple deletes = same result)
- Returns 204 No Content (no body)
- Return 404 if resource already doesn't exist

## Request Format

### Content Type
```
Content-Type: application/json
```

### Request Body Examples

#### Create Doctor
POST /api/v1/doctors
```json
{
  "fullName": "Dr. Jane Wilson",
  "specialty": "Pediatrics",
  "licenseNumber": "MD789012",
  "departmentId": 3,
  "hireDate": "2026-02-01"
}
```

#### Create Appointment
POST /api/v1/appointments
```json
{
  "patientId": 42,
  "doctorId": 15,
  "appointmentDate": "2026-02-15T10:30:00",
  "reason": "Annual checkup",
  "status": "SCHEDULED"
}
```

#### Update Patient (Partial)
PATCH /api/v1/patients/42
```json
{
  "phoneNumber": "+1-555-0123",
  "email": "newemail@example.com"
}
```

### Field Naming
- Use `camelCase` for JSON fields
- Be descriptive but concise
- Avoid abbreviations unless widely understood

```json
{
  "fullName": "John Doe",        // ✓ Good
  "name": "John Doe",             // ✗ Too vague
  "fn": "John Doe",               // ✗ Unclear abbreviation
  "patient_name": "John Doe"      // ✗ Wrong case (snake_case)
}
```

## Response Format

### Standard Response Structure

#### Success Response
```json
{
  "data": { /* resource or array of resources */ },
  "metadata": {
    "timestamp": "2026-01-25T10:30:00Z",
    "version": "v1"
  }
}
```

#### Paginated Response
```json
{
  "data": [
    { "id": 1, "fullName": "Dr. Smith" },
    { "id": 2, "fullName": "Dr. Jones" }
  ],
  "metadata": {
    "timestamp": "2026-01-25T10:30:00Z",
    "version": "v1"
  },
  "pagination": {
    "page": 0,
    "size": 20,
    "totalElements": 156,
    "totalPages": 8,
    "first": true,
    "last": false
  }
}
```

#### Single Resource Response
```json
{
  "data": {
    "id": 123,
    "fullName": "Dr. Jane Wilson",
    "specialty": "Pediatrics",
    "licenseNumber": "MD789012",
    "department": {
      "id": 3,
      "name": "Pediatrics",
      "floor": 2
    },
    "hireDate": "2026-02-01",
    "createdAt": "2026-01-25T10:30:00Z",
    "updatedAt": "2026-01-25T10:30:00Z"
  },
  "metadata": {
    "timestamp": "2026-01-25T10:30:00Z",
    "version": "v1"
  }
}
```

### Error Response Structure

#### Standard Error Format
```json
{
  "error": {
    "code": "RESOURCE_NOT_FOUND",
    "message": "Doctor not found with id: 999",
    "timestamp": "2026-01-25T10:30:00Z",
    "path": "/api/v1/doctors/999",
    "method": "GET"
  }
}
```

#### Validation Error
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input parameters",
    "timestamp": "2026-01-25T10:30:00Z",
    "path": "/api/v1/doctors",
    "method": "POST",
    "validationErrors": {
      "fullName": "Full name is required",
      "licenseNumber": "License number must be unique",
      "hireDate": "Hire date cannot be in the future"
    }
  }
}
```

#### Multiple Errors
```json
{
  "error": {
    "code": "BUSINESS_RULE_VIOLATION",
    "message": "Cannot schedule appointment",
    "timestamp": "2026-01-25T10:30:00Z",
    "path": "/api/v1/appointments",
    "method": "POST",
    "details": [
      "Doctor is not available at the requested time",
      "Patient has overlapping appointment",
      "Requested time is outside working hours"
    ]
  }
}
```

## HTTP Status Codes

### Success Codes (2xx)

| Code | Meaning | Use Case |
|------|---------|----------|
| 200 OK | Success | GET, PUT, PATCH successful |
| 201 Created | Resource created | POST successful |
| 204 No Content | Success, no body | DELETE successful |

### Client Error Codes (4xx)

| Code | Meaning | Use Case |
|------|---------|----------|
| 400 Bad Request | Invalid input | Validation errors, malformed JSON |
| 401 Unauthorized | Authentication failed | Missing or invalid token |
| 403 Forbidden | Authorization failed | Valid token but insufficient permissions |
| 404 Not Found | Resource doesn't exist | Invalid ID, deleted resource |
| 409 Conflict | Business rule violation | Duplicate resource, constraint violation |
| 422 Unprocessable Entity | Semantic errors | Valid JSON but business logic failure |
| 429 Too Many Requests | Rate limit exceeded | API rate limiting |

### Server Error Codes (5xx)

| Code | Meaning | Use Case |
|------|---------|----------|
| 500 Internal Server Error | Unexpected error | Unhandled exceptions |
| 503 Service Unavailable | Service down | Database unavailable, maintenance |

## Common Endpoints by Entity

### Doctor Endpoints
```
GET    /api/v1/doctors                          # List all doctors
GET    /api/v1/doctors/{id}                     # Get doctor by ID
POST   /api/v1/doctors                          # Create doctor
PUT    /api/v1/doctors/{id}                     # Update doctor
PATCH  /api/v1/doctors/{id}                     # Partial update
DELETE /api/v1/doctors/{id}                     # Delete doctor

GET    /api/v1/doctors?specialty=cardiology    # Filter by specialty
GET    /api/v1/doctors?departmentId=5          # Filter by department
GET    /api/v1/doctors/search?q=smith          # Search by name

GET    /api/v1/doctors/{id}/appointments       # Doctor's appointments
GET    /api/v1/doctors/{id}/prescriptions      # Doctor's prescriptions
GET    /api/v1/doctors/{id}/schedule           # Doctor's schedule
```

### Patient Endpoints
```
GET    /api/v1/patients                         # List all patients
GET    /api/v1/patients/{id}                    # Get patient by ID
POST   /api/v1/patients                         # Create patient
PUT    /api/v1/patients/{id}                    # Update patient
PATCH  /api/v1/patients/{id}                    # Partial update
DELETE /api/v1/patients/{id}                    # Delete patient

GET    /api/v1/patients/search?nationalId=123  # Search by national ID
GET    /api/v1/patients/search?q=john+doe      # Search by name

GET    /api/v1/patients/{id}/appointments      # Patient's appointments
GET    /api/v1/patients/{id}/admissions        # Patient's admissions
GET    /api/v1/patients/{id}/medical-records   # Patient's medical records
GET    /api/v1/patients/{id}/prescriptions     # Patient's prescriptions
```

### Appointment Endpoints
```
GET    /api/v1/appointments                     # List all appointments
GET    /api/v1/appointments/{id}                # Get appointment by ID
POST   /api/v1/appointments                     # Create appointment
PUT    /api/v1/appointments/{id}                # Update appointment
PATCH  /api/v1/appointments/{id}                # Partial update (e.g., status)
DELETE /api/v1/appointments/{id}                # Cancel appointment

GET    /api/v1/appointments?doctorId=5&date=2026-02-15
GET    /api/v1/appointments?patientId=42&status=SCHEDULED
GET    /api/v1/appointments/available-slots?doctorId=5&date=2026-02-15
```

### Admission Endpoints
```
GET    /api/v1/admissions                       # List all admissions
GET    /api/v1/admissions/{id}                  # Get admission by ID
POST   /api/v1/admissions                       # Admit patient
PUT    /api/v1/admissions/{id}                  # Update admission
PATCH  /api/v1/admissions/{id}/discharge        # Discharge patient
DELETE /api/v1/admissions/{id}                  # Cancel admission

GET    /api/v1/admissions?status=current       # Currently admitted
GET    /api/v1/admissions?roomId=101           # By room
```

### Inventory Endpoints
```
GET    /api/v1/inventory-items                  # List items
GET    /api/v1/inventory-items/{id}             # Get item
POST   /api/v1/inventory-items                  # Create item
PUT    /api/v1/inventory-items/{id}             # Update item
DELETE /api/v1/inventory-items/{id}             # Delete item

GET    /api/v1/inventory-items?category=MEDICATION
GET    /api/v1/inventory-items/low-stock       # Below reorder level
GET    /api/v1/inventory-items/expiring-soon   # Expiring within 30 days

GET    /api/v1/inventory-stock                  # List stock entries
POST   /api/v1/inventory-stock                  # Add stock
PATCH  /api/v1/inventory-stock/{id}             # Update quantity
```

## Pagination

### Query Parameters
```
page - Zero-based page number (default: 0)
size - Number of items per page (default: 20, max: 100)
sort - Sort field and direction (e.g., fullName,asc)
```

### Example Request
```
GET /api/v1/doctors?page=1&size=50&sort=specialty,asc&sort=fullName,asc
```

### Example Response
```json
{
  "data": [ /* array of doctors */ ],
  "pagination": {
    "page": 1,
    "size": 50,
    "totalElements": 156,
    "totalPages": 4,
    "first": false,
    "last": false,
    "hasNext": true,
    "hasPrevious": true
  },
  "links": {
    "self": "/api/v1/doctors?page=1&size=50&sort=specialty,asc",
    "first": "/api/v1/doctors?page=0&size=50&sort=specialty,asc",
    "previous": "/api/v1/doctors?page=0&size=50&sort=specialty,asc",
    "next": "/api/v1/doctors?page=2&size=50&sort=specialty,asc",
    "last": "/api/v1/doctors?page=3&size=50&sort=specialty,asc"
  }
}
```

## Filtering & Searching

### Simple Filtering
```
# Exact match
GET /api/v1/doctors?specialty=cardiology

# Multiple filters (AND)
GET /api/v1/doctors?specialty=cardiology&departmentId=5

# Date ranges
GET /api/v1/appointments?startDate=2026-02-01&endDate=2026-02-28
```

### Advanced Filtering
```
# Greater than, less than
GET /api/v1/patients?minAge=18&maxAge=65

# In list
GET /api/v1/doctors?specialty=cardiology,neurology,surgery

# Null checks
GET /api/v1/admissions?discharged=false  # discharge_date is null
```

### Full-Text Search
```
GET /api/v1/doctors/search?q=smith&specialty=cardiology
GET /api/v1/patients/search?q=john+doe&page=0&size=20
```

## Sorting

### Single Field
```
GET /api/v1/doctors?sort=fullName,asc
GET /api/v1/doctors?sort=hireDate,desc
```

### Multiple Fields
```
GET /api/v1/doctors?sort=specialty,asc&sort=fullName,asc
GET /api/v1/appointments?sort=appointmentDate,desc&sort=doctorId,asc
```

## Field Selection (Sparse Fieldsets)

### Select Specific Fields
```
GET /api/v1/doctors?fields=id,fullName,specialty
GET /api/v1/patients?fields=id,fullName,phoneNumber,email
```

### Response
```json
{
  "data": [
    {
      "id": 1,
      "fullName": "Dr. Smith",
      "specialty": "Cardiology"
    }
  ]
}
```

## Data Expansion

### Include Related Resources
```
GET /api/v1/doctors/{id}?expand=department
GET /api/v1/appointments/{id}?expand=patient,doctor
GET /api/v1/admissions/{id}?expand=patient,room
```

### Response with Expansion
```json
{
  "data": {
    "id": 123,
    "appointmentDate": "2026-02-15T10:30:00",
    "status": "SCHEDULED",
    "patient": {
      "id": 42,
      "fullName": "John Doe",
      "phoneNumber": "+1-555-0123"
    },
    "doctor": {
      "id": 15,
      "fullName": "Dr. Jane Wilson",
      "specialty": "Pediatrics"
    }
  }
}
```

## Date & Time Format

### ISO 8601 Format
```
Date: 2026-02-15
DateTime: 2026-02-15T10:30:00Z
DateTime with TZ: 2026-02-15T10:30:00+05:30
```

### Examples
```json
{
  "hireDate": "2026-01-15",
  "appointmentDateTime": "2026-02-15T10:30:00Z",
  "createdAt": "2026-01-25T10:30:00Z",
  "updatedAt": "2026-01-25T14:45:30Z"
}
```

## Security Headers

### Request Headers
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
Content-Type: application/json
Accept: application/json
X-Request-ID: 123e4567-e89b-12d3-a456-426614174000
```

### Response Headers
```
Content-Type: application/json
X-Request-ID: 123e4567-e89b-12d3-a456-426614174000
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 995
X-RateLimit-Reset: 2026-01-25T11:00:00Z
```

## Rate Limiting

### Headers
```
X-RateLimit-Limit: 1000        # Max requests per window
X-RateLimit-Remaining: 995     # Remaining requests
X-RateLimit-Reset: 1643112000  # Unix timestamp when limit resets
```

### 429 Response
```json
{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Too many requests. Please try again later.",
    "timestamp": "2026-01-25T10:30:00Z",
    "retryAfter": 3600
  }
}
```

## Bulk Operations

### Bulk Create
```
POST /api/v1/doctors/bulk

{
  "doctors": [
    { "fullName": "Dr. Smith", "specialty": "Cardiology" },
    { "fullName": "Dr. Jones", "specialty": "Neurology" }
  ]
}

Response: 207 Multi-Status
```

### Bulk Update
```
PATCH /api/v1/doctors/bulk

{
  "updates": [
    { "id": 1, "specialty": "Pediatrics" },
    { "id": 2, "departmentId": 5 }
  ]
}
```

## Async Operations

### Long-Running Operations
```
POST /api/v1/reports/generate

Response: 202 Accepted
Location: /api/v1/reports/jobs/abc-123
```

### Check Status
```
GET /api/v1/reports/jobs/abc-123

{
  "id": "abc-123",
  "status": "PROCESSING",
  "progress": 45,
  "createdAt": "2026-01-25T10:30:00Z"
}
```

## Documentation

### OpenAPI/Swagger
- Document all endpoints with OpenAPI 3.0
- Include request/response examples
- Describe all fields
- List all possible error codes

### Endpoint Documentation Template
```yaml
/api/v1/doctors:
  get:
    summary: List all doctors
    description: Retrieves a paginated list of doctors with optional filtering
    parameters:
      - name: page
        in: query
        schema:
          type: integer
          default: 0
      - name: specialty
        in: query
        schema:
          type: string
    responses:
      200:
        description: Successful response
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/DoctorListResponse'
```

## Deprecation

### Deprecation Headers
```
Deprecation: true
Sunset: Sat, 31 Dec 2026 23:59:59 GMT
Link: </api/v2/doctors>; rel="successor-version"
```

### Deprecation Notice in Response
```json
{
  "data": { /* ... */ },
  "warnings": [
    {
      "code": "DEPRECATED",
      "message": "This endpoint will be removed on 2026-12-31. Please migrate to /api/v2/doctors"
    }
  ]
}
```

---

*Last Updated: January 25, 2026*
*API Style Guide Version: 1.0*

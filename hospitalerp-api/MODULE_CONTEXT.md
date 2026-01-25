# hospitalerp-api - Module Context

## Module Overview

The `hospitalerp-api` module provides the REST API layer (presentation layer) for the HospitalERP application. It contains controllers that handle HTTP requests and responses, exposing the hospital management functionality through RESTful endpoints.

## Module Purpose

- **Primary Responsibility**: REST API controllers and request/response handling
- **Layer**: Presentation Layer
- **Package Base**: `com.example.hospitalerp.controller`

## Dependencies

### Internal Dependencies
- `hospitalerp-service` - Business logic layer (to be implemented)
- `hospitalerp-domain` - Domain entities and DTOs

### External Dependencies
- Spring Web - REST controller support
- Spring Boot - Auto-configuration
- Jakarta Validation - Input validation
- Lombok - Code generation

## Current Implementation

### Implemented Controllers

#### DoctorController
- **Endpoint**: `/doctors`
- **Method**: `GET /doctors`
- **Description**: Returns a list of all doctor full names
- **Status**: Basic implementation (uses EntityManager directly)

**Note**: ⚠️ Current implementation bypasses service and repository layers. This is temporary and should be refactored once the service module is implemented.

### Current Architecture
```
DoctorController
    ↓ (direct)
EntityManager
    ↓
Database
```

### Target Architecture
```
DoctorController
    ↓
DoctorService (hospitalerp-service)
    ↓
DoctorRepository (hospitalerp-persistence)
    ↓
Database
```

## Package Structure

### Recommended Structure
```
com.example.hospitalerp.controller/
├── DoctorController.java
├── PatientController.java
├── AppointmentController.java
├── AdmissionController.java
├── DepartmentController.java
├── PrescriptionController.java
├── InventoryController.java
└── MedicalRecordController.java

com.example.hospitalerp.dto.request/
├── CreateDoctorRequest.java
├── UpdateDoctorRequest.java
├── CreatePatientRequest.java
├── UpdatePatientRequest.java
├── CreateAppointmentRequest.java
└── [other request DTOs]

com.example.hospitalerp.dto.response/
├── DoctorResponse.java
├── PatientResponse.java
├── AppointmentResponse.java
├── ErrorResponse.java
└── [other response DTOs]

com.example.hospitalerp.validation/
├── PhoneNumberValidator.java
├── NationalIdValidator.java
└── [custom validators]
```

## Planned Controllers

### 1. DoctorController (Enhance Existing)
```java
@RestController
@RequestMapping("/api/v1/doctors")
@RequiredArgsConstructor
public class DoctorController {
    private final DoctorService doctorService;
    
    @GetMapping
    public ResponseEntity<Page<DoctorDTO>> getAllDoctors(...);
    
    @GetMapping("/{id}")
    public ResponseEntity<DoctorDTO> getDoctorById(@PathVariable Long id);
    
    @PostMapping
    public ResponseEntity<DoctorDTO> createDoctor(@Valid @RequestBody CreateDoctorRequest request);
    
    @PutMapping("/{id}")
    public ResponseEntity<DoctorDTO> updateDoctor(@PathVariable Long id, @Valid @RequestBody UpdateDoctorRequest request);
    
    @PatchMapping("/{id}")
    public ResponseEntity<DoctorDTO> patchDoctor(@PathVariable Long id, @RequestBody Map<String, Object> updates);
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteDoctor(@PathVariable Long id);
    
    @GetMapping("/{id}/appointments")
    public ResponseEntity<List<AppointmentDTO>> getDoctorAppointments(@PathVariable Long id);
}
```

### 2. PatientController
- CRUD operations for patients
- Search by national ID
- Get patient appointments
- Get patient admissions
- Get patient medical records
- Get patient prescriptions

### 3. AppointmentController
- CRUD operations for appointments
- Get appointments by doctor
- Get appointments by patient
- Get appointments by date
- Get available appointment slots
- Update appointment status

### 4. AdmissionController
- CRUD operations for admissions
- Get current admissions
- Discharge patient
- Get admission history
- Get room occupancy

### 5. DepartmentController
- CRUD operations for departments
- Get department doctors
- Get department nurses
- Get department statistics

### 6. PrescriptionController
- CRUD operations for prescriptions
- Get prescriptions by patient
- Get prescriptions by doctor
- Get active prescriptions

### 7. InventoryController
- CRUD operations for inventory items
- Get items by category
- Get low stock items
- Get items expiring soon
- Update stock quantities

### 8. MedicalRecordController
- CRUD operations for medical records
- Get records by patient
- Search medical records

## API Standards

### URL Pattern
```
/api/v1/{resource}
/api/v1/{resource}/{id}
/api/v1/{resource}/{id}/{sub-resource}
```

### HTTP Methods
- **GET** - Retrieve resources
- **POST** - Create resources
- **PUT** - Full update
- **PATCH** - Partial update
- **DELETE** - Remove resources

### Response Codes
- **200 OK** - Successful GET, PUT, PATCH
- **201 Created** - Successful POST
- **204 No Content** - Successful DELETE
- **400 Bad Request** - Validation errors
- **404 Not Found** - Resource not found
- **409 Conflict** - Business rule violation
- **500 Internal Server Error** - Unexpected errors

### Request/Response Format
- Content-Type: `application/json`
- All dates in ISO 8601 format
- Use camelCase for JSON fields

## Validation

### Input Validation
Use Jakarta Validation annotations:
```java
public record CreateDoctorRequest(
    @NotBlank(message = "Full name is required")
    @Size(max = 200, message = "Full name must not exceed 200 characters")
    String fullName,
    
    @NotBlank(message = "Specialty is required")
    @Size(max = 100)
    String specialty,
    
    @NotBlank(message = "License number is required")
    @Pattern(regexp = "MD[0-9]{6}", message = "Invalid license number format")
    String licenseNumber,
    
    @Positive(message = "Department ID must be positive")
    Long departmentId,
    
    @PastOrPresent(message = "Hire date cannot be in the future")
    LocalDate hireDate
) {}
```

### Custom Validators
```java
@Target({ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = PhoneNumberValidator.class)
public @interface ValidPhoneNumber {
    String message() default "Invalid phone number format";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
```

## Error Handling

### Controller-Level Exception Handling
```java
@RestControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(ResourceNotFoundException ex) {
        // Return 404 with error details
    }
    
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidation(MethodArgumentNotValidException ex) {
        // Return 400 with validation errors
    }
    
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGeneral(Exception ex) {
        // Return 500 for unexpected errors
    }
}
```

## Security Considerations

### Future Implementations
1. **Authentication** - JWT token validation
2. **Authorization** - Role-based access control
3. **Rate Limiting** - Prevent abuse
4. **CORS** - Configure allowed origins
5. **Input Sanitization** - Prevent injection attacks

### Endpoint Security
```java
@PreAuthorize("hasRole('ADMIN')")
@DeleteMapping("/{id}")
public ResponseEntity<Void> deleteDoctor(@PathVariable Long id) { }

@PreAuthorize("hasAnyRole('ADMIN', 'DOCTOR')")
@GetMapping("/{id}/medical-records")
public ResponseEntity<List<MedicalRecordDTO>> getRecords(@PathVariable Long id) { }
```

## Testing Strategy

### Controller Tests
```java
@WebMvcTest(DoctorController.class)
class DoctorControllerTest {
    
    @Autowired
    private MockMvc mockMvc;
    
    @MockBean
    private DoctorService doctorService;
    
    @Test
    void getAllDoctors_ReturnsListOfDoctors() throws Exception {
        mockMvc.perform(get("/api/v1/doctors"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.data").isArray());
    }
    
    @Test
    void createDoctor_WithValidInput_ReturnsCreated() throws Exception {
        String requestBody = """
            {
                "fullName": "Dr. Smith",
                "specialty": "Cardiology",
                "licenseNumber": "MD123456",
                "departmentId": 1
            }
            """;
        
        mockMvc.perform(post("/api/v1/doctors")
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestBody))
            .andExpect(status().isCreated())
            .andExpect(header().exists("Location"));
    }
}
```

## Documentation

### OpenAPI/Swagger
Add Swagger documentation:
```java
@RestController
@RequestMapping("/api/v1/doctors")
@Tag(name = "Doctor Management", description = "APIs for managing doctors")
public class DoctorController {
    
    @Operation(
        summary = "Get all doctors",
        description = "Returns a paginated list of all doctors with optional filtering"
    )
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Successful"),
        @ApiResponse(responseCode = "400", description = "Invalid parameters")
    })
    @GetMapping
    public ResponseEntity<Page<DoctorDTO>> getAllDoctors(...) { }
}
```

## Configuration

### Application Properties
```properties
# Controller-related settings
spring.mvc.throw-exception-if-no-handler-found=true
spring.web.resources.add-mappings=false

# Validation
spring.mvc.validation.problem-details.enabled=true

# Jackson serialization
spring.jackson.serialization.write-dates-as-timestamps=false
spring.jackson.default-property-inclusion=non_null
```

## Pagination & Sorting

### Standard Pagination
```java
@GetMapping
public ResponseEntity<Page<DoctorDTO>> getAllDoctors(
    @RequestParam(defaultValue = "0") int page,
    @RequestParam(defaultValue = "20") int size,
    @RequestParam(defaultValue = "id") String sortBy,
    @RequestParam(defaultValue = "asc") String sortDir) {
    
    Sort sort = sortDir.equalsIgnoreCase("asc") 
        ? Sort.by(sortBy).ascending() 
        : Sort.by(sortBy).descending();
        
    Pageable pageable = PageRequest.of(page, size, sort);
    Page<DoctorDTO> doctors = doctorService.getAllDoctors(pageable);
    
    return ResponseEntity.ok(doctors);
}
```

## Migration Notes

### Current State
- Single controller (DoctorController)
- Direct EntityManager usage
- Minimal error handling
- No validation
- No authentication/authorization

### Migration Path
1. ✅ Create module context documentation
2. ⏳ Implement service layer
3. ⏳ Refactor controllers to use services
4. ⏳ Add request/response DTOs
5. ⏳ Add input validation
6. ⏳ Enhance error handling
7. ⏳ Add pagination and filtering
8. ⏳ Add OpenAPI documentation
9. ⏳ Add security
10. ⏳ Write comprehensive tests

## Best Practices

1. **Keep Controllers Thin** - Delegate logic to services
2. **Use DTOs** - Never expose entities directly
3. **Validate Input** - Use validation annotations
4. **Handle Errors** - Provide meaningful error messages
5. **Document APIs** - Use OpenAPI/Swagger
6. **Test Thoroughly** - Unit and integration tests
7. **Version APIs** - Plan for evolution
8. **Follow REST** - Use proper HTTP methods and status codes

## Resources

- [Spring Web MVC Documentation](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html)
- [Jakarta Validation](https://beanvalidation.org/)
- [OpenAPI Specification](https://swagger.io/specification/)
- [REST API Best Practices](https://restfulapi.net/)

---
*Last Updated: January 25, 2026*
*Module Version: 0.0.1-SNAPSHOT*

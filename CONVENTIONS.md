# HospitalERP - Coding Conventions & Standards

## General Principles

### SOLID Principles
- **S**ingle Responsibility Principle - Each class has one reason to change
- **O**pen/Closed Principle - Open for extension, closed for modification
- **L**iskov Substitution Principle - Subtypes must be substitutable
- **I**nterface Segregation Principle - Many specific interfaces over one general
- **D**ependency Inversion Principle - Depend on abstractions, not concretions

### Clean Code Principles
- Write self-documenting code
- Keep methods small (max 20 lines preferred)
- Use meaningful names
- Avoid code duplication (DRY)
- Favor composition over inheritance
- Write tests first when possible (TDD)

## Java Coding Standards

### Naming Conventions

#### Classes
```java
// PascalCase for class names
public class DoctorService { }
public class PatientRepository { }
public class AppointmentDTO { }

// Interfaces without 'I' prefix
public interface DoctorService { }  // ✓ Good
public interface IDoctorService { } // ✗ Bad

// Abstract classes with 'Abstract' or 'Base' prefix
public abstract class AbstractEntity { }
public abstract class BaseService { }

// Exception classes with 'Exception' suffix
public class DoctorNotFoundException extends RuntimeException { }
public class InvalidAppointmentException extends RuntimeException { }
```

#### Methods
```java
// camelCase for method names
public void createDoctor() { }
public Doctor findDoctorById(Long id) { }
public List<Patient> getAllPatients() { }

// Boolean methods start with 'is', 'has', 'can', 'should'
public boolean isActive() { }
public boolean hasAppointments() { }
public boolean canScheduleAppointment() { }

// Getters/Setters follow JavaBean conventions
public String getName() { }
public void setName(String name) { }
```

#### Variables
```java
// camelCase for variables
private String fullName;
private LocalDate dateOfBirth;

// UPPER_SNAKE_CASE for constants
public static final int MAX_APPOINTMENTS_PER_DAY = 20;
public static final String DEFAULT_STATUS = "ACTIVE";

// Meaningful names, avoid abbreviations
private String doctorSpecialty;     // ✓ Good
private String docSpec;             // ✗ Bad
private String ds;                  // ✗ Very Bad
```

#### Packages
```
// All lowercase, dot-separated
com.example.hospitalerp.controller
com.example.hospitalerp.service
com.example.hospitalerp.repository
com.example.hospitalerp.model
com.example.hospitalerp.dto
com.example.hospitalerp.exception
com.example.hospitalerp.config
```

### Code Organization

#### Package Structure by Layer
```
com.example.hospitalerp/
├── controller/          # REST controllers
├── service/            # Business logic
├── repository/         # Data access
├── model/              # Domain entities
├── dto/                # Data transfer objects
├── mapper/             # DTO ↔ Entity mappers
├── exception/          # Custom exceptions
├── config/             # Configuration classes
├── security/           # Security-related classes
├── util/               # Utility classes
└── constant/           # Application constants
```

#### Class Member Order

```java
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

// 1. Lombok annotations
@Getter
@Setter
public class Doctor {
    // 2. Constants
    public static final String DEFAULT_SPECIALTY = "General Practice";

    // 3. Static fields
    private static Logger logger = LoggerFactory.getLogger(Doctor.class);

    // 4. Instance fields
    private Long id;
    private String fullName;
    private String specialty;

    // 4. Constructors
    // No-arg constructor

    // 5. Static methods
    public static Doctor createDefault() {
        return new Doctor("Unknown", DEFAULT_SPECIALTY);
    }

    // 6. Protected methods
    protected void validateSpecialty() {
    }

    // 7. Private methods
    private void initializeDefaults() {
    }

    // 8. Nested classes
    public static class Builder {
    }
}
```

### Lombok Usage

#### Recommended Annotations
```java
@Data                    // For DTOs and simple entities
@Builder                 // For fluent object creation
@NoArgsConstructor      // JPA requirement
@AllArgsConstructor     // With Builder
@Getter                 // When @Data is too much
@Setter                 // When @Data is too much
@ToString               // Custom toString
@EqualsAndHashCode      // Custom equality
@Slf4j                  // Logger field

// Example entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "doctors")
public class Doctor {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "full_name", nullable = false)
    private String fullName;
    
    // Exclude from toString and equals/hashCode to avoid lazy loading issues
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @OneToMany(mappedBy = "doctor", fetch = FetchType.LAZY)
    private List<Appointment> appointments;
}
```

#### Lombok Anti-Patterns
```java
// ✗ Bad - @Data on entities with bidirectional relationships
@Data
@Entity
public class Doctor {
    @OneToMany(mappedBy = "doctor")
    private List<Appointment> appointments;  // Will cause infinite loop
}

// ✓ Good - Exclude collections from toString and equals
@Data
@Entity
public class Doctor {
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @OneToMany(mappedBy = "doctor")
    private List<Appointment> appointments;
}
```

## JPA & Database Conventions

### Entity Design

#### Basic Entity Template
```java
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "table_name")
public class EntityName {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "entity_id")
    private Long id;
    
    @Column(name = "column_name", nullable = false, length = 100)
    private String propertyName;
    
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
```

### Relationship Mapping

#### One-to-Many / Many-to-One
```java
// Parent entity (One side)
@Entity
public class Doctor {
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @OneToMany(mappedBy = "doctor", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<Appointment> appointments;
}

// Child entity (Many side)
@Entity
public class Appointment {
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "doctor_id", nullable = false)
    private Doctor doctor;
}
```

#### Many-to-Many
```java
@Entity
public class Doctor {
    @ManyToMany
    @JoinTable(
        name = "doctor_departments",
        joinColumns = @JoinColumn(name = "doctor_id"),
        inverseJoinColumns = @JoinColumn(name = "department_id")
    )
    private Set<Department> departments;
}
```

### Fetch Strategy
```java
// Default to LAZY loading
@ManyToOne(fetch = FetchType.LAZY)
@OneToMany(fetch = FetchType.LAZY)

// Use EAGER sparingly
@ManyToOne(fetch = FetchType.EAGER)  // Only for small, frequently accessed data
```

### Query Naming Conventions
```java
public interface DoctorRepository extends JpaRepository<Doctor, Long> {
    // Query methods follow naming convention
    List<Doctor> findBySpecialty(String specialty);
    List<Doctor> findByDepartmentId(Long departmentId);
    Optional<Doctor> findByLicenseNumber(String licenseNumber);
    
    List<Doctor> findBySpecialtyAndDepartmentId(String specialty, Long deptId);
    
    boolean existsByLicenseNumber(String licenseNumber);
    
    long countBySpecialty(String specialty);
    
    void deleteByLicenseNumber(String licenseNumber);
}
```

## REST API Conventions

### URL Structure
```
// Resource-based URLs (nouns, not verbs)
GET    /doctors                 // List all doctors
GET    /doctors/{id}            // Get specific doctor
POST   /doctors                 // Create new doctor
PUT    /doctors/{id}            // Update entire doctor
PATCH  /doctors/{id}            // Partial update
DELETE /doctors/{id}            // Delete doctor

// Sub-resources
GET    /doctors/{id}/appointments
POST   /doctors/{id}/appointments
GET    /doctors/{id}/appointments/{appointmentId}

// Query parameters for filtering, sorting, pagination
GET    /doctors?specialty=cardiology
GET    /doctors?page=1&size=20&sort=fullName,asc
GET    /doctors?departmentId=5&active=true
```

### Controller Design
```java
@RestController
@RequestMapping("/doctors")
@RequiredArgsConstructor  // Lombok constructor injection
public class DoctorController {
    
    private final DoctorService doctorService;
    
    // List all - with pagination
    @GetMapping
    public ResponseEntity<Page<DoctorDTO>> getAllDoctors(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(defaultValue = "id") String sortBy) {
        
        Page<DoctorDTO> doctors = doctorService.getAllDoctors(page, size, sortBy);
        return ResponseEntity.ok(doctors);
    }
    
    // Get by ID
    @GetMapping("/{id}")
    public ResponseEntity<DoctorDTO> getDoctorById(@PathVariable Long id) {
        DoctorDTO doctor = doctorService.getDoctorById(id);
        return ResponseEntity.ok(doctor);
    }
    
    // Create
    @PostMapping
    public ResponseEntity<DoctorDTO> createDoctor(
            @Valid @RequestBody CreateDoctorRequest request) {
        
        DoctorDTO created = doctorService.createDoctor(request);
        URI location = URI.create("/doctors/" + created.getId());
        return ResponseEntity.created(location).body(created);
    }
    
    // Update
    @PutMapping("/{id}")
    public ResponseEntity<DoctorDTO> updateDoctor(
            @PathVariable Long id,
            @Valid @RequestBody UpdateDoctorRequest request) {
        
        DoctorDTO updated = doctorService.updateDoctor(id, request);
        return ResponseEntity.ok(updated);
    }
    
    // Partial update
    @PatchMapping("/{id}")
    public ResponseEntity<DoctorDTO> patchDoctor(
            @PathVariable Long id,
            @RequestBody Map<String, Object> updates) {
        
        DoctorDTO updated = doctorService.patchDoctor(id, updates);
        return ResponseEntity.ok(updated);
    }
    
    // Delete
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteDoctor(@PathVariable Long id) {
        doctorService.deleteDoctor(id);
        return ResponseEntity.noContent().build();
    }
}
```

### Request/Response Objects
```
// Separate DTOs for different operations
public record CreateDoctorRequest(
    @NotBlank String fullName,
    @NotBlank String specialty,
    @NotBlank String licenseNumber,
    Long departmentId,
    @PastOrPresent LocalDate hireDate
) {}

public record UpdateDoctorRequest(
    @NotBlank String fullName,
    String specialty,
    Long departmentId
) {}

public record DoctorDTO(
    Long id,
    String fullName,
    String specialty,
    String licenseNumber,
    String departmentName,
    LocalDate hireDate
) {}
```

### HTTP Status Codes
```
// Success
200 OK              - Successful GET, PUT, PATCH
201 Created         - Successful POST
204 No Content      - Successful DELETE

// Client Errors
400 Bad Request     - Invalid input
401 Unauthorized    - Authentication required
403 Forbidden       - Authorization failed
404 Not Found       - Resource doesn't exist
409 Conflict        - Business rule violation

// Server Errors
500 Internal Server Error  - Unexpected error
503 Service Unavailable    - Database/service down
```

## Service Layer Conventions

### Service Design
```java
@Service
@RequiredArgsConstructor
@Slf4j
public class DoctorServiceImpl implements DoctorService {
    
    private final DoctorRepository doctorRepository;
    private final DoctorMapper doctorMapper;
    
    @Override
    @Transactional(readOnly = true)
    public DoctorDTO getDoctorById(Long id) {
        log.debug("Fetching doctor with id: {}", id);
        
        Doctor doctor = doctorRepository.findById(id)
            .orElseThrow(() -> new DoctorNotFoundException(id));
            
        return doctorMapper.toDTO(doctor);
    }
    
    @Override
    @Transactional
    public DoctorDTO createDoctor(CreateDoctorRequest request) {
        log.info("Creating new doctor: {}", request.fullName());
        
        // Validate business rules
        validateLicenseNumber(request.licenseNumber());
        
        // Convert and save
        Doctor doctor = doctorMapper.toEntity(request);
        Doctor saved = doctorRepository.save(doctor);
        
        log.info("Doctor created with id: {}", saved.getId());
        return doctorMapper.toDTO(saved);
    }
    
    private void validateLicenseNumber(String licenseNumber) {
        if (doctorRepository.existsByLicenseNumber(licenseNumber)) {
            throw new DuplicateLicenseException(licenseNumber);
        }
    }
}
```

### Transaction Management
```java
// Read-only transactions for queries
@Transactional(readOnly = true)
public DoctorDTO findById(Long id) { }

// Default transaction for modifications
@Transactional
public DoctorDTO create(CreateDoctorRequest request) { }

// Custom transaction settings
@Transactional(
    propagation = Propagation.REQUIRES_NEW,
    isolation = Isolation.READ_COMMITTED,
    timeout = 30
)
public void complexOperation() { }
```

## Exception Handling

### Custom Exceptions
```java
// Base exception
public abstract class HospitalErpException extends RuntimeException {
    protected HospitalErpException(String message) {
        super(message);
    }
    
    protected HospitalErpException(String message, Throwable cause) {
        super(message, cause);
    }
}

// Specific exceptions
public class DoctorNotFoundException extends HospitalErpException {
    public DoctorNotFoundException(Long id) {
        super("Doctor not found with id: " + id);
    }
}

public class DuplicateLicenseException extends HospitalErpException {
    public DuplicateLicenseException(String licenseNumber) {
        super("Doctor already exists with license number: " + licenseNumber);
    }
}
```

### Global Exception Handler
```java
@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {
    
    @ExceptionHandler(DoctorNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(DoctorNotFoundException ex) {
        log.warn("Resource not found: {}", ex.getMessage());
        
        ErrorResponse error = ErrorResponse.builder()
            .timestamp(LocalDateTime.now())
            .status(HttpStatus.NOT_FOUND.value())
            .error("Not Found")
            .message(ex.getMessage())
            .build();
            
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }
    
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidation(
            MethodArgumentNotValidException ex) {
        
        Map<String, String> errors = ex.getBindingResult()
            .getFieldErrors()
            .stream()
            .collect(Collectors.toMap(
                FieldError::getField,
                FieldError::getDefaultMessage
            ));
            
        ErrorResponse error = ErrorResponse.builder()
            .timestamp(LocalDateTime.now())
            .status(HttpStatus.BAD_REQUEST.value())
            .error("Validation Failed")
            .message("Invalid input parameters")
            .validationErrors(errors)
            .build();
            
        return ResponseEntity.badRequest().body(error);
    }
}
```

## Testing Conventions

### Unit Tests
```java
@ExtendWith(MockitoExtension.class)
class DoctorServiceTest {
    
    @Mock
    private DoctorRepository doctorRepository;
    
    @Mock
    private DoctorMapper doctorMapper;
    
    @InjectMocks
    private DoctorServiceImpl doctorService;
    
    @Test
    @DisplayName("Should return doctor when ID exists")
    void getDoctorById_WhenExists_ReturnsDoctor() {
        // Given
        Long doctorId = 1L;
        Doctor doctor = Doctor.builder()
            .id(doctorId)
            .fullName("Dr. Smith")
            .build();
            
        when(doctorRepository.findById(doctorId))
            .thenReturn(Optional.of(doctor));
            
        // When
        DoctorDTO result = doctorService.getDoctorById(doctorId);
        
        // Then
        assertNotNull(result);
        verify(doctorRepository).findById(doctorId);
    }
    
    @Test
    @DisplayName("Should throw exception when doctor not found")
    void getDoctorById_WhenNotExists_ThrowsException() {
        // Given
        Long doctorId = 999L;
        when(doctorRepository.findById(doctorId))
            .thenReturn(Optional.empty());
        
        // When & Then
        assertThrows(DoctorNotFoundException.class, 
            () -> doctorService.getDoctorById(doctorId));
    }
}
```

### Integration Tests
```java
@SpringBootTest
@Testcontainers
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class DoctorRepositoryIntegrationTest {
    
    @Container
    static OracleContainer oracle = new OracleContainer("gvenzl/oracle-xe:21-slim");
    
    @Autowired
    private DoctorRepository doctorRepository;
    
    @Test
    void shouldSaveAndRetrieveDoctor() {
        // Given
        Doctor doctor = Doctor.builder()
            .fullName("Dr. Johnson")
            .specialty("Cardiology")
            .build();
        
        // When
        Doctor saved = doctorRepository.save(doctor);
        Doctor retrieved = doctorRepository.findById(saved.getId()).orElseThrow();
        
        // Then
        assertThat(retrieved).isEqualTo(saved);
    }
}
```

## Code Quality

### Static Analysis
- Use SonarLint for real-time code quality feedback
- Run SpotBugs for bug detection
- Use Checkstyle for code style enforcement

### Code Coverage
- Target: Minimum 80% coverage
- Focus on business logic coverage
- Don't chase 100% coverage on trivial code

### Code Review Checklist
- [ ] Code follows naming conventions
- [ ] Methods are small and focused
- [ ] No code duplication
- [ ] Proper exception handling
- [ ] Tests are included
- [ ] Documentation is updated
- [ ] No commented-out code
- [ ] No TODO comments without tickets

## Comments & Documentation

### When to Comment
```java
// ✓ Good - Explain WHY, not WHAT
// Using exponential backoff to handle rate limiting from external API
private void retryWithBackoff() { }

// ✗ Bad - Comments that state the obvious
// Get the doctor's name
public String getName() { return name; }

// ✓ Good - Complex business logic
// Calculate dosage based on patient weight and age
// Formula: base_dose * (weight_kg / 70) * age_factor
// Age factor: 1.0 for adults, 0.5 for children under 12
private double calculateDosage(Patient patient) { }
```

### JavaDoc
```java
/**
 * Creates a new appointment for a patient with a doctor.
 * 
 * @param patientId the ID of the patient
 * @param doctorId the ID of the doctor
 * @param appointmentTime the scheduled time for the appointment
 * @return the created appointment DTO
 * @throws PatientNotFoundException if patient doesn't exist
 * @throws DoctorNotFoundException if doctor doesn't exist
 * @throws InvalidAppointmentException if appointment time is invalid
 */
public AppointmentDTO createAppointment(
        Long patientId, 
        Long doctorId, 
        LocalDateTime appointmentTime) {
    // implementation
}
```

## Git Conventions

### Commit Messages
```
type(scope): subject

body

footer

Types: feat, fix, docs, style, refactor, test, chore
Scope: module name (api, service, domain, etc.)
Subject: imperative mood, lowercase, no period

Examples:
feat(api): add patient search endpoint
fix(service): resolve appointment overlap validation
docs(readme): update setup instructions
refactor(domain): simplify doctor entity relationships
test(service): add unit tests for appointment service
```

---
*Last Updated: 25-Jan-2026*
*Version: 1.0*

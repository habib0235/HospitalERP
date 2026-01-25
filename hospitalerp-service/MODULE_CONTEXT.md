# hospitalerp-service - Module Context

## Module Overview

The `hospitalerp-service` module provides the business logic layer for the HospitalERP application. It orchestrates business operations, enforces business rules, manages transactions, and coordinates between the API layer and the persistence layer.

## Module Purpose

- **Primary Responsibility**: Business logic and use case implementations
- **Layer**: Service/Application Layer
- **Package Base**: `com.example.hospitalerp.service`

## Dependencies

### Internal Dependencies
- `hospitalerp-domain` - Domain entities
- `hospitalerp-persistence` - Data access layer

### External Dependencies
- Spring Framework - Dependency injection and transaction management
- Lombok - Code generation
- MapStruct (recommended) - DTO mapping

## Current Status

⚠️ **Module is currently empty and awaiting implementation**

### What Exists
- Module structure created
- Maven configuration in place

### What's Missing
- Service interfaces
- Service implementations
- DTOs (Data Transfer Objects)
- Mappers (Entity ↔ DTO conversion)
- Business validators
- Custom exceptions

## Planned Architecture

### Service Layer Pattern
```
Controller
    ↓
Service Interface
    ↓
Service Implementation
    ├─> Business Logic
    ├─> Validation
    ├─> Transaction Management
    └─> Repository Calls
```

## Planned Package Structure

```
com.example.hospitalerp.service/
├── DoctorService.java                    # Interface
├── PatientService.java
├── AppointmentService.java
├── AdmissionService.java
├── DepartmentService.java
├── PrescriptionService.java
├── InventoryService.java
├── MedicalRecordService.java
└── [other service interfaces]

com.example.hospitalerp.service.impl/
├── DoctorServiceImpl.java                # Implementation
├── PatientServiceImpl.java
├── AppointmentServiceImpl.java
└── [other implementations]

com.example.hospitalerp.dto/
├── DoctorDTO.java
├── PatientDTO.java
├── AppointmentDTO.java
├── CreateDoctorRequest.java
├── UpdateDoctorRequest.java
└── [other DTOs]

com.example.hospitalerp.mapper/
├── DoctorMapper.java
├── PatientMapper.java
├── AppointmentMapper.java
└── [other mappers]

com.example.hospitalerp.validator/
├── AppointmentValidator.java
├── AdmissionValidator.java
└── [other validators]

com.example.hospitalerp.exception/
├── DoctorNotFoundException.java
├── PatientNotFoundException.java
├── DuplicateLicenseException.java
├── InvalidAppointmentException.java
└── [other exceptions]
```

## Planned Service Interfaces

### 1. DoctorService
```java
package com.example.hospitalerp.service;

import com.example.hospitalerp.dto.DoctorDTO;
import com.example.hospitalerp.dto.CreateDoctorRequest;
import com.example.hospitalerp.dto.UpdateDoctorRequest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface DoctorService {
    
    /**
     * Retrieve all doctors with pagination
     */
    Page<DoctorDTO> getAllDoctors(Pageable pageable);
    
    /**
     * Find doctor by ID
     * @throws DoctorNotFoundException if doctor not found
     */
    DoctorDTO getDoctorById(Long id);
    
    /**
     * Find doctors by specialty
     */
    List<DoctorDTO> getDoctorsBySpecialty(String specialty);
    
    /**
     * Find doctors by department
     */
    List<DoctorDTO> getDoctorsByDepartment(Long departmentId);
    
    /**
     * Find doctor by license number
     */
    DoctorDTO getDoctorByLicenseNumber(String licenseNumber);
    
    /**
     * Create a new doctor
     * @throws DuplicateLicenseException if license number already exists
     */
    DoctorDTO createDoctor(CreateDoctorRequest request);
    
    /**
     * Update doctor information
     * @throws DoctorNotFoundException if doctor not found
     */
    DoctorDTO updateDoctor(Long id, UpdateDoctorRequest request);
    
    /**
     * Partial update of doctor
     */
    DoctorDTO patchDoctor(Long id, Map<String, Object> updates);
    
    /**
     * Delete a doctor
     * @throws DoctorNotFoundException if doctor not found
     * @throws CannotDeleteDoctorException if doctor has active appointments
     */
    void deleteDoctor(Long id);
    
    /**
     * Check if license number is available
     */
    boolean isLicenseNumberAvailable(String licenseNumber);
    
    /**
     * Get doctor's appointments
     */
    List<AppointmentDTO> getDoctorAppointments(Long doctorId, LocalDate date);
}
```

### 2. PatientService
```java
package com.example.hospitalerp.service;

import com.example.hospitalerp.dto.*;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface PatientService {
    
    Page<PatientDTO> getAllPatients(Pageable pageable);
    
    PatientDTO getPatientById(Long id);
    
    PatientDTO getPatientByNationalId(String nationalId);
    
    List<PatientDTO> searchPatientsByName(String name);
    
    PatientDTO createPatient(CreatePatientRequest request);
    
    PatientDTO updatePatient(Long id, UpdatePatientRequest request);
    
    void deletePatient(Long id);
    
    List<AppointmentDTO> getPatientAppointments(Long patientId);
    
    List<AdmissionDTO> getPatientAdmissions(Long patientId);
    
    List<PrescriptionDTO> getPatientPrescriptions(Long patientId);
    
    List<MedicalRecordDTO> getPatientMedicalRecords(Long patientId);
    
    boolean isNationalIdRegistered(String nationalId);
}
```

### 3. AppointmentService
```java
package com.example.hospitalerp.service;

import com.example.hospitalerp.dto.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public interface AppointmentService {
    
    AppointmentDTO getAppointmentById(Long id);
    
    List<AppointmentDTO> getAppointmentsByDoctor(Long doctorId, LocalDate date);
    
    List<AppointmentDTO> getAppointmentsByPatient(Long patientId);
    
    List<AppointmentDTO> getAppointmentsByStatus(String status);
    
    AppointmentDTO createAppointment(CreateAppointmentRequest request);
    
    AppointmentDTO updateAppointment(Long id, UpdateAppointmentRequest request);
    
    AppointmentDTO updateAppointmentStatus(Long id, String status);
    
    void cancelAppointment(Long id);
    
    List<LocalDateTime> getAvailableSlots(Long doctorId, LocalDate date);
    
    boolean isSlotAvailable(Long doctorId, LocalDateTime dateTime);
}
```

### 4. AdmissionService
```java
package com.example.hospitalerp.service;

import com.example.hospitalerp.dto.*;
import java.time.LocalDate;
import java.util.List;

public interface AdmissionService {
    
    AdmissionDTO getAdmissionById(Long id);
    
    List<AdmissionDTO> getCurrentAdmissions();
    
    List<AdmissionDTO> getAdmissionsByPatient(Long patientId);
    
    List<AdmissionDTO> getAdmissionsByRoom(Long roomId);
    
    AdmissionDTO admitPatient(CreateAdmissionRequest request);
    
    AdmissionDTO updateAdmission(Long id, UpdateAdmissionRequest request);
    
    AdmissionDTO dischargePatient(Long admissionId, LocalDate dischargeDate);
    
    void cancelAdmission(Long id);
    
    boolean isRoomAvailable(Long roomId);
    
    Double getAverageLengthOfStay();
}
```

### Additional Services
- `DepartmentService`
- `PrescriptionService`
- `MedicalRecordService`
- `InventoryService`
- `NurseService`
- `RoomService`

## Service Implementation Example

### DoctorServiceImpl
```java
package com.example.hospitalerp.service.impl;

import com.example.hospitalerp.dto.DoctorDTO;
import com.example.hospitalerp.dto.CreateDoctorRequest;
import com.example.hospitalerp.dto.UpdateDoctorRequest;
import com.example.hospitalerp.exception.DoctorNotFoundException;
import com.example.hospitalerp.exception.DuplicateLicenseException;
import com.example.hospitalerp.mapper.DoctorMapper;
import com.example.hospitalerp.model.Doctor;
import com.example.hospitalerp.repository.DoctorRepository;
import com.example.hospitalerp.service.DoctorService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional(readOnly = true)
public class DoctorServiceImpl implements DoctorService {
    
    private final DoctorRepository doctorRepository;
    private final DoctorMapper doctorMapper;
    
    @Override
    public Page<DoctorDTO> getAllDoctors(Pageable pageable) {
        log.debug("Fetching all doctors with pagination: {}", pageable);
        return doctorRepository.findAll(pageable)
            .map(doctorMapper::toDTO);
    }
    
    @Override
    public DoctorDTO getDoctorById(Long id) {
        log.debug("Fetching doctor with id: {}", id);
        Doctor doctor = doctorRepository.findById(id)
            .orElseThrow(() -> new DoctorNotFoundException(id));
        return doctorMapper.toDTO(doctor);
    }
    
    @Override
    public List<DoctorDTO> getDoctorsBySpecialty(String specialty) {
        log.debug("Fetching doctors by specialty: {}", specialty);
        return doctorRepository.findBySpecialty(specialty).stream()
            .map(doctorMapper::toDTO)
            .collect(Collectors.toList());
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
    
    @Override
    @Transactional
    public DoctorDTO updateDoctor(Long id, UpdateDoctorRequest request) {
        log.info("Updating doctor with id: {}", id);
        
        Doctor doctor = doctorRepository.findById(id)
            .orElseThrow(() -> new DoctorNotFoundException(id));
        
        // Update fields
        doctorMapper.updateEntity(doctor, request);
        Doctor updated = doctorRepository.save(doctor);
        
        log.info("Doctor updated: {}", id);
        return doctorMapper.toDTO(updated);
    }
    
    @Override
    @Transactional
    public void deleteDoctor(Long id) {
        log.info("Deleting doctor with id: {}", id);
        
        Doctor doctor = doctorRepository.findById(id)
            .orElseThrow(() -> new DoctorNotFoundException(id));
        
        // Business rule: Cannot delete doctor with active appointments
        if (hasActiveAppointments(doctor)) {
            throw new CannotDeleteDoctorException(id, 
                "Doctor has active appointments");
        }
        
        doctorRepository.delete(doctor);
        log.info("Doctor deleted: {}", id);
    }
    
    private void validateLicenseNumber(String licenseNumber) {
        if (doctorRepository.existsByLicenseNumber(licenseNumber)) {
            throw new DuplicateLicenseException(licenseNumber);
        }
    }
    
    private boolean hasActiveAppointments(Doctor doctor) {
        // Implementation to check active appointments
        return false; // Placeholder
    }
}
```

## DTOs (Data Transfer Objects)

### Read DTO
```java
package com.example.hospitalerp.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;

public record DoctorDTO(
    Long id,
    String fullName,
    String specialty,
    String licenseNumber,
    DepartmentDTO department,
    LocalDate hireDate,
    LocalDateTime createdAt,
    LocalDateTime updatedAt
) {}
```

### Create Request DTO
```java
package com.example.hospitalerp.dto;

import jakarta.validation.constraints.*;
import java.time.LocalDate;

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

### Update Request DTO
```java
package com.example.hospitalerp.dto;

import jakarta.validation.constraints.*;
import java.time.LocalDate;

public record UpdateDoctorRequest(
    
    @NotBlank
    @Size(max = 200)
    String fullName,
    
    @Size(max = 100)
    String specialty,
    
    @Positive
    Long departmentId,
    
    LocalDate hireDate
) {}
```

## Mappers

### MapStruct Mapper
```java
package com.example.hospitalerp.mapper;

import com.example.hospitalerp.dto.*;
import com.example.hospitalerp.model.Doctor;
import org.mapstruct.*;

@Mapper(
    componentModel = "spring",
    unmappedTargetPolicy = ReportingPolicy.IGNORE,
    nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE
)
public interface DoctorMapper {
    
    // Entity to DTO
    @Mapping(source = "department.departmentName", target = "department.name")
    DoctorDTO toDTO(Doctor doctor);
    
    // Request to Entity
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "department", ignore = true)
    Doctor toEntity(CreateDoctorRequest request);
    
    // Update entity from request
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "licenseNumber", ignore = true)
    void updateEntity(@MappingTarget Doctor doctor, UpdateDoctorRequest request);
    
    // List mapping
    List<DoctorDTO> toDTOList(List<Doctor> doctors);
}
```

### Manual Mapper (Alternative)
```java
package com.example.hospitalerp.mapper;

import com.example.hospitalerp.dto.*;
import com.example.hospitalerp.model.Doctor;
import org.springframework.stereotype.Component;

@Component
public class DoctorMapperManual {
    
    public DoctorDTO toDTO(Doctor doctor) {
        if (doctor == null) return null;
        
        return new DoctorDTO(
            doctor.getId(),
            doctor.getFullName(),
            doctor.getSpecialty(),
            doctor.getLicenseNumber(),
            mapDepartment(doctor.getDepartment()),
            doctor.getHireDate(),
            doctor.getCreatedAt(),
            doctor.getUpdatedAt()
        );
    }
    
    public Doctor toEntity(CreateDoctorRequest request) {
        return Doctor.builder()
            .fullName(request.fullName())
            .specialty(request.specialty())
            .licenseNumber(request.licenseNumber())
            .hireDate(request.hireDate())
            .build();
    }
    
    private DepartmentDTO mapDepartment(Department department) {
        if (department == null) return null;
        // mapping logic
    }
}
```

## Exception Handling

### Custom Exceptions
```java
package com.example.hospitalerp.exception;

public class DoctorNotFoundException extends ResourceNotFoundException {
    public DoctorNotFoundException(Long id) {
        super("Doctor not found with id: " + id);
    }
}

public class DuplicateLicenseException extends BusinessRuleException {
    public DuplicateLicenseException(String licenseNumber) {
        super("Doctor already exists with license number: " + licenseNumber);
    }
}

public class CannotDeleteDoctorException extends BusinessRuleException {
    public CannotDeleteDoctorException(Long id, String reason) {
        super(String.format("Cannot delete doctor %d: %s", id, reason));
    }
}

public abstract class ResourceNotFoundException extends RuntimeException {
    protected ResourceNotFoundException(String message) {
        super(message);
    }
}

public abstract class BusinessRuleException extends RuntimeException {
    protected BusinessRuleException(String message) {
        super(message);
    }
}
```

## Business Validators

### Appointment Validator
```java
package com.example.hospitalerp.validator;

import com.example.hospitalerp.dto.CreateAppointmentRequest;
import com.example.hospitalerp.exception.InvalidAppointmentException;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
public class AppointmentValidator {
    
    public void validateAppointmentRequest(CreateAppointmentRequest request) {
        validateDateTime(request.appointmentDateTime());
        validateWorkingHours(request.appointmentDateTime());
    }
    
    private void validateDateTime(LocalDateTime dateTime) {
        if (dateTime.isBefore(LocalDateTime.now())) {
            throw new InvalidAppointmentException(
                "Appointment date cannot be in the past");
        }
    }
    
    private void validateWorkingHours(LocalDateTime dateTime) {
        int hour = dateTime.getHour();
        if (hour < 8 || hour >= 18) {
            throw new InvalidAppointmentException(
                "Appointment must be during working hours (8:00 - 18:00)");
        }
    }
}
```

## Transaction Management

### Transaction Boundaries
```java
@Service
@Transactional(readOnly = true)  // Default: read-only transactions
public class DoctorServiceImpl implements DoctorService {
    
    // Read operation - uses class-level read-only transaction
    @Override
    public DoctorDTO getDoctorById(Long id) {
        // ...
    }
    
    // Write operation - overrides with read-write transaction
    @Override
    @Transactional
    public DoctorDTO createDoctor(CreateDoctorRequest request) {
        // ...
    }
    
    // Complex operation with specific settings
    @Override
    @Transactional(
        propagation = Propagation.REQUIRES_NEW,
        isolation = Isolation.READ_COMMITTED,
        timeout = 30,
        rollbackFor = Exception.class
    )
    public void complexOperation() {
        // ...
    }
}
```

## Testing Services

### Service Unit Tests
```java
@ExtendWith(MockitoExtension.class)
class DoctorServiceImplTest {
    
    @Mock
    private DoctorRepository doctorRepository;
    
    @Mock
    private DoctorMapper doctorMapper;
    
    @InjectMocks
    private DoctorServiceImpl doctorService;
    
    @Test
    void getDoctorById_WhenExists_ReturnsDoctor() {
        // Given
        Long doctorId = 1L;
        Doctor doctor = Doctor.builder().id(doctorId).build();
        DoctorDTO dto = new DoctorDTO(/* ... */);
        
        when(doctorRepository.findById(doctorId))
            .thenReturn(Optional.of(doctor));
        when(doctorMapper.toDTO(doctor)).thenReturn(dto);
        
        // When
        DoctorDTO result = doctorService.getDoctorById(doctorId);
        
        // Then
        assertNotNull(result);
        verify(doctorRepository).findById(doctorId);
        verify(doctorMapper).toDTO(doctor);
    }
    
    @Test
    void createDoctor_WithDuplicateLicense_ThrowsException() {
        // Given
        CreateDoctorRequest request = new CreateDoctorRequest(/* ... */);
        when(doctorRepository.existsByLicenseNumber(request.licenseNumber()))
            .thenReturn(true);
        
        // When & Then
        assertThrows(DuplicateLicenseException.class,
            () -> doctorService.createDoctor(request));
    }
}
```

## Migration Path

### Implementation Steps
1. ✅ Module structure created
2. ⏳ Define service interfaces
3. ⏳ Create DTOs
4. ⏳ Implement mappers (MapStruct)
5. ⏳ Implement service classes
6. ⏳ Add business validators
7. ⏳ Create custom exceptions
8. ⏳ Write comprehensive tests
9. ⏳ Add transaction management
10. ⏳ Document business rules

### Priority Order
1. **High Priority**: Core services (Doctor, Patient, Appointment)
2. **Medium Priority**: Supporting services (Department, Admission, Prescription)
3. **Low Priority**: Utility services (Inventory, Reporting)

## Best Practices

1. **Service Interface** - Always define interfaces
2. **Single Responsibility** - Each service has clear purpose
3. **Transaction Management** - Service layer owns transactions
4. **Use DTOs** - Never pass entities to controllers
5. **Validate Input** - Check business rules
6. **Handle Exceptions** - Throw meaningful exceptions
7. **Log Operations** - Debug and info logging
8. **Test Thoroughly** - Unit tests for all methods

## Configuration

### Service Properties
```properties
# Service-specific settings (future)
hospital.appointment.max-per-day=20
hospital.admission.max-length-days=30
```

## Resources

- [Spring Service Layer](https://spring.io/guides/gs/service/)
- [Transaction Management](https://docs.spring.io/spring-framework/docs/current/reference/html/data-access.html#transaction)
- [MapStruct Documentation](https://mapstruct.org/)
- [DTO Pattern](https://martinfowler.com/eaaCatalog/dataTransferObject.html)

---
*Last Updated: January 25, 2026*
*Module Version: 0.0.1-SNAPSHOT*
*Status: ⚠️ NOT YET IMPLEMENTED*

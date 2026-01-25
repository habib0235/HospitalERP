# hospitalerp-persistence - Module Context

## Module Overview

The `hospitalerp-persistence` module provides the data access layer for the HospitalERP application. It contains repository interfaces and custom query implementations that abstract database operations.

## Module Purpose

- **Primary Responsibility**: Data access and repository implementations
- **Layer**: Persistence/Data Access Layer
- **Package Base**: `com.example.hospitalerp.repository`

## Dependencies

### Internal Dependencies
- `hospitalerp-domain` - Domain entities

### External Dependencies
- Spring Data JPA - Repository abstraction
- Hibernate - ORM implementation
- Oracle JDBC Driver - Database connectivity

## Current Status

⚠️ **Module is currently empty and awaiting implementation**

### What Exists
- Module structure created
- Maven configuration in place

### What's Missing
- Repository interfaces
- Custom query implementations
- Specifications for complex queries
- Database-specific optimizations

## Planned Architecture

### Repository Pattern
```
Repository Interface (Spring Data JPA)
    ↓
Spring Data JPA Implementation (Runtime Generated)
    ↓
Hibernate Session
    ↓
JDBC
    ↓
Oracle Database
```

## Planned Package Structure

```
com.example.hospitalerp.repository/
├── DoctorRepository.java
├── PatientRepository.java
├── AppointmentRepository.java
├── AdmissionRepository.java
├── DepartmentRepository.java
├── NurseRepository.java
├── RoomRepository.java
├── PrescriptionRepository.java
├── MedicalRecordRepository.java
├── InventoryItemRepository.java
├── InventoryStockRepository.java
└── SupplierRepository.java

com.example.hospitalerp.repository.custom/
├── DoctorRepositoryCustom.java
├── DoctorRepositoryCustomImpl.java
└── [other custom repositories]

com.example.hospitalerp.specification/
├── DoctorSpecifications.java
├── PatientSpecifications.java
└── [other specifications]
```

## Planned Repository Interfaces

### 1. DoctorRepository
```java
package com.example.hospitalerp.repository;

import com.example.hospitalerp.model.Doctor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DoctorRepository extends 
        JpaRepository<Doctor, Long>, 
        JpaSpecificationExecutor<Doctor> {
    
    // Derived query methods
    List<Doctor> findBySpecialty(String specialty);
    
    List<Doctor> findByDepartmentId(Long departmentId);
    
    Optional<Doctor> findByLicenseNumber(String licenseNumber);
    
    boolean existsByLicenseNumber(String licenseNumber);
    
    long countBySpecialty(String specialty);
    
    // JPQL queries
    @Query("SELECT d FROM Doctor d WHERE d.specialty = :specialty AND d.department.id = :deptId")
    List<Doctor> findBySpecialtyAndDepartment(
        @Param("specialty") String specialty,
        @Param("deptId") Long departmentId
    );
    
    // Fetch join to avoid N+1
    @Query("SELECT DISTINCT d FROM Doctor d " +
           "LEFT JOIN FETCH d.department " +
           "WHERE d.id = :id")
    Optional<Doctor> findByIdWithDepartment(@Param("id") Long id);
    
    // Native query (Oracle-specific if needed)
    @Query(value = "SELECT * FROM doctors WHERE specialty = :specialty", 
           nativeQuery = true)
    List<Doctor> findBySpecialtyNative(@Param("specialty") String specialty);
}
```

### 2. PatientRepository
```java
package com.example.hospitalerp.repository;

import com.example.hospitalerp.model.Patient;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface PatientRepository extends 
        JpaRepository<Patient, Long>,
        JpaSpecificationExecutor<Patient> {
    
    Optional<Patient> findByNationalId(String nationalId);
    
    List<Patient> findByGender(String gender);
    
    List<Patient> findByDateOfBirthBetween(LocalDate start, LocalDate end);
    
    // Full-text search on name
    @Query("SELECT p FROM Patient p WHERE LOWER(p.fullName) LIKE LOWER(CONCAT('%', :name, '%'))")
    List<Patient> searchByName(String name);
    
    // Find patients with upcoming appointments
    @Query("SELECT DISTINCT p FROM Patient p " +
           "JOIN p.appointments a " +
           "WHERE a.appointmentDate >= CURRENT_DATE " +
           "AND a.status = 'SCHEDULED'")
    List<Patient> findPatientsWithUpcomingAppointments();
    
    // Find currently admitted patients
    @Query("SELECT DISTINCT p FROM Patient p " +
           "JOIN p.admissions adm " +
           "WHERE adm.dischargeDate IS NULL")
    List<Patient> findCurrentlyAdmittedPatients();
    
    // Pagination support
    Page<Patient> findByFullNameContainingIgnoreCase(String name, Pageable pageable);
}
```

### 3. AppointmentRepository
```java
package com.example.hospitalerp.repository;

import com.example.hospitalerp.model.Appointment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
    
    List<Appointment> findByDoctorId(Long doctorId);
    
    List<Appointment> findByPatientId(Long patientId);
    
    List<Appointment> findByAppointmentDate(LocalDate date);
    
    List<Appointment> findByStatus(String status);
    
    // Find appointments for a doctor on a specific date
    @Query("SELECT a FROM Appointment a " +
           "WHERE a.doctor.id = :doctorId " +
           "AND a.appointmentDate = :date")
    List<Appointment> findByDoctorAndDate(Long doctorId, LocalDate date);
    
    // Check for conflicting appointments
    @Query("SELECT COUNT(a) > 0 FROM Appointment a " +
           "WHERE a.doctor.id = :doctorId " +
           "AND a.appointmentDate = :date " +
           "AND a.status != 'CANCELLED'")
    boolean hasAppointmentConflict(Long doctorId, LocalDate date);
    
    // Find available slots
    @Query("SELECT a.appointmentDate FROM Appointment a " +
           "WHERE a.doctor.id = :doctorId " +
           "AND a.appointmentDate BETWEEN :startDate AND :endDate " +
           "AND a.status != 'CANCELLED'")
    List<LocalDate> findBookedSlots(Long doctorId, LocalDate startDate, LocalDate endDate);
}
```

### 4. AdmissionRepository
```java
package com.example.hospitalerp.repository;

import com.example.hospitalerp.model.Admission;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface AdmissionRepository extends JpaRepository<Admission, Long> {
    
    List<Admission> findByPatientId(Long patientId);
    
    List<Admission> findByRoomId(Long roomId);
    
    // Find current admissions (not discharged)
    @Query("SELECT a FROM Admission a WHERE a.dischargeDate IS NULL")
    List<Admission> findCurrentAdmissions();
    
    // Find admissions in date range
    List<Admission> findByAdmissionDateBetween(LocalDate start, LocalDate end);
    
    // Calculate average length of stay
    @Query("SELECT AVG(DATEDIFF(day, a.admissionDate, a.dischargeDate)) " +
           "FROM Admission a WHERE a.dischargeDate IS NOT NULL")
    Double getAverageLengthOfStay();
    
    // Check room availability
    @Query("SELECT COUNT(a) = 0 FROM Admission a " +
           "WHERE a.room.id = :roomId " +
           "AND a.dischargeDate IS NULL")
    boolean isRoomAvailable(Long roomId);
}
```

### 5. DepartmentRepository
```java
package com.example.hospitalerp.repository;

import com.example.hospitalerp.model.Department;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface DepartmentRepository extends JpaRepository<Department, Long> {
    
    Optional<Department> findByDepartmentName(String departmentName);
    
    @Query("SELECT d FROM Department d LEFT JOIN FETCH d.doctors WHERE d.id = :id")
    Optional<Department> findByIdWithDoctors(Long id);
    
    @Query("SELECT COUNT(doc) FROM Department d JOIN d.doctors doc WHERE d.id = :id")
    long countDoctorsByDepartment(Long id);
}
```

### Additional Repositories
Similar patterns for:
- `NurseRepository`
- `RoomRepository`
- `PrescriptionRepository`
- `MedicalRecordRepository`
- `InventoryItemRepository`
- `InventoryStockRepository`
- `SupplierRepository`

## Custom Repository Implementation

### Custom Interface
```java
package com.example.hospitalerp.repository.custom;

import com.example.hospitalerp.model.Doctor;
import java.util.List;

public interface DoctorRepositoryCustom {
    List<Doctor> findDoctorsWithComplexCriteria(/* parameters */);
    void bulkUpdateDoctorStatus(List<Long> doctorIds, String status);
}
```

### Custom Implementation
```java
package com.example.hospitalerp.repository.custom;

import com.example.hospitalerp.model.Doctor;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.RequiredArgsConstructor;

import java.util.List;

public class DoctorRepositoryCustomImpl implements DoctorRepositoryCustom {
    
    @PersistenceContext
    private EntityManager entityManager;
    
    @Override
    public List<Doctor> findDoctorsWithComplexCriteria(/* parameters */) {
        // Complex criteria query
        return entityManager.createQuery(
            "SELECT d FROM Doctor d WHERE ...", Doctor.class)
            .getResultList();
    }
    
    @Override
    public void bulkUpdateDoctorStatus(List<Long> doctorIds, String status) {
        entityManager.createQuery(
            "UPDATE Doctor d SET d.status = :status WHERE d.id IN :ids")
            .setParameter("status", status)
            .setParameter("ids", doctorIds)
            .executeUpdate();
    }
}
```

### Extended Repository Interface
```java
package com.example.hospitalerp.repository;

import com.example.hospitalerp.repository.custom.DoctorRepositoryCustom;

public interface DoctorRepository extends 
        JpaRepository<Doctor, Long>,
        JpaSpecificationExecutor<Doctor>,
        DoctorRepositoryCustom {
    // Combines Spring Data JPA and custom methods
}
```

## JPA Specifications

### Specification Examples
```java
package com.example.hospitalerp.specification;

import com.example.hospitalerp.model.Doctor;
import org.springframework.data.jpa.domain.Specification;

public class DoctorSpecifications {
    
    public static Specification<Doctor> hasSpecialty(String specialty) {
        return (root, query, cb) -> 
            specialty == null ? null : cb.equal(root.get("specialty"), specialty);
    }
    
    public static Specification<Doctor> inDepartment(Long departmentId) {
        return (root, query, cb) ->
            departmentId == null ? null : 
                cb.equal(root.get("department").get("id"), departmentId);
    }
    
    public static Specification<Doctor> hiredAfter(LocalDate date) {
        return (root, query, cb) ->
            date == null ? null : cb.greaterThanOrEqualTo(root.get("hireDate"), date);
    }
    
    public static Specification<Doctor> nameContains(String name) {
        return (root, query, cb) ->
            name == null ? null : 
                cb.like(cb.lower(root.get("fullName")), 
                    "%" + name.toLowerCase() + "%");
    }
}

// Usage in service
Specification<Doctor> spec = Specification
    .where(DoctorSpecifications.hasSpecialty("Cardiology"))
    .and(DoctorSpecifications.inDepartment(5L))
    .and(DoctorSpecifications.nameContains("smith"));

List<Doctor> doctors = doctorRepository.findAll(spec);
```

## Query Methods Naming Convention

### Supported Keywords
- `findBy` - Query method
- `findOneBy` - Single result
- `countBy` - Count query
- `existsBy` - Boolean check
- `deleteBy` - Delete query
- `And` - Logical AND
- `Or` - Logical OR
- `Between` - Range query
- `LessThan` / `GreaterThan` - Comparison
- `Like` / `Containing` - Pattern matching
- `IgnoreCase` - Case-insensitive
- `OrderBy` - Sorting

### Examples
```java
// Exact match
findBySpecialty(String specialty);

// Multiple conditions
findBySpecialtyAndDepartmentId(String specialty, Long deptId);

// Pattern matching
findByFullNameContaining(String nameFragment);

// Case insensitive
findByFullNameIgnoreCase(String fullName);

// Range query
findByHireDateBetween(LocalDate start, LocalDate end);

// Comparison
findByHireDateAfter(LocalDate date);

// Sorting
findBySpecialtyOrderByFullNameAsc(String specialty);

// Pagination
Page<Doctor> findBySpecialty(String specialty, Pageable pageable);
```

## Performance Optimization

### N+1 Query Prevention
```java
// Use JOIN FETCH
@Query("SELECT d FROM Doctor d LEFT JOIN FETCH d.department WHERE d.id = :id")
Optional<Doctor> findByIdWithDepartment(@Param("id") Long id);

// Or use @EntityGraph
@EntityGraph(attributePaths = {"department", "appointments"})
Optional<Doctor> findById(Long id);
```

### Projection Interfaces
```java
public interface DoctorNameProjection {
    Long getId();
    String getFullName();
    String getSpecialty();
}

@Query("SELECT d.id as id, d.fullName as fullName, d.specialty as specialty " +
       "FROM Doctor d")
List<DoctorNameProjection> findAllProjections();
```

### Batch Operations
```java
@Modifying
@Query("UPDATE Doctor d SET d.department.id = :newDeptId WHERE d.id IN :doctorIds")
void updateDepartmentBulk(@Param("doctorIds") List<Long> doctorIds, 
                          @Param("newDeptId") Long newDeptId);
```

## Transaction Management

### Repository-Level (Not Recommended)
```java
// Spring Data JPA repositories are transactional by default
// But transactions should be managed at the service layer
```

### Best Practice
- Repositories should be transactionless
- Service layer manages transactions
- Use `@Transactional` in service methods

## Testing Repositories

### Repository Tests
```java
@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
@Testcontainers
class DoctorRepositoryTest {
    
    @Container
    static OracleContainer oracle = new OracleContainer("gvenzl/oracle-xe:21-slim");
    
    @Autowired
    private DoctorRepository doctorRepository;
    
    @Test
    void findBySpecialty_ReturnsMatchingDoctors() {
        // Given
        Doctor doctor = Doctor.builder()
            .fullName("Dr. Smith")
            .specialty("Cardiology")
            .build();
        doctorRepository.save(doctor);
        
        // When
        List<Doctor> found = doctorRepository.findBySpecialty("Cardiology");
        
        // Then
        assertThat(found).hasSize(1);
        assertThat(found.get(0).getFullName()).isEqualTo("Dr. Smith");
    }
}
```

## Migration Path

### Implementation Steps
1. ✅ Module structure created
2. ⏳ Create repository interfaces
3. ⏳ Implement custom queries
4. ⏳ Add specifications for complex queries
5. ⏳ Add projections for performance
6. ⏳ Write repository tests
7. ⏳ Optimize queries (indexes, fetch strategies)
8. ⏳ Document query patterns

### Priority Order
1. **High Priority**: Core CRUD repositories (Doctor, Patient, Appointment)
2. **Medium Priority**: Supporting repositories (Department, Admission, Prescription)
3. **Low Priority**: Utility repositories (Inventory, Supplier)

## Best Practices

1. **Keep Repositories Thin** - No business logic
2. **Use Derived Queries** - When method name is clear
3. **Use @Query for Complex** - JPQL for complex queries
4. **Avoid Native Queries** - Unless absolutely necessary
5. **Use Specifications** - For dynamic queries
6. **Prevent N+1** - Use JOIN FETCH or @EntityGraph
7. **Test Thoroughly** - Integration tests with Testcontainers
8. **Document Queries** - Complex queries need comments

## Configuration

### JPA Properties
```properties
# Repository scanning
spring.jpa.repositories.base-package=com.example.hospitalerp.repository

# Query logging
spring.jpa.show-sql=false
spring.jpa.properties.hibernate.format_sql=true
logging.level.org.hibernate.SQL=DEBUG
logging.level.org.hibernate.type.descriptor.sql.BasicBinder=TRACE
```

## Resources

- [Spring Data JPA Documentation](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/)
- [JPA Specification](https://jakarta.ee/specifications/persistence/)
- [Query Methods](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#jpa.query-methods)
- [Specifications](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#specifications)

---
*Last Updated: January 25, 2026*
*Module Version: 0.0.1-SNAPSHOT*
*Status: ⚠️ NOT YET IMPLEMENTED*

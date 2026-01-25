# hospitalerp-domain - Module Context

## Module Overview

The `hospitalerp-domain` module is the core domain layer of the HospitalERP application. It contains the fundamental business entities (JPA entities) that represent the hospital management domain model. This module is the foundation upon which all other modules depend.

## Module Purpose

- **Primary Responsibility**: Core domain entities and business models
- **Layer**: Domain Layer (Core)
- **Package Base**: `com.example.hospitalerp.model`

## Dependencies

### Internal Dependencies
- None - This is the core module with no internal dependencies

### External Dependencies
- Jakarta Persistence API - JPA annotations and specifications
- Hibernate - ORM implementation (runtime)
- Lombok - Code generation and boilerplate reduction

## Architecture Principles

1. **Domain-Driven Design** - Entities model real-world hospital concepts
2. **Framework Independence** - Minimal framework coupling
3. **Rich Domain Model** - Entities can contain business logic
4. **Persistence Ignorance** - Business logic not dependent on persistence details

## Current Domain Entities

### Core Entities

#### 1. Doctor
- **Table**: `doctors`
- **Purpose**: Medical practitioners in the hospital
- **Key Relationships**: 
  - Many-to-One with Department
  - One-to-Many with Appointment
  - One-to-Many with Prescription
- **File**: `Doctor.java`

#### 2. Patient
- **Table**: `patients`
- **Purpose**: Individuals receiving medical care
- **Key Relationships**:
  - One-to-Many with Admission
  - One-to-Many with Appointment
  - One-to-Many with MedicalRecord
  - One-to-Many with Prescription
- **File**: `Patient.java`

#### 3. Department
- **Table**: `departments`
- **Purpose**: Hospital organizational units
- **Key Relationships**:
  - One-to-Many with Doctor
  - One-to-Many with Nurse
- **File**: `Department.java`

#### 4. Nurse
- **Table**: `nurses`
- **Purpose**: Nursing staff
- **Key Relationships**:
  - Many-to-One with Department
- **File**: `Nurse.java`

#### 5. Appointment
- **Table**: `appointments`
- **Purpose**: Scheduled doctor-patient meetings
- **Key Relationships**:
  - Many-to-One with Patient
  - Many-to-One with Doctor
- **File**: `Appointment.java`

#### 6. Admission
- **Table**: `admissions`
- **Purpose**: Patient hospital stays
- **Key Relationships**:
  - Many-to-One with Patient
  - Many-to-One with Room
- **File**: `Admission.java`

#### 7. Room
- **Table**: `rooms`
- **Purpose**: Hospital room management
- **Key Relationships**:
  - One-to-Many with Admission
- **File**: `Room.java`

#### 8. Prescription
- **Table**: `prescriptions`
- **Purpose**: Medical prescriptions
- **Key Relationships**:
  - Many-to-One with Patient
  - Many-to-One with Doctor
- **File**: `Prescription.java`

#### 9. MedicalRecord
- **Table**: `medical_records`
- **Purpose**: Patient medical history
- **Key Relationships**:
  - Many-to-One with Patient
- **File**: `MedicalRecord.java`

#### 10. InventoryItem
- **Table**: `inventory_items`
- **Purpose**: Medical supplies catalog
- **Key Relationships**:
  - One-to-Many with InventoryStock
- **File**: `InventoryItem.java`

#### 11. InventoryStock
- **Table**: `inventory_stock`
- **Purpose**: Stock levels tracking
- **Key Relationships**:
  - Many-to-One with InventoryItem
  - Many-to-One with Supplier
- **File**: `InventoryStock.java`

#### 12. Supplier
- **Table**: `suppliers`
- **Purpose**: Medical supply vendors
- **Key Relationships**:
  - One-to-Many with InventoryStock
- **File**: `Supplier.java`

## Package Structure

### Current Structure
```
com.example.hospitalerp.model/
├── Doctor.java
├── Patient.java
├── Department.java
├── Nurse.java
├── Appointment.java
├── Admission.java
├── Room.java
├── Prescription.java
├── MedicalRecord.java
├── InventoryItem.java
├── InventoryStock.java
└── Supplier.java
```

### Recommended Future Structure
```
com.example.hospitalerp.model/
├── entity/
│   ├── Doctor.java
│   ├── Patient.java
│   └── [other entities]
├── valueobject/
│   ├── Address.java
│   ├── PhoneNumber.java
│   └── MedicalLicense.java
├── enums/
│   ├── AppointmentStatus.java
│   ├── RoomType.java
│   └── Gender.java
└── exception/
    ├── DomainException.java
    ├── InvalidDoctorException.java
    └── [other domain exceptions]
```

## Entity Design Patterns

### Standard Entity Template
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
    
    @Column(name = "attribute_name", nullable = false, length = 100)
    private String attributeName;
    
    // Exclude collections from toString and equals to avoid lazy loading issues
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @OneToMany(mappedBy = "entity", fetch = FetchType.LAZY)
    private List<RelatedEntity> relatedEntities;
}
```

### Lombok Usage

#### Recommended Annotations
- `@Data` - Generates getters, setters, toString, equals, hashCode
- `@NoArgsConstructor` - Required by JPA
- `@AllArgsConstructor` - Used with Builder
- `@Builder` - Fluent object creation
- `@ToString.Exclude` - Exclude lazy collections
- `@EqualsAndHashCode.Exclude` - Exclude lazy collections

#### Anti-Pattern: Avoid Circular References
```java
// ✗ Bad - Will cause infinite loop in toString
@Data
@Entity
public class Doctor {
    @OneToMany(mappedBy = "doctor")
    private List<Appointment> appointments;  // toString includes this
}

// ✓ Good - Excludes collections
@Data
@Entity
public class Doctor {
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @OneToMany(mappedBy = "doctor")
    private List<Appointment> appointments;
}
```

## JPA Mapping Strategies

### Identity Generation
```java
@Id
@GeneratedValue(strategy = GenerationType.IDENTITY)
@Column(name = "entity_id")
private Long id;
```
- Uses database auto-increment
- Suitable for Oracle IDENTITY columns

### Relationship Mappings

#### Many-to-One (Child Side)
```java
@ManyToOne(fetch = FetchType.LAZY)
@JoinColumn(name = "doctor_id", nullable = false)
private Doctor doctor;
```

#### One-to-Many (Parent Side)
```java
@ToString.Exclude
@EqualsAndHashCode.Exclude
@OneToMany(mappedBy = "doctor", fetch = FetchType.LAZY)
private List<Appointment> appointments;
```

#### Fetch Strategy
- Default to `FetchType.LAZY` for all relationships
- Use `FetchType.EAGER` only when absolutely necessary
- Consider using fetch joins in queries instead

### Column Mapping
```java
@Column(
    name = "column_name",           // Database column name
    nullable = false,               // NOT NULL constraint
    length = 100,                   // VARCHAR length
    unique = true,                  // UNIQUE constraint
    updatable = true,               // Can be updated
    insertable = true               // Can be inserted
)
private String attributeName;
```

## Domain Constraints

### Database Constraints
- Primary keys on all entities
- Foreign key relationships
- Unique constraints where applicable
- NOT NULL constraints on required fields

### Application-Level Validation
Consider adding validation in future:
```java
@Entity
@Table(name = "doctors")
public class Doctor {
    
    @NotBlank
    @Size(max = 200)
    private String fullName;
    
    @Pattern(regexp = "MD[0-9]{6}")
    private String licenseNumber;
    
    @PastOrPresent
    private LocalDate hireDate;
}
```

## Business Logic in Entities

### Rich Domain Model Pattern
Entities can contain business logic:

```java
@Entity
public class Admission {
    // ...fields...
    
    public boolean isCurrentlyAdmitted() {
        return dischargeDate == null;
    }
    
    public long getLengthOfStay() {
        LocalDate endDate = dischargeDate != null ? dischargeDate : LocalDate.now();
        return ChronoUnit.DAYS.between(admissionDate, endDate);
    }
    
    public void discharge(LocalDate dischargeDate) {
        if (dischargeDate.isBefore(admissionDate)) {
            throw new InvalidAdmissionException("Discharge date cannot be before admission date");
        }
        this.dischargeDate = dischargeDate;
    }
}
```

## Value Objects (Future Enhancement)

### Embeddable Value Objects
```java
@Embeddable
public class Address {
    @Column(name = "street")
    private String street;
    
    @Column(name = "city")
    private String city;
    
    @Column(name = "postal_code")
    private String postalCode;
    
    @Column(name = "country")
    private String country;
}

@Entity
public class Patient {
    @Embedded
    private Address address;
}
```

## Enumerations (Future Enhancement)

### Entity Enums
```java
public enum AppointmentStatus {
    SCHEDULED,
    CONFIRMED,
    COMPLETED,
    CANCELLED,
    NO_SHOW
}

public enum Gender {
    MALE,
    FEMALE,
    OTHER
}

public enum RoomType {
    GENERAL,
    PRIVATE,
    ICU,
    EMERGENCY,
    OPERATING
}

@Entity
public class Appointment {
    @Enumerated(EnumType.STRING)
    @Column(length = 30)
    private AppointmentStatus status;
}
```

## Audit Fields (Future Enhancement)

### Common Audit Pattern
```java
@MappedSuperclass
public abstract class AuditableEntity {
    
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @Column(name = "created_by", length = 100)
    private String createdBy;
    
    @Column(name = "updated_by", length = 100)
    private String updatedBy;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}

@Entity
public class Doctor extends AuditableEntity {
    // inherits audit fields
}
```

## Testing Entities

### Entity Tests
```java
class DoctorTest {
    
    @Test
    void builder_CreatesValidDoctor() {
        Doctor doctor = Doctor.builder()
            .fullName("Dr. Smith")
            .specialty("Cardiology")
            .licenseNumber("MD123456")
            .hireDate(LocalDate.of(2026, 1, 15))
            .build();
        
        assertNotNull(doctor);
        assertEquals("Dr. Smith", doctor.getFullName());
    }
    
    @Test
    void equals_SameId_ReturnsTrue() {
        Doctor doctor1 = Doctor.builder().id(1L).build();
        Doctor doctor2 = Doctor.builder().id(1L).build();
        
        assertEquals(doctor1, doctor2);
    }
}
```

## Database Schema Alignment

### Schema Generation
- **Current**: Managed by Liquibase
- **Hibernate DDL**: Set to `none` (no auto-generation)
- **Schema Location**: `hospitalerp-boot/src/main/resources/sql/`

### Entity-Table Mapping
Each entity maps to a corresponding database table:
```
Doctor          → doctors
Patient         → patients
Department      → departments
Nurse           → nurses
Appointment     → appointments
Admission       → admissions
Room            → rooms
Prescription    → prescriptions
MedicalRecord   → medical_records
InventoryItem   → inventory_items
InventoryStock  → inventory_stock
Supplier        → suppliers
```

## Performance Considerations

### Lazy Loading
- All relationships are LAZY by default
- Prevents N+1 query problems
- Use JOIN FETCH in queries when needed

### Indexing
Ensure database indexes on:
- Primary keys (automatic)
- Foreign keys
- Frequently queried columns (e.g., licenseNumber, nationalId)
- Date columns used in range queries

### Projection Pattern
For read-only operations, consider using projections:
```java
// Instead of loading full entity
Doctor doctor = repository.findById(id);

// Use projection
DoctorNameProjection projection = repository.findNameById(id);

interface DoctorNameProjection {
    Long getId();
    String getFullName();
    String getSpecialty();
}
```

## Security Considerations

### Sensitive Data
Mark sensitive fields for special handling:
```java
@Entity
public class Patient {
    // Sensitive - PII
    @Column(name = "national_id")
    private String nationalId;
    
    // Sensitive - PHI (Protected Health Information)
    @Column(name = "medical_notes", columnDefinition = "CLOB")
    private String medicalNotes;
}
```

### Audit Logging
Consider adding change tracking for sensitive entities.

## Migration Path

### Current State
✅ All core entities implemented
✅ JPA annotations properly configured
✅ Lombok reducing boilerplate
✅ Relationships properly mapped

### Future Enhancements
⏳ Add value objects (Address, PhoneNumber, etc.)
⏳ Add enumerations for status fields
⏳ Add audit fields (createdAt, updatedAt, etc.)
⏳ Add validation annotations
⏳ Add domain business logic methods
⏳ Add domain events
⏳ Add soft delete support
⏳ Add versioning/optimistic locking

## Best Practices

1. **Keep Entities Focused** - Single responsibility
2. **Use Lazy Loading** - Avoid eager fetching
3. **Exclude Collections** - From toString and equals
4. **Use Builders** - For complex object creation
5. **Add Business Logic** - When it belongs to the entity
6. **Validate Invariants** - Ensure entity validity
7. **Document Relationships** - Clear comments on mappings
8. **Test Entities** - Unit test business logic

## Resources

- [JPA Specification](https://jakarta.ee/specifications/persistence/)
- [Hibernate Documentation](https://hibernate.org/orm/documentation/)
- [Lombok Documentation](https://projectlombok.org/)
- [Domain-Driven Design](https://www.domainlanguage.com/ddd/)

---
*Last Updated: January 25, 2026*
*Module Version: 0.0.1-SNAPSHOT*

# HospitalERP - Domain Model Documentation

## Domain Overview

The HospitalERP domain model represents the core business entities and their relationships in a hospital management system. The model is designed to handle patient care, medical staff management, appointments, admissions, inventory, and medical records.

## Domain Entities

### 1. Doctor

**Description**: Represents medical practitioners in the hospital.

**Attributes**:
- `id` (Long) - Unique identifier
- `fullName` (String, max 200) - Doctor's full name
- `specialty` (String, max 100) - Medical specialty (e.g., Cardiology, Neurology)
- `licenseNumber` (String, max 50) - Professional medical license number
- `departmentId` (Long) - Foreign key to Department
- `hireDate` (LocalDate) - Employment start date

**Relationships**:
- Many-to-One with `Department` - Each doctor belongs to one department
- One-to-Many with `Appointment` - A doctor can have multiple appointments
- One-to-Many with `Prescription` - A doctor can write multiple prescriptions

**Business Rules**:
- Full name is required
- License number should be unique
- A doctor can only belong to one department at a time
- Specialty should be from a predefined list (future enhancement)

**Database Mapping**:
- Table: `doctors`
- Primary Key: `doctor_id`
- Foreign Key: `department_id` → `departments(department_id)`

---

### 2. Patient

**Description**: Represents individuals receiving medical care.

**Attributes**:
- `id` (Long) - Unique identifier
- `nationalId` (String, max 30) - National identification number
- `fullName` (String, max 200) - Patient's full name
- `dateOfBirth` (LocalDate) - Patient's date of birth
- `gender` (String, max 10) - Gender (Male, Female, Other)
- `phoneNumber` (String, max 30) - Contact phone number
- `email` (String, max 100) - Email address

**Relationships**:
- One-to-Many with `Admission` - A patient can have multiple admissions
- One-to-Many with `Appointment` - A patient can have multiple appointments
- One-to-Many with `MedicalRecord` - A patient has multiple medical records
- One-to-Many with `Prescription` - A patient can receive multiple prescriptions

**Business Rules**:
- Full name is required
- National ID should be unique per patient
- Date of birth must be in the past
- Age calculation: current date - date of birth
- Minor patients (under 18) may require guardian information (future enhancement)

**Database Mapping**:
- Table: `patients`
- Primary Key: `patient_id`
- Unique Constraint: `national_id` (if provided)

---

### 3. Department

**Description**: Represents hospital departments/divisions.

**Attributes**:
- `id` (Long) - Unique identifier
- `departmentName` (String, max 100) - Name of the department
- `floorNumber` (Integer) - Physical location in hospital

**Relationships**:
- One-to-Many with `Doctor` - A department has multiple doctors
- One-to-Many with `Nurse` - A department has multiple nurses

**Business Rules**:
- Department name is required and should be unique
- Floor number should be positive
- Each department must have at least one head (future enhancement)

**Database Mapping**:
- Table: `departments`
- Primary Key: `department_id`

**Common Departments**:
- Emergency
- Cardiology
- Neurology
- Pediatrics
- Surgery
- Radiology
- Laboratory

---

### 4. Nurse

**Description**: Represents nursing staff in the hospital.

**Attributes**:
- `id` (Long) - Unique identifier
- `fullName` (String, max 200) - Nurse's full name
- `licenseNumber` (String, max 50) - Professional nursing license
- `departmentId` (Long) - Foreign key to Department
- `hireDate` (LocalDate) - Employment start date

**Relationships**:
- Many-to-One with `Department` - Each nurse belongs to one department

**Business Rules**:
- Full name is required
- License number should be unique
- Nurses can be reassigned to different departments

**Database Mapping**:
- Table: `nurses`
- Primary Key: `nurse_id`
- Foreign Key: `department_id` → `departments(department_id)`

---

### 5. Appointment

**Description**: Represents scheduled meetings between patients and doctors.

**Attributes**:
- `id` (Long) - Unique identifier
- `patientId` (Long) - Foreign key to Patient
- `doctorId` (Long) - Foreign key to Doctor
- `appointmentDate` (LocalDate) - Scheduled date of appointment
- `status` (String, max 30) - Appointment status

**Relationships**:
- Many-to-One with `Patient` - Each appointment is for one patient
- Many-to-One with `Doctor` - Each appointment is with one doctor

**Business Rules**:
- Patient and doctor are required
- Appointment date must be in the future (for new appointments)
- Cannot double-book a doctor at the same time
- Status transitions: SCHEDULED → CONFIRMED → COMPLETED or CANCELLED

**Status Values**:
- `SCHEDULED` - Initial state
- `CONFIRMED` - Patient confirmed attendance
- `COMPLETED` - Appointment finished
- `CANCELLED` - Cancelled by patient or doctor
- `NO_SHOW` - Patient didn't show up

**Database Mapping**:
- Table: `appointments`
- Primary Key: `appointment_id`
- Foreign Keys:
  - `patient_id` → `patients(patient_id)`
  - `doctor_id` → `doctors(doctor_id)`

---

### 6. Admission

**Description**: Represents a patient's hospital stay.

**Attributes**:
- `id` (Long) - Unique identifier
- `patientId` (Long) - Foreign key to Patient
- `roomId` (Long) - Foreign key to Room
- `admissionDate` (LocalDate) - Date of admission
- `dischargeDate` (LocalDate) - Date of discharge (null if still admitted)

**Relationships**:
- Many-to-One with `Patient` - Each admission is for one patient
- Many-to-One with `Room` - Each admission is assigned to one room

**Business Rules**:
- Patient is required
- Admission date is required
- Discharge date must be after admission date
- A patient cannot have overlapping admissions
- Room must be available for the admission period

**Database Mapping**:
- Table: `admissions`
- Primary Key: `admission_id`
- Foreign Keys:
  - `patient_id` → `patients(patient_id)`
  - `room_id` → `rooms(room_id)`

**Calculated Properties**:
- Length of stay: discharge_date - admission_date (or current_date if not discharged)
- Is current admission: discharge_date is null

---

### 7. Room

**Description**: Represents hospital rooms for patient accommodation.

**Attributes**:
- `id` (Long) - Unique identifier
- `roomNumber` (String, max 20) - Room identifier
- `roomType` (String, max 50) - Type of room
- `floor` (Integer) - Floor number
- `capacity` (Integer) - Maximum occupancy
- `isAvailable` (Boolean) - Current availability status

**Relationships**:
- One-to-Many with `Admission` - A room can have multiple admissions over time

**Business Rules**:
- Room number must be unique
- Capacity must be positive
- Cannot admit more patients than room capacity
- Availability updates automatically based on admissions

**Room Types**:
- `GENERAL` - Standard ward room
- `PRIVATE` - Single patient room
- `ICU` - Intensive Care Unit
- `EMERGENCY` - Emergency room
- `OPERATING` - Operating theater

**Database Mapping**:
- Table: `rooms`
- Primary Key: `room_id`
- Unique Constraint: `room_number`

---

### 8. Prescription

**Description**: Represents medical prescriptions issued by doctors to patients.

**Attributes**:
- `id` (Long) - Unique identifier
- `patientId` (Long) - Foreign key to Patient
- `doctorId` (Long) - Foreign key to Doctor
- `medicationName` (String, max 200) - Name of prescribed medication
- `dosage` (String, max 100) - Dosage instructions
- `prescriptionDate` (LocalDate) - Date prescription was issued
- `expiryDate` (LocalDate) - Prescription expiration date

**Relationships**:
- Many-to-One with `Patient` - Each prescription is for one patient
- Many-to-One with `Doctor` - Each prescription is issued by one doctor

**Business Rules**:
- Patient, doctor, and medication name are required
- Prescription date cannot be in the future
- Expiry date must be after prescription date
- Typical validity: 30-90 days depending on medication

**Database Mapping**:
- Table: `prescriptions`
- Primary Key: `prescription_id`
- Foreign Keys:
  - `patient_id` → `patients(patient_id)`
  - `doctor_id` → `doctors(doctor_id)`

---

### 9. MedicalRecord

**Description**: Stores patient medical history and visit records.

**Attributes**:
- `id` (Long) - Unique identifier
- `patientId` (Long) - Foreign key to Patient
- `recordDate` (LocalDate) - Date of medical record
- `diagnosis` (String) - Medical diagnosis (CLOB)
- `treatment` (String) - Treatment provided (CLOB)
- `notes` (String) - Additional notes (CLOB)

**Relationships**:
- Many-to-One with `Patient` - Each record belongs to one patient

**Business Rules**:
- Patient is required
- Record date is required
- Records are immutable once created (audit trail)
- Diagnosis should follow ICD-10 codes (future enhancement)

**Database Mapping**:
- Table: `medical_records`
- Primary Key: `record_id`
- Foreign Key: `patient_id` → `patients(patient_id)`

**Security Considerations**:
- Highly sensitive data - requires encryption
- Access should be role-based
- Audit all access to medical records

---

### 10. InventoryItem

**Description**: Represents medical supplies and equipment in the hospital.

**Attributes**:
- `id` (Long) - Unique identifier
- `itemName` (String, max 200) - Name of the item
- `itemCategory` (String, max 100) - Category classification
- `unitOfMeasure` (String, max 50) - Unit for measurement (e.g., pieces, boxes, liters)
- `reorderLevel` (Integer) - Minimum stock level triggering reorder

**Relationships**:
- One-to-Many with `InventoryStock` - An item can have multiple stock entries

**Business Rules**:
- Item name is required
- Reorder level should be positive
- Alert when stock falls below reorder level

**Item Categories**:
- `MEDICATION` - Pharmaceutical drugs
- `SURGICAL` - Surgical instruments and supplies
- `DIAGNOSTIC` - Diagnostic equipment and consumables
- `PROTECTIVE` - PPE and protective equipment
- `CONSUMABLE` - General medical consumables

**Database Mapping**:
- Table: `inventory_items`
- Primary Key: `item_id`

---

### 11. InventoryStock

**Description**: Tracks current stock levels for inventory items.

**Attributes**:
- `id` (Long) - Unique identifier
- `itemId` (Long) - Foreign key to InventoryItem
- `supplierId` (Long) - Foreign key to Supplier
- `quantity` (Integer) - Current quantity in stock
- `unitPrice` (Decimal) - Price per unit
- `expiryDate` (LocalDate) - Expiration date (for perishable items)

**Relationships**:
- Many-to-One with `InventoryItem` - Each stock entry is for one item
- Many-to-One with `Supplier` - Each stock entry comes from one supplier

**Business Rules**:
- Item is required
- Quantity cannot be negative
- Alert on items approaching expiry date
- FIFO (First In, First Out) for stock consumption

**Database Mapping**:
- Table: `inventory_stock`
- Primary Key: `stock_id`
- Foreign Keys:
  - `item_id` → `inventory_items(item_id)`
  - `supplier_id` → `suppliers(supplier_id)`

---

### 12. Supplier

**Description**: Represents vendors who supply medical items to the hospital.

**Attributes**:
- `id` (Long) - Unique identifier
- `supplierName` (String, max 200) - Name of the supplier
- `contactPerson` (String, max 100) - Primary contact person
- `phoneNumber` (String, max 30) - Contact phone
- `email` (String, max 100) - Contact email
- `address` (String, max 500) - Supplier address

**Relationships**:
- One-to-Many with `InventoryStock` - A supplier can supply multiple items

**Business Rules**:
- Supplier name is required
- Contact information should be validated
- Maintain supplier rating/performance metrics (future enhancement)

**Database Mapping**:
- Table: `suppliers`
- Primary Key: `supplier_id`

---

## Domain Relationships Diagram

```
┌──────────────┐
│  Department  │
└──────┬───────┘
       │
       │ 1:N
       ├─────────────┐
       │             │
┌──────▼────┐   ┌───▼────┐
│  Doctor   │   │ Nurse  │
└──────┬────┘   └────────┘
       │
       │ 1:N
       │
┌──────▼────────┐         ┌──────────────┐
│  Appointment  │◄───N:1──┤   Patient    │
└───────────────┘         └──────┬───────┘
                                 │
                          ┌──────┼──────┬─────────┐
                          │      │      │         │
                       1:N│   1:N│   1:N│      1:N│
                          │      │      │         │
                   ┌──────▼──┐ ┌─▼─────▼─────┐ ┌─▼──────────┐
                   │Admission│ │Prescription │ │MedicalRecord│
                   └────┬────┘ └─────────────┘ └────────────┘
                        │
                     N:1│
                        │
                   ┌────▼────┐
                   │  Room   │
                   └─────────┘

┌──────────────┐
│ Supplier     │
└──────┬───────┘
       │
       │ 1:N
       │
┌──────▼─────────┐       ┌──────────────┐
│InventoryStock │◄──N:1─┤InventoryItem │
└────────────────┘       └──────────────┘
```

## Entity Lifecycle States

### Appointment Lifecycle
```
   NEW
    ↓
SCHEDULED ──→ CANCELLED
    ↓
CONFIRMED ──→ NO_SHOW
    ↓
COMPLETED
```

### Admission Lifecycle
```
ADMITTED (discharge_date = null)
    ↓
DISCHARGED (discharge_date set)
```

### Room Status
```
AVAILABLE ←→ OCCUPIED ←→ MAINTENANCE
```

## Common Query Patterns

### By Entity

**Doctors**:
- Find doctors by specialty
- Find doctors in a department
- Find available doctors for a given date
- Find doctor by license number

**Patients**:
- Find patient by national ID
- Find patients by name (fuzzy search)
- Find patients with upcoming appointments
- Find currently admitted patients

**Appointments**:
- Find appointments by doctor and date
- Find appointments by patient
- Find appointments by status
- Find available appointment slots

**Admissions**:
- Find current admissions (discharge_date is null)
- Find admissions by date range
- Find admission history for a patient
- Calculate average length of stay

**Inventory**:
- Find items below reorder level
- Find items expiring soon
- Find stock by supplier
- Calculate total inventory value

## Data Validation Rules

### Common Validations
- **Email**: RFC 5322 format
- **Phone**: International format with country code
- **Dates**: 
  - Past dates: date of birth, hire date
  - Future dates: appointment date, expiry date
  - Date ranges: admission/discharge, prescription validity

### Entity-Specific Validations
- **Doctor/Nurse**: License number format validation
- **Patient**: Age validation (0-150 years)
- **Appointment**: No double-booking, working hours only
- **Admission**: Room capacity not exceeded
- **Prescription**: Dosage format validation
- **Inventory**: Positive quantities and prices

## Security & Privacy

### Sensitive Data (HIPAA/GDPR Compliance)
- Patient personal information
- Medical records
- Prescription information
- Contact details

### Recommended Protections
1. **Encryption at rest** - Database column encryption
2. **Encryption in transit** - HTTPS/TLS
3. **Access control** - Role-based permissions
4. **Audit logging** - Track all access to sensitive data
5. **Data masking** - Mask sensitive fields in logs
6. **Right to erasure** - Support data deletion requests

## Future Enhancements

### Planned Additions
1. **Billing & Insurance** - Billing entity with insurance claims
2. **Laboratory** - Lab tests and results
3. **Imaging** - Radiology studies and reports
4. **Pharmacy** - Medication dispensing tracking
5. **Staff Scheduling** - Doctor and nurse schedules
6. **Emergency Contacts** - Patient emergency contacts
7. **Allergies** - Patient allergy tracking
8. **Vital Signs** - Temperature, blood pressure, etc.
9. **Bed Management** - Detailed bed tracking within rooms
10. **Equipment Tracking** - Medical equipment location and maintenance

### Domain Events (Event-Driven Architecture)
- `PatientAdmitted`
- `PatientDischarged`
- `AppointmentScheduled`
- `AppointmentCancelled`
- `PrescriptionIssued`
- `InventoryLowStock`
- `InventoryItemExpiring`

---

*Last Updated: January 25, 2026*
*Domain Model Version: 1.0*

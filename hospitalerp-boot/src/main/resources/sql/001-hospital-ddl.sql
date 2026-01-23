
-- ================================
-- Hospital Database - DDL
-- Oracle Style (Using Sequences)
-- ================================

-- Sequences
CREATE SEQUENCE seq_patients START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_departments START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_doctors START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_nurses START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_rooms START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_admissions START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_appointments START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_medical_records START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_prescriptions START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_inventory_items START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_inventory_stock START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_suppliers START WITH 1 INCREMENT BY 1 NOCACHE;

-- Tables
CREATE TABLE patients (
    patient_id    NUMBER DEFAULT seq_patients.NEXTVAL PRIMARY KEY,
    national_id   VARCHAR2(30),
    full_name     VARCHAR2(200) NOT NULL,
    date_of_birth DATE,
    gender        VARCHAR2(10),
    phone_number  VARCHAR2(30),
    email         VARCHAR2(100)
);

CREATE TABLE departments (
    department_id   NUMBER DEFAULT seq_departments.NEXTVAL PRIMARY KEY,
    department_name VARCHAR2(100) NOT NULL,
    floor_number    NUMBER
);

CREATE TABLE doctors (
    doctor_id       NUMBER DEFAULT seq_doctors.NEXTVAL PRIMARY KEY,
    full_name       VARCHAR2(200) NOT NULL,
    specialty       VARCHAR2(100),
    license_number  VARCHAR2(50),
    department_id   NUMBER,
    hire_date       DATE,
    CONSTRAINT fk_doctors_department
        FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE nurses (
    nurse_id        NUMBER DEFAULT seq_nurses.NEXTVAL PRIMARY KEY,
    full_name       VARCHAR2(200) NOT NULL,
    department_id   NUMBER,
    shift_type      VARCHAR2(30),
    CONSTRAINT fk_nurses_department
        FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE rooms (
    room_id     NUMBER DEFAULT seq_rooms.NEXTVAL PRIMARY KEY,
    room_number VARCHAR2(20) NOT NULL,
    room_type   VARCHAR2(50),
    capacity    NUMBER
);

CREATE TABLE admissions (
    admission_id   NUMBER DEFAULT seq_admissions.NEXTVAL PRIMARY KEY,
    patient_id     NUMBER NOT NULL,
    room_id        NUMBER,
    admission_date DATE NOT NULL,
    discharge_date DATE,
    CONSTRAINT fk_adm_patient FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    CONSTRAINT fk_adm_room FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

CREATE TABLE appointments (
    appointment_id   NUMBER DEFAULT seq_appointments.NEXTVAL PRIMARY KEY,
    patient_id       NUMBER NOT NULL,
    doctor_id        NUMBER NOT NULL,
    appointment_date DATE NOT NULL,
    status           VARCHAR2(30),
    CONSTRAINT fk_app_patient FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    CONSTRAINT fk_app_doctor FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE medical_records (
    record_id   NUMBER DEFAULT seq_medical_records.NEXTVAL PRIMARY KEY,
    patient_id  NUMBER NOT NULL,
    diagnosis   VARCHAR2(400),
    notes       VARCHAR2(2000),
    created_at  DATE DEFAULT SYSDATE,
    CONSTRAINT fk_mr_patient FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

CREATE TABLE prescriptions (
    prescription_id NUMBER DEFAULT seq_prescriptions.NEXTVAL PRIMARY KEY,
    patient_id      NUMBER NOT NULL,
    doctor_id       NUMBER NOT NULL,
    medication_name VARCHAR2(200),
    dosage          VARCHAR2(100),
    CONSTRAINT fk_pr_patient FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    CONSTRAINT fk_pr_doctor FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE inventory_items (
    item_id         NUMBER DEFAULT seq_inventory_items.NEXTVAL PRIMARY KEY,
    item_name       VARCHAR2(200) NOT NULL,
    item_category   VARCHAR2(100),
    unit_of_measure VARCHAR2(50),
    reorder_level   NUMBER
);

CREATE TABLE inventory_stock (
    stock_id         NUMBER DEFAULT seq_inventory_stock.NEXTVAL PRIMARY KEY,
    item_id          NUMBER NOT NULL,
    location         VARCHAR2(100),
    quantity_on_hand NUMBER,
    expiration_date  DATE,
    CONSTRAINT fk_stock_item FOREIGN KEY (item_id) REFERENCES inventory_items(item_id)
);

CREATE TABLE suppliers (
    supplier_id   NUMBER DEFAULT seq_suppliers.NEXTVAL PRIMARY KEY,
    supplier_name VARCHAR2(200) NOT NULL,
    contact_info  VARCHAR2(300)
);

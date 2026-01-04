
-- ================================
-- Hospital Database - Sample Data
-- ================================

INSERT INTO departments (department_name, floor_number) VALUES ('Cardiology', 2);
INSERT INTO departments (department_name, floor_number) VALUES ('Emergency', 1);
INSERT INTO departments (department_name, floor_number) VALUES ('Neurology', 3);

INSERT INTO patients (national_id, full_name, date_of_birth, gender, phone_number, email)
VALUES ('LU12345', 'John Muller', DATE '1985-04-12', 'M', '621111111', 'john.muller@mail.com');

INSERT INTO patients (national_id, full_name, date_of_birth, gender, phone_number, email)
VALUES ('LU67890', 'Anna Weber', DATE '1990-09-23', 'F', '621222222', 'anna.weber@mail.com');

INSERT INTO doctors (full_name, specialty, license_number, department_id, hire_date)
VALUES ('Dr. Marc Klein', 'Cardiology', 'LIC-001', 1, DATE '2015-06-01');

INSERT INTO doctors (full_name, specialty, license_number, department_id, hire_date)
VALUES ('Dr. Sophie Laurent', 'Neurology', 'LIC-002', 3, DATE '2018-03-15');

INSERT INTO nurses (full_name, department_id, shift_type)
VALUES ('Laura Hoffmann', 2, 'Night');

INSERT INTO rooms (room_number, room_type, capacity)
VALUES ('101A', 'ICU', 1);

INSERT INTO admissions (patient_id, room_id, admission_date)
VALUES (1, 1, SYSDATE);

INSERT INTO appointments (patient_id, doctor_id, appointment_date, status)
VALUES (2, 2, SYSDATE + 1, 'SCHEDULED');

INSERT INTO medical_records (patient_id, diagnosis, notes)
VALUES (1, 'Hypertension', 'Patient responding well to treatment');

INSERT INTO prescriptions (patient_id, doctor_id, medication_name, dosage)
VALUES (1, 1, 'Amlodipine', '5mg once daily');

INSERT INTO inventory_items (item_name, item_category, unit_of_measure, reorder_level)
VALUES ('Surgical Gloves', 'Consumables', 'Box', 20);

INSERT INTO inventory_items (item_name, item_category, unit_of_measure, reorder_level)
VALUES ('Paracetamol', 'Medication', 'Tablet', 500);

INSERT INTO inventory_stock (item_id, location, quantity_on_hand, expiration_date)
VALUES (1, 'Main Storage', 100, DATE '2027-12-31');

INSERT INTO suppliers (supplier_name, contact_info)
VALUES ('MedSupply Europe', 'contact@medsupply.eu');

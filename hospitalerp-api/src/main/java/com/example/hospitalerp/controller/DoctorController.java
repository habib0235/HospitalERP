package com.example.hospitalerp.controller;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
@RequestMapping("/doctors")
public class DoctorController {

    @PersistenceContext
    private EntityManager em;

    // GET /doctors -> return list of full names of all doctors
    @GetMapping
    public List<String> getAllDoctorFullNames() {
        try {
            return em.createQuery("select d.fullName from Doctor d", String.class)
                    .getResultList();
        } catch (Exception ex) {
            // Typical root cause here is datasource auth/availability (e.g., ORA-01017).
            // Return a user-friendly message instead of an unhandled stack trace.
            throw new ResponseStatusException(
                    HttpStatus.SERVICE_UNAVAILABLE,
                    "Database connection failed. Check Oracle credentials/volume and SPRING_DATASOURCE_* settings.",
                    ex
            );
        }
    }
}

package com.example.hospitalerp.controller;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/doctors")
public class DoctorController {

    @PersistenceContext
    private EntityManager em;

    // GET /doctors -> return list of full names of all doctors
    @GetMapping
    public List<String> getAllDoctorFullNames() {
        return em.createQuery("select d.fullName from Doctor d", String.class)
                .getResultList();
    }
}

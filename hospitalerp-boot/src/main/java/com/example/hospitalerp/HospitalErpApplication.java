package com.example.hospitalerp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackages = {
        "com.example.hospitalerp",
        "com.example.hospitalerp.controller"
})
public class HospitalErpApplication {

    public static void main(String[] args) {
        SpringApplication.run(HospitalErpApplication.class, args);
    }

}


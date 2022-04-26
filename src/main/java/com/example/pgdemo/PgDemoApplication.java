package com.example.pgdemo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication
public class PgDemoApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(PgDemoApplication.class, args);
    }

    @Override protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        return builder.sources(PgDemoApplication.class);
    }
}

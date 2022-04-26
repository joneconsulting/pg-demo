package com.example.pgdemo.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class MvcConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("http://localhost:21000", "http://127.0.0.1:21000",
                        "https://xpayvvipclient.tosspayments.com/", "https://pretestclient.tosspayments.com:9443/")
                .allowedMethods("POST", "PUT", "GET", "DELETE", "OPTIONS")
                .maxAge(3600);
    }
}

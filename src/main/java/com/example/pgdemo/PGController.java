package com.example.pgdemo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@CrossOrigin("*")
@Controller
public class PGController {
    OracleDemo oracleDemo;

    @Autowired
    public PGController(OracleDemo oracleDemo) {
        this.oracleDemo = oracleDemo;
    }

//    @GetMapping("/welcome.do")
//    public String request() {
//        return "welcome";
//    }

    @GetMapping("/sample_crossplatform.do")
    public String sampleCrossplatform() {
        return "sample_crossplatform";
    }

    @PostMapping("/payreq_crossplatform.do")
    public String payreqCrossplatform() {
        return "payreq_crossplatform";
    }

    @PostMapping("/returnurl.do")
    public String returnurl() {
        return "returnurl";
    }

    @PostMapping("/payres.do")
    public String payres() {
        return "payres";
    }
}

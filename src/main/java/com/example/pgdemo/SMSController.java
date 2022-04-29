package com.example.pgdemo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@CrossOrigin("*")
@RestController
public class SMSController {
    OracleDemo oracleDemo;

    @Autowired
    public SMSController(OracleDemo oracleDemo) {
        this.oracleDemo = oracleDemo;
    }

    @GetMapping("/read.do")
    public List<String> read() {
        List<String> result = oracleDemo.readData();

        return result;
    }

    @GetMapping("/add.do")
    public String add() {
        boolean result1 = oracleDemo.addData();

        return result1 ? "추가 성공" : "추가 실패";
    }
}

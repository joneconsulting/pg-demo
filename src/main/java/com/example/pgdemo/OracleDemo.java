package com.example.pgdemo;

import org.springframework.stereotype.Service;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

@Service
public class OracleDemo {
    public String connectOracle() {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            System.out.print("드라이버 검색 성공");
        } catch (ClassNotFoundException e) {
            System.err.println("드라이버 검색 실패");
            e.printStackTrace();
        }

        //데이터베이스 연결 - 커넥션 만들기
        String msg = null;
        Connection conn = null;
        try {
            conn = DriverManager.getConnection( "jdbc:oracle:thin:@211.241.36.16:1521:mono_solutions" ,
                    "mono_customer", "mono_customer" );
            msg = "데이터베이스 연결 성공";
        } catch (SQLException e) {
            System.err.println("데이터베이스 연결 실패");
            e.printStackTrace();
        }

        try {
            if(conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            e.printStackTrace();
        }

        return msg;
    }
}

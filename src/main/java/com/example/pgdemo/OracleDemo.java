package com.example.pgdemo;

import org.springframework.stereotype.Service;

import java.sql.*;

@Service
public class OracleDemo {
    public String connectOracle() {
        try {
            Class.forName("oracle.jdbc.OracleDriver");
            System.out.print("드라이버 검색 성공\n");
        } catch (ClassNotFoundException e) {
            System.err.println("드라이버 검색 실패\n");
            e.printStackTrace();
        }

        //데이터베이스 연결 - 커넥션 만들기
        String msg = null;
        Connection conn = null;
        try {
            conn = DriverManager.getConnection( "jdbc:oracle:thin:@211.241.36.16:1521:ora11" ,
                    "mono_customer", "mono_customer" );
            System.out.print(conn);

            ResultSet rs = conn.getMetaData().getTables(null, "MONO_CUSTOMER",
                    null, new String[]{"TABLE"});
            while(rs.next()) {
                String table = rs.getString("TABLE_NAME");
                System.out.println("Table Name : " + table);
            }

//            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM CUSTOMER_SMS_SEND");
//            ResultSet rs = pstmt.executeQuery();
//            System.out.println("<<<<<<<<<<<<<<<<");
//            while (rs.next()) {
//                StringBuilder sb = new StringBuilder();
//                sb.append("ID=" + rs.getString("ID"));
//                sb.append("USER_ID=" + rs.getString("USER_ID"));
//                sb.append("TITLE=" + rs.getString("TITLE"));
//                sb.append("CALLING_NUM=" + rs.getString("CALLING_NUM"));
//                sb.append("PHONE_NUM=" + rs.getString("PHONE_NUM"));
//                System.out.println(sb.toString());
//            }
//            System.out.println(">>>>>>>>>>>>>>>>");

            msg = "데이터베이스 연결 성공\n";
        } catch (SQLException e) {
            System.err.println("데이터베이스 연결 실패\n");
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

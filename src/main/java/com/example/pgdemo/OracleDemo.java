package com.example.pgdemo;

import org.springframework.stereotype.Service;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Service
public class OracleDemo {
    Connection conn;

    private Connection getConnection() {
        try {
            Class.forName("oracle.jdbc.OracleDriver");
            System.out.print("드라이버 검색 성공\n");
        } catch (ClassNotFoundException e) {
            System.err.println("드라이버 검색 실패\n");
            e.printStackTrace();
        }

        //데이터베이스 연결 - 커넥션 만들기
        Connection conn = null;
        try {
            conn = DriverManager.getConnection("jdbc:oracle:thin:@211.241.36.16:1521:ora11",
                    "mono_customer", "mono_customer");
//            System.out.print(conn);
//
//            ResultSet rs = conn.getMetaData().getTables(null, "MONO_SOLUTIONS",
//                    null, new String[]{"TABLE"});
//            while (rs.next()) {
//                String table = rs.getString("TABLE_NAME");
//                System.out.println("Table Name : " + table);
//            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return conn;
    }

    private void closeConnection(Connection conn) {
        try {
            if(conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            e.printStackTrace();
        }
    }

    public List<String> readData() {
        List<String> list = new ArrayList<>();
        Connection conn = getConnection();
        try {
            PreparedStatement pstmt = conn.prepareStatement(
                    "SELECT * FROM MONO_SOLUTIONS.CUSTOMER_SMS_SEND WHERE PHONE_NUM='01034912327'");
            ResultSet rs2 = pstmt.executeQuery();
//            ResultSetMetaData rsmd = rs2.getMetaData();
//            int cnt = rsmd.getColumnCount();
//            for (int i = 1; i <= cnt; i++) {
//                System.out.println(rsmd.getColumnLabel(i));
//            }
            System.out.println("[[");
            while (rs2.next()) {
                StringBuilder sb = new StringBuilder();
                sb.append("ID=" + rs2.getString("ID"));
                sb.append(", USER_ID=" + rs2.getString("USER_ID"));
                sb.append(", TITLE=" + rs2.getString("TITLE"));
                sb.append(", CALLING_NUM=" + rs2.getString("CALLING_NUM"));
                sb.append(", PHONE_NUM=" + rs2.getString("PHONE_NUM"));
                sb.append(", REG_DTTM=" + rs2.getString("REG_DTTM"));
                sb.append(", STATE_CD=" + rs2.getString("STATE_CD"));
                sb.append(", RESULT_MSG=" + rs2.getString("RESULT_MSG"));

                System.out.println(sb);
                list.add(sb.toString());
            }
            System.out.println("]]");
        } catch (SQLException e) {
            e.printStackTrace();
        }

        closeConnection(conn);

        return list;
    }

    public boolean addData() {
        String msg = null;
        Connection conn = getConnection();
        try {
            String sql = "INSERT INTO MONO_SOLUTIONS.CUSTOMER_SMS_SEND (ID, USER_ID, SCHEDULE_TYPE, " +
                        "TITLE, MSG_CONTENT, CALLING_NUM, TGT_NM, PHONE_NUM, " +
                        "RESERV_DTTM, REG_DTTM) " +
                        "VALUES (MONO_SOLUTIONS.CUSTOMER_SMS_SEND_SEQ.NEXTVAL,'volunteer','0',?,?,?,?,?,NULL," +
                        "TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'))";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, new String("[외부전송]SMS")); // [외부전송]SMS
            pstmt.setString(2, "외부시스템 SMS전송테스트 입니다."); // 외부시스템 SMS전송테스트 입니다.
            pstmt.setString(3, "0221556100"); // 021112222
            pstmt.setString(4, "이도원"); // 홍길동
            pstmt.setString(5, "01034912327"); // 01011112222

            int result = pstmt.executeUpdate();

            return result > 0 ? true : false;
        } catch (SQLException e) {
            System.err.println("데이터 추가 실패\n");
            e.printStackTrace();
            return false;
        } finally {
            closeConnection(conn);
        }
    }
}

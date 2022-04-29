package com.example.pgdemo;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.http.HttpMethod;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

public class HttpUtil {

    public static void callApi(){

        HttpURLConnection conn = null;
        JSONObject responseJson = null;

        try {
            //URL 설정
            URL url = new URL("http://192.168.0.13:8088/api/v1/payment/cancel");

            conn = (HttpURLConnection) url.openConnection();

            // type의 경우 POST, GET, PUT, DELETE 가능
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Transfer-Encoding", "chunked");
            conn.setRequestProperty("Connection", "keep-alive");
            conn.setDoOutput(true);


            BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
            // JSON 형식의 데이터 셋팅
            JsonObject params = new JsonObject();
            JsonArray jsonArray = new JsonArray();

            params.addProperty("token", "rpTGMRQBNdL8UmCXWADKXbeo5zdl1UYGXepzlChM7mgDTw0/5TiGOPyfxMbR33nwM79naQ==");
            params.addProperty("lgd_mid", "tscscd02");
            params.addProperty("lgd_tid", "tscsc2022042802323090138");
            params.addProperty("lgd_buyerid", "12345");
            params.addProperty("cancel_lgd_respcode", "0001");
            params.addProperty("cancel_lgd_respmsg", "정상취소2");

//            commands.add("userInfo", params);
            // JSON 형식의 데이터 셋팅 끝

            // 데이터를 STRING으로 변경
            Gson gson = new GsonBuilder().setPrettyPrinting().create();
            String jsonOutput = gson.toJson(params);

            bw.write(params.toString());
            bw.flush();
            bw.close();

            // 보내고 결과값 받기
            int responseCode = conn.getResponseCode();
            if (responseCode == 200) {
                BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                StringBuilder sb = new StringBuilder();
                String line = "";
                while ((line = br.readLine()) != null) {
                    sb.append(line);
                }
                responseJson = new JSONObject(sb.toString());

                // 응답 데이터
                System.out.println("responseJson :: " + responseJson);
            }
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (JSONException e) {
            System.out.println("not JSON Format response");
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        callApi();
    }
}


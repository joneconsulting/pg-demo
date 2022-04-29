<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ page import="java.io.*" %>
<%@ page import="lgdacom.XPayClient.XPayClient"%>

<%
request.setCharacterEncoding("euc-kr");
    /*
     * [최종결제요청 페이지(STEP2-2)]
	 *
     * 매뉴얼 "5.1. XPay 결제 요청 페이지 개발"의 "단계 5. 최종 결제 요청 및 요청 결과 처리" 참조
	 *
     * 토스페이먼츠으로 부터 내려받은 LGD_PAYKEY(인증Key)를 가지고 최종 결제요청.(파라미터 전달시 POST를 사용하세요)
     */

	/* ※ 중요
	* 환경설정 파일의 경우 반드시 외부에서 접근이 가능한 경로에 두시면 안됩니다.
	* 해당 환경파일이 외부에 노출이 되는 경우 해킹의 위험이 존재하므로 반드시 외부에서 접근이 불가능한 경로에 두시기 바랍니다. 
	* 예) [Window 계열] C:\inetpub\wwwroot\lgdacom ==> 절대불가(웹 디렉토리)
	*/
//    String configPath = "C:/lgdacom";  //토스페이먼츠에서 제공한 환경파일("/conf/lgdacom.conf,/conf/mall.conf") 위치 지정.
	File f = new File(request.getContextPath());
	String configPath = f.getAbsoluteFile() + "/src/main/webapp/WEB-INF/jsp/lgdacom/";
	System.out.println(configPath);

    /*
     *************************************************
     * 1.최종결제 요청 - BEGIN
     *  (단, 최종 금액체크를 원하시는 경우 금액체크 부분 주석을 제거 하시면 됩니다.)
     *************************************************
     */
    
    String CST_PLATFORM                 = request.getParameter("CST_PLATFORM");
    String CST_MID                      = request.getParameter("CST_MID");
    String LGD_MID                      = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;
    String LGD_PAYKEY                   = request.getParameter("LGD_PAYKEY");

    //해당 API를 사용하기 위해 WEB-INF/lib/XPayClient.jar 를 Classpath 로 등록하셔야 합니다.
	// (1) XpayClient의 사용을 위한 xpay 객체 생성
    XPayClient xpay = new XPayClient();

	// (2) Init: XPayClient 초기화(환경설정 파일 로드) 
	// configPath: 설정파일
	// CST_PLATFORM: - test, service 값에 따라 lgdacom.conf의 test_url(test) 또는 url(srvice) 사용
	//				- test, service 값에 따라 테스트용 또는 서비스용 아이디 생성
   	boolean isInitOK = xpay.Init(configPath, CST_PLATFORM);   	

   	if( !isInitOK ) {
    	//API 초기화 실패 화면처리
        out.println( "결제요청을 초기화 하는데 실패하였습니다.<br>");
        out.println( "토스페이먼츠에서 제공한 환경파일이 정상적으로 설치 되었는지 확인하시기 바랍니다.<br>");        
        out.println( "mall.conf에는 Mert ID = Mert Key 가 반드시 등록되어 있어야 합니다.<br><br>");
        out.println( "문의전화 토스페이먼츠 1544-7772<br>");
        return;
   	
   	}else{      
   		try{
   			
			// (3) Init_TX: 메모리에 mall.conf, lgdacom.conf 할당 및 트랜잭션의 고유한 키 TXID 생성
	    	xpay.Init_TX(LGD_MID);
	    	xpay.Set("LGD_TXNAME", "PaymentByKey");
	    	xpay.Set("LGD_PAYKEY", LGD_PAYKEY);
	    
	    	//금액을 체크하시기 원하는 경우 아래 주석을 풀어서 이용하십시요.
	    	//String DB_AMOUNT = "DB나 세션에서 가져온 금액"; //반드시 위변조가 불가능한 곳(DB나 세션)에서 금액을 가져오십시요.
	    	//xpay.Set("LGD_AMOUNTCHECKYN", "Y");
	    	//xpay.Set("LGD_AMOUNT", DB_AMOUNT);
	    
    	}catch(Exception e) {
    		out.println("토스페이먼츠 제공 API를 사용할 수 없습니다. 환경파일 설정을 확인해 주시기 바랍니다. ");
    		out.println(""+e.getMessage());    	
    		return;
    	}
   	}
	/*
	 *************************************************
	 * 1.최종결제 요청(수정하지 마세요) - END
	 *************************************************
	 */

    /*
     * 2. 최종결제 요청 결과처리
     *
     * 최종 결제요청 결과 리턴 파라미터는 연동메뉴얼을 참고하시기 바랍니다.
     */
	 // (4) TX: lgdacom.conf에 설정된 URL로 소켓 통신하여 최종 인증요청, 결과값으로 true, false 리턴
     if ( xpay.TX() ) {
         //1)결제결과 화면처리(성공,실패 결과 처리를 하시기 바랍니다.)
         out.println( "결제요청이 완료되었습니다.  <br>");
		 out.println( "TX 결제요청 통신 응답코드 = " + xpay.m_szResCode + "<br>");					//통신 응답코드("0000" 일 때 통신 성공)
         out.println( "TX 결제요청 통신 응답메시지 = " + xpay.m_szResMsg + "<p>");					//통신 응답메시지
        
         
         out.println("거래번호 : " + xpay.Response("LGD_TID",0) + "<br>");
         out.println("상점아이디 : " + xpay.Response("LGD_MID",0) + "<br>");
         out.println("상점주문번호 : " + xpay.Response("LGD_OID",0) + "<br>");
         out.println("결제금액 : " + xpay.Response("LGD_AMOUNT",0) + "<br>");
         out.println("결과코드 : " + xpay.Response("LGD_RESPCODE",0) + "<br>");						//LGD_RESPCODE 가 반드시 "0000" 일때만 결제 성공, 그 외는 모두 실패
         out.println("결과메세지 : " + xpay.Response("LGD_RESPMSG",0) + "<p>");
         
         for (int i = 0; i < xpay.ResponseNameCount(); i++)
         {
             out.println(xpay.ResponseName(i) + " = ");
             for (int j = 0; j < xpay.ResponseCount(); j++)
             {
                 out.println("\t" + xpay.Response(xpay.ResponseName(i), j) + "<br>");
             }
         }
         out.println("<p>");
         

		 // (5) DB에 인증요청 결과 처리
         if( "0000".equals( xpay.m_szResCode ) ) {
         	// 통신상의 문제가 없을시
			// 최종결제요청 결과 성공 DB처리(LGD_RESPCODE 값에 따라 결제가 성공인지, 실패인지 DB처리)
         	out.println("최종결제요청 성공, DB처리하시기 바랍니다.<br>");
         	            	
         	//최종결제요청 결과를 DB처리합니다. (결제성공 또는 실패 모두 DB처리 가능)

			//상점내 DB에 어떠한 이유로 처리를 하지 못한경우 false로 변경해 주세요.
         	boolean isDBOK = true; 
         	if( !isDBOK ) {
				 
         		xpay.Rollback("상점 DB처리 실패로 인하여 Rollback 처리 [TID:" +xpay.Response("LGD_TID",0)+",MID:" + xpay.Response("LGD_MID",0)+",OID:"+xpay.Response("LGD_OID",0)+"]");
         		
				out.println( "TX Rollback Response_code = " + xpay.Response("LGD_RESPCODE",0) + "<br>");
				out.println( "TX Rollback Response_msg = " + xpay.Response("LGD_RESPMSG",0) + "<p>");
         		
				if( "0000".equals( xpay.m_szResCode ) ) { 
					out.println("자동취소가 정상적으로 완료 되었습니다.<br>");
				}else{
					out.println("자동취소가 정상적으로 처리되지 않았습니다.<br>");
				}
         	}
         	
         }else{
			//통신상의 문제 발생(최종결제요청 결과 실패 DB처리)
			out.println("최종결제요청 결과 실패, DB처리하시기 바랍니다.<br>");            	
         }
     }else {
         //2)API 요청실패 화면처리
         out.println( "결제요청이 실패하였습니다.  <br>");
         out.println( "TX 결제요청 Response_code = " + xpay.m_szResCode + "<br>");
         out.println( "TX 결제요청 Response_msg = " + xpay.m_szResMsg + "<p>");
         
     	//최종결제요청 결과 실패 DB처리
     	out.println("최종결제요청 결과 실패 DB처리하시기 바랍니다.<br>");            	            
     }
%>

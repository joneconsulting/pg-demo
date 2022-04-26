<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ page import="lgdacom.XPayClient.XPayClient"%>

<%
    /*
     * [현금영수증 발급요청 페이지]
     *
     * 토스페이먼츠으로 부터 내려받은 거래번호(LGD_TID)를 가지고 취소 요청을 합니다.(파라미터 전달시 POST를 사용하세요)
     * (승인시 토스페이먼츠으로 부터 내려받은 PAYKEY와 혼동하지 마세요.)
     */
    String CST_PLATFORM           = request.getParameter("CST_PLATFORM");                 //토스페이먼츠 결제서비스 선택(test:테스트, service:서비스)
    String CST_MID                = request.getParameter("CST_MID");                      //토스페이먼츠으로 부터 발급받으신 상점아이디를 입력하세요.
    String LGD_MID                = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;  //테스트 아이디는 't'를 제외하고 입력하세요.
                                                                                          //상점아이디(자동생성)
    String LGD_METHOD   		  = request.getParameter("LGD_METHOD");                   //메소드('AUTH':승인, 'CANCEL' 취소)
    String LGD_OID                = request.getParameter("LGD_OID");					  //주문번호(상점정의 유니크한 주문번호를 입력하세요)
    String LGD_PAYTYPE            = request.getParameter("LGD_PAYTYPE");				  //결제수단 코드 (SC0030:계좌이체, SC0040:가상계좌, SC0100:무통장입금 단독)
    String LGD_AMOUNT     		  = request.getParameter("LGD_AMOUNT");             	  //금액("," 를 제외한 금액을 입력하세요)
    String LGD_CASHCARDNUM        = request.getParameter("LGD_CASHCARDNUM");              //발급번호(주민등록번호,현금영수증카드번호,휴대폰번호 등등)
    String LGD_CUSTOM_MERTNAME    = request.getParameter("LGD_CUSTOM_MERTNAME");       	  //상점명
    String LGD_CUSTOM_BUSINESSNUM = request.getParameter("LGD_CUSTOM_BUSINESSNUM");       //사업자등록번호
    String LGD_CUSTOM_MERTPHONE   = request.getParameter("LGD_CUSTOM_MERTPHONE");         //상점 전화번호
    String LGD_CASHRECEIPTUSE     = request.getParameter("LGD_CASHRECEIPTUSE");			  //현금영수증발급용도('1':소득공제, '2':지출증빙)
    String LGD_PRODUCTINFO        = request.getParameter("LGD_PRODUCTINFO");			  //상품명
    String LGD_TID                = request.getParameter("LGD_TID");			  		  //토스페이먼츠 거래번호 (취소시만 사용) 

    /* ※ 중요
	* 환경설정 파일의 경우 반드시 외부에서 접근이 가능한 경로에 두시면 안됩니다.
	* 해당 환경파일이 외부에 노출이 되는 경우 해킹의 위험이 존재하므로 반드시 외부에서 접근이 불가능한 경로에 두시기 바랍니다. 
	* 예) [Window 계열] C:\inetpub\wwwroot\lgdacom ==> 절대불가(웹 디렉토리)
	*/
	
    String configPath 			  = "C:/lgdacom";  										  //토스페이먼츠에서 제공한 환경파일("/conf/lgdacom.conf") 위치 지정.
        
    LGD_METHOD       		= ( LGD_METHOD == null )?"":LGD_METHOD;
    LGD_OID       		    = ( LGD_OID == null )?"":LGD_OID;
    LGD_PAYTYPE       		= ( LGD_PAYTYPE == null )?"":LGD_PAYTYPE;
    LGD_AMOUNT   		    = ( LGD_AMOUNT == null )?"":LGD_AMOUNT;
    LGD_CASHCARDNUM         = ( LGD_CASHCARDNUM == null )?"":LGD_CASHCARDNUM;
    LGD_CUSTOM_MERTNAME  	= ( LGD_CUSTOM_MERTNAME == null )?"":LGD_CUSTOM_MERTNAME;
    LGD_CUSTOM_BUSINESSNUM  = ( LGD_CUSTOM_BUSINESSNUM == null )?"":LGD_CUSTOM_BUSINESSNUM;
    LGD_CUSTOM_MERTPHONE  	= ( LGD_CUSTOM_MERTPHONE == null )?"":LGD_CUSTOM_MERTPHONE;
    LGD_CASHRECEIPTUSE      = ( LGD_CASHRECEIPTUSE == null )?"":LGD_CASHRECEIPTUSE;
    LGD_PRODUCTINFO         = ( LGD_PRODUCTINFO == null )?"":LGD_PRODUCTINFO;
    LGD_TID         		= ( LGD_TID == null )?"":LGD_TID;
    
    XPayClient xpay = new XPayClient();
    xpay.Init(configPath, CST_PLATFORM);
    xpay.Init_TX(LGD_MID);
    xpay.Set("LGD_TXNAME", "CashReceipt");
    xpay.Set("LGD_METHOD", LGD_METHOD);
    xpay.Set("LGD_PAYTYPE", LGD_PAYTYPE);
    
    if (LGD_METHOD.equals("AUTH")){    // 현금영수증 발급 요청 
    	xpay.Set("LGD_OID", LGD_OID);
    	xpay.Set("LGD_CUSTOM_MERTNAME", LGD_CUSTOM_MERTNAME);
     	xpay.Set("LGD_CUSTOM_BUSINESSNUM", LGD_CUSTOM_BUSINESSNUM);
    	xpay.Set("LGD_CUSTOM_MERTPHONE", LGD_CUSTOM_MERTPHONE);
    	xpay.Set("LGD_CASHCARDNUM", LGD_CASHCARDNUM);
		xpay.Set("LGD_AMOUNT", LGD_AMOUNT);
    	xpay.Set("LGD_CASHRECEIPTUSE", LGD_CASHRECEIPTUSE);
    	
    	if (LGD_PAYTYPE.equals("SC0030")){  //기결제된 계좌이체건 현금영수증 발급요청시 필수  
    		xpay.Set("LGD_TID", LGD_TID);
    	}
    	else if (LGD_PAYTYPE.equals("SC0040")){  //기결제된 가상계좌건 현금영수증 발급요청시 필수  
    		xpay.Set("LGD_TID", LGD_TID);
    		xpay.Set("LGD_SEQNO", "001");
    	}
    	else {  								//무통장입금 단독건 발급요청  
    		xpay.Set("LGD_PRODUCTINFO", LGD_PRODUCTINFO);
        }
    }else{								// 현금영수증 취소 요청 
    	xpay.Set("LGD_TID", LGD_TID);

    	if (LGD_PAYTYPE.equals("SC0040")){  //가상계좌건 현금영수증 발급취소시 필수  
			xpay.Set("LGD_SEQNO", "001");

    	}
    }
    
    /*
     * 1. 현금영수증 발급/취소 요청 결과처리
     *
     * 결과 리턴 파라미터는 연동메뉴얼을 참고하시기 바랍니다.
     */
    if (xpay.TX()) {
        //1)현금영수증 발급/취소결과 화면처리(성공,실패 결과 처리를 하시기 바랍니다.)
        out.println("현금영수증 발급/취소 요청처리가 완료되었습니다.  <br>");
        out.println( "TX Response_code = " + xpay.m_szResCode + "<br>");
        out.println( "TX Response_msg = " + xpay.m_szResMsg + "<p>");
        
        out.println("거래번호 : " + xpay.Response("LGD_TID",0) + "<br>");
        out.println("결과코드 : " + xpay.Response("LGD_RESPCODE",0) + "<br>");
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
        
    }else {
        //2)API 요청 실패 화면처리
        out.println("현금영수증 발급/취소 요청처리가 실패되었습니다.  <br>");
        out.println( "TX Response_code = " + xpay.m_szResCode + "<br>");
        out.println( "TX Response_msg = " + xpay.m_szResMsg + "<p>");
    }
%>

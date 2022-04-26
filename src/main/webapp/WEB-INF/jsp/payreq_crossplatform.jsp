<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.security.MessageDigest, java.util.*, java.io.*" %>
<%@ page import="lgdacom.XPayClient.XPayClient"%>
<%
	request.setCharacterEncoding("euc-kr");
    /*
     * [결제 인증요청 페이지(STEP2-1)]
     *
     * 샘플페이지에서는 기본 파라미터만 예시되어 있으며, 별도로 필요하신 파라미터는 연동메뉴얼을 참고하시어 추가 하시기 바랍니다.
     */

     /* ※ 중요
 	* 환경설정 파일의 경우 반드시 외부에서 접근이 가능한 경로에 두시면 안됩니다.
 	* 해당 환경파일이 외부에 노출이 되는 경우 해킹의 위험이 존재하므로 반드시 외부에서 접근이 불가능한 경로에 두시기 바랍니다. 
 	* 예) [Window 계열] C:\inetpub\wwwroot\lgdacom ==> 절대불가(웹 디렉토리)
 	*/
// 	String configPath = "C:/lgdacom";  //토스페이먼츠에서 제공한 환경파일("/conf/lgdacom.conf,/conf/mall.conf") 위치 지정.
    File f = new File(request.getContextPath());
    String configPath = f.getAbsoluteFile() + "/src/main/webapp/WEB-INF/jsp/lgdacom/";

    /*
     * 1. 기본결제 인증요청 정보 변경
     *
     * 기본정보를 변경하여 주시기 바랍니다.(파라미터 전달시 POST를 사용하세요)
     */
 	

    String CST_PLATFORM         = request.getParameter("CST_PLATFORM");                 //토스페이먼츠 결제서비스 선택(test:테스트, service:서비스)
    String CST_MID              = request.getParameter("CST_MID");                      //토스페이먼츠로 부터 발급받으신 상점아이디를 입력하세요.
    String LGD_MID              = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;  //테스트 아이디는 't'를 제외하고 입력하세요.
                                                                                        //상점아이디(자동생성)
    String LGD_OID              = request.getParameter("LGD_OID");                      //주문번호(상점정의 유니크한 주문번호를 입력하세요)
    String LGD_AMOUNT           = request.getParameter("LGD_AMOUNT");                   //결제금액("," 를 제외한 결제금액을 입력하세요)
    String LGD_BUYER            = request.getParameter("LGD_BUYER");                    //구매자명
    String LGD_PRODUCTINFO      = request.getParameter("LGD_PRODUCTINFO");              //상품명
    String LGD_BUYEREMAIL       = request.getParameter("LGD_BUYEREMAIL");               //구매자 이메일
    String LGD_TIMESTAMP        = request.getParameter("LGD_TIMESTAMP");                //타임스탬프
    String LGD_CUSTOM_USABLEPAY = request.getParameter("LGD_CUSTOM_USABLEPAY");        	//상점정의 초기결제수단
    String LGD_CUSTOM_SKIN      = "red";                                                //상점정의 결제창 스킨(red)
	String LGD_CUSTOM_PROCESSTYPE = "TWOTR";

    String LGD_CUSTOM_SWITCHINGTYPE = request.getParameter("LGD_CUSTOM_SWITCHINGTYPE"); //신용카드 카드사 인증 페이지 연동 방식 (수정불가)
    String LGD_WINDOW_VER		= "2.5";												//결제창 버젼정보
    String LGD_WINDOW_TYPE      = request.getParameter("LGD_WINDOW_TYPE");              //결제창 호출 방식 (수정불가)

	String LGD_OSTYPE_CHECK     = "P";                                                  //값 P: XPay 실행(PC 결제 모듈): PC용과 모바일용 모듈은 파라미터 및 프로세스가 다르므로 PC용은 PC 웹브라우저에서 실행 필요. 
                                                                                        //"P", "M" 외의 문자(Null, "" 포함)는 모바일 또는 PC 여부를 체크하지 않음
	//String LGD_ACTIVEXYN		= "N";													//계좌이체 결제시 사용, ActiveX 사용 여부로 "N" 이외의 값: ActiveX 환경에서 계좌이체 결제 진행(IE)

    
    /*
     * 가상계좌(무통장) 결제 연동을 하시는 경우 아래 LGD_CASNOTEURL 을 설정하여 주시기 바랍니다.
     */
    String LGD_CASNOTEURL		= "http://127.0.0.1:21000/cas_noteurl.do";

    /*
     * LGD_RETURNURL 을 설정하여 주시기 바랍니다. 반드시 현재 페이지와 동일한 프로트콜 및  호스트이어야 합니다. 아래 부분을 반드시 수정하십시요.
     */
//    String LGD_RETURNURL		= "http://상점URL/returnurl.jsp";// FOR MANUAL
    String LGD_RETURNURL		= "http://127.0.0.1:21000/returnurl.do";// FOR MANUAL

    /*
     *************************************************
     * 2. MD5 해쉬암호화 (수정하지 마세요) - BEGIN
     *
     * MD5 해쉬암호화는 거래 위변조를 막기위한 방법입니다.
     *************************************************
     *
     * 해쉬 암호화 생성( LGD_MID + LGD_OID + LGD_AMOUNT + LGD_TIMESTAMP )
     * LGD_MID          : 상점아이디
     * LGD_OID          : 주문번호
     * LGD_AMOUNT       : 금액
     * LGD_TIMESTAMP    : 타임스탬프
     *
     * MD5 해쉬데이터 암호화 검증을 위해
     * 토스페이먼츠에서 발급한 상점키(MertKey)를 환경설정 파일(lgdacom/conf/mall.conf)에 반드시 입력하여 주시기 바랍니다.
     */
     String LGD_HASHDATA = "";
     XPayClient xpay = null;
     try {
    	 
    	 xpay = new XPayClient();
    	 xpay.Init(configPath, CST_PLATFORM);
    	 
    	 if(LGD_TIMESTAMP == null || "".equals(LGD_TIMESTAMP)) {
    		 LGD_TIMESTAMP = xpay.GetTimeStamp();
    	 }
    	 LGD_HASHDATA = xpay.GetHashData(LGD_MID, LGD_OID, LGD_AMOUNT, LGD_TIMESTAMP);
    	 
     } catch(Exception e) {
    	 e.printStackTrace();
    	out.println("토스페이먼츠 제공 API를 사용할 수 없습니다. 환경파일 설정을 확인해 주시기 바랍니다. ");
 		out.println(""+e.getMessage());    	
 		return;
     } finally {
    	 xpay = null;
     }
    /*
     *************************************************
     * 2. MD5 해쉬암호화 (수정하지 마세요) - END
     *************************************************
     */
     
     
	//파라미터를 추가할 경우 하단의 input type="hidden" 추가 설정 필요     
     


 %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>통합토스페이먼츠 전자결서비스 결제테스트</title>
<!-- test -->
<script language="javascript" src="https://pretest.tosspayments.com:9443/xpay/js/xpay_crossplatform.js" type="text/javascript"></script>
<!-- 
  service  
<script language="javascript" src="https://xpayvvip.tosspayments.com/xpay/js/xpay_crossplatform.js" type="text/javascript"></script>
 -->

<script type="text/javascript">

/*
* 수정불가.
*/
	var LGD_window_type = '<%=LGD_WINDOW_TYPE%>';
	
/*
* 수정불가
*/
function launchCrossPlatform(){
	lgdwin = openXpay(document.getElementById('LGD_PAYINFO'), '<%= CST_PLATFORM %>', LGD_window_type, null, "", "");
}
/*
* FORM 명만  수정 가능
*/
function getFormObject() {
        return document.getElementById("LGD_PAYINFO");
}

/*
 * 인증결과 처리
 */
window.addEventListener('message', function(e) {
    // console.log('parent message');
    // console.log(e.data); // { childData : 'test data' }
    // console.log("e.origin : " + e.origin); //http://123.com(자식창 도메인)

    if(e.data.childData === 'payment_return'){
        payment_return(e.data.respCode, e.data.payKey);
    }
});

function payment_return(respCode, payKey) {
    var fDoc;
	fDoc = lgdwin.contentWindow || lgdwin.contentDocument;
    console.log(fDoc);
	// if (fDoc.document.getElementById('LGD_RESPCODE').value == "0000") {
    if (respCode == "0000") {
        // document.getElementById("LGD_PAYKEY").value = fDoc.document.getElementById('LGD_PAYKEY').value;
        document.getElementById("LGD_PAYKEY").value = payKey;
        document.getElementById("LGD_PAYINFO").target = "_self";
        document.getElementById("LGD_PAYINFO").action = "payres.do";
        document.getElementById("LGD_PAYINFO").submit();
	} else {
		alert("LGD_RESPCODE (결과코드) : " + fDoc.parent.document.getElementById('LGD_RESPCODE').value + "\n"
            + "LGD_RESPMSG (결과메시지): " + fDoc.parent.document.getElementById('LGD_RESPMSG').value);
		closeIframe();
	}
}

</script>
</head>
<body>
<form method="post" name="LGD_PAYINFO" id="LGD_PAYINFO" action="payres.jsp">
<table>
    <tr>
        <td>구매자 이름 </td>
        <td><%= LGD_BUYER %></td>
    </tr>
    <tr>
        <td>상품정보 </td>
        <td><%= LGD_PRODUCTINFO %></td>
    </tr>
    <tr>
        <td>결제금액 </td>
        <td><%= LGD_AMOUNT %></td>
    </tr>
    <tr>
        <td>구매자 이메일 </td>
        <td><%= LGD_BUYEREMAIL %></td>
    </tr>
    <tr>
        <td>주문번호 </td>
        <td><%= LGD_OID %></td>
    </tr>
    <tr>
        <td colspan="2">* 추가 상세 결제요청 파라미터는 메뉴얼을 참조하시기 바랍니다.</td>
    </tr>
    <tr>
        <td colspan="2"></td>
    </tr>
    <tr>
        <td colspan="2">
		<input type="button" value="인증요청" onclick="launchCrossPlatform();"/>
        </td>
    </tr>
</table>


<input type="hidden" id="CST_PLATFORM"				name="CST_PLATFORM"				value="<%=CST_PLATFORM %>"/>
<input type="hidden" id="CST_MID"					name="CST_MID"					value="<%=CST_MID %>"/>
<input type="hidden" id="LGD_WINDOW_TYPE"			name="LGD_WINDOW_TYPE"			value="<%=LGD_WINDOW_TYPE %>"/>
<input type="hidden" id="LGD_MID"					name="LGD_MID"					value="<%=LGD_MID %>"/>
<input type="hidden" id="LGD_OID"					name="LGD_OID"					value="<%=LGD_OID %>"/>
<input type="hidden" id="LGD_BUYER"					name="LGD_BUYER"				value="<%=LGD_BUYER %>"/>
<input type="hidden" id="LGD_PRODUCTINFO"			name="LGD_PRODUCTINFO"			value="<%=LGD_PRODUCTINFO %>"/>
<input type="hidden" id="LGD_AMOUNT"				name="LGD_AMOUNT"				value="<%=LGD_AMOUNT %>"/>
<input type="hidden" id="LGD_BUYEREMAIL"			name="LGD_BUYEREMAIL"			value="<%=LGD_BUYEREMAIL %>"/>
<input type="hidden" id="LGD_CUSTOM_SKIN"			name="LGD_CUSTOM_SKIN"			value="<%=LGD_CUSTOM_SKIN %>"/>
<input type="hidden" id="LGD_CUSTOM_PROCESSTYPE"	name="LGD_CUSTOM_PROCESSTYPE"	value="<%=LGD_CUSTOM_PROCESSTYPE %>"/>
<input type="hidden" id="LGD_TIMESTAMP"				name="LGD_TIMESTAMP"			value="<%=LGD_TIMESTAMP %>"/>
<input type="hidden" id="LGD_HASHDATA"				name="LGD_HASHDATA"				value="<%=LGD_HASHDATA %>"/>
<input type="hidden" id="LGD_RETURNURL"				name="LGD_RETURNURL"			value="<%=LGD_RETURNURL %>"/>
<input type="hidden" id="LGD_CUSTOM_USABLEPAY"		name="LGD_CUSTOM_USABLEPAY"		value="<%=LGD_CUSTOM_USABLEPAY %>"/>
<input type="hidden" id="LGD_CUSTOM_SWITCHINGTYPE"	name="LGD_CUSTOM_SWITCHINGTYPE" value="<%=LGD_CUSTOM_SWITCHINGTYPE %>"/>
<input type="hidden" id="LGD_WINDOW_VER"			name="LGD_WINDOW_VER"			value="<%=LGD_WINDOW_VER %>"/>
<input type="hidden" id="LGD_OSTYPE_CHECK"			name="LGD_OSTYPE_CHECK"			value="<%=LGD_OSTYPE_CHECK %>"/>
<!--
결제요청시 “LGD_RETURN_MERT_CUSTOM_PARAM” = “Y”일 경우 사용자정의 값이 retunurl 로 그대로 리턴
*주의사항
사용자정의 파라미터는 LGD_ 로 시작될 수 없음.

<input type="hidden" id="LGD_RETURN_MERT_CUSTOM_PARAM"	name="LGD_RETURN_MERT_CUSTOM_PARAM"	value="Y” />
<input type="hidden" id="CUSTOM_PARAMETER1"	name="CUSTOM_PARAMETER1"	value="상점정의 파라미터 값 1번입니다" />
<input type="hidden" id="CUSTOM_PARAMETER2"	name="CUSTOM_PARAMETER2"	value="상점정의 파라미터 값 2번입니다” />
-->

<%--
<input type="hidden" id="LGD_ACTIVEXYN"				name="LGD_ACTIVEXYN"			value="<%=LGD_ACTIVEXYN %>"/>
--%>
<input type="hidden" id="LGD_VERSION"				name="LGD_VERSION"				value="JSP_Non-ActiveX_Standard"/>
<input type="hidden" id="LGD_DOMAIN_URL"			name="LGD_DOMAIN_URL"			value="xpayvvip"/>

<input type="hidden" id="LGD_CASNOTEURL"			name="LGD_CASNOTEURL"			value="<%=LGD_CASNOTEURL %>"/>
<input type="hidden" id="LGD_RESPCODE"				name="LGD_RESPCODE"				value=""/>
<input type="hidden" id="LGD_RESPMSG"				name="LGD_RESPMSG"				value=""/>
<input type="hidden" id="LGD_PAYKEY"				name="LGD_PAYKEY"				value=""/>

</form>

</body>

</html>

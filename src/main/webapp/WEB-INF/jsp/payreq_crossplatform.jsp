<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.security.MessageDigest, java.util.*, java.io.*" %>
<%@ page import="lgdacom.XPayClient.XPayClient"%>
<%
	request.setCharacterEncoding("euc-kr");
    /*
     * [���� ������û ������(STEP2-1)]
     *
     * ���������������� �⺻ �Ķ���͸� ���õǾ� ������, ������ �ʿ��Ͻ� �Ķ���ʹ� �����޴����� �����Ͻþ� �߰� �Ͻñ� �ٶ��ϴ�.
     */

     /* �� �߿�
 	* ȯ�漳�� ������ ��� �ݵ�� �ܺο��� ������ ������ ��ο� �νø� �ȵ˴ϴ�.
 	* �ش� ȯ�������� �ܺο� ������ �Ǵ� ��� ��ŷ�� ������ �����ϹǷ� �ݵ�� �ܺο��� ������ �Ұ����� ��ο� �νñ� �ٶ��ϴ�. 
 	* ��) [Window �迭] C:\inetpub\wwwroot\lgdacom ==> ����Ұ�(�� ���丮)
 	*/
// 	String configPath = "C:/lgdacom";  //�佺���̸������� ������ ȯ������("/conf/lgdacom.conf,/conf/mall.conf") ��ġ ����.
    File f = new File(request.getContextPath());
    String configPath = f.getAbsoluteFile() + "/src/main/webapp/WEB-INF/jsp/lgdacom/";

    /*
     * 1. �⺻���� ������û ���� ����
     *
     * �⺻������ �����Ͽ� �ֽñ� �ٶ��ϴ�.(�Ķ���� ���޽� POST�� ����ϼ���)
     */
 	

    String CST_PLATFORM         = request.getParameter("CST_PLATFORM");                 //�佺���̸��� �������� ����(test:�׽�Ʈ, service:����)
    String CST_MID              = request.getParameter("CST_MID");                      //�佺���̸����� ���� �߱޹����� �������̵� �Է��ϼ���.
    String LGD_MID              = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;  //�׽�Ʈ ���̵�� 't'�� �����ϰ� �Է��ϼ���.
                                                                                        //�������̵�(�ڵ�����)
    String LGD_OID              = request.getParameter("LGD_OID");                      //�ֹ���ȣ(�������� ����ũ�� �ֹ���ȣ�� �Է��ϼ���)
    String LGD_AMOUNT           = request.getParameter("LGD_AMOUNT");                   //�����ݾ�("," �� ������ �����ݾ��� �Է��ϼ���)
    String LGD_BUYER            = request.getParameter("LGD_BUYER");                    //�����ڸ�
    String LGD_PRODUCTINFO      = request.getParameter("LGD_PRODUCTINFO");              //��ǰ��
    String LGD_BUYEREMAIL       = request.getParameter("LGD_BUYEREMAIL");               //������ �̸���
    String LGD_TIMESTAMP        = request.getParameter("LGD_TIMESTAMP");                //Ÿ�ӽ�����
    String LGD_CUSTOM_USABLEPAY = request.getParameter("LGD_CUSTOM_USABLEPAY");        	//�������� �ʱ��������
    String LGD_CUSTOM_SKIN      = "red";                                                //�������� ����â ��Ų(red)
	String LGD_CUSTOM_PROCESSTYPE = "TWOTR";

    String LGD_CUSTOM_SWITCHINGTYPE = request.getParameter("LGD_CUSTOM_SWITCHINGTYPE"); //�ſ�ī�� ī��� ���� ������ ���� ��� (�����Ұ�)
    String LGD_WINDOW_VER		= "2.5";												//����â ��������
    String LGD_WINDOW_TYPE      = request.getParameter("LGD_WINDOW_TYPE");              //����â ȣ�� ��� (�����Ұ�)

	String LGD_OSTYPE_CHECK     = "P";                                                  //�� P: XPay ����(PC ���� ���): PC��� ����Ͽ� ����� �Ķ���� �� ���μ����� �ٸ��Ƿ� PC���� PC ������������ ���� �ʿ�. 
                                                                                        //"P", "M" ���� ����(Null, "" ����)�� ����� �Ǵ� PC ���θ� üũ���� ����
	//String LGD_ACTIVEXYN		= "N";													//������ü ������ ���, ActiveX ��� ���η� "N" �̿��� ��: ActiveX ȯ�濡�� ������ü ���� ����(IE)

    
    /*
     * �������(������) ���� ������ �Ͻô� ��� �Ʒ� LGD_CASNOTEURL �� �����Ͽ� �ֽñ� �ٶ��ϴ�.
     */
    String LGD_CASNOTEURL		= "http://127.0.0.1:21000/cas_noteurl.do";

    /*
     * LGD_RETURNURL �� �����Ͽ� �ֽñ� �ٶ��ϴ�. �ݵ�� ���� �������� ������ ����Ʈ�� ��  ȣ��Ʈ�̾�� �մϴ�. �Ʒ� �κ��� �ݵ�� �����Ͻʽÿ�.
     */
//    String LGD_RETURNURL		= "http://����URL/returnurl.jsp";// FOR MANUAL
    String LGD_RETURNURL		= "http://127.0.0.1:21000/returnurl.do";// FOR MANUAL

    /*
     *************************************************
     * 2. MD5 �ؽ���ȣȭ (�������� ������) - BEGIN
     *
     * MD5 �ؽ���ȣȭ�� �ŷ� �������� �������� ����Դϴ�.
     *************************************************
     *
     * �ؽ� ��ȣȭ ����( LGD_MID + LGD_OID + LGD_AMOUNT + LGD_TIMESTAMP )
     * LGD_MID          : �������̵�
     * LGD_OID          : �ֹ���ȣ
     * LGD_AMOUNT       : �ݾ�
     * LGD_TIMESTAMP    : Ÿ�ӽ�����
     *
     * MD5 �ؽ������� ��ȣȭ ������ ����
     * �佺���̸������� �߱��� ����Ű(MertKey)�� ȯ�漳�� ����(lgdacom/conf/mall.conf)�� �ݵ�� �Է��Ͽ� �ֽñ� �ٶ��ϴ�.
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
    	out.println("�佺���̸��� ���� API�� ����� �� �����ϴ�. ȯ������ ������ Ȯ���� �ֽñ� �ٶ��ϴ�. ");
 		out.println(""+e.getMessage());    	
 		return;
     } finally {
    	 xpay = null;
     }
    /*
     *************************************************
     * 2. MD5 �ؽ���ȣȭ (�������� ������) - END
     *************************************************
     */
     
     
	//�Ķ���͸� �߰��� ��� �ϴ��� input type="hidden" �߰� ���� �ʿ�     
     


 %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>�����佺���̸��� ���ڰἭ�� �����׽�Ʈ</title>
<!-- test -->
<script language="javascript" src="https://pretest.tosspayments.com:9443/xpay/js/xpay_crossplatform.js" type="text/javascript"></script>
<!-- 
  service  
<script language="javascript" src="https://xpayvvip.tosspayments.com/xpay/js/xpay_crossplatform.js" type="text/javascript"></script>
 -->

<script type="text/javascript">

/*
* �����Ұ�.
*/
	var LGD_window_type = '<%=LGD_WINDOW_TYPE%>';
	
/*
* �����Ұ�
*/
function launchCrossPlatform(){
	lgdwin = openXpay(document.getElementById('LGD_PAYINFO'), '<%= CST_PLATFORM %>', LGD_window_type, null, "", "");
}
/*
* FORM ��  ���� ����
*/
function getFormObject() {
        return document.getElementById("LGD_PAYINFO");
}

/*
 * ������� ó��
 */
window.addEventListener('message', function(e) {
    // console.log('parent message');
    // console.log(e.data); // { childData : 'test data' }
    // console.log("e.origin : " + e.origin); //http://123.com(�ڽ�â ������)

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
		alert("LGD_RESPCODE (����ڵ�) : " + fDoc.parent.document.getElementById('LGD_RESPCODE').value + "\n"
            + "LGD_RESPMSG (����޽���): " + fDoc.parent.document.getElementById('LGD_RESPMSG').value);
		closeIframe();
	}
}

</script>
</head>
<body>
<form method="post" name="LGD_PAYINFO" id="LGD_PAYINFO" action="payres.jsp">
<table>
    <tr>
        <td>������ �̸� </td>
        <td><%= LGD_BUYER %></td>
    </tr>
    <tr>
        <td>��ǰ���� </td>
        <td><%= LGD_PRODUCTINFO %></td>
    </tr>
    <tr>
        <td>�����ݾ� </td>
        <td><%= LGD_AMOUNT %></td>
    </tr>
    <tr>
        <td>������ �̸��� </td>
        <td><%= LGD_BUYEREMAIL %></td>
    </tr>
    <tr>
        <td>�ֹ���ȣ </td>
        <td><%= LGD_OID %></td>
    </tr>
    <tr>
        <td colspan="2">* �߰� �� ������û �Ķ���ʹ� �޴����� �����Ͻñ� �ٶ��ϴ�.</td>
    </tr>
    <tr>
        <td colspan="2"></td>
    </tr>
    <tr>
        <td colspan="2">
		<input type="button" value="������û" onclick="launchCrossPlatform();"/>
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
������û�� ��LGD_RETURN_MERT_CUSTOM_PARAM�� = ��Y���� ��� ��������� ���� retunurl �� �״�� ����
*���ǻ���
��������� �Ķ���ʹ� LGD_ �� ���۵� �� ����.

<input type="hidden" id="LGD_RETURN_MERT_CUSTOM_PARAM"	name="LGD_RETURN_MERT_CUSTOM_PARAM"	value="Y�� />
<input type="hidden" id="CUSTOM_PARAMETER1"	name="CUSTOM_PARAMETER1"	value="�������� �Ķ���� �� 1���Դϴ�" />
<input type="hidden" id="CUSTOM_PARAMETER2"	name="CUSTOM_PARAMETER2"	value="�������� �Ķ���� �� 2���Դϴ١� />
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

<%@ page contentType="text/html;charset=EUC-KR" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>�佺���̸��� ���ڰ��� ���� ������ (XPay)</title>
<script type="text/javascript">
function LPad(digit, size, attatch) {
    var add = "";
    digit = digit.toString();

    if (digit.length < size) {
        var len = size - digit.length;
        for (i = 0; i < len; i++) {
            add += attatch;
        }
    }
    return add + digit;
}

function makeoid() {
	var now = new Date();
	var years = now.getFullYear();
	var months = LPad(now.getMonth() + 1, 2, "0");
	var dates = LPad(now.getDate(), 2, "0");
	var hours = LPad(now.getHours(), 2, "0");
	var minutes = LPad(now.getMinutes(), 2, "0");
	var seconds = LPad(now.getSeconds(), 2, "0");
	var timeValue = years + months + dates + hours + minutes + seconds; 
	document.getElementById("LGD_OID").value = "test_" + timeValue;
	document.getElementById("LGD_TIMESTAMP").value = timeValue;
}

/*
* ������û ó�� 
*/
function doPay() {
	// OID, TIMESTAMP ����
	makeoid();
	// ����â ȣ��
	document.getElementById("LGD_PAYINFO").submit();
}
</script>
</head>
<body>
<form method="post" id="LGD_PAYINFO" action="payreq_crossplatform.do">
    <div>
        <table>
            <tr>
                <td>�������̵�(t�� ������ ���̵�) </td>
<%--                <td><input type="text" name="CST_MID" id="CST_MID" value="lgdacomxpay"/></td>--%>
                <td><input type="text" name="CST_MID" id="CST_MID" value="scscd02"/></td>
            </tr>
            <tr>
                <td>����,�׽�Ʈ </td>
                <td><input type="text" name="CST_PLATFORM" id="CST_PLATFORM" value="test"/></td>
            </tr>
            <tr>
                <td>������ �̸� </td>
                <td><input type="text" name="LGD_BUYER" id="LGD_BUYER" value="ȫ�浿"/></td>
            </tr>
            <tr>
                <td>��ǰ���� </td>
                <td><input type="text" name="LGD_PRODUCTINFO" id="LGD_PRODUCTINFO" value="myLG070-���ͳ���ȭ��"/></td>
            </tr>
            <tr>
                <td>�����ݾ� </td>
                <td><input type="text" name="LGD_AMOUNT" id="LGD_AMOUNT" value="50000"/></td>
            </tr>
            <tr>
                <td>������ �̸��� </td>
                <td><input type="text" name="LGD_BUYEREMAIL" id="LGD_BUYEREMAIL" value=""/></td>
            </tr>
            <tr>
                <td>�ֹ���ȣ </td>
                <td><input type="text" name="LGD_OID" id="LGD_OID" value="test_1234567890020"/></td>
            </tr>
            <tr>
                <td>Ÿ�ӽ����� </td>
                <td><input type="text" name="LGD_TIMESTAMP" id="LGD_TIMESTAMP" value="1234567890"/></td>
            </tr>
            <tr>
                <td>�ʱ�������� </td>
                <td>
                	<select name="LGD_CUSTOM_USABLEPAY" id="LGD_CUSTOM_USABLEPAY">
						<option value="SC0010">�ſ�ī��</option>				
						<option value="SC0030">������ü</option>				
						<option value="SC0040">�������Ա�</option>				
						<option value="SC0060">�޴���</option>				
						<option value="SC0070">������ȭ����</option>				
						<option value="SC0090">OKĳ����</option>				
						<option value="SC0111">��ȭ��ǰ��</option>				
						<option value="SC0112">���ӹ�ȭ��ǰ��</option>				
					</select>
				</td>
			</tr>
            <tr>
                <td>����â ȣ�� ��� </td>
                <td>
                	<select name="LGD_WINDOW_TYPE" id="LGD_WINDOW_TYPE">
						<option value="iframe">iframe</option>
					</select>
				</td>
            </tr>
            <tr>
                <td>�ſ�ī�� ī��� ���� ������ ���� ��� </td>
                <td>
                	<select name="LGD_CUSTOM_SWITCHINGTYPE" id="LGD_CUSTOM_SWITCHINGTYPE">
						<option value="IFRAME">IFRAME</option>
					</select>
				</td>
            </tr>                      
            <tr>
                <td colspan="2">
                <input type="button" value="�����ϱ�" onclick="doPay();" /><br/>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
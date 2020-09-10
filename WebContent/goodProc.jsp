<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR"%>
<%request.setCharacterEncoding("UTF-8"); %>

<jsp:useBean id="mMgr" class="datec.datecMgr"/>
<jsp:useBean id="mBean" class="datec.datecBean"/>

<%
	String userID = (String)session.getAttribute("userID");
	String goodplace = request.getParameter("dname");			
	String button = request.getParameter("good");
	String msg = "";
    String url = "/UserChat/datec/datec.jsp";
 	String gbutton = request.getParameter("button");

    boolean result = mMgr.goodcheck(userID, goodplace);			/* mMgr�� �ִ� goodcheck�Լ� �̿��Ͽ� id,goodplace���� datecgood���̺� ������ true,������ false */
    if(!result){											/* !result => datecgood ���̺� ���� �ȵǾ��ִ� ���� */
    	mMgr.insertgood(userID, goodplace);						/* mMgr�� �ִ� insertgood �Լ� �̿��Ͽ� id,goodplace���� datecgood ���̺� ���� */
    	msg = "�� �߰��Ǿ����ϴ�";
    }else{													/* datecgood ���̺� ���� �Ǿ��ִ� ���� */
    	mMgr.deletegood(userID, goodplace);						/* mMgr�� �ִ� deletegood �Լ� �̿��Ͽ� id,goodplace���� datecgood ���̺��� ���� */
    	msg = "�� �����Ǿ����ϴ�";
    }
%>

<script>
	alert("<%=msg%>");
  	location.href="<%=url%>";
</script>

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

    boolean result = mMgr.goodcheck(userID, goodplace);			/* mMgr에 있는 goodcheck함수 이용하여 id,goodplace값이 datecgood테이블에 있으면 true,없으면 false */
    if(!result){											/* !result => datecgood 테이블에 저장 안되어있는 상태 */
    	mMgr.insertgood(userID, goodplace);						/* mMgr에 있는 insertgood 함수 이용하여 id,goodplace값을 datecgood 테이블에 저장 */
    	msg = "찜 추가되었습니다";
    }else{													/* datecgood 테이블에 저장 되어있는 상태 */
    	mMgr.deletegood(userID, goodplace);						/* mMgr에 있는 deletegood 함수 이용하여 id,goodplace값을 datecgood 테이블에서 삭제 */
    	msg = "찜 삭제되었습니다";
    }
%>

<script>
	alert("<%=msg%>");
  	location.href="<%=url%>";
</script>

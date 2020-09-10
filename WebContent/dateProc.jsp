<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8"); %>

<jsp:useBean id="mMgr" class="datec.datecMgr"/>
<jsp:useBean id="mBean" class="datec.datecBean"/>

<%
	String button = request.getParameter("button");				/* main에서 받아온 button값(지역) */
    String url = "/UserChat/datec/datec.jsp";										

	if(!button.equals(null)){									/* button 값이 null이 아니면 button값을 dlocation session에 저장 */
		session.setAttribute("dlocation",button);
		session.setAttribute("kind","total"); 					/* 지역버튼 누르면 kind에 "total"값 저장. 지역버튼 누르면 type에 total값 보여지게 */
	}
%>

<script>
  location.href="<%=url%>";										/* datec.jsp로 session값을 보냄 */
</script>

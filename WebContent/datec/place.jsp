<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
   String name=request.getParameter("name");					/* name으로 보낸 type값 받아옴 */
   session.setAttribute("kind", name);							/* type값을 kind session에 저장 */
   String url="/UserChat/datec/datec.jsp";										/* datec.jsp로 session값을 보냄 */
%>
</head>
<script>
  location.href="<%=url%>";
</script>
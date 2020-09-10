<%@page import="user.UserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <jsp:useBean id="mMgr" class="user.UserDAO"></jsp:useBean>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
	String id=(String)session.getAttribute("userID"); //내 아이디
	String userid=request.getParameter("id");	//내가 보는 사람
	String url="/UserChat/user/heart.jsp";
	mMgr.deleteHeart(id,userid);
	new UserDAO().minusGood(userid);
	String msg="좋아요가 취소되었습니다";
%>
</head>
<script>
		alert("<%=msg%>");
		location.href="<%=url%>";
</script>  
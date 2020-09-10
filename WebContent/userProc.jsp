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
	String userid=request.getParameter("id");	//상대방
	String url="/UserChat/user/heart.jsp";
	String msg="이미 좋아요를 눌렀습니다";
	
	boolean check=mMgr.checkid(id,userid);		//이미 좋아요를 누른 사람인지 아닌지 확인
	if(!check){			//이미 좋아요를 누른 사람이 아닐 경우
		mMgr.sendHeart(id,userid);			//좋아요를 누르고 db에 insert
		new UserDAO().addGood(userid);
		msg="좋아요를 눌렀습니다";
	}
%>
</head>
	<script>
		alert("<%=msg%>");
		location.href="<%=url%>";
	 </script>  
	


<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="mMgr" class="user.UserDAO"></jsp:useBean>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%
	request.setCharacterEncoding("UTF-8");
	String id=(String)session.getAttribute("userID");    //지금 현재 로그인 한 아이디 		
	String url="/UserChat/user/heart.jsp";
	String button=request.getParameter("button");		//내가 좋아요 누른 사람 or 나를 좋아요 누른 사람
	
	
	//서로 호감인지 아닌지 체크
	boolean result=false;
	result=mMgr.FromHeart(id,button);	//result에 나를 좋아요 누른 사람 or 내가 좋아요 누른 사람이 존재하는지 아닌지 판별
	if(result){		//존재하는 경우 session 값 생성
		session.setAttribute("idKey", id);	
		session.setAttribute("button", button);
		session.setAttribute("heart", "heart");		//heart.jsp에서 "heart"로 호감 리스트를 뿌리기 때문에 "heart" 세션에 아무값이나 넣음
	}	
%>
</head>
	 <script>
		location.href="<%=url%>";
	 </script> 
	
	
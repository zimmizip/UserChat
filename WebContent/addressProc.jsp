<%@page import="user.UserDTO"%>
<%@page import="user.UserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="mMgr" class="map.mapDAO"></jsp:useBean> 
<jsp:useBean id="uMgr" class="user.UserDAO"></jsp:useBean>    
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%
		request.setCharacterEncoding("utf-8");
		String userID=(String)session.getAttribute("userID");
		UserDTO info=uMgr.getUser(userID);		//로그인한 회원의 정보를 받아옴
		String address=request.getParameter("address");
		String msg="";
		String url="";
		boolean checkAddress=mMgr.checkid(userID);		//이미 등록되어 있는지 확인
		if(checkAddress){
			msg="주소를 이미 등록하셨습니다";
			url="/UserChat/map/map1.jsp?address="+address;
		}else if(info.getUserProfile().equals("")|| info.getUserProfile()==null){
			msg="사진을 먼저 등록해주세요";
			url="/UserChat/map/insertAddress.jsp";
		}else{
			mMgr.insertAddress(userID,address,info.getUserProfile());	//새로 등록할 경우 db에 저장
			url="/UserChat/map/map1.jsp?address="+address;
		}
		
			
	%>
</head>
	<script>
		location.href="<%=url%>";
	</script>
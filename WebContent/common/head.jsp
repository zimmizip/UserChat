<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null) {
			userID = (String)session.getAttribute("userID");
		}
		
	%>
	<meta charset="UTF-8">
	<meta name = "viewport" content = "width = device-width, initial-scale=1">
	<link rel = "stylesheet" href = "/UserChat/css/bootstrap.css">
	<link rel = "stylesheet" href = "/UserChat/css/custom.css">
	<title>지금 당장 만나</title>
	<script src = "https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src = "/UserChat/js/bootstrap.js"></script>
	<body>
<!-- 요기부터 header -->
	<nav class ="navbar navbar-default">
		<div class ="navbar-header">
			<button type = "button" class = "navbar-toggle collapsed"
				data-toggle = "collapse" data-target = "#bs-example-navbar-collapse-1"
				aria-expanded = "false">
				<span class = "icon-bar"></span>
				<span class = "icon-bar"></span>
				<span class = "icon-bar"></span>
			</button>
			<a class = "navbar-brand" href = "/UserChat/index.jsp">지금 당장 만나</a>
		</div>
		<div class = "collapse navbar-collapse" id = "bs-example-navbar-collapse-1">
			<ul class = "nav navbar-nav">
				<li><a href = "/UserChat/index.jsp">메인</a>
				<li><a href = "/UserChat/user/find.jsp">친구찾기</a></li>
				<li><a href = "/UserChat/chat/box.jsp">메세지함<span id = "unread" class = "label label-info"></span></a></li>
				<li><a href = "/UserChat/board/boardView.jsp">연애상담 게시판</a>
				<li><a href = "/UserChat/map/insertAddress.jsp">주변 이성 찾기</a>
				<li><a href = "/UserChat/datec/datec.jsp">데이트 추천</a>
				<li><a href = "/UserChat/poll/polllist.jsp">심리 테스트</a>
			</ul>
			<ul class = "nav navbar-nav navbar-right">
				<li class ="dropdown">
					<a href = "#" class= "dropdown-toggle"
						data-toggle = "dropdown" role = "button" aria-haspopup = "true"
						aria-expanded = "false">회원관리<span class = "caret"></span>
					</a>
					<ul class = "dropdown-menu">
						<li><a href = "/UserChat/user/update.jsp">회원정보 수정</a></li>
						<li><a href = "/UserChat/user/profileUpdate.jsp">프로필 수정</a></li>
						<li><a href = "/UserChat/logoutAction.jsp">로그아웃</a></li>
						<li><a href="/UserChat/user/mypage.jsp">내 정보</a></li>
						<li><a href="/UserChat/user/leave.jsp">회원탈퇴</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</nav>
	<!-- 요기까지가 header -->
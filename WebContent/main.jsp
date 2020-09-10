<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String userID = null;
	if(session.getAttribute("userID") != null) {
		userID = (String)session.getAttribute("userID");
		response.sendRedirect("index.jsp");	
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>지금 당장 만나</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel = "stylesheet" href = "/UserChat/css/bootstrap.css">
	<link rel = "stylesheet" href = "/UserChat/css/custom.css">
	<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
	<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Raleway">
	<link rel = "stylesheet" href = "http://fonts.googleapis.com/earlyaccess/nanumgothic.css">
	<script src = "https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src = "/UserChat/js/bootstrap.js"></script>
	<style>
	* {
		font-family: 'Nanum Gothic';
	}
	body, html {height: 100%}
	.bgimg {
	  background-image: url('/UserChat/images/main.png');
	  min-height: 100%;
	  background-position: center;
	  background-size: cover;
	}
</style>
</head>
<body>
	<div class="bgimg w3-display-container w3-animate-opacity w3-text-black">
		<div class="w3-display-middle">
			<button data-toggle="collapse" href="#collapseExample" aria-expanded="false" aria-controls="collapseExample" style = "font-size: 50px; border: 0px; background-color: #006DCC; color: white; border-radius: 10px;">지금 당장 만나</button>
			    <div class = "collapse" id = "collapseExample">
				<form method = "post" action = "/UserChat/./userLogin">
					<table class = "table table-bordered table-hover" style = "text-align: center; background-color: white; border: 1px solid #dddddd">
						<thead>
							<tr>
								<th colspan = "2"><h4>로그인 양식</h4></th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td style = "width: 110px;"><h5 style = "color: black;">아이디</h5></td>
								<td><input class = "form-control" type = "text" name = "userID" maxlength = "20" placeholder = "아이디를 입력하세요."></td>
							</tr>
							<tr>
								<td style = "width: 110px;"><h5  style = "color: black;">비밀번호</h5></td>
								<td><input class = "form-control" type = "password" name = "userPassword" maxlength = "20" placeholder = "비밀번호를 입력하세요."></td>
							</tr>
							<tr>
								<td style = "text-align: left" colspan = "2"><input class = "btn btn-primary left" type = "button" value = "회원가입" onclick = "window.open('join.jsp','회원가입','width=430,height=500,location=no,status=no,scrollbars=yes');">
								<input class = "btn btn-primary pull-right" type = "submit" value = "로그인"></td>
							</tr>
						</tbody>
					</table> 
					<h5 style = "text-align: middle" class = "btn btn-primary middle" onclick = "window.open('findIDPW.jsp','ID,PW찾기','width=430,height=500,location=no,status=no,scrollbars=yes');">ID와 Password를 잊으셨다구요?</h5>
				</form>
			</div>
		</div>
	</div>
	<%
		String messageContent = null;
		if(session.getAttribute("messageContent") != null) {
			messageContent = (String)session.getAttribute("messageContent");
		}
		String messageType = null;
		if(session.getAttribute("messageType") != null) {
			messageType =(String)session.getAttribute("messageType");
		}
		if(messageContent != null) {
	%>
	<div class = "modal fade" id = "messageModal" tabindex = "-1" role = "dialog" aria-hidden = "true">
		<div class = "vertical-alignment-helper">
			<div class = "modal-dialog vertical-align-center">
				<div class = "modal-content <%if(messageType.equals("오류 메시지")) out.println("panel-warning"); else out.println("panel-success"); %>">
					<div class = "modal-header panel-heading">
						<button type = "button" class= "close" data-dismiss = "modal">
							<span aria-hidden = "true">&times</span>
							<span class = "sr-only">Close</span>
						</button>
						<h4 class = "modal-title">
							<%=messageType %>
						</h4>
					</div>
					<div class = "modal-body">
						<%=messageContent %>
					</div>
					<div class = "modal-footer">
						<button type = "button" class = "btn btn-primary" data-dismiss = "modal">확인</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script>
		$('#messageModal').modal("show");
	</script>
	<%
		session.removeAttribute("messageContent");
		session.removeAttribute("messageType");
		}
	%>
	<div class = "modal fade" id = "checkModal" tabindex = "-1" role = "dialog" aria-hidden = "true">
		<div class = "vertical-alignment-helper">
			<div class = "modal-dialog vertical-align-center">
				<div id = "checkType" class = "modal-content panel-info">
					<div class = "modal-header panel-heading">
						<button type = "button" class= "close" data-dismiss = "modal">
							<span aria-hidden = "true">&times</span>
							<span class = "sr-only">Close</span>
						</button>
						<h4 class = "modal-title">
							확인 메세지
						</h4>
					</div>
					<div id = "checkMessage" class = "modal-body">
					</div>
					<div class = "modal-footer">
						<button type = "button" class = "btn btn-primary" data-dismiss = "modal">확인</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
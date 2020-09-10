<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name = "viewport" content = "width = device-width, initial-scale=1">
	<link rel = "stylesheet" href = "/UserChat/css/bootstrap.css">
	<link rel = "stylesheet" href = "/UserChat/css/custom.css">
	<title>지금 당장 만나</title>
	<script src = "https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src = "/UserChat/js/bootstrap.js"></script>
	<script src = "js/bootstrap.js"></script>
</head>
<body>
	<!-- 로그인 양식 -->
	<div class = "container">
		<form method = "post" action = "/UserChat/./userIdServlet">
			<table class = "table table-bordered table-hover" style = "text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan = "2"><h4>아이디 찾기</h4></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style = "width: 110px;"><h5>이름</h5></td>
						<td><input class = "form-control" type = "text" name = "userName" maxlength = "20" placeholder = "이름을 입력하세요."></td>
					</tr>
					<tr>
						<td style = "width: 110px;"><h5>이메일</h5></td>
						<td><input class = "form-control" type = "text" name = "userEmail" maxlength = "20" placeholder = "이메일을 입력하세요."></td>
					</tr>
					<tr>
						<td style = "text-align: left" colspan = "2"><input class = "btn btn-primary pull-right" type = "submit" value = "아이디 찾기"></td>
					</tr>
				</tbody>
			</table> 
		</form>
	</div>
	<div class = "container">
		<form method = "post" action = "/UserChat/./userPasswordServlet">
			<table class = "table table-bordered table-hover" style = "text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan = "2"><h4>Password 찾기</h4></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style = "width: 110px;"><h5>아이디</h5></td>
						<td><input class = "form-control" type = "text" name = "userID" maxlength = "20" placeholder = "아이디를 입력하세요."></td>
					</tr>
					<tr>
						<td style = "width: 110px;"><h5>이메일</h5></td>
						<td><input class = "form-control" type = "text" name = "userEmail" maxlength = "20" placeholder = "이메일을 입력하세요."></td>
					</tr>
					<tr>
						<td style = "text-align: left" colspan = "2"><input class = "btn btn-primary pull-right" type = "submit" value = "Password 찾기"></td>
					</tr>
				</tbody>
			</table> 
		</form>
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
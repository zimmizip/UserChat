<%@page import="user.UserDAO"%>
<%@page import="user.UserDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String userID = null;
	if(session.getAttribute("userID") != null) {
		userID = (String)session.getAttribute("userID");
	}
	String toID = (String)request.getParameter("toID");
	UserDTO user = new UserDAO().getUser(toID);
	
	String checkGood = new UserDAO().findGood(userID, toID);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name = "viewport" content = "width = device-width, initial-scale=1">
	<link rel = "stylesheet" href = "/UserChat/css/bootstrap.css">
	<link rel = "stylesheet" href = "/UserChat/css/custom.css">
	<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
	<title>지금 당장 만나</title>
	<script src = "https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src = "/UserChat/js/bootstrap.js"></script>
</head>
<body>
	<div class = "container">
		<form method = "post" action = "./userLoveServlet">
			<table class = "table table-bordered table-hover" style = "text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan = "2"><h4><%=user.getUserID() %>님의 정보</h4></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style = "width: 300px; text-align: center; margin: 0px auto;"><h5>프로필 사진</h5></td>
		  				<td colspan= "2" height="300" ><img style = "height: 400px; width: 400px;" src="http://localhost:8089/UserChat/upload/<%=user.getUserProfile() %>"></td> 	  		
					</tr>
					<tr>
						<td style = "width: 110px;"><h5>이름</h5></td>
						<td colspan = "2"><h5><%=user.getUserName() %></h5>
						<input type = "hidden" name = "toID" value = "<%=user.getUserID() %>">
						<input type = "hidden" name = "userID" value = "<%=userID %>"></td>
					</tr>
					<tr>
						<td style = "width: 110px;"><h5>자기소개</h5></td>
						<td colspan = "2"><h5><%=user.getUserContent() %></h5></td>
					</tr>
					<tr>
						<td style = "width: 110px;"><h5>좋아요</h5></td>
						<td colspan = "2"><h5><%=user.getUserGood() %></h5></td>
					</tr>
					<tr>
						<td style = "text-align: left;" colspan = "3">
							<input class = "btn btn-primary pull-right" type = "button" value = "나가기" onclick = "window.close()">
							<%
								if(checkGood.equals("yes")) {
							%>
									<input class = "btn btn-primary pull-right" type = "submit" value = "좋아요 취소"/>
							<%		
								} else {
							%>
									<input class = "btn btn-primary pull-right" type = "submit" value = "좋아요"/>
							<%
								}
							%>
						</td>
					</tr>
				</tbody>
			</table>
		</form>	
	</div>
	<!-- 	요기부터 팝업창 -->
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
	<%
		session.removeAttribute("messageContent");
		session.removeAttribute("messageType");
		}
	%>
	<!-- 요기까지 팝업 메세지 -->
	<script>
		$('#messageModal').modal("show");
	</script>
</body>
</html>
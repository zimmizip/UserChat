<%@page import="user.UserDAO"%>
<%@page import="user.UserDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<%
		if(userID == null) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "현재 로그인이 되어 있지 않는 상태입니다.");
			response.sendRedirect("main.jsp");
			return;
		}
		UserDTO user = new UserDAO().getUser(userID);
	%>
<head>
	<script type = "text/javascript">
		function getUnread() {
			$.ajax ({
				type: "POST",
				url: "/UserChat/./chatUnread",
				data: {
					userID: encodeURIComponent('<%=userID%>'),
				},
				success: function(result) {
					if(result >= 1) {
						showUnread(result);
					} else {
						showUnread();
					}
				}
			});
		}
		function getInfiniteUnread() {
			setInterval(function() {
				getUnread();
			}, 4000);
		}
		function showUnread(result) {
			$('#unread').html(result);
		}		
	</script>
</head>
<body>
	<div class = "container">
		<form method = "post" action = "/UserChat/index.jsp">
			<table class = "table table-bordered table-hover" style = "text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan = "2"><h4>내 정보</h4></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style = "width: 300px; text-align: center; margin: 0px auto;"><h5>프로필 사진</h5></td>
		  				<td colspan= "2" height="300" ><img style = "height: 400px; width: 400px;" src="http://localhost:8089/UserChat/upload/<%=user.getUserProfile() %>"></td> 	  		
					</tr>
					<tr>
						<td style = "width: 110px;"><h5>아이디</h5></td>
						<td><h5>
							<%=user.getUserID() %>
						</h5>
						<input type = "hidden" name = "userID" value = "<%=user.getUserID() %>"></td>
					</tr>				
					<tr>
						<td style = "width: 110px;"><h5>이름</h5></td>
						<td colspan = "2"><h5><%=user.getUserName() %></h5></td>
					</tr>
					<tr>
						<td style = "width: 110px;"><h5>나이</h5></td>
						<td colspan = "2"><h5><%=user.getUserAge() %></h5></td>
					</tr>
					<tr>
						<td style = "width: 110px;"><h5>성별</h5></td>
						<td colspan = "2"><h5><%=user.getUserGender() %></h5></td>
					</tr>
					<tr>
						<td = style = "width: 110px;"><h5>이메일</h5></td>
						<td colspan = "2"><h5><%=user.getUserEmail() %></h5></td>
					</tr>   
					<tr>
						<td style = "text-align: left;" colspan = "3">
							<!-- <h5 style = "color: red;" id = "passwordCheckMessage"></h5> -->
							<input class = "btn btn-primary pull-right" type = "submit" value = "나가기">
							<input class = "btn btn-primary pull-right" type = "button" value = "호감" onclick="location.href='/UserChat/user/heart.jsp?id=<%=userID%>'"/>
							<input class = "btn btn-primary pull-right" type = "button" value = "데이트 장소 찜 리스트" onclick="location.href='/UserChat/user/zzimlist.jsp'"/>
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
	<%
		if(userID != null) {
	%>
		<script type = "text/javascript">
			$(document).ready(function() {
				getUnread();
				getInfiniteUnread();
			});
		</script>
	<%
		}
	%>
</body>
</html>
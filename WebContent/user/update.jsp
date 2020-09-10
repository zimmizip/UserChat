<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "user.UserDTO" %>
<%@ page import = "user.UserDAO" %>
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
		
		function passwordCheckFunction() {
			var userPassword1 = $('#userPassword1').val();
			var userPassword2 = $('#userPassword2').val();
			if(userPassword1 != userPassword2) {
				$('#passwordCheckMessage').html('비밀번호가 서로 일치하지 않습니다.');
			} else {
				$('#passwordCheckMessage').html('');
			}
		}
	</script>
</head>
<body>
	<div class = "container">
		<form method = "post" action = "/UserChat/./userUpdate">
			<table class = "table table-bordered table-hover" style = "text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan = "2"><h4>회원 정보 수정 양식</h4></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style = "width: 110px;"><h5>아이디</h5></td>
						<td><h5>
							<%=user.getUserID() %>
						</h5>
						<input type = "hidden" name = "userID" value = "<%=user.getUserID() %>"></td>
					</tr>
					<tr>
						<td style = "width: 110px;"><h5>비밀번호</h5></td>
						<td colspan = "2"><input onkeyup = "passwordCheckFunction();" class = "form-control" type = "password" id = "userPassword1" name ="userPassword1" maxlength = "20" placeholder = "비밀번호를 입력하세요"></td>
					</tr>
					<tr>
						<td style = "width: 110px;"><h5>비밀번호 확인</h5></td>
						<td colspan = "2"><input onkeyup = "passwordCheckFunction();" class = "form-control" type = "password" id = "userPassword2" name ="userPassword2" maxlength = "20" placeholder = "비밀번호를 확인하세요"></td>
					</tr> 
					<tr>
						<td style = "width: 110px;"><h5>이름</h5></td>
						<td colspan = "2"><input class = "form-control" type = "text" id = "userName" name ="userName" maxlength = "20" placeholder = "이름을 입력하세요" value = "<%=user.getUserName() %>"></td>
					</tr>
					<tr>
						<td style = "width: 110px;"><h5>나이</h5></td>
						<td colspan = "2"><input class = "form-control" type = "text" id = "userAge" name ="userAge" maxlength = "20" placeholder = "나이를 입력하세요" value = "<%=user.getUserAge() %>"></td>
					</tr>
					<tr>
						<td style = "width: 110px;"><h5>성별</h5></td>
						<td colspan = "2">
							<div class = "form-group" style = "text-algin: center; margin: 0 auto;">
								<div class = "btn-group" data-toggle = "buttons">
									<label class = "btn btn-primary <% if(user.getUserGender().equals("남자")) out.print("active");%>">
										<input type = "radio" name = "userGender" autocomplete = "off" value = "남자" <% if(user.getUserGender().equals("남자")) out.print("checked"); %>>남자
									</label>
									<label class = "btn btn-primary <% if(user.getUserGender().equals("여자")) out.print("active");%>">
										<input type = "radio" name = "userGender" autocomplete = "off" value = "여자" <% if(user.getUserGender().equals("여자")) out.print("checked"); %>>여자
									</label>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<td = style = "width: 110px;"><h5>이메일</h5></td>
						<td colspan = "2"><input class = "form-control" type = "email" id = "userEmail" name ="userEmail" maxlength = "20" placeholder = "이메일을 입력하세요" value = "<%=user.getUserEmail() %>"></td>
					</tr>   
					<tr>
						<td style = "text-align: left;" colspan = "3"><h5 style = "color: red;" id = "passwordCheckMessage"></h5><input class = "btn btn-primary pull-right" type = "submit" value = "수정"></td>
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
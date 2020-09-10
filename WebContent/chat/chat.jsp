<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.net.URLDecoder" %>
<%@ page import = "user.UserDAO" %>
<%
	request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
	<%
		String toID = null;
		if(request.getParameter("toID") != null) {
			toID = (String)request.getParameter("toID");
		}
		if(userID == null) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "현재 로그인이 되어 있지 않는 상태입니다.");
			response.sendRedirect("main.jsp");
			return;
		}
		if(toID == null) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "대화 상대가 지정되지 않았습니다.");
			response.sendRedirect("/UserChat/user/find.jsp");
			return;
		}
		if(userID.equals(URLDecoder.decode(toID, "UTF-8"))) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "자기 자신에게는 쪽지를 보낼수 없습니다.");
			response.sendRedirect("/UserChat/user/find.jsp");
			return;
		}
		String fromProfile = new UserDAO().getProfile(userID);
		String toProfile = new UserDAO().getProfile(toID);
	%>
	<script src = "js/bootstrap.js"></script>
	
	<script type = "text/javascript">
		function autoClosingAlert(selector, delay) {
			var alert = $(selector).alert();
			alert.show();
			window.setTimeout(function() { alert.hide() }, delay);
		}
		function submitFunction() {
			var fromID = '<%=userID%>';
			var toID = '<%=toID%>';
			var chatContent = $('#chatContent').val();
			$.ajax({
				type: "POST",
				url: "/UserChat/./chatSubmitServlet",
				data: {
					fromID: fromID,
					toID: toID,
					chatContent: chatContent,
				},
				success: function(result) {
					if(result == 1) {
						autoClosingAlert('#successMessage', 2000);
					}
					else if (result == 0) {
						autoClosingAlert('#dangerMessage', 2000);
					}
					else {
						autoClosingAlert('#warningMessage', 2000);
					}
				}
			});
			$('#chatContent').val(''); // 내용 보냈으니 chatContent는 비워주는 친구.
		}
		
		var lastID = 0;
		
		function chatListFunction(type) {
			var fromID = '<%=userID%>';
			var toID = '<%=toID%>';
			$.ajax({
				type: "POST",
				url: "/UserChat/./chatListServlet",
				data: {
					fromID: fromID,
					toID: toID,
					listType: type
				},
				success: function(data) {
					if(data == "") return;
					var parsed = JSON.parse(data);
					var result = parsed.result;
					for(var i=0; i<result.length; i++) {
						if(result[i][0].value == fromID) {
							result[i][0].value = "나";
						}
						addChat(result[i][0].value, result[i][2].value, result[i][3].value);
					}
					lastID = Number(parsed.last);
				}
			});
		}
		
		function addChat(chatName, chatContent, chatTime) {
			if(chatName == '나') {
				$('#chatList').append('<div class = "row">' +
						'<div class = "col-lg-12">' +
						'<div class = "media">' +
						'<a class = "pull-left" href = "#">' +
						'<img class = "media-object img-circle" style = "width: 30px; height: 30px;" src = "<%=fromProfile%>" alt = "">' +
						'</a>' +
						'<div class = "media-body">' +
						'<h4 class = "media-heading">' +
						chatName +
						'<span class = "small pull-right">' +
						chatTime +
						'</span>' +
						'</h4>' +
						'<p>' +
						chatContent +
						'</p>' +
						'</div>' +
						'</div>' +
						'</div>' +
						'</div>' +
						'<hr>');
			} else {
				$('#chatList').append('<div class = "row">' +
						'<div class = "col-lg-12">' +
						'<div class = "media">' +
						'<a class = "pull-left" href = "#">' +
						'<img class = "media-object img-circle" style = "width: 30px; height: 30px;" src = "<%=toProfile%>" alt = "">' +
						'</a>' +
						'<div class = "media-body">' +
						'<h4 class = "media-heading">' +
						chatName +
						'<span class = "small pull-right">' +
						chatTime +
						'</span>' +
						'</h4>' +
						'<p>' +
						chatContent +
						'</p>' +
						'</div>' +
						'</div>' +
						'</div>' +
						'</div>' +
						'<hr>');
			}
			$('#chatList').scrollTop($('#chatList')[0].scrollHeight);
		}
		function getInfiniteChat() {
			setInterval(function() {
				chatListFunction(lastID);
			}, 3000);
		}
		
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
	<!-- 요기부터 채팅창 -->
	<div class = "container bootstrap snippet">
		<div class = "row">
			<div class = "col-xs-12">
				<div class = "portlet portlet-default">
					<div class = "portlet-heading">
						<div class= "portlet-title">
							<h4><i class = "fa fa-circle text-green"></i>실시간 채팅창</h4>
						</div>
						<div class = "clearfix"></div>
					</div>
					<div id = "chat" class = "panel-collapse collapse in">
						<div id = "chatList" class = "panel-body chat-widget" style = "overflow-y: auto; height: 600px;">
						</div>
						<div class = "portlet-footer">
							<div class = "row" style = "height: 90px;">
								<div class= "form-group col-xs-10">
									<textarea style = "height: 80px;" id = "chatContent" class= "form-control" placeholder = "메시지를 입력하세요." maxlength = "100"></textarea>
								</div>
								<div class = "form-group col-xs-2">
									<button type = "button" class = "btn btn-default pull right" onclick = "submitFunction()">전송</button>
									<div class = "clearfix"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class = "alert alert-success" id = "successMessage" style = "display:none";>
		<strong>메세지 전송에 성공했습니다.</strong>
	</div>
	<div class = "alert alert-danger" id = "dangerMessage" style = "display:none";>
		<strong>이름과 내용을 모두 입력해주세요.</strong>
	</div>
	<div class = "alert alert-warning" id = "warningMessage" style = "display:none";>
		<strong>데이터베이스 오류가 발생했습니다.</strong>
	</div>
	
	<!-- 요기는 팝업 메세지 -->
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
	<!-- 요기까지 팝업 메세지 -->
	<script type = "text/javascript">
		$(document).ready(function() {
			getUnread();
			chatListFunction('0');
			getInfiniteChat();
			getInfiniteUnread();
		});
	</script>
</body>
</html>
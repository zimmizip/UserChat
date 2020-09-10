<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<%
		if(userID == null) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "현재 로그인이 되어 있지 않는 상태입니다.");
			response.sendRedirect("main.jsp");
			return;
		}
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
		function chatBoxFunction() {
			var userID = '<%=userID%>'
			$.ajax ({
				type: "POST",
				url: "/UserChat/./chatBox",
				data: {
					userID: userID,
				},
				success: function(data) {
					if(data == "") return;
					$('#boxTable').html('');
					var parsed = JSON.parse(data);
					var result = parsed.result;
					for(var i=0; i < result.length; i++) {
						if(result[i][0].value == userID) {
							result[i][0].value = result[i][1].value;
						} else {
							result[i][1].value = result[i][0].value;
						}
						addBox(result[i][0].value, result[i][1].value, result[i][2].value, result[i][3].value, result[i][4].value, result[i][5].value);
					}
				}
			});
		}
		function addBox(lastID, toID, chatContent, chatTime, unread, profile) {
			$('#boxTable').append('<tr onclick = "location.href=\'/UserChat/chat/chat.jsp?toID=' + toID + '\'">' +
					'<td style="width: 150px;">' +
					'<img class = "media-object img-circle" style = "margin: 0 auto; max-width: 40px; max-height: 40px" src = "' + profile +'">' +
					'<h5>' + lastID + '</h5></td>' +
					'<td>' +
					'<h5>' + chatContent +
					'<span class = "label label-info">' + unread + '</span></h5>' +
					'<div class = "pull-right">' + chatTime + '</div>' +
					'</td>' +
					'</tr>');
		}
		function getInfiniteBox() {
			setInterval(function() {
				chatBoxFunction();
			}, 3000);
		}
	</script>
</head>
<body>
	<div class ="container">
		<table class = "table" style = "margin: 0 auto;">
			<thead>
				<tr>
					<th><h4>주고받은 메세지 목록</h4></th>
				</tr>
			</thead>
			<div style = "overflow-y: auto; width: 100%; max-height: 450px;">
				<table class ="table table-bordered table-hover" style = "text-align: center; border: 1px solid #dddddd; margin: 0 auto;">
					<tbody id = "boxTable">
					</tbody>
				</table>
			</div>
		</table>
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
				chatBoxFunction();
				getInfiniteBox();
			});
		</script>
	<%
		}
	%>
</body>
</html>
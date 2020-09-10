<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "user.UserDTO" %>
<%@ page import = "user.UserDAO" %>
<%@ page import = "board.BoardDTO" %>
<%@ page import = "board.BoardDAO" %>
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
		String boardID = request.getParameter("boardID");
		if(boardID == null || boardID.equals("")) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "접근 할 수 없습니다..");
			response.sendRedirect("/UserChat/board/boardView.jsp");
			return;
		}
		BoardDAO boardDAO = new BoardDAO();
		BoardDTO board = boardDAO.getBoard(boardID);
		if(!userID.equals(board.getUserID())) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "접근 할 수 없습니다.");
			response.sendRedirect("/UserChat/board/boardView.jsp");
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
		<form method = "post" action = "/UserChat/./boardUpdate" enctype = "multipart/form-data">
			<table class = "table table-bordered table-hover" style = "text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan = "2"><h4>게시물 수정 양식</h4></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style = "width: 110px;"><h5>아이디</h5></td>
						<td><h5><%=user.getUserID() %>
						</h5>
						<input type = "hidden" name = "userID" value = "<%=user.getUserID() %>">
						<input type = "hidden" name = "boardID" value = "<%=boardID %>"></td>
					</tr>
					<tr>
						<td style = "width: 110px;"><h5>글 제목</h5></td>
						<td><input class = "form-control" type = "text" maxlength = "50" name = "boardTitle" value = "<%=board.getBoardTitle()%>" placeholder = "제목을 입력하세요."></td>
					</tr>
					<tr>
						<td style = "width: 110px;"><h5>글 내용</h5></td>
						<td><textarea class = "form-control" rows = "10" name = "boardContent" maxlength = "2000" placeholder = "글 내용을 입력하세요."><%=board.getBoardContent()%></textarea></td>
					</tr>
					<tr>
						<td style = "width: 110px;"><h5>파일 업로드</h5></td>
						<td colspan = "2">
							<input type = "file" name = "boardFile" class = "file">
							<div class = "input-group col-xs-12">
								<span class ="input-group-addon"><i class = "glyphicon glyphicon-picture"></i></span>
								<input type = "text" class = "form-control input-lg" disabled placeholder = "<%=board.getBoardFile()%>">
								<span class = "input-group-btn">
									<button class ="browse btn btn-primary input-lg" type = "button"><i class = "glyphicon glyphicon-search"></i>파일 찾기</button>
								</span> 
							</div>
						</td>
					</tr>
					<tr>
						<td style = "text-align: left;" colspan = "3"><h5 style = "color: red;"></h5><input class = "btn btn-primary pull-right" type = "submit" value = "수정"></td>
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
	<script type = "text/javascript">
		$(document).on('click', '.browse', function() {
			var file = $(this).parent().parent().parent().find('.file');
			file.trigger('click');
		});
		$(document).on('change', '.file', function() {
			$(this).parent().find('.form-control').val($(this).val().replace(/C:\\fakepath\\/i, ''));
		});
	</script>
</body>
</html>
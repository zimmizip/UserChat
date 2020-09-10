<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "board.BoardDAO" %>
<%@ page import = "board.BoardDTO" %>
<!DOCTYPE html>
<html>
	<%
		if(userID == null) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "현재 로그인이 되어 있지 않는 상태입니다.");
			response.sendRedirect("main.jsp");
			return;
		}
		String boardID = null;
		if(request.getParameter("boardID") != null) {
			boardID = (String)request.getParameter("boardID");
		}
		if(boardID == null || boardID.equals("")) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "게시물을 선택해주세요.");
			response.sendRedirect("/UserChat/board/boardView.jsp");
			return;
		}
		BoardDAO boardDAO = new BoardDAO();
		BoardDTO board = boardDAO.getBoard(boardID);
		if(board.getBoardAvailable() == 0) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "삭제된 게시물입니다.");
			response.sendRedirect("/UserChat/board/boardView.jsp");
			return;
		}
		boardDAO.hit(boardID);
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
		<table class = "table table-bordered table-hover" style = "text-align: center; border: 1px solid #dddddd">
			<thead>
				<tr>
					<th colspan = "4"><h4>게시물 확인</h4></th>
				</tr>
				<tr>
					<td style = "background-color: #fafafa; color: #000000; width: 80px;"><h5>제목</h5></td>
					<td colspan = "3"><h5><%=board.getBoardTitle() %></h5></td>
				</tr>
				<tr>
					<td style = "background-color: #fafafa; color: #000000; width: 80px;"><h5>작성자</h5></td>
					<td colspan = "3"><h5><%=board.getUserID() %></h5></td>
				</tr>
				<tr>
					<td style = "background-color: #fafafa; color: #000000; width: 80px;"><h5>작성날짜</h5></td>
					<td><h5><%=board.getBoardDate() %></h5></td>
					<td style = "background-color: #fafafa; color: #000000; width: 80px;"><h5>조회수</h5></td>
					<td><h5><%=board.getBoardHit() + 1 %></h5></td>
				</tr>
				<tr>
					<td style = "vertical-align: middle; min-height: 150px; background-color: #fafafa; color: #000000; width: 80px;"><h5>글 내용</h5></td>
					<td colspan = "3" style = "text-align: left;"><h5><%=board.getBoardContent() %></h5></td>
				</tr>
				<tr>
					<td style = "background-color: #fafafa; color: #000000; width: 80px;"><h5>첨부파일</h5></td>
					<td colspan = "3">
						<h5>
							<a href = "/UserChat/board/boardDownload.jsp?boardID=<%=board.getBoardID() %>" style = "color: #000000"><%= board.getBoardFile() %></a>
						</h5>
					</td>
				</tr>
				<tr>
					<td style = "background-color: #fafafa; color: #000000; width: 80px;"><h5>파일내용</h5></td>
					<td colspan = "3" style = "text-align: center;"><img style = "max-width: 500px; margin: 0 auto;" src = "http://localhost:8089/UserChat/upload/<%=board.getBoardFile() %>"></td>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td colspan = "5" style = "text-align: right;">
						<a href = "/UserChat/board/boardView.jsp" class = "btn btn-primary">목록</a>
						<a href = "/UserChat/board/boardReply.jsp?boardID=<%= board.getBoardID()%>" class = "btn btn-primary">답변</a>
						<button type = "button"  class ="btn btn-primary">댓글 달기</button>&nbsp;&nbsp;
						<%
							if(userID.equals(board.getUserID())) {
						%>
							<a href = "/UserChat/board/boardUpdate.jsp?boardID=<%= board.getBoardID()%>" class = "btn btn-primary">수정</a>
							<a href = "/UserChat/board/boardDelete?boardID=<%= board.getBoardID()%>" class = "btn btn-primary" onClick = "return confirm('정말로 삭제하시겠습니까?')">삭제</a>
						<%							
							}
						%>
					</td>
				</tr>
			</tbody>
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
			});
		</script>
	<%
		}
	%>
</body>
</html>
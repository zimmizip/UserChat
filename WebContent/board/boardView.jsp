<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "board.BoardDAO" %>
<%@ page import = "board.BoardDTO" %>
<%@ page import = "java.util.ArrayList" %>
<!DOCTYPE html>
<html>
	<%
		if(userID == null) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "현재 로그인이 되어 있지 않는 상태입니다.");
			response.sendRedirect("main.jsp");
			return;
		}
		String pageNumber = "1";
		if(request.getParameter("pageNumber") != null) {
			pageNumber = request.getParameter("pageNumber");
		}
		try {
			Integer.parseInt(pageNumber);
		} catch(Exception e) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "페이지 번호가 잘못 되었습니다.");
			response.sendRedirect("/UserChat/board/boardView.jsp");
			return;
		}
		ArrayList<BoardDTO> boardList = new BoardDAO().getList(pageNumber);
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
					<th colspan = "5"><h4>연애 상담 게시판</h4></th>
				</tr>
				<tr>
					<th style = "background-color: #fafafa; color: #000000; width: 70px;"><h5>번호</h5></th>
					<th style = "background-color: #fafafa; color: #000000;"><h5>제목</h5></th>
					<th style = "background-color: #fafafa; color: #000000; width: 100px;"><h5>작성자</h5></th>
					<th style = "background-color: #fafafa; color: #000000; width: 100px;"><h5>작성 날짜</h5></th>
					<th style = "background-color: #fafafa; color: #000000; width: 70px;"><h5>조회수</h5></th>
				</tr>
			</thead>
			<tbody>
			<%
				for(int i=0; i<boardList.size(); i++) {
					BoardDTO board = boardList.get(i);
			%>
				<tr>
					<td><%=board.getBoardID() %></td>
					<td style = "text-align: left;">
					<a href = "/UserChat/board/boardShow.jsp?boardID=<%=board.getBoardID() %>" style = "color: #000000">
			<%
				for(int j=0; j<board.getBoardLevel(); j++) {
			%>
					<span class = "glyphicon glyphicon-arrow-right" aria-hidden = "true"></span>
			<%
				}
			%>
			<%
				if(board.getBoardAvailable() == 0) {
			%>
				(삭제된 게시물입니다.)
			<%
				} else {
			%>
					<%=board.getBoardTitle() %></a></td>
			<%
				}
			%>
					<td><%=board.getUserID() %></td>
					<td><%=board.getBoardDate() %></td>
					<td><%=board.getBoardHit() %></td>
				</tr>
			<%
				}
			%>
				<tr>
					<td colspan = "5">
						<a href = "/UserChat/board/boardWrite.jsp" class = "btn btn-primary pull-right" type = "submit">글쓰기</a>
						<ul class = "pagination" style = "margin: 0 auto;">
					<%
						int startPage = (Integer.parseInt(pageNumber) / 10) * 10 + 1;
						if(Integer.parseInt(pageNumber) % 10 == 0) startPage -= 10;
						int targetPage = new BoardDAO().targetPage(pageNumber);
						if(startPage != 1) {
					%>
						<li><a href = "/UserChat/board/boardView.jsp?pageNumber=<%=Integer.parseInt(pageNumber) - 1 %>"><span class = "glyphicon glyphicon-chevron-left"></span></a></li>
					<%
						} else {
					%>
							<li><span class = "glyphicon glyphicon-chevron-left" style = "color: gray;"></span></li>
					<%		
						}
						for(int i=startPage; i<Integer.parseInt(pageNumber); i++) {
					%>
							<li><a href = "/UserChat/board/boardView.jsp?pageNumber=<%=i %>"><%=i %></a></li>
					<%
						}
					%>
						<li class = "active"><a href = "/UserChat/board/boardView.jsp?pageNumber=<%=pageNumber %>"><%=pageNumber %></a></li>
					<%
						for(int i = Integer.parseInt(pageNumber) + 1; i<=targetPage + Integer.parseInt(pageNumber); i++) {
							if(i < startPage + 10) {
					%>
						<li><a href = "/UserChat/board/boardView.jsp?pageNumber=<%= i %>"><%=i %></a></li>
					<%		
							}
						}
						if(targetPage + Integer.parseInt(pageNumber) > startPage + 9) {
					%>
						<li><a href = "/UserChat/board/boardView.jsp?pageNumber=<%= startPage + 10 %>"><span class = "glyphicon glyphicon-chevron-right"></span></a></li>
					<%
						} else {
					%>
						<li><span class = "glyphicon glyphicon-chevron-right" style = "color: gray;"></span></li>
					<%
						}
					%>
						</ul>
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
<%@page import="java.util.Vector"%>
<%@page import="user.UserDAO"%>
<%@page import="user.UserDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="mMgr" class="user.UserDAO"/>
<!DOCTYPE html>
<html>
<%
		request.setCharacterEncoding("UTF-8");
		String id =request.getParameter("id");
		String button=(String)session.getAttribute("button");
		UserDTO user=mMgr.userInfo(id);
		
		boolean check=mMgr.checkid(userID,id);		//이미 좋아요를 누른 사람인지 아닌지 확인
		boolean heartcheck=false;
		if(check){			//이미 좋아요를 누른 사람이 아닐 경우	
			heartcheck=mMgr.checkid(id,userID);//내가 좋아요를 누른 사람이 나를 좋아요 눌렀는지 체크	
		}
	%>
<head>
</head>
<body>
	<div class = "container">
		<form method = "post" action = "/UserChat/userProc.jsp">
			<table class = "table table-bordered table-hover" style = "text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan = "2"><h4><%=user.getUserID() %>님의 정보</h4></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style = "width: 110px;"><h5>아이디</h5></td>
						<td style = "width: 440px;"><h5>
							<%=user.getUserID() %>
						</h5>
						<input type = "hidden" name = "id" value = "<%=user.getUserID() %>"></td>
					</tr>				
					<tr>
						<td style = "width: 110px;"><h5>이름</h5></td>
						<td style = "width: 440px;"><%=user.getUserName() %></td>
					</tr>
					<tr>
						<td style = "width: 110px;"><h5>나이</h5></td>
						<td style = "width: 440px;"><%=user.getUserAge() %></td>
					</tr>
					<tr>
						<td style = "width: 110px;"><h5>성별</h5></td>
						<td style = "width: 440px;">
							<div class = "form-group" style = "text-algin: center; margin: 0 auto;">
								<div class = "btn-group" data-toggle = "buttons">
									 <%= user.getUserGender() %>									
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<td style = "width: 110px;"><h5>이메일</h5></td>
						<td style = "width: 440px;"><%=user.getUserEmail() %></td>
					</tr>   
					<% if(!button.equals("내가 좋아요 누른 사람")) {		//버튼이 '나를 좋아요 누른 사람'일 경우 '좋아요 취소'는 존재할 수 없고 '좋아요 누르기'만 존재하므로
					%>
						<tr>
							<td colspan=2><input class = "btn btn-primary pull-center" type="submit" name=heart value="좋아요 누르기"/></td>
						</tr>
					<%}%>
					<% if(button.equals("내가 좋아요 누른 사람")){		//버튼이 '내가 좋아요 누른 사람'일 경우 '좋아요 누르기'는 존재할 수 없고 '좋아요 취소'만 존재하므로
					%>
						<tr>
							<td colspan=2><input class = "btn btn-primary pull-center" type = "button" name=heart value = "좋아요 취소" onclick="location.href='/UserChat/deleteProc.jsp?id=<%=user.getUserID()%>'"/></td>
						</tr>
					<%}%>
					<%if(heartcheck){	//내가 좋아요를 누른 상대가 나를 좋아요 누른 경우  
					%>	
						<tr>		
							<td colspan=2><input class = "btn btn-primary pull-center" type = "button"  value = "채팅으로 이동..?" onclick = "location.href ='/UserChat/chat/chat.jsp?toID=<%=user.getUserID()%>'" /></td>
						</tr>
					<%} %>
					<tr>		
						<td colspan=2><input class = "btn btn-primary pull-center" type = "button" name=heart value = "성향 확인하기"  onclick="location.href='/UserChat/poll/checktype.jsp?id=<%=user.getUserID()%>'"/></td>				
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
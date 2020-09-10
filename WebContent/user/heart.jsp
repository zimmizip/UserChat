<%@page import="java.util.Vector"%>
<%@page import="user.UserDAO"%>
<%@page import="user.UserDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="bean" class="user.UserDTO"/>
<jsp:useBean id="mMgr" class="user.UserDAO"/>    
<!DOCTYPE html>
<html>
<%
		if(userID == null) {
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "현재 로그인이 되어 있지 않는 상태입니다.");
			response.sendRedirect("main.jsp");
			return;
		}

		String heart=(String)session.getAttribute("heart");	 //userinfo 와 userProc 에서도 사용	
		String button=(String)session.getAttribute("button");//내가 좋아요 누른 사람 or 나를 좋아요 누른 사람 버튼
		Vector<UserDTO> heartlist=new Vector<UserDTO>();
		if(button==null || button.equals("내가 좋아요 누른 사람")){		
			heartlist=mMgr.fromheartList(userID,"내가 좋아요 누른 사람");		// 처음 heartlist는 내가 좋아요 누른 사람으로 세팅
		}else if(button.equals("서로 좋아요")){		//서로 좋아요 버튼을 누를 경우
			heartlist=mMgr.fromheartList(userID,"서로 좋아요");
		}else{
			heartlist=mMgr.fromheartList(userID,button);	//내가 좋아요 누른 사람 일 경우의 heartlist
		}
	%>
<head>
	<script type = "text/javascript">
			function getUnread() {
			$.ajax ({
				type: "POST",
				url: "/UserChat/./chatUnread",
				data: {
					userID: encodeURIComponent('%=userID%>'),
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
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div class = "container">
		<form method = "post" action="/UserChat/heartProc.jsp">
			<table class = "table table-bordered table-hover" style = "text-align: center; border: 1px solid #dddddd">
				<tr>
					<td style = "text-align: center;" ><input class = "btn btn-primary pull-center" type = "submit" name=button value = "내가 좋아요 누른 사람"></td>
					<td style = "text-align: center;" ><input class = "btn btn-primary pull-center" type = "submit" name=button value = "나를 좋아요 누른 사람"></td>
					<td style = "text-align: center;" ><input class = "btn btn-primary pull-center" type = "submit" name=button value = "서로 좋아요"></td>
				</tr>
		  	<%if(heart!=null){ %>			<!-- heart에 세션 값이 담길 경우 list 출력 -->
		  	<% 
		  		for(int i=0;i<heartlist.size();i++){
		  			UserDTO mbean=heartlist.get(i);
		  	%>
		  	<tr>
		  		<td colspan=3 height="300" ><img style = "height: 400px; width: 400px;"src="http://localhost:8089/UserChat/upload/<%=mbean.getUserProfile() %>" onclick="location.href='/UserChat/user/userInfo.jsp?id=<%=mbean.getUserID()%>'"></td> 	  		
			</tr>
			<tr>
				<td colspan=3><input type="button" name="id" value="<%=mbean.getUserID()%>" onclick="location.href='/UserChat/user/userInfo.jsp?id=<%=mbean.getUserID()%>'"></td>
			</tr>
		<%} %>
	  </table> 
	 <%}%>
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
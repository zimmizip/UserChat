<%@page import="poll.ExplainDTO"%>
<%@page import="java.util.Vector"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="pMgr" class="poll.PollDAO"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%
		Vector<ExplainDTO> resultlist=pMgr.mytestlist(userID); //session에 담겨 있는 아이디
		
	%>
	</head>
	<body>
	<div class = "container">
			<div style="background-color:white; height:1000px";>
				<h3 align="center"> 테스트 결과 </h3>
				<%
					for(int i=0;i<resultlist.size();i++){
						ExplainDTO bean=resultlist.get(i);	
					
				%>	
				<div class ="dropdown">
					
					<h3 href = "#" class= "dropdown-toggle"
						data-toggle = "dropdown" role = "button" aria-haspopup = "true"
						aria-expanded = "false"><%=i+1%>.<%=bean.getQuestion() %><span class = "caret"></span>
					</h3>
					<div class = "dropdown-menu" >
						<h4> 내가 고른 답: <%=bean.getAnswer() %></h4>
						<h4> 해석: "<label style="text-color:red";><%=bean.getContent() %></label> "으로 <%=bean.getExplain() %> </h4>
					</div>
				</div>
				<%}%>
				<h2></h2><input class = "btn btn-primary "  type="button" onclick="location.href='/UserChat/index.jsp'" value="돌아가기" >
			</div>
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
	<script>
		$('#messageModal').modal("show");
	</script>
	<%
		session.removeAttribute("messageContent");
		session.removeAttribute("messageType");
		}
	%>
	<div class = "modal fade" id = "checkModal" tabindex = "-1" role = "dialog" aria-hidden = "true">
		<div class = "vertical-alignment-helper">
			<div class = "modal-dialog vertical-align-center">
				<div id = "checkType" class = "modal-content panel-info">
					<div class = "modal-header panel-heading">
						<button type = "button" class= "close" data-dismiss = "modal">
							<span aria-hidden = "true">&times</span>
							<span class = "sr-only">Close</span>
						</button>
						<h4 class = "modal-title">
							확인 메세지
						</h4>
					</div>
					<div id = "checkMessage" class = "modal-body">
					</div>
					<div class = "modal-footer">
						<button type = "button" class = "btn btn-primary" data-dismiss = "modal">확인</button>
					</div>
				</div>
			</div>
		</div>
	</div>
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
</body>
</html>
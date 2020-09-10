<%@page import="poll.ExplainDTO"%>
<%@page import="poll.PollListDTO"%>
<%@page import="java.util.List"%>
<%@page import="user.UserDTO"%>
<%@page import="java.util.Vector"%>
<jsp:useBean id="bean" class="user.UserDTO"/>
<jsp:useBean id="Mgr" class="user.UserDAO"/>
<jsp:useBean id="pbean" class="poll.PollItemDTO"/>
<jsp:useBean id="pMgr" class="poll.PollDAO"/>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
	<%
		request.setCharacterEncoding("UTF-8");
	%>
	<%
	int num=0;		//num=14를 pollTestProc에서 받아와서 이를 사용하기 위한 변수(14가 1번입니다...)
	if(!(request.getParameter("num")==null || request.getParameter("num").equals(""))){
		num=Integer.parseInt(request.getParameter("num"));
	}
	
	PollListDTO plBean=pMgr.getList(num);		//14번에 해당하는 문제 정보를 가져와 plBean에 넣음
	Vector<String> vlist=pMgr.getItem(num);		//14번에 해당하는 문제와 보기를 vlist에 넣음
	String question=plBean.getQuestion();		//14번에 해당하는 question

	%>	
<head>
	<script type = "text/javascript">
		function getUnread() {
			$.ajax ({
				type: "POST",
				url: "/UserChat/./chatUnread",
				data: {
					userID: <%=userID%>,
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

	<!-- 요기까지가 header -->
	<!-- 요기부터 메인바디 -->
	
       <div class="container">
       <%if(question !=null){ %>
		<form method="post" action="/UserChat/pollFormProc.jsp">
			<table class = "table table-bordered table-hover" style = "text-align: center;" >
					<thead>
					<tr>
						<th colspan = "2"><h4><%=question %></h4></th>
					</tr>
				</thead>
					<tr >
						<td colspan="2" height=100px>
						<% 
							for(int i=0;i<vlist.size();i++){
								String itemList=vlist.get(i);	
						%>
								<%-- out.println("<input type=radio  name='itemnum' value='"+i+"' onclick=location.href='/UserChat/pollFormProc.jsp?num='>" );
								out.println(itemList+"<br>"); --%>
								<input type=radio  name='itemnum' value=<%=i%>><%=itemList%><br>
						<%}
						%>
						</td>
					</tr>
					<tr align=center colspan=2>
						<td>
						<%
								out.println("<input type='submit' class = 'btn btn-primary pull-center' value='투표'>");
						%>
						</td>					
					</tr>
			</table>
	<input type="hidden" name="num" value="<%=num %>">	
	</form>
	<%}else{ %>
		<div class="container">
		<form method="post" action="pollTestResult.jsp">
			<table class = "table table-bordered table-hover" style = "text-align: center;">
				<thead>
					<tr>
						<th colspan = "2"><h4>수고하셨습니다</h4></th>
					</tr>
				</thead>
				<tr>
					<td align="center"><input class = "btn btn-primary pull-center"  type="submit" value="결과보기" ></td>
				</tr>
			</table>
		</form>
		</div>
		<%} %>
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
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="pMgr" class="poll.PollDAO"/>
<!DOCTYPE html>
<% 
	String userid=(String)session.getAttribute("userID");
	boolean pollcheck=pMgr.testCheck(userid);		//심리테스트에 참여하였는지 확인
	String url="";
	String msg="";
	if(userid==null){									
		msg="로그인을 먼저 해주세요";
		url="/UserChat/poll/polllist.jsp";	
	}else if(pollcheck){							
		msg="이미 테스트를 진행하였습니다";
		url="/UserChat/poll/polllist.jsp";	
	}else if(userid!=null && !pollcheck){ 	
		msg="시~작~!";
		url="/UserChat/poll/pollForm.jsp?num=14";
	}
%>

	<script>
		alert("<%=msg%>");
		location.href="<%=url%>";
	</script>
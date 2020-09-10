<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="pMgr" class="poll.PollDAO"/>

<meta charset="UTF-8">
<% 
	
	request.setCharacterEncoding("UTF-8");
	String userID = (String)session.getAttribute("userID");
	int num=Integer.parseInt(request.getParameter("num"));
	String[] itemnum=request.getParameterValues("itemnum");
	boolean result=pMgr.insertUserPoll(userID,num,itemnum);	//사용자의 응답 정보에 질문과 질문에 대한 응답번호를 DB에 넣음
	num+=1;
	String msg="투표가 등록되지 않습니다";
	if(result){
		msg="투표가 정상적으로 등록되었습니다";
	}
%>

<script>
	location.href="/UserChat/poll/pollForm.jsp?num=<%=num%>";
</script>
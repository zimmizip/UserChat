<%@page import="user.UserDTO"%>
<%@page import="poll.ExplainDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="poll.PollItemDTO"%>
<%@page import="java.util.Vector"%>
<jsp:useBean id="pMgr" class="poll.PollDAO"></jsp:useBean>
<jsp:useBean id="uMgr" class="user.UserDAO"></jsp:useBean>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="ie=edge">
<title>부트스트랩 차트그리기</title>

<!-- 차트 링크 -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>
<%
	String id=request.getParameter("id");
	
	UserDTO myinfo=uMgr.userInfo(userID);	//사용자의 정보
	UserDTO opinfo=uMgr.userInfo(id);		//상대방의 정보
	
	Vector<PollItemDTO> typeuserlist=pMgr.typelist(userID);	//사용자의 심리테스트 결과를 가져옴
	Vector<PollItemDTO> typelist=pMgr.typelist(id);  //상대방의 심리테스트 결과를 가져옴
	int[] userword=new int[typeuserlist.size()];	
	int[] word=new int[typelist.size()];
	

	
	String msg="";
	if(typeuserlist.size()!=0){
		 userword=pMgr.showitem(typeuserlist);	//사용자의 정답번호를 userword에 저장
	}else{
		msg="심리테스트를 먼저  진행해 주세요";
	}
	if(typelist.size()!=0){
		 word=pMgr.showitem(typelist);			//상대방의 정답번호를 word에 저장
	}else{
		msg="상대방이 심리테스트를 진행하지 않았습니다";
	}
	
	Vector<ExplainDTO> compare=new Vector<ExplainDTO>();	//정답 비교를 하기 위한 compare Vector 선언
	int num=14;	
	int count=0;	//다른 문항 개수를 세기 위한 변수
	double result=0;
	if(typeuserlist.size()!=0 &&typelist.size()!=0){	//둘 다 심리테스트를 진행하였을 경우
		for(int i=0;i<typeuserlist.size();i++){
			ExplainDTO bean=new ExplainDTO();
			if(userword[i]!=word[i]){	//사용자와 상대방의 정답이 다를 경우
				count++;
				compare.add(pMgr.comparelist(num,id));		//상대방과 사용자의 정답이 다른 문항(num)을 상대방 기준으로 출력하게 함
				
			}
			num++;
		}
		
		
	result=(double)(typeuserlist.size()-count)/typeuserlist.size()*100;		//상대방과 나의 일치하는 문항의 퍼센트 출력
	result=Math.round(result);
	}
%>
</head>
<body>

		<%
		if(typeuserlist.size()==0 ||typelist.size()==0){	//상대방이나 내가 테스트를 진행하지 않았을 경우
		%>
		<table class = "table table-bordered table-hover" style = "text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan = "2"><h4><%=msg %></h4></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><input type=button class = "btn btn-primary pull-right" value="돌아가기" onclick="location.href='/UserChat/user/userInfo.jsp?id=<%=id%>'"></td>
					</tr>
				</tbody>
		</table>		
		<%}else if(typeuserlist.size()!=0&& typelist.size()!=0){%>
		
		
   <div class="container">
      <canvas id="myChart"></canvas>
   </div>
   <!-- 부트스트랩 -->
   <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
      integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
      crossorigin="anonymous"></script>
   <script
      src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
      integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
      crossorigin="anonymous"></script>
   <script
      src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
      integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
      crossorigin="anonymous"></script>
   <!-- 차트 -->
   <script>
      var ctx = document.getElementById('myChart');
      var myChart = new Chart(ctx,
            {
               type : 'bar',
               data : {
                  labels : [ '1번', '2번', '3번', '4번', '5번','6번','7번','8번','9번','10번','11번','12번'],
                  datasets : [ {  
                	  label:'<%=userID%>',
                     data : [ <%=userword[0]%>,<%=userword[1]%>,<%=userword[2]%>,<%=userword[3]%>,<%=userword[4]%>,
                    	 <%=userword[5]%>,<%=userword[6]%>,<%=userword[7]%>,<%=userword[8]%>,<%=userword[9]%>,
                    	 <%=userword[10]%>,<%=userword[11]%>,],
                     backgroundColor : [ 'rgba(255, 99, 132, 0.2)',
                           'rgba(54, 162, 235, 0.2)',
                           'rgba(255, 206, 86, 0.2)',
                           'rgba(75, 192, 192, 0.2)',
                           'rgba(153, 102, 255, 0.2)',
                           'rgba(255, 159, 64, 0.2)', 
                           'rgba(100, 200, 64, 0.2)', 
                           'rgba(80, 100, 64, 0.2)' ,
                           'rgba(255, 159, 64, 0.2)' ,
                           'rgba(200, 159, 30, 0.2)',
                           'rgba(150, 10, 130, 0.2)',
                           'rgba(50, 40, 30, 0.2)'],
                     borderColor : [ 'rgba(255, 99, 132, 1)',
                           'rgba(54, 162, 235, 1)',
                           'rgba(255, 206, 86, 1)',
                           'rgba(75, 192, 192, 1)',
                           'rgba(153, 102, 255, 1)',
                           'rgba(255, 159, 64, 1)',
                           'rgba(100, 200, 64, 0.2)' ,
                           'rgba(80, 100, 64, 0.2)' ,
                           'rgba(255, 159, 64, 0.2)' ,
                           'rgba(200, 159, 30, 0.2)',
                           'rgba(150, 10, 130, 0.2)',
                           'rgba(50, 40, 30, 0.2)'],
                     borderWidth : 1
                  },
                  { 
                	  label:'<%=id%>',
                	  data : [ <%=word[0]%>,<%=word[1]%>,<%=word[2]%>,<%=word[3]%>,<%=word[4]%>,
                 	 <%=word[5]%>,<%=word[6]%>,<%=word[7]%>,<%=word[8]%>,<%=word[9]%>,
                 	 <%=word[10]%>,<%=word[11]%>,],
                 	backgroundColor : [ 'rgba(255, 99, 132, 0.2)',
                        'rgba(54, 162, 235, 0.2)',
                        'rgba(255, 206, 86, 0.2)',
                        'rgba(75, 192, 192, 0.2)',
                        'rgba(153, 102, 255, 0.2)',
                        'rgba(255, 159, 64, 0.2)', 
                        'rgba(100, 200, 64, 0.2)', 
                        'rgba(80, 100, 64, 0.2)' ,
                        'rgba(255, 159, 64, 0.2)' ,
                        'rgba(200, 159, 30, 0.2)',
                        'rgba(150, 10, 130, 0.2)',
                        'rgba(50, 40, 30, 0.2)'],
                  borderColor : [ 'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(153, 102, 255, 1)',
                        'rgba(255, 159, 64, 1)',
                        'rgba(100, 200, 64, 0.2)' ,
                        'rgba(80, 100, 64, 0.2)' ,
                        'rgba(255, 159, 64, 0.2)' ,
                        'rgba(200, 159, 30, 0.2)',
                        'rgba(150, 10, 130, 0.2)',
                        'rgba(50, 40, 30, 0.2)'],
                  borderWidth : 1
                  
                  
                  
                  }
                  ]
               },
               
               
               
               options : {
                  scales : {
                     yAxes : [ {
                        ticks : {
                           beginAtZero : true
                        }
                     } ]
                  }
               }
            });
   </script>
   <div class = "container">
		<div class = "nav navbar-nav navbar-left" style="background-color:white; height:1000px";>
			<table>
				<tr style="align: center; width:100%">
					<td style="align: center; width:20%"></td>
					<td style="align: center; width:20%"><img class = "media-object img-circle" style = "max-width: 100px;  margin: 0 auto;" src = <%=request.getContextPath()%>/upload/<%=myinfo.getUserProfile()%>></td>
					<td style="align: center; width:20%"><h2 align="center"> <%=id %>님과 <label><%=result %>%</label> 일치합니다 </h2></td>
					<td style="align: center; width:20%"><img class = "media-object img-circle" style = "max-width: 100px; margin: 0 auto;" src = <%=request.getContextPath()%>/upload/<%=opinfo.getUserProfile()%>></td>
					<td style="align: center; width:20%"></td>
				</tr>
			</table>	
				<h4 align="center" > 일치하지 않는 문항</h4>
				<br>
				<%
					for(int i=0;i<compare.size();i++){
						ExplainDTO bean=compare.get(i);	
					
				%>	
				
					
					<div class ="dropdown" >
						
						<h4 href = "#" class= "dropdown-toggle"
							data-toggle = "dropdown" role = "button" aria-haspopup = "true"
							aria-expanded = "false"><%=bean.getListnum()-13%>.  <%=bean.getQuestion() %><span class = "caret"></span>
						</h4>
						<div class = "dropdown-menu" >
							<h4> <%=id%> 님이 고른 답: <label><%=bean.getAnswer() %></label></h4>
							<h4> 해석: "<label><%=bean.getContent() %></label> "으로 <%=bean.getExplain() %> </h4>
						</div>
					</div>
					<br>
				<%}%>
			</div>
	</div>
	  <%} %>
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

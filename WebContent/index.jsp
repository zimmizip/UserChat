<%@page import="user.UserDAO"%>
<%@page import="user.UserDTO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="mgr" class="chart.ChartDAO" />    
<!DOCTYPE html>
<html>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null) {
			userID = (String)session.getAttribute("userID");
		}
		
		
		String userGender = (String)session.getAttribute("userGender");
		String userAge = request.getParameter("userAge");
		
		String[] genderCount = mgr.countGender();
		String[] ageCount = mgr.countAge(); 
		
		ArrayList<UserDTO> userList = new UserDAO().getGenderList(userGender);
		ArrayList<UserDTO> topList = new UserDAO().getTopList(userGender);
	%>
<head>
	<meta charset="UTF-8">
	<meta name = "viewport" content = "width = device-width, initial-scale=1">
	<link rel = "stylesheet" href = "/UserChat/css/bootstrap.css">
	<link rel = "stylesheet" href = "/UserChat/css/custom.css">
	<link rel = "stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
	<link rel = "stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
	<title>지금 당장 만나</title>
	<script src = "https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src = "/UserChat/js/bootstrap.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>
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
	<style>
		#a{border:1px solid black;with:300px;height:300px;}
	</style>
</head>
<body>
<!-- 요기부터 header -->
	<nav class ="navbar navbar-default">
		<div class ="navbar-header">
			<button type = "button" class = "navbar-toggle collapsed"
				data-toggle = "collapse" data-target = "#bs-example-navbar-collapse-1"
				aria-expanded = "false">
				<span class = "icon-bar"></span>
				<span class = "icon-bar"></span>
				<span class = "icon-bar"></span>
			</button>
			<a class = "navbar-brand" href = "index.jsp">지금 당장 만나</a>
		</div>
		<div class = "collapse navbar-collapse" id = "bs-example-navbar-collapse-1">
			<ul class = "nav navbar-nav">
				<li class = "active"><a href = "index.jsp">메인</a>
				<li><a href = "/UserChat/user/find.jsp">친구찾기</a></li>
				<li><a href = "/UserChat/chat/box.jsp">메세지함<span id = "unread" class = "label label-info"></span></a></li>
				<li><a href = "/UserChat/board/boardView.jsp">연애상담 게시판</a>
				<li><a href = "/UserChat/map/insertAddress.jsp">주변 이성 찾기</a>
				<li><a href = "/UserChat/datec/datec.jsp">데이트 추천</a>
				<li><a href = "/UserChat/poll/polllist.jsp">심리 테스트</a>
			</ul>
			<ul class = "nav navbar-nav navbar-right">
				<li class ="dropdown">
					<a href = "#" class= "dropdown-toggle"
						data-toggle = "dropdown" role = "button" aria-haspopup = "true"
						aria-expanded = "false">회원관리<span class = "caret"></span>
					</a>
					<ul class = "dropdown-menu">
						<li><a href = "/UserChat/user/update.jsp">회원정보 수정</a></li>
						<li><a href = "/UserChat/user/profileUpdate.jsp">프로필 수정</a></li>
						<li><a href = "/UserChat/logoutAction.jsp">로그아웃</a></li>
						<li><a href="/UserChat/user/mypage.jsp">내 정보</a></li>
						<li><a href="/UserChat/user/leave.jsp">회원탈퇴</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</nav>
	<!-- 요기까지가 header -->
	<style type = "text/css">
		.jumbotron {
			background-color: white;
		}
	</style>
	<div class = "container">
		<div class = "jumbotron">
			<h2 style = "text-align: center; font-family: Hanna;">마음에 드는 이성에게 좋아요를 눌러주세요~!</h2><br>
			<div class="w3-row">
				<%
					int cnt = 0;
					for(int i=0; i<3; i++) {
				%>
					<div class="w3-third">
					<%
						for(int j=0; j<3; j++) {
							UserDTO user = userList.get(cnt);
					%>
						<img src = "http://localhost:8089/UserChat/upload/<%=user.getUserProfile() %>" style="height: 350px; width: 350px;"
							onclick = "window.open('selectUser.jsp?toID=<%=user.getUserID() %>','좋아요를 눌러주세요','width=600,height=600,location=no,status=no,scrollbars=yes');">
					<%
							cnt++;
						}
					%>
					</div>
				<%
					}
				%>
			  </div>
			  <div id = "addList">
			  </div>
			  <div>
			  	<br>
			  	<p class= "text-center"><a href = "index.jsp" class = "btn btn-primary btn-lg">새로고침</a></p>
			  </div>
		</div>
	</div>
	<hr style = "border: 0; height: 2px; background: #006DCC"/>
	<div class = "container">
		<div class = "jumbotron">
			<h2 style = "text-align: center; font-family: Hanna;">인기 많으신 분들</h2><br>
			<table class = "table table-bordered table-hover" style = "text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan = "3"><h4>좋아요 top4</h4></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>
						<%
							for(int i=0; i<topList.size(); i++) {
								UserDTO top3 = topList.get(i);
						%>
								<img src = "http://localhost:8089/UserChat/upload/<%=top3.getUserProfile() %>" style="height: 350px; width:350px;"
									onclick = "window.open('selectUser.jsp?toID=<%=top3.getUserID() %>','좋아요를 눌러주세요','width=600,height=600,location=no,status=no,scrollbars=yes')">
						<%
							}
						%>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<hr style = "border: 0; height: 2px; background: #006DCC"/>
	<div class = "container">
		<div class = "jumbotron">
			<h2 style = "text-align: center; font-family: Hanna;">이용자 현황</h2><h5 style = "text-align: center; font-family: Hanna; margin: -8px auto;">(그래프에 마우스를 올려보세요~)</h5><br>
			<section class="u-clearfix u-section-7" id="sec-73ed">
		      <div class="u-clearfix u-sheet u-sheet-1">
		        <div class="u-clearfix u-expanded-width u-layout-wrap u-layout-wrap-1">
		          <div class="u-layout">
		            <div class="u-layout-row">
		            <!-- 연령대별 사용자 -->
		              <div class="u-container-style u-layout-cell u-right-cell u-size-60 u-layout-cell-1">
		                <div class="u-container-layout u-container-layout-1">
		                  <p class="u-text u-text-default u-text-1">
		                  	<div class="col-lg-6">
								<h5 align="center">연령대별 사용자</h5>
								<div class="container">
								<canvas id="myChart"></canvas>
								</div>
							</div>
		                  </p>
		                </div>
		              </div>
		              <!-- 남녀비율 그래프 원형 -->
		              <div class="u-container-style u-layout-cell u-left-cell u-size-60 u-layout-cell-2">
		                <div class="u-container-layout u-container-layout-2">
		                  <p class="u-text u-text-default u-text-2">
		                  <div class="col-lg-6">
							<h5 align="center">남녀비율</h5>
							<div class="card">
								<div class="card-body">
									<canvas id="myChart2"></canvas>
								</div>
							</div>
						</div>
		                  </p>
		                </div>
		              </div>
		            </div>
		          </div>
		        </div>
		      </div>
		    </section>
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
	<script>
		var ctx = document.getElementById('myChart');
		var myChart = new Chart(ctx, {
			type : 'bar',
			data : {
				labels : [ '10대', '20대', '30대', '40대', '50대', ],
				datasets : [ {
					label : '연령대별 사이트 이용자', //여기다 뿌려줍니다
					data : [<%=ageCount[0]%>,<%=ageCount[1]%>,<%=ageCount[2]%>,<%=ageCount[3]%>,<%=ageCount[4]%>],
					backgroundColor : [ 
							'rgba(255, 99, 132, 0.2)',
							'rgba(54, 162, 235, 0.2)',
							'rgba(255, 206, 86, 0.2)',
							'rgba(75, 192, 192, 0.2)',
							'rgba(153, 102, 255, 0.2)',
							'rgba(255, 159, 64, 0.2)' ],
					borderColor : [ 
							'rgba(255, 99, 132, 1)',
							'rgba(54, 162, 235, 1)', 'rgba(255, 206, 86, 1)',
							'rgba(75, 192, 192, 1)', 'rgba(153, 102, 255, 1)',
							'rgba(255, 159, 64, 1)' ],} ]},
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
		<script>
		data = {
				datasets : [ {

					backgroundColor : [ '#006dcd', '#B7F0B1', 'skyblue' ],
					data : [<%=genderCount[0]%>,<%=genderCount[1]%>] //여기도마찬가지로 뿌려줍니당
				} ],
				labels : [ '남', '여' ]
			};

			var ctx2 = document.getElementById("myChart2");
			var myDoughnutChart = new Chart(ctx2, {
				type : 'doughnut',
				data : data,
				options : {}
			});
	</script>
</body>
</html>
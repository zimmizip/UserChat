<%@page import="java.awt.Button"%>
<%@page import="datec.datecBean"%>
<%@page import="java.util.Vector"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:useBean id="mMgr" class="datec.datecMgr"/>
<jsp:useBean id="mBean" class="datec.datecBean"/>


<!DOCTYPE html>
<html>
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<head>
	<style>
	.button {															/* button style값 */
	  background-color: white;
	  border-radius: 10px;
	  border-radius: 10%;
	  padding: 5px 5px;
	  text-align: center;
	  text-decoration: none;
	  display: inline-block;
	  font-size: 16px;
	  margin: 10px 10px;
	  cursor: pointer;
	  width:120px;
	  height:70px;
	}
	
	</style>
	<script>
		function zzimPro(index, str, dname) {								
			/* 찜하기 function(index는 번호,str은 타입(total,play,food,cafe), 가게이름 ) */
		    var btn = document.getElementsByClassName(str);					
		   
		    btn[index].value="찜 취소하기";									
		    location.href="/UserChat/goodProc.jsp?dname="+encodeURIComponent(dname)+"&button="+encodeURIComponent("찜하기");		
		    /* goodProc.jsp로 dname(가게이름),"찜하기" 값 보냄 */ 
		}
	
	
	</script>
	
	<meta charset="UTF-8">
	<title>Insert title here</title>		
	<% 
		userID = (String)session.getAttribute("userID");					/* userID session값으로 가져옴 */
		Vector<datecBean> dateclist = new Vector<datecBean>();				/* total 데이터 저장할 dateclist 생성 */
		Vector<datecBean> datekindlist = new Vector<datecBean>();			/* type별 데이터 저장할 datekindlist 생성 */
		String location = (String)session.getAttribute("dlocation");		/* dlocation session값으로 가져옴 */
		String kind = (String)session.getAttribute("kind");					/* kind session값으로 가져옴 */
		String category= "";
		String sentence="";
		
		if(kind!=null){														/* kind => type(total,play,food,cafe)선택상태 */						
		   datekindlist = mMgr.getkindList(location,kind,category,sentence);
		} else{																/* kind => type선택 안한상태(지역만 선택시) type을 'total'로 설정 */
		   datekindlist = mMgr.getkindList(location,"total",category,sentence);
		}
	%>


</head>
<body>
	<div class="w3-main" style="margin-left:250px; margin-right:250px;">
	<form method="post" action="/UserChat/dateProc.jsp">
	<table style="width:40%;">
	<tr>
	   <td><input type="submit" name="button" class="button" value= "건대"></td>
	   <td><input type="submit" name="button" class="button" value= "홍대"></td>
	   <td><input type="submit" name="button" class="button" value= "이태원"></td>
	   <td><input type="submit" name="button" class="button" value= "가로수길"></td>
	   <td><input type="submit" name="button" class="button" value= "강남역"></td>
	</tr>
	</table>
	</form>
	<div class="w3-container" style="margin-left:20px;">
	  <button class="w3-bar-item w3-button" onclick="openCity('total')" name="total">전 체</button>
	  <button class="w3-bar-item w3-button" onclick="openCity('play')" name="play">놀거리</button>
	  <button class="w3-bar-item w3-button" onclick="openCity('food')" name="food">맛집</button>
	  <button class="w3-bar-item w3-button" onclick="openCity('cafe')" name="cafe">까페</button>
	</div>
	        <div class="w3-center">															
	         <form name="searchForm" method="post" action="/UserChat/datec/datec3.jsp">							<!-- 검색하면 date3.jsp로 보냄 -->
	            <select name="category" size="1">
	               <option value="daddress">주소</option>
	               <option value="dname">이름</option>
	            </select>
	            <input size="16" name="sentence">
	            <input type="submit" class = "btn btn-primary" value="찾기">
	         </form>
	      </div>
	
	<div id="total" class="w3-container city">																<!-- type이 total일때  dateclist 뿌려주는 코드-->
		<form method="post" name="listfrm" action="/UserChat/dateProc.jsp"> 
			<% if(location!=null&&kind=="total"){ %>												
			<% for(int i=0; i<dateclist.size(); i++){	%>									
			<table class="w3-table-all w3-card-4" >
			
			<tr>
			<th width="300" rowspan="6" bgcolor="white" >
			   <font size="2" color="#666666">
			   <img  width = "300" height = "300" src = "/UserChat/ny/<%=dateclist.get(i).getDphoto() %>">
			 
			   <%  boolean mgrchk = mMgr.goodcheck(userID,dateclist.get(i).getDname()); %>							<!-- goodcheck로 DB에 저장되어있는지 확인 후 있으면  true, 없으면 false값반환 -->
			   <% if(mgrchk){ %>																					<!-- 반환값이 true이면 찜취소하기 버튼 보여지게 -->
			   <input type="button" class="total" value= "찜취소하기" name="good"
			   onclick = "zzimPro('<%=i %>', 'total', '<%=dateclist.get(i).getDname() %>')" />
			   <%}else{ %>																							<!-- 반환값이 false이면 찜하기 버튼 보여지게 -->
			   <input type="button" class="total" value= "찜하기" name="good"
			   onclick = "zzimPro('<%=i %>', 'total', '<%=dateclist.get(i).getDname() %>')" />
			   <%} %>
			   </font>
			</th>
			
			   <td><b><%=dateclist.get(i).getDname() %></b></td></tr>
			   <tr><td><%=dateclist.get(i).getDexplan() %></td></tr>
			   <tr><td><b>TEL :</b><%=dateclist.get(i).getDtel() %></td></tr>
			   <tr><td><b>메뉴 및 가격 :</b><%=dateclist.get(i).getDmenu() %> - <%=dateclist.get(i).getDprice()%></td></tr>
			   <tr><td><b>주소 :</b> <%=dateclist.get(i).getDaddress() %>&nbsp;&nbsp;&nbsp;
			   <input type="button" class = "btn btn-primary" name="map" value="지도보기"	
			   onclick="window.open('/UserChat/ny/maps_ny.jsp?address=<%=dateclist.get(i).getDaddress()%>&name=<%=dateclist.get(i).getDname()%>','window팝업','width=400, height=200, menubar=no, status=no, toolbar=no');" />
			   </td></tr>
			   <tr><td><b>영업시간 :</b><%=dateclist.get(i).getDtime() %></td></tr>
			</table>
			<% 
			   }
			%>
		</form>
	</div>
	<%} %>
	
	<div id="play" class="w3-container city">																<!-- type이 play일때  datekindlist 뿌려주는 코드-->
	   <% for(int i=0; i<datekindlist.size(); i++){ %>
	<form method="post" name="listfrm" action="/UserChat/dateProc.jsp">
	<table class="w3-table-all w3-card-4" >
	
	<tr>
	<th width="300" rowspan="6" bgcolor="white" >
	   <font size="2" color="#666666">
	   <img  width = "300" height = "300" src = "/UserChat/ny/<%=datekindlist.get(i).getDphoto() %>">
	   <%  boolean mgrchk = mMgr.goodcheck(userID,datekindlist.get(i).getDname()); %>
	   <% if(mgrchk){ %>
	   <input type="button" class="play" value= "찜취소하기" name="good"
	   onclick = "zzimPro('<%=i %>', 'play', '<%=datekindlist.get(i).getDname() %>')" />
	   <%}else{ %>
	   <input type="button" class="play" value= "찜하기" name="good"
	   onclick = "zzimPro('<%=i %>', 'play', '<%=datekindlist.get(i).getDname() %>')" />
	   <%} %>
	   </font>
	</th>
	   <td><b><%=datekindlist.get(i).getDname() %></b></td></tr>
	   <tr><td><%=datekindlist.get(i).getDexplan() %></td></tr>
	   <tr><td><b>TEL :</b><%=datekindlist.get(i).getDtel() %></td></tr>
	   <tr><td><b>메뉴 및 가격 :</b><%=datekindlist.get(i).getDmenu() %> - <%=datekindlist.get(i).getDprice()%></td></tr>
	   <tr><td><b>주소 :</b> <%=datekindlist.get(i).getDaddress() %>&nbsp;&nbsp;&nbsp;
	   <input type="button" class = "btn btn-primary" name="map" value="지도보기"	
	   onclick="window.open('/UserChat/ny/maps_ny.jsp?address=<%=datekindlist.get(i).getDaddress()%>&name=<%=datekindlist.get(i).getDname()%>','window팝업','width=400, height=200, menubar=no, status=no, toolbar=no');" />
	   </td></tr>
	   <tr><td><b>영업시간 :</b><%=datekindlist.get(i).getDtime() %></td></tr>
	   </td>
	</table>
	<% } %>
	</form>
	</div>
	
	
	<div id="food" class="w3-container city" style="display:none">													<!-- type이 food일때  datekindlist 뿌려주는 코드-->
	   <% for(int i=0; i<datekindlist.size(); i++){%>
	<form method="post" name="listfrm" action="/UserChat/dateProc.jsp">
	<table class="w3-table-all w3-card-4" >
	
	<tr>
	<th width="300" rowspan="6" bgcolor="white" >
	   <font size="2" color="#666666">
	   <img  width = "300" height = "300" src = "/UserChat/ny/<%=datekindlist.get(i).getDphoto() %>">
	   <%  boolean mgrchk = mMgr.goodcheck(userID,datekindlist.get(i).getDname()); %>
	   <% if(mgrchk){ %>
	   <input type="button" class="food" value= "찜취소하기" name="good"
	   onclick = "zzimPro('<%=i %>', 'food', '<%=datekindlist.get(i).getDname() %>')" />
	   <%}else{ %>
	   <input type="button" class="food" value= "찜하기" name="good"
	   onclick = "zzimPro('<%=i %>', 'food', '<%=datekindlist.get(i).getDname() %>')" />
	   <%} %>
	   </font>
	</th>
	
	   <td><b><%=datekindlist.get(i).getDname() %></b></td>
	   </tr>
	   <tr><td><%=datekindlist.get(i).getDexplan() %></td></tr>
	   <tr><td><b>TEL :</b><%=datekindlist.get(i).getDtel() %></td></tr>
	   <tr><td><b>메뉴 및 가격 :</b><%=datekindlist.get(i).getDmenu() %> - <%=datekindlist.get(i).getDprice()%></td></tr>
	   <tr><td><b>주소 :</b> <%=datekindlist.get(i).getDaddress() %>&nbsp;&nbsp;&nbsp;
	   <input type="button" class = "btn btn-primary" name="map" value="지도보기"	
	   onclick="window.open('/UserChat/ny/maps_ny.jsp?address=<%=datekindlist.get(i).getDaddress()%>&name=<%=datekindlist.get(i).getDname()%>','window팝업','width=400, height=200, menubar=no, status=no, toolbar=no');" />
	   </td></tr>
	   <tr><td><b>영업시간 :</b><%=datekindlist.get(i).getDtime() %></td></tr></td>
	</table>
	<%  }%>
	</form></div>
	
	
	<div id="cafe" class="w3-container city" style="display:none">										<!-- type이 cafe일때  datekindlist 뿌려주는 코드-->
	   <% for(int i=0; i<datekindlist.size(); i++){ %>
	<form method="post" name="listfrm" action="/UserChat/dateProc.jsp">
	<table class="w3-table-all w3-card-4" >
	
	<tr>
	<th width="300" rowspan="6" bgcolor="white" >
	   <font size="2" color="#666666">
	   <img  width = "300" height = "300" src = "/UserChat/ny/<%=datekindlist.get(i).getDphoto() %>">
	       <%  boolean mgrchk = mMgr.goodcheck(userID,datekindlist.get(i).getDname()); %>
	  <% if(mgrchk){ %>
	   <input type="button" class="cafe" value= "찜취소하기" name="good"
	   onclick = "zzimPro('<%=i %>', 'cafe', '<%=datekindlist.get(i).getDname() %>')" />
	   <%}else{ %>
	   <input type="button" class="cafe" value= "찜하기" name="good"
	   onclick = "zzimPro('<%=i %>', 'cafe', '<%=datekindlist.get(i).getDname() %>')" />
	   <%} %>
	   </font>
	   </th>
	
	   <td><b><%=datekindlist.get(i).getDname() %></b></td>
	</tr>
	   <tr><td><%=datekindlist.get(i).getDexplan() %></td></tr>
	     <tr><td><b>TEL :</b><%=datekindlist.get(i).getDtel() %></td></tr>
	     <tr><td><b>메뉴 및 가격 :</b><%=datekindlist.get(i).getDmenu() %> - <%=datekindlist.get(i).getDprice()%></td></tr>
	     <tr><td><b>주소 :</b> <%=datekindlist.get(i).getDaddress() %> &nbsp;&nbsp;&nbsp;
	     <input type="button" class = "btn btn-primary" name="map" value="지도보기"	
	     onclick="window.open('/UserChat/ny/maps_ny.jsp?address=<%=datekindlist.get(i).getDaddress()%>&name=<%=datekindlist.get(i).getDname()%>','window팝업','width=400, height=200, menubar=no, status=no, toolbar=no');" />
	   </td></tr>
	     </td></tr>
	     <tr><td><b>영업시간 :</b><%=datekindlist.get(i).getDtime() %></td></tr>
	   </td>
	
	
	</table>
	<% 
	   }
	%>
	</form>
	</div>
	
	</div>
	<script>
		function openCity(type) {									/* type 메뉴 선택시 type에 해당하는 테이블 출력하는 함수	/  cityName => kind(type) */
		  var i;
		  var x = document.getElementsByClassName("city");
		  for (i = 0; i < x.length; i++) {
		    x[i].style.display = "none";  
		  }
		  document.getElementById(type).style.display = "block";  
		  location.href="/UserChat/datec/place.jsp?name="+type;
		}
	</script>
</body>
</html>
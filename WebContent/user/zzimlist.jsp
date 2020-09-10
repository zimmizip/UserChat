<%@page import="datec.datecBean"%>
<%@page import="java.util.Vector"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    
<jsp:useBean id="mMgr" class="datec.datecMgr"/>
<jsp:useBean id="mBean" class="datec.datecBean"/>

<% 
	userID = (String)session.getAttribute("userID");
	Vector<datecBean> zzimlist = new Vector<datecBean>();
	
	zzimlist = mMgr.myplaceList(userID);
%>

<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<script>
function zzimPro(index, str, dname) {								/* 찜하기 function(index는 번호,str은 타입(total,play,food,cafe), 가게이름 ) */
   var btn = document.getElementsByClassName(str);					
   
      btn[index].value="찜 취소하기";									
      location.href="/UserChat/goodProc_user.jsp?dname="+encodeURIComponent(dname)+"&button="+encodeURIComponent("찜하기");		/* goodProc.jsp로 dname(가게이름),"찜하기" 값 보냄 */ 
}
</script>

<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div class="w3-main" style="margin-left:250px; margin-right:250px;">
		<form method="post" name="zzimlistfrm" action="zzimlist.jsp"> 
		
		<% if(zzimlist.size()!=0){	%>													<!-- zzimlist가 1개라도 있으면 테이블출력 -->
		<% for(int i=0; i<zzimlist.size(); i++){	%>								
		<table class="w3-table-all w3-card-4" >
		
		<tr>
		<th width="300" rowspan="6" bgcolor="white" >
		   <font size="2" color="#666666">
		   <img  width = "300" height = "300" src = "/UserChat/ny/<%=zzimlist.get(i).getDphoto() %>">
		 
		   <%  boolean mgrchk = mMgr.goodcheck(userID,zzimlist.get(i).getDname()); %>							<!-- goodcheck로 DB에 저장되어있는지 확인 후 있으면  true, 없으면 false값반환 -->
		   <% if(mgrchk){ %>																					<!-- 반환값이 true이면 찜취소하기 버튼 보여지게 -->
		   <input type="button" class="total" value= "찜취소하기" name="good"
		   onclick = "zzimPro('<%=i %>', 'total', '<%=zzimlist.get(i).getDname() %>')" />
		   <%}else{ %>																							<!-- 반환값이 false이면 찜하기 버튼 보여지게 -->
		   <input type="button" class="total" value= "찜하기" name="good"
		   onclick = "zzimPro('<%=i %>', 'total', '<%=zzimlist.get(i).getDname() %>')" />
		   <%} %>
		   </font>
		</th>
		
		   <td><b><%=zzimlist.get(i).getDname() %></b></td></tr>
		   <tr><td><%=zzimlist.get(i).getDexplan() %></td></tr>
		   <tr><td><b>TEL :</b><%=zzimlist.get(i).getDtel() %></td></tr>
		   <tr><td><b>메뉴 및 가격 :</b><%=zzimlist.get(i).getDmenu() %> - <%=zzimlist.get(i).getDprice()%></td></tr>
		   <tr><td><b>주소 :</b> <%=zzimlist.get(i).getDaddress() %>&nbsp;&nbsp;&nbsp;
		   <input type="button" class = "btn btn-primary" name="map" value="지도보기"	
		   onclick="window.open('/UserChat/ny/maps_ny.jsp?address=<%=zzimlist.get(i).getDaddress()%>&name=<%=zzimlist.get(i).getDname()%>','window팝업','width=400, height=200, menubar=no, status=no, toolbar=no');" />
		   </td></tr>
		   <tr><td><b>영업시간 :</b><%=zzimlist.get(i).getDtime() %></td></tr>
		   </td>
		</table>
		<% 
		   }}else{
			   out.println("저장된 데이트 장소 찜 목록이 없습니다");
		   }
		%>
		
		</form>
	</div>

</body>
</html>
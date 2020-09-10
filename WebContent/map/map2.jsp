
<%@page import="user.UserDTO"%>
<%@page import="map.mapDTO"%>
<%@page import="java.util.Vector"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <jsp:useBean id="mMgr" class="map.mapDAO"></jsp:useBean>
    <jsp:useBean id="uMgr" class="user.UserDAO"></jsp:useBean>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>주소로 장소 표시하기</title>
	 <%
		 String address=request.getParameter("address");			//주소,위도,경도를 받아옴
		 double lat=Double.parseDouble(request.getParameter("lat"));
		 double lng=Double.parseDouble(request.getParameter("lng"));
		 mMgr.insertLatLng(userID, lat, lng);		//위도 경도를 db에 넣어줌
		 UserDTO userinfo=uMgr.getUser(userID);
		 Vector<mapDTO> list=mMgr.showAddress(userinfo.getUserID(),userinfo.getUserGender());	//로그인한 회원과 주변이성의 정보를 담는 리스트 선언
		 mapDTO bean=mMgr.getInfo(userID);		
		 list.remove(bean);					//로그인한 사람을 주변 이성에서 제외
		 for(int i=0;i<list.size();i++){
			//distance[i]= mMgr.distance(bean,list.get(i));
			list.get(i).setDistance(mMgr.distance(bean,list.get(i)));	//로그인한 회원과 list에 담긴 이성과의 거리 계산
		 }
	 %>
</head>
<body>
	<div id="map" style="width:100%;height:350px;"> 
	</div>
	
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=3b354cddfddea50f9a467900bc2de37a&libraries=services&libraries=services"></script>
	<script>
	
	
	
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	    mapOption = {
	        center: new kakao.maps.LatLng(<%=lat%>, <%=lng%>), // 지도의 중심좌표(사용자의 주소)
	        level: 3 // 지도의 확대 레벨
	    }; 
	// 지도를 생성합니다    
	var map = new kakao.maps.Map(mapContainer, mapOption); 
	// 주소-좌표 변환 객체를 생성합니다
	var geocoder = new kakao.maps.services.Geocoder();
	<%-- <%for (int i = 0; i < list.size(); i ++) {%> --%>
	// 주소로 좌표를 검색합니다
	geocoder.addressSearch('<%=address%>', function(result, status) {
	    // 정상적으로 검색이 완료됐으면 
	     if (status === kakao.maps.services.Status.OK) {
	
	    	 
	        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
	  		var imageSrc = "http://localhost:8089/UserChat/upload/<%=bean.getProfile()%>",   // 마커이미지의 주소입니다    (내 프로필사진)
	        imageSize = new kakao.maps.Size(35, 35), // 마커이미지의 크기입니다
	        imageOption = {offset: new kakao.maps.Point(27, 50)};  
	        
	        var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
	        
	        // 결과값으로 받은 위치를 마커로 표시합니다
	        var marker = new kakao.maps.Marker({
	            map: map,
	            position: coords,
	            image:markerImage
	        });
	        // 인포윈도우로 장소에 대한 설명을 표시합니다
	       <%--  var infowindow = new kakao.maps.InfoWindow({
	            content: '<div>'+names[<%=i%>]+'</div>'
	        }); --%>
	        
	        kakao.maps.event.addListener(marker, 'click', function() {
	        	  // 마커에 마우스오버 이벤트가 발생하면 인포윈도우를 마커위에 표시합니다
	        	   // infowindow.open(map, marker);
	        	  //location.href="map.jsp?";
	        	  <%-- window.open('/UserChat/user/userAddress.jsp?address='+positions[<%=i%>], '_blank', 'width=600, height=600'); --%>
	        });
	
	    } 
	});   
	<%-- <%}%> --%>
	
	
	</script>		
	<br>
	<div class = "container">
			<img align="center" class = "media-object img-circle" style = "max-width: 100px; margin: 0 auto;" src = "http://localhost:8089/UserChat/upload/<%=bean.getProfile()%>">
			<h2 align="center">현재 내 주소:  <%=address %> </h2>
			<table class = "table table-bordered table-hover" style = "text-align: center; border: 1px solid #dddddd">
				<thead >
					<tr>
						<th colspan="3">내 주변에 <h5><%=list.size() %>명</h5>의 이성을 찾았습니다</th>
					</tr>
				</thead>
				<tbody>
					<%for(int i=0;i<list.size();i++){ %>
					<tr>
						<td style="text-align:center;" >
							<a href="/UserChat/user/userInfo.jsp?id=<%=list.get(i).getUserid()%>">
								<img class = "media-object img-circle" style = "max-width: 100px; margin: 0 auto;" src = "http://localhost:8089/UserChat/upload/<%=list.get(i).getProfile()%>" onclick="location.href='/UserChat/user/userInfo.jsp?id=<%=list.get(i).getUserid()%>'">
							</a>
						</td>
						<td style="text-align:center;" >
							아이디:<h2><%=list.get(i).getUserid() %></h2>
						</td>
						<td style="text-align:center;" >
							나와의 거리:<h2><%-- <%=distance[i] %> --%><%=list.get(i).getDistance() %>km</h2>
						</td>
					</tr>
					<%} %>
				</tbody>
			</table>
	</div>
</body>
</html>
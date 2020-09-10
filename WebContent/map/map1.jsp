
<%@page import="map.mapDTO"%>
<%@page import="java.util.Vector"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <jsp:useBean id="mMgr" class="map.mapDAO"></jsp:useBean>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>주소로 장소 표시하기</title>
	 <%
	 	String address=request.getParameter("address");
	 %>
</head>
<body>
<div id="map" style="width:100%;height:0px;" ></div>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=3b354cddfddea50f9a467900bc2de37a&libraries=services&libraries=services"></script>
<script>		//geocoder를 이용해 받아온 주소를 위도,경도로 변환하여 map2로 넘겨줌
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	    mapOption = {
	        center: new kakao.maps.LatLng(33.470701, 126.570667), // 지도의 중심좌표
	        level: 3 // 지도의 확대 레벨
	    }; 
	// 지도를 생성합니다    
	var map = new kakao.maps.Map(mapContainer, mapOption); 
	/* var positions=[];
	var names=[]
	var im=[]; */
	// 주소-좌표 변환 객체를 생성합니다
	var geocoder = new kakao.maps.services.Geocoder();
	// 주소로 좌표를 검색합니다
	geocoder.addressSearch( '<%=address%>', function(result, status) {		
	    // 정상적으로 검색이 완료됐으면 
	     if (status === kakao.maps.services.Status.OK) {
	       var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
	       location.href="/UserChat/map/map2.jsp?lat="+result[0].y+"&lng="+result[0].x+"&address="+'<%=address%>';
	    } 
	});   
</script>
</body>
</html>
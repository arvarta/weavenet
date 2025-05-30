<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<title>그린컴퓨터아카데미 위치 표시</title>
	 <script type="text/javascript"
          src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=b38c87ec2e8c17d795527b1c2d73c5e1&libraries=services"></script>
	<style>
		#map {
			width: 500px;
			height: 500px;
			border: 1px solid #ccc;
		}
	</style>
</head>
<body>
	<h2>COMPANY INFO</h2>
	<br>
	<div id="map"></div>
	<br>
	<div class="">
		<ul>
			<li>대표자 : 김상곤</li>
			<li>사업자등록번호 : 214-86-26812</li>
			<li>통신판매업신고 : 2023-서울서초-2056호</li>
			<li>주소 : 부산 부산진구 중앙대로 749 범향빌딩 4층</li>
		</ul>
	</div>
	<br>
	

	<script>
		var container = document.getElementById('map');
		var options = {
			center: new kakao.maps.LatLng(35.159614, 129.060194), // 범향빌딩 좌표
			level: 2
		};
	
		var map = new kakao.maps.Map(container, options);
	
		// 마커 위치
		var markerPosition = new kakao.maps.LatLng(35.159614, 129.060194);
	
		// 마커 생성
		var marker = new kakao.maps.Marker({
			position: markerPosition
		});
	
		marker.setMap(map);
	
		// 인포윈도우 내용
		var iwContent = '<div style="padding: 10px; font-size:12px;">그린컴퓨터아카데미<br>부산진구 중앙대로 749</div>',
			iwPosition = markerPosition;
	
		// 인포윈도우 생성
		var infowindow = new kakao.maps.InfoWindow({
			position : iwPosition,
			content : iwContent
		});
	
		// 인포윈도우 표시
		infowindow.open(map, marker);
	</script>

</body>
</html>

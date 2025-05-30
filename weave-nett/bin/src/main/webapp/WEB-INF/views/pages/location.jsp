<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>현재 위치 근무지 등록</title>
  <script type="text/javascript"
          src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=b38c87ec2e8c17d795527b1c2d73c5e1&libraries=services"></script>
  <style>
    #map {
      width: 350px;
      height: 350px;
      border: 1px solid #ccc;
    }
  </style>
</head>
<body>

  <!-- 고정된 회사명 표시 (초기값은 빈칸으로 설정) -->
  <span id="workplaceInfo">회사명 (주소는 자동으로 설정됩니다.)</span>


  <label>회사명: <input style="display: none;" type="text" id="companyName" placeholder="회사명을 입력하세요"></label>
  <br><br>

  <div id="map"></div>

  <script>
    var container = document.getElementById('map');
    var map;
    var marker;
    var geocoder;
    var infoWindow;
    var companyInput = document.getElementById("companyName");
    var workplaceInfo = document.getElementById("workplaceInfo");

    kakao.maps.load(function () {
      map = new kakao.maps.Map(container, {
        center: new kakao.maps.LatLng(33.450701, 126.570667), // 기본 좌표 (제주도)
        level: 3
      });

      geocoder = new kakao.maps.services.Geocoder();
      infoWindow = new kakao.maps.InfoWindow({ zIndex: 1 });

      // 현재 위치 가져오기
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function (position) {
          var lat = position.coords.latitude;
          var lng = position.coords.longitude;
          var currentPos = new kakao.maps.LatLng(lat, lng);
          map.setCenter(currentPos);

          // 마커 표시
          marker = new kakao.maps.Marker({
            position: currentPos,
            map: map
          });

          // 좌표로 주소 검색
          geocoder.coord2Address(lng, lat, function (result, status) {
            if (status === kakao.maps.services.Status.OK) {
              var address = result[0].road_address ? result[0].road_address.address_name : result[0].address.address_name;

              // 회사명이 입력된 경우 표시
              function updateWorkplace() {
                var companyName = companyInput.value || "회사위치";
                workplaceInfo.textContent = companyName + " (" + address + ")";
              }

              // 초기 표시
              updateWorkplace();

              // 회사명 바뀔 때마다 다시 표시
              companyInput.addEventListener("input", updateWorkplace);

              // 정보창 스타일 적용
              infoWindow.setContent('<div style="padding:10px; background-color:white; border-radius:5px; font-size:14px; line-height: 1.5;">' + workplaceInfo.textContent + '</div>');

              // 정보창 위치를 약간 위로 이동
              var offsetPosition = new kakao.maps.LatLng(lat + 0.0001, lng); // 0.0001만큼 위로 이동
              infoWindow.setPosition(offsetPosition);

              // 정보창 띄우기
              infoWindow.open(map, marker);
            }
          });

          // 지도 기능 제한
          map.setDraggable(true);
          map.setZoomable(true);
          kakao.maps.event.addListener(map, 'dblclick', function (e) {
            e.preventDefault(); // 더블클릭 확대 방지
          });

        }, function () {
          alert("현재 위치를 가져올 수 없습니다.");
        });
      } else {
        alert("이 브라우저는 위치 정보 기능을 지원하지 않습니다.");
      }
    });
  </script>

</body>
</html>

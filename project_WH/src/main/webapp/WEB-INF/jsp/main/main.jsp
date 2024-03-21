<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>재희 지도</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.15.1/build/ol.js"></script>
<link rel="stylesheet"  href="https://cdn.jsdelivr.net/npm/ol@v6.15.1/ol.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
    $(document).ready(function() {
    	
    	$('#loc').change(function(){
    	    var test = $('#loc').val(); // 선택된 옵션의 값 가져오기
    	    $.ajax({
    	        type: 'POST',
    	        url: url,
    	        data: data,
    	        success: success,
    	        dataType: dataType
    	    });
    	});
    	
</script>
<script>
	$(document).ready(function() {
		
		let map = new ol.Map({ // OpenLayer의 맵 객체를 생성한다.
		    target: 'map', // 맵 객체를 연결하기 위한 target으로 <div>의 id값을 지정해준다.
		    layers: [ // 지도에서 사용 할 레이어의 목록을 정희하는 공간이다.
		      new ol.layer.Tile({
		        source: new ol.source.OSM({
		       url: 'http://api.vworld.kr/req/wmts/1.0.0/2ADB7362-BFB8-38E5-86FD-57954DE6347D/Base/{z}/{y}/{x}.png' 
		        		  // vworld의 지도를 가져온다.
		        })
		      })
		    ],
		        
		    view: new ol.View({ // 지도가 보여 줄 중심좌표, 축소, 확대 등을 설정한다. 보통은 줌, 중심좌표를 설정하는 경우가 많다.
		      center: ol.proj.fromLonLat([128.4, 35.7]),
		      zoom: 7
		    })
		});
		
	/* 	var wms = new ol.layer.Tile({
			source : new ol.source.TileWMS({
				url : 'http://localhost:8080/geoserver/cite/wms?service=WMS', // 1. 레이어 URL
				params : {
					'VERSION' : '1.1.0', // 2. 버전
					'LAYERS' : 'jaehee', // 3. 작업공간:레이어 명
					'CQL_FILTER' : 'sgg_cd=11680',
					'BBOX' : '13868720, 3906626.5, 14680011.171788167, 4670269.5', 
					'SRS' : 'EPSG:3857', // SRID
					'FORMAT' : 'image/png' // 포맷
				},
				serverType : 'geoserver',
			})
		}); */
		
		var wmssd = new ol.layer.Tile({
			source : new ol.source.TileWMS({
				url : 'http://localhost:8080/geoserver/cite/wms?service=WMS', // 1. 레이어 URL
				params : {
					'VERSION' : '1.1.0', // 2. 버전
					'LAYERS' : 'cite:tlsd', // 3. 작업공간:레이어 명
					'CQL_FILTER': "${loc}",
					'BBOX' : '1.386872E7, 3906626.5, 1.4428071E7, 4670269.5', 
					'SRS' : 'EPSG:3857', // SRID
					'FORMAT' : 'image/png' // 포맷						
				},
				serverType : 'geoserver',
			})
		});
		
		map.addLayer(wmssd); // 맵 객체에 레이어를 추가함

	
	var wmssgg = new ol.layer.Tile({
	    source : new ol.source.TileWMS({
	        url : 'http://localhost:8080/geoserver/cite/wms?service=WMS', // 1. 레이어 URL
	        params : {
	            'VERSION' : '1.1.0', // 2. 버전
	            'LAYERS' : 'cite:tlsgg', // 3. 작업공간:레이어 명
	            'CQL_FILTER': "${loc1}", // 변수 loc로 변경
	            'BBOX' : '1.386872E7 , 3906626.5, 1.4428071E7, 4670269.5', 
	            'SRS' : 'EPSG:3857', // SRID
	            'FORMAT' : 'image/png' // 포맷						
	        },
	        serverType : 'geoserver',
	    })
	});
	map.addLayer(wmssgg); // 맵 객체에 레이어를 추가함

	var wmsbjd = new ol.layer.Tile({
	    source : new ol.source.TileWMS({
	        url : 'http://localhost:8080/geoserver/cite/wms?service=WMS', // 1. 레이어 URL
	        params : {
	            'VERSION' : '1.1.0', // 2. 버전
	            'LAYERS' : 'cite:tlbjd', // 3. 작업공간:레이어 명
	            'CQL_FILTER': "${loc2}", // 변수 loc로 변경
	            'BBOX' : '1.3873946E7 , 3906626.5, 1.4428045E7, 4670269.5', 
	            'SRS' : 'EPSG:3857', // SRID
	            'FORMAT' : 'image/png' // 포맷						
	        },
	        serverType : 'geoserver',
	    })
	});
	map.addLayer(wmsbjd); // 맵 객체에 레이어를 추가함
	});
	
	
</script>

<style>
    .map {
      height: 600px;
      width: 100%;
    }
    
    .olControlAttribution {
        right: 20px;
    }

    .olControlLayerSwitcher {
        right: 20px;
        top: 20px;
    }
</style>
</head>
<body>
	<div id="map" class="map">
		<!-- 실제 지도가 표출 될 영역 -->
	</div>
	<div>
		<button type="button" onclick="javascript:deleteLayerByName('VHYBRID');" name="rpg_1">레이어삭제하기</button>
		<form action="./main.do" method="get">
		
			<select id="loc" name="loc">
			<c:forEach items="${list }" var="row">
				<option value="${row.sidonm}" ${row.sidonm eq param.loc ? 'selected' : ''}>${row.sidonm}</option>
			</c:forEach>
			</select>
			
			<select id="loc1" name="loc1">
   			<option></option>
			</select>
			
			<select id="loc2" name="loc2">
			<c:forEach items="${list2 }" var="row">
				<option value="${row.bjd_nm}" ${row.bjd_nm eq param.loc ? 'selected' : ''}>${row.bjd_nm}</option>
			</c:forEach>
			</select>
			<button type="submit">선택</button>
		</form>	
	</div>
</body>
</html>
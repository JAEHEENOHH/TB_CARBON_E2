<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>브이월드 오픈API</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.15.1/build/ol.js"></script>
<link rel="stylesheet"  href="https://cdn.jsdelivr.net/npm/ol@v6.15.1/ol.css">

<script type="text/javascript">
   
   var sdLayer;
   var sggLayer;
   var bjdLayer;

   $(document).ready(function() {
	   
	   $("#fileBtn").on("click",function() {
			let fileName = $('#file').val();
			alert("!111 " + fileName);
			if (fileName == "") {
				alert("파일을 선택해주세요.");
				return false;
			}
			let dotName = fileName.substring(fileName.lastIndexOf('.') + 1)
					.toLowerCase();
			if (dotName == 'txt') {
				//alert("! " + fileName);

				$.ajax({
					url : '/fileUp2.do',
					type : 'POST',
					dataType : 'json',
					data : new FormData($('#form')[0]),
					cache : false,
					contentType : false,
					processData : false,
					enctype : 'multipart/form-data',
					// 추가한부분
					xhr : function() {
						var xhr = $.ajaxSettings.xhr();
						xhr.upload.onprogress = function(e) {
							var per = e.loaded * 100 / e.total;
							progressBar(per);
						};
						return xhr;
					},

					/* swal창으로하기
					 xhr: function(){
					   var xhr = $.ajaxSettings.xhr();
					   // Set the onprogress event controlle
					    xhr.upload.onprogress = function(event){
					      var perc = Math.round((event.loaded / event.total) * 100);
					      $('#progressBar').text(perc + '%');
					      $('#progressBar').css('width',perc + '%');
					      };
					      return xhr;
					   },
					 */

					success : function(result) {
						//alert(result);
						console.log("SUCCESS : ", result);
					},
					error : function(Data) {
						console.log("ERROR : ", Data);
					}
				});

			} else {
				alert("확장자가 안 맞으면 멈추기");
			}
		}); 
	   
	   
	   
                  $('#sidoSelect').change(function() {
                                 var sidoSelectedValue = $(this).val();
                                 var sidoSelectedText = $(this).find('option:selected').text();
                                 
                                 updateAddress(sidoSelectedText, null, null); // 상단 시/도 노출
                                 
                                 var cqlFilterSD = "sd_cd='" + sidoSelectedValue + "'";
                                 var cqlFilterSgg = "sd_nm='" + sidoSelectedText + "'";
                                
                                 if(sdLayer || sggLayer || bjdLayer) {
                                    map.removeLayer(sdLayer);
                                    map.removeLayer(sggLayer);
                                    map.removeLayer(bjdLayer);
                                 }
                                 
                                 sdLayer = new ol.layer.Tile(
                                       { // sd 시도
                                          source : new ol.source.TileWMS(
                                                {
                                                   url : 'http://localhost:8080/geoserver/cite/wms?service=WMS', // 1. 레이어 URL
                                                   params : {
                                                      'VERSION' : '1.1.0', // 2. 버전
                                                      'LAYERS' : 'cite:tlsd', // 3. 작업공간:레이어 명
                                                      'CQL_FILTER': cqlFilterSD,      
                                                      'BBOX' : [
                                                            1.3871489341071218E7,
                                                            3910407.083927817,
                                                            1.4680011171788167E7,
                                                            4666488.829376997 ],
                                                      'SRS' : 'EPSG:3857', // SRID
                                                      'FORMAT' : 'image/png' // 포맷
                                                   },
                                                   serverType : 'geoserver',
                                                })
                                       });
                                 map.addLayer(sdLayer); // 맵 객체에 레이어를 추가
                                 
                                 
                                 sggLayer = new ol.layer.Tile(
                                         { // sgg 시군구
                                            source : new ol.source.TileWMS(
                                                  {
                                                     url : 'http://localhost:8080/geoserver/cite/wms?service=WMS', // 1. 레이어 URL
                                                     params : {
                                                        'VERSION' : '1.1.0', // 2. 버전
                                                        'LAYERS' : 'cite:tlsgg', // 3. 작업공간:레이어 명
                                                        'CQL_FILTER': cqlFilterSgg,
                                                        'style' : 'line',
                                                        'BBOX' : [ 1.386872E7,
                                                              3906626.5,
                                                              1.4428071E7,
                                                              4670269.5 ],
                                                        'SRS' : 'EPSG:3857', // SRID
                                                        'FORMAT' : 'image/png' // 포맷
                                                     },
                                                     serverType : 'geoserver',
                                                  })
                                         });

                                   map.addLayer(sggLayer); // 맵 객체에 레이어를 추가함
                                   
                                $('#sggSelect, #bjdSelect').empty().val(null).trigger('change');
                                 // bjdSelect를 초기화
                                 //var bjdSelect = $("#bjdSelect");
                                 //bjdSelect.empty(); // 옵션 제거
                                 // bjdSelect의 선택 해제
                                 //bjdSelect.val(null).trigger('change');
                                 //bjdSelect.html("<option>--동/읍/면를 선택하세요--</option>");
								//alert(sidoSelectedValue);
								console.log(sidoSelectedText);
                  
				               // AJAX 요청 보내기
				                  $.ajax({
				                   type: 'POST', // 또는 "GET", 요청 방식 선택
				                       url: '/sgg.do', // 컨트롤러의 URL 입력
				                       data: { 'sido': sidoSelectedText }, // 선택된 값 전송
				                       dataType: 'json',
				                     success: function(response) {
				                          // 성공 시 수행할 작업
				                          //console.log(response);
				                         // console.log(response.sgglist);
				                          
				                          var sgg = response.sgglist;
				                          var geom = response.geom;
				                          map.getView().fit([geom.xmin, geom.ymin, geom.xmax, geom.ymax], {duation : 900});  
				                       
				                      
				                         
				                          var sggSelect = $("#sggSelect");
				                          sggSelect.html("<option>--시/군/구를 선택하세요--</option>");
				                          //var lists = JSON.parse(response);
				                         // for(var i = 0; i < sgg.length; i++) {
				                        	 $.each(sgg, function(index, item){
				                       			
				                        	 /*  alert("for문으로 진입"); */
				                              //var item = sgg[i];
				                              console.log("for문안으로 진입"+item.sgg_nm);                          
				                              let indexOfSpace = item.sgg_nm.indexOf(' ');
				                              let sgg2 = indexOfSpace !== -1 ? item.sgg_nm.substring(indexOfSpace + 1) : item.sgg_nm;
				                                    console.log(sgg2);
				                              
				                              sggSelect.append("<option value='" + item.sgg_nm + "'>" + sgg2 + "</option>");
				                                })
				                         },
				                          error: function(xhr, status, error) {
				                              // 에러 발생 시 수행할 작업
				                               // alert('ajax 실패');
				                              // console.error("AJAX 요청 실패:", error);
				                          }
				                     });
				                  });

                  $('#sggSelect').change(function() {
                                
                	  var sggSelectedValue = $(this).val(); // sggSelect.append("<option value='" + item.sgg_nm + "'>" + sgg2 + "</option>");의 value 값을 sggSelectedValue에 담는다
                        
                                 if(sggSelectedValue) {
                                    var sggSelectedText = $(this).find('option:selected').text();
                                    updateAddress(null, sggSelectedText, null); //상단 시/군/구 노출
                                 }
                                 
                                  $('#bjdSelect').empty().val(null).trigger('change');
                                 
                              //	alert(sggSelectedValue);
                                 var cqlFilterSGG = "sgg_nm LIKE'%" + sggSelectedValue + "%'";
                                 
                                 if(sggLayer || bjdLayer) {
                                    
                                   map.removeLayer(sggLayer);
                                    map.removeLayer(bjdLayer);
                                 }
                                 
                                 sggLayer = new ol.layer.Tile(
                                       { // sgg 시군구
                                          source : new ol.source.TileWMS(
                                                {
                                                   url : 'http://localhost:8080/geoserver/cite/wms?service=WMS', // 1. 레이어 URL
                                                   params : {
                                                      'VERSION' : '1.1.0', // 2. 버전
                                                      'LAYERS' : 'cite:tlsgg', // 3. 작업공간:레이어 명
                                                      'CQL_FILTER': cqlFilterSGG,
                                                      'BBOX' : [ 1.386872E7,
                                                            3906626.5,
                                                            1.4428071E7,
                                                            4670269.5 ],
                                                      'SRS' : 'EPSG:3857', // SRID
                                                      'FORMAT' : 'image/png' // 포맷
                                                   },
                                                   serverType : 'geoserver',
                                                })
                                       });

                                 map.addLayer(sggLayer); // 맵 객체에 레이어를 추가함
                                 
                                 $.ajax({
                                          type : "POST", // 또는 "GET", 요청 방식 선택
                                          url : "/bjd.do", // 컨트롤러의 URL 입력
                                          data : {
                                             "sgg" : sggSelectedValue
                                          }, // 선택된 값 전송
                                          dataType : 'json',
                                          success : function(response) { //controller에서 return map이 response(변수명)랑 같은 거임
                                             //alert(response);
  											console.log(response.bjdlist);
                                             //var bjd = JSON.parse(response);
                                           
                                             var bjd = response.bjdlist;
                                             var geom = response.geom;
                                              
                                              map.getView().fit([geom.xmin, geom.ymin, geom.xmax, geom.ymax], { duration: 900 });
                                   				//alert(geom);
                                             var bjdSelect = $("#bjdSelect");
                                             bjdSelect.html("<option>--동/읍/면를 선택하세요--</option>");
                                             //for (var i = 0; i < bjd.length; i++) {
                                            	  $.each(bjd, function(index, item){
                                               // var item = bjd[i];
                                                 console.log("for문안으로 진입"+item.bjd_nm); 
                                                bjdSelect.append("<option value='" + item.bjd_cd + "'>"+ item.bjd_nm+ "</option>");
                                             });
                                          },
                                          error : function(xhr,status, error) {
                                             // 에러 발생 시 수행할 작업
                                             //alert('ajax 실패 sgg');
                                             // console.error("AJAX 요청 실패:", error);
                                          }
                                       });
                              });
                  
                  $('#bjdSelect').change(function() {
                     var bjdSelectedValue = $(this).val();
                     var bjdSelectedText = $(this).find('option:selected').text();
                     updateAddress(null, null, bjdSelectedText); //상단 법정동 노출
                     
                     var cqlFilterBJD = "bjd_cd='" + bjdSelectedValue + "'";
                     
                     if(bjdLayer) {
                        map.removeLayer(bjdLayer);
                     }
                     
                     bjdLayer = new ol.layer.Tile(
                           { // bjd 법정동
                              source : new ol.source.TileWMS(
                                    {
                                       url : 'http://localhost:8080/geoserver/cite/wms?service=WMS', // 1. 레이어 URL
                                       params : {
                                          'VERSION' : '1.1.0', // 2. 버전
                                          'LAYERS' : 'cite:tlbjd', // 3. 작업공간:레이어 명
                                          'CQL_FILTER' : cqlFilterBJD,
                                          'BBOX' : [ 1.3873946E7,
                                                3906626.5,
                                                1.4428045E7,
                                                4670269.5 ],
                                          'SRS' : 'EPSG:3857', // SRID
                                          'FORMAT' : 'image/png' // 포맷
                                       },
                                       serverType : 'geoserver',
                                    })
                           });

                     map.addLayer(bjdLayer); // 맵 객체에 레이어를 추가함
  
                     
                  });
           
                  
                  function updateAddress(sido, sgg, bjd) {
                     // 각 select 요소에서 선택된 값 가져오기
                       var sidoValue = sido || $('#sidoSelect').find('option:selected').text() || '';
                       var sggValue = sgg || $('#sggSelect').find('option:selected').text() || ''; // 선택된 값이 없으면 빈 문자열 나열
                       var bjdValue = bjd || $('#bjdSelect').find('option:selected').text() || '';

                       // 주소 업데이트
                       $('#address').html('<h1>' + sidoValue + ' ' + sggValue + ' ' + bjdValue + '</h1>');
                  }
                  
                  let map = new ol.Map(
                        { // OpenLayer의 맵 객체를 생성한다.
                           target : 'map', // 맵 객체를 연결하기 위한 target으로 <div>의 id값을 지정해준다.
                           layers : [ // 지도에서 사용 할 레이어의 목록을 정의하는 공간이다.
                           new ol.layer.Tile(
                                 {
                                    source : new ol.source.OSM(
                                          {
                                             url : 'https://api.vworld.kr/req/wmts/1.0.0/2ADB7362-BFB8-38E5-86FD-57954DE6347D/Base/{z}/{y}/{x}.png' // vworld의 지도를 가져온다.
                                          })
                                 }) ],
                           view : new ol.View({ // 지도가 보여 줄 중심좌표, 축소, 확대 등을 설정한다. 보통은 줌, 중심좌표를 설정하는 경우가 많다.
                              center : ol.proj.fromLonLat([ 128.4, 35.7 ]),
                              zoom : 7
                           })
                        });

               });

</script>
<style type="text/css">
.toolBar {
   height: 900px;
   width: 15%;
   float: left;
}
.address {
   height: 50px;
}
.map {
   height: 850px;
   width: 85%;
   float: right;
}
.footer {
   height: 5%;
   width: 100%;
   clear: both; /* 부모 요소 아래로 내려가도록 함 */
   color: white;
   position: fiexd;
   bottom: 0;
   text-align: center;
}
.selectBar {
   padding: 5px 20px;
}
#sidoSelect {
   width: 90%;
}
#sggSelect {
   width: 90%;
}
#bjdSelect {
   width: 90%;
}
</style>
</head>
<body>
   <div>
		<div class="toolBar">
         <h1>메뉴</h1>
         <div class="selectBar">
            <select id="sidoSelect">
               <option>--시/도를 선택하세요--</option>
               <c:forEach items="${sdlist}" var="sido">
                  <option value="${sido.sd_cd}">${sido.sd_nm}</option>
               </c:forEach>
            </select>
         </div>
         <div class="selectBar">
            <select id="sggSelect">
               <option>--시/군/구를 선택하세요--</option>
            </select>
         </div>
         <div class="selectBar">
            <select id="bjdSelect">
               <option>--동/읍/면을 선택하세요--</option>
            </select>
            
          <div>
          <form id="form" enctype="multipart/form-data">
			<input type="file" id="file" name="file" accept="txt">
          </form>
                        <button type="button" id="fileBtn">파일 전송</button><hr>              
            	 </div>
	        </div>
		</div>

      <div>
        <div id="address" class="address">
            <h1>주소창</h1>
        </div>
       <div id="map" class="map">
       </div>
     	</div>
   	</div>
   <div class="footer">
      <h3>탄소배출량 표기 시스템</h3>
   </div>
</body>
</html>
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
   let sggBjdFlag;
   let ldLayer;
   var style;

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
	   
	   
	   				let sgg; 
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
								
								sggBjdFlag = "sgg";
                  
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
				                          
				                     
				                          sgg = response.sgglist;
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
				                              
				                              sggSelect.append("<option value='" +item.sgg_nm + "'>" + sgg2 + "</option>");
				                                })
				                         },
				                          error: function(xhr, status, error) {
				                              // 에러 발생 시 수행할 작업
				                               // alert('ajax 실패');
				                              // console.error("AJAX 요청 실패:", error);
				                          }
				                     });
				                  });
                  
				 let sggSelectedValue;
				 let s_cd;
                  $('#sggSelect').change(function() {
                                
                	  sggSelectedValue = $(this).val(); // sggSelect.append("<option value='" + item.sgg_nm + "'>" + sgg2 + "</option>");의 value 값을 sggSelectedValue에 담는다
                  	 
                                 if(sggSelectedValue) {
                                    var sggSelectedText = $(this).find('option:selected').text();
                                    updateAddress(null, sggSelectedText, null); //상단 시/군/구 노출
                                    
                                    sgg.forEach(function(map) {
                                        if (map.sgg_nm === sggSelectedValue) {
                                        	s_cd = map.sgg_cd;
                                        }
                                    });
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
                                          
  											console.log(response.bjdlist);
                                           
                                           
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
                     
                     sggBjdFalg = "bjd";
                     
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
                  
                  
                  $('#legendSelect').change(function() {
                	    var legend = $("#legendSelect").val();
                	    
                	    map.removeLayer(sdLayer);
                        map.removeLayer(sggLayer);
                        map.removeLayer(bjdLayer); 

                	    style = (legend === "1") ? 'totalusagedgg' : 'totalusagenature';

                	    alert((legend === "1") ? "등간격 스타일을 적용합니다." : "네추럴 브레이크 스타일을 적용합니다.");
                	    $.ajax({
                	        url: "/legend.do",
                	        type: 'POST',
                	        dataType: "json",
                	        data: {
                	            "legend": legend
                	        },
                	        success: function(result) {
                	        	alert("scd 코드"+s_cd );
                	        
                	            var bjd_CQL = "sgg_cd='" + s_cd + "'";
                	            var bjdSource = new ol.source.TileWMS({
                	                url: 'http://localhost:8080/geoserver/cite/wms?service=WMS',
                	                params: {
                	                    'VERSION': '1.1.0',
                	                    'LAYERS': 'cite:e2bjdview',
                	                    'CQL_FILTER': bjd_CQL,
                	                    'BBOX': [1.3873946E7, 3926728.0, 1.4411295E7, 4612208.0],
                	                    'SRS': 'EPSG:3857',
                	                    'FORMAT': 'image/png',
                	                    'TRANSPARENT': 'TRUE',
                	                    'STYLES': style,
                	                },
                	                serverType: 'geoserver',
                	            });
                	            
                	            ldLayer = new ol.layer.Tile({
                	                source: bjdSource,
                	                opacity: 0.5
                	            });
                	            map.addLayer(ldLayer);
	                	      	ldjaehee(style);
                	        },
                	        error: function() {
                	            alert("실패");
                	        }
                
                	    });
                	});
                  
                  // 팝업 오버레이 생성
                  var overlay = new ol.Overlay({
                    element: document.getElementById('popup'), // 팝업의 HTML 요소
                    positioning: 'bottom-center', // 팝업을 마커 아래 중앙에 위치시킴
                    offset: [0, -20], // 팝업을 마커 아래로 조정
                    autoPan: true // 팝업이 지도 영역을 벗어날 경우 자동으로 팝업 위치를 조정하여 보여줌
                  });
                  map.addOverlay(overlay);

                  // 팝업 닫기 버튼 요소 가져오기
                  var popupCloser = document.getElementById('popup-closer');

                  // 클릭 이벤트 리스너 설정
                  map.on('singleclick', function(evt) {
                    // 클릭한 지점의 좌표를 가져옴
                    var coordinate = evt.coordinate;
                    
                    if (sggBjdFlag == 'sgg') {
                        // 해당 좌표에서의 지리적 정보를 가져오는 요청을 서버에 보냄
                        var featureRequest = new ol.format.WFS().writeGetFeature({
                          srsName: 'EPSG:3857',
                          featureNS: 'http://localhost:8080/geoserver/cite',
                          featurePrefix: 'cite',
                          featureTypes: ['e2bjdview'],
                          outputFormat: 'application/json',
                          geometryName: 'geom',
                          filter: new ol.format.filter.Intersects('geom', new ol.geom.Point(coordinate))
                        });             
                    
                    } else if (sggBjdFlag == 'bjd'){
                    	// 해당 좌표에서의 지리적 정보를 가져오는 요청을 서버에 보냄
                    	var featureRequest = new ol.format.WFS().writeGetFeature({
                    	    srsName: 'EPSG:3857',
                    	    featureNS: 'http://localhost:8080/geoserver/cite',
                    	    featurePrefix: 'cite',
                    	    featureTypes: ['e2bjdview'],
                    	    outputFormat: 'application/json',
                    	    geometryName: 'geom',
                    	    filter: new ol.format.filter.Intersects('geom', new ol.geom.Point(coordinate))
                    	});             
                    }

                    // 서버에 요청 보내기
                    fetch('http://localhost:8080/geoserver/cite/wfs', {
                      method: 'POST',
                      body: new XMLSerializer().serializeToString(featureRequest)
                    })
                    .then(function(response) {
                    	let res = response.json();
                    	console.log(res);
                      return res;
                    })
                    .then(function(json) {
                      // 가져온 정보에서 단계 구분 값을 추출하여 팝업에 표시
                      if (json.features.length > 0) {
                        var properties = json.features[0].properties;
                        var sgg_pu = properties['sgg_pu']; // 예시: 구분 값의 키가 'sgg_cd'라 가정
                        var sgg_cd = properties['adm_sect_c']; 
                        var sgg_nm = properties['sgg_nm']; 
                        var totalusage = properties['totalusage'];
                        let bjd_nm = properties['bjd_nm'];
                        let bjd_cd = properties['bjd_cd'];
                        
                        // 팝업 내용을 구성
                        var popupContent;
                          popupContent = 
                             '<p>' + bjd_nm + '</p>'
                             + '<p>전력 사용량 : ' + totalusage.toLocaleString() + ' kWh' + '</p>';
                             
                           // 팝업 내용 설정
                           document.getElementById('popup-content').innerHTML = popupContent;
                           
                           // 팝업 위치 설정 및 보이기
                           overlay.setPosition(coordinate);
                        
                      } else {
                        alert('클릭한 지점에 대한 정보를 찾을 수 없습니다.');
                      }
                    });
                  });

                  // 팝업 닫기 버튼에 이벤트 리스너 추가
                  popupCloser.onclick = function() {
                    overlay.setPosition(undefined); // 팝업을 지도에서 제거
                    return false; // 이벤트 전파 방지
                  };
               });
   
   let legendSelected = 'nb';
	function ldjaehee(style) {
  		console.log(ldLayer);
         // sggLayer의 소스에 접근하여 파라미터 수정
         let source = ldLayer.getSource();
         let params = source.getParams();
         
         //범례 재구성
         fetchLegendInfo(style);        
   }


	function fetchLegendInfo(styleName) {
  // GeoServer의 REST API 엔드포인트 설정
 	const baseUrl = 'http://localhost:8080/geoserver';
  	const styleEndpoint = `${"${baseUrl}"}/rest/styles/${"${styleName}"}.sld`;

  // Ajax를 사용하여 범례 정보 가져오기
  $.ajax({
      url: styleEndpoint,
      dataType: 'xml',
      success: function(response) {
         
          // Ajax 요청이 성공했을 때 처리할 코드
          // 반환된 JSON 데이터에서 범례 정보 추출 및 처리
          let breakValues = extractRuleNames(response);
          console.log('Break Values:', breakValues);
          updateLegend(breakValues);

          // 여기서 범례 이미지 URL을 사용하여 이미지를 화면에 표시하거나 추가적인 처리를 할 수 있습니다.
      },
      error: function(xhr, status, error) {
          // Ajax 요청이 실패했을 때 처리할 코드
          console.error('Error:', error);
      }
  });
}

function extractRuleNames(sldXml) {
  const ruleNames = [];

  // SLD XML을 jQuery 객체로 변환
  const $xml = $(sldXml);

  // 각 분류(Classification) 요소를 찾아 반복
  $xml.find('sld\\:FeatureTypeStyle > sld\\:Rule').each(function() {
      const $rule = $(this);

      // Rule 내의 se:Name 요소의 텍스트 값을 추출하여 배열에 추가
      const ruleName = $rule.find('sld\\:Name').text().trim();
      console.log('rule : ' + ruleName);
      ruleNames.push(ruleName);
  });

  return ruleNames;
}

function updateLegend(breakValues) {
  const legendContainer = document.querySelector('.legend');

  // 먼저 기존의 legend-item 요소를 모두 제거합니다.
  const legendItems = document.querySelectorAll('.legend-item');
  legendItems.forEach(item => item.remove());

  // breakValues 배열을 순회하면서 legend-item을 생성하고 legendContainer에 추가합니다.
  breakValues.forEach((value, index) => {
      const legendItem = document.createElement('div');
      legendItem.classList.add('legend-item');

      // 값을 "-" 기준으로 분리하여 숫자 부분만 추출합니다.
      const [start, end] = value.split('-').map(Number);
      
      // 숫자를 locale string으로 변환하여 읽기 쉽게 만듭니다.
      const formattedStart = start.toLocaleString();
      const formattedEnd = end.toLocaleString();           
      
      // 연결된 문자열을 생성합니다.
      const stringValue = `${"${formattedStart}"} ~ ${"${formattedEnd}"}`;           
      
      const colorSpan = document.createElement('span');
      if(style == 'totalusagedgg'){
    	  colorSpan.style.backgroundColor = getColorDgg(); // getColor 함수는 각 값에 해당하는 색상을 반환하는 것으로 가정합니다.
      }else if(style == 'totalusagenature'){
    	  colorSpan.style.backgroundColor = getColorNature(); // getColor 함수는 각 값에 해당하는 색상을 반환하는 것으로 가정합니다.
      }
    
      const textNode = document.createTextNode(stringValue);
      legendItem.appendChild(colorSpan);
      legendItem.appendChild(textNode);
      
      legendContainer.appendChild(legendItem);
  });
  
  // legend 클래스를 보이도록 변경
  legendContainer.style.display = 'block';
}

let counter = 0; // getColor 함수 외부에서 선언하여 값이 유지되도록 수정
function getColorNature() {
  let color = '#ffffff'; // 기본값으로 흰색을 지정

  // counter 변수를 사용하여 다른 색상을 반환
  switch (counter) {
      case 0:
          color = '#ffffff'; // 흰색
          break;
      case 1:
          color = '#ffbfbf'; // 연한 분홍색
          break;
      case 2:
          color = '#ff8080'; // 분홍색
          break;
      case 3:
          color = '#ff4040'; // 적색
          break;
      case 4:
          color = '#ff0000'; // 빨간색
          break;
  }
  
  counter = (counter + 1) % 5; // 0부터 4까지 반복되도록 설정

  return color;


  // counter 값을 증가시킴
 
} 
function getColorDgg() {
	  let color = '#ffffff'; // 기본값으로 흰색을 지정

	  // counter 변수를 사용하여 다른 색상을 반환
	  switch (counter) {
	      case 0:
	          color = '#ffffff'; // 흰색
	          break;
	      case 1:
	          color = '##fff9ce'; // 연한 노랑색
	          break;
	      case 2:
	          color = '##fff39c'; // 노랑색
	          break;
	      case 3:
	          color = '#ffee6a'; // 진한 노랑색
	          break;
	      case 4:
	          color = '#ffe839'; // 엄청 진한 노랑색
	          break;
	  }
	  counter = (counter + 1) % 5; // 0부터 4까지 반복되도록 설정

	  return color;
}

</script>
<style type="text/css">

   /* 범례 스타일 */
   .legend {
     background-color: rgba(255, 255, 255, 0.8);
     border: 1px solid #ccc;
     border-radius: 5px;
     padding: 10px;
     position: absolute;
     bottom: 20px;
     right: 20px;
     z-index: 1000;
     display: none;
   }
   
   .legend-title {
     font-weight: bold;
     margin-bottom: 5px;
   }
   
   .legend-item {
     margin-bottom: 5px;
   }
   
   .legend-item span {
     display: inline-block;
     width: 20px;
     height: 10px;
     margin-right: 5px;
   }  

  /* 폰트 스타일 */
  body {
    font-family: 'Arial', sans-serif; /* 여기에 사용할 원하는 폰트 이름을 넣어주세요 */
  }
  
  /* 팝업 스타일 */
  .popup {
    position: relative;
    background-color: #ffffff;
    border-radius: 10px;
    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.3);
    padding: 20px;
    width: 250px; /* 가로폭 조정 */
    font-size: 16px;
    color: #333; /* 폰트 색상 */
    line-height: 1.5; /* 줄간격 조정 */
    font-weight: bold; /* 폰트 굵기 */
  }

  /* 팝업 닫기 버튼 스타일 */
  .popup-closer {
    position: absolute;
    top: 5px;
    right: 5px;
    font-size: 20px; /* X 아이콘 크기 */
    color: #888; /* X 아이콘 색상 */
    text-decoration: none;
    transition: color 0.3s ease;
    font-weight: bold; /* 폰트 굵기 */
    line-height: 1; /* 세로 정렬 */
  }

  .popup-closer:hover {
    color: #555; /* 호버 시 색상 변경 */
  }
  
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

   <!-- 팝업을 나타내는 HTML 요소 -->
   <div id="popup" class="popup">
     <a href="#" id="popup-closer" class="popup-closer">&times;</a>
     <div id="popup-content"></div>
   </div>
   
      <!-- 범례 요소 -->
   <div class="legend">
     <div class="legend-title">전력 사용량 범례 (단위 kWh)</div>
     
     <div class="legend-item">
       <span style="background-color: #ff0000;"></span> 0 - 100
     </div>
     <div class="legend-item">
       <span style="background-color: #ffcc00;"></span> 101 - 200
     </div>
     <div class="legend-item">
       <span style="background-color: #00ff00;"></span> 201 - 300
     </div>
   </div>   
   
   <div>
		<div class="toolBar">
         <h1>탄소공간지도</h1>
         <div class="selectBar">
                
           <select id="sidoSelect">
               <option>--시/도를 선택하세요--</option>
               <c:forEach items="${sdlist}" var="sido"> <!-- Controller.java에서 model에서 보내서 씀 -->
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
            
               
          <select id="legendSelect" name="legendSelect">
                    <option value="default">범례 선택</option>
                    <option value="1">등간격</option>
                    <option value="2">네추럴 브레이크</option>
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
            <h1>주소 표시창</h1>
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
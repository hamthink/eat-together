
function toChatroom(num){
    var option = "width = 800, height = 800, top = 100, left = 200, scrollbars=no"
    window.open("/chat/chatroom?roomNum="+num, num, option);
}
function partyJoin(seq){
	location.href="/party/partyJoin?seq="+seq;
}
function toStopRecruit(seq, writer){
	var ask = confirm("모집종료 후에는 되돌릴 수 없습니다. \n 정말 모집을 종료하시겠습니까?");
	if (ask) {
	location.href= "/party/stopRecruit?seq="+seq+"&writer="+writer;
	}
}
function partyModify(seq){
	location.href = "/party/partymodify?seq="+seq;
}
function partyDelete(seq){
	var ask = confirm("삭제 후에는 복구할 수 없습니다.\n 정말 삭제하겠습니까?");
	if (ask) {
		location.href = "/party/partydelete?seq="+seq;
	}
}
function toExitParty(seq){
	var ask = confirm("정말 모임을 나가시겠습니까?");
	if (ask) {
		location.href= "/party/toExitParty?seq="+seq;
	}
}
function toRestartRecruit(seq, writer){
	var ask = confirm("모집을 다시 시작하겠습니까?");
	if (ask) {
		location.href= "/party/restartRecruit?seq="+seq+"&writer="+writer;
	}
}
function partyReport(num, report_id, title, content){
	$.ajax({
		url:"/party/party_report",
		data : { seq : num, report_id : report_id , title : title , content : content},
		success : function(result) {
			if (result == 1){ 
				alert("신고가 정상적으로 접수되었습니다.");	
				if (self.name != 'reload') {
			         self.name = 'reload';
			         self.location.reload(true);
			     }
			     else self.name = ''; 
			}else{
				alert("무분별한 신고를 방지하기 위해 신고는 한번만 가능합니다.");
			}
		},
		error:function(e){
			console.log("error");
		}
	});	
}
function reviewReport(seq,content,id){
	var ask = confirm("허위신고일 경우 피해가 되돌아올 수 있습니다. \n정말 신고하시겠습니까?\n신고할 사용자 : "+id+"\n신고할 리뷰 내용 : "+content);
	if(ask){
		$.ajax({
			url:"/review/report",
			data : { seq : seq, report_id : id , content : content},
			success : function(result) {
				if (result == 1){ 
					alert("신고가 정상적으로 접수되었습니다.");	
				}else if(result == 0){
					alert("무분별한 신고를 방지하기 위해 신고는 한번만 가능합니다.");
				}
			},
			error:function(e){
				console.log("error");
			}
		});
	}
}


$(function () {
	  $('[data-toggle="tooltip"]').tooltip();
})

$(function(){
		/****************** 스타일 관련 영역 ******************/
		$('#Progress_Loading').hide(); //첫 시작시 로딩바를 숨겨준다.
	    $('.cropping img').each(function (index, item) {
	        if ($(this).height() / $(this).width() < 0.567) {
	            $(this).addClass('landscape').removeClass('portrait');
	        } else {
	            $(this).addClass('portrait').removeClass('landscape');
	        }
	    });
		/****************** 카카오맵 영역 ******************/
	    var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	    mapOption = { 
	        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
	        level: 6 // 지도의 확대 레벨 
	    };
		// 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
		var map = new kakao.maps.Map(mapContainer, mapOption); 
		map.setMaxLevel(13);
		map.panBy(100, 50);
		// HTML5의 geolocation으로 사용할 수 있는지 확인합니다 
		var currentPositionMarker = null;
		var currentPositionOverlay = null;
	    if (navigator.geolocation) {
	        // GeoLocation을 이용해서 접속 위치를 얻어옵니다
	        navigator.geolocation.getCurrentPosition(function(position) {
	            var lat = position.coords.latitude, // 위도
	                lon = position.coords.longitude; // 경도
	            var locPosition = new kakao.maps.LatLng(lat, lon), // 마커가 표시될 위치를 geolocation으로 얻어온 좌표로 생성합니다
	                message = '당신의 위치'; // 인포윈도우에 표시될 내용입니다
	            // 마커와 인포윈도우를 표시합니다
	            currentPositionMarker = displayMarker(locPosition, message, currentPositionOverlay);
	            if($("#markerLat").text()!=""){
	            	map.setCenter(new kakao.maps.LatLng($("#markerLat").text(), $("#markerLng").text()));
	            	map.setLevel(2);
	            }
	          });
	    } else { // HTML5의 GeoLocation을 사용할 수 없을때 마커 표시 위치와 인포윈도우 내용을 설정합니다
	        var locPosition = new kakao.maps.LatLng(33.450701, 126.570667),    
	            message = 'geolocation을 사용할수 없어요..';
	        currentPositionMarker = displayMarker(locPosition, message, currentPositionOverlay);
            if($("#markerLat").text()!=""){
            	map.setCenter(new kakao.maps.LatLng($("#markerLat").text(), $("#markerLng").text()));
            	map.setLevel(2);
            }
	    }
	    function displayMarker(locPosition, message, currentPositionOverlay) { // SSL 인증 위치 중심 확인용 인포윈도우
	        var marker = new kakao.maps.Marker({  
	            map: map, 
	            position: locPosition
	        }); 
	        kakao.maps.event.addListener(marker, 'click', function(mouseEvent) {
	        	map.setLevel(3);
	        	map.setCenter(locPosition);
	        });
			currentPositionOverlay = new kakao.maps.CustomOverlay({
	            position: locPosition,
	            content: '<div class="custom">' +
    	        '  <div>' +
    	        '    <span class="here">'+message+'</span>' +
    	        '  </div>' +
    	        '</div>'
	        });
			currentPositionOverlay.setMap(map);
	        map.setCenter(locPosition); 

		    return {marker:marker, customOverlay:currentPositionOverlay};
	    }  
	    function deleteMarker(marker, customOverlay) {
	    	marker.setMap(null);
	    	customOverlay.setMap(null);
	    } 
		// 마커 클러스터러 : 맛집으로 등록된 마커는 이것으로 표시!
	    var clusterer = new kakao.maps.MarkerClusterer({
	        map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체 
	        averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정 
	        minLevel: 5, // 클러스터 할 최소 지도 레벨 
	        calculator: [10, 30, 50], // 클러스터의 크기 구분 값, 각 사이값마다 설정된 text나 style이 적용된다
	        texts: getTexts, // texts는 ['삐약', '꼬꼬', '꼬끼오', '치멘'] 이렇게 배열로도 설정할 수 있다 
	        styles: [{ // calculator 각 사이 값 마다 적용될 스타일을 지정한다
	                width : '30px', height : '30px',
	                background: 'rgba(255, 153, 0, .8)',
	                borderRadius: '15px',
	                color: '#fff',
	                textAlign: 'center',
	                fontWeight: 'bold',
	                lineHeight: '31px'
	            },
	            {
	                width : '40px', height : '40px',
	                background: 'rgba(255, 153, 0, .8)',
	                borderRadius: '20px',
	                color: '#fff',
	                textAlign: 'center',
	                fontWeight: 'bold',
	                lineHeight: '41px'
	            },
	            {
	                width : '50px', height : '50px',
	                background: 'rgba(255, 153, 0, .8)',
	                borderRadius: '25px',
	                color: '#fff',
	                textAlign: 'center',
	                fontWeight: 'bold',
	                lineHeight: '51px'
	            },
	            {
	                width : '60px', height : '60px',
	                background: 'rgba(255, 153, 0, .8)',
	                borderRadius: '30px',
	                color: '#fff',
	                textAlign: 'center',
	                fontWeight: 'bold',
	                lineHeight: '61px'
	            }
	        ]
	    });
	    // 클러스터 내부에 삽입할 문자열 생성 함수입니다 
	    function getTexts( count ) {

	      // 한 클러스터 객체가 포함하는 마커의 개수에 따라 다른 텍스트 값을 표시합니다 
	      if(count < 10) {
	        return count;        
	      } else if(count < 30) {
	        return count;
	      } else if(count < 50) {
	        return count;
	      } else {
	        return count;
	      }
	    }
	    
	    var notmapclusterer = new kakao.maps.MarkerClusterer({
	        map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체 
	        averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정 
	        minLevel: 5, // 클러스터 할 최소 지도 레벨 
	        calculator: [10, 30, 50], // 클러스터의 크기 구분 값, 각 사이값마다 설정된 text나 style이 적용된다
	        texts: notmapGetTexts, // texts는 ['삐약', '꼬꼬', '꼬끼오', '치멘'] 이렇게 배열로도 설정할 수 있다 
	        styles: [{ // calculator 각 사이 값 마다 적용될 스타일을 지정한다
	                width : '30px', height : '30px',
	                background: 'rgba(255, 255, 255, .8)',
	                borderRadius: '15px',
	                color: '#000',
	                textAlign: 'center',
	                fontWeight: 'bold',
	                lineHeight: '31px'
	            },
	            {
	                width : '40px', height : '40px',
	                background: 'rgba(255, 255, 255, .8)',
	                borderRadius: '20px',
	                color: '#000',
	                textAlign: 'center',
	                fontWeight: 'bold',
	                lineHeight: '41px'
	            },
	            {
	                width : '50px', height : '50px',
	                background: 'rgba(255, 255, 255, .8)',
	                borderRadius: '25px',
	                color: '#000',
	                textAlign: 'center',
	                fontWeight: 'bold',
	                lineHeight: '51px'
	            },
	            {
	                width : '60px', height : '60px',
	                background: 'rgba(255, 255, 255, .8)',
	                borderRadius: '30px',
	                color: '#000',
	                textAlign: 'center',
	                fontWeight: 'bold',
	                lineHeight: '61px'
	            }
	        ]
	    });
	    
	    // 클러스터 내부에 삽입할 문자열 생성 함수입니다 
	    function notmapGetTexts( count ) {
	      // 한 클러스터 객체가 포함하는 마커의 개수에 따라 다른 텍스트 값을 표시합니다 
	      if(count < 10) {
	        return count;        
	      } else if(count < 30) {
	        return count;
	      } else if(count < 50) {
	        return count;
	      } else {
	        return count;
	      }
	    }
		$("#centerLat").text(map.getCenter().getLat());
	    $("#centerLng").text(map.getCenter().getLng());

		// MakrerImage 객체를 생성하여 반환하는 함수입니다
		function createMarkerImage(markerSize, offset, markerImageSrc) {
		    var markerImage = new kakao.maps.MarkerImage(
		    	markerImageSrc, // 마커 이미지 URL
		        markerSize, // 마커의 크기
		        {
		            offset: offset, // 마커 이미지에서의 기준 좌표
		        }
		    );
		    return markerImage;
		}
	    // 인포윈도우를 표시하는 클로저를 만드는 함수입니다 
	    function makeOverListener(map, marker, infowindow) {
	        return function() {
	            infowindow.open(map, marker);
	        };
	    }

	    // 인포윈도우를 닫는 클로저를 만드는 함수입니다 
	    function makeOutListener(infowindow) {
	        return function() {
	            infowindow.close();
	        };
	    }
	    
	    function pushMarker(po) {
			var markerSize = new kakao.maps.Size(10, 10),
				markerOffset = new kakao.maps.Point(0, 0);
			var normalImageSrc = 'https://eat-together.s3.ap-northeast-2.amazonaws.com/img.png';
			var hoverImageSrc = 'https://eat-together.s3.ap-northeast-2.amazonaws.com/img-hover.png';
			
	        var normalImage = createMarkerImage(markerSize, markerOffset, normalImageSrc),
	        	hoverImage = createMarkerImage(markerSize, markerOffset, hoverImageSrc);
	        var marker = new kakao.maps.Marker({
	            map: map,
	            position: po.latlng,
	            image: normalImage
	        });
	        notmapclusterer.addMarker(marker);
	        var customOverlay = new kakao.maps.CustomOverlay({
	            position: po.latlng,
	            content: po.content
	        });
	        // 인포윈도우를 표시하는 클로저를 만드는 함수입니다 
			function infoOverSet(map) {
			    customOverlay.setMap(map);
			}
			// 인포윈도우를 닫는 클로저를 만드는 함수입니다 
			function infoOverClose() {
			    customOverlay.setMap(null);
			}
	        marker.normalImage = normalImage;
	        kakao.maps.event.addListener(marker, 'mouseover', function() {
	                marker.setImage(hoverImage);
	                marker.setZIndex(1);
	                infoOverSet(marker.getMap());
	        });
	        kakao.maps.event.addListener(marker, 'mouseout', function() {
	                marker.setImage(normalImage);
	                infoOverClose();
	                marker.setZIndex(0);
	        });
	        kakao.maps.event.addListener(marker, 'click', function(mouseEvent) {
				$.each(customOverlayArray, function(i, item) {
					infoOverClose(item.customOverlay);
				});
                // 클릭했을 때 정보값 출력 ? 
	        	$.ajax({
	        		url:'/map/selectKakaoMarkerInfo',
	        		data:{place_id:po.place_id,category:po.category},
	        		dataType:"JSON"
	        	}).done(function(resp){
					$(".choose_info").html("");
					$(".search_result").html("");
					var info = $("<div class='info'></div>");
					info.append("<div class='category' style='font-size:10pt;'>"+resp.result.category_group_name+"</div>");
					info.append("<div class='place_name' style='font-size:12pt;'><b>"+resp.result.place_name+"</b></div>");
					info.append("<div class='place_id' style='display:none;'>"+resp.result.id+"</div>");
					info.append("<div class='lat' style='display:none;'>"+resp.result.y+"</div>");
					info.append("<div class='lng' style='display:none;'>"+resp.result.x+"</div>");
					info.append("<div class='road_address' style='display:none;'>"+resp.result.road_address_name+"</div>");
					info.append("<div class='place_url' style='display:none;'>"+resp.result.place_url+"</div>");
					info.append("<div class='address' style='font-size:10pt;'>"+resp.result.address_name+"</div>");
					info.append("<div class='phone' style='font-size:10pt;'>"+resp.result.phone+"</div><br>");
					info.append("<h style='font-size:10pt;'>아직 등록되지 않은 맛집입니다.<br>모임을 모집해 맛집으로 등록해보세요!</h>");
					info.append("<button type='button' class='btn btn-primary' id='recruit' style='margin-top:10px;'>내가 직접 모집하기</button>")
					$(".search_result").append(info);
					$(".search_result").css('max-height','700px');
					$(".navi_btn").html('<i class="fas fa-chevron-left"></i>');
					$("#sideBar").animate({right:0},1000);
	        	})
	        });
	        return marker;
	    }
	    $(document).on("click","#recruit",function(){
	    	location.href = "/map/toParty_New?name="+$(this).closest(".info").find(".place_name b").text()
	    									+"&address="+$(this).closest(".info").find(".address").text()
	    									+"&road_address="+$(this).closest(".info").find(".road_address").text()
	    									+"&category="+$(this).closest(".info").find(".category").text()
	    									+"&lat="+$(this).closest(".info").find(".lat").text()
	    									+"&lng="+$(this).closest(".info").find(".lng").text()
	    									+"&phone="+$(this).closest(".info").find(".phone").text()
	    									+"&place_url="+$(this).closest(".info").find(".place_url").text()
	    									+"&place_id="+$(this).closest(".info").find(".place_id").text();
	    })
	    $("#mapRecruit").on("click",function(){
	    	location.href = "/map/mapToParty_New?parent_name="+$(this).closest(".partylist").siblings(".store_info").find(".name").text()
								    						+"&parent_address="+$(this).closest(".partylist").siblings(".store_info").find(".address").text()
								    						+"&img="+$(this).closest(".partylist").siblings(".store_info").find("img").attr("src")
								    						+"&place_id="+$(this).closest(".partylist").siblings(".store_info").find(".place_id").text()
								    						+"&category="+$(this).closest(".partylist").siblings(".store_info").find(".category").text();
	    })

	    var kakaoCafeMarkers = [];
	    var kakaoFoodMarkers = [];
		function createMapTableMarker(positions, image){
			var markers = [];
			positions.forEach(function(pos){
				var marker = new kakao.maps.Marker({
			        map: map, 
			        position: pos.latlng,
			        image: image
			    });
				var customOverlay = new kakao.maps.CustomOverlay({
		            position: pos.latlng,
		            content: pos.content
		        });
				function infoOverSet(map) {
					customOverlay.setMap(map);
				}
				function infoOverClose() {
					customOverlay.setMap(null);
				}
			    kakao.maps.event.addListener(marker, 'click', function(mouseEvent) {      
			        location.href = "/map/selectMarkerInfo?place_id="+pos.place_id;
			    });
				kakao.maps.event.addListener(marker, 'mouseover', function() {
	                infoOverSet(marker.getMap());
	                marker.setZIndex(1);
		        });
		        kakao.maps.event.addListener(marker, 'mouseout', function() {
		            infoOverClose();
	                marker.setZIndex(0);
		        });
                markers.push({
	    	        marker: marker
	    		});
	    		clusterer.addMarker(marker);
			});
			return markers;
		}
		
		var cafeMarkers = null;
		var foodMarkers = null;
		var cafePartyMarkers = null;
		var foodPartyMarkers = null;
		var cafeTopMarkers = null;
		var foodTopMarkers = null;
		

		$.get("/resources/json/mapData.json").done(function(data){
			var cafePositions = [];
			var foodPositions = [];
			var cafePartyPositions = [];
			var foodPartyPositions = [];
			var cafeTopPositions = [];
			var foodTopPositions = [];
			
			var normalCafeImageSrc = 'https://eat-together.s3.ap-northeast-2.amazonaws.com/Asset6.png', 
			normalFoodImageSrc = 'https://eat-together.s3.ap-northeast-2.amazonaws.com/Asset5.png'
			partyCafeImageSrc = 'https://eat-together.s3.ap-northeast-2.amazonaws.com/Asset3.png',
			partyFoodImageSrc = 'https://eat-together.s3.ap-northeast-2.amazonaws.com/Asset4.png', 
			topCafeImageSrc = 'https://eat-together.s3.ap-northeast-2.amazonaws.com/Asset2.png',
			topFoodImageSrc = 'https://eat-together.s3.ap-northeast-2.amazonaws.com/Asset1.png',  
		    baseImageSize = new kakao.maps.Size(40, 60), // 마커이미지의 크기입니다
		    baseImageOption = {offset: new kakao.maps.Point(20, 69)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
		    var normalCafeImage = new kakao.maps.MarkerImage(normalCafeImageSrc, baseImageSize, baseImageOption);
		    var normalFoodImage = new kakao.maps.MarkerImage(normalFoodImageSrc, baseImageSize, baseImageOption);
		    var partyCafeImage = new kakao.maps.MarkerImage(partyCafeImageSrc, baseImageSize, baseImageOption);
		    var partyFoodImage = new kakao.maps.MarkerImage(partyFoodImageSrc, baseImageSize, baseImageOption);
		    var topCafeImage = new kakao.maps.MarkerImage(topCafeImageSrc, baseImageSize, baseImageOption);
		    var topFoodImage = new kakao.maps.MarkerImage(topFoodImageSrc, baseImageSize, baseImageOption);
			
			$.each(data, function(i, item) { 
				if(item.top!=undefined){
					if(item.category == '카페'){
						cafeTopPositions.push({
							content: '<div class="mapcustomoverlay">' +
			    	        '  <a href="'+item.place_url+'" target="_blank">' +
			    	        '    <span class="category">'+ item.category +'</span>' +
			    	        '    <span class="title">'+ item.name +'</span>' +
			    	        '    <span class="address">'+ item.address +'</span>' +
			    	        '  </a>' +
			    	        '</div>', 
							latlng: new kakao.maps.LatLng(item.lat, item.lng),
							place_id: item.place_id
						})
					}else{
						foodTopPositions.push({
							content: '<div class="mapcustomoverlay">' +
			    	        '  <a href="'+item.place_url+'" target="_blank">' +
			    	        '    <span class="category">'+ item.category +'</span>' +
			    	        '    <span class="title">'+ item.name +'</span>' +
			    	        '    <span class="address">'+ item.address +'</span>' +
			    	        '  </a>' +
			    	        '</div>', 
							latlng: new kakao.maps.LatLng(item.lat, item.lng),
							place_id: item.place_id
						})
					}
				}else{
					if(item.category == '카페'){
						if(item.partyOn > 0){
							cafePartyPositions.push({
								content: '<div class="mapcustomoverlay">' +
				    	        '  <a href="'+item.place_url+'" target="_blank">' +
				    	        '    <span class="category">'+ item.category +'</span>' +
				    	        '    <span class="title">'+ item.name +'</span>' +
				    	        '    <span class="address">'+ item.address +'</span>' +
				    	        '  </a>' +
				    	        '</div>', 
								latlng: new kakao.maps.LatLng(item.lat, item.lng),
								place_id: item.place_id
							});				
						}else if(item.partyOn == 0){
							cafePositions.push({
								content: '<div class="mapcustomoverlay">' +
				    	        '  <a href="'+item.place_url+'" target="_blank">' +
				    	        '    <span class="category">'+item.category +'</span>' +
				    	        '    <span class="title">'+ item.name +'</span>' +
				    	        '    <span class="address">'+ item.address +'</span>' +
				    	        '  </a>' +
				    	        '</div>', 
								latlng: new kakao.maps.LatLng(item.lat, item.lng),
								place_id: item.place_id
							});		
						}
					}else if(item.category == '음식점'){
						if(item.partyOn > 0){
							foodPartyPositions.push({
								content: '<div class="mapcustomoverlay">' +
				    	        '  <a href="'+item.place_url+'" target="_blank">' +
				    	        '    <span class="category">'+ item.category +'</span>' +
				    	        '    <span class="title">'+ item.name +'</span>' +
				    	        '    <span class="address">'+ item.address +'</span>' +
				    	        '  </a>' +
				    	        '</div>', 
								latlng: new kakao.maps.LatLng(item.lat, item.lng),
								place_id: item.place_id
							});
						}else if(item.partyOn == 0){
							foodPositions.push({
								content: '<div class="mapcustomoverlay">' +
				    	        '  <a href="'+item.place_url+'" target="_blank">' +
				    	        '    <span class="category">'+ item.category +'</span>' +
				    	        '    <span class="title">'+ item.name +'</span>' +
				    	        '    <span class="address">'+ item.address +'</span>' +
				    	        '  </a>' +
				    	        '</div>', 
								latlng: new kakao.maps.LatLng(item.lat, item.lng),
								place_id: item.place_id
							});
						}
					}					
				}
			});
			cafeMarkers = createMapTableMarker(cafePositions, normalCafeImage); // 일반 카페
			foodMarkers = createMapTableMarker(foodPositions, normalFoodImage); // 일반 음식점
			cafePartyMarkers = createMapTableMarker(cafePartyPositions, partyCafeImage); // 모임 모집중인 카페
			foodPartyMarkers = createMapTableMarker(foodPartyPositions, partyFoodImage); // 모임 모집중인 음식점
			cafeTopMarkers = createMapTableMarker(cafeTopPositions, topCafeImage); // 리뷰 평균 Top 카페
			foodTopMarkers = createMapTableMarker(foodTopPositions, topFoodImage); // 리뷰 평균 Top 음식점
		}).fail(function(jqXHR, textStatus, errorThrown) { location.href = "/map/toMap"; });
		
		// 지도 확대 축소를 제어할 수 있는  줌 컨트롤을 생성합니다
		var zoomControl = new kakao.maps.ZoomControl();
		map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

		// 지도가 확대 또는 축소되면 마지막 파라미터로 넘어온 함수를 호출하도록 이벤트를 등록합니다
		/* kakao.maps.event.addListener(map, 'zoom_changed', function() {        
		    
		    // 지도의 현재 레벨을 얻어옵니다
		    var level = map.getLevel();
		    
		    var message = '지도를 확대해주세요.';
		    var resultDiv = document.getElementById('result');  
		    resultDiv.innerHTML = message;
		    
		}); */
		
		// 주소-좌표 변환 객체를 생성합니다
		var geocoder = new kakao.maps.services.Geocoder();

		// 중심 좌표나 확대 수준이 변경됐을 때 지도 중심 좌표에 대한 주소 정보를 표시하도록 이벤트를 등록합니다
		kakao.maps.event.addListener(map, 'idle', function() {
		    searchAddrFromCoords(map.getCenter(), displayCenterInfo);
		    $("#centerLat").text(map.getCenter().getLat());
		    $("#centerLng").text(map.getCenter().getLng());
		});

		function searchAddrFromCoords(coords, callback) {
		    // 좌표로 행정동 주소 정보를 요청합니다
		    geocoder.coord2RegionCode(coords.getLng(), coords.getLat(), callback);         
		}

		function searchDetailAddrFromCoords(coords, callback) {
		    // 좌표로 법정동 상세 주소 정보를 요청합니다
		    geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
		}

		// 지도 좌측상단에 지도 중심좌표에 대한 주소정보를 표출하는 함수입니다
		function displayCenterInfo(result, status) {
		    if (status === kakao.maps.services.Status.OK) {
		        var infoDiv = document.getElementById('centerAddr');

		        for(var i = 0; i < result.length; i++) {
		            // 행정동의 region_type 값은 'H' 이므로
		            if (result[i].region_type === 'H') {
		                // infoDiv.innerHTML = result[i].address_name;
		                break;
		            }
		        }
		    }    
		}
        var positions = [];
		$(".foodInsert").on("click",function(){ // 음식점 입력
			alert("현재 지도 중심 좌표로부터 20km 반경의 주변 장소를 불러옵니다.");
        	$.ajax({
        		url:"/map/foodInsert",
        		type:"get",
        		data:{
        			lat:$("#centerLat").text(),
        			lng:$("#centerLng").text()},
        		dataType:"JSON"
        	}).done(function(resp){
        		var result = "";
        		if(resp.length>0){
        			for(i = 0;i < resp.length;i++){
        				result = result + "\n " + (i + 1) + "." + resp[i].place_name;
        			}
        			alert("미등록 장소(음식점) 총 "+resp.length+"개 입력 완료!\n" + result);
        		}else if(resp.length == 0){
        			alert("현재 지도 중심 좌표로부터 20km 반경의 \n주변 장소는 이미 입력되어 있습니다.\n\n지도의 중심을 이동해보세요.");
        		}
        		var iCHK = 1;
        		for(var i = 0;i<iCHK;i++)
        		{
        		document.location.reload();
        		}
        	}).fail(function(error1,error2){
        		console.log(error1);
        		console.log(error2);
        	})
		})
		$(".cafeInsert").on("click",function(){ // 카페 입력
			alert("현재 지도 중심 좌표로부터 20km 반경의 주변 장소를 불러옵니다.");
        	$.ajax({
        		url:"/map/cafeInsert",
        		type:"get",
        		data:{
        			lat:$("#centerLat").text(),
        			lng:$("#centerLng").text()},
        		dataType:"JSON"
        	}).done(function(resp){
        		var result = "";
        		if(resp.length>0){
        			for(i = 0;i < resp.length;i++){
        				result = result + "\n " + (i + 1) + "." + resp[i].place_name;
        			}
        			alert("미등록 장소(카페) 총 "+resp.length+"개 입력 완료!\n" + result);
        		}else if(resp.length == 0){
        			alert("현재 지도 중심 좌표로부터 20km 반경의 \n주변 장소는 이미 입력되어 있습니다.\n\n지도의 중심을 이동해보세요.");
        		}
        		var iCHK = 1;
        		for(var i = 0;i<iCHK;i++)
        		{
        		document.location.reload();
        		}
        	}).fail(function(error1,error2){
        		console.log(error1);
        		console.log(error2);
        	})
		})
		$(".join").on("click",function(){ // 참가
			$.ajax({
				url:"/map/getPartyInfo",
				data:{seq:$(this).parent().find(".seq").text(),
					partyFullCheck:$(this).parent().find(".partyFullCheck").text(),
					partyParticipantCheck:$(this).parent().find(".partyParticipantCheck").text(),
					partylife:$(this).parent().find(".partylife").text()},
				dataType:"JSON"
			}).done(function(resp){
				$("#partyModal #exampleModalLabel b").text(resp.pdto.title);
				$("#partyModal .writer").text(resp.pdto.writer);
				$("#partyModal .parent_name").text(resp.pdto.parent_name);
				$("#partyModal .parent_address").text(resp.pdto.parent_address);
				$("#partyModal .meetdate").text(resp.pdto.meetdate);
				$("#partyModal .count").text(resp.pdto.count);
				if(resp.pdto.gender == 'a'){
					$("#partyModal .gender").text("혼성모임");
				}else if(resp.pdto.gender == 'f'){
					$("#partyModal .gender").text("여성만");
				}else if(resp.pdto.gender == 'm'){
					$("#partyModal .gender").text("남성만");
				}
				$("#partyModal .age").html("");
				if(resp.pdto.age.includes(",")){
					var ages = resp.pdto.age.split(",");
					for(var i = 0;i < ages.length;i++){
						$("#partyModal .age").append('<span class="badge badge-pill badge-light">'+ ages[i] + '대</span>');
					}
				}else{
					$("#partyModal .age").append("<span class='badge badge-pill badge-light'>" + resp.pdto.age + "대만</span>");
				}
				if(resp.pdto.drinking == 1){
					$("#partyModal .drinking").text("음주OK");
				}else if(resp.pdto.drinking == 0){
					$("#partyModal .drinking").text("음주NO");
				}
				$("#partyModal .content").text(resp.pdto.content);
				$(".modal-footer").html("");
				if((resp.partyFullCheck == false && resp.pdto.status == 1) && resp.partyParticipantCheck == false){
					if((resp.mdto.gender == 1 && resp.pdto.gender == 'm')||(resp.mdto.gender == 2 && resp.pdto.gender == 'f')||resp.pdto.gender == 'a'){
						$("#partyModal .modal-footer").append('<button type="button" id="toPartyJoin" class="btn btn-success" onClick=\"partyJoin('+resp.pdto.seq+');\">모임참가하기</button>');						
					}
				}else if(resp.partyParticipantCheck == true){
					if(resp.partylife == 'alive'){
						$("#partyModal .modal-footer").append('<button type="button" id="toChatroom" class="btn btn-primary" onClick=\"toChatroom('+resp.pdto.seq+');\">채팅방으로 이동</button>');
					}
					if(resp.pdto.writer != resp.mdto.nickname){
						$("#partyModal .modal-footer").append('<button type="button" id="toExitParty" class="btn btn-danger" onClick=\"toExitParty('+resp.pdto.seq+');\">모임 나가기</button>');
					}else{
						if(resp.pdto.status == '1'){
							$("#partyModal .modal-footer").append('<button type="button" id="toStopRecruit" class="btn btn-dark" onClick=\"toStopRecruit('+resp.pdto.seq+',\''+resp.pdto.writer+'\');\">모집 종료하기</button>');	
						}else if(resp.pdto.status == '0'){
							$("#partyModal .modal-footer").append('<button type="button" id="torestartRecruit" class="btn btn-success" onClick=\"toRestartRecruit('+resp.pdto.seq+',\''+resp.pdto.writer+'\');\">모집 재시작</button>');
						}
					}
				}
				if(resp.mdto.nickname == resp.pdto.writer){
					$("#partyModal .modal-footer").append('<br><button type="button" id="partyModify" class="btn btn-warning" onClick=\"partyModify('+resp.pdto.seq+');\">수정</button><button type="button" id="partyDelete" class="btn btn-danger" onClick=\"partyDelete('+resp.pdto.seq+')\">삭제</button>');
				}else{
					$("#partyModal .modal-footer").append('<br><button type="button" id="partyReport" class="btn btn-info" onClick=\"partyReport('+resp.pdto.seq+',\''+resp.pdto.writer+'\',\''+resp.pdto.title+'\',\''+resp.pdto.content+'\');\">신고</button>');
				}
			})
		})
		// 인포윈도우를 표시하는 클로저를 만드는 함수입니다 
		function infoOverSet(customOverlay,map) {
			customOverlay.setMap(map);
		}
		// 인포윈도우를 닫는 클로저를 만드는 함수입니다 
		function infoOverClose(customOverlay) {
			customOverlay.setMap(null);
		}
		var customOverlayArray = [];
		var searchResultArray = [];
		var markers = [];
		$("#search").on("click",function(){ // 키워드 검색
			$.ajax({
				url:"/map/search",
				data:{keyword:$("#keyword").val()},
				dataType:"JSON"
			}).done(function(resp){
				$.each(customOverlayArray, function(i, item) {
					infoOverClose(item.customOverlay);
				});
				/* markers 초기화 */
				
				cafeMarkers.forEach(function(item) {item.marker.setMap(null);clusterer.removeMarker(item.marker);});
				foodMarkers.forEach(function(item) {item.marker.setMap(null);clusterer.removeMarker(item.marker);});
				cafeTopMarkers.forEach(function(item) {item.marker.setMap(null);clusterer.removeMarker(item.marker);});
				foodTopMarkers.forEach(function(item) {item.marker.setMap(null);clusterer.removeMarker(item.marker);});
				cafePartyMarkers.forEach(function(item) {item.marker.setMap(null);clusterer.removeMarker(item.marker);});
				foodPartyMarkers.forEach(function(item) {item.marker.setMap(null);clusterer.removeMarker(item.marker);});
				kakaoFoodMarkers.forEach(function(item){item.marker.setMap(null);clusterer.removeMarker(item.marker);});
				kakaoCafeMarkers.forEach(function(item){item.marker.setMap(null);clusterer.removeMarker(item.marker);});
				positions= [];
				if(markers.length != 0){
					$.each(markers,function(i, item){
						item.marker.setMap(null);
						notmapclusterer.removeMarker(item.marker);
					});
				}
				$(".choose_info").html("");
				$(".search_result").html("");
				var cafePositions = [];
				var foodPositions = [];
				var cafePartyPositions = [];
				var foodPartyPositions = [];
				var cafeTopPositions = [];
				var foodTopPositions = [];
				var count = null;
				if(resp.cafe_list == undefined && resp.food_list == undefined){
					count = resp.map_list.length;
				}else if(resp.cafe_list == undefined && resp.food_list != undefined){
					count = resp.map_list.length + resp.food_list.length;
				}else if(resp.cafe_list != undefined && resp.food_list == undefined){
					count = resp.map_list.length + resp.cafe_list.length;
				}else{
					count = resp.map_list.length + resp.cafe_list.length + resp.food_list.length;
				}
				if(count == 0){
					$(".search_result").append("<div class='search_count'><b>장소</b> "+count+"</div>");
					$(".search_result").append("<div style='font-size:10pt;padding-left:30px;padding-right:30px;'>검색결과가 존재하지 않습니다.</div>");
					$(".search_result").css('max-height','700px');
				}else{
					$(".search_result").append("<div class='search_count'><b>장소</b> "+count+"</div>");
					$(".search_result").css('max-height','700px');
					
				    var normalCafeImageSrc = 'https://eat-together.s3.ap-northeast-2.amazonaws.com/Asset6.png', 
					normalFoodImageSrc = 'https://eat-together.s3.ap-northeast-2.amazonaws.com/Asset5.png'
					partyCafeImageSrc = 'https://eat-together.s3.ap-northeast-2.amazonaws.com/Asset3.png',
					partyFoodImageSrc = 'https://eat-together.s3.ap-northeast-2.amazonaws.com/Asset4.png', 
					topCafeImageSrc = 'https://eat-together.s3.ap-northeast-2.amazonaws.com/Asset2.png',
					topFoodImageSrc = 'https://eat-together.s3.ap-northeast-2.amazonaws.com/Asset1.png',  
				    baseImageSize = new kakao.maps.Size(40, 60), // 마커이미지의 크기입니다
				    baseImageOption = {offset: new kakao.maps.Point(20, 69)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
				    var normalCafeImage = new kakao.maps.MarkerImage(normalCafeImageSrc, baseImageSize, baseImageOption);
				    var normalFoodImage = new kakao.maps.MarkerImage(normalFoodImageSrc, baseImageSize, baseImageOption);
				    var partyCafeImage = new kakao.maps.MarkerImage(partyCafeImageSrc, baseImageSize, baseImageOption);
				    var partyFoodImage = new kakao.maps.MarkerImage(partyFoodImageSrc, baseImageSize, baseImageOption);
				    var topCafeImage = new kakao.maps.MarkerImage(topCafeImageSrc, baseImageSize, baseImageOption);
				    var topFoodImage = new kakao.maps.MarkerImage(topFoodImageSrc, baseImageSize, baseImageOption);
				    $.each(resp.map_list, function(i, item) { 
						if(item.top!=undefined){
							if(item.category == '카페'){
								cafeTopPositions.push({
									content: '<div class="mapcustomoverlay">' +
					    	        '  <a href="'+item.place_url+'" target="_blank">' +
					    	        '    <span class="category">'+ item.category +'</span>' +
					    	        '    <span class="title">'+ item.name +'</span>' +
					    	        '    <span class="address">'+ item.address +'</span>' +
					    	        '  </a>' +
					    	        '</div>', 
									latlng: new kakao.maps.LatLng(item.lat, item.lng),
									place_id: item.place_id
								})
							}else{
								foodTopPositions.push({
									content: '<div class="mapcustomoverlay">' +
					    	        '  <a href="'+item.place_url+'" target="_blank">' +
					    	        '    <span class="category">'+ item.category +'</span>' +
					    	        '    <span class="title">'+ item.name +'</span>' +
					    	        '    <span class="address">'+ item.address +'</span>' +
					    	        '  </a>' +
					    	        '</div>', 
									latlng: new kakao.maps.LatLng(item.lat, item.lng),
									place_id: item.place_id
								})
							}
						}else{
							if(item.category == '카페'){
								if(item.partyOn > 0){
									cafePartyPositions.push({
										content: '<div class="mapcustomoverlay">' +
						    	        '  <a href="'+item.place_url+'" target="_blank">' +
						    	        '    <span class="category">'+ item.category +'</span>' +
						    	        '    <span class="title">'+ item.name +'</span>' +
						    	        '    <span class="address">'+ item.address +'</span>' +
						    	        '  </a>' +
						    	        '</div>', 
										latlng: new kakao.maps.LatLng(item.lat, item.lng),
										place_id: item.place_id
									});				
								}else if(item.partyOn == 0){
									cafePositions.push({
										content: '<div class="mapcustomoverlay">' +
						    	        '  <a href="'+item.place_url+'" target="_blank">' +
						    	        '    <span class="category">'+ item.category +'</span>' +
						    	        '    <span class="title">'+ item.name +'</span>' +
						    	        '    <span class="address">'+ item.address +'</span>' +
						    	        '  </a>' +
						    	        '</div>', 
										latlng: new kakao.maps.LatLng(item.lat, item.lng),
										place_id: item.place_id
									});		
								}
							}else if(item.category == '음식점'){
								if(item.partyOn > 0){
									foodPartyPositions.push({
										content: '<div class="mapcustomoverlay">' +
						    	        '  <a href="'+item.place_url+'" target="_blank">' +
						    	        '    <span class="category">'+ item.category +'</span>' +
						    	        '    <span class="title">'+ item.name +'</span>' +
						    	        '    <span class="address">'+ item.address +'</span>' +
						    	        '  </a>' +
						    	        '</div>', 
										latlng: new kakao.maps.LatLng(item.lat, item.lng),
										place_id: item.place_id
									});
								}else if(item.partyOn == 0){
									foodPositions.push({
										content: '<div class="mapcustomoverlay">' +
						    	        '  <a href="'+item.place_url+'" target="_blank">' +
						    	        '    <span class="category">'+ item.category +'</span>' +
						    	        '    <span class="title">'+ item.name +'</span>' +
						    	        '    <span class="address">'+ item.address +'</span>' +
						    	        '  </a>' +
						    	        '</div>', 
										latlng: new kakao.maps.LatLng(item.lat, item.lng),
										place_id: item.place_id
									});
								}
							}					
						}
					});
					cafeMarkers = createMapTableMarker(cafePositions, normalCafeImage); // 일반 카페
					foodMarkers = createMapTableMarker(foodPositions, normalFoodImage); // 일반 음식점
					cafePartyMarkers = createMapTableMarker(cafePartyPositions, partyCafeImage); // 모임 모집중인 카페
					foodPartyMarkers = createMapTableMarker(foodPartyPositions, partyFoodImage); // 모임 모집중인 음식점
					cafeTopMarkers = createMapTableMarker(cafeTopPositions, topCafeImage); // 리뷰 평균 Top 카페
					foodTopMarkers = createMapTableMarker(foodTopPositions, topFoodImage); // 리뷰 평균 Top 음식점
					
					var line = $("<div class='search_list'></div>");
					for(var i = 0; i < resp.map_list.length; i++){
						var food = $("<div class='map_info'></div>");
						food.append("<img src='/resources/img/premium.png' style='height:25px;'>")
						food.append("<div class='place_name'>"+resp.map_list[i].name+"</div>");
						food.append("<div class='place_id' style='display:none;'>"+resp.map_list[i].place_id+"</div>");
						food.append("<div class='address_name'>"+resp.map_list[i].address+"</div>");
						food.append("<div class='category_name'>"+resp.map_list[i].category+"</div>");
						if(resp.map_list[i].phone != undefined){
							food.append("<div class='phone'>"+resp.map_list[i].phone+"</div>");						
						}
						line.append(food);			
					}
					if(resp.cafe_list != undefined){
						for(var i = 0; i < resp.cafe_list.length; i++){
							var cafe = $("<div class='cafe_info'></div>");
							cafe.append("<div class='place_name'>"+resp.cafe_list[i].place_name+"</div>");
							cafe.append("<div class='place_id' style='display:none;'>"+resp.cafe_list[i].id+"</div>");
							cafe.append("<div class='address_name'>"+resp.cafe_list[i].address_name+"</div>");
							cafe.append("<div class='category_name'>"+resp.cafe_list[i].category_group_name+"</div>");
							cafe.append("<div class='phone'>"+resp.cafe_list[i].phone+"</div>");
							line.append(cafe);	
							positions.push({
				    	        content: '<div class="cafecustomoverlay">' +
				    	        '  <a href="'+resp.cafe_list[i].place_url+'" target="_blank">' +
				    	        '    <span class="title">'+ resp.cafe_list[i].place_name +'</span>' +
				    	        '  </a>' +
				    	        '</div>', 
				    	        latlng: new kakao.maps.LatLng(resp.cafe_list[i].y, resp.cafe_list[i].x),
				    	        place_id:resp.cafe_list[i].id,
				    	        category:resp.cafe_list[i].category_group_name
							});
						}
					}
					if(resp.food_list != undefined){
						for(var i = 0; i < resp.food_list.length; i++){
							var food = $("<div class='food_info'></div>");
							food.append("<div class='place_name'>"+resp.food_list[i].place_name+"</div>");
							food.append("<div class='place_id' style='display:none;'>"+resp.food_list[i].id+"</div>");
							food.append("<div class='address_name'>"+resp.food_list[i].address_name+"</div>");
							food.append("<div class='category_name'>"+resp.food_list[i].category_group_name+"</div>");
							food.append("<div class='phone'>"+resp.food_list[i].phone+"</div>");
							line.append(food);	
							positions.push({
				    	        content: '<div class="foodcustomoverlay">' +
				    	        '  <a href="'+resp.food_list[i].place_url+'" target="_blank">' +
				    	        '    <span class="title">'+ resp.food_list[i].place_name +'</span>' +
				    	        '  </a>' +
				    	        '</div>', 
				    	        latlng: new kakao.maps.LatLng(resp.food_list[i].y, resp.food_list[i].x),
				    	        place_id:resp.food_list[i].id,
				    	        category:resp.food_list[i].category_group_name
							});			
						}
					}
					$(".search_result").append(line);
					var lat = map.getCenter().getLat();
					var lng = map.getCenter().getLng();
					if(resp.map_list.length != 0){
						lat = resp.map_list[0].lat;
						lng = resp.map_list[0].lng;
					}else if(resp.cafe_list.length != 0){
						lat = resp.cafe_list[0].y;
						lng = resp.cafe_list[0].x;
					}else if(resp.food_list.length != 0){
						lat = resp.food_list[0].y;
						lng = resp.food_list[0].x;
					}
					map.setCenter(new kakao.maps.LatLng(lat, lng));
					map.setLevel(2);
					$.each(positions,function(i, item){
						var marker = pushMarker(item);
						markers.push({marker:marker});
					});
					console.log(positions);
					/* cafe_list, food_list 에 대한 marker 정보만 표시 */
				}
				
			})
		})
		$("#cafeBtn").on("click",function(){ // 카테고리 검색 - '카페' 버튼
			$.ajax({
				url:"/map/searchCafeBtn",
				dataType:"JSON"
			}).done(function(resp){
				$.each(customOverlayArray, function(i, item) {
					infoOverClose(item.customOverlay);
				});
				/* markers 초기화 */
				cafeMarkers.forEach(function(item) {item.marker.setMap(null);clusterer.removeMarker(item.marker);});
				foodMarkers.forEach(function(item) {item.marker.setMap(null);clusterer.removeMarker(item.marker);});
				cafeTopMarkers.forEach(function(item) {item.marker.setMap(null);clusterer.removeMarker(item.marker);});
				foodTopMarkers.forEach(function(item) {item.marker.setMap(null);clusterer.removeMarker(item.marker);});
				cafePartyMarkers.forEach(function(item) {item.marker.setMap(null);clusterer.removeMarker(item.marker);});
				foodPartyMarkers.forEach(function(item) {item.marker.setMap(null);clusterer.removeMarker(item.marker);});
				kakaoFoodMarkers.forEach(function(item){item.marker.setMap(null);clusterer.removeMarker(item.marker);});
				kakaoCafeMarkers.forEach(function(item){item.marker.setMap(null);clusterer.removeMarker(item.marker);});
				positions= [];
				if(markers.length != 0){
					$.each(markers,function(i, item){
						item.marker.setMap(null);
						notmapclusterer.removeMarker(item.marker);
					});
				}
				$(".choose_info").html("");
				$(".search_result").html("");
				var cafePositions = [];
				var foodPositions = [];
				var cafePartyPositions = [];
				var foodPartyPositions = [];
				var cafeTopPositions = [];
				var foodTopPositions = [];
				var count = null;
				if(resp.cafe_list == undefined){
					count = resp.map_list.length;
				}else{
					count = resp.map_list.length + resp.cafe_list.length;
				}
				if(count == 0){
					$(".search_result").append("<div class='search_count'><b>장소</b> "+count+"</div>");
					$(".search_result").append("<div style='font-size:10pt;padding-left:30px;padding-right:30px;'>검색결과가 존재하지 않습니다.</div>");
					$(".search_result").css('max-height','700px');
				}else{
					$(".search_result").append("<div class='search_count'><b>장소</b> "+count+"</div>");
					$(".search_result").css('max-height','700px');
					
				    var normalCafeImageSrc = 'https://eat-together.s3.ap-northeast-2.amazonaws.com/Asset6.png', 
					partyCafeImageSrc = 'https://eat-together.s3.ap-northeast-2.amazonaws.com/Asset3.png',
					topCafeImageSrc = 'https://eat-together.s3.ap-northeast-2.amazonaws.com/Asset2.png',
				    baseImageSize = new kakao.maps.Size(40, 60), // 마커이미지의 크기입니다
				    baseImageOption = {offset: new kakao.maps.Point(20, 69)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
				    var normalCafeImage = new kakao.maps.MarkerImage(normalCafeImageSrc, baseImageSize, baseImageOption);
				    var partyCafeImage = new kakao.maps.MarkerImage(partyCafeImageSrc, baseImageSize, baseImageOption);
				    var topCafeImage = new kakao.maps.MarkerImage(topCafeImageSrc, baseImageSize, baseImageOption);
				    $.each(resp.map_list, function(i, item) { 
						if(item.top!=undefined){
							if(item.category == '카페'){
								cafeTopPositions.push({
									content: '<div class="mapcustomoverlay">' +
					    	        '  <a href="'+item.place_url+'" target="_blank">' +
					    	        '    <span class="category">'+ item.category +'</span>' +
					    	        '    <span class="title">'+ item.name +'</span>' +
					    	        '    <span class="address">'+ item.address +'</span>' +
					    	        '  </a>' +
					    	        '</div>', 
									latlng: new kakao.maps.LatLng(item.lat, item.lng),
									place_id: item.place_id
								})
							}else{
								foodTopPositions.push({
									content: '<div class="mapcustomoverlay">' +
					    	        '  <a href="'+item.place_url+'" target="_blank">' +
					    	        '    <span class="category">'+ item.category +'</span>' +
					    	        '    <span class="title">'+ item.name +'</span>' +
					    	        '    <span class="address">'+ item.address +'</span>' +
					    	        '  </a>' +
					    	        '</div>', 
									latlng: new kakao.maps.LatLng(item.lat, item.lng),
									place_id: item.place_id
								})
							}
						}else{
							if(item.category == '카페'){
								if(item.partyOn > 0){
									cafePartyPositions.push({
										content: '<div class="mapcustomoverlay">' +
						    	        '  <a href="'+item.place_url+'" target="_blank">' +
						    	        '    <span class="category">'+ item.category +'</span>' +
						    	        '    <span class="title">'+ item.name +'</span>' +
						    	        '    <span class="address">'+ item.address +'</span>' +
						    	        '  </a>' +
						    	        '</div>', 
										latlng: new kakao.maps.LatLng(item.lat, item.lng),
										place_id: item.place_id
									});				
								}else if(item.partyOn == 0){
									cafePositions.push({
										content: '<div class="mapcustomoverlay">' +
						    	        '  <a href="'+item.place_url+'" target="_blank">' +
						    	        '    <span class="category">'+ item.category +'</span>' +
						    	        '    <span class="title">'+ item.name +'</span>' +
						    	        '    <span class="address">'+ item.address +'</span>' +
						    	        '  </a>' +
						    	        '</div>', 
										latlng: new kakao.maps.LatLng(item.lat, item.lng),
										place_id: item.place_id
									});		
								}
							}					
						}
					});
					cafeMarkers = createMapTableMarker(cafePositions, normalCafeImage); // 일반 카페
					cafePartyMarkers = createMapTableMarker(cafePartyPositions, partyCafeImage); // 모임 모집중인 카페
					cafeTopMarkers = createMapTableMarker(cafeTopPositions, topCafeImage); // 리뷰 평균 Top 카페
					
					var line = $("<div class='search_list'></div>");
					for(var i = 0; i < resp.map_list.length; i++){
						var food = $("<div class='map_info'></div>");
						food.append("<img src='/resources/img/premium.png' style='height:25px;'>")
						food.append("<div class='place_name'>"+resp.map_list[i].name+"</div>");
						food.append("<div class='place_id' style='display:none;'>"+resp.map_list[i].place_id+"</div>");
						food.append("<div class='address_name'>"+resp.map_list[i].address+"</div>");
						food.append("<div class='category_name'>"+resp.map_list[i].category+"</div>");
						if(resp.map_list[i].phone != undefined){
							food.append("<div class='phone'>"+resp.map_list[i].phone+"</div>");						
						}
						line.append(food);			
					}
					if(resp.cafe_list != undefined){
						for(var i = 0; i < resp.cafe_list.length; i++){
							var cafe = $("<div class='cafe_info'></div>");
							cafe.append("<div class='place_name'>"+resp.cafe_list[i].place_name+"</div>");
							cafe.append("<div class='place_id' style='display:none;'>"+resp.cafe_list[i].id+"</div>");
							cafe.append("<div class='address_name'>"+resp.cafe_list[i].address_name+"</div>");
							cafe.append("<div class='category_name'>"+resp.cafe_list[i].category_group_name+"</div>");
							cafe.append("<div class='phone'>"+resp.cafe_list[i].phone+"</div>");
							line.append(cafe);	
							positions.push({
				    	        content: '<div class="cafecustomoverlay">' +
				    	        '  <a href="'+resp.cafe_list[i].place_url+'" target="_blank">' +
				    	        '    <span class="title">'+ resp.cafe_list[i].place_name +'</span>' +
				    	        '  </a>' +
				    	        '</div>', 
				    	        latlng: new kakao.maps.LatLng(resp.cafe_list[i].y, resp.cafe_list[i].x),
				    	        place_id:resp.cafe_list[i].id,
				    	        category:resp.cafe_list[i].category_group_name
							});
						}
					}
					$(".search_result").append(line);
					var lat = map.getCenter().getLat();
					var lng = map.getCenter().getLng();
					if(resp.map_list.length != 0){
						lat = resp.map_list[0].lat;
						lng = resp.map_list[0].lng;
					}else if(resp.cafe_list.length != 0){
						lat = resp.cafe_list[0].y;
						lng = resp.cafe_list[0].x;
					}else if(resp.food_list.length != 0){
						lat = resp.food_list[0].y;
						lng = resp.food_list[0].x;
					}
					map.setCenter(new kakao.maps.LatLng(lat, lng));
					map.setLevel(2);
					$.each(positions,function(i, item){
						var marker = pushMarker(item);
						markers.push({marker:marker});
					});
					/* cafe_list, food_list 에 대한 marker 정보만 표시 */
				}
			})
		})
		$("#foodBtn").on("click",function(){ // 카테고리 검색 - '음식점' 버튼
			$.ajax({
				url:"/map/searchFoodBtn",
				dataType:"JSON"
			}).done(function(resp){
				$.each(customOverlayArray, function(i, item) {
					infoOverClose(item.customOverlay);
				});
				/* markers 초기화 */
				cafeMarkers.forEach(function(item) {item.marker.setMap(null);clusterer.removeMarker(item.marker);});
				foodMarkers.forEach(function(item) {item.marker.setMap(null);clusterer.removeMarker(item.marker);});
				cafeTopMarkers.forEach(function(item) {item.marker.setMap(null);clusterer.removeMarker(item.marker);});
				foodTopMarkers.forEach(function(item) {item.marker.setMap(null);clusterer.removeMarker(item.marker);});
				cafePartyMarkers.forEach(function(item) {item.marker.setMap(null);clusterer.removeMarker(item.marker);});
				foodPartyMarkers.forEach(function(item) {item.marker.setMap(null);clusterer.removeMarker(item.marker);});
				kakaoFoodMarkers.forEach(function(item){item.marker.setMap(null);clusterer.removeMarker(item.marker);});
				kakaoCafeMarkers.forEach(function(item){item.marker.setMap(null);clusterer.removeMarker(item.marker);});
				positions= [];
				if(markers.length != 0){
					$.each(markers,function(i, item){
						item.marker.setMap(null);
						notmapclusterer.removeMarker(item.marker);
					});
				}
				
				$(".choose_info").html("");
				$(".search_result").html("");
				var cafePositions = [];
				var foodPositions = [];
				var cafePartyPositions = [];
				var foodPartyPositions = [];
				var cafeTopPositions = [];
				var foodTopPositions = [];
				var count = null;
				if(resp.food_list == undefined){
					count = resp.map_list.length;
				}else{
					count = resp.map_list.length + resp.food_list.length;
				}
				if(count == 0){
					$(".search_result").append("<div class='search_count'><b>장소</b> "+count+"</div>");
					$(".search_result").append("<div style='font-size:10pt;padding-left:30px;padding-right:30px;'>검색결과가 존재하지 않습니다.</div>");
					$(".search_result").css('max-height','700px');
				}else{
					$(".search_result").append("<div class='search_count'><b>장소</b> "+count+"</div>");
					$(".search_result").css('max-height','700px');
					
				    var normalFoodImageSrc = 'https://eat-together.s3.ap-northeast-2.amazonaws.com/Asset5.png',
					partyFoodImageSrc = 'https://eat-together.s3.ap-northeast-2.amazonaws.com/Asset4.png', 
					topFoodImageSrc = 'https://eat-together.s3.ap-northeast-2.amazonaws.com/Asset1.png',  
				    baseImageSize = new kakao.maps.Size(40, 60), // 마커이미지의 크기입니다
				    baseImageOption = {offset: new kakao.maps.Point(20, 69)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
				    var normalFoodImage = new kakao.maps.MarkerImage(normalFoodImageSrc, baseImageSize, baseImageOption);
				    var partyFoodImage = new kakao.maps.MarkerImage(partyFoodImageSrc, baseImageSize, baseImageOption);
				    var topFoodImage = new kakao.maps.MarkerImage(topFoodImageSrc, baseImageSize, baseImageOption);
				    $.each(resp.map_list, function(i, item) { 
						if(item.top!=undefined){
							foodTopPositions.push({
									content: '<div class="mapcustomoverlay">' +
					    	        '  <a href="'+item.place_url+'" target="_blank">' +
					    	        '    <span class="category">'+ item.category +'</span>' +
					    	        '    <span class="title">'+ item.name +'</span>' +
					    	        '    <span class="address">'+ item.address +'</span>' +
					    	        '  </a>' +
					    	        '</div>', 
									latlng: new kakao.maps.LatLng(item.lat, item.lng),
									place_id: item.place_id
							})
						}else{
							if(item.category == '음식점'){
								if(item.partyOn > 0){
									foodPartyPositions.push({
										content: '<div class="mapcustomoverlay">' +
						    	        '  <a href="'+item.place_url+'" target="_blank">' +
						    	        '    <span class="category">'+ item.category +'</span>' +
						    	        '    <span class="title">'+ item.name +'</span>' +
						    	        '    <span class="address">'+ item.address +'</span>' +
						    	        '  </a>' +
						    	        '</div>', 
										latlng: new kakao.maps.LatLng(item.lat, item.lng),
										place_id: item.place_id
									});
								}else if(item.partyOn == 0){
									foodPositions.push({
										content: '<div class="mapcustomoverlay">' +
						    	        '  <a href="'+item.place_url+'" target="_blank">' +
						    	        '    <span class="category">'+ item.category +'</span>' +
						    	        '    <span class="title">'+ item.name +'</span>' +
						    	        '    <span class="address">'+ item.address +'</span>' +
						    	        '  </a>' +
						    	        '</div>', 
										latlng: new kakao.maps.LatLng(item.lat, item.lng),
										place_id: item.place_id
									});
								}
							}					
						}
					});
					foodMarkers = createMapTableMarker(foodPositions, normalFoodImage); // 일반 음식점
					foodPartyMarkers = createMapTableMarker(foodPartyPositions, partyFoodImage); // 모임 모집중인 음식점
					foodTopMarkers = createMapTableMarker(foodTopPositions, topFoodImage); // 리뷰 평균 Top 음식점
					
					var line = $("<div class='search_list'></div>");
					for(var i = 0; i < resp.map_list.length; i++){
						var food = $("<div class='map_info'></div>");
						food.append("<img src='/resources/img/premium.png' style='height:25px;'>")
						food.append("<div class='place_name'>"+resp.map_list[i].name+"</div>");
						food.append("<div class='place_id' style='display:none;'>"+resp.map_list[i].place_id+"</div>");
						food.append("<div class='address_name'>"+resp.map_list[i].address+"</div>");
						food.append("<div class='category_name'>"+resp.map_list[i].category+"</div>");
						if(resp.map_list[i].phone != undefined){
							food.append("<div class='phone'>"+resp.map_list[i].phone+"</div>");						
						}
						line.append(food);			
					}
					if(resp.food_list != undefined){
						for(var i = 0; i < resp.food_list.length; i++){
							var food = $("<div class='food_info'></div>");
							food.append("<div class='place_name'>"+resp.food_list[i].place_name+"</div>");
							food.append("<div class='place_id' style='display:none;'>"+resp.food_list[i].id+"</div>");
							food.append("<div class='address_name'>"+resp.food_list[i].address_name+"</div>");
							food.append("<div class='category_name'>"+resp.food_list[i].category_group_name+"</div>");
							food.append("<div class='phone'>"+resp.food_list[i].phone+"</div>");
							line.append(food);	
							positions.push({
				    	        content: '<div class="foodcustomoverlay">' +
				    	        '  <a href="'+resp.food_list[i].place_url+'" target="_blank">' +
				    	        '    <span class="title">'+ resp.food_list[i].place_name +'</span>' +
				    	        '  </a>' +
				    	        '</div>', 
				    	        latlng: new kakao.maps.LatLng(resp.food_list[i].y, resp.food_list[i].x),
				    	        place_id:resp.food_list[i].id,
				    	        category:resp.food_list[i].category_group_name
							});			
						}
					}
					$(".search_result").append(line);
					var lat = resp.map_list[0].lat,
					lng = resp.map_list[0].lng;
					map.setCenter(new kakao.maps.LatLng(lat, lng));
					map.setLevel(2);
					$.each(positions,function(i, item){
						var marker = pushMarker(item);
						markers.push({marker:marker});
					});
				}
			})
		})
		$(document).on("click",".map_info",function(){
			$.ajax({
				url:'/map/chooseMapInfo',
				type:"get",
				data:{place_id:$(this).find(".place_id").text()},
				dataType:"JSON"
			}).done(function(resp){
			    map.setCenter(new kakao.maps.LatLng(resp[0].lat, resp[0].lng));
				$.each(customOverlayArray, function(i, item) {
					infoOverClose(item.customOverlay);
				});
			    customOverlay = new kakao.maps.CustomOverlay({
		            position: map.getCenter(),
		            content: '<div class="mapcustomoverlay">' +
	    	        '  <a href="'+resp[0].place_url+'" target="_blank">' +
	    	        '    <span class="category">'+ resp[0].category +'</span>' +
	    	        '    <span class="title">'+ resp[0].name +'</span>' +
	    	        '    <span class="address">'+ resp[0].address +'</span>' +
	    	        '  </a>' +
	    	        '</div>'
		        });
				customOverlayArray.push({customOverlay : customOverlay});
		        infoOverSet(customOverlay,map);
			})
		})
		$(document).on("click",".cafe_info",function(){
			$.ajax({
				url:'/map/chooseCafeInfo',
				type:"get",
				data:{place_id:$(this).find(".place_id").text()},
				dataType:"JSON"
			}).done(function(resp){
			    map.setCenter(new kakao.maps.LatLng(resp.result.cafe.y, resp.result.cafe.x));
				$.each(customOverlayArray, function(i, item) {
					infoOverClose(item.customOverlay);
				});
			    customOverlay = new kakao.maps.CustomOverlay({
		            position: map.getCenter(),
		            content: '<div class="cafecustomoverlay">' +
		            '  <a href="'+resp.result.cafe.place_url+'" target="_blank">' +
	    	        '    <span class="title">'+ resp.result.cafe.place_name +'</span>' +
	    	        '  </a>' +
	    	        '</div>'
		        });
				customOverlayArray.push({customOverlay : customOverlay});
		        infoOverSet(customOverlay,map);
			})
		})
		$(document).on("click",".food_info",function(){
			$.ajax({
				url:'/map/chooseFoodInfo',
				type:"get",
				data:{place_id:$(this).find(".place_id").text()},
				dataType:"JSON"
			}).done(function(resp){
			    map.setCenter(new kakao.maps.LatLng(resp.result.food.y, resp.result.food.x));
				$.each(customOverlayArray, function(i, item) {
					infoOverClose(item.customOverlay);
				});
			    customOverlay = new kakao.maps.CustomOverlay({
		            position: map.getCenter(),
		            content: '<div class="foodcustomoverlay">' +
		            '  <a href="'+resp.result.food.place_url+'" target="_blank">' +
	    	        '    <span class="title">'+ resp.result.food.place_name +'</span>' +
	    	        '  </a>' +
	    	        '</div>'
		        });
				customOverlayArray.push({customOverlay : customOverlay});
		        infoOverSet(customOverlay,map);
			})
		})
		$(".current_position_btn").on("click",function(){
			deleteMarker(currentPositionMarker.marker, currentPositionMarker.customOverlay);
		    if (navigator.geolocation) {
		        // GeoLocation을 이용해서 접속 위치를 얻어옵니다
		        navigator.geolocation.getCurrentPosition(function(position) {
		            var lat = position.coords.latitude, // 위도
		                lon = position.coords.longitude; // 경도
		            var locPosition = new kakao.maps.LatLng(lat, lon), // 마커가 표시될 위치를 geolocation으로 얻어온 좌표로 생성합니다
		                message = '당신의 위치'; // 인포윈도우에 표시될 내용입니다
		            // 마커와 인포윈도우를 표시합니다
		            currentPositionMarker = displayMarker(locPosition, message, currentPositionMarker.customOverlay);
		          });
		    } else { // HTML5의 GeoLocation을 사용할 수 없을때 마커 표시 위치와 인포윈도우 내용을 설정합니다
		        var locPosition = new kakao.maps.LatLng(33.450701, 126.570667),    
		            message = 'geolocation을 사용할수 없어요..';
		        currentPositionMarker = displayMarker(locPosition, message, currentPositionMarker.customOverlay);
		    }
		})
		/****************** 리뷰 및 기타 영역 ******************/		
		$("#review_write").on("submit",function(){
			var result = false;
			if($(".reviewlist .writer b").text()==""){
				alert("로그인을 해주세요.");
			}else if($(".input_content").text()==""){
				alert("리뷰 내용을 입력해주세요.");
			}else if(!$("input[name='rating']").is(':checked')){
				alert("별점을 선택해주세요.");
			}else{
				result = true;
				$("#review_content").val($(".input_content").text());
			}
			return result;
		})
		$('#imgFile').on("change",function() {
			// files 로 해당 파일 정보 얻기.
			var file = this.files;
			// file[0].name 은 파일명 입니다.
			// 정규식으로 확장자 체크
			if(!/\.(gif|jpg|jpeg|png)$/i.test(file[0].name)) {
				alert('이미지 파일만 선택해 주세요.\n\n현재 파일 : ' + file[0].name);
				$(".filebox i").css('color','none');
				$("#imgFile").val("");
			}
			else {// 체크를 통과했다면 종료.
				/*this.outerHTML = this.outerHTML;*/
				$(".filebox i").css('color','#038cfc');
				return;
			}
			// 체크에 걸리면 선택된  내용 취소 처리를 해야함.
			// 파일선택 폼의 내용은 스크립트로 컨트롤 할 수 없습니다.
			// 그래서 그냥 새로 폼을 새로 써주는 방식으로 초기화 합니다.
			// 이렇게 하면 간단 !?
		});
		$(".toLogin").on("click",function(){
			location.href = "/member/loginview";
		})
		$(".toSignUp").on("click",function(){
			location.href = "/member/signup_check";
		})
		$("#backMap").on("click",function(){
			location.href = "/map/toMap";
		})
		$("#back").on("click",function(){
			$(".choose_info").html("");
			$(".search_result").html($("#map_approach_info").html());
			$(".search_result .pin_how_to").append("<button type='button' id='refresh'><i class='fas fa-undo-alt'></i></button>");
		})
		$(document).on("click","#refresh",function(){
			location.reload(true);
		})
		var duration = 300;

		$('.navi_btn').on('click', function(){
		    if( $(this).html()=='<i class="fas fa-chevron-left"></i>')
		    {
		        $(this).html('<i class="fas fa-chevron-right"></i>');
		        $("#sideBar").animate({right:300},1000);
		    }
		    else
		    {
		       $(this).html('<i class="fas fa-chevron-left"></i>');
		        $("#sideBar").animate({right:0},1000);
		     }
		    
		});
		 $("#keyword").keydown(function(key) {
             if (key.keyCode == 13) {
                 //엔터 클릭시
            	 $("#search").click();
             }
         });
		$("#editable").on("keydown", function(e) {
		       if (e.keyCode === 13) {
		           document.execCommand('insertHTML', false, '\n');
		       }
		       return e.which != 13; 
		});
	})
	.ajaxStart(function(){
		$('#Progress_Loading').show(); //ajax실행시 로딩바를 보여준다.
	})
	.ajaxStop(function(){
		$('#Progress_Loading').hide(); //ajax종료시 로딩바를 숨겨준다.
	});	
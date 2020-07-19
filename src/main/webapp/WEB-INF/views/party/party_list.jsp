<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<meta property="fb:app_id" content="APP_ID" />
<meta property="og:site_name" content="맛집동행찾기서비스 - 맛집갔다갈래">
<meta property="og:type" content="article" />
<meta property="og:title" content="${con.title}" />
<meta property="og:url" content="eat-together.net" />
<meta property="og:description" content="${con.content}" />
<meta property="og:image"
	content="https://eat-together.s3.ap-northeast-2.amazonaws.com/logo/eattogether-logo-rectangle.png" />

<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<!-- 태훈 추가 -->

<!-- Google Fonts -->
<link
	href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,400i,600,700|Raleway:300,400,400i,500,500i,700,800,900"
	rel="stylesheet">

<!-- Vendor CSS Files -->
<link href="/resources/assets/vendor/icofont/icofont.min.css" rel="stylesheet">
<link href="/resources/assets/vendor/animate.css/animate.min.css" rel="stylesheet">
<link href="/resources/assets/vendor/animate.css/animate.min.css" rel="stylesheet">
<link href="/resources/assets/vendor/font-awesome/css/font-awesome.min.css"
	rel="stylesheet">
	
<!-- Template Main CSS File -->
<link href="/resources/assets/css/style.css?ver=1" rel="stylesheet">
<!-- 태훈 추가 -->

<!-- BootStrap4 -->
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>
<!-- BootStrap4 End--> 

<!--  kakao api -->
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>

<!-- google font -->
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@500&display=swap"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@500;900&display=swap"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css2?family=Black+Han+Sans&display=swap"
	rel="stylesheet">
<!-- google font end-->


<!-- ******************* -->
<!-- header,footer용 css  -->
<link rel="stylesheet" type="text/css"
	href="/resources/css/index-css.css">
<!-- header,footer용 css  -->
<!-- ******************* -->
<!-- ******************* -->
<link rel="stylesheet" type="text/css"
	href="/resources/css/party-css.css">

<!-- 태훈 css -->
<link rel="stylesheet" type="text/css" href="/resources/css/party-content-include.css?ver=7">
<!-- 태훈 css -->

<title>모임 리스트</title>
<script>
/******************* 변수 ************************/
var cpage = 1; //페이징과 같은 방식이라고 생각하면 된다. 

var url = "/party/partysearch";
console.log(url);

var formData = new FormData();
console.log("시작값 : ");
console.log(formData);
var imgHeight = $(".imgTop").height();
console.log(imgHeight);
/******************* 변수 ************************/
 
/************************* 첫  페이지 로딩 ******************************/
window.onload = $(function() { //페이지가 로드되면 데이터를 가져오고 page를 증가시킨다.	
	getPartyList(cpage);
	test();
	cpage++;
	area();
});
/*********************** End 첫  페이지 로딩 ****************************/

/*********************** 스크롤 페이지 로딩 ****************************/
function getDocHeight() {
    var D = document;
    return Math.max(
        D.body.scrollHeight, D.documentElement.scrollHeight,
        D.body.offsetHeight, D.documentElement.offsetHeight,
        D.body.clientHeight, D.documentElement.clientHeight
    );
}

function test(){
	$(window).scrollTop(0);
}
		 
$(function() {	
	$(window).scroll(function() { //스크롤이 최하단 으로 내려가면 리스트를 조회하고 page를 증가시킨다.
		console.log(getDocHeight());
		if ($(window).scrollTop() == getDocHeight() - $(window).height()) {
			console.log($("#start_list > div").last().html());
			console.log($("#start_list > div").last().attr('id'));
			console.log("새로 로딩 : ");
			console.log(formData);
			console.log(typeof(formData));
			var check = typeof(formData);
			console.log(check);
			console.log(formData.length);
			console.log(cpage);
			if($("#start_list > div").last().attr('id') == "endSearch"){
				alert("더 이상 검색할 내용이 없습니다.");
			}
			else{					
				if(check == "string"){
					cpage++;
					partySearch(url,formData,cpage);
				}
				else{
					getPartyList(cpage);
					cpage++;
				}
			}	
		}
	});
});
/********************* End 스크롤 페이지 로딩 **************************/
 
/*********************** ajax 로딩 이미지 ****************************/ 
$(function(){
	$(document).ajaxStart(function(){
		$('#Progress_Loading').show(); //ajax실행시 로딩바를 보여준다.
	})
	$(document).ajaxStop(function(){
		$('#Progress_Loading').hide(); //ajax종료시 로딩바를 숨겨준다.
	});	
})
/********************* End ajax 로딩 이미지 **************************/

/********************* 기본 페이지 로딩 ajax **************************/
function partySearch(url,formData,cpage){
	console.log(url);
	$.ajax({
		type : "POST",
		url : url,
		data : {"formData" : formData, "cpage":cpage},
		success : function(partyList) {
			//$("#start_list").append("<div class=\"col-lg-3 col-md-4 col-sm-6 col-xs-12\" style=\"background-color: ivory\"><span>"+cpage+" 통합 검색<span></div>");
			$("#start_list").append(partyList);
		},
	    error:function(e){
	    	alert("데이터를 가져오는데 실패하였습니다.");        
	    }
	});
}
/******************* End 기본 페이지 로딩 ajax ************************/
 
/*********************** 통합 검색 페이지 로딩 ajax ***********************/
function getPartyList(cpage){		 
    $.ajax({
        type : 'get',  
        data : {"cpage" : cpage},
        url : '/party/getPartyList',
        success : function(partyList) {
        	//$("#start_list").append("<div class=\"col-lg-3 col-md-4 col-sm-6 col-xs-12\" style=\"background-color: ivory\"><span>"+cpage+ "기본 검색 <span></div>");
            $("#start_list").append(partyList);         
       },
       error:function(e){
    	   alert("데이터를 가져오는데 실패하였습니다.");        
       }
    });
}
/********************* End 통합 검색 페이지 로딩 ajax *********************/

/************************ 통합 검색  *****************************/
$(function(){
	$(document).on('submit','#idForm',function(e) {
		console.log("상세검색 준비");
		cpage=1;
		
		formData = JSON.stringify($("#idForm").serializeArray());
		console.log("검색 시작: " );
		console.log(formData);
		
	    e.preventDefault(); // avoid to execute the actual submit of the form.
	    
		$("#start_list").empty();	
	    test();
		partySearch(url,formData,cpage);
		$("#idForm")[0].reset();
		$("option", $("#sido")).remove();
		$("option", $("#gugun")).remove();
		area();
	});	
});
/********************** End 통합 검색 ***************************/

/******************* 태훈 모임 내용 모달창 생성 ************************/
$(function() {
	console.log("버튼 기능 준비");		
	$(document).on('click', '.myBtn', function() {
		console.log("버튼 기능 시작");
		if ("${loginInfo.id}" == "") {
			alert("로그인 후 이용해주세요");
			location.replace('/member/loginview');
		} else {
			var select_seq = $(this).parent().siblings().children(".party_seq").val();
			$("#aaa").empty();
			$.ajax({
				url : "/party/party_content_include",
				data : {seq : select_seq}
			}).done(function(con) {
				console.log(con);
				$("#aaa").append(con);
				$("#mymodal").modal();
			});
		}
	});
});
/***************** End 태훈 모임 내용 모달창 생성 **********************/

/*****************************************  태훈  지역 검색 스크립트  ***********************************************/
function area () {
	
	/******************* 지역 리스트 ************************/
	var area0 = [ "시/도 선택", "서울", "인천", "대전", "광주", "대구", "울산", "부산", "경기",
			"강원", "충북", "충남", "전북", "전남", "경북", "경남", "제주특별자치도" ];
	var area1 = [ "강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구",
				"노원구", "도봉구", "동대문구", "동작구", "마포구", "서대문구", "서초구", "성동구",
				"성북구", "송파구", "양천구", "영등포구", "용산구", "은평구", "종로구", "중구", "중랑구" ];
	var area2 = [ "계양구", "남구", "남동구", "동구", "부평구", "서구", "연수구", "중구",
				"강화군", "옹진군" ];
	var area3 = [ "대덕구", "동구", "서구", "유성구", "중구" ];
	var area4 = [ "광산구", "남구", "동구", "북구", "서구" ];
	var area5 = [ "남구", "달서구", "동구", "북구", "서구", "수성구", "중구", "달성군" ];
	var area6 = [ "남구", "동구", "북구", "중구", "울주군" ];
	var area7 = [ "강서구", "금정구", "남구", "동구", "동래구", "부산진구", "북구", "사상구",
				"사하구", "서구", "수영구", "연제구", "영도구", "중구", "해운대구", "기장군" ];
	var area8 = [ "고양시 덕양구", "고양시 일산동구", "고양시 일산서구", "과천시", "광명시", "광주시",
				"구리시", "군포시", "김포시", "남양주시", "동두천시", "부천시 소사구", "부천시 오정구",
				"부천시 원미구", "성남시 분당구", "성남시 수정구", "성남시 중원구", "수원시 권선구",
				"수원시 영통구", "수원시 장안구", "수원시 팔달구", "시흥시", "안산시 단원구", "안산시 상록구",
				"안성시", "안양시 동안구", "안양시 만안구", "양주시", "오산시", "용인시 기흥구",
				"용인시 수지구", "용인시 처인구", "의왕시", "의정부시", "이천시", "파주시", "평택시",
				"포천시", "하남시", "화성시", "가평군", "양평군", "여주군", "연천군" ];
	var area9 = [ "강릉시", "동해시", "삼척시", "속초시", "원주시", "춘천시", "태백시", "고성군",
				"양구군", "양양군", "영월군", "인제군", "정선군", "철원군", "평창군", "홍천군", "화천군",
				"횡성군" ];
	var area10 = [ "제천시", "청주시", "충주시", "괴산군", "단양군", "보은군", "영동군", "옥천군",
				"음성군", "증평군", "진천군", "청원군" ];
	var area11 = [ "계룡시", "공주시", "논산시", "보령시", "서산시", "아산시", "천안시", "금산군",
				"당진군", "부여군", "서천군", "연기군", "예산군", "청양군", "태안군", "홍성군" ];
	var area12 = [ "군산시", "김제시", "남원시", "익산시", "전주시", "정읍시", "고창군", "무주군",
				"부안군", "순창군", "완주군", "임실군", "장수군", "진안군" ];
	var area13 = [ "광양시", "나주시", "목포시", "순천시", "여수시", "강진군", "고흥군", "곡성군",
				"구례군", "담양군", "무안군", "보성군", "신안군", "영광군", "영암군", "완도군", "장성군",
				"장흥군", "진도군", "함평군", "해남군", "화순군" ];
	var area14 = [ "경산시", "경주시", "구미시", "김천시", "문경시", "상주시", "안동시", "영주시",
				"영천시", "포항시", "고령군", "군위군", "봉화군", "성주군", "영덕군", "영양군", "예천군",
				"울릉군", "울진군", "의성군", "청도군", "청송군", "칠곡군" ];
	var area15 = [ "거제시", "김해시", "마산시", "밀양시", "사천시", "양산시", "진주시", "진해시",
				"창원시", "통영시", "거창군", "고성군", "남해군", "산청군", "의령군", "창녕군", "하동군",
				"함안군", "함양군", "합천군" ];
	var area16 = [ "서귀포시", "제주시" ];
	/******************* 지역 리스트 ************************/
	
	// 시/도 선택 박스 초기화
	$.each(area0,function() {
		$("#sido").append("<option value='"+this+"'>" + this + "</option>");
	});
	$("#gugun").append("<option value=''>구/군 선택</option>");	
	// 시/도 선택시 구/군 설정
	$("#sido").change(function() {
		var areaindex = $('option:selected', $(this)).index();
		$("option", $("#gugun")).remove();
		if (areaindex == 0) {
			$("#gugun").append("<option value=''>구/군 선택</option>");
		} else {
			$("#gugun").append("<option value=''>구/군 선택</option>");
			$.each(eval("area" + areaindex), function() {
				$("#gugun").append("<option value='"+this+"'>" + this + "</option>");
			});
		}
	});
};
/*************************************** End 태훈  지역 검색 스크립트  *********************************************/

/**************************** 인기 맛집  모집하러기 *********************************/
 $(function(){
	 $(".topBtn").on("click", function() {
		 if ("${loginInfo.id}" == "") {
				alert("로그인 후 이용해주세요");
				location.replace('/member/loginview');
		}else{
			location.href = "/map/mapToParty_New?parent_name="
				+ $(this).siblings(".store_name").html()
				+ "&parent_address="
				+ $(this).siblings(".store_address").val()
				+ "&img=" + $(this).parent().siblings().find("img").attr("src")
				+ "&place_id="
				+ $(this).siblings(".store_place_id").val()
				+ "&category="
				+ $(this).siblings(".store_category").val();
		}
	});	 
 });
/************************** End 인기 맛집  모집하러기 ********************************/

/***************** by 페이지 로딩 스피너 **************/ 
$(function(){
	$('#Progress_Loading').hide(); //첫 시작시 로딩바를 숨겨준다.	
});
/***************** End 페이지 로딩 스피너 **************/


/***************** 상단 돌아가기 버튼 **************/
$(function() {
	$(window).scroll(function() {
		if ($(this).scrollTop() > 100) {
			$('.back-to-top').fadeIn('slow');
		} else {
			$('.back-to-top').fadeOut('slow');
		}
	});
	$('.back-to-top').click(function() {
		$('html, body').animate({
			scrollTop : 0
		}, 1500, 'easeInOutExpo');
		return false;
	});
});

	 
/***************** 상단 돌아가기 버튼 **************/
</script>
<style>

.aa {
	width: 60%;
	margin: auto;
}

.topt5{
	margin: auto;
}

.listtitle {
	font-size: 35px;
}

.partylist {
	margin-bottom: 20px;
}
.adb{
	margin-bottom: 15px;
}

.searchpart{
	background-color:#ffd04f;
	padding:15px;
}


#Progress_Loading{
	position:fixed;
	height:100vh;
	width:100vw;
    background-color: rgba( 255, 255, 255, 0.5 );
	z-index:100;
}

#Progress_Loading img{
	position:absolute;
	left: 50%;
	top: 40%;
}


.thumbnail-wrapper {
  width: 100%;
  border: 1px solid rgba(0, 0, 0, 0.1);
}

.thumbnail {
  position: relative;
  padding-top: 100%;
  overflow: hidden;
}

.thumbnail-centered {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  transform: translate(50%, 50%);
}

.thumbnail-img {
	max-width: 100%;
/*   height: 박스의 height와 같아야 한다. */
  transform: translate(-50%, -50%);
}
.topBtn{
	background-color:#ff923c;
	border-color:#ff923c;
}
.topBtn:hover{
	background-color:#ff9d4f;
	border-color:#ff9d4f;
}

</style>
</head>
<body>
<% request.setCharacterEncoding("UTF-8"); %>
	<!-- ******************* -->
	<!-- header  -->
	<jsp:include page="/WEB-INF/views/include/header.jsp" />
	<!-- hedaer  -->
	<!-- ******************* -->

	<div class="container-fluid">
		
		<!-- ================ Top 5 Section ================ -->
		<div class="row aa">
			<span class="col-12 listtitle">인기 맛집 Top 5!</span>
		</div>
		<div class="row row-cols-1 row-cols-sm-3 row-cols-lg-5 aa top5">
			<c:forEach var="top" items="${top}" varStatus="status">
					<div class="card partylist">
						<div class="thumbnail-wrapper imgBox">
							<div class="thumbnail">
								<div class="thumbnail-centered">
									<img class="thumbnail-img"
										src="${imglist2[status.index]}" />
								</div>
							</div>
						</div>
						<!-- <img src="${imglist2[status.index]}" class="card-img-top"> -->
						<div class="card-body cardedit">
							<h5 class="card-title store_name">${top.name }</h5>
							<p class="card-text">
								<c:choose>
									<c:when test="${empty review[top.seq].content }">
									${top.address }
								</c:when>
									<c:otherwise>
										<c:out value="${review[top.seq].content }" />
									<br>
									- by ${review[top.seq].id }	
								</c:otherwise>
								</c:choose>
							</p>
							<input type="hidden" class="store_place_id"
								value="${top.place_id}"> <input type="hidden"
								class="store_address" value="${top.address}"> <input
								type="hidden" class="store_category" value="${top.category}">
							<button type="button" class="btn btn-info btn-sm topBtn">모집하러
								가기</button>
						</div>
					</div>
			</c:forEach>
		</div>
		<!-- ============== End Top 5 Section ============== -->
		
		<!-- =========== Loding Spinner Section ============= -->
		<div id = "Progress_Loading"><!-- 로딩바 -->
			<img src="/resources/img/Progress_Loading.gif"/>
		</div>
		<!-- ========== End Loding Spinner Section ========== -->
		
		<!-- ============== Party List Search Section ============== -->
		<div class="row aa searchpart">
			<form id="idForm">
				<span class="listtitle">통합 검색</span>
				<div id="areacheck">
					지역: 
					<select name="sido" id="sido"></select> 
					<select name="gugun" id="gugun"></select>
				</div>
				<div id="gendercheck">
					성별 : 
					<input type="radio" name="gender" value="m" /> 남자만 
					<input type="radio" name="gender" value="f" /> 여자만 
					<input type="radio" name="gender" value="a" /> 남녀무관
				</div>
				<div id="agecheck">
					연령 : 
					<input type="checkbox" name="age" value="10" /> 10대 
					<input type="checkbox" name="age" value="20" /> 20대 
					<input type="checkbox" name="age" value="30" /> 30대 
					<input type="checkbox" name="age" value="40" /> 40대 
					<input type="checkbox" name="age" value="50" /> 50대 이상
				</div>

				<div id="drinkingcheck">
					음주 : 
					<input type="radio" name="drinking" value="0" /> 불가능 
					<input type="radio" name="drinking" value="1" /> 가능 
					<input type="hidden" name="drinking" value="2" />
				</div>

				<div>
					<select name="text">
						<option value="title">제목</option>
						<option value="writer">작성자</option>
						<option value="content">내용</option>
						<option value="both">제목 + 내용</option>
					</select> 
					<input type="text" name="search">
					<input type="submit" value="검색">
				</div>

			</form>
		</div>
	</div>
	<!-- ============ End Party List Search Section ============ -->

	<!-- ======= Party List Section ======= -->
	<main id="main">
		<div class="area-padding">
		
		<div class="row">
			<div class="col-md-12 col-sm-12 col-xs-12">
				<div class="section-headline text-center">
					<h2>밥 먹고 갈래?</h2>
				</div>
			</div>
		</div>
		
			<div class="container-fluid">
				
				<div class="row" id="start_list">
					
				</div>
			</div>
		</div>
	</main>
	<!-- End Party List Section -->
	
	<!-- =========== To TOP Section ============= -->
	<a href="#" class="back-to-top"> 
		<i class="fa fa-chevron-up"></i>
	</a>
	<!-- ========= End To TOP Section =========== -->
	
	<!-- ======= Page Modal Section ======= -->
	<div class="modal fade" id="mymodal" role="dialog">
		<div class="modal-dialog modal-xl">
			<!-- Modal content-->
			<div class="modal-content" id="aaa">
				
			</div>
		</div>
	</div>
	<!-- ======= End Page Modal Section ======= -->
	
	<!-- ******************* -->
	<!-- footer  -->
	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
	<!-- footer  -->
	<!-- ******************* -->
	
	<!-- Vendor JS Files -->
  <script src="/resources/assets/vendor/jquery.easing/jquery.easing.min.js"></script>
  <script src="/resources/assets/vendor/appear/jquery.appear.js"></script>  
</body>
</html>
 


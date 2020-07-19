<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>맛집갔다갈래 - 맛집 동행 찾기 서비스 By 코딩맛집(COMA)</title>
<!-- BootStrap4 -->
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>
<!-- BootStrap4 End-->

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
	href="/resources/css/index-css.css?c">
<!-- header,footer용 css  -->
<!-- ******************* -->

<!-- 
<script>
	$(function(){
		$("#toMap").on("click",function(){
			location.href = "/map/toMap";
		})
	})
</script> -->
 <style type="text/css">
        html,body{ margin:0; padding:0; width:100%; height:100%;}
        .box{ width:100%; height:100%; position:relative; color:#ffffff; font-size:24pt;}
        .imgdiv {margin:auto;padding-top:50px; padding-left:150px;}
        .bg-fdc23e {background-color: #fdc23e;}
        
    </style>
    <script type="text/javascript">
        window.onload = function () {
            var elm = ".box";
            $(elm).each(function (index) {
                // 개별적으로 Wheel 이벤트 적용
                $(this).on("mousewheel DOMMouseScroll", function (e) {
                    e.preventDefault();
                    var delta = 0;
                    if (!event) event = window.event;
                    if (event.wheelDelta) {
                        delta = event.wheelDelta / 120;
                        if (window.opera) delta = -delta;
                    } 
                    else if (event.detail)
                        delta = -event.detail / 3;
                    var moveTop = $(window).scrollTop();
                    var elmSelecter = $(elm).eq(index);
                    // 마우스휠을 위에서 아래로
                    if (delta < 0) {
                        if ($(elmSelecter).next() != undefined) {
                            try{
                                moveTop = $(elmSelecter).next().offset().top;
                            }catch(e){}
                        }
                    // 마우스휠을 아래에서 위로
                    } else {
                        if ($(elmSelecter).prev() != undefined) {
                            try{
                                moveTop = $(elmSelecter).prev().offset().top;
                            }catch(e){}
                        }
                    }
                     
                    // 화면 이동 0.8초(800)
                    $("html,body").stop().animate({
                        scrollTop: moveTop + 'px'
                    }, {
                        duration: 800, complete: function () {
                        }
                    });
                });
            });
        }
    </script>
</head>
<body style=" margin:0; padding:0; ">
 <div class="box main-bg1">
	<!-- ******************* -->
	<!-- header  -->
	<jsp:include page="/WEB-INF/views/include/header.jsp" />
	<!-- hedaer  -->
	<!-- ******************* -->

	<!--contents-->
	
	<div class="container-fluid ">
		<!-- 슬라이드 -->
		<div class="row">
		<div class="col-12 px-0 mx-0"><img width="100%" src="/resources/img/slide01.jpg"> </div>
	</div>
		<!-- <div class="row slide-area ">
			<div class="col px-0 mx-0">

				<div id="carouselExampleCaptions" class="carousel slide"
					data-ride="carousel">
					<ol class="carousel-indicators">
						<li data-target="#carouselExampleCaptions" data-slide-to="0"
							class="active"></li>
						<li data-target="#carouselExampleCaptions" data-slide-to="1"></li>
						<li data-target="#carouselExampleCaptions" data-slide-to="2"></li>
						<li data-target="#carouselExampleCaptions" data-slide-to="3"></li>
					</ol>
					<div class="carousel-inner">
						<div class="carousel-item active">
							<img src="/resources/img/slide01.jpg" class="d-block w-100"
								alt="...">
							<div class="carousel-caption d-none d-md-block">
								<h1>
									마음의 허기를 달래줄<br> <span class="index-copyright">밥친구</span>를
									찾습니다
								</h1>
								<p>맛집 동행 찾기 서비스 - 맛집갔다갈래</p>
							</div>
						</div>
						<div class="carousel-item">
							<img src="/resources/img/slide02.jpg" class="d-block w-100"
								alt="...">
							<div class="carousel-caption d-none d-md-block">
								<h1>
									같은 팀을 응원하는 사람과<br> 함께 중계를 보며 식사를 하고 싶을때
								</h1>
								<p>스포츠와 함께 할 때 더 즐거운 식사</p>
							</div>
						</div>
						<div class="carousel-item">
							<img src="/resources/img/slide03.jpg" class="d-block w-100"
								alt="...">
							<div class="carousel-caption d-none d-md-block">
								<h1>
									혼자 가기 아쉬운 맛집<br> 누군가와 함께 가고 싶을 때
								</h1>
								<p>같이 공유하는 미각의 즐거움</p>
							</div>
						</div>
						<div class="carousel-item">
							<img src="/resources/img/slide04.jpg" class="d-block w-100"
								alt="...">
							<div class="carousel-caption d-none d-md-block">
								<h1>
									지금 찾아보세요<br> 맛있는 음식! 즐거운 친구!
								</h1>
								<p>간편회원가입으로 시작하세요!</p>
							</div>
						</div>
					</div>
					<a class="carousel-control-prev" href="#carouselExampleCaptions"
						role="button" data-slide="prev"> <span
						class="carousel-control-prev-icon" aria-hidden="true"></span> <span
						class="sr-only">Previous</span>
					</a> <a class="carousel-control-next" href="#carouselExampleCaptions"
						role="button" data-slide="next"> <span
						class="carousel-control-next-icon" aria-hidden="true"></span> <span
						class="sr-only">Next</span>
					</a>
				</div>
			</div>
		</div> -->
		</div>

	<!-- <div class="container-fluid py-0 my-0 bg-fdc23e">
		<div class="row">
			<div class="col-12 col-sm-12  pt-3 pb-3 my-0 text-center">
				<a id="toJoinBtn"><h4 class="lastcopy text-center"> 1분만에 무료 간편회원가입하고 모임을 시작해보세요.</h4></a>
				<button type="button" id="toJoinBtn"
					class="btn btn-success btn-lg text-center">간편 무료회원가입</button>
			</div>
		</div>
	</div>
 -->

		
	</div>
		 <div class="box" style="background-color:orange;"><div class="imgdiv"><img width="90%" src="/resources/img/mn/party.jpg"></div></div>
    <div class="box" style="background-color:yellow;"><div class="imgdiv"><img width="80%" src="/resources/img/mn/map.jpg"></div></div>
    <div class="box" style="background-color:green;"><div class="imgdiv"><img src="/resources/img/mn/chat.jpg"></div></div>
    <div class="box" style="background-color:blue;"><div class="imgdiv"><img src="/resources/img/mn/search.jpg"></div></div>
    
    <div class="box" style="background-color:violet;"><!-- ******************* -->
	<!-- footer  -->
	<jsp:include page="/WEB-INF/views/include/footer.jsp" />

	<!-- footer  -->
	<!-- ******************* --></div>
	
	<!-- 카카오톡으로 로그인한 경우 accoun_email인증이 안되었기 때문에 mypage로 이동시킨다. -->
	<script>
		if ("${loginInfo.account_email}" == "need@eat-together.com") {
			alert("이메일 인증 후 사이트를 이용해주시길 바랍니다.");
			location.replace("/member/mypage_myinfo");
		}
	</script>

	
</body>
</html>

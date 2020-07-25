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
<title>맛집갔다갈래 - ${con.title} / ${con.writer}</title>
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

<!-- SNS Share js start -->
<script src='/resources/js/sns_share.js?a'></script>
<!-- SNS Share js end -->

<!-- ******************* -->
<!-- header,footer용 css  -->
<link rel="stylesheet" type="text/css"
	href="/resources/css/index-css.css">
<!-- header,footer용 css  -->
<!-- ******************* -->

<link rel="stylesheet" type="text/css"
	href="/resources/css/party-css.css?ver=1">

</head>
<script>

// by 지은, 카카오톡으로 로그인한 경우 accoun_email인증이 안되었기 때문에 mypage로 이동시킨다_20200717	
if ("${loginInfo.account_email}" == "need@eat-together.com") {
	alert("이메일 인증 및 개인정보 수정 후 사이트를 이용해주시길 바랍니다.");
	location.replace("/member/mypage_myinfo");
}

function send_msg(){
	var option = "width = 500, height = 550, top = 100, left = 200, scrollbars=no"
	var target="${con.writer}";
	window.open("/msg/msgResponse?msg_receiver="+target,target,option);
};

function toChatroom(num){
    var option = "width = 800, height = 800, top = 100, left = 200, scrollbars=no"
    window.open("/chat/chatroom?roomNum="+num, num, option);
}

function partyReport(num){
	console.log("신고 시작 : "+ num);
	var report_id = "${con.writer}";
	var title = "${con.title}";
	var content = $(".party_content").html();
	console.log("신고 시작 : "+ report_id);
	$.ajax({
		url:"/party/party_report",
		
		data : { seq : num, report_id : report_id , title : title , content : content},
		success : function(result) {
			console.log("신고 접수");
			console.log(result);
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

$(document).ready(function(){
	   // by 지은, 카카오톡으로 로그인한 경우 accoun_email인증이 안되었기 때문에 mypage로 이동시킨다_20200717   
	   if ("${loginInfo.account_email}" == "need@eat-together.com") {
	      alert("이메일 인증 및 개인정보 수정 후 사이트를 이용해주시길 바랍니다.");
	      location.replace("/member/mypage_myinfo");
	   }
	
	var stime = "${con.sTime}";
	var time = stime.substr(0,5);
	console.log(time);
	$("#time").html(time);
});

	$(function() {
		$("#partyModify").on("click", function() {
			location.href = "/party/partymodify?seq=${con.seq}";
		});

		$("#partyDelete").on("click", function() {
			var ask = confirm("삭제 후에는 복구할 수 없습니다.\n 정말 삭제하겠습니까?");
			if (ask) {
				location.href = "/party/partydelete?seq=${con.seq}";
			}
		});

		$("#toPartylist").on("click", function() {
			location.href = "/party/selectByWriter?mcpage=1";
		});
		
		$("#toPartyJoin").on("click",function(){ //모임가입
			location.href="/party/partyJoin?seq=${con.seq}";
		});
		
		
		
		// 태훈 신고
		$("#partyReport").on("click", function() {
			var ask = confirm("무분별한 신고는 신고자 본인에게 불이익이 갈 수 있습니다.\n정말 신고하겠습니까?");	
			if (ask) {
				
				partyReport(${con.seq} );
			}
		});
		
		$("#toChatroom").on("click", function() {
			toChatroom(${con.seq});
		});
		
		$("#toExitParty").on("click",function(){
			var ask = confirm("정말 모임을 나가시겠습니까?");
			if (ask) {
			location.href= "/party/toExitParty?seq=${con.seq}";
			}
		});
        
		
		$("#toStopRecruit").on("click",function(){
			var ask = confirm("정말 모집을 종료하시겠습니까?");
			if (ask) {
			location.href= "/party/stopRecruit?seq=${con.seq}&writer=${con.writer}";
			}
		});
		

		$("#torestartRecruit").on("click",function(){
			var ask = confirm("모집을 다시 시작하겠습니까?");
			if (ask) {
			location.href= "/party/restartRecruit?seq=${con.seq}&writer=${con.writer}";
			}
		});

	});
	
	//페이지 리사이징
	$(function() {
		$('.cropping img').each(function(index, item) {
			if ($(this).height() / $(this).width() < 0.567) {
				$(this).addClass('landscape').removeClass('portrait');
			} else {
				$(this).addClass('portrait').removeClass('landscape');
			}
		});
	});
</script>
<style>
.mb-1 {
	padding: 3px;
}

.mb-1>div:nth-child(1) {
	background-color: #f9a11b50;
	border-radius: 5px;
	text-align: center;
	padding: 1px
}

.mb-1>div:nth-child(2) {
	margin: 0px;
	padding: 5px;
	padding-left: 20px
}

.featImgWrap {
	height: 250px;
	position: relative;
	padding-top: 56.57%;
	/* 16:9 ratio */
	overflow: hidden;
}

.featImgWrap .cropping {
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	-webkit-transform: translate(50%, 50%);
	-ms-transform: translate(50%, 50%);
	transform: translate(50%, 50%);
}

.featImgWrap .cropping img {
	position: absolute;
	top: 0;
	left: 0;
	max-width: 100%;
	height: auto;
	-webkit-transform: translate(-50%, -50%);
	-ms-transform: translate(-50%, -50%);
	transform: translate(-50%, -50%);
}

.featImgWrap .cropping img.landscape {
	max-height: 100%;
	height: 100%;
	max-width: none;
}

.featImgWrap .cropping img.portrait {
	max-width: 100%;
	width: 100%;
	max-height: none;
	border: 1px solid black;
}
</style>
<body>
	<!-- ******************* -->
	<!-- header  -->
	<jsp:include page="/WEB-INF/views/include/header.jsp" />
	<!-- hedaer  -->
	<!-- ******************* -->
	<div class="container-fluid section">
		<div class="container">
			<div class="row mb-3">
				<div class="col-sm-12 mt-3">
					<h2 class="party_headline">
						#
						<c:out value='${con.seq}' />
						/
						<c:out value='${con.title}' />
						<input type="hidden" id="sns_share_title"
							value="《  ${con.parent_name} 》 에 같이 가자!!! - 맛집동행찾기서비스 맛집갔다갈래">
						<c:choose>
							<c:when test="${con.status  eq '1'}">
								<span class="badge badge-success">멤버 모집중</span>

								<c:if
									test="${con.writer ne sessionScope.loginInfo.id && partyParticipantCheck eq false && ((sessionScope.loginInfo.gender eq 1 &&  con.gender eq 'm') || (sessionScope.loginInfo.gender eq 2 && con.gender eq'f') || con.gender eq 'a')}">
									<div class="row  pt-1 mt-2">
										<div class="col-sm-12 alert alert-success">
											<h6 class="">참여가능한 모임입니다.</h6>
											<span class="party-info">현재 <strong>${party.count}명</strong>
												참여중 / 총 모집인원 <strong>${con.count}명</strong>
											</span>
										</div>
									</div>
								</c:if>
							</c:when>
							<c:when test="${con.status  eq '0'}">
								<span class="badge badge-secondary">모집마감</span>
								<c:if
									test="${con.writer ne sessionScope.loginInfo.id && partyParticipantCheck eq false  }">
									<div class="row mt-2 ">
										<div class="col-sm-12 alert alert-danger">
											<h6 class="">모집이 종료되어 참여할 수 없습니다.</h6>
											<span class="party-info">(참여 : <strong>${party.count}</strong>
												/ 모집 : <strong>${party.pull}</strong>)
											</span>
										</div>
									</div>
								</c:if>
							</c:when>
						</c:choose>
					</h2>
					<c:if test="${con.report == 0 }">
						<div class="row  pt-1 mt-2">
							<div class="col-sm-12 alert alert-success">
								<h6 class="">
									<strong>정상모임</strong> : 신고건수 ${con.report} 건
								</h6>
							</div>
						</div>
					</c:if>
					<c:if test="${con.report > 0 && con.report < 5 }">
						<div class="row  pt-1 mt-2">
							<div class="col-sm-4 alert alert-warning">
								<h6 class="">
									<strong>요주의모임</strong> : 신고건수 ${con.report} 건
								</h6>
							</div>
						</div>
					</c:if>
					<c:if test="${con.report >= 5}">
						<div class="row  pt-1 mt-2">
							<div class="col-sm-4 alert alert-danger">
								<h6 class="">
									<strong>위험모임</strong> : 신고건수 ${con.report} 건
								</h6>
							</div>
						</div>
					</c:if>

				</div>
				<div class="col-sm-12 party_writer">
					작성자 : ${con.writer} <a onclick="send_msg()"><img
						src="/resources/img/send_message.png"></a>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="row mb-1">
						<div class="col-sm-3 party-titlelabel">상호</div>
						<div class="col-sm-9">${con.parent_name}</div>
					</div>
					<div class="row mb-1">
						<div class="col-sm-3 party-titlelabel">위치</div>
						<div class="col-sm-9">${con.parent_address}</div>
					</div>
					<%-- <div class="row mb-1">
				<div class="col-sm-2">제목</div>
				<div class="col-sm-10">
					${con.title}
				</div>
			</div> --%>
					<div class="row mb-1">
						<div class="col-sm-3 party-titlelabel">날짜</div>
						<div class="col-sm-9 pl-3">${con.sDate }</div>
					</div>
					<div class="row mb-1">
						<div class="col-sm-3 party-titlelabel">시간</div>
						<div class="col-sm-9 pl-3" id="time"></div>
					</div>
					<div class="row mb-1">
						<div class="col-sm-3 party-titlelabel">인원</div>
						<div class="col-sm-9">
							<span class="badge badge-success">현재 참여자</span> ${party.count} 명
							<span class="badge badge-warning">총 모집인원</span> ${con.count} 명
						</div>

					</div>
					<div class="row mb-1">
						<div class="col-sm-3 party-titlelabel">구성</div>
						<div class="col-sm-9">
							<c:choose>
								<c:when test="${con.gender  eq 'm'}">남자만</c:when>
								<c:when test="${con.gender  eq 'f'}">여자만</c:when>

								<c:otherwise> 남녀무관 </c:otherwise>
							</c:choose>

						</div>

					</div>


					<div class="row mb-1">
						<div class="col-sm-3 party-titlelabel">연령</div>
						<div class="col-sm-9">${con.age}</div>
					</div>

					<div class="row mb-1" id="adult_q">
						<div class="col-sm-3 party-titlelabel">음주</div>
						<div class="col-sm-9">
							<c:choose>
								<c:when test="${con.drinking  eq '1'}">OK</c:when>
								<c:when test="${con.drinking  eq '0'}">NO</c:when>
							</c:choose>

						</div>
					</div>
					<div class="row mb-1">
						<div class="col-sm-3 mb-3 party-titlelabel">소개</div>
						<div class="col-sm-9 party-contenttext-area party_content">
							<c:out value='${con.content}' />
						</div>
					</div>
					<div class="row mb-1">
						<div class="col-sm-3 party-titlelabel">SNS</div>
						<div class="col-sm-9">

							<!-- 네이버 블로그/카페 공유 -->

							<a onclick="share_naver()"> <img
								src="/resources/img/sns_icon/sns_naver.png" class="sns_icon"></a>

							<!-- 트위터 공유 -->
							<a onclick="share_twitter()"><img
								src="/resources/img/sns_icon/sns_tw.png" class="sns_icon"></a>

							<!-- 페이스북 공유 -->
							<a onclick="share_facebook()"><img
								src="/resources/img/sns_icon/sns_face.png" class="sns_icon"></a>

							<!-- 카카오톡 공유 -->
							<a onclick="share_kakao()"><img
								src="/resources/img/sns_icon/sns_ka.png" class="sns_icon"></a>

						</div>

					</div>
				</div>
				<div class="col-sm-6">

					<div class="featImgWrap">
						<div class="cropping">
							<img src="${con.imgaddr}" width="350px" id="storeimg">
						</div>
					</div>
				</div>

			</div>
			<div class="row mb-1 mt-2 mb-3"></div>
			<div class="row mb-2">
				<div class="col-12 text-center">
					<c:choose>
						<c:when
							test="${(partyFullCheck eq false && con.status eq 1 ) && partyParticipantCheck eq false}">
							<c:if
								test="${ (sessionScope.loginInfo.gender eq 1 &&  con.gender eq 'm') || (sessionScope.loginInfo.gender eq 2 && con.gender eq'f') || con.gender eq 'a' }">
								<button type="button" id="toPartyJoin" class="btn btn-success">모임참가하기</button>
							</c:if>
						</c:when>
						<c:when test="${partyParticipantCheck  eq true}">
							 <c:if test="${partylife eq 'alive' }"> 
							<button type="button" id="toChatroom" class="btn btn-primary">채팅방으로
								이동</button>
							 </c:if> 
							
							<c:if test="${con.writer ne sessionScope.loginInfo.nickname }">
								<button type="button" id="toExitParty" class="btn btn-danger">모임
									나가기</button>
							</c:if>
							<c:if test="${con.writer eq sessionScope.loginInfo.nickname }">

								<c:choose>
									<c:when test="${con.status  eq '1'}">
										<button type="button" id="toStopRecruit" class="btn btn-dark">모집
											종료하기</button>
									</c:when>
									<c:when test="${con.status  eq '0'}">
										<button type="button" id="torestartRecruit"
											class="btn btn-success">모집 재시작</button>

									</c:when>
								</c:choose>
							</c:if>
						</c:when>


					</c:choose>
				</div>
			</div>
			<div class="row mb-3">
				<div class="col-12 mb-5 text-right">
					<c:if test="${con.writer eq sessionScope.loginInfo.nickname }">
						<button type="button" id="partyModify" class="btn btn-warning">수정하기</button>
						<button type="button" id="partyDelete" class="btn btn-danger">삭제하기</button>
					</c:if>
					<c:if test="${con.writer ne sessionScope.loginInfo.nickname }">
						<button type="button" id="partyReport" class="btn btn-info">신고하기</button>
					</c:if>
					<button type="button" id="toPartylist" class="btn btn-secondary">목록으로</button>
				</div>
			</div>
		</div>
	</div>


	<!-- ******************* -->
	<!-- footer  -->
	<jsp:include page="/WEB-INF/views/include/footer.jsp" />

	<!-- footer  -->
	<!-- ******************* -->
</body>
</html>
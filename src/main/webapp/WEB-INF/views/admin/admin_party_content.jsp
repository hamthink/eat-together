<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>
<link rel="stylesheet" type="text/css" href="/resources/css/admin.css">
<title>Admin-모임글관리</title>
<style>
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
<script>
function toChatroom(num){
    var option = "width = 800, height = 800, top = 100, left = 200, scrollbars=no"
    window.open("/chat/chatroom?roomNum="+num, num, option);
}


$(document).ready(function(){
	
	
	var stime = "${con.sTime}";
	var time = stime.substr(0,5);
	console.log(time);
	$("#time").html(time);
});

	$(function() {
		

		$("#partyDelete").on("click", function() {
			var ask = confirm("삭제 후에는 복구할 수 없습니다.\n 정말 삭제하겠습니까?");
			if (ask) {
				location.href = "/admin/partydelete?seq=${con.seq}";
			}
		});

		$("#toPartylist").on("click", function() {
			location.href = "/admin/toAdmin_party";
		});
		
		
		
		$("#toChatroom").on("click", function() {
			toChatroom(${con.seq});
		});
		
	
		
		$("#toStopRecruit").on("click",function(){
			var ask = confirm("모집종료 후에는 되돌릴 수 없습니다. \n 정말 모집을 종료하시겠습니까?");
			if (ask) {
			location.href= "/admin/stopRecruit?seq=${con.seq}";
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



function toDelete(seq){
	var ask = confirm("정말 삭제하시겠습니까?");
	if(ask){
		location.href="/party/partydeleteByAdmin?seq="+seq;
	}
};

		

</script>
</head>
<body>
	<div class="container-fluid mx-0 px-0">
		<div class="row mx-0">

			<div class="col-2 mx-0 px-0"><jsp:include
					page="/WEB-INF/views/include/admin_sidebar.jsp" /></div>
			<div class="col-10 px-5">
				<div class="row">
					<div class="col-12 col-sm-12 mt-3">
						<h2 class="admin-h2">모임글 관리</h2>
					</div>
				</div>

				<div class="row">
					<div class="col-12  col-sm-12">
						<div class="row mb-3">
							<div class="col-sm-12 mt-3">
								<h2 class="party_headline">
									#
									<c:out value='${con.seq}' />
									/
									<c:out value='${con.title}' />
									<input type="hidden" id="sns_share_title"
										value=" /' ${con.parent_name} /' 에 같이 가자!!! - 맛집동행찾기서비스 맛집갔다갈래">
									<c:choose>
										<c:when test="${con.status  eq '1'}">
											<span class="badge badge-success">멤버 모집중</span>
										</c:when>
										<c:when test="${con.status  eq '0'}">
											<span class="badge badge-secondary">모집마감</span>
										</c:when>
									</c:choose>
								</h2>
								<c:if
									test="${con.report == 0 }">
									<div class="row  pt-1 mt-2">
										<div class="col-sm-4 alert alert-success">
											<h6 class=""><strong>정상모임</strong> : 신고건수  ${con.report} 건</h6>
										</div>
									</div>
								</c:if>
								<c:if
									test="${con.report > 0 && con.report < 5 }">
									<div class="row  pt-1 mt-2">
										<div class="col-sm-4 alert alert-warning">
											<h6 class=""><strong>요주의모임</strong> : 신고건수  ${con.report} 건</h6>
										</div>
									</div>
								</c:if>
								<c:if
									test="${con.report >= 5}">
									<div class="row  pt-1 mt-2">
										<div class="col-sm-4 alert alert-danger">
											<h6 class=""><strong>위험모임</strong> : 신고건수 ${con.report} 건</h6>
										</div>
									</div>
								</c:if>
								

							</div>
							<div class="col-sm-12">작성자 : ${con.writer}</div>
						</div>
						<div class="row">
							<div class="col-6 col-sm-6">
								<div class="featImgWrap">
									<div class="cropping">
										<img src="${con.imgaddr}" id="img">
									</div>
								</div>
							</div>
						</div>
						<div class="row mb-1">
							<div class="col-sm-2 party-titlelabel">상호명</div>
							<div class="col-sm-3">${con.parent_name}</div>
						</div>
						<div class="row mb-1">
							<div class="col-sm-2 party-titlelabel">위치</div>
							<div class="col-sm-10">${con.parent_address}</div>
						</div>
						<%-- <div class="row mb-1">
				<div class="col-sm-2">제목</div>
				<div class="col-sm-10">
					${con.title}
				</div>
			</div> --%>
						<div class="row mb-1">
							<div class="col-sm-2 party-titlelabel">모임날짜</div>
							<div class="col-sm-2">${con.sDate }</div>
						</div>
						<div class="row mb-1">
							<div class="col-sm-2 party-titlelabel">시간</div>
							<div class="col-sm-2" id="time"></div>
						</div>
						<div class="row mb-1">
							<div class="col-sm-2 party-titlelabel">인원</div>
							<div class="col-sm-4">현재 참여자 ${party.count} 명 / 총 모집인원
								${con.count} 명</div>

						</div>
						<div class="row mb-1">
							<div class="col-sm-2 party-titlelabel">멤버구성</div>
							<div class="col-sm-10">
								<c:choose>
									<c:when test="${con.gender  eq 'm'}">남자만</c:when>
									<c:when test="${con.gender  eq 'f'}">여자만</c:when>

									<c:otherwise> 남녀무관 </c:otherwise>
								</c:choose>

							</div>

						</div>


						<div class="row mb-1">
							<div class="col-sm-2 party-titlelabel">연령대</div>
							<div class="col-sm-10">${con.age}</div>
						</div>

						<div class="row mb-1" id="adult_q">
							<div class="col-sm-2 party-titlelabel">음주</div>
							<div class="col-sm-10">
								<c:choose>
									<c:when test="${con.drinking  eq '1'}">음주OK</c:when>
									<c:when test="${con.drinking  eq '0'}">음주NO</c:when>
								</c:choose>

							</div>
						</div>
						<div class="row mb-1">
							<div class="col-2 party-titlelabel">소개</div>
							<div class="col-10">
								<c:out value='${con.content}' />
							</div>
						</div>
						<div class="row mb-2">
							<div class="col-12">

								<c:if test="${sessionScope.loginInfo.id eq 'administrator' && con.status eq '1'}">
									<button type="button" id="toStopRecruit" class="btn btn-dark">모집
										종료시키기</button>
								</c:if>

							</div>

						</div>
						<div class="row mb-3">
							<div class="col-12 mb-5">
								<c:if test="${sessionScope.loginInfo.id eq 'administrator'}">

									<button type="button" id="partyDelete" class="btn btn-danger">삭제하기</button>
								</c:if>
								<button type="button" id="toPartylist" class="btn btn-secondary">목록으로</button>

							</div>

						</div>



					</div>
				</div>

			</div>

		</div>

	</div>
</body>
</html>



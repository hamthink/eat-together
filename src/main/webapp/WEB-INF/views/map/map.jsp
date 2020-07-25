<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>맛집지도</title>
<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
<script src='/resources/js/map.js?asaaaaasaaaaada'></script>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
<script
	src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=e156322dd35cfd9dc276f1365621ae9a&libraries=services,clusterer"></script>
<link rel="stylesheet"
	href="https://use.fontawesome.com/releases/v5.13.1/css/all.css"
	integrity="sha384-xxzQGERXS00kBmZW/6qxqJPyxW3UR0BPsL4c8ILaIWXva5kFi7TxkIIaMiKtqV1Q"
	crossorigin="anonymous">
<!-- header,footer용 css  -->
<link rel="stylesheet" type="text/css"
	href="/resources/css/index-css.css">
<link rel="stylesheet" type="text/css" href="/resources/css/map.css?aaaaabbsbbbba">
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
</head>
<body>
	<!-- 사용자가 보고 있는 중심 좌표 -->
	<div style="display: none;" id="centerLat"></div>
	<div style="display: none;" id="centerLng"></div>
	<!-- 선택해서 들어온 중심 좌표 -->
	<div style="display: none;" id="markerLat">${markerlat}</div>
	<div style="display: none;" id="markerLng">${markerlng}</div>
	<div class="container-fluid all">
		<div id="header"><jsp:include
				page="/WEB-INF/views/include/header.jsp" /></div>
		<div id="map_approach_info" style="display:none;">
			<jsp:include page="/WEB-INF/views/include/map_approach_info.jsp" />
		</div>
		<c:if test="${empty sessionScope.loginInfo}">
			<div class="loginPlease">
				<p class="loginMsg">현재 진행중인 모임 ${partyAllCount}개<br>
					<button type="button" class="btn btn-primary toLogin">로그인</button>
					<button type="button" class="btn btn-primary toSignUp">회원가입</button>
				</p>
			</div>
		</c:if>
		<div id = "Progress_Loading"><!-- 로딩바 -->
			<img src="/resources/img/Progress_Loading.gif"/>
		</div>
		<div id="sideBar">
			<div class="navi_btn"><i class="fas fa-chevron-left"></i></div>
			<div class="current_position_btn text-center"  data-toggle="tooltip" data-placement="right" title="현재 내 위치"><i class="fas fa-crosshairs "></i></div>
			<div class="search_area">
				<div class="category_search_btns mx-auto">
					<button type="button" id="backMap"><i class="fas fa-map-marked-alt"></i></button>
					<div class="search_btn" id="foodBtn" data-toggle="tooltip" data-placement="top" title="음식점 전체 목록 조회">
						<i class="fas fa-utensils"></i>
					</div>
					<div class="search_btn" id="cafeBtn" data-toggle="tooltip" data-placement="top" title="카페 전체 목록 조회">
						<i class="fas fa-coffee"></i>
					</div>
				</div>
				<div class="searchbar mx-auto">
					<input type="text" class="search_input" id="keyword"
						placeholder="음식점, 카페 상호명 검색">
					<button type="button" class="search_icon" id="search">
						<i class="fas fa-search"></i>
					</button>
				</div>
			</div>
			<div class="side">
				<div class="search_result">
					<c:if test="${empty mapdto}">
						<jsp:include page="/WEB-INF/views/include/map_approach_info.jsp" />
					</c:if>
				</div>
				<div class="choose_info">
					<c:if test="${not empty mapdto}">
						<div class="store_info mx-auto">
							<div class="name">${mapdto.name}
								<button type="button" id="back"><i class="fas fa-times"></i></button>
							</div>
							<div class="featImgWrap">
								<div class="cropping">
									<img src="${img}" id="mapimg">
								</div>
							</div>
							<div class="category">${mapdto.category}</div>
							<div class="place_id" style="display:none;">${mapdto.place_id}</div>
							<div class="address">${mapdto.address}</div>
							<div class="road_address">${mapdto.road_address}</div>
							<div class="rating_avg">
								<c:choose>
									<c:when test="${mapdto.rating_avg eq 0}">
										<i class="far fa-star"></i>
										<i class="far fa-star"></i>
										<i class="far fa-star"></i>
										<i class="far fa-star"></i>
										<i class="far fa-star"></i>
									</c:when>
									<c:when test="${mapdto.rating_avg eq 1}">
										<i class="fas fa-star"></i>
										<i class="far fa-star"></i>
										<i class="far fa-star"></i>
										<i class="far fa-star"></i>
										<i class="far fa-star"></i>
									</c:when>
									<c:when test="${mapdto.rating_avg eq 2}">
										<i class="fas fa-star"></i>
										<i class="fas fa-star"></i>
										<i class="far fa-star"></i>
										<i class="far fa-star"></i>
										<i class="far fa-star"></i>
									</c:when>
									<c:when test="${mapdto.rating_avg eq 3}">
										<i class="fas fa-star"></i>
										<i class="fas fa-star"></i>
										<i class="fas fa-star"></i>
										<i class="far fa-star"></i>
										<i class="far fa-star"></i>
									</c:when>
									<c:when test="${mapdto.rating_avg eq 4}">
										<i class="fas fa-star"></i>
										<i class="fas fa-star"></i>
										<i class="fas fa-star"></i>
										<i class="fas fa-star"></i>
										<i class="far fa-star"></i>
									</c:when>
									<c:when test="${mapdto.rating_avg eq 5}">
										<i class="fas fa-star"></i>
										<i class="fas fa-star"></i>
										<i class="fas fa-star"></i>
										<i class="fas fa-star"></i>
										<i class="fas fa-star"></i>
									</c:when>
									<c:when test="${mapdto.rating_avg < 1}">
										<i class="fas fa-star-half-alt"></i>
										<i class="far fa-star"></i>
										<i class="far fa-star"></i>
										<i class="far fa-star"></i>
										<i class="far fa-star"></i>
									</c:when>
									<c:when test="${mapdto.rating_avg < 2}">
										<i class="fas fa-star"></i>
										<i class="fas fa-star-half-alt"></i>
										<i class="far fa-star"></i>
										<i class="far fa-star"></i>
										<i class="far fa-star"></i>
									</c:when>
									<c:when test="${mapdto.rating_avg < 3}">
										<i class="fas fa-star"></i>
										<i class="fas fa-star"></i>
										<i class="fas fa-star-half-alt"></i>
										<i class="far fa-star"></i>
										<i class="far fa-star"></i>
									</c:when>
									<c:when test="${mapdto.rating_avg < 4}">
										<i class="fas fa-star"></i>
										<i class="fas fa-star"></i>
										<i class="fas fa-star"></i>
										<i class="fas fa-star-half-alt"></i>
										<i class="far fa-star"></i>
									</c:when>
									<c:when test="${mapdto.rating_avg < 5}">
										<i class="fas fa-star"></i>
										<i class="fas fa-star"></i>
										<i class="fas fa-star"></i>
										<i class="fas fa-star"></i>
										<i class="fas fa-star-half-alt"></i>
									</c:when>
								</c:choose>
							</div>
							<div class="phone">${mapdto.phone}</div>
							<div class="place_url">${mapdto.place_url}</div>
						</div>
					</c:if>
					<c:if test="${not empty mapdto}">
						<div class="partylist">
							<p>진행중인 모임</p>
							<c:if test="${empty partyMap}">
								<small>개설된 모임이 없습니다.</small>
							</c:if>
							<c:if test="${not empty partyMap}">
								<c:forEach var="i" items="${partyMap}">
									<c:if test="${i.key.status eq 1}">
										<div class="party">
											<div class="title">${i.key.title}</div>
											<div class="seq" style="display: none;">${i.key.seq}</div>
											<div class="partyFullCheck" style="display: none;"><c:out value="${i.value.partyFullCheck}"></c:out></div>
											<div class="partyParticipantCheck" style="display: none;"><c:out value="${i.value.partyParticipantCheck}"></c:out></div>
											<div class="partylife" style="display:none;"><c:out value="${i.value.partylife}"></c:out></div>
												<button type="button" class="btn btn-primary join"
													data-toggle="modal" data-target="#partyModal">참가</button>										
										</div>
									</c:if>
								</c:forEach>
							</c:if>
							<nav aria-label="Page navigation example">
								<ul class="pagination pagination-sm justify-content-center">
									<c:if test="${not empty navi}">
					  		${navi}
					  	</c:if>
								</ul>
							</nav>
							<button type="button" class="btn btn-primary" id="mapRecruit">내가 직접 모집하기</button>
						</div>
					</c:if>
					<c:if test="${not empty markerlat}">
						<div class="reviewlist">
							<b>리뷰</b>
							<form action="/review/write" method="post" id="review_write" enctype='multipart/form-data'>
								<input type=hidden value="${mapdto.place_id}" name="place_id">
								<div class="review_comment">
									<c:choose>
										<c:when test="${not empty sessionScope.loginInfo.id}">
											<div class="writer">
												<b>${sessionScope.loginInfo.id}</b>님
											</div>
											<div contenteditable="true" class="input_content" id="editable"></div>
											<input type="text" name="content" style="display: none;"
												id="review_content">
											<div class="filebox">
												<label for="imgFile"><i class="fas fa-images"></i></label>
												<input type="file" id="imgFile" name="imgFile" accept="image/*">
											</div>
											<div class="rating">
												<input type="radio" id="star5" name="rating" value="5" /><label
													for="star5" title="매우 만족스러움">5 stars</label> <input
													type="radio" id="star4" name="rating" value="4" /><label
													for="star4" title="조금 만족스러움">4 stars</label> <input
													type="radio" id="star3" name="rating" value="3" /><label
													for="star3" title="보통이에요">3 stars</label> <input type="radio"
													id="star2" name="rating" value="2" /><label for="star2"
													title="조금 별로">2 stars</label> <input type="radio" id="star1"
													name="rating" value="1" /><label for="star1" title="매우 별로">1
													star</label>
											</div>
											<input type="text" name="parent_seq" style="display:none;" value="${parent_seq}">
											<input type=submit class="btn-sm btn-primary" value="작성">
										</c:when>
										<c:otherwise>
											<div style="font-size:10pt;">
												리뷰를 작성하려면 로그인하세요.
											</div>
										</c:otherwise>
									</c:choose>
								</div>
							</form>
							<c:forEach var="i" items="${reviewMap}" varStatus="status">
								<div class="review">
									<img src="/upload/${i.key.id}/${i.key.profile}" onError="this.src='/resources/img/no_img.png'" alt="" style="height:30px;width:30px;">
									<div class="raty">
										<c:if test="${i.key.rating eq 1}"><i class="fas fa-star"></i><i class="far fa-star"></i><i class="far fa-star"></i><i class="far fa-star"></i><i class="far fa-star"></i></c:if>
										<c:if test="${i.key.rating eq 2}"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="far fa-star"></i><i class="far fa-star"></i><i class="far fa-star"></i></c:if>
										<c:if test="${i.key.rating eq 3}"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="far fa-star"></i><i class="far fa-star"></i></c:if>
										<c:if test="${i.key.rating eq 4}"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="far fa-star"></i></c:if>
										<c:if test="${i.key.rating eq 5}"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i></c:if>
									</div>
									<div class="attachedImage">
										<c:if test="${not empty i.value}">
											<img src="/upload/files/${i.value.sysname}">
										</c:if>
									</div>
									<div class="content"><c:out value="${i.key.content}"></c:out></div>
									<div class="bottom">
										${i.key.id}<span class="bg_bar"></span>
										${i.key.sdate}
										<c:choose>
											<c:when test="${i.key.id eq 'unknown'}">
											</c:when>
											<c:otherwise>
												<c:if test="${i.key.id ne sessionScope.loginInfo.id}">
													<span class="bg_bar"></span>
													<button type="button" class="btn btn-primary report" onClick="reviewReport(${i.key.seq},'<c:out value="${i.key.content}"></c:out>','${i.key.id}')">신고</button>
												</c:if>
											</c:otherwise>
										</c:choose>
									</div>
								</div>
							</c:forEach>
						</div>
					</c:if>
				</div>
			</div>


		</div>
		<div id="map"></div>
		<c:if test="${sessionScope.loginInfo.id eq 'administrator'}">
			<div class="foodInsert text-center" data-toggle="tooltip" data-placement="left" title="미등록 장소 (음식점) 입력"><i class="fas fa-utensils"></i></div>
			<div class="cafeInsert text-center" data-toggle="tooltip" data-placement="left" title="미등록 장소 (카페) 입력"><i class="fas fa-coffee"></i></div>
		</c:if>
		
		<!-- 맛집 참가 modal -->
		<div class="modal fade" id="partyModal" tabindex="-1" role="dialog"
			aria-labelledby="exampleModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-lg modal-dialog-centered"
				role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="exampleModalLabel">
							<b></b>
						</h5>
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<table class="table">
							<tbody>
								<tr>
									<th scope="row">작성자</th>
									<td class="writer"></td>
								</tr>
								<tr>
									<td class="badges" colspan="2">
										<div>
											<span class="badge badge-pill badge-light drinking"></span>
										</div>
										<div>
											<span class="badge badge-pill badge-light gender"></span>
										</div>
										<div class="age"></div>
									</td>
								</tr>
								<tr>
									<th scope="row">상호명</th>
									<td class="parent_name"></td>
									<th scope="row">위치</th>
									<td class="parent_address"></td>
								</tr>
								<tr>
									<th scope="row">모임날짜</th>
									<td class="meetdate"></td>
								</tr>
								<tr>
									<th scope="row">인원</th>
									<td class="count"></td>
								</tr>
								<tr>
									<th scope="row" colspan="2">소개말</th>
								</tr>
								<tr>
									<td scope="row" class="content" colspan="2"></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="modal-footer">
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>


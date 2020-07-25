<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!-- 태훈 스크립트 -->
<script type="text/javascript" src='/resources/js/party_content_include.js?ver=6'></script>
<!-- 태훈 스크립트 -->
<!-- SNS Share js start -->
<script src='/resources/js/sns_share.js'></script>
<!-- SNS Share js end -->
<div class="container-fluid section">
	<div class="container">
		<div class="row mb-3">
			<div class="col-sm-12 mt-3">
            <h2 class="party_headline">
					# <c:out value='${con.seq}' /> / <c:out value='${con.title}' />
					<input type="hidden" id="party_seq" value="${con.seq }">
					<input type="hidden" id="party_time" value="${con.sTime }">
					<input type="hidden" id="party_writer" value="${con.writer }">
					<input type="hidden" id="party_title" value="${con.title }">
					<input type="hidden" id="sns_share_title"
						value=" /' ${con.parent_name} /' 에 같이 가자!!! - 맛집동행찾기서비스 맛집갔다갈래">
					<c:choose>
						<c:when test="${con.status  eq '1'}">
							<span class="badge badge-success">멤버 모집중</span>

							<c:if
								test="${con.writer ne sessionScope.loginInfo.id && partyParticipantCheck eq false && ((sessionScope.loginInfo.gender eq 1 &&  con.gender eq 'm') || (sessionScope.loginInfo.gender eq 2 && con.gender eq'f') || con.gender eq 'a')}">
								<div class="row  pt-1 mt-2">
									<div class="col-12 alert alert-success">
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
								test="${con.writer ne sessionScope.loginInfo.nickname && partyParticipantCheck eq false  }">
								<div class="row mt-2 ">
									<div class="col-12 alert alert-danger">
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
						<div class="col-12 alert alert-success">
							<h6 class="">
								<strong>정상모임</strong> : 신고건수 ${con.report} 건
							</h6>
						</div>
					</div>
				</c:if>
				<c:if test="${con.report > 0 && con.report < 5 }">
					<div class="row  pt-1 mt-2">
						<div class="col-12 alert alert-warning">
							<h6 class="">
								<strong>요주의모임</strong> : 신고건수 ${con.report} 건
							</h6>
						</div>
					</div>
				</c:if>
				<c:if test="${con.report >= 5}">
					<div class="row  pt-1 mt-2">
						<div class="col-12 alert alert-danger">
							<h6 class="">
								<strong>위험모임</strong> : 신고건수 ${con.report} 건
							</h6>
						</div>
					</div>
				</c:if>
			</div>
         <div class="col-sm-12">
         	작성자 : ${con.writer} <a onclick="send_msg()">
         	<img src="/resources/img/send_message.png"></a>
         </div>
      	</div>
		<div class="row">
			<div class="col-sm-6">
				<div class="row mb-1">
					<div class="col-sm-3 party-titlelabel">상호명</div>
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
					<div class="col-sm-3 party-titlelabel">모임날짜</div>
					<div class="col-lg-9">${con.sDate }</div>
				</div>
				<div class="row mb-1">
					<div class="col-sm-3 party-titlelabel">시간</div>
					<div class="col-sm-9" id="time"></div>
				</div>

				<div class="row mb-1">
					<div class="col-sm-3 party-titlelabel">인원</div>
					<div class="col-sm-9">
						<span class="badge badge-success">현재 참여자</span> ${party.count} 명 <span
							class="badge badge-warning">총 모집인원</span> ${con.count} 명
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
							<c:when test="${con.drinking  eq '1'}">음주OK</c:when>
							<c:when test="${con.drinking  eq '0'}">음주NO</c:when>
						</c:choose>
					</div>
				</div>
				<div class="row mb-1">
					<div class="col-sm-3 mb-3 party-titlelabel">소개</div>
					<div class="col-sm-9 party-contenttext-area party_content">
						<c:out value='${con.content}'/>
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
						<img src="${con.imgaddr}" id="img">
					</div>
				</div>
			</div>
		</div>
		<div class="row mb-1 mt-2 mb-3"></div>
		<div class="row mb-2">
			<div class="col-12" align="center">
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
							<button type="button" id="toExitParty" class="btn btn-primary">모임
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
         <div class="col-12 mb-5" align="right">
            <c:if test="${con.writer eq sessionScope.loginInfo.nickname }">
               <button type="button" id="partyModify" class="btn btn-warning">수정하기</button>
               <button type="button" id="partyDelete" class="btn btn-danger">삭제하기</button>
            </c:if>
            <c:if test="${con.writer ne sessionScope.loginInfo.nickname }">
            	<button type="button" id="partyReport" class="btn btn-info">신고하기</button>
            </c:if>
				<button type="button" class="btn btn-secondary" data-dismiss="modal">목록으로</button>
			</div>
		</div>
	</div>
</div>
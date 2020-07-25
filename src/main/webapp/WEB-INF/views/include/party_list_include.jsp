<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<style>
#endSearch{
	padding-top:30px;
	text-align:center;
	font-size:2em;
	line-height:100%;
}
.tt{
	overflow: hidden;
  	text-overflow: ellipsis;
  	white-space: nowrap;
}
</style>
<c:choose>
	<c:when test="${empty list}">
		<div class="col-12" id="endSearch">
			<span>검색 된 내용이 없습니다.</span>
		</div>
	</c:when>
	<c:otherwise>
		<!-- start column -->
		<c:forEach var="partyList" items="${list}">
			<div class="col-lg-4 col-md-4 col-sm-12 adb">
				<div class="party-list">
					<div class="party-img">
					<a href="#" onclick="return false;" style="cursor:default">
					<div class="featImgWrap">
						<div class="cropping">
							<img src="${partyList.imgaddr}" id ="img">
						</div>
					</div>
					 </a>
						<div class="toContent text-center">
							<ul>
								<li><a class="myBtn" style="cursor:pointer">상세 보기</a></li>
								<li style="display: none">
									<input type="hidden"class="party_seq" value="${partyList.seq}">
								</li>
							</ul>
						</div>
					</div>
					<div class="party-content text-center">
						<h3 class="tt"><c:out value="${partyList.title }"/></h3>
						<br>
						<h5 class="card-subtitle mb-2 text-muted tt">${partyList.parent_name }</h5>
						<p class="tt">
							날짜 : ${partyList.sDate}<br> 지역 : ${partyList.parent_address }
						</p>
					</div>
				</div>
			</div>
		</c:forEach>
		<!-- End column -->
	</c:otherwise>
</c:choose>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<% request.setCharacterEncoding("utf-8"); %>
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
<title>Admin-신고관리</title>
<script>
$(function(){
	$(".reportView").on("click",function(){
		console.log($(this).siblings(".seq").val());
		$("#refuse").css("display", "none");
		$("#accept").css("display", "none");
		$.ajax({
			url:"/admin/admin_reportContent",
			dataType:"JSON",
			data:{seq:$(this).siblings(".seq").val()}
		}).done(function(resp){
			console.log(resp);
			$(".modal-title").html("#" + resp.seq);
			$(".modal-body #report_id").html(resp.report_id);
			$(".modal-body #id").html(resp.id);
			if(resp.category == 0){
				$(".modal-body #category").html("리뷰 신고 (code:0)");	
			}else if(resp.category == 1){
				$(".modal-body #category").html("모임 모집 글 신고 (code:1)");
			}
			else{
				$(".modal-body #category").html("회원 신고 (code:2)");
			}
			
			$(".modal-body #report_date").html(resp.report_date);
			$(".modal-body #title").html(resp.title);
			$(".modal-body #content").html(resp.content);	
			if(resp.status == 0){
				$(".modal-body #status").html("접수 대기");
				$("#refuse").css("display", "block");
				$("#accept").css("display", "block");
			}
			else if(resp.status == 1){
				$(".modal-body #status").html("접수 완료");
			}
			else{
				$(".modal-body #status").html("다른 사람의 신고로 처리 된 신고");
			}
			$(".modal-body #status").html();
			$(".modal-body #parent_seq").html(resp.parent_seq);
			$("#mymodal").modal();
		})
	});
	
	$("#refuse").on("click",function(){
		var check = confirm("회원의 신고를 반려 처리합니다.\n처리하시겠습니까?");
		if(check){			
			var seq = $(".modal-title").html().substring(1);
			var parent_seq = $("#parent_seq").html();
			var category = $("#category").html().substr(-2,1);
			console.log(seq);
			$.ajax({
				url:"/report/reportRefuse",	
				data:{seq : seq , parent_seq : parent_seq , category : category}
			}).done(function(resp){
				if(resp==1){
					alert("정상적으로 처리 되었습니다.");
					location.reload();
				}else{
					alert("이미 삭재 된 글 / 회원 입니다.");
					location.reload();
				}
			});
		}
	});
	
	$("#accept").on("click",function(){
		var check = confirm("회원의 신고를 승인합니다. 리뷰 혹은 모임 글의 경우 자동 삭제 처리 됩니다.\n처리하시겠습니까?");
		if(check){
			var seq = $(".modal-title").html().substring(1);
			var parent_seq = $("#parent_seq").html();
			var category = $("#category").html().substr(-2,1);
			var report_id = $("#report_id").html();

			console.log(seq);
			$.ajax({
				url:"/report/reportAccept",	
				data:{seq : seq , parent_seq : parent_seq , category : category , report_id : report_id}
			}).done(function(resp){
				if(resp==1){
					alert("정상적으로 처리 되었습니다.");
					location.reload();
				}else{
					alert("이미 삭재 된 글 / 회원 입니다.");
					location.reload();
				}
			});	
		}
	});
	
});


</script>
<style>
#refuse , #accept {
	display:none;
}
th , td{
	padding-bottom:15px;
}
.title{
	width:50%;
}
.ready{
	color:red;
}
</style>
</head>
<body>
	<div class="container-fluid mx-0 px-0">
		<div class="row mx-0">
			<div class="col-2 mx-0 px-0"><jsp:include
					page="/WEB-INF/views/include/admin_sidebar.jsp" /></div>
			<div class="col-10 px-5">
				<div class="row">
					<div class="col-12 col-sm-12 mt-3">
						<h2 class="admin-h2">회원 신고 관리</h2>
					</div>
				</div>
				<div class="row">
					<div class="col-12 col-sm-12 mt-3">
						<button type="button" class="btn btn-warning" onclick="location.href='Category_list?cpage=1&category=0'">리뷰</button>
						<button type="button" class="btn btn-warning" onclick="location.href='Category_list?cpage=1&category=1'">모임글</button>
						<button type="button" class="btn btn-dark" onclick="location.href='Category_list?cpage=1&category=2'">회원</button>
						<button type="button" class="btn btn-dark" onclick="location.href='toAdmin_report'">전체</button>
						
					</div>
				</div>
				<div class="row">
					<div class="col-12  col-sm-12">
						<div class="row">
							<div class="table-responsive">
								<table class="table border-bottom border-dark">
									<thead class="thead-dark">
										<tr>
											<th scope="col" class="text-center">번호</th>
											<th scope="col">신고 분류</th>
											<th scope="col">신고자 닉네임</th>
											<th scope="col">신고 닉네임</th>
											<th scope="col">신고일</th>
											<th scope="col">접수 상태</th>
											<th scope="col">접수</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="i" items="${list}" varStatus="status">
											<tr>
												<th scope="row" class="text-center">
													${status.index}													
												</th>
												
												<c:choose>
													<c:when test="${i.category eq 0}">
														<td>리뷰 신고</td>
													</c:when>
													<c:when test="${i.category eq 1}">
														<td>모임 글 신고</td>
													</c:when>
													<c:otherwise>
														<td>회원 신고</td>
													</c:otherwise>
												</c:choose>																							
												<td>${i.id}</td>	
												<td>${i.report_id}</td>
												<td>${i.sdate}</td>
												<c:choose>
													<c:when test="${i.status == 0}">
														<td class="ready">접수 대기</td>
													</c:when>
													<c:otherwise>
														<td>접수 완료</td>
													</c:otherwise>
												</c:choose>
												<td>
													<button type="button"  class="btn btn-secondary reportView" data-toggle="modal" data-target="#staticBackdrop">
  														상세 내용
													</button>
													<input type="hidden" class="seq" value="${i.seq }">
												</td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
							</div>
						</div>
						<div class="row mb-5">
							<div class="col-2"></div>
							<div class="col-8">
								<nav aria-label="Page navigation example">
									<ul class="pagination justify-content-center">
										${navi}
									</ul>
								</nav>
							</div>
							<div class="modal fade" id="mymodal"
								data-backdrop="static" data-keyboard="false" tabindex="-1"
								role="dialog" aria-labelledby="staticBackdropLabel"
								aria-hidden="true">
								<div class="modal-dialog modal-dialog-centered modal-lg" >
									<div class="modal-content">
										<!-- header -->
										<div class="modal-header">
											<h5 class="modal-title" id="staticBackdropLabel">
												
											</h5>
											<button type="button" class="close" data-dismiss="modal"
												aria-label="Close">
												<span aria-hidden="true">&times;</span>
											</button>
										</div>
										<!-- body -->
										<div class="modal-body">
											<table>
												<tbody>
													<tr>
														<th scope="row" class="title">신고 대상 글번호</th>
														<td id="parent_seq"></td>
													</tr>
													<tr>
														<th scope="row" class="title">신고일</th>
														<td id="report_date"></td>
													</tr>
													<tr>
														<th scope="row" class="title">신고 대상 아이디</th>
														<td id="report_id"></td>
													</tr>
													<tr>
														<th scope="row" class="title">신고자 아이디</th>
														<td id="id"></td>
													</tr>
													<tr>
														<th scope="row" class="title">신고 유형</th>
														<td id="category"></td>
													</tr>
													<tr>
														<th scope="row" class="title">제목  / 상호</th>
														<td id="title"></td>
													</tr>
													<tr>
														<th scope="row" class="title">신고 내용</th>
														<td id="content"></td>
													</tr>
													<tr>
														<th scope="row" class="title">처리 상태</th>
														<td id="status"></td>
													</tr>
												</tbody>
											</table>
										</div>
										<!-- footer -->
										<div class="modal-footer">
											<button type="button" class="btn btn-secondary"
												data-dismiss="modal">닫기</button>
											<button type="button" id="accept" class="btn btn-danger">접수</button>
											<button type="button" id="refuse" class="btn btn-warning">반려</button>
										</div>
									</div>
								</div>
							</div>

						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>



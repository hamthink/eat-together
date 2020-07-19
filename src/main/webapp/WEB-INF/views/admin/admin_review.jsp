<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>
<link rel="stylesheet" type="text/css" href="/resources/css/admin.css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.13.1/css/all.css">
<script>
	$(function(){
		$(".sr-only").parent().css("background-color","#ffa500");
		$(".viewDetailReview").on("click",function(){
			$.ajax({
				url:"/admin/viewDetailReview",
				dataType:"JSON",
				data:{seq:$(this).find(".admin_text.seq").html()}
			}).done(function(resp){
				console.log(resp);
				$(".modal-body #parent_name").html(resp.name);
				$(".modal-body #writer").html(resp.id);
				$(".modal-body #content").html(resp.content);
				$(".modal-body #write_date").html(resp.write_date);
				$(".modal-body #seq").html(resp.seq);
				$(".modal-body #report").html(resp.report);
			})
		})
		$("#checkAll").click(function() {
			if ($("#checkAll").is(":checked")) {
				$(".checkboxes").prop("checked", true);
			} else {
				$(".checkboxes").prop("checked", false);
			}
		});
		$(".checkboxes").click(function() {
			var checklength = $("input:checkbox[name='checkbox[]']").length;
			console.log(checklength);
			console
					.log($("input:checkbox[name='checkbox[]']:checked").length);

			if ($("input:checkbox[name='checkbox[]']:checked").length == checklength) {
				$("#checkAll").prop("checked", true);
			} else {
				$("#checkAll").prop("checked", false);
			}
		});
		$("#toOut").on("click", function() {
			var result = confirm("정말로 리뷰를 삭제시키겠습니까?");
			if (result) {
				var arr = [];
				$(".checkboxes:checked").each(function(i) {
					arr.push($(this).val());
				})
				$.ajax({
					url : "/review/reviewDeleteProc",
					type : "post",
					data : {
						seqs : JSON.stringify(arr)
					}
				}).done(function(resp) {
					if(resp>0){
					alert("선택한 리뷰가 삭제 처리 되었습니다.");
					$(this).closest("tr").remove();
						location.reload();
					}else{
						alert("리뷰 삭제에 실패하였습니다.");
					}
				})
			}
		})
	})
</script>
<title>Admin-리뷰관리</title>
<style>
	#toOut{background-color:#fcbb42;border:1px solid #ffa500;}
	#toOut:hover{background-color:#ffa500;}
	.page-item{margin-left:2px;margin-right:2px;}
    .page-link{
    	line-height:1 !important;
    	border-radius:20px !important;
    	border:0px;
    	color:#ff9900;
    }
    .page-item:hover .page-link{color:black;}
    .sr-only{background-color:#ffa500;}
    .viewDetailReview:hover{cursor:pointer;background-color:#dee2e6;}
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
						<h2 class="admin-h2">리뷰관리</h2>
					</div>
				</div>
				<div class="row">
					<div class="col-12 col-sm-12 mt-3">
						<form action="/admin/sortReview" method="post">
							<div class="row form-group position-relative">
								<div class="col-10 p-0">
									<label for="selectByOption">조건정렬</label> <select
										class="form-control" id="selectByOption" name=option>
										<option value="write_date">작성일</option>
										<option value="report">신고 수</option>
									</select>
								</div>
								<div class="col-2 p-0 b-0 position-absolute" style="bottom:0px;right:0px;">
									<button type="submit" class="btn btn-dark align-middle" style="width:100%;">검색</button>
								</div>
							</div>
						</form>
					</div>
				</div>
				<div class="row">
					<div class="col-12  col-sm-12">
						<div class="row">
							<div class="table-responsive">
								<table class="table border-bottom border-dark">
									<thead class="thead-dark">
										<tr>
											<th scope="col"></th>
											<th scope="col">맛집</th>
											<th scope="col">작성자</th>
											<th scope="col">내용</th>
											<th scope="col">작성일</th>
											<th scope="col">신고 수</th>
											<th scope="col" class=" text-center">
												<label><input type="checkbox" id="checkAll" class="checkAll"><span class="label label-primary admin_text"></span>
												</label>
												<button class="btn-sm btn-danger admin_text" id="toOut">삭제</button>
											</th>
										</tr>
									</thead>
									<tbody>
										<c:choose>
											<c:when test="${empty rlist}">
												<tr>
													<td colspan=12 class="review_text">리뷰가 존재하지 않습니다.</td>
												</tr>
											</c:when>
											<c:when test="${not empty rlist}">
												<form action="/review/reviewDeleteProc" id="reviewDeleteProc" method="post">
												<c:forEach var="i" items="${rlist}">
													<tr class="viewDetailReview">
														<td class="admin_text seq" data-toggle="modal" data-target="#exampleModal">${i.seq}</td>
														<td class="admin_text" data-toggle="modal" data-target="#exampleModal">${i.name}</td>
														<td class="admin_text id" data-toggle="modal" data-target="#exampleModal">${i.id}</td>
														<td class="admin_text" data-toggle="modal" data-target="#exampleModal">
															<div  style="max-width:100px;max-height:100px;white-space: nowrap;overflow: hidden; text-overflow: ellipsis;">
															  ${i.content}
															</div>
														</td>
														<td class="admin_text" data-toggle="modal" data-target="#exampleModal">${i.sdate}</td>
														<td class="admin_text" data-toggle="modal" data-target="#exampleModal">${i.report}</td>
														<td class="admin_text text-center"><input type="checkbox" name="checkbox[]" value="${i.seq}" class="checkboxes"></td>
													</tr>
												</c:forEach>
												</form>
											</c:when>
										</c:choose>
									</tbody>
								</table>
							</div>
						</div>
						<div class="row mb-5">
							<div class="col-3"></div>
							<div class="col-6">
								<nav aria-label="Page navigation example">
									<ul class="pagination justify-content-center">
										<c:if test="${not empty navi}">
									  		${navi}
									  	</c:if>
									</ul>
								</nav>
							</div>
							<div class="col-3 text-right">
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- modal -->
		<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog"
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
						  <thead>
						    <tr>
						      <th scope="col">번호</th>
						      <th scope="col" id="seq"></th>
						    </tr>
						  </thead>
						  <tbody>
						    <tr>
						      <th scope="row">맛집</th>
						      <td id="parent_name"></td>
						    </tr>
						    <tr>
						      <th scope="row">작성자</th>
						      <td id="writer"></td>
						    </tr>
						    <tr>
						      <th scope="row">작성일</th>
						      <td id="write_date"></td>
						    </tr>
						    <tr>
						      <th scope="row">내용</th>
						      <td id="content"></td>
						    </tr>
						    <tr>
						      <th scope="row">누적 신고 수</th>
						      <td id="report"></td>
						    </tr>
						  </tbody>
						</table>
					</div>
			        <div class="modal-footer">
				        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
			        </div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>



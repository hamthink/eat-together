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
	#toOut{background-color:#fcbb42;border:1px solid #ffa500;}
	#toOut:hover{background-color:#ffa500;}
	.page-item{margin-left:2px;margin-right:2px;}
    .page-link{
    	line-height:1 !important;
    	border-radius:20px !important;
    	border:0px;
    	color:#ff9900;
    }
    .page-item.active .page-link {
	    background-color: #ffa500;
	}
    .page-item:hover .page-link{color:black;}
    .sr-only{background-color:#ffa500;}
</style>
<script>

function toDelete(seq){
	var ask = confirm("정말 삭제하시겠습니까?");
	if(ask){
		location.href="/party/partydeleteByAdmin?seq="+seq;
	}
};
$(function(){
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
		var result = confirm("선택한 모임글을 정말로 삭제시키겠습니까?");
		if (result) {
			var arr = [];
			$(".checkboxes:checked").each(function(i) {
				arr.push($(this).val());
			})
			$.ajax({
				url : "/party/partyDeleteCheckList",
				type : "post",
				data : {
					seqs : JSON.stringify(arr)
				}
			}).done(function(resp) {
				if(resp>0){
					alert("선택한 모임글이 삭제 처리 되었습니다.");
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
					<div class="col-12 col-sm-12 mt-3">
						<form action="/admin/partyByOption" method="post">
							<div class="row form-group position-relative">
								<div class="col-10 p-0">
									<label for="partyByOption">조건정렬</label> <select
										class="form-control" id="partyByOption" name=option>
										<option value="meetdate">모임일</option>
										<option value="report">신고수</option>
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
											<th scope="col" class="text-center"></th>

											<th scope="col">글제목</th>
											<th scope="col">모임장소</th>
											<th scope="col">작성자</th>
											<th scope="col">모임일</th>
											<th scope="col">모임상태</th>
											<th scope="col">신고수</th>
											<th scope="col" class="text-center">
												<label><input type="checkbox" id="checkAll" class="checkAll"><span class="label label-primary admin_text"></span>
												</label>
											<button class="btn-sm btn-danger admin_text" id="toOut">삭제</button></th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="i" items="${list}" varStatus="status">
											<tr>
												<th scope="row" class="text-center">${i.seq}</th>

												<td  style="max-width: 150px;" class="text-truncate"><a href="/admin/admin_party_content?seq=${i.seq}" style="max-width: 150px;">${i.title}</a>


												</td>
												<td>${i.parent_name }</td>
												<td>${i.writer}</td>
												<td>${i.sDate }</td>
												<td class="text-center"><c:if test="${i.status eq 1}">진행중</c:if> <c:if
														test="${i.status eq 0}">종료</c:if></td>
												<td>${i.report}</td>
												<td class=" text-center"><input type="checkbox" name="checkbox[]" value="${i.seq}" class="checkboxes"></td>
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
									<ul class="pagination justify-content-center">${navi}</ul>
								</nav>
							</div>
							<div class="col-2"></div>
						</div>









					</div>
				</div>

			</div>

		</div>

	</div>
</body>
</html>



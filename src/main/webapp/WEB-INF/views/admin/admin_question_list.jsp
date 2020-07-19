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
<title>Admin-1:1문의</title>
<script sre="https://code.jquery.com/jquery-3.5.1.js"></script>
</head>
<script>
	function AnswerPopUp(msg_seq, msg_sender) {
		var name = msg_seq;
		var option = "width=500,height=550 location=no";
		window.open("questionAnswer?msg_seq=" + msg_seq + "&msg_sender="
				+ msg_sender, msg_sender, option);
	}
	function AdminQuestionDel(msg_seq) {
		location.href = "AdminQuestionDel?msg_seq=" + msg_seq;
		alert("삭제성공");
	}
	$(function() {
		$(document).on("click", ".answer", function() {
			var some = $(this).attr("id").split(":");
			console.log(some);
			AnswerPopUp(some[0], some[1]);
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
			var result = confirm("정말로 쪽지를 삭제시키겠습니까?");
			if (result) {
				var arr = [];
				$(".checkboxes:checked").each(function(i) {
					arr.push($(this).val());
				})
				$.ajax({
					url : "/msg/msgSenderDel",
					type : "post",
					data : {
						msg_seqs : JSON.stringify(arr)
					}
				}).done(function(resp) {
					console.log(resp);
					if(resp>0){
					alert("선택한 쪽지가 삭제 처리 되었습니다.");
					$(this).closest("tr").remove();
						location.reload();
					}else{
						alert("쪽지 삭제에 실패하였습니다.");
					}
				})
			}
		})
	})
</script>
<body>
	<div class="container-fluid mx-0 px-0">
		<div class="row mx-0">

			<div class="col-2 mx-0 px-0"><jsp:include
					page="/WEB-INF/views/include/admin_sidebar.jsp" /></div>

			<div class="col-10 px-5">

				<div class="row">
					<div class="col-12 col-sm-12 mt-3">
						<h2 class="admin-h2">1:1문의</h2>
					</div>
				</div>
				<div class="row">
					<div class="col-12 col-sm-12 mt-3">
						<form action="/admin/AdminQuestion_list" method="post">
							<div class="row form-group position-relative">
								<div class="col-10 p-0">
									<label for="selectByOption">조건정렬</label> <select
										class="form-control" id="selectByOption" name=optionQ>
										<option value="all">전체</option>
										<option value="noAnswer">답변대기</option>
										<option value="yesAnswer">답변완료</option>
									</select>
								</div>
								<div class="col-2 p-0 b-0 position-absolute"
									style="bottom: 0px; right: -5px;">
									<button type="submit" class="btn btn-dark align-middle">검색</button>
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
											<th scope="col">문의번호</th>
											<th scope="col">아이디</th>
											<th scope="col">제목</th>
											<th scope="col">날짜</th>
											<th scope="col">답변여부</th>
											<th scope="col"><label><input type="checkbox"
													id="checkAll" class="checkAll"><span
													class="label label-primary admin_text"></span> </label>
												<button class="btn-sm btn-danger admin_text" id="toOut">삭제</button></th>
										</tr>
									</thead>
									<tbody>
										<c:choose>
											<c:when test="${empty list}">
												<tr>
													<td colspan=12 class="myinfo_text">문의가 존재하지 않습니다.</td>
												</tr>
											</c:when>
											<c:when test="${!empty list}">
												<c:forEach var="i" items="${list}">
													<tr>
														<td class="admin_text">${i.msg_seq}</td>
														<td class="admin_text">${i.msg_sender}</td>
														<td class="admin_text"><c:choose>
																<c:when test="${i.msg_view==0||i.msg_view==1}">
																	<a href="questionViewAdmin?msg_seq=${i.msg_seq}">${i.msg_title}</a>
																</c:when>
																<c:otherwise>
																	<a href="questionViewAdmin?msg_seq=${i.msg_seq}"
																		style="color: black;">${i.msg_title}</a>
																</c:otherwise>
															</c:choose></td>
														<td class="admin_text">${i.date}</td>
														<c:choose>
															<c:when test="${i.msg_view==0||i.msg_view==1}">
																<td class="admin_text" style="color: red;">답변대기</td>
															</c:when>
															<c:otherwise>
																<td class="admin_text">답변완료</td>
															</c:otherwise>
														</c:choose>

														<c:choose>
															<c:when test="${i.receiver_del==1}">
																<td>삭제  <input type="checkbox" name="checkbox[]"
																	value="${i.msg_seq}" class="checkboxes"></td>
															</c:when>
															<c:otherwise>
																<td class="myinfo_text">삭제불가</td>
															</c:otherwise>
														</c:choose>


													</tr>
												</c:forEach>
											</c:when>
										</c:choose>
									</tbody>
								</table>
							</div>
						</div>
						<div class="row mb-5">
							<div class="col-12">${navi}</div>

						</div>
					</div>
				</div>

			</div>

		</div>

	</div>



</body>
</html>
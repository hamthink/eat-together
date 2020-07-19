<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
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
	href="/resources/css/index-css.css">
<!-- header,footer용 css  -->
<!-- ******************* -->
<!-- mypage용 css  -->
<link rel="stylesheet" type="text/css" href="/resources/css/mypage.css">
<!-- ******************* -->
<!-- menubar용 css  -->
<link rel="stylesheet" type="text/css" href="/resources/css/menubar.css">
<!-- ******************* -->
<script>
	function questionWritePopUp() {
		var name = "qpop.test";
		var option = "width=500,height=550 location=no";
		window.open("question_write", name, option);
	}
	function questionViewPopUp(msg_seq) {
		var name = msg_seq;
		var option = "width=500,height=550 location=no"
		window.open("questionView?msg_seq=" + msg_seq, name, option);
	}
	function msgReceiverDel(msg_seq) {
		location.href = "QuestionReceiverDel?msg_seq=" + msg_seq;
		alert("삭제성공");
	}
	$(
			function() {
				$("#checkAll").click(function() {
					if ($("#checkAll").is(":checked")) {
						$(".checkboxes").prop("checked", true);
					} else {
						$(".checkboxes").prop("checked", false);
					}
				});
				$(".checkboxes")
						.click(
								function() {
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
							url : "/msg/msgReceiverDel",
							type : "post",
							data : {
								msg_seqs : JSON.stringify(arr)
							}
						}).done(function(resp) {
							console.log(resp);
							if (resp > 0) {
								alert("선택한 쪽지가 삭제 처리 되었습니다.");
								$(this).closest("tr").remove();
								location.reload();
							} else {
								alert("쪽지 삭제에 실패하였습니다.");
							}
						})
					}
				})
			})
</script>
<meta charset="UTF-8">
<title>내 정보</title>
</head>
<body>
	<!-- ******************* -->
	<!-- header  -->
	<jsp:include page="/WEB-INF/views/include/header.jsp" />
	<!-- header  -->
	<!-- ******************* -->


	<div id=mypage-container>
		<jsp:include page="/WEB-INF/views/include/menubar.jsp" />
		<div id=contents>
			<table class="table" id="mypage_table">
				<thead class="thead-dark">
					<tr>
						<th scope="col" colspan=12>1:1문의</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th scope="col">제목</th>
						<th scope="col">날짜</th>
						<th scope="col" style="text-align: center;">답변여부</th>
						<th scope="col"><label><input type="checkbox"
								id="checkAll" class="checkAll"><span
								class="label label-primary admin_text"></span> </label>
							<button class="btn-sm btn-danger admin_text" id="toOut">삭제</button>
						</th>
					</tr>
					<c:if test="${empty list}">
						<tr>
							<td scope="col" colspan=12 align="center">1:1 문의가 없습니다.</td>
						</tr>
					</c:if>
					<c:forEach var="i" items="${list}" varStatus="status">
						<tr>
							<td><a href="javascript:questionViewPopUp(${i.msg_seq})"
								style="color: black">${i.msg_title}</a></td>
							<td>${i.date}</td>
							<td align="center"><c:choose>
									<c:when test="${i.msg_view==0||i.msg_view==1}">
										답변중	 	
								 	</c:when>
									<c:otherwise>
										<button type="button" class="btn btn-warning"
											id="answerQuestion"
											onclick="location.href='javascript:questionViewPopUp(${i.msg_view})'">답변완료</button>
									</c:otherwise>
								</c:choose></td>
							<td><input type="checkbox" name="checkbox[]"
								value="${i.msg_seq}" class="checkboxes"></td>
						</tr>
					</c:forEach>
					<tr>
						<td scope="col" colspan=12>${navi}</td>
					</tr>
					<tr>
						<td scope="col" colspan=12 align="center">
							<button type="button" class="btn btn-warning" id="question">문의하기</button>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>


	<!-- ******************* -->
	<!-- footer  -->
	<div id=footer-container>
		<jsp:include page="/WEB-INF/views/include/footer.jsp" />
	</div>
	<!-- footer  -->
	<!-- ******************* -->
	<script>
		$("#question").on("click", function() {
			location.href = "javascript:questionWritePopUp()";
		})
	</script>
</body>
</html>
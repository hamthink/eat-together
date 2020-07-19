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
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
#msg_title>a {
	color: black;
}
</style>

<script>
	$(function() {
		$("#list_admin").on("click", function() {
			location.href = "msg_list_admin";
		})
		$("#list_sender").on("click", function() {
			location.href = "msg_list_sender";
		})
		$("#list_receiver").on("click", function() {
			location.href = "msg_list_receiver";
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
					url : "/msg/msgReceiverDel",
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

		$(".newMsg").on("click", function() {
			$.ajax({
				url : 'newmsg',
				dataType : 'json',
				success : function(resp) {
					console.log(resp);
					location.reload();
				}
			})
		})
	})
</script>


<script>
	function msgReceiverDel(msg_seq) {
		location.href = "msgReceiverDel?msg_seq=" + msg_seq;
		alert("삭제성공");
	}
	function msgWritePopUp() {
		var name = "popup.test";
		var option = "width=500,height=550 location=no,scrollbar=no,menubar=no,top=200,left=600";
		window.open("msgWrite", name, option);
	}
	function msgViewPopUp(msg_seq) {
		var name = msg_seq;
		var option = "width=500,height=440 location=no";
		window.open("msgView?msg_seq=" + msg_seq, msg_seq, option);
	}
</script>
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
						<th scope="col" colspan=12>MyNote</th>
					</tr>
				</thead>
				<tbody>

					<tr>
						<td scope="col" colspan=12 align="left">
							<button type="button" class="btn btn-outline-danger"
								id="list_admin">
								관리자
								<c:if test="${newMsgByAdmin!=0}">
									<span class="badge badge-danger">N</span>
								</c:if>
							</button>
							<button type="button" class="btn btn-outline-warning"
								id="list_sender">
								받은 쪽지함
								<c:if test="${newMsgByNick!=0}">
									<span class="badge badge-danger">N</span>
								</c:if>
							</button>
							<button type="button" class="btn btn-outline-warning"
								id="list_receiver">보낸쪽지함</button>
							<button type="button" class="btn btn-warning" id="writeMsg">쪽지보내기</button>
						</td>
					</tr>
					<tr align="center">
						<th scope="col" colspan=2>읽음</th>
						<th scope="col" colspan=2>보낸사람</th>
						<th scope="col" colspan=4>제목</th>
						<th scope="col" colspan=2>날짜</th>
						<th scope="col" colspan=2><label><input
								type="checkbox" id="checkAll" class="checkAll"><span
								class="label label-primary admin_text"></span> </label>
							<button class="btn-sm btn-danger admin_text" id="toOut">삭제</button>
						</th>
					</tr>
					<tr>
						<c:if test="${empty list}">
							<td scope="col" colspan=12 align="center">쪽지가 없습니다.</td>
						</c:if>
					</tr>

					<c:forEach var="i" items="${list}" varStatus="status">
						<tr align="center">
							<td colspan=2><c:choose>
									<c:when test="${i.msg_view==0}">
										<svg width="1em" height="1em" viewBox="0 0 16 16"
											class="bi bi-envelope" fill="currentColor"
											xmlns="http://www.w3.org/2000/svg"> <path
												fill-rule="evenodd"
												d="M0 4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V4zm2-1a1 1 0 0 0-1 1v.217l7 4.2 7-4.2V4a1 1 0 0 0-1-1H2zm13 2.383l-4.758 2.855L15 11.114v-5.73zm-.034 6.878L9.271 8.82 8 9.583 6.728 8.82l-5.694 3.44A1 1 0 0 0 2 13h12a1 1 0 0 0 .966-.739zM1 11.114l4.758-2.876L1 5.383v5.73z" />
</svg>
									</c:when>
									<c:when test="${i.msg_view==1}">
										<svg width="1em" height="1em" viewBox="0 0 16 16"
											class="bi bi-envelope-open" fill="currentColor"
											xmlns="http://www.w3.org/2000/svg">
  <path fill-rule="evenodd"
												d="M8.47 1.318a1 1 0 0 0-.94 0l-6 3.2A1 1 0 0 0 1 5.4v.818l5.724 3.465L8 8.917l1.276.766L15 6.218V5.4a1 1 0 0 0-.53-.882l-6-3.2zM15 7.388l-4.754 2.877L15 13.117v-5.73zm-.035 6.874L8 10.083l-6.965 4.18A1 1 0 0 0 2 15h12a1 1 0 0 0 .965-.738zM1 13.117l4.754-2.852L1 7.387v5.73zM7.059.435a2 2 0 0 1 1.882 0l6 3.2A2 2 0 0 1 16 5.4V14a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V5.4a2 2 0 0 1 1.059-1.765l6-3.2z" />
</svg>
									</c:when>
								</c:choose></td>


							<td colspan=2><c:choose>
									<c:when test="${i.msg_sender eq 'administrator'}">관리자</c:when>
									<c:otherwise>${i.msg_sender}</c:otherwise>
								</c:choose></td>
							<td colspan=4 class="msg_title" id="msg_title"><a
								href="javascript:msgViewPopUp(${i.msg_seq})" class="newMsg"><c:out
										value="${i.msg_title}" /></a></td>
							<td colspan=2>${i.date}</td>
							<td colspan=2><input type="checkbox" name="checkbox[]"
								value="${i.msg_seq}" class="checkboxes"></td>
						</tr>
					</c:forEach>

					<tr>
						<td scope="col" colspan=12 align="center">${navi}</td>
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
		$("#writeMsg").on("click", function() {
			location.href = "javascript:msgWritePopUp()";
		})
	</script>
</body>
</html>
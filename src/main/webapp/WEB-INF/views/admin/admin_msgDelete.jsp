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
<script>
function saveMsg(msg_seq) {
	location.href = "saveMsg?msg_seq=" + msg_seq;
	alert("복구성공");
}
</script>
<title>Admin-쪽지관리</title>

</head>
<body>
	<div class="container-fluid mx-0 px-0">
		<div class="row mx-0">

			<div class="col-2 mx-0 px-0"><jsp:include
					page="/WEB-INF/views/include/admin_sidebar.jsp" /></div>
			<div class="col-10 px-5">
				<div class="row">
					<div class="col-12 col-sm-12 mt-3">
						<h2 class="admin-h2">쪽지 관리</h2>
					</div>
				</div>
				<hr>
				<div class="row">
					<div class="col" colspan=10>
						<button type="button" class="btn btn-danger" onclick="location.href='toAdmin_msg'">공지</button>					
						<button type="button" class="btn btn-warning" onclick="location.href='admin_msgSend?ascpage=1'">받은 쪽지함</button>
						<button type="button" class="btn btn-warning" onclick="location.href='admin_msgReceive?arcpage=1'">보낸 쪽지함</button>
						<button type="button" class="btn btn-dark" onclick="location.href='admin_SendDel?sdcpage=1'">삭제된 쪽지함</button>
						<button type="button" class="btn btn-dark" onclick="location.href='admin_msgDelete?gcpage=1'">휴지통</button>
					</div>
				</div>
				<hr>
					<div class="row">
						<div class="col-12  col-sm-12">
							<div class="row">
								<div class="table-responsive">

									<table class="table border-bottom border-dark">
										<thead class="thead-dark">
											<tr>
												<th scope="col" colspan=12 class="text-center">받은 쪽지</th>
											</tr>


										</thead>
										<tbody>
											<tr align="center">
												<th scope="col" colspan=2>#</th>
												<th scope="col" colspan=2>보낸사람</th>
												<th scope="col" colspan=2>받는사람</th>
												<th scope="col" colspan=2>제목</th>
												<th scope="col" colspan=2>날짜</th>
												<th scope="col" colspan=2>삭제</th>
											</tr>
											<tr>
												<c:if test="${empty list}">
													<td scope="col" colspan=12 align="center">쪽지가 없습니다.</td>
												</c:if>
											</tr>

											<c:forEach var="i" items="${list}" varStatus="status">
												<tr align="center">
													<td colspan=2>${i.msg_seq}</td>
													<td colspan=2>${i.msg_sender}</td>
													<td colspan=2><c:choose>
															<c:when test="${i.msg_receiver eq 'administrator'}">관리자</c:when>
															<c:otherwise>${i.msg_receiver}</c:otherwise>
														</c:choose></td>
													<td colspan=2 class="msg_title" id="msg_title"><c:out value="${i.msg_title}" /></td>
													<td colspan=2>${i.date}</td>
													<td colspan=2>
														<button type="button" class="btn btn-outline-dark"
															onclick="location.href='javascript:saveMsg(${i.msg_seq})'">복구</button>
													</td>
												</tr>
											</c:forEach>
											<tr><td scope="col" colspan=12 align="right"><button type="button" id="empty" class="btn btn-dark" >비우기</button></td></tr>
											<tr>
												<td scope="col" colspan=12 align="center">${navi}</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>

						</div>
					</div>
			</div>

		</div>
<script>
	$("#empty").on("click",function(){
		var result =confirm("휴지통을 비우시겠습니까?");
		console.log(result);
		if(result){
			location.href="admin_EmptyDeleteMsg";
			return true;
		}
	})
</script>
	</div>
</body>
</html>



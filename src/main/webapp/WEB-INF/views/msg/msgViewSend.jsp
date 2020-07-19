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
<link rel="stylesheet" type="text/css" href="/resources/css/msg.css">
<!-- google font end-->
<meta charset="UTF-8">

<title>Insert title here</title>
</head>
<body>
	<div class="container">
		<table class="table">
			<thead>
				<tr class="table" id="orange">
					<th scope="col" colspan=12>${msgView.msg_receiver}님에게 보낸쪽지</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td scope="col" colspan=12>받는 사람 : ${msgView.msg_receiver}
						(${msgView.msg_date})</td>
				</tr>
				<tr>
					<th scope="col" colspan=3 style="width: 20%">제목</th>
					<td scope="col" colspan=6 style="width: 50%"><c:out
							value="${msgView.msg_title}"></c:out></td>
					<td scope="col" colspan=3 rowspan=2 style="width: 30%"><img
						src="/upload/${mdto.id}/${mdto.sysname}" style="width: 100%">
					</td>
				</tr>
				<tr>
					<td scope="col" colspan=9 rowspan=1 >
						<div style="width: 305px; padding: 10px; word-break: break-all; resize: none; overflow-y:auto;  height: 200px;"><c:out value="${msgView.msg_text}"></c:out></div>
					</td>
				</tr>
			</tbody>
		</table>

		<div class="row" align="center">
			<div class="col-12" align="center">
               <button type="button" id="close" class="btn btn-light">닫기</button>
			</div>
		</div>
	</div>
	<script>
		$("#close").on("click", function() {
			window.close();
		})
	</script>
</body>
</html>

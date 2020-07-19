<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
<script src="https://ssl.pstatic.net/static.gn/js/clickcrD.js"
	id="gnb_clickcrD" charset="utf-8"></script>

<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css"
	integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
<style>
	.text{
	background-color:white;
	width: 100%; padding: 10px;
	word-break: keep-all; 
	height: 180px; resize: none;
	option:readonly,disabled;
	}
</style>
<script>

</script>
<title>1:1문의내역</title>
</head>
<body>
	<div id=container>
		<table class="table">
			<thead class="thead-dark">
				<tr>
					<th scope="col" colspan=12>1:1문의</th>
				</tr>
			</thead>
			<tbody>
				<tr align="center">
					<th scope="col">제목</th>
					<th scope="col"><c:out value="${qdto.msg_title}"></c:out></th>
				</tr>

				<tr align="center">
					<th scope="col">받는사람</th>
					<th scope="col">관리자</th>
				</tr>
				<tr align="center">
					<th scope="col" colspan=12>내용</th>
				</tr>
				<tr align="center">
					<td scope="col" colspan=12><textarea class="text" id="msg_text"  name="msg_text" readonly disabled><c:out value="${qdto.msg_text}"></c:out></textarea></td>
				</tr>
				<tr align="center">
					<td scope="col" colspan=12>
					<button type="button" id="close" class="btn btn-secondary">닫기</button>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
<script>
	$("#close").on("click",function(){
		window.close();
	})
</script>
</body>
</html>
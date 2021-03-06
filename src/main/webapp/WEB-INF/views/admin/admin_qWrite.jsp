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
<script>
$(function(){
	$("#container").find("#msg_text").keyup(function(){
		var word = $(this).val();
		var wordSize = word.length;
		console.log(wordSize);
		if(wordSize <=2000){
			$(".current").text(wordSize);
		}else{
			word=word.substr(0,2000);
			$(".current").text(word.length);
			$(this).val(word);
			alert("쪽지는 2000자 이하로 작성해주세요");
		}
	})
})
</script>
<title>Insert title here</title>
</head>
<body>
	<div id=container>
	<form action="questionAnswerSend" method="post">
		<table class="table">
			<thead class="thead-dark">
				<tr>
					<th scope="col" colspan=12>1:1문의</th>
				</tr>
			</thead>
			<tbody>
				<tr align="center">
					<th scope="col">제목<input type="hidden" name="msg_view" id="msg_view"></th>
					<th scope="col">[1:1문의]답변입니다.</th>
				</tr>

				<tr align="center">
					<th scope="col">받는사람</th>
					<th scope="col">${qdto.msg_sender}<input type="hidden" name="msg_receiver" id="msg_receiver"></th>
				</tr>
				<tr align="center">
					<th scope="col" colspan=12>내용</th>
				</tr>
				<tr align="center">
					<td scope="col" colspan=12><textarea placeholder="내용을 입력해주세요"
							style="width: 100%; padding: 10px; word-break: keep-all; height: 180px;" id="msg_text"  name="msg_text"></textarea></td>
				</tr>
				<tr>

					<td scope="col" colspan=12 id="wordcheck" align="right"><span
						class="current">0</span>/2000자</td>
				</tr>
				<tr align="center">
					<td scope="col" colspan=12>
					<button type="submit" id=submit class="btn btn-secondary">문의하기</button>
					</td>
				</tr>
			</tbody>
		</table>
		</form>
	</div>
	<script>
		$("#submit").on("click",function(){
			var where = ${qdto.msg_seq};
			console.log(where);
			var msg_receiver = ${qdto.msg_sender};
			$("#msg_view").val(where);
			$("#msg_receiver").val(msg_receiver);
			console.log(where);
			console.log(msg_receiver);
		})
	</script>
</body>
</html>
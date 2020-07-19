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
<link rel="stylesheet" type="text/css" href="/resources/css/msg.css">
<title>쪽지보내기</title>

<script>
	$(function() {
		$(".container").find("#msg_text").keyup(function() {
			var word = $(this).val();
			var wordSize = word.length;
			console.log(wordSize);
			if (wordSize <= 1000) {
				$(".current").text(wordSize);
			} else {
				word = word.substr(0, 1000);
				$(".current").text(word.length);
				$(this).val(word);
				alert("쪽지는 1000자 이하로 작성해주세요");
			}
		})

		$("#idcheck").on("click", function() {
			var id = $("#msg_receiver").val();
			$.ajax({
				url : '../member/isIdAvailable?id=' + id,
				dataType : 'json',
				success : function(resp) {
					console.log(resp);
					if (resp == false) {
						alert("존재하는 회원입니다.");
						$("#msg_receiver").val(id);
						$("#msg_receiver").attr("readonly", true);
						$("#msg_receiver").css("background-color", "DarkGray");
						$("#idcheck").val("확인됨");
					} else {
						alert("존재하지 않는 회원입니다.");
						$("#msg_receiver").val("");
						$("#idcheck").val("확인");
					}
				}
			})
		});
	})
</script>
</head>

<body>
	<div class="container" align="center">
		<form action="msgSend" method="post">
			<table class="table">
				<thead>
					<tr class="table" align="center" id="orange">
						<th scope="col" colspan=12>쪽지보내기</th>
					</tr>
				</thead>
				<tbody>
					<tr align="center">
						<th scope="col" colspan=4>닉네임</th>
						<td scope="col" colspan=8>
							<div id="msg_receiver">${msg_receiver}</div> <input type="hidden"
							id="hidden" name="msg_receiver">
					</tr>
					<tr align="center">
						<th scope="col" colspan=4>제목</th>
						<td scope="col" colspan=8><input type="text" name="msg_title"
							id="msg_title" style="width: 100%;" maxlength="15"
							placeholder="최대 15자"></td>
					</tr>
					<tr align="center">
						<th scope="col" colspan=12>내용</th>
					</tr>
					<tr align="center">
						<td scope="col" colspan=12><textarea placeholder="내용을 입력해주세요"
								style="width: 100%; padding: 10px; word-break: keep-all; height: 180px; resize: none;"
								name="msg_text" id="msg_text"></textarea></td>
					</tr>
					<tr>
						<td scope="col" colspan=12 id="wordcheck" align="right"><span
							class="current">0</span>/1000자</td>
					</tr>
					<tr align="center">
						<td scope="col" colspan=12>
							<button type="submit" id="submit" class="btn btn-orange">보내기</button>
							<button type="button" id="close" class="btn btn-light">취소</button>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
	<script>
		$("#close").on("click", function() {
			window.close();
		})

		$("#submit").on("click", function() {
			var msg_receiver = $("#msg_receiver").text();
			console.log(msg_receiver);
			$("#hidden").val(msg_receiver);

			if ($("#msg_title").val() != "") {
				if ($("#msg_text").val() != "") {
					return true;
				} else {
					alert("내용을 입력하세요");
					return false;
				}
			} else {
				alert("제목을 입력하세요");
				return false;
			}

		})
	</script>
</body>
</html>

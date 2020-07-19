<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<!-- BootStrap4 -->
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>
<!-- BootStrap4 End-->

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.form/4.3.0/jquery.form.js"></script>
<link rel="stylesheet" type="text/css" href="/resources/css/msg.css">
<title>Report</title>
<script type="text/javascript">
var option ={
		url:"/memreport/memReport",
		type:"post",
		success:function(result){
			console.log("result : "+result);
			if(result ==1){
				alert("신고가 정상적으로 처리되었습니다.");
				window.close();
			}
			else{
				alert("에러 발생. 관리자에게 문의하십시요.");
				window.close();
			}
			
		},
		error:function(result){
			alert("에러 발생. 관리자에게 문의하십시요.");
			window.close();
		}
}
$(function(){
	$(".container").find("#content").keyup(function() {
		var word = $(this).val();
		var wordSize = word.length;
		console.log(wordSize);
		if (wordSize <= 2000) {
			$(".current").text(wordSize);
		} else {
			word = word.substr(0, 2000);
			$(".current").text(word.length);
			$(this).val(word);
			alert("쪽지는 2000자 이하로 작성해주세요");
		}
	})

	$("#idcheck").on("click",function() {
		var nickname = $("#report_id").val();
		console.log(nickname);
		if (nickname == "") {
			alert("닉네임을 입력해 주세요.");
		} else if (nickname == "${nick }") {
			alert("본인은 신고할 수 없습니다.");
			$("#report_id").val("");			
		} else {
			$.ajax({
				url : '../memreport/duplCheck?nickname='+ nickname,
				dataType : 'json',
				success : function(resp) {
					console.log(resp);
					if (resp == 0) {
						alert(nickname+ "님을 신고합니다.");
						$("#report_id").val(nickname);
						$("#report_id").attr("readonly", true);
						$("#report_id").css("background-color","DarkGray");
						$("#idcheck").val("확인됨");
					} else if (resp == 1) {
						alert("무분별한 신고를 막기 위해 한 회원 당 한번만 가능합니다.\n다시 한번 확인해주세요.");
						$("#report_id").val("");
					} else if (resp == 3) {
						alert("관리자는 신고할 수 없습니다..\n다시 한번 확인해주세요.");
						$("#report_id").val("");
					} else {
						alert("존재하지 않는 회원입니다.\n다시 한번 확인해주세요.");
						$("#report_id").val("");
					}
				}
			})
		}
	});
});
	
$(function(){
	$(document).on('submit','#reportForm',function(e){
		if($("#report_id").val() == ""){
			alert("신고자 아이디 중복검사를 해주세요.");
			return false;
		}
		else if($("#title").val() == ""){
			alert("제목을 입력해 주세요.");
			return false;
		}else if($("#content").val() == ""){
			alert("내용을 입력해 주세요.");
			return false;
		}else{
			e.preventDefault();
			$(this).ajaxSubmit(option);		
			console.log("ajax 성공");
			return false;
		}

	});
	
	$("#close").on("click",function(){
		window.close();
	});
});
</script>
<style>
</style>
</head>
<body>
	<div class="container" align="center">
		<!-- <form id="report" action="/memreport/insertReport" method="post"> -->
		<form id="reportForm" onsubmit="return false;">
			<table class="table">
				<thead>
					<tr class="table" align="center" id="orange">
						<td class="bg-danger" scope="col" colspan=12>신고하기</td>
					</tr>
				</thead>
				<tbody>
					<tr align="center">
						<th scope="col" colspan=12>신고자 닉네임 : ${nick } 
						<input type="hidden" name="id" value="${nick }"></th>
					</tr>
					<tr align="center">
						<th scope="col" colspan=4>신고 닉네임</th>
						<td scope="col" colspan=8>
							<input type="text" name="report_id" id="report_id"> 
							<input type="button" id="idcheck" value="확인">
						</td>
					</tr>
					<tr align="center">
						<th scope="col" colspan=4>제목</th>
						<td scope="col" colspan=8>
							<input type="text" name="title"id="title">
						</td>
					</tr>
					<tr align="center">
						<th scope="col" colspan=12>신고사유</th>
					</tr>
					<tr align="center">
						<td scope="col" colspan=12>
							<textarea placeholder="신고 사유를 최대한 자세히 작성해 주세요." style="width: 100%; padding: 10px; word-break: keep-all; height: 180px; resize: none;"
								name="content" id="content"></textarea>
						</td>
					</tr>
					<tr>
						<td scope="col" colspan=12 id="wordcheck" align="right"><span
							class="current">0</span>/2000자</td>
					</tr>
					<tr align="center">
						<td scope="col" colspan=12>
							<button type="submit" id="report" class="btn btn-danger">보내기</button>
							<button type="button" id="close" class="btn btn-light">취소</button>
					</tr>
				</tbody>
			</table>
		</form>

	</div>
</body>
</html>
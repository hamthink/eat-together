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
<title>Admin-쪽지관리</title>
<script>
$(function(){
	$(".table-responsive").find("#msg_text").keyup(function(){
		var word = $(this).val();
		var wordSize = word.length;
		console.log(wordSize);
		if(wordSize <=1000){
			$(".current").text(wordSize);
		}else{
			word=word.substr(0,1000);
			$(".current").text(word.length);
			$(this).val(word);
			alert("전체쪽지는 1000자 이하로 작성해주세요");
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
						<h2 class="admin-h2">쪽지 관리</h2>
					</div>
				</div>
				<hr>
				<div class="row">
					<div class="col">
						<button type="button" class="btn btn-danger" onclick="location.href='toAdmin_msg'">공지</button>					
						<button type="button" class="btn btn-warning" onclick="location.href='admin_msgSend?ascpage=1'">받은 쪽지함</button>
						<button type="button" class="btn btn-warning" onclick="location.href='admin_msgReceive?arcpage=1'">보낸 쪽지함</button>
						<button type="button" class="btn btn-dark" onclick="location.href='admin_msgDelete?gcpage=1'">삭제된 쪽지함</button>
					</div>
				</div>
				<hr>
				<form action="msgNotice" method="post">
					<div class="row">
						<div class="col-12  col-sm-12">
							<div class="row">
								<div class="table-responsive">

									<table class="table border-bottom border-dark">
										<thead class="thead-dark">
											<tr>
												<th scope="col" colspan=12 class="text-center">전체 쪽지</th>
											</tr>
											
											
										</thead>
										<tbody>
											<tr align="center">
												<th scope="col" colspan=4>제목</th>
												<th scope="col" colspan=8>[공지] <input type="text"
													id="msg_title" name="msg_title" style="width: 80%;" maxlength="15"></th>
											</tr>

											<tr align="center">
												<th scope="col" colspan=6>받는사람</th>
												<th scope="col" colspan=6>전체 회원</th>
											</tr>
											<tr align="center">
												<th scope="col" colspan=12>내용</th>
											</tr>
											<tr align="center">
												<td scope="col" colspan=12><textarea
														placeholder="내용을 입력해주세요"
														style="width: 100%; padding: 10px; word-break: keep-all; height: 150px; resize: none;"
														id="msg_text" name="msg_text"></textarea></td>
											</tr>
											<tr>

												<td scope="col" colspan=12 id="wordcheck" align="right"><span
													class="current">0</span>/2000자</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="row">
								<div class="col-12" align="center">
									<c:if test="${sessionScope.loginInfo.id eq 'administrator'}">
										<button class="btn btn-warning" id="submit" type="submit">보내기</button>
									</c:if>
								</div>
							</div>

						</div>
					</div>
				</form>
			</div>

		</div>
<script>
	$("#submit").on("click",function(){
		if($("#msg_title").val()!=""){
			if($("#msg_text").val()!=""){
				var result = prompt("전체 회원에게 보내는 쪽지입니다.한번더 확인하고 확인을 입력해주세요");
				if(result=="확인"){
					return true;	
				}else{
					alert("확인을 입력해주세요");
					return false;
				}
			}else{
				alert("내용을 입력해주세요");
				return false;
			}
		}else{
			alert("제목을 입력해주세요");
			return false;
		}
	})

</script>
	</div>
</body>
</html>



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
				alert("답변은 1000자 이하로 작성해주세요");
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
					<div class="col-12  col-sm-12">
						<div class="row">
							<div class="table-responsive">
								<form action="questionAnswerSend" method="post">
									<table class="table">
										<thead class="thead-dark">
											<tr>
												<th scope="col" colspan=12>1:1문의</th>
											</tr>
										</thead>
										<tbody>
											<tr align="center">
												<th scope="col" colspan=6>제목</th>
												<th scope="col" colspan=6><c:out value="${qdto.msg_title}"></c:out></th>
											</tr>

											<tr align="center">
												<th scope="col" colspan=6>작성자</th>
												<th scope="col" colspan=6>${qdto.msg_sender}</th>
											</tr>

											<tr align="center">
												<th scope="col" colspan=6>작성 날짜</th>
												<th scope="col" colspan=6>${qdto.date}</th>
											</tr>
											<tr>
												<td scope="col" colspan=12><div
														style="width: 100%; padding: 10px; word-break: break-all; resize: none; overflow-y:auto;  height: 150px;"><c:out value="${qdto.msg_text}"></c:out></div></td>
											</tr>


											<c:choose>
												<c:when test="${qdto.msg_view==0||qdto.msg_view==1}">
													<thead class="table-danger">
														<tr>
															<th scope="col" colspan=12>답변 하기</th>
														</tr>
													</thead>
													<tr align="center">
														<th scope="col" colspan=4>제목<input type="hidden"
															name="msg_view" id="msg_view" value="${qdto.msg_seq}"></th>
														<th scope="col" colspan=8>[1:1답변]<input type="text"
															id="msg_title" name="msg_title" style="width: 80%;" maxlength="15"></th>
													</tr>

													<tr align="center">
														<th scope="col" colspan=6>받는사람</th>
														<th scope="col" colspan=6>${qdto.msg_sender}<input
															type="hidden" name="msg_receiver" id="msg_receiver"
															value="${qdto.msg_sender}"></th>
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
															class="current">0</span>/1000자</td>
													</tr>
													<tr align="center">
														<td scope="col" colspan=12>
															<button type="submit" id=submit class="btn btn-secondary">답변하기</button>

														</td>
													</tr>
												</c:when>
												<c:otherwise>
													<thead class="thead-dark">
														<tr>
															<th scope="col" colspan=12>답변 완료</th>
														</tr>
													</thead>
													<tr align="center">
														<th scope="col" colspan=6>제목</th>
														<th scope="col" colspan=6><c:out value="${qadto.msg_title}"></c:out></th>
													</tr>

													<tr align="center">
														<th scope="col" colspan=6>작성자</th>
														<th scope="col" colspan=6>${qadto.msg_sender}</th>
													</tr>

													<tr align="center">
														<th scope="col" colspan=6>작성 날짜</th>
														<th scope="col" colspan=6>${qadto.date}</th>
													</tr>
													<tr>
														<td scope="col" colspan=12><div
																style="width: 100%; padding: 10px; word-break: break-all; resize: none; overflow-y:auto;  height: 150px;"><c:out value="${qadto.msg_text}"></c:out></div></td>
													</tr>

												</c:otherwise>
											</c:choose>
										</tbody>
									</table>
								</form>
							</div>
						</div>

					</div>
				</div>

			</div>

		</div>

	</div>
	<script>
	$("#submit").on("click",function(){
		if($("#msg_title").val()!=""){
			if($("#msg_text").val()!=""){
				return true;
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

</body>
</html>
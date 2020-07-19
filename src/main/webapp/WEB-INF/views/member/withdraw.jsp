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
<!-- header,footer용 css  -->
<link rel="stylesheet" type="text/css"
	href="/resources/css/index-css.css">
<!-- header,footer용 css  -->
<!-- ******************* -->
<!-- withdraw용 css -->
<link rel="stylesheet" type="text/css"
	href="/resources/css/withdraw.css">
<!-- ************* -->
<meta charset="UTF-8">
<title>회원탈퇴</title>
</head>
<body>
	<!-- ******************* -->
	<!-- header  -->
	<jsp:include page="/WEB-INF/views/include/header.jsp" />
	<!-- header  -->
	<!-- ******************* -->


	<div class="jumbotron jumbotron-fluid">
		<div class="container withdraw_text">
			<h1 class="display-4" class="withdraw_text">${loginInfo.id}
				님이 참여한 모임으로<br>수많은 새로운 맛집 친구를 만났습니다.
			</h1>
			<br>
			<p class="lead withdraw_text">
				앞으로 더 많은 맛집 친구들이 기다리고 있습니다.<br>정말로 탈퇴하시겠습니까?
			</p>
		</div>
	</div>
	<br>
	<div class="contents_container withdraw_text">
		<form action="/member/withdrawProc" id=withdrawProc method="post">
			<fieldset class="withdraw_text">
				<legend>회원탈퇴</legend>
				<div class="withdraw_text">
					<label for="account_email" class="withdraw_text">이메일</label> <input
						type="text" class="form-control" id="account_email"
						name="account_email" placeholder="ex)eat-together@naver.com">
					<input type=button id=mail value="인증하기" class="btn btn-warning">
					<button type="button" class="btn btn-dark withdraw_text" id="back">되돌아가기</button>
					<br> <br>
					<div id=mail_div style="display: none;">
						인증번호 : <input type=text id=mail_text>
						<button type=button id=mail_accept class="btn btn-light">인증</button>
					</div>
					<div id=withdraw_result style="display: none;"><br>
						<button type=button class="btn btn-light withdraw_text"
							id="withdrawBtn">탈퇴하기</button><br>
					</div>
				</div>

			</fieldset>

		</form>
	</div>

	<script>
	window.onload = function() {
		// by 지은, 카카오톡으로 로그인한 경우 accoun_email인증이 안되었기 때문에 mypage로 이동시킨다_20200717	
		if ("${loginInfo.account_email}" == "need@eat-together.com") {
			alert("이메일 인증 및 개인정보 수정 후 사이트를 이용해주시길 바랍니다.");
			location.replace("/member/mypage_myinfo");
		}

		var code;
		//메일 인증 
		//by 지은, 이메일 인증 ajax의 중복호출을 방지하기 위해서 전송상태를 표시한다_20200716
		$("#mail").on("click", function() {
			if ($("#account_email").val() == "") {
				alert("이메일을 입력해주십시오.");
				$("#account_email").focus();
			} else {
				$.ajax({
					url : "/mail/mailSendingForOut",
					type : "post",
					data : {
						account_email : $("#account_email").val()
					}
				}).done(function(resp) {
					code = resp;
					console.log(code);
					if (code != "") {
						alert("인증메일이 발송되었습니다.");
						$("#mail_div").css("display", "block");

					}else {
						
						alert("이메일 정보가 일치하지 않습니다");
						$("#mail_text").val("");
						$("#mail_text").focus();
					}

				}).fail(function(jqXHR, textStatus, errorThrown) {
					serrorFunction();
				});
			}
		})

		$("#mail_accept").on("click", function() {
			if ($("#mail_text").val() == code) {
				$("#mail_text").css("color", "blue");
				$("#mail_text").val("인증에 성공하였습니다.");
				$("#mail_text").attr("readonly", true);
				
				$("#withdraw_result").css("display", "block");
			} else if ($("#mail_text").val == "") {
				alert("인증문자열을 입력해주세요.");
				$("#mail_text").focus();
			} else if ($("#mail_text") != code) {
				alert("인증문자열이 일치하지 않습니다.");
				$("#mail_text").val("");
				$("#mail_text").focus();

			}
		})
		//account_email regex
		$("#account_email")
				.focusout(
						function() {
							if ($("#account_email").val() != "") {
								var account_email = $("#account_email").val();
								var account_emailregex = /[a-zA-Z0-9]*@[a-zA-Z0-9]*[.]{1}[a-zA-Z]{2,3}|([.]{1}[a-zA-Z]{2,3})$/;
								if (!account_emailregex.test(account_email)) {
									$("#account_email").val("");
									alert("유효한 이메일을 입력해주세요.");
									$("#account_email").focus();
								}
							}
						})
		$("#back").on("click", function() {
			location.replace("/member/mypage_myinfo");
		})

		$("#withdrawBtn").on("click", function() {
			var result = confirm("정말로 탈퇴하시겠습니까?");
			if (result) {
				alert("그동안 감사했습니다.\nLet's eat together again!");
				$("#withdrawProc").submit();
			} else {
				return false;
			}
		})
	}
	</script>


	<!-- ******************* -->
	<!-- footer  -->
	<div id=footer-container>
		<jsp:include page="/WEB-INF/views/include/footer.jsp" />
	</div>
	<!-- footer  -->
	<!-- ******************* -->
</body>
</html>
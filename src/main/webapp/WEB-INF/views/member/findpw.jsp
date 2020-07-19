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

<!-- findpw css  -->
<link rel="stylesheet" type="text/css" href="/resources/css/findpw.css">
<!-- ******************* -->
<meta charset="UTF-8">
<meta charset="UTF-8">
<title>비밀번호 찾기</title>


</head>
<body>
	<fieldset class="findpw_text">
		<legend>비밀번호 찾기</legend>
		<div class="findpw_text">
			<label for="id" class="signup_text">아이디</label> <input type="text"
				class="form-control" id="id" name="id" placeholder="영문+숫자 4~10글자">
			<label for="account_email" class="findpw_text">이메일</label> <input
				type="text" class="form-control" id="account_email"
				name="account_email" placeholder="ex)eat-together@naver.com">
			<input type=button id=mail value="인증하기" class="btn btn-warning"><br>

			<!--by지은, #mail 인증하기 버튼 클릭시 display:block으로 생성되는 div_20200707 -->
			<div id=mail_div style="display: none;">
				인증번호 : <input type=text id=mail_text>
				<button type=button id=mail_accept class="btn btn-light">인증</button>
			</div>
			<!-- by지은, 인증하기에 성공하면 생성되는 div_20200709 -->
			<div id=findpw_result style="display: none;">
				<form id="editPwForm" action="editPwProc">
					<div class="article container">
						<div class="editpw_text">
							<label for="pw" class="editpw_text">비밀번호</label> <input
								type="password" class="form-control" id="pw" name="pw"
								placeholder="특수문자+숫자+영문 6~12글자">
						</div>
						<div class="editpw_text">
							<label for="pw" class="editpw_text">비밀번호 확인</label> <input
								type="password" class="form-control" id="pwCorrection">
							<div id="pw_text" style="display: none;"></div>
						</div>
					</div>
					<button type="button" class="btn btn-warning" id="editPwBtn">
						수정하기</button>
					<button type=button class="btn btn-light" id="back"
						onClick="window.close()">되돌아가기</button>
				</form>
			</div>
		</div>
	</fieldset>

	<script>
		window.onload = function() {

			var code;
			//by지은, 비밀번호 수정하기 ajax로 처리한다. 왜냐하면 id 값을 받아와야 하기 때문에_20200709
			$("#editPwBtn").on("click", function() {
				if ($("#pw").val() == "") {
					alert("비밀번호를 입력해주세요.");
					return false;
				} else if ($("#pw_text").html() != "비밀번호가 일치합니다.") {
					alert("비밀번호 확인을 해주세요.");
					return false;
				} else {
					$.ajax({
						url : "/member/editPwProc",
						type : "post",
						dataType : "text",
						data : {
							id : $("#id").val(),
							pw : $("#pw").val()
						}
					}).done(function(resp) {
						if (resp == "success") {
							alert("비밀번호가 수정되었습니다.\n다시 로그인해주세요.");
							window.close();
						} else {
							alert("수정하려는 비밀번호가 기존과 일치합니다.");
							$("#pw").val("");
							$("#pw").focus();
						}

					})
				}

			})

			//pw regex
			$("#pw")
					.focusout(
							function() {
								var pw = $("#pw").val();
								var pwregex = /(?=.*\d{1,50})(?=.*[~`!@#$%\^&*()-+=]{1,50})(?=.*[a-zA-Z]{1,50}).{6,12}$/;
								if ($("#pw").val() != "") {
									if (!pwregex.test(pw)) {
										alert("비밀번호 조건을 확인하세요.");
										$("#pw").val("");
									}
								}
							})

			//pw 재확인
			$("#pwCorrection").focusin(function() {
				if ($("#pw").val() == "") {
					alert("비밀번호를 먼저 입력해주세요.");
					$("#pw").focus();
				} else {
					$("#pwCorrection").focusout(function() {
						if ($("#pwCorrection").val() != "") {
							if ($("#pw").val() != $("#pwCorrection").val()) {
								$("#pwCorrection").val("");
								alert("비밀번호가 일치하지 않습니다.");
								$("#pwCorrection").focus();
							} else {
								$("#pw_text").css("display", "block");
								$("#pw_text").css("color", "blue");
								$("#pw_text").html("비밀번호가 일치합니다.");
							}
						}
					})
				}
			})
			//account_email regex
			$("#account_email")
					.focusout(
							function() {
								if ($("#account_email").val() != "") {
									var account_email = $("#account_email")
											.val();
									var account_emailregex = /[a-zA-Z0-9]*@[a-zA-Z0-9]*[.]{1}[a-zA-Z]{2,3}|([.]{1}[a-zA-Z]{2,3})$/;
									if (!account_emailregex.test(account_email)) {
										$("#account_email").val("");
										alert("유효한 이메일을 입력해주세요.");
										$("#account_email").focus();
									}
								}
							})

			//메일 인증_resp값이 text이므로 dataType을 text로 수정해야 제대로 작동함_20200709
			$("#mail").on("click", function() {
				if ($("#account_email").val() == "" || $("#id").val() == "") {
					alert("아이디와 이메일을 모두 입력해주십시오.");
					$("#account_email").focus();
				} else {
					$.ajax({
						url : "/mail/mailSendingForPw",
						type : "post",
						dataType : "text",
						data : {
							id : $("#id").val(),
							account_email : $("#account_email").val()
						}
					}).done(function(resp) {
						code = resp;
						console.log(code);
						if (code != "") {
							alert("인증메일이 발송되었습니다.");
							$("#mail_div").css("display", "block");
						} else if (code == "") {
							alert("아이디 또는 이메일을 잘못 입력하였습니다.");
							$("#mail_text").val("");
							$("#mail_text").focus();
						}

					})
				}
			})

			$("#mail_accept").on("click", function() {
				if ($("#mail_text").val() == code) {
					$("#mail_text").attr("readonly", true);
					$("#mail_text").css("color", "blue");
					$("#mail_text").val("인증에 성공하였습니다.");

					$("#findpw_result").css("display", "block");
				} else if ($("#mail_text").val() == "") {
					alert("인증 문자열을 입력해주세요.");
					$("#mail_text").val("");
					$("#mail_text").focus();
				} else {
					alert("인증 문자열이 일치하지 않습니다.");
					$("#mail_text").val("");
					$("#mail_text").focus();
				}
			})
		}
	</script>
</body>
</html>
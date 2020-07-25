<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<script>
	alert("로그인 세션이 만료되었습니다.\n 다시 로그인해주세요!");
	location.href = "/member/loginview";
</script>
</body>
</html>
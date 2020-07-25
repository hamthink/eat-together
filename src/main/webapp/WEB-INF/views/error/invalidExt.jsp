<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>잘못된 확장자 입니다.</title>
<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
</head>
<body>
	<div style="display:none" id="url">${previousURL}</div>
	<script>
		alert("잘못된 확장자입니다.\njpeg, jpg, gif, bmp 확장자의 이미지만 첨부 가능합니다.");
		location.href = "/map/" + $("#url").text();
	</script>
</body>
</html> 
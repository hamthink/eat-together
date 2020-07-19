<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Party Full</title>
<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
</head>
<body>
<script>
		alert("모집할 수 있는 모임수를 초과하였습니다.\n계정당 모집중 상태의 모임은 5개로 제한됩니다.\n새로 모집하시려면 현재 활성화된 모임을 확인 후 정리해주세요.");
		location.href = "/party/selectByWriter?mcpage=1";
	</script>

</body>
</html>
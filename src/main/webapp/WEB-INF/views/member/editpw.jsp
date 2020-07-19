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

<!-- editpw css  -->
<link rel="stylesheet" type="text/css" href="/resources/css/editpw.css">
<!-- ******************* -->
<meta charset="UTF-8">
<title>비밀번호 수정</title>
</head>
<body>
   <form id="editPwForm" action="editPwProc">
      <div class="article container">
         <div class="editpw_text">
            <input type=hidden id="id" name="id" value="${loginInfo.id}">
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
      <button type="submit" class="btn btn-warning" id="editPwBtn">
         수정하기</button>
      <button type=button class="btn btn-light" id="back"
         onClick="window.close()">되돌아가기</button>
   </form>
   <script>
      window.onload = function() {
         
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
                  if (resp == "") {
                     alert("수정하려는 비밀번호가 기존과 일치합니다.");
                     window.close();

                  } else{
                     alert("비밀번호가 수정되었습니다.\n다시 로그인해주세요.");
                     window.close();
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
         
      }
      
   </script>
</body>
</html>
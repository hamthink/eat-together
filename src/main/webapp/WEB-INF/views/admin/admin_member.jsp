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
<title>Admin-회원관리</title>
<!-- admine용 css  -->
<link rel="stylesheet" type="text/css" href="/resources/css/admin.css?ver=1">
<!-- ******************* -->
<style>
	#toOut{background-color:#fcbb42;border:1px solid #ffa500;}
	#toOut:hover{background-color:#ffa500;}
	.page-item{margin-left:2px;margin-right:2px;}
    .page-link{
    	line-height:1 !important;
    	border-radius:20px !important;
    	border:0px;
    	color:#ff9900;
    }
    .page-item.active .page-link {
	    background-color: #ffa500;
	}
    .page-item:hover .page-link{color:black;}
    .sr-only{background-color:#ffa500;}
</style>
</head>
<body>
	<div class="container-fluid mx-0 px-0 admin_text">
		<div class="row mx-0">

			<div class="col-2 mx-0 px-0"><jsp:include
					page="/WEB-INF/views/include/admin_sidebar.jsp" /></div>
			<div class="col-10 px-5">
				<div class="row">
					<div class="col-12 col-sm-12 mt-3">
						<h2 class="admin-h2">회원관리</h2>
					</div>
				</div>
				<div class="row">
					<div class="col-12 col-sm-12 mt-3">
						<form action="/admin/searchByOption" method="post">
							<div class="form-group">
								<label for="selectByOption">조건정렬</label> <select
									class="form-control" id="selectByOptionn" name=option>
									<option value="join_date">가입일자</option>
									<option value="report_count">신고 수</option>
								</select><br>
								<button type="submit" class="btn btn-dark">검색</button>
							</div>
						</form>
					</div>
				</div>
				<div class="row">
					<div class="col-12  col-sm-12">
						<div class="row">
							<div class="table-responsive">
								<table class="table border-bottom border-dark">
									<thead class="thead-dark">
										<tr>
											<th scope="col">아이디</th>
											<th scope="col">닉네임</th>
											<th scope="col">생년월일</th>
											<th scope="col">성별</th>
											<th scope="col">이메일</th>
											<th scope="col">가입일자</th>
											<th scope="col">누적신고수</th>
											<th scope="col">탈퇴</th>
										</tr>
									</thead>
									<tbody>
										<c:choose>
											<c:when test="${empty mlist}">
												<tr>
													<td colspan=12 class="myinfo_text">가입한 회원이 존재하지 않습니다.</td>
												</tr>
											</c:when>
											<c:when test="${!empty mlist}">
												<form action="/admin/memberOutProc" id="memberOutProc"
													method="post">
													<c:forEach var="i" items="${mlist}">
														<tr>
															<td class="admin_text">${i.id}</td>
															<td class="admin_text">${i.nickname}</td>
															<td class="admin_text">${i.birth}</td>
															<td class="admin_text gender">${i.gender}</td>
															<td class="admin_text">${i.account_email}</td>
															<td class="admin_text">${i.sdate}</td>
															<td class="admin_text">${i.report_count}</td>
															<td class="admin_text"><input type="checkbox"
																name="checkbox[]" value="${i.id}" class="checkboxes"></td>
														</tr>
													</c:forEach>
												</form>
											</c:when>
										</c:choose>
									</tbody>
								</table>
							</div>
						</div>
						<div class="row mb-5">
							<div class="col-2"></div>
							<div class="col-6">${navi}</div>
							<div class="col-4">
								<c:if test="${sessionScope.loginInfo.id eq 'administrator'}">
									<button class="btn btn-danger admin_text" id="toOut">탈퇴</button>
									<label><input type="checkbox" id="checkAll"
										class="checkAll"> <span class="label label-primary admin_text">전체선택</span>
									</label>
								</c:if>
							</div>
						</div>
					</div>
				</div>

			</div>

		</div>

	</div>
	<script>
		//by 지은, 성별의 int 값을 jsp에서 남여로 출력하는 과정_202007020
		var gender = $(".gender").html();
		if (gender == 1) {
			$(".gender").html("남");
		} else if(gender == 2){
			$(".gender").html("여");
		}

		//by 지은, 탈퇴하고자 하는 회원의 id를 배열로 생성, ajax로 삭제처리한다_20200713
		$("#toOut").on("click", function() {
			var result = confirm("정말로 회원을 탈퇴시키겠습니까?");
			if (result) {
				var arr = [];
				$(".checkboxes:checked").each(function(i) {
					arr.push($(this).val());
				})
				$.ajax({
					url : "/admin/memberOutProc",
					type : "post",
					data : {
						ids : JSON.stringify(arr)
					}
				}).done(function(resp) {
					if(resp>0){
					alert("선택한 회원이 탈퇴 처리 되었습니다.");
					$(this).closest("tr").remove();
					location.reload();
					}else{
						alert("회원 탈퇴에 실패하였습니다.\n 관리자에게 문의하세요.");
					}
				})
			}

		})

		//by 지은, 성별의 int 값을 jsp에서 남여로 출력하는 과정_20200708
		var gender = $("#gender").val();
		if (gender == 1) {
			$("#gender_text").html("남");
		} else {
			$("#gender_text").html("여");
		}

		//by 지은, 전체선택 시 모든 회원 선택 가능_20200713
		$("#checkAll").click(function() {
			if ($("#checkAll").is(":checked")) {
				$(".checkboxes").prop("checked", true);
			} else {
				$(".checkboxes").prop("checked", false);
			}
		});

		// by 지은, 전체 선택 후 회원 선택 시 전체선택 해제_20200713
		$(".checkboxes")
				.click(
						function() {
							var checklength = $("input:checkbox[name='checkbox[]']").length;
							console.log(checklength);
							console
									.log($("input:checkbox[name='checkbox[]']:checked").length);

							if ($("input:checkbox[name='checkbox[]']:checked").length == checklength) {
								$("#checkAll").prop("checked", true);
							} else {
								$("#checkAll").prop("checked", false);
							}
						});
	</script>
</body>
</html>



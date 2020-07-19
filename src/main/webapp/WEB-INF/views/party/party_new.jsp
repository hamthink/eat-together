<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>모임 모집하기</title>
<!-- BootStrap4 -->
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script
	src="//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.js"></script>
<!-- BootStrap4 End-->

<!--  datetimepicekr CDN -->
<script type="text/javascript"
	src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.2/moment.min.js"></script>
<script type="text/javascript"
	src="https://cdnjs.cloudflare.com/ajax/libs/tempusdominus-bootstrap-4/5.0.1/js/tempusdominus-bootstrap-4.min.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/tempusdominus-bootstrap-4/5.0.1/css/tempusdominus-bootstrap-4.min.css" />
<link rel="stylesheet"
	href="https://netdna.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.css" />

<!-- google font -->
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100;300;400;500;700;900&display=swap"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css2?family=Black+Han+Sans&display=swap"
	rel="stylesheet">

<!-- google font end-->

<!-- ******************* -->
<!-- header,footer용 css  -->
<link rel="stylesheet" type="text/css"
	href="/resources/css/index-css.css">
<!-- header,footer용 css  -->
<!-- ******************* -->

<link rel="stylesheet" type="text/css"
	href="/resources/css/party-css.css?ver=25">
<link rel="stylesheet" type="text/css"
	href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<link rel="stylesheet"
	href="//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.css">
<script>
	// by 지은, 카카오톡으로 로그인한 경우 accoun_email인증이 안되었기 때문에 mypage로 이동시킨다_20200717	
	if ("${loginInfo.account_email}" == "need@eat-together.com") {
		alert("이메일 인증 및 개인정보 수정 후 사이트를 이용해주시길 바랍니다.");
		location.replace("/member/mypage_myinfo");
	}

	//유효성 - 미성년자 음주불가
	$("#drinking1").attr('disabled', true);
	$(function() {
		$("#age1").on("click", function() {
			if ($('input:checkbox[id=age1]').is(":checked") == true) {
				$("#drinking1").attr('disabled', true);
				$("#drinking1").prop("checked", false);
				$("#drinking2").prop("checked", true);
			} else {
				$("#drinking1").attr('disabled', false);
			}
		});
	});
	//유효성 - 미성년자 음주불가 끝
	/**
	 *  yyyyMMdd 포맷으로 반환
	 */
	function getFormatDate(date) {
		var year = date.getFullYear(); //yyyy
		var month = (1 + date.getMonth()); //M
		month = month >= 10 ? month : '0' + month; //month 두자리로 저장
		var day = date.getDate(); //d
		day = day >= 10 ? day : '0' + day; //day 두자리로 저장
		return year + '' + month + '' + day; //'-' 추가하여 yyyy-mm-dd 형태 생성 가능
	}
	$(function() {
		$("#toLogin").on("click",function(){
			location.href = "/member/loginview";
		});
		$("#toSignUp").on("click",function(){
			location.href = "/member/signup_check";
		});
		
		$("#party_title").on("change keyup paste", function() {
			var len = $(this).val();
			if (len.length > 25) {
				alert("글 제목은 25자 이내로 설정해주세요")
				$(this).val(len.substr(0, 25));
			}
		});

		$("#content").on("change keyup paste", function() {
			var len = $(this).val();
			if (len.length > 300) {
				alert("글 제목은 300자 이내로 설정해주세요")
				$(this).val(len.substr(0, 300));
			}
		})

		$("#party_date").on(
				"blur",
				function() {
					var d = new Date($("#party_date").val());
					var d_format = getFormatDate(d);
					var now = new Date();
					var now_format = getFormatDate(now);
					var lastday = new Date(now.getYear(), now.getMonth() + 2,
							now.getDate());
					var tdate = now.getFullYear();

					if (10 > lastday.getMonth()) {
						tdate += "0" + lastday.getMonth();
					} else {
						tdate += "" + lastday.getMonth();
					}

					if (10 > lastday.getDate()) {
						tdate += "0" + lastday.getDate();
					} else {
						tdate += "" + lastday.getDate();
					}

					console.log(d_format);
					console.log(now_format);
					var now_time = now.getTime();
					var d_time = d.getTime();

					console.log(now_time);
					console.log(d_time);

					if (now_format > d_format) {
						alert("과거의 날짜를 선택하셨습니다.");
						$("#party_date").val("");
					} else if (tdate < d_format) {
						alert("너무 먼 날짜를 선택하셨습니다.");
					} else if (now_time > d_time) {
						alert("과거의 시간을 선택하셨습니다.");
						$("#party_date").val("");
					} else {

						$("#timeDiv").text($("#party_date").val());
					}

				});

		var birthday = "${age}";
		var yyyy = birthday.substr(0, 4);
		var mm = birthday.substr(5, 2);
		var dd = birthday.substr(8, 2);
		var ymd = new Date(yyyy, mm - 1, dd);
		var today = new Date();
		var years = today.getFullYear() - ymd.getFullYear();
		console.log('계산 된 나이 : ' + years);
		var agech = "";
		if (years >= 50) {
			$("input:checkbox[id='age5']").prop("checked", true);
			$("input:checkbox[id='age5']").attr("disabled", true);
			agech = "age5";
		} else if (years >= 40) {
			$("input:checkbox[id='age4']").prop("checked", true);
			$("input:checkbox[id='age4']").attr("disabled", true);
			agech = "age4";
		} else if (years >= 30) {
			$("input:checkbox[id='age3']").prop("checked", true);
			$("input:checkbox[id='age3']").attr("disabled", true);
			agech = "age3";
		} else if (years >= 20) {
			$("input:checkbox[id='age2']").prop("checked", true);
			$("input:checkbox[id='age2']").attr("disabled", true);
			agech = "age2";
		} else if (years >= 14) {
			$("input:checkbox[id='age1']").prop("checked", true);
			$("input:checkbox[id='age1']").attr("disabled", true);
			agech = "age1";
		}
		;
		var gender = "${gender}";
		console.log(gender);
		if (gender == 1) {
			$('input:radio[id=gender1]').attr("disabled", false);
			$('input:radio[id=gender2]').attr("disabled", true);
		} else {
			$('input:radio[id=gender1]').attr("disabled", true);
			$('input:radio[id=gender2]').attr("disabled", false);
		}
		;
		$("#search_parent_name")
				.on(
						"click",
						function() {
							window.name = "parentForm";
							openWin = window
									.open("/party/toSearchStore", "childForm",
											"width=650, height=600, resizable = no, scrollbars = no");
						});
		/* $("#toCheckAddr").on("click",function(){
				var lng = $("#lng").val();
				var lat = $("#lat").val();
				if($("#category").val()=='c'){
					var category = 'cafe';
				}else{
					var category='food';
				}
				console.log(category);
				console.log(lat);
				console.log(lng);
				
				$.ajax({
					url : "/map/" + category+"?lat="+lat+"&lng="+lng,
					dataType : "json"
				}).done(function(resp) {
					console.log(resp);
					var pid = $("#place_id").val();
					for(var i=0; i< resp.documents.length;i++){
					if(resp.documents[i].place_id==pid){
						console.log(resp.documents[i].place_name);
					}
					}
					
				});
			
			
		}); */
		$("#submitBtn").on("click", function() {
			var parent_name = $("#parent_name").val();
			var parent_address = $("#parent_address").val();
			var title = $("#party_title").val();
			var date = $("#party_date").val();
			var time = $("#party_time").val();
			var count = $("#party_count").val();
			var content = $("#content").val();
			var isCheckGender = $('input:radio[name=gender]').is(':checked');
			var isCheckAge = $('input:checkbox[name=age]').is(':checked');

			if ($.trim(parent_name) == '') {
				alert('상호명 찾기버튼으로 모임장소를 등록해주세요');
				return false;
			}
			;
			if ($.trim(title) == '') {
				alert('모임 제목을 입력해주세요');
				return false;
			}
			;
			if (!date) {
				alert('모임날짜를 선택해주세요');
				return false;
			}
			;

			if ($.trim(count) == '') {
				alert("모임인원을 선택해주세요");
				return false;
			}
			;

			if (count > 4 || count < 2) {
				alert("모임인원은 2~4명 사이로 지정해주세요");
				return false;
			}
			;

			if (!isCheckGender) {
				alert('멤버구성을 선택해주세요');
				return false;
			}
			;

			if (count > 4 || count < 2) {
				alert("모임인원은 2~4명 사이로 지정해주세요");
				return false;
			}
			;
			if (!isCheckAge) {
				alert('모집하고자하는 연령대를 선택해주세요');
				return false;
			}
			;
			if ($.trim(content) == '') {
				alert('모임 소개를 작성해주세요');
				return false;
			}
			;
			let today = new Date();
			console.log(today);
			console.log(date);
			let tyear = today.getFullYear(); // 년도
			let tmonth = today.getMonth() + 1; // 월
			let tdate = today.getDate(); // 날짜
			let tday = today.getDay(); // 요일
			if (today > date) {
				alert('선택된 날짜가 과거입니다.');
				return false;
			}

			if (agech == "age5") {
				$("input:checkbox[id=age5]").attr("disabled", false);
			} else if (agech == "age4") {
				$("input:checkbox[id=age4]").attr("disabled", false);
			} else if (agech == "age3") {
				$("input:checkbox[id=age3]").attr("disabled", false);
			} else if (agech == "age2") {
				$("input:checkbox[id=age2]").attr("disabled", false);
			} else if (agech == "age1") {
				$("input:checkbox[id=age1]").attr("disabled", false);
			}
			document.form.submit();
		});
	});
</script>
</head>
<body>
	<!-- ******************* -->
	<!-- header  -->
	<jsp:include page="/WEB-INF/views/include/header.jsp" />
	<!-- hedaer  -->
	<!-- ******************* -->
	<div class="container-fluid section">
		<c:if test="${empty sessionScope.loginInfo }">
			<script>
			alert("로그인 후 이용해주세요");
			location.href="/member/loginview";
			
			
			</script>
		</c:if>
		<c:if test="${!empty sessionScope.loginInfo }">
			<form id="form" name="form" method="post"
				action="/party/party_New_Proc">
				<div class="container">
					<div class="row">
						<div class="col-12 col-sm-8 formdiv">
							<div class="row pt-5 mb-3">
								<div class="col-sm-12">
									<h2 class="party_headline">모임 모집하기</h2>
								</div>
								<input type="hidden" name="writer">
							</div>
							<div class="row mb-1">
								<div class="col-sm-2">상호</div>
								<div class="col-sm-7">
									<input type="text" class="form-control" name="parent_name"
										id="parent_name" value="${parent_name}" readonly>
								</div>
								<div class="col-sm-3">
									<button id="search_parent_name" class="btn btn_select"
										type=button>상호 찾기</button>
								</div>
							</div>
							<div class="row mb-1">
								<div class="col-sm-2">위치</div>
								<div class="col-sm-9">
									<!-- 예지 수정 : 지도형 페이지에서 '내가 직접 모집하기' 버튼으로 접근 / 네비 '모임모집' 버튼으로 접근하는 경우 구분-->
									<input type="text" class="form-control" name="parent_address"
										id="parent_address" value="${parent_address}" readonly>
									<c:choose>
										<c:when test="${not empty mdto}">
											<input type="hidden" name="place_id" id="place_id"
												value="${mdto.place_id}">
											<input type="hidden" name="lng" id="lng" value="${mdto.lng}">
											<input type="hidden" name="lat" id="lat" value="${mdto.lat}">
											<input type="hidden" name="category" id="category"
												value="${mdto.category}">
											<input type="hidden" name="phone" id="phone"
												value="${mdto.phone}">
											<input type="hidden" name="road_address_name"
												id="road_address_name" value="${mdto.road_address}">
											<input type="hidden" name="place_url" id="place_url"
												value="${mdto.place_url}">
											<input type="hidden" name="imgaddr" id="imgaddr"
												value="${img}">
										</c:when>
										<c:when test="${not empty kakaojson}">
											<c:forEach items="${kakaojson}" var="i" begin="0" end="0"
												varStatus="status">
												<input type="hidden" name="place_id" id="place_id"
													value="${place_id}">
												<input type="hidden" name="lng" id="lng" value="${lng}">
												<input type="hidden" name="lat" id="lat" value="${lat}">
												<input type="hidden" name="category" id="category"
													value="${category}">
												<input type="hidden" name="phone" id="phone"
													value="${phone}">
												<input type="hidden" name="road_address_name"
													id="road_address_name" value="${road_address}">
												<input type="hidden" name="place_url" id="place_url"
													value="${place_url}">
												<input type="hidden" name="imgaddr" id="imgaddr"
													value="${img}">
											</c:forEach>
										</c:when>
										<c:otherwise>
											<input type="hidden" name="place_id" id="place_id">
											<input type="hidden" name="lng" id="lng">
											<input type="hidden" name="lat" id="lat">
											<input type="hidden" name="category" id="category">
											<input type="hidden" name="phone" id="phone">
											<input type="hidden" name="road_address_name"
												id="road_address_name">
											<input type="hidden" name="place_url" id="place_url">
											<input type="hidden" name="imgaddr" id="imgaddr">
										</c:otherwise>
									</c:choose>
								</div>
							</div>

							<div class="row pb-1">
								<div class="col-sm-2">제목</div>
								<div class="col-sm-9">
									<input class="form-control" type="text" name="title"
										id="party_title">
								</div>
							</div>
							<div class="row mb-1">
								<div class="col-sm-2">날짜</div>
								<div class="col-sm-1 ">
									<div class="input-group date" id="datetimepicker1"
										data-target-input="nearest">
										<input type="hidden" id="party_date" name="date"
											class="form-control datetimepicker-input"
											data-target="#datetimepicker1" />
										<div class="input-group-append" data-target="#datetimepicker1"
											data-toggle="datetimepicker">
											<div class="input-group-text">
												<i class="fa fa-calendar"></i>
											</div>
										</div>
									</div>
									<script type="text/javascript">
										$(function() {
											$('#datetimepicker1')
													.datetimepicker(
															{
																pickDate : true,
																pickTime : true,
																useSeconds : false,
																startDate : 'd',
																format : 'YYYY-MM-DD H:mm',
																stepping : 5,
																showOn : "both",
																showButtonPanel : true

															}); //datepicker end
										});
									</script>
								</div>
								<div class="col-sm-5">
									<div id="timeDiv"></div>
								</div>
							</div>
							<div class="row mb-1">
								<div class="col-sm-2">인원</div>
								<div class="col-sm-5">
									<input class="form-control" type="number" name="count" min=2
										max=4 id="party_count" aria-describedby="countHelpInline">
								</div>
								<div class="col-sm-5">
									<small id="countHelpInline" class="text-muted"> 인원수는
										2~4명 사이로 설정가능합니다. </small>
								</div>

							</div>
							<div class="row mb-1">
								<div class="col-sm-2">구성</div>
								<div class="col-sm-10">
									<div class="form-check form-check-inline">
										<input class="form-check-input" type="radio" name="gender"
											value="m" id="gender1"> <label
											class="form-check-label" for="gender1">남자만</label>
									</div>

									<div class="form-check form-check-inline">
										<input class="form-check-input" type="radio" name="gender"
											value="f" id="gender2"> <label
											class="form-check-label" for="gender2">여자만</label>
									</div>

									<div class="form-check form-check-inline">
										<input class="form-check-input" type="radio" name="gender"
											value="a" id="gender3"> <label
											class="form-check-label" for="gender3">남녀무관</label>
									</div>
								</div>
							</div>

							<div class="row mb-1">
								<div class="col-sm-2">연령</div>
								<div class="col-sm-10">
									<div class="form-check form-check-inline">
										<input class="form-check-input" type="checkbox" name="age"
											value="10" id="age1"> <label class="form-check-label"
											for="age1">10대</label>
									</div>
									<div class="form-check form-check-inline">
										<input class="form-check-input" type="checkbox" name="age"
											value="20" id="age2"> <label class="form-check-label"
											for="age2">20대</label>
									</div>
									<div class="form-check form-check-inline">
										<input class="form-check-input" type="checkbox" name="age"
											value="30" id="age3"> <label class="form-check-label"
											for="age3">30대</label>
									</div>
									<div class="form-check form-check-inline">
										<input class="form-check-input" type="checkbox" name="age"
											value="40" id="age4"> <label class="form-check-label"
											for="age4">40대</label>
									</div>
									<div class="form-check form-check-inline">
										<input class="form-check-input" type="checkbox" name="age"
											value="50" id="age5"> <label class="form-check-label"
											for="age5">50대 이상</label>
									</div>
								</div>
							</div>

							<div class="row mb-1" id="adult_q">
								<div class="col-sm-2">음주</div>
								<div class="col-sm-10">
									<div class="form-check form-check-inline">
										<input class="form-check-input" type="radio" name="drinking"
											value="1" id="drinking1"> <label
											class="form-check-label" for="drinking1">OK</label>
									</div>

									<div class="form-check form-check-inline">
										<input class="form-check-input" type="radio" name="drinking"
											value="0" id="drinking2" checked="checked"> <label
											class="form-check-label" for="drinking2">NO</label>
									</div>
								</div>
							</div>
						</div>
						<div class="col-12 col-sm-4 mt-5 pt-5" id="img-area">
							<img src="${img}" width="350px" id="storeimg">
						</div>
					</div>
				</div>
				<div class="container formdiv pb-5">
					<div class="row pb-1">
						<div class="col-1">소개</div>
						<div class="col-11 px-5">
							<textarea class="form-control " id="content" name="content"
								placeholder="소개를 입력해주세요" rows="5" style="resize: none;"></textarea>
						</div>
					</div>
					<div class="row pt-3 pb-3">
						<div class="col-12">
							<button type=button id="submitBtn"
								class="btn btn_select btn-lg btn-block">모임 등록하기</button>
						</div>

					</div>

				</div>
			</form>
		</c:if>
	</div>

	<!-- ******************* -->
	<!-- footer  -->
	<jsp:include page="/WEB-INF/views/include/footer.jsp" />

	<!-- footer  -->
	<!-- ******************* -->
</body>
</html>
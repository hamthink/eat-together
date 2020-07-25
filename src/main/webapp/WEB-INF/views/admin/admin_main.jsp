<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
        <script src="https://code.jquery.com/jquery-3.5.1.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>
        <link rel="stylesheet" type="text/css" href="/resources/css/admin.css?ver=2">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.2/Chart.js"></script>
        <link href="/resources/assets/vendor/font-awesome/css/font-awesome.min.css"rel="stylesheet">      
        <title>Admin-main</title>
</head>
<style>

#ageChart , #partyChart{
	background-color:white;
	border:1px solid #f2f2f2;
	box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
}

.fa{
	color:#d4d4d4;
}
.apap{
	margin-top:3%;
}
.aac{
	position:absolute;
    left:50%;
    top:50%;
    transform:translate(-38%,-50%);
    
}
.aaa{
	text-align:center;
	font-size:50px;
	
}
.cha{
	padding-bottom:15px;
}
.admin-text{
	overflow-x:hidden;
}

</style>
<body>
	<div class="container-fluid mx-0 px-0 admin_text">
		<div class="row mx-0">
			<div class="col-2 mx-0 px-0">
				<jsp:include page="/WEB-INF/views/include/admin_sidebar.jsp" />
			</div>
			<div class="col-10 px-5 aac">
				<div class="row">
					<div class="col aaa">
						<span>사이트 현황</span>
					</div>
					
				</div>
				<div class="row">
					<div class="col-xl-3 col-md-3 mb-4 apap">
						<div class="card border-left-primary shadow h-100 py-2">
							<div class="card-body">
								<div class="row no-gutters align-items-center">
									<div class="col mr-2">
										<div
											class="text-xs font-weight-bold text-primary text-uppercase mb-1">총 회원수</div>
										<div class="h5 mb-0 font-weight-bold text-gray-800">${member }</div>
									</div>
									<div class="col-auto">
										<i class="fa fa-user-circle fa-3x text-gray-300"></i>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="col-xl-3 col-md-3 mb-4 apap">
						<div class="card border-left-success shadow h-100 py-2">
							<div class="card-body">
								<div class="row no-gutters align-items-center">
									<div class="col mr-2">
										<div
											class="text-xs font-weight-bold text-success text-uppercase mb-1">총 모임 수</div>
										<div class="h5 mb-0 font-weight-bold text-gray-800">${totalparty }</div>
									</div>
									<div class="col-auto">
										<i class="fa fa-comments fa-3x text-gray-300"></i>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="col-xl-3 col-md-3 mb-4 apap">
						<div class="card border-left-info shadow h-100 py-2">
							<div class="card-body">
								<div class="row no-gutters align-items-center">
									<div class="col mr-2">
										<div
											class="text-xs font-weight-bold text-info text-uppercase mb-1">총 맛집 수</div>
										<div class="h5 mb-0 font-weight-bold text-gray-800">${map}</div>
									</div>
									<div class="col-auto">
										<i class="fa fa-cutlery fa-3x text-gray-300"></i>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="col-xl-3 col-md-3 mb-4 apap">
						<div class="card border-left-warning shadow h-100 py-2">
							<div class="card-body">
								<div class="row no-gutters align-items-center">
									<div class="col mr-2">
										<div
											class="text-xs font-weight-bold text-warning text-uppercase mb-1">미 처리 현황</div>
										<div class="h6 mb-0 font-weight-bold text-gray-800">문의 : ${questionCount} <br> 신고 : ${reportCount }</div>
									</div>
									<div class="col-auto">
										
									</div>
								</div>
							</div>
						</div>
					</div>	
				</div>
				<div class="row">
					<div class="col-12 col-sm-12 mt-3">
						<div class="row">
							<div class="col-6 cha">
								<canvas id="partyChart"></canvas>
							</div>
							<div class="col-6 cha">
								<canvas id="ageChart"></canvas>
							</div>
						</div>
					</div>
				</div>	
			</div>
		</div>
	</div>
	<script type="text/javascript">
		// 연령대 별 회원 수 
		var ctx1 = document.getElementById("ageChart");
		
		var ageChart = new Chart(ctx1, {
	    	type: 'pie',
	    	data: {
	    		labels: ['10대','20대','30대','40대','50대 이상',],
	    		datasets:[{
	    			data:[
	    				${age["10대"]}, ${age["20대"]}, ${age["30대"]}, ${age["40대"]},${age["50대"]}
	    			],
	    			backgroundColor : [
						'rgba(255, 99, 132, 0.2)',
						'rgba(54, 162, 235, 0.2)',
						'rgba(255, 206, 86, 0.2)',
						'rgba(75, 192, 192, 0.2)',
						'rgba(153, 102, 255, 0.2)'
					],
					borderColor : [
						'rgba(255,99,132,1)',
						'rgba(54, 162, 235, 1)',
						'rgba(255, 206, 86, 1)',
						'rgba(75, 192, 192, 1)',
						'rgba(153, 102, 255, 1)'
					],
					borderWidth : 2
				}]
	    	},
	    	options: {
	    		cutoutPercentage: 70, //도넛두께 : 값이 클수록 얇아짐 
	    		legend: {position:'bottom', padding:5, labels: {pointStyle:'circle', usePointStyle:true}},
	    		maintainAspectRatio: true,
	    		title:{
	    			display:true,
	    			text:"연령대별 회원 수"
	    		}
	    	}
		});
		
		var ctx2 = document.getElementById("partyChart");
		
		var partyChart = new Chart(ctx2,{
			type : 'bar',			
			data : {		
				labels : ["일욜일","월요일","화요일","수요일","목요일","금요일","토요일"],
				datasets : [ {	
					label : '요일 별 생성 되었던 모임 현황',
					data : [${party["1"]}, ${party["2"]}, ${party["3"]}, ${party["4"]},${party["5"]},${party["6"]},${party["7"]}],
					backgroundColor: [
							'rgba(255, 99, 132, 0.2)',
							'rgba(54, 162, 235, 0.2)',
							'rgba(255, 206, 86, 0.2)',
							'rgba(75, 192, 192, 0.2)',
							'rgba(153, 102, 255, 0.2)',
							'rgba(255, 159, 64, 0.2)',
							'rgba(255, 100, 64, 0.2)',
							'rgba(255, 156, 64, 0.2)'

					],
					borderColor: [
							'rgba(255,99,132,1)',
							'rgba(54, 162, 235, 1)',
							'rgba(255, 206, 86, 1)',
							'rgba(75, 192, 192, 1)',
							'rgba(153, 102, 255, 1)',
							'rgba(255, 159, 64, 1)',
							'rgba(255, 100, 64, 1)',
							'rgba(255, 156, 64, 1)',
					],
					borderWidth : 2
				}]
			},
			options:{
				scales : {
					yAxes : [{
						ticks : {
							beginAtZero : true,
							stepSize:1
						}
					}]
				},
				title: {
					display: true,
			        text: '요일별 모집 수'
			    }
			}
		});
	</script>
</body>
</html>
/********************************* 채팅방으로 이동 ************************************/
function send_msg(){
	var option = "width = 500, height = 550, top = 100, left = 200, scrollbars=no"
	var target=	$("#party_writer").val();	
	//var target=${con.writer};
	window.open("/msg/msgResponse?msg_receiver="+target,target,option);
};
/********************************* 채팅방으로 이동 ************************************/

/********************************* 채팅방으로 이동 ************************************/
function toChatroom(num){
	var option = "width = 800, height = 800, top = 100, left = 200, scrollbars=no"
		window.open("/chat/chatroom?roomNum="+num, num, option);
}
/********************************* 채팅방으로 이동 ************************************/

/********************************* 모임 게시글 신고 ************************************/
function partyReport(num){
	console.log("신고 시작 : "+ num);
	//var writer = $(".party_writer").html();
	//var report_id = writer.substring(6,writer.length);
	var report_id = $("#party_writer").val();
	var title = $("#party_title").val();
	var content = $(".party_content").html();
	
	console.log("신고 시작 : "+ report_id);
	$.ajax({
		url:"/party/party_report",
		data : { seq : num, report_id : report_id , title : title , content : content},
		success : function(result) {
			if (result == 1){ 
				alert("신고가 정상적으로 접수되었습니다.");	
				
				if (self.name != 'reload') {
			         self.name = 'reload';
			         self.location.reload(true);
			     }
			     else self.name = ''; 
			}
			else{
				alert("무분별한 신고를 방지하기 위해 신고는 한번만 가능합니다.");
			}
		},
		error:function(e){
			console.log("error");
		}
	});	
}

/********************************* 채팅방으로 이동 ************************************/

/*****************************  party content 스크립 ***********************************************/
$(document).ready(function(){
	//var stime = "${con.sTime}";
	var stime = $("#party_time").val();
	var time = stime.substr(0,5);
	console.log(stime);
	$("#time").html(stime);
});
 
$(function () {
	
	var party_seq = $("#party_seq").val();
	console.log(party_seq);
	
	$("#partyModify").on("click", function() {
		//location.href = "/party/partymodify?seq=${con.seq}";
		location.href = "/party/partymodify?seq="+party_seq;
	});

	$("#partyDelete").on("click", function() {
		var ask = confirm("삭제 후에는 복구할 수 없습니다.\n 정말 삭제하겠습니까?");
		if (ask) {
			////location.href = "/party/partydelete?seq=${con.seq}";
			location.href = "/party/partydelete?seq="+party_seq;
		}
	});

	$("#toPartylist").on("click", function() {
		//location.href = "/party/toPartylist";
		location.href = "/party/selectByWriter?mcpage=1";
	});

	$("#toPartyJoin").on("click",function(){ //모임가입
		//location.href="/party/partyJoin?seq=${con.seq}";
		location.href="/party/partyJoin?seq="+party_seq;
	});

	// 태훈 신고
	$("#partyReport").on("click", function() {
		var ask = confirm("무분별한 신고는 신고자 본인에게 불이익이 갈 수 있습니다.\n정말 신고하겠습니까?");
		if (ask) {
			partyReport(party_seq );
		}
	});

	$("#toChatroom").on("click", function() {
		//toChatroom(${con.seq});
		toChatroom(party_seq );
	});

	$("#toExitParty").on("click",function(){
		//toExitParty(${con.seq});
		//toExitParty(party_seq );
		if (ask) {
			//location.href= "/party/toExitParty?seq=${con.seq}";
			location.href= "/party/toExitParty?seq=" + party_seq;
		}
	});


	$("#toStopRecruit").on("click",function(){
		var ask = confirm("모집종료 후에는 되돌릴 수 없습니다. \n 정말 모집을 종료하시겠습니까?");
		if (ask) {
			//location.href= "/party/restartRecruit?seq=${con.seq}&writer=${con.writer}";
			location.href= "/party/stopRecruit?seq="+party_seq +"&writer="+$(".party_writer").html();
		}
	});
	$(".party_writer").html()
});

//페이지 리사이징
$(function() {
	$('.cropping img').each(function(index, item) {
		if ($(this).height() / $(this).width() < 0.567) {
			$(this).addClass('landscape').removeClass('portrait');
		} else {
			$(this).addClass('portrait').removeClass('landscape');
		}
	});
});       


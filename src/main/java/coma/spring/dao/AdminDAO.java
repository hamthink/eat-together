package coma.spring.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import coma.spring.dto.MemberDTO;
import coma.spring.dto.MsgDTO;
import coma.spring.dto.PartyDTO;
import coma.spring.dto.ReportDTO;
import coma.spring.statics.Configuration;

@Repository
public class AdminDAO {
	@Autowired
	private SqlSessionTemplate mybatis;
	
	//by 지은, 체크박스 회원 탈퇴하기 _ 20200713
	public int memberOut(List<String> list) {
		return mybatis.delete("Admin.memberOut", list);
	}
	
	//by 지은, 회원정보 리스트 출력하기_20200712
	public List<MemberDTO> memberList(Map<String, Integer> param){
		return mybatis.selectList("Admin.memberList", param);
	}
	
	public int getAllMemberCount() {
		return mybatis.selectOne("Admin.getAllMemberCount");
	}
	
	//by 지은, 회원정보 조건검색 select 문 연결_20200712
	public List<MemberDTO> selectByOption(Map<String, Object> param){
		return mybatis.selectList("Admin.selectByOption", param);
	}
	
	//by 수지, 모임글 리스트 출력하기_20200712
	public List<PartyDTO> partyList(Map<String, Integer> param){
			return mybatis.selectList("Admin.partyList", param);
	}
	
	//by 수지, 모임글 조건검색 select 문 연결_20200712
	public List<PartyDTO> partyByOption(Map<String, Object> param){
		return mybatis.selectList("Admin.partyByOption", param);
	}

	//받은쪽지함
	public List<MsgDTO> selectBySender(int cpage,String msg_receiver) throws Exception{
		int start = cpage*Configuration.recordMsgCountPerPage - (Configuration.recordMsgCountPerPage - 1);
		int end = start + (Configuration.recordMsgCountPerPage - 1);
		
		Map<String,String> param = new HashMap<>();
		param.put("start",String.valueOf(start));
		param.put("end",String.valueOf(end));
		param.put("msg_receiver",msg_receiver);
		
		return mybatis.selectList("Admin.selectBySender",param);
	}
	//보낸쪽지함
	public List<MsgDTO> selectByReceiver(int cpage,String msg_receiver) throws Exception{
		int start = cpage*Configuration.recordMsgCountPerPage - (Configuration.recordMsgCountPerPage - 1);
		int end = start + (Configuration.recordMsgCountPerPage - 1);
		
		Map<String,String> param = new HashMap<>();
		param.put("start",String.valueOf(start));
		param.put("end",String.valueOf(end));
		param.put("msg_receiver",msg_receiver);
		
		return mybatis.selectList("Admin.selectByReceiver",param);
	}
	//삭제된쪽지함
	public List<MsgDTO> selectByDelete(int cpage,String msg_receiver) throws Exception{
		int start = cpage*Configuration.recordMsgCountPerPage - (Configuration.recordMsgCountPerPage - 1);
		int end = start + (Configuration.recordMsgCountPerPage - 1);
		
		Map<String,String> param = new HashMap<>();
		param.put("start",String.valueOf(start));
		param.put("end",String.valueOf(end));
		param.put("msg_receiver",msg_receiver);
		
		return mybatis.selectList("Admin.selectByGarbage",param);
	}
	
	//받은쪽지함카운트
	public int getSenderCount(String msg_receiver) throws Exception{
		return mybatis.selectOne("Admin.getSenderCount",msg_receiver);
	}
	//보낸쪽지함카운트
	public int getReceiverCount(String msg_receiver) throws Exception{
		return mybatis.selectOne("Admin.getReceiverCount",msg_receiver);

	}
	//휴지통카운트
	public int getGarbageCount(String msg_receiver) throws Exception{
		return mybatis.selectOne("Admin.getGarbageCount",msg_receiver);

	}
	//메세지 복구하기
	public int saveMsg(int msg_seq)throws Exception{
		return mybatis.update("Admin.saveMsg",msg_seq);
	}
	//받은 쪽지함 네비
			public String getSenderPageNav(int currentPage,String msg_receiver) throws Exception{
				int recordTotalCount = this.getSenderCount(msg_receiver); // 총 개시물의 개수
				int pageTotalCount = 0; // 전체 페이지의 개수

				if( recordTotalCount % Configuration.recordMsgCountPerPage > 0) {
					pageTotalCount = recordTotalCount / Configuration.recordMsgCountPerPage +1;
				}else {
					pageTotalCount = recordTotalCount / Configuration.recordMsgCountPerPage;
				}

				if(currentPage < 1) {
					currentPage = 1;
				}else if(currentPage > pageTotalCount){
					currentPage = pageTotalCount;
				}

				int startNav = (currentPage-1)/Configuration.navMsgCountPerPage * Configuration.navMsgCountPerPage + 1;
				int endNav = startNav + Configuration.navMsgCountPerPage - 1;
				if(endNav > pageTotalCount) {
					endNav = pageTotalCount;
				}

				boolean needPrev = true;
				boolean needNext = true;

				if(startNav == 1) {
					needPrev = false;
				}
				if(endNav == pageTotalCount) {
					needNext = false;
				}

				StringBuilder sb = new StringBuilder("<nav aria-label='Page navigation'><ul class='pagination justify-content-center'>");
				
				if(needPrev) {
					sb.append("<li class='page-item'><a class='page-link' href='admin_msgSend?ascpage="+(startNav-1)+"' id='prevPage' tabindex='-1' aria-disabled='true'>Previous</a></li>");
				}

				for(int i=startNav; i<=endNav; i++) {
					if(currentPage == i) {
						sb.append("<li class='page-item active' aria-current='page'><a class='page-link' href='admin_msgSend?ascpage="+i+"'>"+i+"<span class=sr-only>(current)</span></a></li>");
						//sb.append("<li class='page-item active' aria-current='page'>"+i+"<span class='sr-only'>(current)</span></li>");
					}else {
						sb.append("<li class='page-item'><a class='page-link' href='admin_msgSend?ascpage="+i+"'>"+i+"</a></li>");
					}
				}

				if(needNext) {
					sb.append("<li class=page-item><a class=page-link href='admin_msgSend?ascpage="+(endNav+1)+"' id='nextPage'>다음</a></li> ");
				}		
				sb.append("</ul></nav>");
				return sb.toString();
			}
			//보낸 쪽지함 네비
			public String getReceiverPageNav(int currentPage,String msg_receiver) throws Exception{
				int recordTotalCount = this.getReceiverCount(msg_receiver); // 총 개시물의 개수
				int pageTotalCount = 0; // 전체 페이지의 개수

				if( recordTotalCount % Configuration.recordMsgCountPerPage > 0) {
					pageTotalCount = recordTotalCount / Configuration.recordMsgCountPerPage +1;
				}else {
					pageTotalCount = recordTotalCount / Configuration.recordMsgCountPerPage;
				}

				if(currentPage < 1) {
					currentPage = 1;
				}else if(currentPage > pageTotalCount){
					currentPage = pageTotalCount;
				}

				int startNav = (currentPage-1)/Configuration.navMsgCountPerPage * Configuration.navMsgCountPerPage + 1;
				int endNav = startNav + Configuration.navMsgCountPerPage - 1;
				if(endNav > pageTotalCount) {
					endNav = pageTotalCount;
				}

				boolean needPrev = true;
				boolean needNext = true;

				if(startNav == 1) {
					needPrev = false;
				}
				if(endNav == pageTotalCount) {
					needNext = false;
				}

				StringBuilder sb = new StringBuilder("<nav aria-label='Page navigation'><ul class='pagination justify-content-center'>");
				
				if(needPrev) {
					sb.append("<li class='page-item'><a class='page-link' href='admin_msgReceive?arcpage="+(startNav-1)+"' id='prevPage' tabindex='-1' aria-disabled='true'>Previous</a></li>");
				}

				for(int i=startNav; i<=endNav; i++) {
					if(currentPage == i) {
						sb.append("<li class='page-item active' aria-current='page'><a class='page-link' href='admin_msgReceive?arcpage="+i+"'>"+i+"<span class=sr-only>(current)</span></a></li>");
						//sb.append("<li class='page-item active' aria-current='page'>"+i+"<span class='sr-only'>(current)</span></li>");
					}else {
						sb.append("<li class='page-item'><a class='page-link' href='admin_msgReceive?arcpage="+i+"'>"+i+"</a></li>");
					}
				}

				if(needNext) {
					sb.append("<li class=page-item><a class=page-link href='admin_msgReceive?arcpage="+(endNav+1)+"' id='nextPage'>다음</a></li> ");
				}		
				sb.append("</ul></nav>");
				return sb.toString();
			}
			
			//삭제된 메일함 네비
			public String getGarbagePageNav(int currentPage,String msg_receiver) throws Exception{
				int recordTotalCount = this.getGarbageCount(msg_receiver); // 총 개시물의 개수
				int pageTotalCount = 0; // 전체 페이지의 개수

				if( recordTotalCount % Configuration.recordMsgCountPerPage > 0) {
					pageTotalCount = recordTotalCount / Configuration.recordMsgCountPerPage +1;
				}else {
					pageTotalCount = recordTotalCount / Configuration.recordMsgCountPerPage;
				}

				if(currentPage < 1) {
					currentPage = 1;
				}else if(currentPage > pageTotalCount){
					currentPage = pageTotalCount;
				}

				int startNav = (currentPage-1)/Configuration.navMsgCountPerPage * Configuration.navMsgCountPerPage + 1;
				int endNav = startNav + Configuration.navMsgCountPerPage - 1;
				if(endNav > pageTotalCount) {
					endNav = pageTotalCount;
				}

				boolean needPrev = true;
				boolean needNext = true;

				if(startNav == 1) {
					needPrev = false;
				}
				if(endNav == pageTotalCount) {
					needNext = false;
				}

				StringBuilder sb = new StringBuilder("<nav aria-label='Page navigation'><ul class='pagination justify-content-center'>");
				
				if(needPrev) {
					sb.append("<li class='page-item'><a class='page-link' href='admin_msgDelete?gcpage="+(startNav-1)+"' id='prevPage' tabindex='-1' aria-disabled='true'>Previous</a></li>");
				}

				for(int i=startNav; i<=endNav; i++) {
					if(currentPage == i) {
						sb.append("<li class='page-item active' aria-current='page'><a class='page-link' href='admin_msgDelete?gcpage="+i+"'>"+i+"<span class=sr-only>(current)</span></a></li>");
						//sb.append("<li class='page-item active' aria-current='page'>"+i+"<span class='sr-only'>(current)</span></li>");
					}else {
						sb.append("<li class='page-item'><a class='page-link' href='admin_msgDelete?gcpage="+i+"'>"+i+"</a></li>");
					}
				}

				if(needNext) {
					sb.append("<li class=page-item><a class=page-link href='admin_msgDelete?gcpage="+(endNav+1)+"' id='nextPage'>다음</a></li> ");
				}		
				sb.append("</ul></nav>");
				return sb.toString();
			}
			
			// by 태훈 신고 리스트 출력하기
			public List<ReportDTO> reportList(Map<String, Integer> param){
				return mybatis.selectList("Admin.reportList", param);
			}
			public ReportDTO getReportContent(int seq) {
				return mybatis.selectOne("Admin.getReportContent",seq);
			}

}

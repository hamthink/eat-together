package coma.spring.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import coma.spring.dao.AdminDAO;
import coma.spring.dao.FaqDAO;
import coma.spring.dao.PartyDAO;
import coma.spring.dao.ReportDAO;
import coma.spring.dto.MemberDTO;
import coma.spring.dto.MsgDTO;
import coma.spring.dto.PartyDTO;
import coma.spring.dto.ReportDTO;
import coma.spring.statics.Configuration;

@Service
public class AdminService {
	@Autowired
	private AdminDAO adao;

	@Autowired
	private PartyDAO pdao;
	
	@Autowired
	private ReportDAO rdao;
	
	@Autowired
	private FaqDAO fdao;

	//by 지은, 체크박스 회원 삭제하기
	public int memberOut(String[] checkList) {

		List<String> list = new ArrayList<String>();
		for(int a=0;a<checkList.length;a++) {
			list.add(checkList[a]);
		}

		return adao.memberOut(list);
	}

	//by 지은, 회원정보 리스트 출력하기_20200712
	public List<MemberDTO> memberList(int cpage){
		int start = cpage * Configuration.recordCountPerPage-(Configuration.recordCountPerPage-1);
		int end = start + (Configuration.recordCountPerPage-1);

		Map<String, Integer> param = new HashMap<>();
		param.put("start", start);
		param.put("end", end);

		return adao.memberList(param);
	}

	//by 지은, 회원관리 조건검색_20200712
	public List<MemberDTO> selectByOption(int cpage, Object option){
		int start = cpage * Configuration.recordCountPerPage-(Configuration.recordCountPerPage-1);
		int end = start + (Configuration.recordCountPerPage-1);

		Map<String, Object> param = new HashMap<>();
		param.put("targetColumn", option);
		param.put("start", start);
		param.put("end", end);

		return adao.selectByOption(param);
	}


	//by 지은, 회원관리 네비바를 위한 회원수 카운트_20200712
	public int getAllMemberCount() {
		return adao.getAllMemberCount();
	}

	//by 지은, 회원관리 중 조건검색 정렬을 위한 네비바 생성_20200712
	public String getSelectMemberPageNav(int cpage, Object option) throws Exception{
		int recordTotalCount = adao.getAllMemberCount(); // 총 회원 수
		int pageTotalCount = 0; // 전체 페이지의 개수

		if( recordTotalCount % Configuration.recordCountPerPage > 0) {
			pageTotalCount = recordTotalCount / Configuration.recordCountPerPage +1;
		}else {
			pageTotalCount = recordTotalCount / Configuration.recordCountPerPage;
		}

		if(cpage < 1) {
			cpage = 1;
		}else if(cpage > pageTotalCount){
			cpage = pageTotalCount;
		}

		int startNav = (cpage-1)/Configuration.navCountPerPage * Configuration.navCountPerPage + 1;
		int endNav = startNav + Configuration.navCountPerPage - 1;
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
			sb.append("<li class='page-item'><a class='page-link' href='/admin/searchByOption?cpage="+(startNav-1)+"?option="+option+"' id='prevPage' tabindex='-1' aria-disabled='true'>Previous</a></li>");
		}

		for(int i=startNav; i<=endNav; i++) {
			if(cpage == i) {
				sb.append("<li class='page-item active' aria-current='page'><a class='page-link' href='/admin/searchByOption?cpage="+i+"?option="+option+"'>"+i+"<span class=sr-only>(current)</span></a></li>");
				//sb.append("<li class='page-item active' aria-current='page'>"+i+"<span class='sr-only'>(current)</span></li>");
			}else {
				sb.append("<li class='page-item'><a class='page-link' href='/admin/searchByOption?cpage="+i+"?option="+option+"'>"+i+"</a></li>");
			}
		}

		if(needNext) {
			sb.append("<li class=page-item><a class=page-link href='/admin/searchByOption?cpage="+(endNav+1)+"?option="+option+"' id='nextPage'>다음</a></li> ");
		}		
		sb.append("</ul></nav>");
		return sb.toString();
	}


	//by 지운, 회원관리 중 회원리스트 출력을 위한 네비바 생성_20200712
	public String getMemberPageNav(int cpage) throws Exception{
		int recordTotalCount = adao.getAllMemberCount(); // 총 회원의 수
		int pageTotalCount = 0; // 전체 페이지의 개수

		if( recordTotalCount % Configuration.recordCountPerPage > 0) {
			pageTotalCount = recordTotalCount / Configuration.recordCountPerPage +1;
		}else {
			pageTotalCount = recordTotalCount / Configuration.recordCountPerPage;
		}

		if(cpage < 1) {
			cpage = 1;
		}else if(cpage > pageTotalCount){
			cpage = pageTotalCount;
		}

		int startNav = (cpage-1)/Configuration.navCountPerPage * Configuration.navCountPerPage + 1;
		int endNav = startNav + Configuration.navCountPerPage - 1;
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
			sb.append("<li class='page-item'><a class='page-link' href='/admin/toAdmin_member?cpage="+(startNav-1)+"' id='prevPage' tabindex='-1' aria-disabled='true'>Previous</a></li>");
		}

		for(int i=startNav; i<=endNav; i++) {
			if(cpage == i) {
				sb.append("<li class='page-item active' aria-current='page'><a class='page-link' href='/admin/toAdmin_member?cpage="+i+"'>"+i+"<span class=sr-only>(current)</span></a></li>");
				//sb.append("<li class='page-item active' aria-current='page'>"+i+"<span class='sr-only'>(current)</span></li>");
			}else {
				sb.append("<li class='page-item'><a class='page-link' href='/admin/toAdmin_member?cpage="+i+"'>"+i+"</a></li>");
			}
		}

		if(needNext) {
			sb.append("<li class=page-item><a class=page-link href='/admin/toAdmin_member?cpage="+(endNav+1)+"' id='nextPage'>다음</a></li> ");
		}		
		sb.append("</ul></nav>");
		return sb.toString();
	}

	//by 수지 모임모집글  모임글 출력하기_20200712
	public List<PartyDTO> partyList(int cpage){
		int start = cpage * Configuration.recordCountPerPage-(Configuration.recordCountPerPage-1);
		int end = start + (Configuration.recordCountPerPage-1);

		Map<String, Integer> param = new HashMap<>();
		param.put("start", start);
		param.put("end", end);

		return adao.partyList(param);
	}

	//수지 모임모집글  모임글 네비_20200712
	public String getPageNavi(int currentPage) throws Exception{
		int recordTotalCount = pdao.getListCount(); 
		int pageTotalCount = 0; 
		if(recordTotalCount % Configuration.recordCountPerPage > 0) {
			pageTotalCount = recordTotalCount / Configuration.recordCountPerPage + 1;			
		}else {
			pageTotalCount = recordTotalCount / Configuration.recordCountPerPage;
		}
		if(currentPage < 1) {
			currentPage = 1;
		}else if(currentPage > pageTotalCount) {
			currentPage = pageTotalCount;
		}
		int startNavi = (currentPage - 1) / Configuration.navCountPerPage * Configuration.navCountPerPage + 1;
		int endNavi = startNavi + Configuration.navCountPerPage - 1;
		if(endNavi > pageTotalCount) {
			endNavi = pageTotalCount;
		}
		boolean needPrev = true; // <
		boolean needNext = true; // >
		StringBuilder sb = new StringBuilder();
		if(startNavi == 1) {needPrev = false;}
		if(endNavi == pageTotalCount) {needNext = false;}

		if(needPrev) {
			sb.append("<li class='page-item'><a class='page-link' href='toAdmin_party?cpage="+(startNavi-1)+" aria-label=\"Previous\"> <span aria-hidden=\"true\"><i class=\"fas fa-chevron-left\"></i></span> </a></li>");
		}
		for(int i = startNavi;i <= endNavi;i++) {
			if(currentPage == i) {
				sb.append("<li class='page-item active' aria-current=\"page\"><span class=\"page-link\">" + i +"<span class=\"sr-only\">(current)</span></span></li>");
			}
			else {
				sb.append("<li class='page-item'><a class='page-link' href=\"toAdmin_party?cpage="+i+"\">" + i + "</a></li>");
			}	
		}
		if(needNext) {
			sb.append("<li class='page-item'><a class='page-link' href='toAdmin_party?cpage="+(endNavi-1)+" aria-label=\"Next\"> <span aria-hidden=\"true\"><i class=\"fas fa-chevron-right\"></i></span> </a></li>");
		}
		

		return sb.toString();
	}

	//by 수지, 모임글관리 조건검색_20200712
	public List<PartyDTO> partyByOption(int cpage, Object option){
		int start = cpage * Configuration.recordCountPerPage-(Configuration.recordCountPerPage-1);
		int end = start + (Configuration.recordCountPerPage-1);

		Map<String, Object> param = new HashMap<>();
		param.put("targetColumn", option);
		param.put("start", start);
		param.put("end", end);

		return adao.partyByOption(param);
	}

	//by 수지, 모임글 관리 중 조건검색 정렬을 위한 네비바 생성_20200712
	public String getSelectPartyPageNav(int cpage, Object option) throws Exception{
		int recordTotalCount = pdao.getListCount();
		int pageTotalCount = 0; // 전체 페이지의 개수

		if( recordTotalCount % Configuration.recordCountPerPage > 0) {
			pageTotalCount = recordTotalCount / Configuration.recordCountPerPage +1;
		}else {
			pageTotalCount = recordTotalCount / Configuration.recordCountPerPage;
		}

		if(cpage < 1) {
			cpage = 1;
		}else if(cpage > pageTotalCount){
			cpage = pageTotalCount;
		}

		int startNav = (cpage-1)/Configuration.navCountPerPage * Configuration.navCountPerPage + 1;
		int endNav = startNav + Configuration.navCountPerPage - 1;
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
			sb.append("<li class='page-item'><a class='page-link' href='/admin/partyByOption?cpage="+(startNav-1)+"' id='prevPage' tabindex='-1' aria-disabled='true'>Previous</a></li>");
		}

		for(int i=startNav; i<=endNav; i++) {
			if(cpage == i) {
				sb.append("<li class='page-item active' aria-current='page'><a class='page-link' href='/admin/partyByOption?cpage="+i+"'>"+i+"<span class=sr-only>(current)</span></a></li>");
				//sb.append("<li class='page-item active' aria-current='page'>"+i+"<span class='sr-only'>(current)</span></li>");
			}else {
				sb.append("<li class='page-item'><a class='page-link' href='/admin/partyByOption?cpage="+i+"'>"+i+"</a></li>");
			}
		}

		if(needNext) {
			sb.append("<li class=page-item><a class=page-link href='/admin/partyByOption?cpage="+(endNav+1)+"' id='nextPage'>다음</a></li> ");
		}		
		sb.append("</ul></nav>");
		return sb.toString();
	}
	
	// 태훈 신고 리스트 출력
	public List<ReportDTO> reportList(int cpage){
		System.out.println("신고 서비스 : "+cpage);
		int start = cpage * Configuration.recordCountPerPage-(Configuration.recordCountPerPage-1);
		int end = start + (Configuration.recordCountPerPage-1);

		Map<String, Integer> param = new HashMap<>();
		param.put("start", start);
		param.put("end", end);

		return adao.reportList(param);
	}

	// 태훈  신고 리스트 네비_20200712
	public String getReportNavi(int currentPage) throws Exception{
		int recordTotalCount =rdao.getListCount(); 
		System.out.println("신고 토탈"+recordTotalCount);
		int pageTotalCount = 0; 
		if(recordTotalCount % Configuration.recordCountPerPage > 0) {
			pageTotalCount = recordTotalCount / Configuration.recordCountPerPage + 1;			
		}else {
			pageTotalCount = recordTotalCount / Configuration.recordCountPerPage;
		}
		if(currentPage < 1) {
			currentPage = 1;
		}else if(currentPage > pageTotalCount) {
			currentPage = pageTotalCount;
		}
		int startNavi = (currentPage - 1) / Configuration.navCountPerPage * Configuration.navCountPerPage + 1;
		int endNavi = startNavi + Configuration.navCountPerPage - 1;
		if(endNavi > pageTotalCount) {
			endNavi = pageTotalCount;
		}
		boolean needPrev = true; // <
		boolean needNext = true; // >
		StringBuilder sb = new StringBuilder();
		if(startNavi == 1) {needPrev = false;}
		if(endNavi == pageTotalCount) {needNext = false;}

		if(needPrev) {
			sb.append("<li class='page-item'><a class='page-link' href='toAdmin_report?cpage="+(startNavi-1)+" aria-label=\"Previous\"> <span aria-hidden=\"true\">&laquo;</span> </a></li>");
		}
		else {
			sb.append("<li class='page-item disabled'><a class='page-link' aria-label=\"Previous\"> <span aria-hidden=\"true\">&laquo;</span> </a></li>");
		}
		for(int i = startNavi;i <= endNavi;i++) {
			if(currentPage == i) {
				sb.append("<li class='page-item active' aria-current=\"page\"><span class=\"page-link\">" + i +"<span class=\"sr-only\">(current)</span></span></li>");
			}
			else {
				sb.append("<li class='page-item'><a class='page-link' href=\"toAdmin_report?cpage="+i+"\">" + i + "</a></li>");
			}	
		}
		if(needNext) {
			sb.append("<li class='page-item'><a class='page-link' href='toAdmin_report?cpage="+(endNavi-1)+" aria-label=\"Next\"> <span aria-hidden=\"true\">&raquo;</span> </a></li>");
		}
		else {
			sb.append("<li class='page-item disabled'><a class='page-link' aria-label=\"Next\"> <span aria-hidden=\"true\">&raquo;</span> </a></li>");
		}

		return sb.toString();
	}
	//받은쪽지함
	public List<MsgDTO> selectBySender(int cpage,String msg_receiver) throws Exception{
		List<MsgDTO> dto = adao.selectBySender(cpage,msg_receiver);
		return dto;
	}
	//보낸쪽지함
	public List<MsgDTO> selectByReceiver(int cpage,String msg_receiver) throws Exception{
		List<MsgDTO> dto = adao.selectByReceiver(cpage,msg_receiver);
		return dto;
	}
	//삭제된메일함
	public List<MsgDTO> selectByDelete(int cpage,String msg_receiver) throws Exception{
		List<MsgDTO> dto = adao.selectByDelete(cpage,msg_receiver);
		return dto;
	}
	//관리자 받은쪽지함 네비
	public String Sendnavi (int cpage,String msg_receiver) throws Exception{
		String navi = adao.getSenderPageNav(cpage,msg_receiver);
		return navi;
	}
	//관리자 보낸쪽지함 네비
	public String Receivenavi (int cpage,String msg_receiver) throws Exception{
		String navi = adao.getReceiverPageNav(cpage,msg_receiver);
		return navi;
	}
	//관리자 받은쪽지함 네비
	public String Deletenavi (int cpage,String msg_receiver) throws Exception{
		String navi = adao.getGarbagePageNav(cpage,msg_receiver);
		return navi;
	}
	//쪽지복구하기
	public int saveMsg(int msg_seq)throws Exception{
		int result = adao.saveMsg(msg_seq);
		return result;
	}
	public ReportDTO getReportContent(int seq) throws Exception{
		return adao.getReportContent(seq);
	}
	
	//수지 faq리스트
	public String faqgetPageNav(int currentPage) throws Exception{
		int recordTotalCount = fdao.getArticleCount(); // 총 개시물의 개수
		int pageTotalCount = 0; // 전체 페이지의 개수

		if( recordTotalCount % Configuration.recordCountPerPage > 0) {
			pageTotalCount = recordTotalCount / Configuration.recordCountPerPage +1;
		}else {
			pageTotalCount = recordTotalCount / Configuration.recordCountPerPage;
		}

		if(currentPage < 1) {
			currentPage = 1;
		}else if(currentPage > pageTotalCount){
			currentPage = pageTotalCount;
		}

		int startNav = (currentPage-1)/Configuration.navCountPerPage * Configuration.navCountPerPage + 1;
		int endNav = startNav + Configuration.navCountPerPage - 1;
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
			sb.append("<li class='page-item'><a class='page-link' href='toAdmin_faq?cpage="+(startNav-1)+"' id='prevPage' tabindex='-1' aria-disabled='true'>Previous</a></li>");
		}

		for(int i=startNav; i<=endNav; i++) {
			if(currentPage == i) {
				sb.append("<li class='page-item active' aria-current='page'><a class='page-link' href='toAdmin_faq?cpage="+i+"'>"+i+"<span class=sr-only>(current)</span></a></li>");
				//sb.append("<li class='page-item active' aria-current='page'>"+i+"<span class='sr-only'>(current)</span></li>");
			}else {
				sb.append("<li class='page-item'><a class='page-link' href='toAdmin_faq?cpage="+i+"'>"+i+"</a></li>");
			}
		}

		if(needNext) {
			sb.append("<li class=page-item><a class=page-link href='toAdmin_faq?cpage="+(endNav+1)+"' id='nextPage'>다음</a></li> ");
		}		
		sb.append("</ul></nav>");
		return sb.toString();
	}
	
	public String faqnavi (int cpage) throws Exception{
		String navi = this.faqgetPageNav(cpage);
		return navi;
	}

	//삭제된 받은 쪽지함
	public List<MsgDTO> selectBySendDel(int cpage) throws Exception{
		List<MsgDTO> dto = adao.selectBySendDel(cpage);
		return dto;
	}
	//관리자 삭제된 받은  쪽지함 네비
	public String SendDelnavi (int cpage) throws Exception{
		String navi = adao.getSendDelPageNav(cpage);
		return navi;
	}
	//관리자 삭제된 받은 쪽지 검색 네비
	public List<MsgDTO> selectByDelSearch(int cpage,String msg_receiver) throws Exception{
		List<MsgDTO> dto = adao.selectByDelSearch(cpage,msg_receiver);
		return dto;
	}
	//관리자 삭제된 받은  쪽지함 검색 네비
	public String SearchDelnavi (int cpage,String msg_receiver) throws Exception{
		String navi = adao.getDelSearchPageNav(cpage,msg_receiver);
		return navi;
	}
	//관리자 삭제된 페이지 쪽지 살리기
	public int saveMsgSend(String[] checkList)throws Exception{
		List<String> list = new ArrayList<String>();
		for(int a=0;a<checkList.length;a++) {
			list.add(checkList[a]);
		}
		return adao.saveMsgSend(list);
	}
	//관리자 페이지 휴지통 비우기
	public int msgDelete()throws Exception{
		return adao.msgDelete();
	}

	// 태훈 등록 맛집 갯수
	public int mapCount() throws Exception{
		return adao.mapCount();
	}
	
	// 태훈 미 접수 신고 수 가져오기
	public int reportCount() throws Exception {
		return adao.reportCount();
	}
	// 태훈 미 답변 문의 수 가져오기
	public int	questionCount() throws Exception {
		return adao.questionCount();
	}
	// 태훈 연령별 회원 수
	public Map<String, Integer> memberCountByAge() throws Exception {
		//Map<Integer, Integer> age = new HashMap<>();
		Map<String, Integer> age = new HashMap<>();
		//List<Map<Integer,Integer>> ageList = adao.memberCountByAge();
		List<Map<String,Integer>> ageList = adao.memberCountByAge();
		for (int i=0; i<ageList.size();i++) {
			age.put(String.valueOf(ageList.get(i).get("연령")), ageList.get(i).get("수"));
			System.out.println(age);
		}
		for (int i=1; i<6; i++) {
			if(!(age.containsKey((i*10)+"대"))) {
				age.put((i*10)+"대",0);
			}
			System.out.println(age);
		}
		
		return age;
	}
	// 태훈 요일별 모집 수
	public Map<String, Integer> partyCountByDay() throws Exception {
		Map<String, Integer> party = new HashMap<>();
		List<Map<String,Integer>> partyList = adao.partyCountByDay();
		for (int i=0; i<partyList.size();i++) {
			party.put(String.valueOf(partyList.get(i).get("요일")), partyList.get(i).get("수"));
			System.out.println(party);
		}
		for (int i=1; i<8; i++) {
			if(!(party.containsKey(String.valueOf(i)))) {
				party.put(String.valueOf(i),0);
			}
			System.out.println(party);
		}

		return party;
	}

}

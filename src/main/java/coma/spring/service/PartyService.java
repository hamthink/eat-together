package coma.spring.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import coma.spring.dao.PartyDAO;
import coma.spring.dao.ReportDAO;
import coma.spring.dto.PartyCountDTO;
import coma.spring.dto.PartyDTO;
import coma.spring.dto.PartySearchListDTO;
import coma.spring.dto.ReportDTO;
import coma.spring.statics.Configuration;
import coma.spring.statics.PartyConfiguration;


@Service
public class PartyService {

	@Autowired
	private PartyDAO pdao;
	
	@Autowired
	private ReportDAO rdao;

	// 수지 모임 생성
	public int partyInsert(PartyDTO dto) throws Exception  {
		int seq = pdao.getNextVal();
		//String imgaddr = this.clew(dto.getParent_name());
		dto.setSeq(seq);
		//dto.setImgaddr(imgaddr);
		pdao.insert(dto);
		return seq;
	}

	//수지 파티 참가 
	public int partyJoin(String seq, String nickname) throws Exception {
		int result = pdao.partyJoin(seq,nickname);
		return result;
	}
	// 수지 계정당 모임 생성수 확인
	public int getMadePartyCount(String writer) throws Exception{
		return pdao.getMadePartyCount(writer);
	}

	//수지 파티 정원초과 확인
	public boolean isPartyfull(String seq) throws Exception {
		boolean result = pdao.isPartyfull(seq);
		return result;
	}


	//수지 파티 참가인인지 확인
	public boolean isPartyParticipant(String seq, String nickname) throws Exception{
		boolean result = pdao.isPartyParticipant(seq,nickname);
		return result;
	}


	// 수지 모임 글 보기 
	public PartyDTO selectBySeq(int seq) throws Exception {
		PartyDTO dto = pdao.selectBySeq(seq); // 읽어오기
		return dto;
	}

	// 수지 모임 삭제
	public int delete(String seq) throws Exception{
		int result=pdao.delete(seq);
		return result;
	}

	// 수지 모임 수정
	public int update(PartyDTO dto) throws Exception{
		int result= pdao.update(dto);
		return result;
	}

	// 태훈 모임 리스트
	public List<PartyDTO> selectList(int cpage) throws Exception {
		List<PartyDTO> list = pdao.selectList(cpage);
		return list;
	}
	
	// 태훈 모임 글 상세 검색
	public List<PartyDTO> partySearch(Map<String, Object> map, int cpage) throws Exception{
		List<PartyDTO> list = pdao.partySearch(this.searchKey(map),cpage);
		System.out.println(list);
		return list;
	}
	// 태훈 검색 키워드 가공
	public Map<String, Object> searchKey(Map<String, Object> map) throws Exception{

		Map<String, Object> param = new HashMap<>();

		// 지역 정보
		if(map.get("sido").equals("시/도 선택")) {
			param.put("address", "");
			
		}
		else {
			if(map.get("gugun").equals("구/군 선택")) {
				param.put("address",map.get("sido"));
			}
			else {
				param.put("address",map.get("sido") + " " +map.get("gugun"));
			}
			
		}
		System.out.println(param.get("address"));
		// 성별 정보
		param.put("gender",map.get("gender"));
		// 나이 정보
		param.put("ageList", map.get("ageList"));
		param.put("ageList.size",map.get("ageListSize"));
		// 음주 정보
		param.put("drinking",map.get("drinking"));
		// 키워드 검색
		String title = "", writer = "", content = "", both = ""; 
		if(map.get("text").equals("title")) {
			title = (String) map.get("search");
		}
		else if(map.get("text").equals("writer")){
			writer = (String) map.get("search");
			System.out.println("W"+writer);
		}
		else if(map.get("text").equals("content")) {
			content = (String) map.get("search");
			System.out.println("C"+content);
		}
		else if(map.get("text").equals("both")) {
			both = (String) map.get("search");
		}
		param.put("title", title);
		param.put("writer", writer);
		param.put("content", content);
		param.put("both", both);
		return param;
	}
	
	// 예지 장소 아이디 별 모임 리스트
	public List<PartyDTO> selectByPageNo(int cpage, int place_id) throws Exception{
		return pdao.selectByPageNo(cpage, place_id);
	}
	// 예지 페이지 네비
	public String getPageNavi(int currentPage, int place_id) throws Exception{
		int recordTotalCount = pdao.getArticleCount(place_id); 
		int pageTotalCount = 0; 
		if(recordTotalCount % PartyConfiguration.RECORD_COUNT_PER_PAGE > 0) {
			pageTotalCount = recordTotalCount / PartyConfiguration.RECORD_COUNT_PER_PAGE + 1;			
		}else {
			pageTotalCount = recordTotalCount / PartyConfiguration.RECORD_COUNT_PER_PAGE;
		}
		if(currentPage < 1) {
			currentPage = 1;
		}else if(currentPage > pageTotalCount) {
			currentPage = pageTotalCount;
		}
		int startNavi = (currentPage - 1) / PartyConfiguration.NAVI_COUNT_PER_PAGE * PartyConfiguration.NAVI_COUNT_PER_PAGE + 1;
		int endNavi = startNavi + PartyConfiguration.NAVI_COUNT_PER_PAGE - 1;
		if(endNavi > pageTotalCount) {
			endNavi = pageTotalCount;
		}
		boolean needPrev = true; // <
		boolean needNext = true; // >
		if(startNavi == 1) {needPrev = false;}
		if(endNavi == pageTotalCount) {needNext = false;}

		StringBuilder sb = new StringBuilder();
		if(needPrev) {sb.append("<li class='page-item'><a class='page-link' href='selectMarkerInfo?cpage="+(startNavi-1)+"&place_id="+place_id+"' tabindex='-1' aria-disabled='true'><i class=\"fas fa-chevron-left\"></i> </a></li>");}
		for(int i = startNavi;i <= endNavi;i++) {
			sb.append("<li class='page-item'><a class='page-link' href='selectMarkerInfo?cpage="+i+"&place_id="+place_id+"'>" + i + "</a></li>");
		}
		if(needNext) {sb.append("<li class='page-item'><a class='page-link' href='selectMarkerInfo?cpage="+(endNavi+1)+"&place_id="+place_id+"'><i class=\"fas fa-chevron-right\"></i></a></li>");}
		return sb.toString();
	}

	// 수지 모임 종료
	public int stopRecruit(String seq) throws Exception {
		return pdao.stopRecruit(seq);
	}
	// 예지 모임 전체 갯수
	public int selectAllCount() throws Exception{
		return pdao.selectAllCount();
	}
	// 지은 작성자 별 모임 리스트
	public List<PartyDTO> selectByWriterPage(String nickname, int mcpage)throws Exception{
		int start = mcpage * Configuration.recordCountPerPage-(Configuration.recordCountPerPage-1);
		int end = start + (Configuration.recordCountPerPage-1);

		Map<String, Object> param = new HashMap<>();
		param.put("start", start);
		param.put("end", end);
		param.put("nickname", nickname);

		List<PartyDTO> partyList = pdao.selectByWriterPage(param);
		return partyList;
	}
	// 지은 페이지 네비
	public String getMyPageNav(int mcpage, String nickname) throws Exception{
		int recordTotalCount = pdao.getMyPageArticleCount(nickname); // 총 개시물의 개수
		int pageTotalCount = 0; // 전체 페이지의 개수

		if( recordTotalCount % Configuration.recordCountPerPage > 0) {
			pageTotalCount = recordTotalCount / Configuration.recordCountPerPage +1;
		}else {
			pageTotalCount = recordTotalCount / Configuration.recordCountPerPage;
		}

		if(mcpage < 1) {
			mcpage = 1;
		}else if(mcpage > pageTotalCount){
			mcpage = pageTotalCount;
		}

		int startNav = (mcpage-1)/Configuration.navCountPerPage * Configuration.navCountPerPage + 1;
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
			sb.append("<li class='page-item'><a class='page-link' href='/party/selectByWriter?mcpage="+(startNav-1)+"' id='prevPage' tabindex='-1' aria-disabled='true'>Previous</a></li>");
		}

		for(int i=startNav; i<=endNav; i++) {  
			if(mcpage == i) {
				sb.append("<li class='page-item active' aria-current='page'><a class='page-link' href='/party/selectByWriter?mcpage="+i+"'>"+i+"<span class=sr-only>(current)</span></a></li>");
				//sb.append("<li class='page-item active' aria-current='page'>"+i+"<span class='sr-only'>(current)</span></li>");
			}else {
				sb.append("<li class='page-item'><a class='page-link' href='/party/selectByWriter?mcpage="+i+"'>"+i+"</a></li>");
			}
		}

		if(needNext) {
			sb.append("<li class=page-item><a class=page-link href='/party/selectByWriter?mcpage="+(endNav+1)+"' id='nextPage'>다음</a></li> ");
		}		
		sb.append("</ul></nav>");
		return sb.toString();
	}
	// 이지미 클롤링
	public String clew(String str) throws Exception {
		Document doc = Jsoup.connect("https://m.map.kakao.com/actions/searchView?q="+str).get();
		Element linkTag = doc.selectFirst("ul#placeList>li>a>span");
		String img = linkTag.html();
		if(img.contains("fname=")) {
			return img.split("fname=")[1].split("\"")[0];
		}
		else {
			// 이미지 소스 없는 가게 에러 해결 위해 추가 - 태훈
			return "/resources/img/admin-logo.png";
		}
	}

	//블랙리스트유저 차단
	public int userBlockedConfirm(String name , int seq) {
		Map<String , Object> map = new HashMap<String, Object>();
		map.put("name",name);
		map.put("seq" , seq);
		return pdao.userBlockedConfirm(map);
	}

	// 수지 파티의 모집인원수, 현재 참여인원수 구하기
	public PartyCountDTO getPartyCounts(String seq) {
		return pdao.getPartyCounts(seq);
	}
	
	// 태훈 모임 게시글 신고
	@Transactional("txManager")
	public int partyReport(ReportDTO rdto) throws Exception{
		rdao.newReport(rdto); // 신고 테이블 insert 문 
		return pdao.partyReport(rdto.getParent_seq()); // 리뷰 테이블 신고 컬럼 update 문
	}
	// 수지 모집 재시작 기능
	public int restartRecruit(String seq) throws Exception {
		return pdao.restartRecruit(seq);

	}
	// 예지 - 모임글 관리 체크박스 삭제
	public int deleteCheckList(String[] checkList) throws Exception{
		List<String> list = new ArrayList<String>();
		for(int a=0;a<checkList.length;a++) {
			list.add(checkList[a]);
		}
		return pdao.deleteCheckList(list);
	}
}


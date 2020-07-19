package coma.spring.controller;

import java.net.URI;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.RequestEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import coma.spring.dto.MapDTO;
import coma.spring.dto.MemberDTO;
import coma.spring.dto.PartyCountDTO;
import coma.spring.dto.PartyDTO;
import coma.spring.dto.ReportDTO;
import coma.spring.service.ChatService;
import coma.spring.service.MapService;
import coma.spring.service.PartyService;
import coma.spring.service.ReviewService;

@Controller
@RequestMapping("/party/")
public class PartyController {
	@Autowired
	private ChatService cservice;
	
	@Autowired
	private PartyService pservice;

	@Autowired
	private MapService mapservice;
	
	@Autowired
	private ReviewService rservice;

	@Autowired
	private HttpSession session;
	
	// 수지 모임글 작성 페이지 이동
	@RequestMapping("toParty_New")
	public String toPartyNew(HttpServletRequest request) {
		try {
			MemberDTO account = (MemberDTO) session.getAttribute("loginInfo");
			String userid= account.getId();
			String nickname = account.getNickname();
			int gender = account.getGender();
			
			//계정당 활성화된 모임 체크
			int myPartyCount = pservice.getMadePartyCount(nickname);
			if(myPartyCount>4) {
				return "/error/partyfull";
			}
			
			String age = account.getBirth();
			request.setAttribute("gender", gender);
			request.setAttribute("age", age);
		}catch(Exception e) {}
		return "/party/party_new";
	}
	// 수지 모임글 작성
	@RequestMapping(value = "party_New_Proc", method = RequestMethod.POST)
	/*public String partyNewProc(HttpServletRequest request) {*/
	public String partyNewProc(PartyDTO dto, HttpServletRequest request, RedirectAttributes redirectAttributes) throws Exception {

		//		String parent_name = dto.getParent_name();
		//		String parent_address = dto.getParent_address();
		//		String title = dto.getTitle();

		String date = dto.getDate();
		//String time = dto.getTime();
		String dateAndtime = date + ":00.0";

		Timestamp meetdate = java.sql.Timestamp.valueOf(dateAndtime);
		dto.setMeetdate(meetdate);
		
		SimpleDateFormat formatter = new SimpleDateFormat ("yyyy-MM-dd hh:mm:ss");
		Calendar cal = Calendar.getInstance();
		String today = null;
		today = formatter.format(cal.getTime());
		Timestamp ts = Timestamp.valueOf(today);
		
		if(meetdate.before(ts)) {
			return "error/partyinsert";
		}
		
		
		
		MemberDTO account = (MemberDTO) session.getAttribute("loginInfo");
		String userid= account.getId();
		String nickname = account.getNickname();
			
		dto.setWriter(nickname);
		dto.setStatus("1");
		//
		
		
		int count = dto.getCount();
		System.out.println("카운트="+count);
		//		
		//		String age = dto.getAge();
		//		String gender = dto.getGender();
		//		
		//		String drinking = dto.getDrinking();
		//		String content = dto.getContent();
		//		
		System.out.println((String)request.getParameter("lat"));
		System.out.println((String)request.getParameter("lng"));
		String place_url = "http://place.map.kakao.com/" + dto.getPlace_id();
		if(mapservice.insertPossible(place_url)) {
			MapDTO mdto = new MapDTO();
			mdto.setName(dto.getParent_name());
			mdto.setAddress(dto.getParent_address());
			mdto.setRoad_address((String)request.getParameter("road_address_name"));
			mdto.setCategory((String)request.getParameter("category"));
			Double lat = Double.parseDouble((String)request.getParameter("lat")); mdto.setLat(lat);
			Double lng = Double.parseDouble((String)request.getParameter("lng")); mdto.setLng(lng);
			mdto.setPhone((String)request.getParameter("phone"));
			mdto.setPlace_url((String)request.getParameter("place_url"));
			mdto.setPlace_id(dto.getPlace_id());
			mapservice.insert(mdto);
		}

		int myseq = pservice.partyInsert(dto);   // 글번호
		//채팅 insert (생성)  cservice.insert(seq);
		
		pservice.partyJoin(Integer.toString(myseq),nickname);

		// 모임 등록 작업 수행
		System.out.println(myseq);
		redirectAttributes.addAttribute("seq", myseq);
		//모임 등록 후 등록된 페이지로 이동 
		System.out.println("파티 이동!!1");
		return "redirect:/party/party_content";
	}
	// 수지 모임 생성 중 상호 검색 창 이동 
	@RequestMapping(value="toSearchStore", method=RequestMethod.GET)
	public String toSearchStore() {
		return "/party/searchStore";
	}
	// 수지 모임 생성 중 상호 검색 
	@ResponseBody
	@RequestMapping(value="searchStoreProc", method=RequestMethod.GET, produces="application/json;charset=utf8")
	public String searchStoreProc(String keyword, String category) throws Exception {
		String HOST = "https://dapi.kakao.com";
		String APIKEY = "KakaoAK 80c29b1bba14c9c568e4ae4f89fc9368";
		System.out.println(keyword);

		Gson gson = new Gson();
		JsonObject result = new JsonObject();
		JsonArray resultadd = new JsonArray();
		boolean breakpoint = false;

		loop: for(int page = 1; page < 46;page++) {

			if(breakpoint) {break loop;}
			RestTemplate restTemplate = new RestTemplate(); 
			MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();
			params.add("page", "" + page);
			System.out.println("페이지 : " + page);
			HttpHeaders headers = new HttpHeaders();
			headers.add("Authorization", APIKEY);
			headers.add("Accept",MediaType.APPLICATION_JSON_UTF8_VALUE);
			headers.add("Content-Type", MediaType.APPLICATION_FORM_URLENCODED_VALUE + ";charser=UTF-8");

			String  query = URLEncoder.encode(keyword,"UTF-8");

			HttpEntity entity = new HttpEntity(params, headers); 

			URI foodurl=URI.create("https://dapi.kakao.com/v2/local/search/keyword.json?query="+query+"&"+"category_group_code=FD6&page="+page); 
			URI cafeurl=URI.create("https://dapi.kakao.com/v2/local/search/keyword.json?query="+query+"&"+"category_group_code=CE7&page="+page);

			String resp;

			RequestEntity<String> rq = new RequestEntity<>(headers, HttpMethod.GET, foodurl);
			RequestEntity<String> rq1 = new RequestEntity<>(headers, HttpMethod.GET, cafeurl);
			if(category.contentEquals("f")) {
				resp = restTemplate.postForObject(foodurl, rq, String.class);
				System.out.println("f");
			}else {
				resp = restTemplate.postForObject(cafeurl, rq1, String.class);
				System.out.println("c");
			}
			/*
			 * Map<String,String> respBody = new HashMap<String, String>();
			 * respBody.put("food",resp); respBody.put("cafe",resp2);
			 */
			System.out.println(page);

			System.out.println(resp);
			JsonObject obj = gson.fromJson(resp, JsonObject.class);
			JsonArray docs = obj.getAsJsonArray("documents");
			JsonObject meta = obj.getAsJsonObject("meta");
			JsonElement ele = meta.get("is_end");
			for(JsonElement doc : docs) {
				resultadd.add(doc);				
			}
			if(ele.getAsBoolean()) {breakpoint = true;}
		}
		result.add("documents", resultadd);
		String resp = result.toString();
		return resp;
	}
	// 수지 모임 수정 페이지 이동
	@RequestMapping("partymodify")
	public String partymodify(String seq, HttpServletRequest request)  throws Exception {
		PartyDTO content=pservice.selectBySeq(Integer.parseInt(seq));
		request.setAttribute("con",content);
		try {
			MemberDTO account = (MemberDTO) session.getAttribute("loginInfo");
			String age = account.getBirth();
			request.setAttribute("age", age);
		}catch(Exception e) {}
		return "/party/party_modify";
	}
	// 수지 모임 수정
	@RequestMapping("party_modifyProc")
	public String partymodifyProc(PartyDTO dto, HttpServletRequest request) throws Exception{
		String date = dto.getDate();
//		String time = dto.getTime();
		String dateAndtime = "";
//		if(time.length()==8) {
//			dateAndtime = date + " "+time+".0";
//		}else {
//			dateAndtime = date + " "+time+":00.0";
//		}
		dateAndtime = date+":00.0";
	//	System.out.println(date);
	//	System.out.println(time);
	//	System.out.println(dateAndtime);

		Timestamp meetdate = java.sql.Timestamp.valueOf(dateAndtime);
		dto.setMeetdate(meetdate);


		System.out.println(dto.getMeetdate());

		pservice.update(dto);
		return "redirect:/party/party_content?seq="+dto.getSeq();
	}
	// 수지 모임 삭제
	@RequestMapping("partydelete")
	public String partydelete(String seq)  throws Exception {
		pservice.delete(seq);
		return "redirect:/map/toMap";
	}
	// 수지 관리자의 모임 삭제?
	@RequestMapping("partydeleteByAdmin")
	public String partydeleteByAdmin(String seq)  throws Exception {
		pservice.delete(seq);
		return "redirect:/admin/toAdmin_party";
	}

	// 태훈 모임 리스트 페이지로 이동
	@RequestMapping("partylist")
	public String partyList(HttpServletRequest request) throws Exception {

		////////////////////////top 5 ///////////////////////////
		List<MapDTO> top = mapservice.selectTopStore();
		Map<Integer, Object> reviews = rservice.getReview(top);

		System.out.println(reviews.size());
		List<String> imgList2 = new ArrayList<>();
		for(int i=0; i<top.size(); i++) {

			imgList2.add(pservice.clew(top.get(i).getName()));
			System.out.println(i + " : " + top.get(i).getSeq() + " : "+imgList2.get(i));
			System.out.println(top.get(i).getName());
		}
		////////////////////////top 5 ///////////////////////////
		
		request.setAttribute("top", top);
		request.setAttribute("imglist2", imgList2);
		request.setAttribute("review", reviews);
		
		return "/party/party_list";
	}
	
	// 태훈 모임 리스트 출력
	@RequestMapping("getPartyList")
	public String getPartyList(HttpServletRequest request) throws Exception {

		int cpage=1;
		
		try {
			 cpage = Integer.parseInt(request.getParameter("cpage"));
		}catch(Exception e) {

		}
		
		List<PartyDTO> partyList = pservice.selectList(cpage);
		
		request.setAttribute("list", partyList);
		
		return "/include/party_list_include";
	}

	// 태훈 모임 통합 검색
	@RequestMapping(value="partysearch",  method = RequestMethod.POST)
	public String partySearch(HttpServletRequest request) throws Exception {
	
        JsonArray Jarr = JsonParser.parseString(request.getParameter("formData")).getAsJsonArray();
        Map<String, Object> map = new HashMap<>();
        List<String> ageList = new ArrayList<>();
        for(int i=0; i<Jarr.size();i++) {
        	if(Jarr.get(i).getAsJsonObject().get("name").getAsString().equals("age")) {
        		String age = Jarr.get(i).getAsJsonObject().get("value").getAsString();
        		ageList.add(age);
        	}else {
        		map.put(Jarr.get(i).getAsJsonObject().get("name").getAsString(), Jarr.get(i).getAsJsonObject().get("value").getAsString());
        	}
        }
        map.put("ageList", ageList);
        map.put("ageListSize", ageList.size());
        System.out.println(map.get("ageList"));
        System.out.println(map.get("ageList.size"));
        System.out.println(map.get("search") + ":" + map.get("search").getClass().getTypeName());
        System.out.println(map.get("text"));
        System.out.println(map);

        int cpage=1;
		
		try {
			 cpage = Integer.parseInt(request.getParameter("cpage"));
		}catch(Exception e) {

		}
		
		List<PartyDTO> partyList = pservice.partySearch(map , cpage);

		request.setAttribute("list", partyList);

		return "/include/party_list_include";
	}
	
	// 태훈 모임 내용 모달 창
	@RequestMapping(value="party_content_include")
	public String party_content_include(HttpServletRequest request) throws Exception {
		String seq = request.getParameter("seq");
		PartyDTO content = pservice.selectBySeq(Integer.parseInt(seq));		
		MemberDTO account = (MemberDTO) session.getAttribute("loginInfo");		
		String nickname = account.getNickname();
		
		
		boolean partyFullCheck = pservice.isPartyfull(seq);
		boolean partyParticipantCheck= pservice.isPartyParticipant(seq, nickname);
	
		PartyCountDTO pcdto = pservice.getPartyCounts(seq);
		
		request.setAttribute("con",content);
		request.setAttribute("party", pcdto);
		request.setAttribute("partyFullCheck", partyFullCheck);
		request.setAttribute("partyParticipantCheck", partyParticipantCheck);
		return "/include/party_content_include";
	}
	// 수지 모임 글 보기
	@RequestMapping(value="party_content")
	public String party_content(String seq, HttpServletRequest request) throws Exception {
		PartyDTO content=pservice.selectBySeq(Integer.parseInt(seq));
		String img = pservice.clew(content.getParent_name());
		MemberDTO account = (MemberDTO) session.getAttribute("loginInfo");
		String id = account.getId();
		String nickname = account.getNickname();
		boolean partyFullCheck = pservice.isPartyfull(seq);
		boolean partyParticipantCheck= pservice.isPartyParticipant(seq, nickname);
		System.out.println("멤버인가?" + partyParticipantCheck);
		if(partyParticipantCheck) {
			request.setAttribute("participant", 1);
		}
		
		PartyCountDTO pcdto = pservice.getPartyCounts(seq);
		
		SimpleDateFormat formatter = new SimpleDateFormat ("yyyy-MM-dd hh:mm:ss");
		Calendar cal = Calendar.getInstance();
		String today = null;
		today = formatter.format(cal.getTime());
		Timestamp ts = Timestamp.valueOf(today);

		Timestamp deadln = content.getDeadline();
		String partylife = "";
		System.out.println("오늘날짜" + ts);
		System.out.println("마감날짜" + deadln);
		if(ts.compareTo(deadln)>0) {
			partylife="dead";
		}else {
			partylife="alive";
		}
			
			
		request.setAttribute("partylife", partylife);
		request.setAttribute("img", img);
		request.setAttribute("con",content);
		request.setAttribute("party", pcdto);
		request.setAttribute("account", account);
		request.setAttribute("partyFullCheck", partyFullCheck);
		request.setAttribute("partyParticipantCheck", partyParticipantCheck);
		return "/party/party_content";
	}
	// 수지 모임  참여
	@RequestMapping(value="partyJoin")
	public String partyJoin(String seq, HttpServletRequest request, RedirectAttributes redirectAttributes) throws Exception {
		MemberDTO mdto = (MemberDTO) session.getAttribute("loginInfo");
		String nickname = mdto.getNickname();
		
		
		int block=pservice.userBlockedConfirm(nickname, Integer.parseInt(seq));
		
		if(block>0) {
			return "error/BlockJoin";
		}

		System.out.println(seq);
		System.out.println(nickname);
		
		boolean partyFullCheck = pservice.isPartyfull(seq);
		boolean partyParticipantCheck= pservice.isPartyParticipant(seq, nickname);
		
		//모임 참여
		if(!partyFullCheck && !partyParticipantCheck) {
			pservice.partyJoin(seq, nickname);
		}else {
			return "error/partyJoin";
		}
		
		//모임참여 후 참가인원수 확인
		boolean AfterpartyFullCheck = pservice.isPartyfull(seq);
		//참가인원이 다 차면 모집종료처리
		if(AfterpartyFullCheck) {
			pservice.stopRecruit(seq);
		}
		boolean AfterpartyParticipantCheck= pservice.isPartyParticipant(seq, nickname);
		
		PartyDTO content=pservice.selectBySeq(Integer.parseInt(seq));
		
		Map<String,String> partyCheck = new HashMap<>();
		
		
		/*
		 * //redirectAttributes.addAttribute("con",content);
		 * redirectAttributes.addAttribute("partyFullCheck", AfterpartyFullCheck);
		 * redirectAttributes.addAttribute("partyParticipantCheck",
		 * AfterpartyParticipantCheck);
		 */
		request.setAttribute("partyFullCheck", AfterpartyFullCheck);
		request.setAttribute("partyParticipantCheck", AfterpartyParticipantCheck);
		return "redirect:/party/party_content?seq=" + content.getSeq();
		
	}

	// 수지 모집종료 기능
	@RequestMapping("stopRecruit")
	public String stopRecruit(String seq, String writer) throws Exception {
		MemberDTO account = (MemberDTO) session.getAttribute("loginInfo");
		String nickname = account.getNickname();
		if(nickname.contentEquals(writer)) {
		pservice.stopRecruit(seq);
		return "redirect:/party/party_content?seq="+seq;
		}else {
			return "/error/writerpermition";
		}
	}
	
	// 수지 모집 재시작 기능
	@RequestMapping("restartRecruit")
	public String restartRecruit(String seq, String writer) throws Exception {
		MemberDTO account = (MemberDTO) session.getAttribute("loginInfo");
		String nickname = account.getNickname();
		if(nickname.contentEquals(writer)) {
		pservice.restartRecruit(seq);
		return "redirect:/party/party_content?seq="+seq;
		}else {
			return "/error/writerpermition";
		}
	}
	
	// 수지 모임 나가기 기능
	@RequestMapping("toExitParty")
	public String exitParty(String seq) throws Exception{
		MemberDTO account = (MemberDTO) session.getAttribute("loginInfo");
		String nickname = account.getNickname();
		
		cservice.exitChatRoom(nickname, Integer.parseInt(seq));
		boolean isPartyfull = pservice.isPartyfull(seq);
		if(!isPartyfull) {
			System.out.println("hello it's me");
			pservice.restartRecruit(seq);
		}
		
		PartyDTO content=pservice.selectBySeq(Integer.parseInt(seq));
		if(nickname == content.getWriter()) {
			this.partydelete(seq);
		}
		return "redirect:/party/party_content?seq="+seq;
		
	}
	
	// 지은 작성자 별 모임 리스트
	@RequestMapping("selectByWriter")
	public ModelAndView selectByWriter(int mcpage) throws Exception{
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("member/mypage_chatlist");

		if(mcpage==0) {
			mcpage=1;
		}

		MemberDTO mdto = (MemberDTO) session.getAttribute("loginInfo");
		String nickname = mdto.getNickname();
		
		List<PartyDTO> partyList = pservice.selectByWriterPage(nickname, mcpage);
		String navi = pservice.getMyPageNav(mcpage, nickname);
		System.out.println("내 모임 개수 : " + partyList.size());
		mav.addObject("partyList", partyList);
		mav.addObject("navi", navi);

		return mav;
	}
	
	// 파티리스트로 이동
	@RequestMapping("toPartylist")
	public String toPartylist() throws Exception{
		return "redirect:/party/partylist";
	}
	// 이미지 클롤링
	@ResponseBody
	@RequestMapping(value="clewimg", produces="text/plain;charset=UTF-8")
	public String clewimg(String parent_name)  throws Exception {
		System.out.println("상점이름" + parent_name);
		String imgaddr = pservice.clew(parent_name);
		System.out.println("이미지 주소 " + imgaddr);
		return imgaddr;
	}
	// 태훈 모임 신고
	@RequestMapping("party_report")
	public String partyReport(HttpServletRequest request,RedirectAttributes redirectAttributes)  throws Exception {
		MemberDTO mdto = (MemberDTO) session.getAttribute("loginInfo");
		String id = mdto.getNickname();

		
		String report_id = request.getParameter("report_id");
		int seq = Integer.parseInt(request.getParameter("seq"));
		if(id.equals(report_id)) {
			 
			return "redirect:/party/party_content?seq="+seq;
		}
		Timestamp stamp = new Timestamp(System.currentTimeMillis());
		redirectAttributes.addFlashAttribute("rdto", new ReportDTO(0,1,id,report_id,request.getParameter("title"),request.getParameter("content"),stamp,seq,0));
		
		return "redirect:/report/newReport/";
	}

	// By 예지 - 모임글 관리 페이지에서 선택한 
	@ResponseBody
	@RequestMapping("partyDeleteCheckList")
	public int partyDeleteCheckList(HttpServletRequest request) throws Exception{
		String data = request.getParameter("seqs"); 
		String ids = data.substring(2,data.length()-2);
		String[] checkList = ids.split("\",\"");

		System.out.println("삭제 선택한 리뷰 수 : " + checkList.length);

		for(int a = 0; a<checkList.length;a++) {
			System.out.println(checkList[a]);
		}
		int resp = pservice.deleteCheckList(checkList);
		System.out.println("삭제된 리뷰 수 : " + resp);
		return resp;
	}

}
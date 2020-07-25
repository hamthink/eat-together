package coma.spring.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.Reader;
import java.net.URI;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

import coma.spring.dto.MapDTO;
import coma.spring.dto.MemberDTO;
import coma.spring.dto.PartyDTO;
import coma.spring.dto.ReviewDTO;
import coma.spring.dto.ReviewFileDTO;
import coma.spring.service.MapService;
import coma.spring.service.PartyService;
import coma.spring.service.ReviewService;

@Controller
@RequestMapping("/map/")
public class MapController {

	private static final String HOST = "https://dapi.kakao.com";

	@Autowired
	private MapService mapservice;
	@Autowired
	private PartyService pservice;
	@Autowired
	private ReviewService rservice;
	@Autowired
	private ServletContext sc;
	@Autowired
	private HttpSession session;

	@RequestMapping("toMap")
	public String map(HttpServletRequest request, HttpServletResponse response) throws Exception{
		// 등록된 맛집 뿌려주기
		List<MapDTO> list = mapservice.selectAll();
		Gson gson = new Gson();
		int cpage = 1;
		try {cpage = Integer.parseInt(request.getParameter("cpage"));}catch(Exception e) {}
		int place_id = 0;
		try{place_id = Integer.parseInt(request.getParameter("place_id"));}catch(Exception e) {}
		String object = gson.toJson(list);
		String jsonPath = sc.getRealPath("resources/json/mapData.json");
		File file = new File(jsonPath);
		FileWriter fw = new FileWriter(file, false);
		JsonArray arr = gson.fromJson(object, JsonArray.class);
		List<MapDTO> toplist = mapservice.selectTop5();
		for(JsonElement ele : arr) {
			JsonObject obj = ele.getAsJsonObject();
			int result = mapservice.selectPartyOn(obj.get("place_id").getAsInt());
			obj.addProperty("partyOn", result);
			for(MapDTO mapdto : toplist) {
				if(obj.get("place_id").getAsInt() == mapdto.getPlace_id()) {
					obj.addProperty("top", 1);
				}
			}
		}
		fw.write(arr.toString());
		fw.flush();
		fw.close();
		response.setHeader("cache-control","no-cache,no-store");
		if(session.getAttribute("loginInfo")==null) {
			int count = pservice.selectAllCount();
			request.setAttribute("partyAllCount", count);
		}
		return "/map/map";
	}
	@ResponseBody
	@RequestMapping(value="search",produces="application/json;charset=utf8",method=RequestMethod.GET)
	public String searchByKeyword(String keyword, HttpServletRequest req) throws Exception{
		String cafePath = sc.getRealPath("resources/json/cafe.json");
		Gson gson = new Gson();
		JsonArray cafeArr = new JsonArray();
		JsonObject respObj = new JsonObject();
		List<MapDTO> list = mapservice.searchByKeyword(keyword);
		JsonArray maplist = gson.fromJson(gson.toJson(list), JsonArray.class);
		for(JsonElement ele : maplist) {
			JsonObject obj = ele.getAsJsonObject();
			int result = mapservice.selectPartyOn(obj.get("place_id").getAsInt());
			obj.addProperty("partyOn", result);
		}
		respObj.add("map_list", maplist);
		File cafeFile = new File(cafePath);
		if(cafeFile.exists()) {
			Reader reader = new FileReader(cafePath);
			JsonObject readObj = gson.fromJson(reader, JsonObject.class);
			if(readObj != null) {
				JsonArray arr = (JsonArray)readObj.get("cafe_list");
				for(JsonElement ele : arr) { // cafe_list 에서 cafe 정보 빼오기
					boolean addPossible = true;
					JsonObject cafeObj = ele.getAsJsonObject();
					JsonObject cafe = cafeObj.get("cafe").getAsJsonObject();
					String place_name = cafe.get("place_name").getAsString();
					if(place_name.contains(keyword)) { 
						loop:for(JsonElement map : maplist) { // maplist 에서 map 꺼내기
							JsonObject mapObj = map.getAsJsonObject();
							String id = cafe.get("id").getAsString(); // id 비교 ~~ 
							String map_id = mapObj.get("place_id").getAsString();
							if(id.equals(map_id)) {
								addPossible = false;
								break loop;
							}
						}
					if(addPossible) {cafeArr.add(cafe);}
					}
				}
				respObj.add("cafe_list", cafeArr);
			}
		}

		String foodPath = sc.getRealPath("resources/json/food.json");
		JsonArray foodArr = new JsonArray();
		File foodFile = new File(foodPath);
		if(foodFile.exists()) {
			Reader reader = new FileReader(foodPath);
			JsonObject readObj = gson.fromJson(reader, JsonObject.class);
			if(readObj != null) {
				JsonArray arr = (JsonArray)readObj.get("food_list");
				boolean addPossible = true;
				for(JsonElement ele : arr) {
					JsonObject foodObj = ele.getAsJsonObject();
					JsonObject food = foodObj.get("food").getAsJsonObject();
					String place_name = food.get("place_name").getAsString();
					if(place_name.contains(keyword)) { 
						loop:for(JsonElement map : maplist) {
							JsonObject mapObj = map.getAsJsonObject();
							String id = food.get("id").getAsString();
							String map_id = mapObj.get("place_id").getAsString();
							if(id.equals(map_id)) {
								addPossible = false;
								break loop;
							}
						}
					if(addPossible) {foodArr.add(food);}
					}
				}
				respObj.add("food_list", foodArr);
			}
		}
		String respBody =  gson.toJson(respObj);
		return respBody;
	}

	@ResponseBody
	@RequestMapping(value="searchCafeBtn",produces="application/json;charset=utf8",method=RequestMethod.GET)
	public String searchByCafe(HttpServletRequest req) throws Exception{
		String cafePath = sc.getRealPath("resources/json/cafe.json");
		Gson gson = new Gson();
		JsonArray cafeArr = new JsonArray();
		JsonObject respObj = new JsonObject();

		List<MapDTO> list = mapservice.searchByCategory("카페");
		JsonArray maplist = gson.fromJson(gson.toJson(list), JsonArray.class);
		for(JsonElement ele : maplist) {
			JsonObject obj = ele.getAsJsonObject();
			int result = mapservice.selectPartyOn(obj.get("place_id").getAsInt());
			obj.addProperty("partyOn", result);
		}
		respObj.add("map_list", maplist);

		File cafeFile = new File(cafePath);
		if(cafeFile.exists()) {
			Reader reader = new FileReader(cafePath);
			JsonObject readObj = gson.fromJson(reader, JsonObject.class);
			JsonArray arr = (JsonArray)readObj.get("cafe_list");
			for(JsonElement ele : arr) {
				boolean addPossible = true;
				JsonObject cafeObj = ele.getAsJsonObject();
				JsonObject cafe = cafeObj.get("cafe").getAsJsonObject();
				loop:for(JsonElement map : maplist) {
					JsonObject mapObj = map.getAsJsonObject();
					String id = cafe.get("id").getAsString();
					String map_id = mapObj.get("place_id").getAsString();
					if(id.equals(map_id)) {
						addPossible = false;
						break loop;
					}
				}
				if(addPossible) {cafeArr.add(cafe);};
			}
			respObj.add("cafe_list", cafeArr);
		}

		String respBody =  gson.toJson(respObj);
		return respBody;
	}
	@ResponseBody
	@RequestMapping(value="searchFoodBtn",produces="application/json;charset=utf8",method=RequestMethod.GET)
	public String searchByFood(HttpServletRequest req) throws Exception{
		Gson gson = new Gson();
		JsonObject respObj = new JsonObject();
		List<MapDTO> list = mapservice.searchByCategory("음식점");
		JsonArray maplist = gson.fromJson(gson.toJson(list), JsonArray.class);
		for(JsonElement ele : maplist) {
			JsonObject obj = ele.getAsJsonObject();
			int result = mapservice.selectPartyOn(obj.get("place_id").getAsInt());
			obj.addProperty("partyOn", result);
		}
		respObj.add("map_list", maplist);

		String foodPath = sc.getRealPath("resources/json/food.json");
		JsonArray foodArr = new JsonArray();

		File foodFile = new File(foodPath);
		if(foodFile.exists()) {
			Reader reader = new FileReader(foodPath);
			JsonObject readObj = gson.fromJson(reader, JsonObject.class);
			JsonArray arr = (JsonArray)readObj.get("food_list");
			for(JsonElement ele : arr) {
				boolean addPossible = true;
				JsonObject foodObj = ele.getAsJsonObject();
				JsonObject food = foodObj.get("food").getAsJsonObject();
				loop:for(JsonElement map : maplist) {
					JsonObject mapObj = map.getAsJsonObject();
					String id = food.get("id").getAsString();
					String map_id = mapObj.get("place_id").getAsString();
					if(id.equals(map_id)) {
						addPossible = false;
						break loop;
					}
				}
				if(addPossible) {foodArr.add(food);}
			}
			respObj.add("food_list", foodArr);
		}
		String respBody =  gson.toJson(respObj);
		return respBody;
	}

	@ResponseBody
	@RequestMapping(value="cafeInsert",produces="application/json;charset=utf8",method=RequestMethod.GET)
	public String insertKakaoCafeData(String lng, String lat, HttpServletResponse response) throws Exception {
		response.setHeader("cache-control","no-cache,no-store");
		return insertJson("resources/json/cafe.json","CE7",lng,lat);
	}

	@ResponseBody
	@RequestMapping(value="foodInsert",produces="application/json;charset=utf8",method=RequestMethod.GET)
	public String insertKakaoFoodData(String lng, String lat, HttpServletResponse response) throws Exception {
		response.setHeader("cache-control","no-cache,no-store");
		return insertJson("resources/json/food.json","FD6",lng,lat);
	}

	public String insertJson(String path, String category_code, String lng, String lat) throws Exception {

		// 초기 설정
		String list_name = null;
		String category_name = null;
		if(category_code.equals("FD6")) {
			list_name = "food_list";
			category_name = "food";
		}else if(category_code.equals("CE7")) {
			list_name = "cafe_list";
			category_name = "cafe";
		}

		String jsonPath = sc.getRealPath(path);
		// 다음 지도 API 에서 값 json 파일로 저장하는 native 코드
		// 중심 좌표를 기준으로 카테고리별 데이터 넣는 로직
		Gson gson = new Gson();
		JsonObject respObj = new JsonObject();
		JsonArray respArr = new JsonArray();
		String respBody = null;

		File file = new File(jsonPath);
		if(!file.exists()) {
			file.getParentFile().mkdirs(); // Will create parent directories if not exists
			file.createNewFile();
			FileOutputStream s = new FileOutputStream(file,false);
		}
		// if문 : json 파일 read - 일치하는 값은 제외하고 입력!
		Reader reader = new FileReader(jsonPath);
		JsonObject readObj = gson.fromJson(reader, JsonObject.class);
		// 페이지별 값 가져오기
		JsonArray inputArr = new JsonArray();
		loop: for(int page = 1; page < 46;page++) {
			// 페이지마다 카테고리별 검색 진행 
			RestTemplate restTemplate = new RestTemplate();
			MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();
			params.add("x", lng);
			params.add("y", lat);
			params.add("category_group_code", category_code);
			params.add("radius", "20000");
			params.add("page", "" + page);
			HttpHeaders headers = new HttpHeaders();
			headers.add("Authorization", "KakaoAK " + "e156322dd35cfd9dc276f1365621ae9a");
			headers.add("Accept",MediaType.APPLICATION_JSON_UTF8_VALUE);
			headers.add("Content-Type", MediaType.APPLICATION_FORM_URLENCODED_VALUE + ";charser=UTF-8");

			HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);
			respBody = restTemplate.postForObject(new URI(HOST + "/v2/local/search/category.json"), request, String.class);

			if(readObj == null) { // json 파일이 비어있을 때 
				// 입력 진행
				JsonObject obj = gson.fromJson(respBody, JsonObject.class);
				JsonArray docs = obj.getAsJsonArray("documents");
				for(JsonElement doc: docs) { 
					JsonObject place_info = doc.getAsJsonObject();
					JsonObject place_obj = new JsonObject();
					place_obj.add(category_name, place_info);
					respArr.add(place_obj);
					respObj.add(list_name, respArr);
				}
				String resp = gson.toJson(respObj);
				FileWriter fw = new FileWriter(file, true);
				// 이어서 입력되도록 하기 ( read 해서 추가되도록 ) 
				fw.write(resp);
				fw.flush();
				fw.close();
				break;
			}else { // json 파일이 비어있지 않을 때
				JsonArray readArr = (JsonArray) readObj.get(list_name);
				List<String> existIds = new ArrayList<>();
				for(JsonElement readEle : readArr) { // 첫 번째 for문 (파일에 있는 맛집 반복해서 꺼냄) 
					JsonObject read_obj = (JsonObject) readEle.getAsJsonObject().get(category_name);
					String id = read_obj.get("id").toString(); // 이미 파일에 있는 아이디
					existIds.add(id);
				}
				JsonObject obj = gson.fromJson(respBody, JsonObject.class);
				JsonArray docs = obj.getAsJsonArray("documents");
				for(JsonElement doc: docs) { // 두 번째 for문 (입력할 맛집 반복해서 꺼냄)
					String inputId = doc.getAsJsonObject().get("id").toString();
					boolean insertable = true;
					for(String id : existIds) { // 이미 파일에 있는 아이디들과 비교
						if(id.equals(inputId)) {
							insertable = false; // 하나라도 있으면 입력 불가능
						}
					}
					if(insertable) {
						// 입력 진행
						JsonObject place_info = doc.getAsJsonObject();
						JsonObject insert_obj = new JsonObject();
						insert_obj.add(category_name, place_info);
						readArr.add(insert_obj); // 기존 배열에 추가
						inputArr.add(place_info);
					}
				}
				// 마지막 페이지인지 판단
				JsonObject meta = obj.getAsJsonObject("meta");
				JsonElement ele = meta.get("is_end");
				readObj.add(list_name, readArr);
				String resp = gson.toJson(readObj); 
				FileWriter fw = new FileWriter(file, false); // false : 새로 입력
				fw.write(resp);
				fw.flush();
				fw.close();
				if(!ele.getAsBoolean()) {continue loop;}
				else{break loop;}
			}
		}
		String inputResult = gson.toJson(inputArr);
		return inputResult;
	}

	@RequestMapping(value="selectMarkerInfo",method=RequestMethod.GET)
	public String selectMarkerInfo(String place_id, HttpServletRequest request) throws Exception{
		int cpage = 1;
		try {cpage = Integer.parseInt(request.getParameter("cpage"));}catch(Exception e) {}
		int id = Integer.parseInt(place_id);
		MapDTO mapdto = mapservice.selectOne(id);
//		mapservice.updateRatingAvg(mapdto.getSeq());
		// 진행중인 모임이 있다면 모임도 같이 보내준다.
		int pcount = mapservice.selectPartyOn(id);
		List<PartyDTO> plist = pservice.selectByPageNo(cpage, id);
		String navi = pservice.getPageNavi(cpage, id);
		// request
		request.setAttribute("mapdto", mapdto);
		request.setAttribute("partyCount", pcount);
		MemberDTO account = (MemberDTO) session.getAttribute("loginInfo");
		String nickname = null;
		try{nickname = account.getNickname();}catch(Exception e) {return "error/loginPlease";}
		Map<PartyDTO, Map<String, Object>> pMap = new LinkedHashMap<>();
		for(PartyDTO pdto : plist) {
			Map<String, Object> pCheckInfoMap = new LinkedHashMap<>();
			boolean partyFullCheck = pservice.isPartyfull(String.valueOf(pdto.getSeq()));
			boolean partyParticipantCheck= pservice.isPartyParticipant(String.valueOf(pdto.getSeq()), nickname);
			pCheckInfoMap.put("partyFullCheck", partyFullCheck);
			pCheckInfoMap.put("partyParticipantCheck", partyParticipantCheck);
			SimpleDateFormat formatter = new SimpleDateFormat ("yyyy-MM-dd hh:mm:ss");
			Calendar cal = Calendar.getInstance();
			String today = null;
			today = formatter.format(cal.getTime());
			Timestamp ts = Timestamp.valueOf(today);
			Timestamp deadln = pdto.getDeadline();
			String partylife = "";
			if(ts.compareTo(deadln)>0) {
				partylife="dead";
			}else {
				partylife="alive";
			}
			pCheckInfoMap.put("partylife", partylife);
			pMap.put(pdto, pCheckInfoMap);
		}
		request.setAttribute("partyMap", pMap);
		request.setAttribute("partyList", plist);
		request.setAttribute("navi", navi);
		request.setAttribute("markerlat", mapdto.getLat());
		request.setAttribute("markerlng", mapdto.getLng());
		request.setAttribute("parent_seq", mapdto.getSeq());
		if(pcount <= 0) { // 파티가 없을 경우
			request.setAttribute("img", pservice.clew(mapdto.getName()));
		}else { // 파티가 하나라도 있을 경우
			PartyDTO content = pservice.selectBySeq(plist.get(0).getSeq()); // 글번호로 PartyDTO 불러오기 
			request.setAttribute("img", content.getImgaddr());
			request.setAttribute("con",content);
		}
		Map<ReviewDTO,ReviewFileDTO> rmap = new LinkedHashMap<>();
		List<ReviewDTO> rlist = rservice.selectByPseq(mapdto.getSeq());
		for(ReviewDTO rdto : rlist) {
			ReviewFileDTO rf = rservice.selectFileByPseq(rdto.getSeq());
			rmap.put(rdto, rf);
		}
		request.setAttribute("reviewMap", rmap);
		if(session.getAttribute("loginInfo")==null) {
			request.setAttribute("partyAllCount", pservice.selectAllCount());
		}
		return "map/map";
	}

	@ResponseBody
	@RequestMapping(value="selectKakaoMarkerInfo",produces="application/json;charset=utf8")
	public String selectKakaoMarkerInfo(String category,int place_id,HttpServletRequest request) throws Exception{ // 예지 : 아직 MAP 테이블에 등록되지 않은 마커 클릭했을 때 AJAX로 정보 출력
		Gson gson = new Gson();
		JsonObject respObj = new JsonObject();
		if(category.contentEquals("카페")) {
			String cafePath = sc.getRealPath("resources/json/cafe.json");
			File cafeFile = new File(cafePath);
			if(cafeFile.exists()) {
				Reader reader = new FileReader(cafePath);
				JsonObject readObj = gson.fromJson(reader, JsonObject.class);
				JsonArray arr = (JsonArray)readObj.get("cafe_list");
				for(JsonElement ele : arr) {
					JsonObject obj = ele.getAsJsonObject();
					int id = obj.get("cafe").getAsJsonObject().get("id").getAsInt();
					if(id == place_id) {
						respObj.add("result", obj.get("cafe"));
					}
				}
			}

		}else if(category.contentEquals("음식점")) {
			String foodPath = sc.getRealPath("resources/json/food.json");
			File foodFile = new File(foodPath);
			if(foodFile.exists()) {
				Reader reader = new FileReader(foodPath);
				JsonObject readObj = gson.fromJson(reader, JsonObject.class);
				JsonArray arr = (JsonArray)readObj.get("food_list");
				for(JsonElement ele : arr) {
					JsonObject obj = ele.getAsJsonObject();
					int id = obj.get("food").getAsJsonObject().get("id").getAsInt();
					if(id == place_id) {
						respObj.add("result", obj.get("food"));
					}
				}
			}

		}
		return gson.toJson(respObj);
	}

	@ResponseBody
	@RequestMapping(value="getPartyInfo",produces="application/json;charset=utf8")
	public String getPartyInfo(int seq, boolean partyFullCheck, boolean partyParticipantCheck, String partylife) throws Exception{
		Gson gson = new Gson();
		JsonObject respObj = new JsonObject();
		PartyDTO pdto = pservice.selectBySeq(seq);
		String jsondto = gson.toJson(pdto);
		MemberDTO mdto = (MemberDTO) session.getAttribute("loginInfo");
		String jsonmdto = gson.toJson(mdto);
		respObj.add("mdto", gson.fromJson(jsonmdto, JsonElement.class));
		respObj.add("pdto", gson.fromJson(jsondto, JsonElement.class));
		respObj.add("partyFullCheck", gson.fromJson(String.valueOf(partyFullCheck),JsonElement.class));
		respObj.add("partyParticipantCheck", gson.fromJson(String.valueOf(partyParticipantCheck),JsonElement.class));
		respObj.add("partylife", gson.fromJson(partylife, JsonElement.class));
		return gson.toJson(respObj);
	}

	@ResponseBody
	@RequestMapping(value="chooseMapInfo",produces="application/json;charset=utf8")
	public String chooseMapInfo(int place_id) throws Exception{
		List<MapDTO> mapdto = mapservice.searchByPlace_id(place_id);
		Gson gson = new Gson();
		return gson.toJson(mapdto);
	}

	@ResponseBody
	@RequestMapping(value="chooseCafeInfo",produces="application/json;charset=utf8")
	public String chooseCafeInfo(int place_id) throws Exception{
		String cafePath = sc.getRealPath("resources/json/cafe.json");
		Gson gson = new Gson();
		JsonObject respObj = new JsonObject();
		File cafeFile = new File(cafePath);
		if(cafeFile.exists()) {
			Reader reader = new FileReader(cafePath);
			JsonObject readObj = gson.fromJson(reader, JsonObject.class);
			JsonArray arr = (JsonArray)readObj.get("cafe_list");
			for(JsonElement ele : arr) {
				JsonObject obj = ele.getAsJsonObject();
				int id = obj.get("cafe").getAsJsonObject().get("id").getAsInt();
				if(id == place_id) {
					respObj.add("result", obj);
				}
			}
		}
		String respBody = gson.toJson(respObj);
		return respBody;
	}
	@ResponseBody
	@RequestMapping(value="chooseFoodInfo",produces="application/json;charset=utf8")
	public String chooseFoodInfo(int place_id) throws Exception{
		String foodPath = sc.getRealPath("resources/json/food.json");
		Gson gson = new Gson();
		JsonObject respObj = new JsonObject();
		File foodFile = new File(foodPath);
		if(foodFile.exists()) {
			Reader reader = new FileReader(foodPath);
			JsonObject readObj = gson.fromJson(reader, JsonObject.class);
			JsonArray arr = (JsonArray)readObj.get("food_list");
			for(JsonElement ele : arr) {
				JsonObject obj = ele.getAsJsonObject();
				int id = obj.get("food").getAsJsonObject().get("id").getAsInt();
				if(id == place_id) {
					respObj.add("result", obj);
				}
			}
		}
		String respBody = gson.toJson(respObj);
		return respBody;
	}
	// 예지 : 지도 페이지에서 모임글 작성 페이지 이동 : 존재하지 않는 맛집 ( #recruit 버튼 진입 )
	@RequestMapping(value="toParty_New",method=RequestMethod.GET,produces="application/json;charset=utf8")
	public String toPartyNew(HttpServletRequest request, MapDTO mapdto) {
		try {
			MemberDTO account = (MemberDTO) session.getAttribute("loginInfo");
			//String userid= account.getId();
			String nickName = null;
			try{nickName = account.getNickname();}catch(Exception e) {return "error/loginPlease";}
			int gender = account.getGender();
			//계정당 활성화된 모임 체크
			//int myPartyCount = pservice.getMadePartyCount(userid);
			int myPartyCount = pservice.getMadePartyCount(nickName);
			if(myPartyCount>4) {
				return "error/partyfull";
			}
			String age = account.getBirth();
			request.setAttribute("gender", gender);
			request.setAttribute("age", age);
			// 장소명, 지번 주소 값 전달 
			request.setAttribute("parent_name", mapdto.getName());
			request.setAttribute("parent_address", mapdto.getAddress());
			// 크롤링 작업
			String imgaddr = pservice.clew(mapdto.getName());
			request.setAttribute("img", imgaddr);
			
			request.setAttribute("place_id", mapdto.getPlace_id());
			request.setAttribute("lat", mapdto.getLat());
			request.setAttribute("lng", mapdto.getLng());
			request.setAttribute("category", mapdto.getCategory());
			request.setAttribute("phone", mapdto.getPhone());
			request.setAttribute("road_address", mapdto.getRoad_address());
			request.setAttribute("place_url", mapdto.getPlace_url());
			request.setAttribute("mdto", mapdto);
		}catch(Exception e) {}
		return "/party/party_new";
	}
	// 예지 : 지도 페이지에서 모임글 작성 페이지 이동 : 이미 존재하는 맛집 ( #mapRecruit 버튼 진입 )
	@RequestMapping(value="mapToParty_New",method=RequestMethod.GET)
	public String mapToParty_New(HttpServletRequest request, String parent_name, String parent_address, String img, String place_id, String category) {
		try {
			MemberDTO account = (MemberDTO) session.getAttribute("loginInfo");
			String userid = null;
			int gender = 0;
			String age = null;
			try {
				userid= account.getId();
				gender = account.getGender();
				age = account.getBirth();
			}catch(Exception e) {
				return "error/loginPlease";
			}
			//계정당 활성화된 모임 체크
			int myPartyCount = pservice.getMadePartyCount(userid);
			if(myPartyCount>4) {
				return "error/partyfull";
			}
			request.setAttribute("gender", gender);
			request.setAttribute("age", age);
			// 장소명, 지번 주소 값 전달 
			
			request.setAttribute("parent_name", parent_name);
			request.setAttribute("parent_address", parent_address);
			request.setAttribute("img", img);
			MapDTO mdto = mapservice.selectOne(Integer.parseInt(place_id));
			request.setAttribute("mdto", mdto);
		}catch(Exception e) {}
		return "/party/party_new";
	}
}

package coma.spring.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import coma.spring.dto.PartyCountDTO;
import coma.spring.dto.PartyDTO;
import coma.spring.statics.PartyConfiguration;


@Repository
public class PartyDAO {

	@Autowired
	private SqlSessionTemplate mybatis;
	
	// 수지 모임 다음 시퀀스
	public int getNextVal() {
		return mybatis.selectOne("Party.getNextval");
	}
	// 수지 모임 생성
	public int insert(PartyDTO dto) {
		return mybatis.insert("Party.insert",dto);
	}
	// 수지 계정당 모임 생성수 확인
	public int getMadePartyCount(String writer) throws Exception{
		return mybatis.selectOne("Party.getMadePartyCount",writer);
	}
	// 수지 파티 참가
	public int partyJoin(String seq, String nickname) throws Exception{
		Map<String, String> param = new HashMap<>();
			      param.put("seq", seq);
			      param.put("nickname", nickname);
		return mybatis.insert("Party.partyJoin",param);
	}
	//수지 파티 정원초과 확인
	public Boolean isPartyfull(String seq) throws Exception {
		int limit = mybatis.selectOne("Party.getPartyCount",seq);
		int nowCount= mybatis.selectOne("Party.getParticipantCount",seq);
		
		if(nowCount<limit) {
			return false;
		}else {
			return true;
		}
	}
	//수지 파티 참가인인지 확인
	public Boolean isPartyParticipant(String seq, String nickname) throws Exception{
		Map<String, String> param = new HashMap<>();
	      param.put("seq", seq);
	      param.put("nickname", nickname);
	      int check = mybatis.selectOne("Party.isPartyParticipant",param);
	      
	      if(check>0) {
	    	  return true;
	      }else {
	    	  return false;
	      }
	}
	
	// 수지 모임 삭제
	public int delete(String seq) throws Exception{
		return mybatis.delete("Party.delete",seq);
	}
	// 수지 모임 내용
	public PartyDTO selectBySeq(int seq) throws Exception{
		return mybatis.selectOne("Party.selectBySeq",seq);
	} 
	// 수지 모임 수정
	public int update(PartyDTO dto) throws Exception{
		//		 Map<String, String> param = new HashMap<>();
		//	      param.put("columnName1", "title");
		//	      param.put("changeValue1", dto.getTitle());
		//	      param.put("columnName2", "contents");
		//	      param.put("changeValue2", dto.getContents());
		//	      param.put("targetColumn", "seq");
		//	      param.put("targetValue", Integer.toString(dto.getSeq()));
		//	      
		//	      System.out.println(param.size());
		//	      
		//		return mybatis.update("Board.update",param);

		return mybatis.update("Party.update",dto);
	}
	// 예지 장소 아이디 별 모임 갯수
	public int getArticleCount(int place_id) throws Exception{
		return mybatis.selectOne("Party.getArticleCount", place_id);
	}
	// 예지 장소 아이디 별 모임 리스트
	public List<PartyDTO> selectByPageNo(int cpage, int place_id) throws Exception{
		int start = cpage * PartyConfiguration.RECORD_COUNT_PER_PAGE - (PartyConfiguration.RECORD_COUNT_PER_PAGE-1);
		int end = start + (PartyConfiguration.RECORD_COUNT_PER_PAGE-1);
		Map<String, Integer> param = new HashMap<>();
		param.put("start", start);
		param.put("end", end);
		param.put("place_id", place_id);
		return mybatis.selectList("Party.selectByPageNo",param);
	}
	// 수지 모집종료 기능
	public int stopRecruit(String seq) throws Exception {
		return mybatis.update("Party.stopRecruit",seq);
	}
	// 예지 모임 전체 갯수
	public int selectAllCount() throws Exception{
		return mybatis.selectOne("Party.selectAllCount");
	}
	// 태훈 모임 리스트 뽑기 네비 포함
	public List<PartyDTO> selectList(int cpage) {
		int start = cpage * PartyConfiguration.SEARCH_COUNT_PER_PAGE - (PartyConfiguration.SEARCH_COUNT_PER_PAGE-1);
		int end = start + (PartyConfiguration.SEARCH_COUNT_PER_PAGE-1);
		Map<String, Integer> param = new HashMap<>();
		param.put("start", start);
		param.put("end", end);
		return mybatis.selectList("Party.selectList" ,param);
	}
	// 태훈 열려있는 모임 전체 갯수
	public int getListCount() {
		return mybatis.selectOne("Party.getListCount");
	}
	// 태훈 모임 통합 검색
//	public List<PartyDTO> partySearch(Map<String, Object> param){	
//		return mybatis.selectList("Party.partySearch", param);
//	}
	// 태훈 모임 통합 검색
	public List<PartyDTO> partySearch(Map<String, Object> param, int cpage){
		int start = cpage * PartyConfiguration.SEARCH_COUNT_PER_PAGE - (PartyConfiguration.SEARCH_COUNT_PER_PAGE-1);
		int end = start + (PartyConfiguration.SEARCH_COUNT_PER_PAGE-1);	
		param.put("start", start);
		param.put("end", end);
		System.out.println(param.get("start"));
		System.out.println(param.get("end"));
		return mybatis.selectList("Party.partySearch", param) ;
	}
	// 지은 작성자 별 모임 리스트
	public List<PartyDTO> selectByWriterPage(Map<String, Object> param)throws Exception{
		return mybatis.selectList("Party.selectByWriterPage", param);
	}
	// 지은 작성자 별 모임 갯수
	public int getMyPageArticleCount(String nickname) throws Exception{
		return mybatis.selectOne("Party.getMyPageArticleCount", nickname);
	}	
	//블랙리스트유저차단
	public int userBlockedConfirm(Map<String , Object> map) {
	      return mybatis.selectOne("Party.userBlockedConfirm", map);

	}
	// 수지 파티의 모집인원수, 현재 참여인원수 구하기
	public PartyCountDTO getPartyCounts(String seq) {
		return mybatis.selectOne("Party.getPartyCounts",seq);

	}
	// 태훈 모임 게시글 신고
	public int partyReport(int seq) {
		return mybatis.update("Party.partyReport", seq);
	}

	// 수지 모집 재시작 기능
	public int restartRecruit(String seq) throws Exception {
		return mybatis.update("Party.restartRecruit",seq);
	}
	// 예지 - 모임글 관리 체크박스 삭제
	public int deleteCheckList(List<String> list) {
		return mybatis.delete("Party.deleteCheckList", list);
	}

}

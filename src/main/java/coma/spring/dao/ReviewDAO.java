package coma.spring.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import coma.spring.dto.MapDTO;
import coma.spring.dto.ReviewDTO;
import coma.spring.dto.TopFiveStoreDTO;
import coma.spring.statics.Configuration;

@Repository
public class ReviewDAO {
	@Autowired
	private SqlSessionTemplate mybatis;
	
	public int insert(ReviewDTO rdto) throws Exception{
		return mybatis.insert("Review.insert",rdto);
	}
	public List<ReviewDTO> selectByPseq(int parent_seq) throws Exception{
		return mybatis.selectList("Review.selectByPseq",parent_seq);
	}
	
	//by지은, 마이페이지 내리뷰리스트 출력을 위한 select문 수정_20200709
	public List<ReviewDTO> selectById(String id)throws Exception{
		return mybatis.selectList("Review.selectById", id);
	}
	
	public int report(int seq) throws Exception{
		return mybatis.update("Review.updateReport", seq);
	}
	// 예지 리뷰 총 갯수
	public int getArticleCount() throws Exception{
		return mybatis.selectOne("Review.getArticleCount");
	}
	// 예지 리뷰 리스트 : 정렬 검색
	public List<ReviewDTO> selectByPageAndOption(int cpage, Object option) {
		int start = cpage * Configuration.navCountPerPage - (Configuration.navCountPerPage-1);
		int end = start + (Configuration.navCountPerPage-1);
		Map<String, Object> param = new HashMap<>();
		param.put("start", start);
		param.put("end", end);
		param.put("targetColumn", option);
		return mybatis.selectList("Review.selectByPageAndOption",param);
	}
	public ReviewDTO selectBySeq(int seq) {
		return mybatis.selectOne("Review.selectBySeq",seq);
	}
	//by지은, 마이페이지 내리뷰리스트 출력을 위한 네비바_20200707
	public int getMyPageArticleCount(String id)throws Exception{
		return mybatis.selectOne("Review.getMyPageArticleCount", id);
	}
	// 태훈 top5 소개 리뷰 뽑기
	public List<TopFiveStoreDTO> getReview(List<MapDTO> top){
//		Map<String, Integer> param = new HashMap<>();
//		for (int i=0; i<top.size(); i++) {
//			param.put("top"+(i+1), top.get(i).getSeq());	
//		}
		List<Integer> list = new ArrayList<>();
		for (int i=0; i<top.size(); i++) {
			list.add(top.get(i).getSeq());	
		}
		System.out.println(list);
		return mybatis.selectList("Review.top5review", list);
	}
	
	public String getStoreName(int parent_seq) {
		return mybatis.selectOne("Review.getStoreName", parent_seq);
	}
	// 체크박스 리뷰 삭제하기
	public int delete(List<String> list) {
		return mybatis.delete("Review.delete", list);
	}
}

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

import coma.spring.dto.PartyDTO;
import coma.spring.statics.PartyConfiguration;

@Repository
public class PartyDAO {

	@Autowired
	private SqlSessionTemplate mybatis;

	public int getNextVal() {
		return mybatis.selectOne("Party.getNextval");
	}

	public int insert(PartyDTO dto) {
		return mybatis.insert("Party.insert",dto);
	}

	public int delete(String seq) throws Exception{
		return mybatis.delete("Party.delete",seq);
	}

	public PartyDTO selectBySeq(int seq) throws Exception{
		return mybatis.selectOne("Party.selectBySeq",seq);
	} 

	public int update(PartyDTO dto) throws Exception{
		return mybatis.update("Party.update",dto);
	}

	public List<PartyDTO> selectByPlace_id(int place_id) throws Exception{
		return mybatis.selectList("Party.selectByPlace_id",place_id);
	}
	public int getArticleCount(int place_id) throws Exception{
		return mybatis.selectOne("Party.getArticleCount", place_id);
	}

	public List<PartyDTO> selectByPageNo(int cpage, int place_id) throws Exception{
		int start = cpage * PartyConfiguration.RECORD_COUNT_PER_PAGE - (PartyConfiguration.RECORD_COUNT_PER_PAGE-1);
		int end = start + (PartyConfiguration.RECORD_COUNT_PER_PAGE-1);
		Map<String, Integer> param = new HashMap<>();
		param.put("start", start);
		param.put("end", end);
		param.put("place_id", place_id);
		return mybatis.selectList("Party.selectByPageNo",param);
	}
	public String clew(String str) throws Exception {
		Document doc = Jsoup.connect("https://m.map.kakao.com/actions/searchView?q="+str).get();
		Element linkTag = doc.selectFirst("ul#placeList>li>a>span");
		String img = linkTag.html();

		return img.split("fname=")[1].split("\"")[0];
	}
}

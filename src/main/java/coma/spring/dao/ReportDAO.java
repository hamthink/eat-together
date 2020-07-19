package coma.spring.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import coma.spring.dto.ReportDTO;
import coma.spring.statics.Configuration;

@Repository
public class ReportDAO {
	
	@Autowired
	private SqlSessionTemplate mybatis;
	
	public int newReport(ReportDTO rdto) {
		return mybatis.insert("Report.newReport", rdto);
	}
	
	public int checkDupl(ReportDTO rdto) {
		return mybatis.selectOne("Report.checkDupl", rdto);
	}
	
	public int getListCount() {
		return mybatis.selectOne("Report.getListCount");
	}
	
	public int checkReport(int seq) {
		return mybatis.update("Report.checkReport",seq);
	}
	
	public int checkOtherRepo(int seq , int category, int parent_seq) {
		Map<String , Integer> param = new HashMap<>();
		
		param.put("seq", seq);
		param.put("category", category);
		param.put("parent_seq", parent_seq);
		return mybatis.update("Report.checkOtherRepo", param);
	}
	
	public int acceptReport(String report_id) {
		return mybatis.update("Report.acceptReport",report_id);
	}
	
	public int repoCountDown(int category , int parent_seq) {
		Map<String , Object> param = new HashMap<>();
		String table =null;
		if(category == 0) {
			table = "review";
		}
		else if(category == 1){
			table = "party";
		}else {
			param.put("table" , "member_report");
			param.put("seq", parent_seq);
			return mybatis.delete("Report.deleteContent",param);
		}
		param.put("table" , table);
		param.put("seq", parent_seq);
		System.out.println("table"+ table);
		System.out.println("seq"+parent_seq);
		return mybatis.update("Report.repoCountDown",param);
	}
	
	public int deleteContent(int category , int parent_seq) {
		Map<String , Object> param = new HashMap<>();
		String table =null;
		if(category == 0) {
			table = "review";
		}
		else if(category == 1){
			table = "party";
		}else {
			table = "member_report";
		}
		param.put("table" , table);
		param.put("seq", parent_seq);
		System.out.println("table"+ table);
		System.out.println("seq"+parent_seq);
		return mybatis.delete("Report.deleteContent",param);
	}
	

	public List<ReportDTO> selectByCategory(int cpage,int category)throws Exception{
		int start = cpage*Configuration.recordMsgCountPerPage - (Configuration.recordMsgCountPerPage - 1);
		int end = start + (Configuration.recordMsgCountPerPage - 1);

		Map<String,String> param = new HashMap<>();
		param.put("start",String.valueOf(start));
		param.put("end",String.valueOf(end));
		param.put("category",String.valueOf(category));
		
		return mybatis.selectList("Report.ListByCategory",param);
	}
	
	public int getCount(int category) throws Exception{
		return mybatis.selectOne("Report.getCount",category);
	}

	public String getSelectCategoryPageNav(int cpage, int category) throws Exception{
		int recordTotalCount = this.getCount(category); // 총 회원 수
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
			sb.append("<li class='page-item'><a class='page-link' href='/admin/Category_list?cpage="+(startNav-1)+"&category="+category+"' id='prevPage' tabindex='-1' aria-disabled='true'>Previous</a></li>");
		}

		for(int i=startNav; i<=endNav; i++) {
			if(cpage == i) {
				sb.append("<li class='page-item active' aria-current='page'><a class='page-link' href='/admin/Category_list?cpage="+i+"&category="+category+"'>"+i+"<span class=sr-only>(current)</span></a></li>");
				//sb.append("<li class='page-item active' aria-current='page'>"+i+"<span class='sr-only'>(current)</span></li>");
			}else {
				sb.append("<li class='page-item'><a class='page-link' href='/admin/Category_list?cpage="+i+"&category="+category+"'>"+i+"</a></li>");
			}
		}

		if(needNext) {
			sb.append("<li class=page-item><a class=page-link href='/admin/Category_list?cpage="+(endNav+1)+"&category="+category+"' id='nextPage'>다음</a></li> ");
		}		
		sb.append("</ul></nav>");
		return sb.toString();
	}
}

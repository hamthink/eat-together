package coma.spring.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import coma.spring.dto.QuestionDTO;
import coma.spring.statics.Configuration;

@Repository
public class QuestionDAO {
	@Autowired
	private SqlSessionTemplate mybatis;

	//나의 1:1 문의 리스트
	public List<QuestionDTO> selectByQuestion(int cpage,String msg_receiver)throws Exception{
		int start = cpage*Configuration.recordMsgCountPerPage - (Configuration.recordMsgCountPerPage - 1);
		int end = start + (Configuration.recordMsgCountPerPage - 1);

		Map<String,String> param = new HashMap<>();
		param.put("start",String.valueOf(start));
		param.put("end",String.valueOf(end));
		param.put("msg_receiver",msg_receiver);

		return mybatis.selectList("question.selectByQuestion",param);
	}
	//문의 보기
	public QuestionDTO selectByseq(int msg_seq)throws Exception{
		return mybatis.selectOne("question.selectBySeq",msg_seq);
	}
	//관리자 1:1 문의 리스트
	public List<QuestionDTO> selectByAdminQ(int cpage)throws Exception{
		int start = cpage*Configuration.recordMsgCountPerPage - (Configuration.recordMsgCountPerPage - 1);
		int end = start + (Configuration.recordMsgCountPerPage - 1);

		Map<String,String> param = new HashMap<>();
		param.put("start",String.valueOf(start));
		param.put("end",String.valueOf(end));

		return mybatis.selectList("question.selectByAdminQ",param);
	}
	//관리자 1:1 문의 리스트 답변대기
	public List<QuestionDTO> selectByNoAnswer(int cpage)throws Exception{
		int start = cpage*Configuration.recordMsgCountPerPage - (Configuration.recordMsgCountPerPage - 1);
		int end = start + (Configuration.recordMsgCountPerPage - 1);

		Map<String,String> param = new HashMap<>();
		param.put("start",String.valueOf(start));
		param.put("end",String.valueOf(end));

		return mybatis.selectList("question.selectByNoAnswer",param);
	}
	//관리자 1:1 문의 리스트 답변완료
	public List<QuestionDTO> selectByYesAnswer(int cpage)throws Exception{
		int start = cpage*Configuration.recordMsgCountPerPage - (Configuration.recordMsgCountPerPage - 1);
		int end = start + (Configuration.recordMsgCountPerPage - 1);

		Map<String,String> param = new HashMap<>();
		param.put("start",String.valueOf(start));
		param.put("end",String.valueOf(end));

		return mybatis.selectList("question.selectByYesAnswer",param);
	}



	//1:1문의하기
	public int insertQuestion(QuestionDTO qdto)throws Exception{
		return mybatis.insert("question.insertQuestion",qdto);
	}
	//다음 시퀀스
	public int getNextVal() {
		return mybatis.selectOne("question.getNextval");
	}
	//1:1문의 답변하기
	public int QuestionAnswer(QuestionDTO qdto)throws Exception{
		return mybatis.insert("question.QuestionAnswer",qdto);
	}
	//답변처리
	public int answerUpdate(QuestionDTO updto)throws Exception{
		return mybatis.update("question.answerUpdate",updto);
	}
	//답변의 seq값 가져오기
	public QuestionDTO selectByView(int msg_view)throws Exception{
		return mybatis.selectOne("question.selectByView",msg_view);
	}

	//1:1문의 네비 카운트
	public int getQuestionCount(String msg_receiver) throws Exception{
		return mybatis.selectOne("question.getQuestionCount",msg_receiver);
	}

	//회원의 1:1문의 네비
	public String getQuestionPageNav(int currentPage,String msg_receiver) throws Exception{
		int recordTotalCount = this.getQuestionCount(msg_receiver); // 총 개시물의 개수
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
			sb.append("<li class='page-item'><a class='page-link' href='question_list?qcpage="+(startNav-1)+"' id='prevPage' tabindex='-1' aria-disabled='true'>Previous</a></li>");
		}

		for(int i=startNav; i<=endNav; i++) {
			if(currentPage == i) {
				sb.append("<li class='page-item active' aria-current='page'><a class='page-link' href='question_list?qcpage="+i+"'>"+i+"<span class=sr-only>(current)</span></a></li>");
				//sb.append("<li class='page-item active' aria-current='page'>"+i+"<span class='sr-only'>(current)</span></li>");
			}else {
				sb.append("<li class='page-item'><a class='page-link' href='question_list?qcpage="+i+"'>"+i+"</a></li>");
			}
		}

		if(needNext) {
			sb.append("<li class=page-item><a class=page-link href='question_list?qcpage="+(endNav+1)+"' id='nextPage'>다음</a></li> ");
		}		
		sb.append("</ul></nav>");
		return sb.toString();
	}

	//관리자 1:1문의 네비 카운트
	public int getAdminQCount() throws Exception{
		return mybatis.selectOne("question.getAdminQCount");
	}
	//관리자 1:1문의 네비 카운트 답변대기
	public int getNoAnswerCount() throws Exception{
		return mybatis.selectOne("question.getNoAnswerCount");
	}
	//관리자 1:1문의 네비 카운트 답변완료
	public int getYesAnswerCount() throws Exception{
		return mybatis.selectOne("question.getYesAnswerCount");
	}

	//관리자의 1:1문의 네비
	public String getAdminQPageNav(int currentPage) throws Exception{
		int recordTotalCount = this.getAdminQCount(); // 총 개시물의 개수
		int pageTotalCount = 0; // 전체 페이지의 개수
		String option = "all";
		
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
			sb.append("<li class='page-item'><a class='page-link' href='AdminQuestion_list?Aqcpage="+(startNav-1)+"' id='prevPage' tabindex='-1' aria-disabled='true'>Previous</a></li>");
		}

		for(int i=startNav; i<=endNav; i++) {
			if(currentPage == i) {
				sb.append("<li class='page-item active' aria-current='page'><a class='page-link' href='AdminQuestion_list?Aqcpage="+i+"'>"+i+"<span class=sr-only>(current)</span></a></li>");
				//sb.append("<li class='page-item active' aria-current='page'>"+i+"<span class='sr-only'>(current)</span></li>");
			}else {
				sb.append("<li class='page-item'><a class='page-link' href='AdminQuestion_list?Aqcpage="+i+"'>"+i+"</a></li>");
			}
		}

		if(needNext) {
			sb.append("<li class=page-item><a class=page-link href='AdminQuestion_list?Aqcpage="+(endNav+1)+"' id='nextPage'>다음</a></li> ");
		}		
		sb.append("</ul></nav>");
		return sb.toString();
	}
	//관리자의 1:1문의 네비 답변대기
	public String getNoAnswerPageNav(int currentPage) throws Exception{
		int recordTotalCount = this.getNoAnswerCount(); // 총 개시물의 개수
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
			sb.append("<li class='page-item'><a class='page-link' href='AdminQuestion_list?ANcpage="+(startNav-1)+"' id='prevPage' tabindex='-1' aria-disabled='true'>Previous</a></li>");
		}

		for(int i=startNav; i<=endNav; i++) {
			if(currentPage == i) {
				sb.append("<li class='page-item active' aria-current='page'><a class='page-link' href='AdminQuestion_list?ANcpage="+i+"'>"+i+"<span class=sr-only>(current)</span></a></li>");
				//sb.append("<li class='page-item active' aria-current='page'>"+i+"<span class='sr-only'>(current)</span></li>");
			}else {
				sb.append("<li class='page-item'><a class='page-link' href='AdminQuestion_list?ANcpage="+i+">"+i+"</a></li>");
			}
		}

		if(needNext) {
			sb.append("<li class=page-item><a class=page-link href='AdminQuestion_list?ANcpage="+(endNav+1)+" id='nextPage'>다음</a></li> ");
		}		
		sb.append("</ul></nav>");
		return sb.toString();
	}
	//관리자의 1:1문의 네비
	public String getYesAnswerPageNav(int currentPage) throws Exception{
		int recordTotalCount = this.getYesAnswerCount(); // 총 개시물의 개수
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
			sb.append("<li class='page-item'><a class='page-link' href='AdminQuestion_list?AYcpage="+(startNav-1)+" id='prevPage' tabindex='-1' aria-disabled='true'>Previous</a></li>");
		}

		for(int i=startNav; i<=endNav; i++) {
			if(currentPage == i) {
				sb.append("<li class='page-item active' aria-current='page'><a class='page-link' href='AdminQuestion_list?AYcpage="+i+"'>"+i+"<span class=sr-only>(current)</span></a></li>");
				//sb.append("<li class='page-item active' aria-current='page'>"+i+"<span class='sr-only'>(current)</span></li>");
			}else {
				sb.append("<li class='page-item'><a class='page-link' href='AdminQuestion_list?AYcpage="+i+"'>"+i+"</a></li>");
			}
		}

		if(needNext) {
			sb.append("<li class=page-item><a class=page-link href='AdminQuestion_list?AYcpage="+(endNav+1)+"' id='nextPage'>다음</a></li> ");
		}		
		sb.append("</ul></nav>");
		return sb.toString();
	}
}

package coma.spring.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import coma.spring.dao.QuestionDAO;
import coma.spring.dto.QuestionDTO;

@Service
public class QuestionService {
	@Autowired
	private QuestionDAO qdao;

	//1:1문의 리스트
	public List<QuestionDTO> selectByQuestion(int cpage,String msg_receiver)throws Exception{
		List<QuestionDTO> qdto = qdao.selectByQuestion(cpage, msg_receiver);
		return qdto;
	}
	//1:1문의 관리자 리스트
	public List<QuestionDTO> selectByAdminQ(int cpage)throws Exception{
		List<QuestionDTO> qdto = qdao.selectByAdminQ(cpage);
		return qdto;
	}
	//1:1문의 관리자 리스트
	public List<QuestionDTO> selectByNoAnswer(int cpage)throws Exception{
		List<QuestionDTO> qdto = qdao.selectByNoAnswer(cpage);
		return qdto;
	}
	//1:1문의 관리자 리스트
	public List<QuestionDTO> selectByYesAnswer(int cpage)throws Exception{
		List<QuestionDTO> qdto = qdao.selectByYesAnswer(cpage);
		return qdto;
	}
	
	
	//1:1문의 보내기
	public int insertQuestion(QuestionDTO qdto)throws Exception{
		int result = qdao.insertQuestion(qdto);
		return result;
	}
	//1:1문의 보기
	public QuestionDTO selectBySeq(int msg_seq)throws Exception{
		QuestionDTO qdto = qdao.selectByseq(msg_seq);
		return qdto;
	}
	//1:1문의 답변하기
	public int QuestionAnswer(QuestionDTO qdto)throws Exception{
		int result = qdao.QuestionAnswer(qdto);
		return result;
	}
	//다음 시퀀스
	public int getNextVal()throws Exception{
		int result = qdao.getNextVal();
		return result;
	}
	//1:1문의 답변처리
	public int answerUpdate(QuestionDTO updto)throws Exception{
		int result = qdao.answerUpdate(updto);
		return result;
	}
	//1:1문의 보기
	public QuestionDTO selectByView(int msg_view)throws Exception{
		QuestionDTO qdto = qdao.selectByView(msg_view);
		return qdto;
	}

	//네비메뉴
	//1:1문의 네비
	public String QuestionNavi(int cpage,String msg_receiver)throws Exception{
		String navi = qdao.getQuestionPageNav(cpage, msg_receiver);
		return navi;
	}
	
	//1:1문의 관리자 네비
	public String AdminQuestionNavi(int cpage)throws Exception{
		String navi = qdao.getAdminQPageNav(cpage);
		return navi;
	}
	//1:1문의 관리자 네비
	public String AdminNoAnswerNavi(int cpage)throws Exception{
		String navi = qdao.getNoAnswerPageNav(cpage);
		return navi;
	}
	//1:1문의 관리자 네비
	public String AdminYesAnswerNavi(int cpage)throws Exception{
		String navi = qdao.getYesAnswerPageNav(cpage);
		return navi;
	}

}

package coma.spring.dao;

import org.springframework.jdbc.core.JdbcTemplate;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import coma.spring.dto.MemberDTO;

@Repository
public class MemberDAO {


	@Autowired
	private JdbcTemplate jdbc;

	@Autowired
	private SqlSessionTemplate mybatis;

	//by 지은, 파일업로드와 성별 추가하여 회원가입하기 수정_20200708
	public int signUp(Map<String, Object> signUpParam) throws Exception {
		return mybatis.insert("Member.signUp", signUpParam);
	}
	
	//by 지은, 카카오톡 회원가입 처리_20200708
	public int signUpKakao(MemberDTO mdto)throws Exception{
		return mybatis.insert("Member.signUpKakao", mdto);
	}

	//로그인하기
	public boolean logIn(Map<String, String> param) throws Exception{
		int result = mybatis.selectOne("Member.logIn", param);

		if(result>0) return true;
		else return false;
	}
	//내정보보기
	public MemberDTO selectMyInfo(String id) throws Exception {
		return mybatis.selectOne("Member.selectMyInfo", id);
	}
	//닉네임으로 내정보보기
	public MemberDTO selectMyInfoByNick(String nickname)throws Exception{
		return mybatis.selectOne("Member.selectMyInfoByNick",nickname);
	}
	
	//회원가입 시 이메일 중복 검사
	public boolean isEmailAvailable(String account_email) throws Exception{
		int result = mybatis.selectOne("Member.isEmailAvailable", account_email);

		if(result>0) return false;
		else return true;
	}
	//회원가입 시 아이디 중복 검사
	public boolean isIdAvailable(String id) throws Exception{
		int result = mybatis.selectOne("Member.isIdAvailable", id);

		if(result>0) return false;
		else return true;
	}

	//회원가입 시 닉네임 중복 검사_20200710
	public boolean isNickAvailable(String nickname) throws Exception{
		int result = mybatis.selectOne("Member.isNickAvailable", nickname);

		if(result>0) return false;
		else return true;
	}

	//회원탈퇴 파라미터 수정_20200717
	public int deleteMember(String id, String nickname) throws Exception{
		
		int res1 = mybatis.delete("Member.deleteMember1", nickname);
		int res2 = mybatis.delete("Member.deleteMember2", nickname);
		int res3 =  mybatis.delete("Member.deleteMember3", nickname);
		int res4 = mybatis.update("Member.renameReview", id);
		if(res1 >0 &&res3 >0 &&res2 >0 &&res4 >0) {
			return 1;
		}
		else {
			return 0;
		}
	}
	//회원정보수정
	public int editMyInfo(Map<String, Object> editParam)throws Exception{
		return mybatis.update("Member.editMyInfo", editParam);
	}
	//비밀번호 수정
	public int editPw(Map<String, String> param) throws Exception{
		return mybatis.update("Member.editPw", param);
	}
	//아이디 찾기를 위한 이메일 체크
	public MemberDTO emailCheckForId(String account_email) throws Exception{
		return mybatis.selectOne("Member.emailCheckForId", account_email);
	}
	//회원탈퇴 및 비밀번호 찾기를 위한 이메일 체크
	public MemberDTO emailCheck(Map<String, String> param) throws Exception{
		return mybatis.selectOne("Member.emailCheck", param);
	}

	public int memberAddReportCount(List<String> list) {
		return mybatis.update("Member.memberAddReportCount",list);
	}
	
}

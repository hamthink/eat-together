package coma.spring.service;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.Charset;
import java.security.MessageDigest;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import coma.spring.dao.MemberDAO;
import coma.spring.dao.MemberFileDAO;
import coma.spring.dto.MemberDTO;
import coma.spring.dto.MemberFileDTO;

@Service
public class MemberService {

	@Autowired
	private MemberDAO mdao;

	@Autowired
	private MemberFileDAO mfdao;

	//비밀번호 암호화하기
	public String getSha512(String pw) throws Exception{
		String encPw = "";
		MessageDigest md = MessageDigest.getInstance("SHA-512");
		byte[] bytes = pw.getBytes(Charset.forName("UTF-8"));
		md.update(bytes);
		encPw = Base64.getEncoder().encodeToString(md.digest());

		return encPw;
	}

	//회원가입하기
	@Transactional("txManager")
	public int signUp(MemberDTO mdto, MemberFileDTO mfdto) throws Exception{
		System.out.println("원래 비밀번호 : " + mdto.getPw());
		String encPw = this.getSha512(mdto.getPw());
		mdto.setPw(encPw);
		System.out.println("암호화된 비밀번호 : " + mdto.getPw());

		Map<String, Object> signUpParam = new HashMap<>();
		signUpParam.put("mdto", mdto);
		signUpParam.put("mfdto", mfdto);

		int result = mdao.signUp(signUpParam);
		mfdao.uploadProc(mfdto);

		return result;
	}

	//로그인하기
	public boolean logIn(Map<String, String> param)throws Exception{
		boolean result = mdao.logIn(param);
		return result;
	}

	//내 정보 보기
	public MemberDTO selectMyInfo(String id)throws Exception{
		MemberDTO mdto = mdao.selectMyInfo(id);
		return mdto;
	}
	//닉네임으로 내정보 가져오기
	public MemberDTO selectMyInfoByNick(String nickname)throws Exception{
		MemberDTO mdto= mdao.selectMyInfoByNick(nickname);
		return mdto;
	}
	//회원가입시 이메일 중복검사
	public boolean isEmailAvailable(String account_email)throws Exception{
		boolean result = mdao.isEmailAvailable(account_email);
		return result;
	}
	//회원가입시 아이디 중복검사
	public boolean isIdAvailable(String id)throws Exception{
		boolean result = mdao.isIdAvailable(id);
		return result;
	}

	//회원가입시 닉네임 중복검사
	public boolean isNickAvailable(String nickname)throws Exception{
		boolean result = mdao.isNickAvailable(nickname);
		return result;
	}

	//회원탈퇴 파라미터 수정_20200717
	public int deleteMember(String id, String nickname) throws Exception{
		int result = mdao.deleteMember(id, nickname);
		return result;
	}
	//내정보수정하기
	public int editMyInfo(MemberDTO mdto, MemberFileDTO mfdto) throws Exception{

		Map<String, Object> editParam = new HashMap<>();
		editParam.put("mdto", mdto);
		editParam.put("mfdto", mfdto);

		int result = mdao.editMyInfo(editParam);
		return result;
	}
	//비밀번호 수정하기
	public int editPw(Map<String, String> param) throws Exception{
		int result = mdao.editPw(param);
		return result;
	}

	//아이디 찾기용 이메일 체크하기
	public MemberDTO emailCheckForFindId(String account_email) throws Exception{
		MemberDTO mdto = mdao.emailCheckForId(account_email);
		return mdto;
	}
	
	//회원탈퇴용, 비밀번호 찾기용 이메일 체크하기
	public MemberDTO emailCheckFor(String id, String account_email) throws Exception{
		Map<String, String> param = new HashMap<>();
		param.put("targetValue1", id);
		param.put("targetValue2", account_email);
		
		MemberDTO mdto = mdao.emailCheck(param);
		return mdto;
	}

	//카카오톡 로그인을 위한 어세스토큰 가져오기
	public String getAccessToken (String code) {
		String access_Token = "";
		String refresh_Token = "";
		String reqURL = "https://kauth.kakao.com/oauth/token";

		try {
			URL url = new URL(reqURL);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();

			//    POST 요청을 위해 기본값이 false인 setDoOutput을 true로
			conn.setRequestMethod("GET");
			conn.setDoOutput(true);

			//    POST 요청에 필요로 요구하는 파라미터 스트림을 통해 전송
			BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
			StringBuilder sb = new StringBuilder();
			sb.append("grant_type=authorization_code");
			sb.append("&client_id=39543f4353dc8ce2c9268fc23c6d67e4");
			
			//테스트는 localhost로 수행하지만, 최종발표에서는 redirect_uri=https://eat-together.net/member/kakaoLogin 수정필요_20200713
			sb.append("&redirect_uri=https://eat-together.net/member/kakaoLogin");
			sb.append("&code=" + code);
			bw.write(sb.toString());
			bw.flush();

			//    결과 코드가 200이라면 성공
			int responseCode = conn.getResponseCode();
			System.out.println("responseCode : " + responseCode);

			//    요청을 통해 얻은 JSON타입의 Response 메세지 읽어오기
			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			String line = "";
			String result = "";

			while ((line = br.readLine()) != null) {
				result += line;
			}
			System.out.println("response body : " + result);

			//    Gson 라이브러리에 포함된 클래스로 JSON파싱 객체 생성
			JsonElement element = JsonParser.parseString(result);

			access_Token = element.getAsJsonObject().get("access_token").getAsString();
			refresh_Token = element.getAsJsonObject().get("refresh_token").getAsString();

			System.out.println("access_token : " + access_Token);
			System.out.println("refresh_token : " + refresh_Token);

			br.close();
			bw.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 

		return access_Token;
	}

	//카카오톡 정보 가져오기
	public MemberDTO getloginInfo (String access_Token)throws Exception {

		//    요청하는 클라이언트마다 가진 정보가 다를 수 있기에 HashMap타입으로 선언
		MemberDTO mdto = new MemberDTO();
		String reqURL = "https://kapi.kakao.com/v2/user/me";
		try {
			URL url = new URL(reqURL);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST");

			//    요청에 필요한 Header에 포함될 내용
			conn.setRequestProperty("Authorization", "Bearer " + access_Token);

			int responseCode = conn.getResponseCode();
			System.out.println("responseCode : " + responseCode);

			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));

			String line = "";
			String result = "";

			while ((line = br.readLine()) != null) {
				result += line;
			}
			System.out.println("response body : " + result);

			JsonElement element = JsonParser.parseString(result);

			String id = element.getAsJsonObject().get("id").getAsString();
			JsonObject properties = element.getAsJsonObject().get("properties").getAsJsonObject(); 
			JsonObject kakao_account = element.getAsJsonObject().get("kakao_account").getAsJsonObject();

			String nickname = properties.getAsJsonObject().get("nickname").getAsString();


			if(mdao.selectMyInfo(id)==null) {
				//by 지은, 닉네임 사용가능한 경우에는 카카오톡 정보를 그대로 가져온다_20200713
				if(mdao.isNickAvailable(nickname)) {
					mdto.setId(id);
					mdto.setPw("");
					mdto.setNickname(nickname);
					mdto.setBirth("1999-12-31");
					mdto.setAccount_email("need@eat-together.com");
					mdto.setGender(0);
					mdto.setMember_type("kakao");


					int kakaoSignUpResult = mdao.signUpKakao(mdto);
					System.out.println("카카오톡 회원가입 진행 성공1 실패0 : " + kakaoSignUpResult);
				}else {
					//by 지은, 닉네임이 중복되는 경우에는 뒤에 증가하는 숫자를 더해주어 중복을 방지한다_20200713
					int nickNum = 1;
					int sum = nickNum++;

					mdto.setId(id);
					mdto.setPw("");
					mdto.setNickname(nickname + sum);
					mdto.setBirth("1999-12-31");
					mdto.setAccount_email("need@eat-together.com");
					mdto.setGender(0);
					mdto.setMember_type("kakao");


					int kakaoSignUpResult = mdao.signUpKakao(mdto);
					System.out.println("카카오톡 회원가입 진행 성공1 실패0 : " + kakaoSignUpResult);

				}
			}else {
				System.out.println("이미 회원가입된 카카오계정입니다.");
				System.out.println(mdto.getAccount_email());
				mdto = mdao.selectMyInfo(id);
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return mdto;


	}

	//카카오톡 로그아웃하기
	public void kakaoLogout(String access_Token) {
		String reqURL = "https://kapi.kakao.com/v1/user/logout";
		try {
			URL url = new URL(reqURL);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Authorization", "Bearer " + access_Token);

			int responseCode = conn.getResponseCode();
			System.out.println("responseCode : " + responseCode);

			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));

			String result = "";
			String line = "";

			while ((line = br.readLine()) != null) {
				result += line;
			}
			System.out.println(result);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	//카카오톡 회원탈퇴하기
	public void kakaoWithdraw(String access_Token) {
		String reqURL = "https://kapi.kakao.com/v1/user/unlink";
		try {
			URL url = new URL(reqURL);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Authorization", "Bearer " + access_Token);

			int responseCode = conn.getResponseCode();
			System.out.println("responseCode : " + responseCode);

			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));

			String result = "";
			String line = "";

			while ((line = br.readLine()) != null) {
				result += line;
			}
			System.out.println(result);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}


}

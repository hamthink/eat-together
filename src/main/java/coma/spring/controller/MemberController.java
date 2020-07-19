package coma.spring.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import coma.spring.dto.MemberDTO;
import coma.spring.dto.MemberFileDTO;
import coma.spring.service.MemberFileService;
import coma.spring.service.MemberService;
import coma.spring.service.MsgService;

@Controller
@RequestMapping("/member/")
public class MemberController {
	//By 지은, 회원서비스 관련 기능을 모아놓은 컨트롤러

	@Autowired
	private MemberService mservice;

	@Autowired
	private MsgService msgservice;	

	@Autowired
	private HttpSession session;

	@Autowired
	private MemberFileController mfcon;
	
	@Autowired
	private EmailController econ;

	//by지은, try-catch 예외처리 대체할 수 있는 메서드, ExceptionHandler_20200701
	@ExceptionHandler
	public String exceptionHandler(Exception e) {
		e.printStackTrace();
		System.out.println("에러가 발생하였습니다.");
		return "error";
	}

	//로그인 페이지로 이동하기
	@RequestMapping("loginview")
	public String getLoginView() {
		return "member/loginview";
	}

	//회원가입 페이지 중 약관동의로 이동
	@RequestMapping("signup_check")
	public String getSignupCheckView() {
		return "member/signup_check";
	}

	//by 지은 회원가입, 약관동의 후 정보입력 페이지로 이동_20200710
	@RequestMapping("signup_info")
	public String getSignupInfoView() {
			return "member/signup_info";
	}

	//by지은, 마이페이지에서 내정보view로 이동_20200704
	@RequestMapping("mypage_myinfo")
	public ModelAndView getMyInfoView() throws Exception{
		ModelAndView mav = new ModelAndView();
		mav.setViewName("member/mypage_myinfo");
		MemberDTO mdto = (MemberDTO) session.getAttribute("loginInfo");
		String id = mdto.getId();

		mdto = mservice.selectMyInfo(id);
		mav.addObject("mdto", mdto);
		return mav;
	}

	//마이페이지에서 쪽지함으로 이동
	@RequestMapping("mypage_msglist")
	public String getMyMsgView() {
		return "member/mypage_msglist";
	}

	//마이페이지에서 내모임리스트로 이동
	@RequestMapping("mypage_chatlist")
	public String getChatlistView() {
		return "member/mypage_chatlist";
	}

	//마이페이지에서 내리뷰리스트로 이동
	@RequestMapping("mypage_reviewlist")
	public String getReviewlistView() {
		return "member/mypage_reviewlist";
	}
	//회원탈퇴 페이지로 이동하기
	@RequestMapping("withdrawView")
	public String getWithdrawView() {
		return "member/withdraw";
	}

	//비밀번호 수정하기 팝업 열기
	@RequestMapping("editPw")
	public String openEditPwView() {
		return "member/editpw";
	}

	//By지은,  내정보 수정 페이지로 이동하기_20200710
	@RequestMapping("editMyInfoView")
	public ModelAndView getEditMyInfoView()throws Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("member/editmyinfo");

		MemberDTO mdto = (MemberDTO) session.getAttribute("loginInfo");
		String id = mdto.getId();

		mdto = mservice.selectMyInfo(id);
		mav.addObject("mdto", mdto);
		return mav;

	}


	//아이디 찾기 팝업 열기
	@RequestMapping("findid")
	public String findId() {
		return "member/findid";
	}


	//비밀번호 찾기 팝업 열기
	@RequestMapping("findpw")
	public String findpw() {
		return "member/findpw";
	}


	//로그아웃하기
	@RequestMapping("logoutProc")
	public String logoutProc() {
		//By지은, 카카오톡 로그인의 경우 access_Token 로그아웃이 필요하다_20200705
		if(session.getAttribute("access_Token")!=null) {
			mservice.kakaoLogout((String)session.getAttribute("access_Token"));
			session.invalidate();
			return "redirect:/";
			//카카오톡 로그인이 아닌 경우
		}else {
			session.invalidate();
			return "redirect:/";
		}
	}

	//회원가입하기
	@RequestMapping("signupProc")
	public String signUp(MemberDTO mdto, MemberFileDTO mfdto)throws Exception {
		String realPath = session.getServletContext().getRealPath("upload/"+ mdto.getId() + "/");
		mfdto = mfcon.uploadProc(mdto, mfdto, realPath);
		int result = mservice.signUp(mdto, mfdto);
		if(result>0) {
			System.out.println("회원가입성공");
		}else {
			System.out.println("회원가입실패, 오류확인하기");
		}
		//회원가입축하메세지 입니다.
		int msgresult= msgservice.insertWelcome(mdto.getNickname());
		econ.mailSendingGreeting(mdto.getAccount_email());
		System.out.println("signupProc 비밀번호 : " + mdto.getPw());

		return "redirect:/";
	}


	//회원가입시 아이디 중복체크
	@RequestMapping("isIdAvailable")
	@ResponseBody
	public String isIdAvailable(String id)throws Exception {
		boolean result=true;

		result = mservice.isIdAvailable(id);
		System.out.println("아이디 중복체크 결과 : " + result);
		return String.valueOf(result);
	}

	//by 지은, 회원가입시 닉네임 중복체크_20200710
	@RequestMapping("isNickAvailable")
	@ResponseBody
	public String isNickAvailable(String nickname)throws Exception {
		boolean result=true;

		result = mservice.isNickAvailable(nickname);
		System.out.println("닉네임 중복체크 결과 : " + result);
		return String.valueOf(result);
	}

	//로그인하기
	@RequestMapping("login")
	public String login(String id, String pw)throws Exception {

		System.out.println("id : " + id);
		String protectedpw = mservice.getSha512(pw);
		System.out.println("pw : " + protectedpw);

		Map<String, String> param = new HashMap<>();
		param.put("targetColumn1", "id");
		param.put("targetValue1", id);
		param.put("targetColumn2", "pw");
		param.put("targetValue2", protectedpw);

		boolean result = mservice.logIn(param);

		System.out.println("loginResult 결과 : "+ result);

		//by 지은, 로그인 성공시 세션에 값을 저장해준다_20200706
		if(result==true) {
			MemberDTO mdto = mservice.selectMyInfo(id);
			String msg_receiver=mdto.getNickname();
			System.out.println("닉네임은"+msg_receiver);
			//새로운 메세지확인
			if(msg_receiver.contentEquals("administrator")) {
				session.setAttribute("loginInfo", mdto);
				//새로운메세지 확인
				System.out.println("로그인 성공");
				return "redirect:/";
			}else {
				int newmsg = msgservice.newmsg(msg_receiver);
				System.out.println("새로운메세지"+newmsg);
				session.setAttribute("newMsg", newmsg);
				session.setAttribute("loginInfo", mdto);
				//새로운메세지 확인
				System.out.println("로그인 성공");
				return "redirect:/";
			}
			
		}else {
			System.out.println("id : " + id);
			System.out.println("pw : " + protectedpw);
			System.out.println("로그인 실패");
			return "redirect:/";
		}

	}

	//로그인 시 유효성 검사
	@RequestMapping("isPwCorrect")
	@ResponseBody
	public String isPwCorrect(@RequestParam String id, @RequestParam String pw)throws Exception {
		System.out.println("id : " + id);
		String protectedpw = mservice.getSha512(pw);
		System.out.println("pw : " + protectedpw);

		Map<String, String> param = new HashMap<>();
		param.put("targetColumn1", "id");
		param.put("targetValue1", id);
		param.put("targetColumn2", "pw");
		param.put("targetValue2", protectedpw);

		boolean result = mservice.logIn(param);

		System.out.println("loginResult 결과 : "+ result);

		//by 지은, 아이디와 입력한 비밀번호가 일치한 경우 correct를 반환, 틀린 경우 uncorrect 반환_20200706
		if(result==true) {
			String msg = "correct";
			return msg;
		}else {
			String msg = "uncorrect";
			return msg;
		}
	}

	//회원탈퇴하기 파라미터 수정_20200717
	@RequestMapping("withdrawProc")
	public String withdrawProc() throws Exception{
		//By지은, 카카오톡 로그인의 경우 회원탈퇴 시 어세스토큰 만료 필요하다_20200712
		//회원탈퇴 이메일로 수정함_20200713
		MemberDTO mdto = (MemberDTO) session.getAttribute("loginInfo");
		String nickname = mdto.getNickname();
		String id = mdto.getId();
		
		if(session.getAttribute("access_Token")!=null) {
			String access_Token = (String) session.getAttribute("access_Token");

			int result = mservice.deleteMember(id, nickname);
			mservice.kakaoWithdraw(access_Token);
			session.invalidate();
			System.out.println("회원탈퇴 성공1 실패0" + result);
			return "redirect:/";
		}else {
			//일반 회원탈퇴의 경우 어세스토큰 만료가 필요하지 않다_20200712


			System.out.println("회원탈퇴하는 id : " + nickname);
			int result = mservice.deleteMember(id, nickname);
			session.invalidate();
			System.out.println("회원탈퇴 성공1 실패0" + result);
			return "redirect:/";

		}
	}

	//by 지은, 비밀번호 수정하기 ajax로 수정했음_20200709
	@RequestMapping("editPwProc")
	@ResponseBody
	public String editPwProc(@RequestParam String id, @RequestParam String pw)throws Exception {
		System.out.println("컨트롤러로 값 전달 성공");
		MemberDTO mdto = new MemberDTO();

		if(session.getAttribute("loginInfo")!=null) {
			mdto = (MemberDTO) session.getAttribute("loginInfo");
			id = mdto.getId();
		}else {
			mdto = mservice.selectMyInfo(id);
		}

		String oriprotectedpw = mdto.getPw(); 
		String newprotectedpw = mservice.getSha512(pw);

		if(oriprotectedpw.contentEquals(newprotectedpw)) {
			System.out.println("수정하려는 비밀번호가 기존과 일치하여 에러 발생");
			return "";
		}else {
			Map<String, String> param = new HashMap<>();
			param.put("targetColumn1", "pw");
			param.put("targetValue1", newprotectedpw);
			param.put("targetColumn2", "id");
			param.put("targetValue2", id);

			int result = mservice.editPw(param);
			System.out.println("비밀번호 수정 성공 :" + result);

			//by지은, 비밀번호를 수정한 후에는 재로그인을 요구한다_20200709
			//By지은, 카카오톡 로그인의 경우 access_Token 로그아웃이 필요하다_20200705
			if(session.getAttribute("access_Token")!=null) {
				mservice.kakaoLogout((String)session.getAttribute("access_Token"));
				session.invalidate();
				return "success";
				//카카오톡 로그인이 아닌 경우
			}else {
				session.invalidate();
				return "success";
			}
		}
	}


	//내정보 수정하기
	@RequestMapping("editMyInfoProc")
	public ModelAndView editMyInfoProc(MultipartFile profile, int gender, String account_email, String birth, MemberFileDTO mfdto) throws Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("redirect:/member/mypage_myinfo");

		MemberDTO mdto = (MemberDTO) session.getAttribute("loginInfo");
		String id = mdto.getId();

		mdto.setGender(gender);
		mdto.setProfile(profile);
		mdto.setAccount_email(account_email);
		mdto.setBirth(birth);

		String realPath = session.getServletContext().getRealPath("upload/"+id+"/");
		mfdto = mfcon.uploadProc(mdto, mfdto, realPath);
		mdto.setSysname(mfdto.getSysname());
		
		int result = mservice.editMyInfo(mdto, mfdto);
		System.out.println("이전:"+mdto.getGender());
		System.out.println("회원정보수정 결과 1-성공 0-실패 : " + result);
		session.setAttribute("loginInfo", mdto);

		MemberDTO mdto2 = (MemberDTO) session.getAttribute("loginInfo");
		System.out.println("이후:"+mdto2.getGender());
		mdto = mservice.selectMyInfo(id);
		mav.addObject("mdto", mdto);
		return mav;


	}


	//카카오톡 로그인하기
	@RequestMapping("/kakaoLogin")
	public String kakaoLogin(@RequestParam("code") String code, HttpSession session)throws Exception {
		System.out.println("카카오 로그인 code : "+ code);
		String access_Token = mservice.getAccessToken(code);
		System.out.println("controller access_token : " + access_Token);
		MemberDTO mdto = mservice.getloginInfo(access_Token);
		System.out.println("login Controller : " + mdto);

		//    클라이언트의 이메일이 존재할 때 세션에 해당 이메일과 토큰 등록
		if (mdto.getId() != null) {
			
			session.setAttribute("loginInfo", mdto);
			session.setAttribute("access_Token", access_Token);
		}
		return "redirect:/";
	}



}

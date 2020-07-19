package coma.spring.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.Random;

import javax.inject.Inject;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import coma.spring.dto.MemberDTO;
import coma.spring.service.MemberService;

@Controller
@RequestMapping("/mail/")
public class EmailController {

	@Inject
	JavaMailSender mailSender; 

	@Autowired
	private MemberService mservice;

	@Autowired
	private HttpSession session;

	//mailSending 랜덤 문자열 생성하기
	public String getRandomString(){
		char[] charaters = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','0','1','2','3','4','5','6','7','8','9'};

		StringBuffer sb = new StringBuffer();
		Random rn = new Random();

		for( int i = 0 ; i < 15 ; i++ ){
			sb.append( charaters[ rn.nextInt( charaters.length ) ] );
		}
		return sb.toString();
	}


	//회원가입 축하 이메일 발송하기
	@RequestMapping("mailSendingGreeting")
	public void mailSendingGreeting(String account_email) throws Exception{ 
		String username = "eat-together";
		String password = "aktwlqrkTekrkffo?";

		String recipient = account_email;
		String subject ="맛집갔다갈래 회원가입을 축하드립니다!";
		String msg = "<html><head></head><body>\r\n" + 
				"<div style=\"font-family: 'Apple SD Gothic Neo', 'sans-serif' !important; width: 540px; height: 600px; border-top: 4px solid {$point_color}; margin: 100px auto; padding: 30px 0; box-sizing: border-box;\">\r\n" + 
				"	<h1 style=\"margin: 0; padding: 0 5px; font-size: 28px; font-weight: 400;\">\r\n" + 
				"<img src=\"https://eat-together.s3.ap-northeast-2.amazonaws.com/logo/eattogether-logo-square.png\" width=\"350px\"><br>\r\n" + 
				"<hr style=\"border: 0; width:500px; height: 0; border-top: 1px solid rgba(0, 0, 0, 0.1); border-bottom: 1px solid rgba(255, 255, 255, 0.3);\"><br>\r\n" + 
				"		<span style=\"font-size: 15px; margin: 0 0 10px 3px;\">맛집 동행 찾기 서비스 - <맛집갔다갈래></span><br>\r\n" + 
				"		<span style=\"color: {$point_color};\">회원가입을 축하드립니다!</span>\r\n" + 
				"	</h1>\r\n" + 
				"	<p style=\"font-size: 16px; line-height: 26px; margin-top: 50px; padding: 0 5px;\">\r\n" + 
				"		안녕하세요.<br>\r\n" + 
				"		<맛집갔다갈래>에 신규회원이 되신 것을 진심으로 축하드립니다.<br>\r\n" + 
				"		새로운 맛집 친구와 함께 즐거운 모임을 시작하시길 바랍니다.<br>\r\n" + 
				"		감사합니다.\r\n" + 
				"	</p>\r\n" + 
				"<center>\r\n" + 
				"<a href=\"https://eat-together.net\" target=\"blank\" class=\"myButton\">사이트에 접속하기</a>\r\n" + 
				"</center>\r\n" + 
				"<hr style=\"border: 0; width:500px; height: 0; border-top: 1px solid rgba(0, 0, 0, 0.1); border-bottom: 1px solid rgba(255, 255, 255, 0.3);\">";

		Properties props = new Properties();
		props.put("mail.smtp.host", "smtp.daum.net");
		props.put("mail.smtp.socketFactory.port", "465");
		props.put("mail.smtp.socketFactory.class",
				"javax.net.ssl.SSLSocketFactory");
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.port", "465");

		Session session = Session.getDefaultInstance(props,
				new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username,password);
			}
		});

		try {

			Message message = new MimeMessage(session);
			message.setFrom(new InternetAddress("no-reply@eat-together.net"));
			message.setRecipients(Message.RecipientType.TO,
					InternetAddress.parse(account_email));
			message.setSubject(subject);
			message.setContent(msg, "text/html; charset=utf-8");
			Transport.send(message);

			System.out.println("회원가입 축하메일 발송 OK");
		} catch (MessagingException e) {
			throw new RuntimeException(e);
		}
	}


	//회원가입시 인증 메일 보내기, 이메일 정보 수정시 사용_20200713
	@RequestMapping("mailSending")
	@ResponseBody
	public String mailSender(@RequestParam String account_email) throws Exception{ 
		String username = "eat-together";
		String password = "aktwlqrkTekrkffo?";
		String resp;

		boolean result = mservice.isEmailAvailable(account_email);
		System.out.println("이메일 사용가능한가? :" + result);
		if(result==false) {
			resp = "";
			return resp;
		}else {

			String dice = this.getRandomString();
			System.out.println("랜덤문자열 : " + dice);

			String recipient = account_email;
			String subject = "맛집갔다갈래 인증 이메일입니다.";
			String msg = "<html><head></head><body>\r\n" + 
					"<div style=\"font-family: 'Apple SD Gothic Neo', 'sans-serif' !important; width: 540px; height: 600px; border-top: 4px solid {$point_color}; margin: 100px auto; padding: 30px 0; box-sizing: border-box;\">\r\n" + 
					"	<h1 style=\"margin: 0; padding: 0 5px; font-size: 28px; font-weight: 400;\">\r\n" + 
					"<img src=\"https://eat-together.s3.ap-northeast-2.amazonaws.com/logo/eattogether-logo-square.png\" width=\"350px\"><br>\r\n" + 
					"<hr style=\"border: 0; width:500px; height: 0; border-top: 1px solid rgba(0, 0, 0, 0.1); border-bottom: 1px solid rgba(255, 255, 255, 0.3);\"><br>\r\n" + 
					"		<span style=\"font-size: 15px; margin: 0 0 10px 3px;\">맛집 동행 찾기 서비스 - <맛집갔다갈래></span><br>\r\n" + 
					"		<span style=\"color: {$point_color};\">사이트 이용에 필요한 인증메일</span>\r\n" + 
					"	</h1>\r\n" + 
					"	<p style=\"font-size: 16px; line-height: 26px; margin-top: 50px; padding: 0 5px;\">\r\n" + 
					"		안녕하세요.<br>\r\n" + 
					"		<맛집갔다갈래>에서 인증메일을 보내드립니다.<br>\r\n<br>" + 
					"		인증코드 : <strong>"+ dice +"</strong><br>\r\n<br> 인증코드를 인증란에 입력해주시길 바랍니다.<br>\r\n" + 
					"		감사합니다.\r\n" + 
					"	</p>\r\n" + 
					"<center>\r\n" + 
					"<a href=\"https://eat-together.net\" target=\"blank\" class=\"myButton\">사이트에 접속하기</a>\r\n" + 
					"</center>\r\n" + 
					"<hr style=\"border: 0; width:500px; height: 0; border-top: 1px solid rgba(0, 0, 0, 0.1); border-bottom: 1px solid rgba(255, 255, 255, 0.3);\">";

			Properties props = new Properties();
			props.put("mail.smtp.host", "smtp.daum.net");
			props.put("mail.smtp.socketFactory.port", "465");
			props.put("mail.smtp.socketFactory.class",
					"javax.net.ssl.SSLSocketFactory");
			props.put("mail.smtp.auth", "true");
			props.put("mail.smtp.port", "465");

			Session session = Session.getDefaultInstance(props,
					new javax.mail.Authenticator() {
				protected PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(username,password);
				}
			});

			try {

				Message message = new MimeMessage(session);
				message.setFrom(new InternetAddress("no-reply@eat-together.net"));
				message.setRecipients(Message.RecipientType.TO,
						InternetAddress.parse(recipient));
				message.setSubject(subject);
				message.setContent(msg, "text/html; charset=utf-8");
				Transport.send(message);
				resp = dice;

				System.out.println("OK");
			} catch (MessagingException e) {
				throw new RuntimeException(e);
			}

			return resp;
		}
	}

	//아이디 찾기 인증 메일 보내기
	@RequestMapping("mailSendingForId")
	@ResponseBody
	public List<String> mailSenderForId(@RequestParam String account_email) throws Exception{ 
		String username = "eat-together";
		String password = "aktwlqrkTekrkffo?";
		List<String> resplist = new ArrayList<>();
		
		System.out.println("아이디 찾기용 입력한 이메일 : " + account_email);
		MemberDTO mdto = mservice.emailCheckForFindId(account_email);


		if(mdto==null) {
			System.out.println("아이디 찾기 결과 실패 : 입력한 이메일의 고객이 존재하지 않음");
			resplist.add(0, null);
			return resplist;

		}else {
			System.out.println("아이디 찾기 결과 성공 : ");
			String dice = this.getRandomString();
			System.out.println("랜덤문자열 : " + dice);

			String id = mdto.getId(); //입력한 이메일 정보를 가진 고객의 아이디를 가져온다.
			resplist.add(0, dice);
			resplist.add(1, id);

			String recipient = account_email;
			String subject = "맛집갔다갈래 아이디찾기 이메일입니다.";
			String msg = "<html><head></head><body>\r\n" + 
					"<div style=\"font-family: 'Apple SD Gothic Neo', 'sans-serif' !important; width: 540px; height: 600px; border-top: 4px solid {$point_color}; margin: 100px auto; padding: 30px 0; box-sizing: border-box;\">\r\n" + 
					"	<h1 style=\"margin: 0; padding: 0 5px; font-size: 28px; font-weight: 400;\">\r\n" + 
					"<img src=\"https://eat-together.s3.ap-northeast-2.amazonaws.com/logo/eattogether-logo-square.png\" width=\"350px\"><br>\r\n" + 
					"<hr style=\"border: 0; width:500px; height: 0; border-top: 1px solid rgba(0, 0, 0, 0.1); border-bottom: 1px solid rgba(255, 255, 255, 0.3);\"><br>\r\n" + 
					"		<span style=\"font-size: 15px; margin: 0 0 10px 3px;\">맛집 동행 찾기 서비스 - <맛집갔다갈래></span><br>\r\n" + 
					"		<span style=\"color: {$point_color};\">아이디 찾기에 필요한 인증메일</span>\r\n" + 
					"	</h1>\r\n" + 
					"	<p style=\"font-size: 16px; line-height: 26px; margin-top: 50px; padding: 0 5px;\">\r\n" + 
					"		안녕하세요.<br>\r\n" + 
					"		<맛집갔다갈래>에서 인증메일을 보내드립니다.<br>\r\n<br>" + 
					"		인증코드 : <strong>"+ dice +"</strong><br>\r\n<br> 인증코드를 인증란에 입력해주시길 바랍니다.<br>\r\n" + 
					"		감사합니다.\r\n" + 
					"	</p>\r\n" + 
					"<center>\r\n" + 
					"<a href=\"https://eat-together.net\" target=\"blank\" class=\"myButton\">사이트에 접속하기</a>\r\n" + 
					"</center>\r\n" + 
					"<hr style=\"border: 0; width:500px; height: 0; border-top: 1px solid rgba(0, 0, 0, 0.1); border-bottom: 1px solid rgba(255, 255, 255, 0.3);\">";
			
			Properties props = new Properties();
			props.put("mail.smtp.host", "smtp.daum.net");
			props.put("mail.smtp.socketFactory.port", "465");
			props.put("mail.smtp.socketFactory.class",
					"javax.net.ssl.SSLSocketFactory");
			props.put("mail.smtp.auth", "true");
			props.put("mail.smtp.port", "465");

			Session session = Session.getDefaultInstance(props,
					new javax.mail.Authenticator() {
				protected PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(username,password);
				}
			});

			try {

				Message message = new MimeMessage(session);
				message.setFrom(new InternetAddress("no-reply@eat-together.net"));
				message.setRecipients(Message.RecipientType.TO,
						InternetAddress.parse(recipient));
				message.setSubject(subject);
				message.setContent(msg, "text/html; charset=utf-8");
				Transport.send(message);

				System.out.println("OK");
			} catch (MessagingException e) {
				throw new RuntimeException(e);
			}

			return resplist;
		}
	}


	//비밀번호 찾기 인증 메일 보내기
	@RequestMapping("mailSendingForPw")
	@ResponseBody
	public String mailSenderForPw(@RequestParam String account_email, @RequestParam String id) throws Exception{
		String username = "eat-together";
		String password = "aktwlqrkTekrkffo?";
		String resp;
		String inputId = id;
		String input_account_email = account_email;
		System.out.println("비밀번호 찾기용 입력한 이메일 : " + account_email);
		System.out.println("비밀번호 찾기용 입력한 아이디 : " + inputId);

		MemberDTO mdto = mservice.emailCheckFor(inputId, input_account_email);

		if(mdto == null) {
			System.out.println("비밀번호 찾기 결과 실패  : 입력한 정보와 일치한 고객이 없음");
			resp = "";
			return resp;

		}else {
			System.out.println("비밀번호 찾기 결과 성공 : ");
			String dice = this.getRandomString();
			resp = dice;
			System.out.println("랜덤문자열 : " + dice);

			String recipient = mdto.getAccount_email();
			String subject = "맛집갔다갈래 비밀번호찾기 이메일입니다.";
			String msg = "<html><head></head><body>\r\n" + 
					"<div style=\"font-family: 'Apple SD Gothic Neo', 'sans-serif' !important; width: 540px; height: 600px; border-top: 4px solid {$point_color}; margin: 100px auto; padding: 30px 0; box-sizing: border-box;\">\r\n" + 
					"	<h1 style=\"margin: 0; padding: 0 5px; font-size: 28px; font-weight: 400;\">\r\n" + 
					"<img src=\"https://eat-together.s3.ap-northeast-2.amazonaws.com/logo/eattogether-logo-square.png\" width=\"350px\"><br>\r\n" + 
					"<hr style=\"border: 0; width:500px; height: 0; border-top: 1px solid rgba(0, 0, 0, 0.1); border-bottom: 1px solid rgba(255, 255, 255, 0.3);\"><br>\r\n" + 
					"		<span style=\"font-size: 15px; margin: 0 0 10px 3px;\">맛집 동행 찾기 서비스 - <맛집갔다갈래></span><br>\r\n" + 
					"		<span style=\"color: {$point_color};\">비밀번호 찾기에 필요한 인증메일</span>\r\n" + 
					"	</h1>\r\n" + 
					"	<p style=\"font-size: 16px; line-height: 26px; margin-top: 50px; padding: 0 5px;\">\r\n" + 
					"		안녕하세요.<br>\r\n" + 
					"		<맛집갔다갈래>에서 인증메일을 보내드립니다.<br>\r\n<br>" + 
					"		인증코드 : <strong>"+ dice +"</strong><br>\r\n<br> 인증코드를 인증란에 입력해주시길 바랍니다.<br>\r\n" + 
					"		감사합니다.\r\n" + 
					"	</p>\r\n" + 
					"<center>\r\n" + 
					"<a href=\"https://eat-together.net\" target=\"blank\" class=\"myButton\">사이트에 접속하기</a>\r\n" + 
					"</center>\r\n" + 
					"<hr style=\"border: 0; width:500px; height: 0; border-top: 1px solid rgba(0, 0, 0, 0.1); border-bottom: 1px solid rgba(255, 255, 255, 0.3);\">";
			
			Properties props = new Properties();
			props.put("mail.smtp.host", "smtp.daum.net");
			props.put("mail.smtp.socketFactory.port", "465");
			props.put("mail.smtp.socketFactory.class",
					"javax.net.ssl.SSLSocketFactory");
			props.put("mail.smtp.auth", "true");
			props.put("mail.smtp.port", "465");

			Session session = Session.getDefaultInstance(props,
					new javax.mail.Authenticator() {
				protected PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(username,password);
				}
			});

			try {

				Message message = new MimeMessage(session);
				message.setFrom(new InternetAddress("no-reply@eat-together.net"));
				message.setRecipients(Message.RecipientType.TO,
						InternetAddress.parse(recipient));
				message.setSubject(subject);
				message.setContent(msg, "text/html; charset=utf-8");
				Transport.send(message);


				System.out.println("Email Sending OK");
			} catch (MessagingException e) {
				throw new RuntimeException(e);
			}
			System.out.println("컨트롤러에서 resp 전달: " + resp);
			return resp;
		}
	}

	//회원탈퇴를 위한 인증 메일 보내기
	@RequestMapping("mailSendingForOut")
	@ResponseBody
	public String mailSenderForOut(@RequestParam String account_email) throws Exception{
		String username = "eat-together";
		String password = "aktwlqrkTekrkffo?";
		String resp;

		MemberDTO mdto1 = (MemberDTO) session.getAttribute("loginInfo");
		String id = mdto1.getId();

		String ori_account_email= mdto1.getAccount_email();
		System.out.println("내 정보에 저장된 이메일 : " + ori_account_email);
		String input_account_email = account_email;
		System.out.println("고객이 입력한 이메일 : " + input_account_email);

		//로그인한 아이디와 이메일이 일치하는 고객 찾기_20200717
		MemberDTO mdto2 = mservice.emailCheckFor(id, input_account_email);

		if(mdto2 == null) {
			System.out.println("회원탈퇴 이메일 검증 결과 : 해당 이메일의 회원이 존재하지 않음");
			resp = "";
			return resp;
		}else {
			System.out.println("아이디와 이메일 일치");
			String dice = this.getRandomString();
			resp = dice;
			System.out.println("랜덤문자열 : " + dice);

			String recipient = account_email;
			String subject = "맛집갔다갈래 회원탈퇴인증 이메일입니다.";
			String msg = "<html><head></head><body>\r\n" + 
					"<div style=\"font-family: 'Apple SD Gothic Neo', 'sans-serif' !important; width: 540px; height: 600px; border-top: 4px solid {$point_color}; margin: 100px auto; padding: 30px 0; box-sizing: border-box;\">\r\n" + 
					"	<h1 style=\"margin: 0; padding: 0 5px; font-size: 28px; font-weight: 400;\">\r\n" + 
					"<img src=\"https://eat-together.s3.ap-northeast-2.amazonaws.com/logo/eattogether-logo-square.png\" width=\"350px\"><br>\r\n" + 
					"<hr style=\"border: 0; width:500px; height: 0; border-top: 1px solid rgba(0, 0, 0, 0.1); border-bottom: 1px solid rgba(255, 255, 255, 0.3);\"><br>\r\n" + 
					"		<span style=\"font-size: 15px; margin: 0 0 10px 3px;\">맛집 동행 찾기 서비스 - <맛집갔다갈래></span><br>\r\n" + 
					"		<span style=\"color: {$point_color};\">회원탈퇴에 필요한 인증메일</span>\r\n" + 
					"	</h1>\r\n" + 
					"	<p style=\"font-size: 16px; line-height: 26px; margin-top: 50px; padding: 0 5px;\">\r\n" + 
					"		안녕하세요.<br>\r\n" + 
					"		<맛집갔다갈래>에서 인증메일을 보내드립니다.<br>\r\n<br>" + 
					"		인증코드 : <strong>"+ dice +"</strong><br>\r\n<br> 인증코드를 인증란에 입력해주시길 바랍니다.<br>\r\n" + 
					"		감사합니다.\r\n" + 
					"	</p>\r\n" + 
					"<center>\r\n" + 
					"<a href=\"https://eat-together.net\" target=\"blank\" class=\"myButton\">사이트에 접속하기</a>\r\n" + 
					"</center>\r\n" + 
					"<hr style=\"border: 0; width:500px; height: 0; border-top: 1px solid rgba(0, 0, 0, 0.1); border-bottom: 1px solid rgba(255, 255, 255, 0.3);\">";
			Properties props = new Properties();
			props.put("mail.smtp.host", "smtp.daum.net");
			props.put("mail.smtp.socketFactory.port", "465");
			props.put("mail.smtp.socketFactory.class",
					"javax.net.ssl.SSLSocketFactory");
			props.put("mail.smtp.auth", "true");
			props.put("mail.smtp.port", "465");

			Session session = Session.getDefaultInstance(props,
					new javax.mail.Authenticator() {
				protected PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(username,password);
				}
			});

			try {

				Message message = new MimeMessage(session);
				message.setFrom(new InternetAddress("no-reply@eat-together.net"));
				message.setRecipients(Message.RecipientType.TO,
						InternetAddress.parse(recipient));
				message.setSubject(subject);
				message.setContent(msg, "text/html; charset=utf-8");
				Transport.send(message);


				System.out.println("Email Sending OK");
			} catch (MessagingException e) {
				throw new RuntimeException(e);
			}
			System.out.println("컨트롤러에서 resp 전달: " + resp);
			return resp;
		}
	}


}

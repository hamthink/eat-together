package coma.spring.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import coma.spring.dto.MemberDTO;
import coma.spring.service.MsgService;


@Controller
public class HomeController {

	@Autowired
	private HttpSession session;

	@Autowired
	private MsgService msgservice;

	@RequestMapping("/")
	public String home(){

		if(session.getAttribute("loginInfo")==null) {
			return "home";
		}else {
			MemberDTO mdto = (MemberDTO) session.getAttribute("loginInfo");
			if(mdto.getId().contentEquals("administrator")) {

				return "home";
			}else {
				try {
					int newMsg =msgservice.newmsg(mdto.getNickname());
					session.setAttribute("newMsg", newMsg);
				} catch (Exception e) {
					e.printStackTrace();
					return "error";
				}
				return "home";
			}

		}

	}
	@RequestMapping("/home2")
	public String home2() {
		return "home2";
	}

	@RequestMapping("error")
	public String error() {
		return "error";
	}

}

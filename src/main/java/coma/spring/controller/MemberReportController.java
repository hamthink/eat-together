package coma.spring.controller;

import java.sql.Timestamp;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import coma.spring.dto.MemberDTO;
import coma.spring.dto.MemberReportDTO;
import coma.spring.dto.ReportDTO;
import coma.spring.service.MemberReportService;
import coma.spring.service.MemberService;

@Controller
@RequestMapping("/memreport/")
public class MemberReportController {
	
	@Autowired
	private HttpSession session;
	
	@Autowired
	private MemberReportService mrservice;
	
	@Autowired
	private MemberService mservice;
	
	
	@RequestMapping("toReport")
	public String toReport(HttpServletRequest request) throws Exception {
		MemberDTO loginInfo = (MemberDTO)session.getAttribute("loginInfo");
		request.setAttribute("nick", loginInfo.getNickname());
		return "/memreport/memreport_new";
	}
	
	@ResponseBody
	@RequestMapping("duplCheck")
	public int duplCheck(String nickname) throws Exception {
		if(nickname.equals("administrator")) {
			return 3;
		}
		MemberDTO loginInfo = (MemberDTO)session.getAttribute("loginInfo");
		String reporter = loginInfo.getNickname();
		boolean result = true;
		result = mservice.isNickAvailable(nickname);
		if (!(result)) {
			int check = mrservice.duplCheck(nickname, reporter);
			if (check < 1) {
				return 0;
			}else {
				return 1;
			}
		}else {
			return 2;
		}
	}
	
	@RequestMapping("memReport")
	public String memReport(MemberReportDTO mdto , HttpServletRequest request ,RedirectAttributes redirectAttributes) throws Exception {
		int result = mrservice.memReport(mdto);
		System.out.println("결과 :" +result);
		if(result >0) {
			System.out.println("result : "+result);
			Timestamp stamp = new Timestamp(System.currentTimeMillis());
			redirectAttributes.addFlashAttribute("rdto", new ReportDTO(0,2,mdto.getId(),mdto.getReport_id(),mdto.getTitle(),mdto.getContent(),stamp,result,0));
			return "redirect:/report/newReport/";
		}
		return "/memreport/memreport_new";
	}
	
	
}

package coma.spring.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import coma.spring.dto.MemberDTO;
import coma.spring.dto.ReportDTO;
import coma.spring.service.MemberReportService;
import coma.spring.service.PartyService;
import coma.spring.service.ReportService;
import coma.spring.service.ReviewService;

@Controller
@RequestMapping("/report/")
public class ReportController {
	
	@Autowired
	private PartyService pservice;
	
	@Autowired
	private ReviewService rservice;
	
	@Autowired
	private ReportService reposervice;
	
	@Autowired
	private MemberReportService mrservice;
	
	@Autowired
	private HttpSession session;
	

	// 신고 접수
	@ResponseBody
	@RequestMapping("newReport")
	public int newReport(HttpServletRequest request, RedirectAttributes redirectAttributes, ReportDTO rdto) throws Exception {
		int result = 0;
		Map<String, ?> map = RequestContextUtils.getInputFlashMap(request);
		rdto = (ReportDTO)map.get("rdto");
		int check = reposervice.checkDupl(rdto);
		
		if(rdto.getCategory() == 0) { // 리뷰 신고
			if(check == 0) {
				result = rservice.report(rdto);
			}
		}else if(rdto.getCategory() == 1) { // 모임글 신고
			if(check == 0) {
				result = pservice.partyReport(rdto);
			}
		}else { // 회원 신고
			result = mrservice.memberReport(rdto);
		}
		request.setAttribute("result", result);
		return result;
	}
	
	// 신고 반려
	@ResponseBody
	@RequestMapping("reportRefuse")
	public int reportRefuse(HttpServletRequest request) throws Exception {

		int result=0;
		System.out.println("seq : "+request.getParameter("seq"));
		int repoResult = reposervice.checkReport(Integer.parseInt(request.getParameter("seq")));
		System.out.println("repoResult :"+repoResult);
		if(repoResult == 1) {
			int checkReal = reposervice.checkReal(Integer.parseInt(request.getParameter("category")), Integer.parseInt(request.getParameter("parent_seq")));
			if(checkReal < 1) {
				return 3;
			}
			result = reposervice.repoCountDown(Integer.parseInt(request.getParameter("category")), Integer.parseInt(request.getParameter("parent_seq")));
			System.out.println("result1 : "+result);
		}
		System.out.println("result 2 :"+result);
		return result;
	}
	// 신고 접수
	@ResponseBody
	@RequestMapping("reportAccept")
	public int reportAccept(HttpServletRequest request) throws Exception {
		int seq = Integer.parseInt(request.getParameter("seq"));
		int parent_seq = Integer.parseInt(request.getParameter("parent_seq"));
		int category = Integer.parseInt(request.getParameter("category"));
		int resp = 0;
		int repoResult = reposervice.checkReport(seq);
		if(repoResult ==1) {
			int checkReal = reposervice.checkReal(Integer.parseInt(request.getParameter("category")), Integer.parseInt(request.getParameter("parent_seq")));
			if(checkReal < 1) {
				return 3;
			}
			if(category != 2) {
				repoResult = reposervice.checkOtherRepo(seq , category , parent_seq);
			}
			if(repoResult == 1) {
				System.out.println("report id : "+request.getParameter("report_id"));
				int result=reposervice.acceptReport(request.getParameter("report_id"));
				if(result == 1) {
					resp = reposervice.deleteContent(category, parent_seq);
				}
			}
			
		}
		return resp;
	}
	

	
	
	
}

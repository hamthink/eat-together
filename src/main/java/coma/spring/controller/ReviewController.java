package coma.spring.controller;

import java.io.File;
import java.sql.Timestamp;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.tika.Tika;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import coma.spring.dto.MemberDTO;
import coma.spring.dto.ReportDTO;
import coma.spring.dto.ReviewDTO;
import coma.spring.dto.ReviewFileDTO;
import coma.spring.service.MapService;
import coma.spring.service.MemberService;
import coma.spring.service.ReviewService;

@Controller
@RequestMapping("/review/")
public class ReviewController {

	@Autowired
	private HttpSession session;

	@Autowired
	private ReviewService rservice;
	
	@Autowired
	private MemberService mservice;
	
	@Autowired
	private MapService mapservice;
	
	@RequestMapping("write")
	public String write(ReviewDTO rdto, String place_id, MultipartFile imgFile, HttpServletRequest request) throws Exception{
		// 아이디 세션값에서 가져오기
		MemberDTO mdto = (MemberDTO) session.getAttribute("loginInfo");
		String realPath = null;
		try {
			rdto.setId(mdto.getId());
			rdto.setProfile(mdto.getSysname());
			realPath = session.getServletContext().getRealPath("upload/files");
		}catch(Exception e) {
			return "error/loginPlease";
		}
		// 파일 작업
		File tempFilePath = new File(realPath);
		if(!tempFilePath.exists()) {tempFilePath.mkdirs();}
		UUID uuid = UUID.randomUUID();
		if(imgFile.isEmpty()) { // 이미지 파일을 첨부하지 않은 경우
			rservice.write(rdto);
		}else { // 파일을 첨부한 경우
			ReviewFileDTO rfdto = new ReviewFileDTO();
			rfdto.setOriname(imgFile.getOriginalFilename());
			rfdto.setSysname(uuid+"_"+imgFile.getOriginalFilename());
			File targetLoc = new File(realPath + "/" + rfdto.getSysname());
			imgFile.transferTo(targetLoc);
			String ext = rfdto.getOriname().substring(rfdto.getOriname().lastIndexOf(".") + 1,rfdto.getOriname().length());

			String mimeType = new Tika().detect(targetLoc);
			final String[] EXTENSION = { "image/gif", "image/jpeg", "image/png", "image/bmp" };
			String previousURL = request.getHeader("Referer");
			String hrefURL = previousURL.substring(previousURL.lastIndexOf("/selectMarkerInfo?place_id=")+1,previousURL.length());
            int len = EXTENSION.length;
            boolean possibleExt = false;
            for (int i = 0; i < len; i++) {
                if (mimeType.equals(EXTENSION[i])) {
                	possibleExt = true;
                	break;
                }
            }
            if(!possibleExt) {
            	request.setAttribute("previousURL", hrefURL);
            	return "error/invalidExt";
            }
			rservice.write(rdto,rfdto);
		}
		
		return "redirect:/map/selectMarkerInfo?place_id="+place_id;
	}
	
	//by지은, 마이페이지 - 내모임 리스트 출력하는 select 문 수정_20200709
	@RequestMapping("selectById")
	public ModelAndView selectById() throws Exception{
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("member/mypage_reviewlist");

		MemberDTO mdto = (MemberDTO) session.getAttribute("loginInfo");
		String id = null;
		try{id = mdto.getId();}catch(Exception e) {mav.setViewName("error/loginPlease");}
		
		List<ReviewDTO> reviewList = rservice.selectById(id);
		mav.addObject("reviewList", reviewList);
		
		return mav;
	}
	
	// 예지 : 리뷰 신고 기능
	@RequestMapping("report")
	public String reviewReport(int seq, String report_id, String content, HttpServletRequest request, RedirectAttributes redirectAttributes) throws Exception{
		MemberDTO mdto = (MemberDTO) session.getAttribute("loginInfo");
		// 로그인한 사용자 닉네임
		String id = null;
		try{id= mdto.getNickname();}catch(Exception e) {return "redirect:/error/loginPlease";}
		// 임시 방편으로 닉네임 받아오기 위한 코드 - 추후 아이디 가 아닌 닉네임으로 리뷰 저장으로 변경하자
		MemberDTO mdto2 = mservice.selectMyInfo(request.getParameter("report_id"));
		ReviewDTO dto = rservice.selectBySeq(seq);
		Timestamp stamp = new Timestamp(System.currentTimeMillis());
		redirectAttributes.addFlashAttribute("rdto", new ReportDTO(0,0,id,mdto2.getNickname(),dto.getName() ,request.getParameter("content") ,stamp,seq,0));
		return "redirect:/report/newReport";
	}
	@ResponseBody
	@RequestMapping("reviewDeleteProc") // 체크한 리뷰 삭제시키기
	public int reviewDeleteProc(HttpServletRequest request)throws Exception{
		String data = request.getParameter("seqs"); 
		String seqs = data.substring(2,data.length()-2);
		String[] checkList = seqs.split("\",\"");
		Set<Integer> set = new HashSet<>();
		for(String seq : checkList) {
			int parent_seq = rservice.getParentSeqBySeq(seq);
			set.add(parent_seq);
		}
		System.out.println(set.size());
		int resp = rservice.delete(checkList);
		// 체크 리스트
		for(int parent_seq : set) {
			if(rservice.getCountByParentSeq(parent_seq) == 0) {
				mapservice.updateRatingAvgZero(parent_seq);
			}else{
				mapservice.updateRatingAvg(parent_seq);
			}
		}
		return resp;
	}

}

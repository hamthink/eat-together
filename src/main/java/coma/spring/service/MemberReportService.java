package coma.spring.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import coma.spring.dao.MemberReportDAO;
import coma.spring.dao.ReportDAO;
import coma.spring.dto.MemberReportDTO;
import coma.spring.dto.ReportDTO;

@Service
public class MemberReportService {
	
	@Autowired
	private MemberReportDAO mrdao;
	
	@Autowired
	private ReportDAO rdao;
	
	public int memReport(MemberReportDTO mdto) throws Exception {
		return mrdao.memReport(mdto);
	}
	
	public int duplCheck(String nickname, String reporter) throws Exception{
		return mrdao.duplCheck(nickname , reporter);
	}
	
	public MemberReportDTO selectyById(String id) {
		return mrdao.selectyById(id);
	}
	
	// 태훈 회원 신고
	@Transactional("txManager")
	public int memberReport(ReportDTO rdto) throws Exception{
		
		return rdao.newReport(rdto); // 신고 테이블 insert 문 
	}
	
	// mrdao.confirmReport(rdto.getParent_seq()); // 테이블 신고 컬럼 update 문
}

package coma.spring.dao;

import java.util.HashMap;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import coma.spring.dto.MemberReportDTO;

@Repository
public class MemberReportDAO {
	
	@Autowired
	private SqlSessionTemplate mybatis;
	
	public int memReport(MemberReportDTO mdto) {
		int result = mybatis.insert("MemberReport.memReport", mdto);
		if(result>0) {
			result = mybatis.selectOne("MemberReport.getseq");
		}
		return (result-1);
	}
	
	public int duplCheck(String nickname , String reporter) {
		Map<String , String> param = new HashMap<>();
		param.put("id" , reporter);
		param.put("report_id" , nickname);
		return mybatis.selectOne("MemberReport.duplCheck",param);
	}
	
	public int confirmReport(int seq) {
		return mybatis.update("MemberReport.confirmReport",seq);
	}
	
	public MemberReportDTO selectyById(String id) {
		return mybatis.selectOne("MemberReport.selecById",id);
	}
}

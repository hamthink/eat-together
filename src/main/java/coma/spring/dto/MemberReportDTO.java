package coma.spring.dto;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class MemberReportDTO {
	private int seq;
	private String id;
	private String report_id;
	private String title;
	private String content;
	private Timestamp write_date;
	private int status;
	private String sdate;
	
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getReport_id() {
		return report_id;
	}
	public void setReport_id(String report_id) {
		this.report_id = report_id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Timestamp getWrite_date() {
		return write_date;
	}
	public void setWrite_date(Timestamp write_date) {
		this.write_date = write_date;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	
	public String getSdate() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	    String sdate = sdf.format(write_date);
	    System.out.println(sdate);
		return sdate;
	}
	public void setSdate(String sdate) {
		this.sdate=sdate;
	}
	public MemberReportDTO(int seq, String id, String report_id, String title, String content, Timestamp write_date, int status) {
		super();
		this.seq = seq;
		this.id = id;
		this.report_id = report_id;
		this.title = title;
		this.content = content;
		this.write_date = write_date;
		this.status = status;
		this.sdate=new SimpleDateFormat("yyyy-MM-dd-HH:mm").format(write_date);
	}
	public MemberReportDTO() {
		super();
	}

}

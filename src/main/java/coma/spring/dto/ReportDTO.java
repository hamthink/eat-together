package coma.spring.dto;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class ReportDTO {
	private int seq;
	private int category;
	private String id;
	private String report_id;
	private String title;
	private String content;
	private Timestamp report_date;
	private int parent_seq;
	private int status;
	private String sdate;
	
	public ReportDTO() {
		super();
	}
	
	public ReportDTO(int seq, int category, String id, String report_id, String title, String content, Timestamp report_date, int parent_seq, int status) {
		super();
		this.seq = seq;
		this.category = category;
		this.id = id;
		this.report_id = report_id;
		this.title = title;
		this.content = content;
		this.report_date = report_date;
		this.parent_seq = parent_seq;
		this.status = status;
		this.sdate=new SimpleDateFormat("yyyy-MM-dd-HH:mm").format(report_date);
	}
	
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public int getCategory() {
		return category;
	}
	public void setCategory(int category) {
		this.category = category;
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
	public Timestamp getReport_date() {
		return report_date;
	}
	public void setReport_date(Timestamp report_date) {
		this.report_date = report_date;
	}
	public int getParent_seq() {
		return parent_seq;
	}
	public void setParent_seq(int parent_seq) {
		this.parent_seq = parent_seq;
	}
	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}
	public String getSdate() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	    String sdate = sdf.format(report_date);
	    System.out.println(sdate);
		return sdate;
	}
	public void setSdate(String sdate) {
		this.sdate=sdate;
	}
}

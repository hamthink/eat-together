package coma.spring.controller;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultHandlers;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import coma.spring.dto.MemberDTO;

@RunWith(SpringJUnit4ClassRunner.class) 
@WebAppConfiguration 
@ContextConfiguration(locations= {
		"file:src/main/webapp/WEB-INF/spring/root-context.xml",
		"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"
})
public class ReviewTest {
	private static final Logger logger = LoggerFactory.getLogger(MapTest.class);
	@Autowired
	private WebApplicationContext wac;
	private MockMvc mockMvc;
	protected MockHttpSession session;
	protected MockHttpServletRequest request;
	
	@Before
	public void setup() {
		this.mockMvc = MockMvcBuilders.webAppContextSetup(this.wac).build();
	    MemberDTO mdto = new MemberDTO();
	    mdto.setId("test12345");
	    mdto.setPw("y21a+VZBkWwmxJPE9N5lbUy8xBA9Qgjwit2zbr+EouprRmutAIV+5a7ri7QYZfl86rNhpNNItI2zqzxZsuBgjg==");
	    mdto.setNickname("졸려라");
	    mdto.setBirth("1995-03-01");
	    mdto.setAccount_email("sinyeji95@naver.com");
	    mdto.setReport_count(0);
	    mdto.setGender(2);
	    mdto.setMember_type("site");
	    session = new MockHttpSession();
	    session.setAttribute("loginInfo", mdto);
	    session.getServletContext().getRealPath("upload/files");
	    request = new MockHttpServletRequest();
	    request.setSession(session);
	    RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(request));
	    request.getSession().getServletContext().getRealPath("upload/files");
	}

	@Test 
	public void reviewWriteTest() {
		try {
			mockMvc.perform(MockMvcRequestBuilders.post("/review/write").session(this.session).param("id", "test12345").param("content", "북어가 맛있고 시끌벅적 즐거운 곳~!").param("rating", "5").param("parent_seq","123").param("place_id", "11064200"))
			.andDo(MockMvcResultHandlers.print())
			.andExpect(MockMvcResultMatchers.status().isOk()); 
			logger.info("리뷰 작성 Test 성공!");
		} catch (Exception e) {
			logger.error("리뷰 작성 Test 실패 : " + e.getMessage());
			e.printStackTrace();
		}
	}
	@Test 
	public void reviewReportTest() {
		try {
			mockMvc.perform(MockMvcRequestBuilders.post("/review/report").session(this.session).param("seq", "77"))
			.andDo(MockMvcResultHandlers.print())
			.andExpect(MockMvcResultMatchers.status().isOk()); 
			logger.info("리뷰 신고 Test 성공!");
		} catch (Exception e) {
			logger.error("리뷰 신고 Test 실패 : " + e.getMessage());
			e.printStackTrace();
		}
	}
}

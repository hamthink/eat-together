package coma.spring.controller;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultHandlers;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

//스프링 기능 테스트하기 위해서 필수적으로 필요한 설정들
@RunWith(SpringJUnit4ClassRunner.class) // 아래 클래스가 JUnit4 로 동작하도록 작성 - RunWith : Native 에서 동작 시키는 용도
@WebAppConfiguration // pom.xml 의 spring-test 에서 나오는 Annotation - 톰캣 실행 ( 웹 환경 구성 )
@ContextConfiguration(locations= {
      "file:src/main/webapp/WEB-INF/spring/root-context.xml",
      "file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"
})
public class ReportTest {
   private static final Logger logger = LoggerFactory.getLogger(ReportTest.class); // 어느 클래스에서 테스트되는 기록 용도
   @Autowired
   private WebApplicationContext wac; // 톰캣이 실행되는 효과를 주는 웹 환경 구성 역할의 인스턴스
   private MockMvc mockMvc; // 테스트 기능을 갖고 있는 인스턴스 

   @Before // 테스트 코드보다 먼저 실행되는 코드
   public void setup() {
      this.mockMvc = MockMvcBuilders.webAppContextSetup(this.wac).build();
   }

   @Test 
   public void toReportTest() {
      try {
         mockMvc.perform(MockMvcRequestBuilders.get("/memreport/toReport"))
         .andDo(MockMvcResultHandlers.print())
         .andExpect(MockMvcResultMatchers.status().isOk()); 
         logger.info("회원 신고 페이지 이동 Test 성공!");
      } catch (Exception e) {
         logger.error("회원 신고 페이지 이동 Test 실패 : " + e.getMessage());
         e.printStackTrace();
      }
   }
   @Test 
   public void duplCheckTest() {
      try {
         mockMvc.perform(MockMvcRequestBuilders.get("/memreport/duplCheck").
        		 param("nickname", "차간단투"))
         .andDo(MockMvcResultHandlers.print())
         .andExpect(MockMvcResultMatchers.status().isOk()); 
         logger.info("중복 신고 검사 Test 성공!");
      } catch (Exception e) {
         logger.error("중복 신고 검사 Test 실패 : " + e.getMessage());
         e.printStackTrace();
      }
   }
   @Test 
   public void memReportTest() {
      try {
         mockMvc.perform(MockMvcRequestBuilders.get("/memreport/memReport"))
         .andDo(MockMvcResultHandlers.print())
         .andExpect(MockMvcResultMatchers.status().isOk());
         logger.info("회원 신고Test 성공!");
      } catch (Exception e) {
         logger.error("회원 신고 Test 실패 : " + e.getMessage());
         e.printStackTrace();
      }
   }

}
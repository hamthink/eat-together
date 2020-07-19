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
public class MapTest {
	private static final Logger logger = LoggerFactory.getLogger(MapTest.class); // 어느 클래스에서 테스트되는 기록 용도
	@Autowired
	private WebApplicationContext wac; // 톰캣이 실행되는 효과를 주는 웹 환경 구성 역할의 인스턴스
	private MockMvc mockMvc; // 테스트 기능을 갖고 있는 인스턴스 

	@Before // 테스트 코드보다 먼저 실행되는 코드
	public void setup() {
		this.mockMvc = MockMvcBuilders.webAppContextSetup(this.wac).build();
	}

	@Test 
	public void toMapTest() {
		try {
			mockMvc.perform(MockMvcRequestBuilders.post("/map/toMap"))
			.andDo(MockMvcResultHandlers.print())
			.andExpect(MockMvcResultMatchers.status().isOk()); 
			logger.info("지도형 페이지 이동 Test 성공!");
		} catch (Exception e) {
			logger.error("지도형 페이지 이동 Test 실패 : " + e.getMessage());
			e.printStackTrace();
		}
	}
	@Test 
	public void searchTest() {
		try {
			mockMvc.perform(MockMvcRequestBuilders.get("/map/search").
					param("keyword","와플대학"))
			.andDo(MockMvcResultHandlers.print())
			.andExpect(MockMvcResultMatchers.status().isOk()); 
			logger.info("검색 Test 성공!");
		} catch (Exception e) {
			logger.error("검색 Test 실패 : " + e.getMessage());
			e.printStackTrace();
		}
	}
	@Test 
	public void searchByCafeTest() {
		try {
			mockMvc.perform(MockMvcRequestBuilders.get("/map/searchCafeBtn"))
			.andDo(MockMvcResultHandlers.print())
			.andExpect(MockMvcResultMatchers.status().isOk());
			logger.info("카테고리 - 버튼형 전체 카페 검색 Test 성공!");
		} catch (Exception e) {
			logger.error("카테고리 - 버튼형 전체 카페 검색 Test 실패 : " + e.getMessage());
			e.printStackTrace();
		}
	}
	@Test 
	public void searchByFoodTest() {
		try {
			mockMvc.perform(MockMvcRequestBuilders.get("/map/searchFoodBtn"))
			.andDo(MockMvcResultHandlers.print())
			.andExpect(MockMvcResultMatchers.status().isOk());
			logger.info("카테고리 - 버튼형 전체 음식점 검색 Test 성공!");
		} catch (Exception e) {
			logger.error("카테고리 - 버튼형 전체 음식점 검색 Test 실패 : " + e.getMessage());
			e.printStackTrace();
		}
	}
	@Test 
	public void cafeInsertTest() {
		try {
			mockMvc.perform(MockMvcRequestBuilders.get("/map/cafeInsert").
					param("lng","126.80189915794823").
					param("lat","37.2904445806462"))
			.andDo(MockMvcResultHandlers.print())
			.andExpect(MockMvcResultMatchers.status().isOk());
			logger.info("내 주변 카페 가게 json 파일에 입력 Test 성공!");
		} catch (Exception e) {
			logger.error("내 주변 카페 가게 json 파일에 입력 Test 실패 : " + e.getMessage());
			e.printStackTrace();
		}
	}
	@Test 
	public void foodInsertTest() {
		try {
			mockMvc.perform(MockMvcRequestBuilders.get("/map/foodInsert").
					param("lng","126.80189915794823").
					param("lat","37.2904445806462"))
			.andDo(MockMvcResultHandlers.print())
			.andExpect(MockMvcResultMatchers.status().isOk());
			logger.info("내 주변 카페 음식점 json 파일에 입력 Test 성공!");
		} catch (Exception e) {
			logger.error("내 주변 카페 음식점 json 파일에 입력 Test 실패 : " + e.getMessage());
			e.printStackTrace();
		}
	}
}

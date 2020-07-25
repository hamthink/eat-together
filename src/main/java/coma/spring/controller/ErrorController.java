package coma.spring.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/error/")
public class ErrorController {

	
	@RequestMapping("partyfullError")
	public String toPartyfull() {
		return "/error/partyfull";
	}
	@RequestMapping("adminpermission")
	public String toAdminPermission() {
		return "/error/adminpermission";
	}
	@RequestMapping("writepermition")
	public String toWritePermition() {
		return "/error/writepermition";
	}
	@RequestMapping("loginPlease")
	public String toLoginPlease() {
		return "/error/loginPlease";
	}
}

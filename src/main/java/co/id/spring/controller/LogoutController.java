package co.id.spring.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class LogoutController{
	@RequestMapping("/Logout")
	public String logout(HttpServletRequest req, HttpServletResponse resp){
		HttpSession session = req.getSession(false);
		session.removeAttribute("username");
		session.removeAttribute("email");
		session.removeAttribute("level");
		session.invalidate();
		
		return "redirect:/";
	}
}

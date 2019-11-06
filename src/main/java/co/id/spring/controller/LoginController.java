package co.id.spring.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.SessionTrackingMode;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.WebApplicationInitializer;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import co.id.spring.model.SektorModel;
import co.id.spring.model.UserModel;
import co.id.spring.util.AccessDB;
import co.id.spring.util.DBConnection;



@Controller
public class LoginController implements WebApplicationInitializer{
	
	@Override
	public void onStartup(ServletContext servletContext) throws ServletException {
		// TODO Auto-generated method stub
		HashSet<SessionTrackingMode> set = new HashSet<SessionTrackingMode>();
        set.add(SessionTrackingMode.COOKIE);
        servletContext.setSessionTrackingModes(set);
	}	

	DBConnection dbHelper = new DBConnection();
	
	@RequestMapping("/Login")
    public ModelAndView login(HttpServletRequest request, HttpServletResponse response) {
HttpSession session = request.getSession();		
		
		if(session.getAttribute("username") != null){
//			return new ModelAndView("dashboard");
			return new ModelAndView("redirect:/Dashboard");
		}
		
		String msg;
        msg = "Login Page";
		return new ModelAndView("login", "msg", msg);
        
    }
	
	@RequestMapping("/Home")
    public ModelAndView ceklogin(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {

		HttpSession session = request.getSession();		
		
		if(session.getAttribute("username") != null){
//			return new ModelAndView("dashboard");
			return new ModelAndView("redirect:/Dashboard");
		}

        String user;
        String pass;
		if (request.getParameter("username") != null && request.getParameter("password") != null){
	        user = request.getParameter("username");
	        pass = request.getParameter("password");			
		}else {
			return new ModelAndView("redirect:/Login");
		}        
        
        List<UserModel> validateLogin = null;
        
        try {
			validateLogin = AccessDB.validationUserLogin(user, pass);
		} catch (ClassNotFoundException e) {
			session.setAttribute("msg", "server");
    		return new ModelAndView("login");
		}catch (SQLException e) {
			session.setAttribute("msg", "server");
    		return new ModelAndView("login");
		}
        
        if(validateLogin != null){
        	session.setAttribute("email", validateLogin.get(0).getEmail());
        	session.setAttribute("username", validateLogin.get(0).getUsername());
        	session.setAttribute("level", validateLogin.get(0).getLevel());
        	session.setAttribute("user_id", validateLogin.get(0).getUserID());
        	
        	return new ModelAndView("redirect:/Dashboard");
        }else{
        	session.setAttribute("msg", "error");
    		return new ModelAndView("login");
        }
        
    }
	
}
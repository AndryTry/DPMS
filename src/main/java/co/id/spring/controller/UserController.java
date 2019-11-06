package co.id.spring.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.bind.annotation.ResponseBody;

import co.id.spring.model.UserModel;
import co.id.spring.util.AccessDB;


@Controller
public class UserController {
	@RequestMapping(value={"/User", "User_p"})
    public ModelAndView user(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {

		HttpSession session = request.getSession();
		System.out.println("add");
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return new ModelAndView("redirect:/Login");
		}
		
		int user_level = Integer.parseInt(session.getAttribute("level").toString());
		if (user_level < 3){
			return new ModelAndView("redirect:/Dashboard");
		}
		
		List<UserModel> userList = null;

		try {
			userList = AccessDB.getAllUsers();
			ModelAndView mv = new ModelAndView("user");
			mv.addObject("userList", userList);
						
			return mv;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return new ModelAndView("user");
		}catch (SQLException e) {
			e.printStackTrace();
			return new ModelAndView("user");
		}
		
        
    }
	
	@RequestMapping("/User/EditUser")
    public String editUser(HttpServletRequest request, HttpServletResponse response,
    		@RequestParam(value="user_id", required = true) int id_user) throws IOException, ParseException {
		
		HttpSession session = request.getSession();

		System.out.println("edit");
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}
		
		int user_level = Integer.parseInt(session.getAttribute("level").toString());
		if (user_level < 3){
			new ModelAndView("redirect:/Dashboard");
		}
		
		String username = request.getParameter("name");
		String password = request.getParameter("password");
//		String email = request.getParameter("email");
		String level = request.getParameter("level");
		String desc = request.getParameter("description");
		String ganti_password = request.getParameter("ganti_password");
		int hasil = 0;
		
		System.out.println(ganti_password);
		System.out.println(password.trim().length());
		
		if(ganti_password != null && password.trim().length() <= 7){
			session.setAttribute("errorCreateUser", "errorCreateUser");
			session.setAttribute("msg", "password");
			return "redirect:/User";
		}
		
		try {
			hasil = AccessDB.updateUser(id_user, username, password, level, desc, ganti_password);
			if(hasil > 0){
				return "redirect:/User";				
			}else{
				session.setAttribute("errorCreateUser", "errorCreateUser");
				session.setAttribute("msg", "check your input field !!");
				return "redirect:/User";
			}
		} catch (ClassNotFoundException e) {
			session.setAttribute("errorCreateUser", "errorCreateUser");
			session.setAttribute("msg", "check your input field !!");
			return "redirect:/User";
		}catch (SQLException e) {
			session.setAttribute("errorCreateUser", "errorCreateUser");
			session.setAttribute("msg", "check your input field !!");
			return "redirect:/User";
		}
        
    }
	
	@RequestMapping("/User/SaveUser")
    public String createUser(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
		
		HttpSession session = request.getSession();

		System.out.println("delete");
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}
		
		int user_level = Integer.parseInt(session.getAttribute("level").toString());
		if (user_level < 3){
			return "redirect:/Dashboard";
		}
		
		String username = request.getParameter("name");
		String password = request.getParameter("password");
		String email = request.getParameter("email");
		String level = request.getParameter("level");
		String desc = request.getParameter("desc");
		int hasil = 0;
		String msg = "";
		
		if(password.trim().length() <= 7){
			msg = "password";
			session.setAttribute("errorCreateUser", "errorCreateUser");
			session.setAttribute("msg", msg);
			return "redirect:/User";
		}
		
		try {
			hasil = AccessDB.createNewUser(username, password, email, level, desc);
			if(hasil > 0){
				return "redirect:/User";				
			}else{
				msg = "Duplicate email address !!";
				session.setAttribute("msg", msg);
				session.setAttribute("errorCreateUser", "duplicate");
				return "redirect:/User";
			}
		} catch (ClassNotFoundException e) {
			msg = "Duplicate email address !!";
			session.setAttribute("msg", msg);
			session.setAttribute("errorCreateUser", "errorCreateUser");
			return "redirect:/User";
		} catch (SQLException e) {
			msg = "Duplicate email address !!";
			session.setAttribute("msg", msg);
			session.setAttribute("errorCreateUser", "errorCreateUser");
			return "redirect:/User";
		}
        
    }
	
	
	@RequestMapping("/User/DeleteUser")
    public String deleteUser(HttpServletRequest request, HttpServletResponse response,
    		@RequestParam(value="user_id", required = true) int id_user) throws IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}
		
		int user_level = Integer.parseInt(session.getAttribute("level").toString());
		if (user_level < 3){
			return "redirect:/Dashboard";
		}
		
		try {
			AccessDB.deleteUser(id_user);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
        return "redirect:/User";
        
    }
	
	@RequestMapping("/User/CheckUser") 
	@ResponseBody
	public String checkUser(HttpServletRequest request, HttpServletResponse response) {
 
	    String email = request.getParameter("email");		
		int hasil = 0;
		
		try {
			hasil = AccessDB.checkUserEmail(email);
			
			if(hasil > 0){
				return "true";
			}else {
				return "false";
			}
		
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return "false";
		} catch (SQLException e) {
			e.printStackTrace();
			return "false";
		}catch (Exception e) {
			e.printStackTrace();
			return "false";
		}
	}
}
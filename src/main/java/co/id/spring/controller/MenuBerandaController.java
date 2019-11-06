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

import co.id.spring.model.MenuBerandaModel;
import co.id.spring.util.AccessDB;

@Controller
public class MenuBerandaController {
	@RequestMapping("/Menu_beranda")
    public ModelAndView user(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
		
		List<MenuBerandaModel> menuList = null;
		
		try {
			menuList = AccessDB.getAllMenu();
			ModelAndView mv = new ModelAndView("menu_beranda");
			mv.addObject("menuList", menuList);
			return mv;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return new ModelAndView("menu_beranda");
		}catch (SQLException e) {
			e.printStackTrace();
			return new ModelAndView("menu_beranda");
		}
		
        
    }
	
	@RequestMapping("/Menu_beranda/Edit")
    public String editUser(HttpServletRequest request, HttpServletResponse response,
    		@RequestParam(value="id_menu", required = true) int id_menu) throws IOException, ParseException {
		
		HttpSession session = request.getSession();
		String nama_menu = request.getParameter("name");
		String url = request.getParameter("url");
		String jenis = request.getParameter("jenis");
		String content = request.getParameter("content");
		int hasil = 0;
		
		try {
			hasil = AccessDB.updateMenu(id_menu, nama_menu, url, jenis, content);
			if(hasil > 0){
				return "redirect:/Menu_beranda";				
			}else{
				session.setAttribute("errorCreateUser", "errorCreateUser");
				session.setAttribute("msg", "check your input field !!");
				return "redirect:/Menu_beranda";
			}
		} catch (ClassNotFoundException e) {
			session.setAttribute("errorCreateUser", "errorCreateUser");
			session.setAttribute("msg", "check your input field !!");
			return "redirect:/Menu_beranda";
		}catch (SQLException e) {
			session.setAttribute("errorCreateUser", "errorCreateUser");
			session.setAttribute("msg", "check your input field !!");
			return "redirect:/Menu_beranda";
		}
        
    }
	
	@RequestMapping("/Menu_beranda/Add")
    public String createUser(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
		
		HttpSession session = request.getSession();
		String nama_menu = request.getParameter("name");
		String url = request.getParameter("url");
		String jenis = request.getParameter("jenis");
		String content = request.getParameter("content");
		int hasil = 0;
		String msg = "";
		
		try {
			hasil = AccessDB.createNewMenu(nama_menu, url, jenis, content);
			if(hasil > 0){
				return "redirect:/Menu_beranda";				
			}else{
				session.setAttribute("msg", msg);
				session.setAttribute("errorCreateUser", "errorCreateUser");
				return "redirect:/Menu_beranda";
			}
		} catch (ClassNotFoundException e) {
			session.setAttribute("msg", msg);
			session.setAttribute("errorCreateUser", "errorCreateUser");
			return "redirect:/Menu_beranda";
		} catch (SQLException e) {
			session.setAttribute("msg", msg);
			session.setAttribute("errorCreateUser", "errorCreateUser");
			return "redirect:/Menu_beranda";
		}
        
    }
	
	@RequestMapping("/Menu_beranda/Delete")
    public String deleteUser(@RequestParam(value="id_menu", required = true) int id_menu) throws IOException, ParseException {
		
		try {
			AccessDB.deleteMenu(id_menu);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
        return "redirect:/Menu_beranda";
        
    }
}

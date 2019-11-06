package co.id.spring.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import co.id.spring.util.AccessDB;
import co.id.spring.model.SektorModel;

@Controller
public class SektorController {

	@RequestMapping("/Sektor")
    public ModelAndView sektor(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return new ModelAndView("redirect:/Login");
		}
		
		int user_level = Integer.parseInt(session.getAttribute("level").toString());
		if (user_level < 3){
			return new ModelAndView("redirect:/Dashboard");
		}
		
		List<SektorModel> sektorList = null;
		
		try {
			sektorList = AccessDB.getAllSektor();
			ModelAndView mv = new ModelAndView("sektor");
			mv.addObject("sektorList", sektorList);
			return mv;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return new ModelAndView("sektor");
		}catch (SQLException e) {
			e.printStackTrace();
			return new ModelAndView("sektor");
		}
		
       
    }
	
	
	@RequestMapping("/Sektor/Add")
    public String createSektor(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {

		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}
		
		int user_level = Integer.parseInt(session.getAttribute("level").toString());
		if (user_level < 3){
			return "redirect:/Dashboard";
		}
		
		String namasektor = request.getParameter("namasektor");
		int hasil = 0;
		String msg = "";
		
		
		try {
			hasil = AccessDB.createNewSektor(namasektor);
			return "redirect:/Sektor";
		} catch (ClassNotFoundException e) {
			return "redirect:/Sektor";
		} catch (SQLException e) {
			return "redirect:/Sektor";
		}
        
    }
	
	@RequestMapping("/Sektor/Edit")
    public String editSektor(HttpServletRequest request, HttpServletResponse response) throws NumberFormatException, IOException, ParseException {
		
		HttpSession session = request.getSession();
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}
		
		int user_level = Integer.parseInt(session.getAttribute("level").toString());
		if (user_level < 3){
			return "redirect:/Dashboard";
		}
		
		String namasektor = request.getParameter("name");
		String id_sektor = request.getParameter("sektor_id");
		
		if (namasektor.toString().isEmpty() || namasektor.toString() == null){
			session.setAttribute("sektorNull", "sektorNull");
			return "redirect:/Sektor";	
		}
		
		System.out.println(id_sektor);
		int hasil = 0;
		try {
			hasil = AccessDB.updateSektor(Integer.parseInt(id_sektor), namasektor);
			if(hasil > 0){
				return "redirect:/Sektor";				
			}else{
				return "redirect:/Sektor";
			}
		} catch (ClassNotFoundException e) {
			return "redirect:/Sektor";
		}catch (SQLException e) {
			return "redirect:/Sektor";
		}
        
    }
	
	@RequestMapping("/Sektor/Delete")
    public String deleteSektor(HttpServletRequest request, HttpServletResponse response,
    		@RequestParam(value="sektor_id", required = true) int idsektor) throws IOException, ParseException {

		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}
		
		int user_level = Integer.parseInt(session.getAttribute("level").toString());
		if (user_level < 3){
			return "redirect:/Dashboard";
		}
		
		try {
			AccessDB.deleteSektor(idsektor);;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
        return "redirect:/Sektor"; 
        
    }
	
	
	@RequestMapping("/Sektor/CheckSektor")  
	@ResponseBody
	public String checkUser(HttpServletRequest request, HttpServletResponse response) {
 
	    String name = request.getParameter("name");		
		int hasil = 0;
		
		try {
			hasil = AccessDB.checkSektor(name);
			
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
	
	@RequestMapping("/Sektor/CheckHapusSektor")     
	@ResponseBody
	public String checkHapusSektor(HttpServletRequest request, HttpServletResponse response) {
 
	    String id = request.getParameter("id_sektor");		
		int hasil = 0;
		
		try {
			hasil = AccessDB.checkHapusSektor(id);
			
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

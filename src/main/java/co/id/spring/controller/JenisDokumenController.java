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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import co.id.spring.model.JenisDokumenModel;
import co.id.spring.util.AccessDB;

@Controller
public class JenisDokumenController {
	@RequestMapping("/Jenis_dokumen")
    public ModelAndView jenisDokumen(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return new ModelAndView("redirect:/Login");
		}
		
		int user_level = Integer.parseInt(session.getAttribute("level").toString());
		if (user_level < 3){
			return new ModelAndView("redirect:/Dashboard");
		}
		
		List<JenisDokumenModel> jdList = null;
		
		try {
			jdList = AccessDB.getAllJenisDokumen();
			ModelAndView mv = new ModelAndView("jenis_dokumen");
			mv.addObject("jdList", jdList);
			return mv;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return new ModelAndView("jenis_dokumen");
		}catch (SQLException e) {
			e.printStackTrace();
			return new ModelAndView("jenis_dokumen");
		}
		
        
    }
	
	@RequestMapping("/Jenis_dokumen/Edit")
    public String editJenisDokumen(HttpServletRequest request, HttpServletResponse response,
    		@RequestParam(value="id_jenis_dokumen", required = true) int id_jd) throws IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}
		
		int user_level = Integer.parseInt(session.getAttribute("level").toString());
		if (user_level < 3){
			return "redirect:/Dashboard";
		}
		
		String nama_jd = request.getParameter("name");
		
		if (nama_jd.toString().isEmpty() || nama_jd.toString() == null){
			session.setAttribute("jenisDocNull", "jenisDocNull");
			return "redirect:/Jenis_dokumen";	
		}
		
		int hasil = 0;
		
		try {
			hasil = AccessDB.updateJenisDokumen(id_jd, nama_jd);
			if(hasil > 0){
				return "redirect:/Jenis_dokumen";				
			}else{
				session.setAttribute("errorCreateUser", "errorCreateUser");
				session.setAttribute("msg", "check your input field !!");
				return "redirect:/Jenis_dokumen";
			}
		} catch (ClassNotFoundException e) {
			session.setAttribute("errorCreateUser", "errorCreateUser");
			session.setAttribute("msg", "check your input field !!");
			return "redirect:/Jenis_dokumen";
		}catch (SQLException e) {
			session.setAttribute("errorCreateUser", "errorCreateUser");
			session.setAttribute("msg", "check your input field !!");
			return "redirect:/Jenis_dokumen";
		}
        
    }
	
	@RequestMapping("/Jenis_dokumen/Add")
    public String tambahJenisDokumen(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}
		
		int user_level = Integer.parseInt(session.getAttribute("level").toString());
		if (user_level < 3){
			return "redirect:/Dashboard";
		}
		
		String nama_jd = request.getParameter("name");
		int hasil = 0;
		String msg = "";
		
		try {
			hasil = AccessDB.createJenisDokumen(nama_jd);
			if(hasil > 0){
				return "redirect:/Jenis_dokumen";				
			}else{
				session.setAttribute("msg", msg);
				session.setAttribute("errorCreateUser", "errorCreateUser");
				return "redirect:/Jenis_dokumen";
			}
		} catch (ClassNotFoundException e) {
			session.setAttribute("msg", msg);
			session.setAttribute("errorCreateUser", "errorCreateUser");
			return "redirect:/Jenis_dokumen";
		} catch (SQLException e) {
			session.setAttribute("msg", msg);
			session.setAttribute("errorCreateUser", "errorCreateUser");
			return "redirect:/Jenis_dokumen";
		}
        
    }
	
	@RequestMapping("/Jenis_dokumen/Delete")
    public String hapusJenisDokummen(HttpServletRequest request, HttpServletResponse response,
    		@RequestParam(value="id_jenis_dokumen", required = true) int id_jd) throws IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}
		
		int user_level = Integer.parseInt(session.getAttribute("level").toString());
		if (user_level < 3){
			return "redirect:/Dashboard";
		}
		
		try {
			AccessDB.deleteJenisDokumen(id_jd);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
        return "redirect:/Jenis_dokumen";
        
    }
	
	@RequestMapping("/Jenis_dokumen/CheckJD")
	@ResponseBody
	public String checkUser(HttpServletRequest request, HttpServletResponse response) {
 
	    String name = request.getParameter("name");		
		int hasil = 0;
		
		try {
			hasil = AccessDB.checkJD(name);
			
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
	
	@RequestMapping("/Jenis_dokumen/CheckHapusJD")     
	@ResponseBody
	public String checkHapusJD(HttpServletRequest request, HttpServletResponse response) {
 
	    String id = request.getParameter("id");		
		int hasil = 0;
		
		try {
			hasil = AccessDB.checkHapusJD(id);
			
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
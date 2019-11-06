package co.id.spring.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map; 

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import co.id.spring.model.ProjectModel;
import co.id.spring.model.SektorModel;
import co.id.spring.util.AccessDB;

@Controller
public class DmsController {
	@RequestMapping(value={"/DMS", "/DMS/"})
	public ModelAndView dms(HttpServletRequest request, HttpServletResponse response) {

		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return new ModelAndView("redirect:/Login");
		}
		
		Map<String, Object> model = new HashMap<String, Object>();
        List<ProjectModel> userList = null;
        List<SektorModel> sector = null;
        
        try {
        	userList = AccessDB.getAllProject();
        	sector = AccessDB.getAllSector();
        	model.put("userlist", userList);
        	model.put("sector", sector);
        	model.put("user_id", session.getAttribute("user_id").toString());
       } catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}
        
		return new ModelAndView("dms", "msg", model);
        
    }
	
	
	@RequestMapping("/DMS/search_proyek")
    public ModelAndView searchProject(HttpServletRequest request, HttpServletResponse response) {
		//String msg;
		//data: {jenis_dok:jenis_dok, foldername:foldername, no_surat:no_surat, tgl_surat:tgl_surat, perihal:perihal, sektor:sektor,proyekname:proyekname},
        // msg = "Project Management";
		HttpSession session = request.getSession();
		
		String jenis_dok = request.getParameter("jenis_dok");
		String no_surat = request.getParameter("no_surat");
		String tgl_surat = request.getParameter("tgl_surat");
		String perihal = request.getParameter("perihal");
		String sektor = request.getParameter("sktor");
		String proyekname = request.getParameter("proyekname");
		
		//System.out.println("jenis_dok:"+jenis_dok + "|no_surat:"+no_surat +"|tgl_surat:"+tgl_surat + "|perihal:"+perihal+"|sektor:"+sektor+"|proyekname:"+proyekname);
		
		Map<String, Object> model = new HashMap<String, Object>();
        List<ProjectModel> userList = null;
        List<SektorModel> sector = null;
        
        try {
        	userList = AccessDB.searchProject(jenis_dok, no_surat, tgl_surat, perihal,sektor ,proyekname);
        	sector = AccessDB.getAllSector();
        	model.put("userlist", userList);
        	model.put("sector", sector);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}
        
		return new ModelAndView("search_proyek", "msg", model);
        
        
    }
	
	@RequestMapping("/DMS/cek_proyek")     
	@ResponseBody
	public String check(HttpServletRequest request, HttpServletResponse response, Model model) {
 
	    String proyek_name = request.getParameter("proyek_name");		
		int hasil = 0;
		
		try {
			hasil = AccessDB.cek_ProjectDMS(proyek_name);
			
			if(hasil > 0){
				model.addAttribute(true);
				return "true";
			}else {
				model.addAttribute(false);
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

	
	@RequestMapping("/DMS/SaveProject")
    public String createProject(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
		
		HttpSession session = request.getSession();
		String proyek_name = request.getParameter("proyek_name");
		String proyek_region = request.getParameter("proyek_region");
		//String proyek_progress = request.getParameter("proyek_progress");
		String proyek_sektor = request.getParameter("proyek_sektor");
		String user_id = request.getParameter("user_id");

		int hasil = 0;
		try {
			hasil = AccessDB.createNewProject(proyek_name, proyek_region, proyek_sektor, user_id);
			if(hasil > 0){
				AccessDB.createDefaultFolder();
				return "redirect:/DMS";				
			}else{
				session.setAttribute("errorCreateUser", "errorCreateUser");
				return "redirect:/DMS";
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			session.setAttribute("errorCreateUser", "errorCreateUser");
			return "redirect:/DMS";
		} catch (SQLException e){
			e.printStackTrace();
			session.setAttribute("errorCreateUser", "errorCreateUser");
			return "redirect:/DMS";			
		}
    }
	
	
	@RequestMapping("/DMS/DeleteProject")
    public String deleteProject(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
		
		HttpSession session = request.getSession();
		String proyek_id = request.getParameter("id");
		
		int hasil = 0;
		try {
			hasil = AccessDB.deleteProject(proyek_id);
			if(hasil > 0){
				return "redirect:/DMS";				
			}else{
				session.setAttribute("errorCreateUser", "errorCreateUser");
				return "redirect:/DMS";
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			session.setAttribute("errorCreateUser", "errorCreateUser");
			return "redirect:/DMS";
		}catch (SQLException e) {
			e.printStackTrace();
			session.setAttribute("errorCreateUser", "errorCreateUser");
			return "redirect:/DMS";			
		}
        
    }
	
	
	@RequestMapping("/DMS/UpdateProject")
    public String updateProject(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
		
		HttpSession session = request.getSession();
		String proyek_id = request.getParameter("id");
		String proyek_name = request.getParameter("proyek_name");
		String proyek_region = request.getParameter("proyek_region");
		String proyek_sektor = request.getParameter("proyek_sektor");
		//System.out.println(proyek_id+"|" + proyek_name +"|" + proyek_region+"|"+proyek_sektor);
		int hasil = 0;
		try {
			hasil = AccessDB.updateProject(proyek_id, proyek_name, proyek_region, proyek_sektor);
			if(hasil > 0){
				return "redirect:/DMS";				
			}else{
				session.setAttribute("errorCreateUser", "errorCreateUser");
				return "redirect:/DMS";
			}
		}  catch (ClassNotFoundException e) {
			e.printStackTrace();
			session.setAttribute("errorCreateUser", "errorCreateUser");
			return "redirect:/DMS";
		} catch (SQLException e) {
			e.printStackTrace();
			session.setAttribute("errorCreateUser", "errorCreateUser");
			return "redirect:/DMS";			
		}
        
    }
}
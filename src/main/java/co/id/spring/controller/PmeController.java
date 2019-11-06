package co.id.spring.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FilenameUtils;
import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import co.id.spring.model.AdditionalColumnModel;
import co.id.spring.model.AreaModel;
import co.id.spring.model.FileModel;
import co.id.spring.model.JenisDokumenModel;
import co.id.spring.model.JenisTahapanModel;
import co.id.spring.model.KegiatanModel;
import co.id.spring.model.MapModel;
import co.id.spring.model.ProjectModel;
import co.id.spring.model.SektorModel;
import co.id.spring.model.TahapanModel;
import co.id.spring.model.TahunModel;
import co.id.spring.model.UserModel;
import co.id.spring.util.AccessDB;

@Controller
public class PmeController {
	
	static Logger log = Logger.getLogger(DashboardController.class.getName());
	@RequestMapping(value={"/PME", "/PME/"})
	public ModelAndView pme(HttpServletRequest request, HttpServletResponse response) {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return new ModelAndView("redirect:/Login");
		}

		
		Map<String, Object> model = new HashMap<String, Object>();
        List<ProjectModel> userList = null;
        List<SektorModel> sector = null;
        List<AreaModel> area = null;
        
        try {
        	userList = AccessDB.getAllProjectPME();
        	sector = AccessDB.getAllSector();
        	area = AccessDB.getAllArea();
        	model.put("userlist", userList);
        	model.put("sector", sector);
        	model.put("area", area);
        	model.put("user_id", session.getAttribute("user_id").toString());
        	
//        	if (session.getAttribute("level").toString().equals("3"))
//    			allowed = true;
//    		else
//    			allowed = false;
//        	
        	
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}
        
		return new ModelAndView("pme", "msg", model);
        
    }
	
	@RequestMapping("/PME/SaveProject")
    public String createProject(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}

		Integer.parseInt(session.getAttribute("level").toString()); 
		
		String proyek_name = request.getParameter("proyek_name");
		String pjpk = request.getParameter("pjpk");
		String nilai_proyek = request.getParameter("nilai_proyek");
		String proyek_region = request.getParameter("proyek_region");
		String wilayah = request.getParameter("wilayah");
		String proyek_sektor = request.getParameter("proyek_sektor");
		
		int hasil = 0;
		try {
			hasil = AccessDB.createNewProjectPME(proyek_name, proyek_region, wilayah, pjpk, nilai_proyek, session.getAttribute("user_id").toString(), proyek_sektor);
			if(hasil > 0){
//				AccessDB.createDefaultFolder();
				return "redirect:/PME";				
			}else{
//				session.setAttribute("errorCreateUser", "errorCreateUser");
				return "redirect:/PME";
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
//			session.setAttribute("errorCreateUser", "errorCreateUser");
			return "redirect:/PME";
		} catch (SQLException e){
			e.printStackTrace();
//			session.setAttribute("errorCreateUser", "errorCreateUser");
			return "redirect:/PME";			
		}
        
    }
	
	@RequestMapping("/PME/EditeProyekPME")
    public String EditeProyekPME(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}

		Integer.parseInt(session.getAttribute("level").toString()); 
		
		String proyek_name = request.getParameter("proyek_name");
		String id_proyek = request.getParameter("id_proyek");
		
		int hasil = 0;
		try {
			hasil = AccessDB.editeProyekPME(proyek_name, Integer.parseInt(id_proyek));
			if(hasil > 0){
//				AccessDB.createDefaultFolder();
				return "redirect:/PME/ViewProjectPME?id="+id_proyek;			
			}else{
//				session.setAttribute("errorCreateUser", "errorCreateUser");
				return "redirect:/PME";
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
//			session.setAttribute("errorCreateUser", "errorCreateUser");
			return "redirect:/PME";
		} catch (SQLException e){
			e.printStackTrace();
//			session.setAttribute("errorCreateUser", "errorCreateUser");
			return "redirect:/PME";			
		}
        
    }
	
	@RequestMapping("/PME/DeleteProject")
    public String deleteProject(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}

//		int user_level = Integer.parseInt(session.getAttribute("level").toString());
//		if (user_level < 3){
//			return "redirect:/Dashboard";
//		}
		
		String proyek_id = request.getParameter("id");
		
		int hasil = 0;
		try {
			hasil = AccessDB.deleteProjectPME(proyek_id);
			if(hasil > 0){
				return "redirect:/PME";				
			}else{
//				session.setAttribute("errorCreateUser", "errorCreateUser");
				return "redirect:/PME";
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
//			session.setAttribute("errorCreateUser", "errorCreateUser");
			return "redirect:/PME";
		}catch (SQLException e) {
			e.printStackTrace();
//			session.setAttribute("errorCreateUser", "errorCreateUser");
			return "redirect:/PME";			
		}
        
    }
	
	@RequestMapping("/PME/ViewProjectPME")
    public ModelAndView viewProjectPME(HttpServletRequest request, HttpServletResponse response) throws NumberFormatException, IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return new ModelAndView("redirect:/Login");
		}

//		int user_level = Integer.parseInt(session.getAttribute("level").toString());
//		if (user_level < 3){
//			return new ModelAndView("redirect:/Dashboard");
//		}
		
		String proyek_id = request.getParameter("id");
				
		List<TahapanModel> listTahapan = null;
		List<ProjectModel> listProject = null;
		List<AdditionalColumnModel> listColumn = null;
		List<SektorModel> sector = null; 
//		String result;
		String projectName="";
		
		boolean allowed = false;
		int useridFromDB=0;
		
		try {
//			int checkProject = AccessDB.checkProject(proyek_id);
			listProject = AccessDB.getProjectPMEByID(Integer.parseInt(proyek_id));
			
			if (listProject.get(0).getProjectID() > 0){
				
				listTahapan = AccessDB.getTahapanByProjectID(proyek_id);
				listColumn = AccessDB.getAdditionalColumn(Integer.parseInt(proyek_id));
				sector = AccessDB.getAllSector(); 
//				result = AccessDB.getProjectNameAndUserID(proyek_id);
//				listProject = AccessDB.getProjectPMEByID(Integer.parseInt(proyek_id));
				
				try{
//					String[] results = result.split("\\|");
					projectName = listProject.get(0).getProjectName();
					useridFromDB = listProject.get(0).getUserID();
					
					if (session.getAttribute("user_id").toString().equals(String.valueOf(useridFromDB)) 
							|| session.getAttribute("level").toString().equals("3"))
						allowed = true;
					else
						allowed = false;
				}catch(Exception e){
					e.printStackTrace();
					projectName="";
					useridFromDB=0;
				}
				
				if (listTahapan != null){
					ModelAndView mv = new ModelAndView("view_tahapan");
					mv.addObject("listTahapan", listTahapan);
					mv.addObject("listProject", listProject);
					mv.addObject("listColumn", listColumn);
					mv.addObject("allowed", allowed);
					mv.addObject("sektor", sector);
					
					session.setAttribute("projectNamePME", projectName);
					session.setAttribute("projectIDPME", proyek_id);
					
					return mv;				
				}else {
//					session.setAttribute("errMsg", "error");
					return new ModelAndView("redirect:/PME");
				}				
			}else {
				return new ModelAndView("redirect:/PME");
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
//			session.setAttribute("errMsg", "error");
			return new ModelAndView("redirect:/PME");
		}catch (SQLException e) {
			e.printStackTrace();
//			session.setAttribute("errMsg", "error");
			return new ModelAndView("redirect:/PME");		
		}
        
    }

    @RequestMapping("/PME/CheckKegiatan")     
	@ResponseBody
	public String checkKegiatan(HttpServletRequest request, HttpServletResponse response) {
 
	    String name = request.getParameter("name");	
	    String id_jenis_tahapan = request.getParameter("id_jenis_tahapan");
		int hasil = 0;
		
		try {
			hasil = AccessDB.checkKegiatan(name, Integer.parseInt(id_jenis_tahapan));
			
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

	@RequestMapping("/PME/CheckFilePME")     
	@ResponseBody
	public String checkFilePME(HttpServletRequest request, HttpServletResponse response) {
 
	    String idKegiatan = request.getParameter("idKegiatan");	
	    String idFile = request.getParameter("idFile");
		int hasil = 0;
		
		System.out.println("File : "+idFile+" Kegiatan : "+idKegiatan);
		
		try {
			hasil = AccessDB.checkFilePME(idFile, idKegiatan);
			
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
	
	@RequestMapping("/PME/DisableEnableTahapan")
    public String disableEnable(HttpServletRequest request, HttpServletResponse response) throws NumberFormatException, IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}

		String id_tahapan = request.getParameter("id_tahapan");
		String disabletahapn = request.getParameter("disabletahapn");
		String nama_tahapan = request.getParameter("nama_tahapan");
		String id_proyek = request.getParameter("id_proyek");
		
		log.info("disable control "+disabletahapn);
				
		int hasil = 0;
		try {
			hasil = AccessDB.disableEnableTahapan(Integer.parseInt(id_tahapan), nama_tahapan, Integer.parseInt(disabletahapn));
			if(hasil > 0){
				return "redirect:/PME/ViewProjectPME?id="+id_proyek;				
			}else{
				return "redirect:/PME";
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return "redirect:/PME";
		} catch (SQLException e){
			e.printStackTrace();
			return "redirect:/PME";			
		}
		
    }
	
	@RequestMapping("/PME/ViewJenisTahapan")
	@ResponseBody
    public ModelAndView ViewJenisTahapan(@RequestParam ("id") String id_tahapan, @RequestParam("name") String nama_tahapan,
    		HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return new ModelAndView("redirect:/Login");
		}
//		System.out.println(id_tahapan);
		List<JenisTahapanModel> jenisTahapan = null;
		List<ProjectModel> listProject = null;
		
		boolean allowed = false;
		int useridFromDB=0;
		
		try {
			
			int checkTahapan = AccessDB.checkTahapan(id_tahapan);
			listProject = AccessDB.getProjectPMEByUserID(Integer.parseInt(id_tahapan));
			
			if (checkTahapan > 0){
				jenisTahapan = AccessDB.getJenisTahapanById(id_tahapan);
				
				try{
//					String[] results = result.split("\\|");
					useridFromDB = listProject.get(0).getUserID();
					
					if (session.getAttribute("user_id").toString().equals(String.valueOf(useridFromDB)) 
							|| session.getAttribute("level").toString().equals("3"))
						allowed = true;
					else
						allowed = false;
				}catch(Exception e){
					e.printStackTrace();
					useridFromDB=0;
				}
				
				if (jenisTahapan != null){
					
					session.setAttribute("namaTahapan", nama_tahapan);
					session.setAttribute("idTahapan", id_tahapan);
					
					ModelAndView mv = new ModelAndView("jenis_tahapan");
					mv.addObject("jenisTahapan", jenisTahapan);
					mv.addObject("allowed", allowed);
//					mv.addObject("projectName", proyek_name);
//					mv.addObject("idTahapan", id_tahapan);
					
					return mv;				
				}else {
					return new ModelAndView("redirect:/PME");
				}				
			}else {
				return new ModelAndView("redirect:/PME");
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return new ModelAndView("redirect:/PME");
		}catch (SQLException e) {
			e.printStackTrace();
			return new ModelAndView("redirect:/PME");		
		}        
    }
	
	@RequestMapping("/PME/KegiatanTahapan")
    public ModelAndView ViewKegiatanTahapan(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return new ModelAndView("redirect:/Login");
		}
		
		boolean allowed = false;
		int useridFromDB=0;

//		int user_level = Integer.parseInt(session.getAttribute("level").toString());
//		if (user_level < 3){
//			return new ModelAndView("redirect:/Dashboard");
//		}
		
		String id_jenis_tahapan = request.getParameter("id");
		String proyek_name = request.getParameter("nama");
		String jenis_tahapan = request.getParameter("nama_jenis");
		String nama_tahapan = request.getParameter("name");
		String id_tahapan = request.getParameter("id_tahap");
//		String sub = request.getParameter("sub");
		
//		System.out.println(id_jenis_tahapan);
		List<ProjectModel> listProject = null;
		List<KegiatanModel> listKegiatan = null;
		List<JenisDokumenModel> listJenisDokumen = null;
//		List<FileModel> listFileDMS = null;
		int percentage = 0;
//		int pagetotal = 10;
//		int pageid = 1;
//		String search_fileupload = "";
		
		try {
			
//			int checkTahapan = AccessDB.checkTahapan(id_jenis_tahapan);
//			
//			if (checkTahapan > 0){
			listProject = AccessDB.getKegiatanPMEByUserID(Integer.parseInt(id_jenis_tahapan));
				listKegiatan = AccessDB.getKegiatanById(id_jenis_tahapan);
				listJenisDokumen = AccessDB.getAllJenisDokumen();
				percentage = AccessDB.getPercentageFromJP(Integer.parseInt(id_jenis_tahapan));
				//listFileDMS = AccessDB.getAllFileDMS(pageid,pagetotal,search_fileupload);
				
				try{
//					String[] results = result.split("\\|");
					useridFromDB = listProject.get(0).getUserID();
					if (session.getAttribute("user_id").toString().equals(String.valueOf(useridFromDB))
							|| session.getAttribute("level").toString().equals("3"))
						allowed = true;
					else if (session.getAttribute("user_id").toString().equals(String.valueOf(useridFromDB))
							&& session.getAttribute("level").toString().equals("2"))
						allowed = true;
					else
						allowed = false;
				}catch(Exception e){
					e.printStackTrace();
					useridFromDB=0;
				}
				
				if (listKegiatan != null){
					
					session.setAttribute("namaJenisTahapan", jenis_tahapan);
					session.setAttribute("idJenisTahapan", id_jenis_tahapan);
					session.setAttribute("namaTahapan", nama_tahapan);
					session.setAttribute("id_tahapan", id_tahapan);
					
					ModelAndView mv = new ModelAndView("kegiatan_pme");
					mv.addObject("listKegiatan", listKegiatan);
//					mv.addObject("projectName", proyek_name);
					mv.addObject("jenis_tahapan", jenis_tahapan);
					mv.addObject("id_jenis_tahapan", id_jenis_tahapan);
					mv.addObject("listJenisDokumen", listJenisDokumen);
					mv.addObject("percentage", percentage);
					//mv.addObject("listFileDMS", listFileDMS);
					mv.addObject("allowed", allowed);
					
					return mv;				
				}else {
					return new ModelAndView("redirect:/PME");
				}				
//			}else {
//				return new ModelAndView("redirect:/PME");
//			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return new ModelAndView("redirect:/PME");
		}catch (SQLException e) {
			e.printStackTrace();
			return new ModelAndView("redirect:/PME");		
		}        
    }
	
	//tambahan andri load paging list file dms
	@RequestMapping("/PME/PagingListUpload")
    public ModelAndView pagingListUpload(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
		
		HttpSession session = request.getSession();
		Map<String, Object> model = new HashMap<String, Object>();
		
		int pagetotal = 10;
		String search_fileupload = request.getParameter("search_fileupload");
		int pageid = Integer.parseInt(request.getParameter("pageidDMS"));
		if(pageid != 1){
			pageid = (pageid-1)*pagetotal+1;
		}
		
		List<FileModel> listFileDMS = null;
		try {
			listFileDMS = AccessDB.getAllFileDMS(pageid,pagetotal,search_fileupload);
			//ModelAndView mv = new ModelAndView("kegiatan_pme");
			model.put("listFileDMS", listFileDMS);
			model.put("pageid", pageid);
			model.put("search_fileupload", search_fileupload);
			
			
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}
		return new ModelAndView("table_upload", "msg", model);
    }
	
	//tambahan andri load file pme
	@RequestMapping("/PME/ListFilePme")
    public ModelAndView listFilePme(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
		
		HttpSession session = request.getSession();
		Map<String, Object> model = new HashMap<String, Object>();
		
		int id_kegiatan = Integer.parseInt(request.getParameter("id_kegiatan"));
		
		//List<FileModel> listFilePME = null;
		try {
			//listFilePME = AccessDB.getFilePME(id_kegiatan);
			//model.put("listFilePME", listFilePME);
			model.put("id_kegiatan", id_kegiatan);
			
		} 
		//	catch (ClassNotFoundException e) {
		//	e.printStackTrace();
		//} catch (SQLException e) {
		//	e.printStackTrace();
		//}
		catch (Exception e) {
			e.printStackTrace();
		}
		return new ModelAndView("table_download", "msg", model);
    }
	
	@RequestMapping("/PME/TambahKegiatan")
    public String tambahKegiatan(HttpServletRequest request, HttpServletResponse response) throws NumberFormatException, IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}

//		int user_level = Integer.parseInt(session.getAttribute("level").toString());
//		if (user_level < 3){
//			return "redirect:/Dashboard";
//		}
		
		String nama_kegiatan = request.getParameter("name");
		String target = request.getParameter("target");
		String realisasi = request.getParameter("realisasi");
		String status = request.getParameter("status");
		String deskripsi = request.getParameter("desc");
		String projectName = request.getParameter("projectName");
		String jenis_tahapan = request.getParameter("jenis_tahapan");
		String id_jenis_tahapan = request.getParameter("id_jenis_tahapan");
		String sub = request.getParameter("sub");
		String projectNamaPME = request.getParameter("projectNamaPME");
		String nameTahapan = request.getParameter("nameTahapan");
		String id_tahapan = request.getParameter("id_tahapan");
		
		String userName = session.getAttribute("username").toString();
		
		int hasil = 0;
		try {
			hasil = AccessDB.tambahKegiatan(nama_kegiatan, target, realisasi, deskripsi, status, Integer.parseInt(id_jenis_tahapan), Integer.parseInt(session.getAttribute("user_id").toString()),userName);
			if(hasil > 0){
				return "redirect:/PME/KegiatanTahapan?id="+id_jenis_tahapan+"&nama="+projectNamaPME+"&nama_jenis="+jenis_tahapan+"&name="+nameTahapan+"&id_tahap="+id_tahapan;			
			}else{
				return "redirect:/PME";
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return "redirect:/PME";
		} catch (SQLException e){
			e.printStackTrace();
			return "redirect:/PME";			
		}
    }
	
	@RequestMapping("/PME/NewColumn")
    public String tambahKolomBaru(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}
		
		String nama = request.getParameter("nama");
		String deskripsi = request.getParameter("deskripsi");
		int id_proyek_pme = Integer.parseInt(session.getAttribute("projectIDPME").toString());
		
		int hasil = 0;
		try {
			hasil = AccessDB.tambahKolomBaru(nama, deskripsi, id_proyek_pme);
			if(hasil > 0){
				return "redirect:/PME/ViewProjectPME_dashboard?id="+id_proyek_pme;				
			}else{
				return "redirect:/PME";
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return "redirect:/PME";
		} catch (SQLException e){
			e.printStackTrace();
			return "redirect:/PME";			
		}
    }
	
	@RequestMapping("/PME/EditNewColumn")
    public String editKolomBaru(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}
		
		String nama = request.getParameter("nama");
		String deskripsi = request.getParameter("deskripsi");
		String id_kolom = request.getParameter("id_kolom");
		int id_proyek_pme = Integer.parseInt(session.getAttribute("projectIDPME").toString());
		
		int hasil = 0;
		try {
//			hasil = AccessDB.tambahKolomBaru(nama, deskripsi, id_proyek_pme);
			hasil = AccessDB.editKolomBaru(nama, deskripsi, Integer.parseInt(id_kolom));
			if(hasil > 0){
				return "redirect:/PME/ViewProjectPME_dashboard?id="+id_proyek_pme;				
			}else{
				return "redirect:/PME";
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return "redirect:/PME";
		} catch (SQLException e){
			e.printStackTrace();
			return "redirect:/PME";			
		}
    }
	
	@RequestMapping("/PME/HapusKolomBaru")
    public String hapusKolomBaru(HttpServletRequest request, HttpServletResponse response) throws NumberFormatException, IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}
		
		String id_kolom = request.getParameter("id_kolom");
		int id_proyek_pme = Integer.parseInt(session.getAttribute("projectIDPME").toString());
		
		int hasil = 0;
		try {
			hasil = AccessDB.hapusKolomBaru(Integer.parseInt(id_kolom));
			if(hasil > 0){
				return "redirect:/PME/ViewProjectPME_dashboard?id="+id_proyek_pme;				
			}else{
				return "redirect:/PME";
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return "redirect:/PME";
		} catch (SQLException e){
			e.printStackTrace();
			return "redirect:/PME";			
		}
    }
	
	
	@RequestMapping("/PME/EditNilaiInvestasi")
    public String editNilai(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}
		
		String nilai = request.getParameter("nilai");
		String sektor = request.getParameter("proyek_sektor"); 	
		String pjpk = request.getParameter("pjpk"); 			
		String area = request.getParameter("area");
		String wilayah = request.getParameter("wilayah");
		int id_proyek_pme = Integer.parseInt(session.getAttribute("projectIDPME").toString());
		
		int hasil = 0;
		try {
//			hasil = AccessDB.updateNilaiInvestasi(nilai, id_proyek_pme);
			hasil = AccessDB.updateNilaiInvestasi(nilai, Integer.parseInt(sektor), pjpk, area, id_proyek_pme, wilayah);
			if(hasil > 0){
				return "redirect:/PME/ViewProjectPME_dashboard?id="+id_proyek_pme;				
			}else{
				return "redirect:/PME";
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return "redirect:/PME";
		} catch (SQLException e){
			e.printStackTrace();
			return "redirect:/PME";			
		}
    }
	
	@RequestMapping("/PME/UpdateProgress")
    public String updateProgress(HttpServletRequest request, HttpServletResponse response) throws NumberFormatException, IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}
		
		String id_jenis_tahapan = request.getParameter("id_jenis_tahapan");
//		String projectName = request.getParameter("projectName");
		String id_tahapan = request.getParameter("id_tahapan");
		String status = request.getParameter("status");
				
		int hasil = 0;
		try {
			hasil = AccessDB.updateProgressPME(Integer.parseInt(id_jenis_tahapan), Integer.parseInt(status));
			if(hasil > 0){
				return "redirect:/PME/ViewJenisTahapan?id="+id_tahapan;				
			}else{
				return "redirect:/PME";
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return "redirect:/PME";
		} catch (SQLException e){
			e.printStackTrace();
			return "redirect:/PME";			
		}
		
    }
	
	@RequestMapping("/PME/DoneTahapan")
    public String doneTahapan(HttpServletRequest request, HttpServletResponse response) throws NumberFormatException, IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}
		
		String id_jenis_tahapan = request.getParameter("id_jenis_tahapan");
		String projectName = request.getParameter("projectName");
		String jenis_tahapan = request.getParameter("jenis_tahapan");
		String id_tahapan = request.getParameter("id_tahapan");
				
		int hasil = 0;
		try {
			hasil = AccessDB.updateJenisTahapanStep(Integer.parseInt(id_tahapan));
			if(hasil > 0){
				return "redirect:/PME/ViewProjectPME?id="+session.getAttribute("projectIDPME").toString();			
			}else{
				return "redirect:/PME";
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return "redirect:/PME";
		} catch (SQLException e){
			e.printStackTrace();
			return "redirect:/PME";			
		}
		
    }
	
	@RequestMapping("/PME/TambahJenisTahapan")
	@ResponseBody
    public String tambahTahapan(HttpServletRequest request, HttpServletResponse response) throws NumberFormatException, IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}
		
		String id_tahapan = request.getParameter("id_tahapan");
		String nama_jenis_tahapan = request.getParameter("nama_jenis_tahapan");
		String nama_tahapan = request.getParameter("nama_tahapan");
				
		int hasil = 0;
		int total = 0;
		try {
			total = AccessDB.checkJenisTahapan(Integer.parseInt(id_tahapan));
			hasil = AccessDB.tambahTahapan(Integer.parseInt(id_tahapan), nama_jenis_tahapan, total, Integer.parseInt(session.getAttribute("user_id").toString()));
			if(hasil > 0){
				return "redirect:/PME/ViewJenisTahapan?id="+id_tahapan+"&name="+nama_tahapan;
			}else{
				return "redirect:/PME";
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return "redirect:/PME";
		} catch (SQLException e){
			e.printStackTrace();
			return "redirect:/PME";			
		}
		
    }
	
	@RequestMapping("/PME/HapusTahapan")
    public String hapusTahapan(HttpServletRequest request, HttpServletResponse response) throws NumberFormatException, IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}
		
		String id_tahapan = request.getParameter("id_tahapan");
		String id_jenis_tahapan = request.getParameter("id_jenis_tahapan");
		String nama_tahapan = request.getParameter("nama_tahapan");
				
		int hasil = 0;
		try {
			hasil = AccessDB.hapusTahapan(Integer.parseInt(id_jenis_tahapan));
			if(hasil > 0){
				return "redirect:/PME/ViewJenisTahapan?id="+id_tahapan+"&name="+nama_tahapan;				
			}else{
				return "redirect:/PME";
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return "redirect:/PME";
		} catch (SQLException e){
			e.printStackTrace();
			return "redirect:/PME";			
		}
		
    }
	
	@RequestMapping("/PME/EditJenisTahapan")
	@ResponseBody
    public String updateJenisName(HttpServletRequest request, HttpServletResponse response) throws NumberFormatException, IOException, ParseException {
		
		HttpSession session = request.getSession();
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}
		
		String id_jenis_tahapan = request.getParameter("id_jenis_tahapan");
//		String projectName = request.getParameter("projectName");
		String id_tahapan = request.getParameter("id_tahapan");
//		String sub = request.getParameter("sub");
		String nama_jenis_tahapan = request.getParameter("name");
		String nama_tahapan = request.getParameter("nama_tahapan");
//		String disable = request.getParameter("disabled");
		
		
		int hasil = 0;
		try {
			hasil = AccessDB.updateJenisName(nama_jenis_tahapan, Integer.parseInt(id_jenis_tahapan));
			if(hasil > 0){
				return "redirect:/PME/ViewJenisTahapan?id="+id_tahapan+"&name="+nama_tahapan;				
			}else{
				return "redirect:/PME";
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return "redirect:/PME";
		} catch (SQLException e){
			e.printStackTrace();
			return "redirect:/PME";			
		}
    }
	
	@RequestMapping("/PME/EditKegiatan")
	@ResponseBody
    public String editKegiatan(HttpServletRequest request, HttpServletResponse response) throws NumberFormatException, IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}

//		int user_level = Integer.parseInt(session.getAttribute("level").toString());
//		if (user_level < 3){
//			return "redirect:/Dashboard";
//		}
		
		String nama_kegiatan = request.getParameter("name");
		String target = request.getParameter("target");
		String realisasi = request.getParameter("realisasi");
		String status = request.getParameter("status");
		String deskripsi = request.getParameter("desc");
		String projectName = request.getParameter("projectName");
		String jenis_tahapan = request.getParameter("jenis_tahapan");
		String id_jenis_tahapan = request.getParameter("id_jenis_tahapan");
//		String sub = request.getParameter("sub");
		String id_kegiatan = request.getParameter("id_kegiatan");
		String projectNamaPME = request.getParameter("projectNamaPME");
		String nameTahapan = request.getParameter("nameTahapan");
		String id_tahapan = request.getParameter("id_tahapan");
		
		int hasil = 0;
		try {
			hasil = AccessDB.updateKegiatan(nama_kegiatan, target, realisasi, deskripsi, status, 
					Integer.parseInt(id_kegiatan));
			if(hasil > 0){
				return "redirect:/PME/KegiatanTahapan?id="+id_jenis_tahapan+"&nama="+projectNamaPME+"&nama_jenis="+jenis_tahapan+"&name="+nameTahapan+"&id_tahap="+id_tahapan;				
			}else{
				return "redirect:/PME";
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return "redirect:/PME";
		} catch (SQLException e){
			e.printStackTrace();
			return "redirect:/PME";			
		}
    }
	
	@RequestMapping("/PME/HapusKegiatan")
    public String hapusKegiatan(HttpServletRequest request, HttpServletResponse response) throws NumberFormatException, IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}
		
		String projectName = request.getParameter("projectName");
		String jenis_tahapan = request.getParameter("jenis_tahapan");
		String id_jenis_tahapan = request.getParameter("id_jenis_tahapan");
//		String sub = request.getParameter("sub");
		String id_kegiatan = request.getParameter("id_kegiatan");
		String projectNamaPME = request.getParameter("projectNamaPME");
		String nameTahapan = request.getParameter("nameTahapan");
		String id_tahapan = request.getParameter("id_tahapan");
		
		
		int hasil = 0;
		try {
			hasil = AccessDB.hapusKegiatan(Integer.parseInt(id_kegiatan));
			if(hasil > 0){
				return "redirect:/PME/KegiatanTahapan?id="+id_jenis_tahapan+"&nama="+projectNamaPME+"&nama_jenis="+jenis_tahapan+"&name="+nameTahapan+"&id_tahap="+id_tahapan;				
			}else{
				return "redirect:/PME";
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return "redirect:/PME";
		} catch (SQLException e){
			e.printStackTrace();
			return "redirect:/PME";			
		}
    }
	
	@RequestMapping("/PME/UploadFilePME")
    public String uploadFilePME(@RequestParam("file") MultipartFile file, 
    		HttpServletRequest request, HttpServletResponse response) throws NumberFormatException, IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}

//		int user_level = Integer.parseInt(session.getAttribute("level").toString());
//		if (user_level < 3){
//			return "redirect:/Dashboard";
//		}
		
		String id_jenis_tahapan = request.getParameter("id_jenis_tahapan");
		String projectName = request.getParameter("projectName");
		String jenis_tahapan = request.getParameter("jenis_tahapan");
//		String sub = request.getParameter("sub");
		String id_kegiatan = request.getParameter("id_kegiatan");
		
		System.out.println(id_kegiatan);
		String file_type = request.getParameter("file_type");
		String nomor_surat = request.getParameter("nomor_surat");
		String tanggal_surat = request.getParameter("tanggal_surat");
		String perihal = request.getParameter("perihal");		

		SimpleDateFormat fileFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd");
		java.util.Date date = new java.util.Date();
		InputStream inputStream = null;  
		OutputStream outputStream = null; 
		
		String fileName = FilenameUtils.removeExtension(file.getOriginalFilename());
		String filePath = "/assets/images/";
		String fileUrlFinal = filePath+""+fileFormat.format(date.getTime())+"_"+file.getOriginalFilename();
		
		int hasil = 0;
		try {
			hasil = AccessDB.tambahFilePME(fileName, fileUrlFinal, Integer.parseInt(file_type),
					nomor_surat, tanggal_surat, perihal, format1.format(date.getTime()), Integer.parseInt(id_kegiatan),
					Integer.parseInt(session.getAttribute("user_id").toString()), session.getAttribute("username").toString());
			if(hasil > 0){
				
				try{
					inputStream = file.getInputStream();  
					File newFile = new File(request.getRealPath("/")+fileUrlFinal);  
					System.out.println(""+request.getRealPath("/")+fileUrlFinal);
					if (!newFile.exists()) {  
						newFile.createNewFile();  
					}
					outputStream = new FileOutputStream(newFile);  
					int read = 0;  
					byte[] bytes = new byte[1024];  
					
					while ((read = inputStream.read(bytes)) != -1) {  
						outputStream.write(bytes, 0, read);  
					}
					outputStream.close();
				}catch(IOException e){
					e.printStackTrace();
				}
				
				return "redirect:/PME/KegiatanTahapan?id="+id_jenis_tahapan+"&name="+projectName+"&nama_jenis="+jenis_tahapan;				
			}else{
				return "redirect:/PME";
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return "redirect:/PME";
		} catch (SQLException e){
			e.printStackTrace();
			return "redirect:/PME";			
		}
    }
	
	@RequestMapping("/PME/AddFilePME")
    public String tambahFilePME(HttpServletRequest request, HttpServletResponse response) throws NumberFormatException, IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}
		
		String id_jenis_tahapan = request.getParameter("id_jenis_tahapan");
		String projectName = request.getParameter("projectName");
		String jenis_tahapan = request.getParameter("jenis_tahapan");
		String id_kegiatan = request.getParameter("id_kegiatan_add");
		String filename = request.getParameter("filename");
		String filepath = request.getParameter("filepath");
		String jenisfile = request.getParameter("jenisfile");
		String nomor_surat = request.getParameter("nomorsurat");
		String perihal = request.getParameter("perihal");		
		String idfile = request.getParameter("idfile");
		String tanggalsurat = request.getParameter("tanggalsurat");
		String projectNamaPME = request.getParameter("projectNamaPME");
		String nameTahapan = request.getParameter("nameTahapan");
		String id_tahapan = request.getParameter("id_tahapan");
		
//		System.out.println(filename);
//		System.out.println(filepath);
//		System.out.println(jenisfile);
//		System.out.println(nomor_surat);
//		System.out.println(perihal);
//		System.out.println(id_kegiatan);
//		System.out.println("asdasd : "+tanggalsurat);
				
		int hasil = 0;
		try {
			hasil = AccessDB.tambahFilePMEDariDMS(idfile, filename, filepath, Integer.parseInt(jenisfile),
					nomor_surat, perihal, tanggalsurat, Integer.parseInt(id_kegiatan) ,
					Integer.parseInt(session.getAttribute("user_id").toString()), session.getAttribute("username").toString());
			if(hasil > 0){	
				return "redirect:/PME/KegiatanTahapan?id="+id_jenis_tahapan+"&nama="+projectNamaPME+"&nama_jenis="+jenis_tahapan+"&name="+nameTahapan+"&id_tahap="+id_tahapan;		
			}else{
				return "redirect:/PME";
			}	
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return "redirect:/PME";
		} catch (SQLException e){
			e.printStackTrace();
			return "redirect:/PME";			
		}
//		return "redirect:/PME/KegiatanTahapan?id="+id_jenis_tahapan+"&name="+projectName+"&nama_jenis="+jenis_tahapan;	
    }
	
	@RequestMapping("/PME/deleteFilePME")
	@ResponseBody
    public String deleteFilePME(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return "redirect:/Login";
		}
		
		String id_file = request.getParameter("id_file");
		//String id_jenis_tahapan = request.getParameter("id_jenis_tahapan");
		//String projectName = request.getParameter("projectName");
		//String jenis_tahapan = request.getParameter("jenis_tahapan");
		//String sub = request.getParameter("sub");
		String id_kegiatan = request.getParameter("id_kegiatan");
		//String projectNamaPME = request.getParameter("projectNamaPME");
		//String nameTahapan = request.getParameter("nameTahapan");
		//String id_tahapan = request.getParameter("id_tahapan");
		
//		System.out.println(id_file+" & "+id_jenis_tahapan+" & "+projectName+" & "+jenis_tahapan+" & "+sub);
		String id_file2 = "";
		int hasil = 0;
		int count = 0;
		try {
			hasil = AccessDB.deleteFilePME(id_file, id_kegiatan);
//			if(hasil > 0){
//				return "redirect:/PME/KegiatanTahapan?id="+id_jenis_tahapan+"&nama="+projectNamaPME+"&nama_jenis="+jenis_tahapan+"&name="+nameTahapan+"&id_tahap="+id_tahapan;		
//			}else{
//				return "redirect:/PME";
//			}
			count = AccessDB.checkFilePME(id_file2, id_kegiatan);
			if(count > 0){
				return "exits";
			}else {
				return "not exits";
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return "redirect:/PME";
		}catch (SQLException e) {
			e.printStackTrace();
			return "redirect:/PME";			
		}
        
    }
	
	@RequestMapping("/PME/KegiatanTahapan/FilePME")
    public ModelAndView searchProject(HttpServletRequest request, HttpServletResponse response) {
		//String msg;
		//data: {jenis_dok:jenis_dok, foldername:foldername, no_surat:no_surat, tgl_surat:tgl_surat, perihal:perihal, sektor:sektor,proyekname:proyekname},
        // msg = "Project Management";
		HttpSession session = request.getSession();
		
		String id = request.getParameter("id");
		
		System.out.println(id);

		//System.out.println("jenis_dok:"+jenis_dok + "|no_surat:"+no_surat +"|tgl_surat:"+tgl_surat + "|perihal:"+perihal+"|sektor:"+sektor+"|proyekname:"+proyekname);
		
		        
		return new ModelAndView("pme");
        
        
    }
	
	@RequestMapping("/PME/ViewProjectPME_dashboard")
    public ModelAndView viewProjectPME_dashboard(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {

		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return new ModelAndView("redirect:/Login");
		}

//		int user_level = Integer.parseInt(session.getAttribute("level").toString());
//		if (user_level < 3){
//			return new ModelAndView("redirect:/Dashboard");
//		}
		
		String proyek_id = request.getParameter("id");
		
//		Map<String, Object> model = new HashMap<String, Object>();
//        List<ProjectModel> userList = null;
		List<TahapanModel> listTahapan = null;
		List<ProjectModel> listProject = null;
		List<AdditionalColumnModel> listColumn = null;
		List<SektorModel> sektor = null;
		List<MapModel> map = null;
//		String result;
		String projectName="";
		
		boolean allowed = false;
		int useridFromDB=0;
		
		try {
//			int checkProject = AccessDB.checkProject(proyek_id);
			listProject = AccessDB.getProjectPMEByID(Integer.parseInt(proyek_id));
//			userList = AccessDB.getAllProjectPME();

//			model.put("userlist", userList);
			
			if (listProject.get(0).getProjectID() > 0){
				
				listTahapan = AccessDB.getTahapanByProjectIDViewDash(proyek_id);
				listColumn = AccessDB.getAdditionalColumn(Integer.parseInt(proyek_id));
				sektor = AccessDB.getAllSektor();
				map = AccessDB.getAllMap();
//				result = AccessDB.getProjectNameAndUserID(proyek_id);
//				listProject = AccessDB.getProjectPMEByID(Integer.parseInt(proyek_id));
				
				try{
//					String[] results = result.split("\\|");
					projectName = listProject.get(0).getProjectName();
					useridFromDB = listProject.get(0).getUserID();
					
					if (session.getAttribute("user_id").toString().equals(String.valueOf(useridFromDB)) 
							|| session.getAttribute("level").toString().equals("3"))
						allowed = true;
					else
						allowed = false;
				}catch(Exception e){
					e.printStackTrace();
					projectName="";
					useridFromDB=0;
				}
				
				if (listTahapan != null){
					ModelAndView mv = new ModelAndView("view_project_pme_dashboard");
					mv.addObject("listTahapan", listTahapan);
					mv.addObject("listProject", listProject);
					mv.addObject("listColumn", listColumn);
					mv.addObject("allowed", allowed);
					mv.addObject("sektor", sektor);
					mv.addObject("map", map);
					
					session.setAttribute("projectNamePME", projectName);
					session.setAttribute("projectIDPME", proyek_id);
					
					return mv;				
				}else {
//					session.setAttribute("errMsg", "error");
					return new ModelAndView("redirect:/PME");
				}				
			}else {
				return new ModelAndView("redirect:/PME");
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
//			session.setAttribute("errMsg", "error");
			return new ModelAndView("redirect:/PME");
		}catch (SQLException e) {
			e.printStackTrace();
//			session.setAttribute("errMsg", "error");
			return new ModelAndView("redirect:/PME");		
		}
        
    }
	
	//Tambahan Andri
	
	@RequestMapping("/PME/search_proyek")
    public ModelAndView searchPME(HttpServletRequest request, HttpServletResponse response) {
	HttpSession session = request.getSession();
	
	if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
		return new ModelAndView("redirect:/Login");
	}
		
		String search = request.getParameter("search");
		Map<String, Object> model = new HashMap<String, Object>();
        List<ProjectModel> userList = null;
        List<SektorModel> sector = null;
        List<AreaModel> area = null;
        
        try {
        	userList = AccessDB.searchProjectPME(search);
        	sector = AccessDB.getAllSector();
        	area = AccessDB.getAllArea();
        	model.put("userlist", userList);
        	model.put("sector", sector);
        	model.put("area", area);
        	model.put("user_id", session.getAttribute("user_id").toString());
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}
        
		return new ModelAndView("search_proyek", "msg", model);
        
        
    }
	
	@RequestMapping("/PME/cek_proyek")     
	@ResponseBody
	public String check(HttpServletRequest request, HttpServletResponse response, Model model) {
 
	    String proyek_name = request.getParameter("proyek_name");		
		int hasil = 0;
		
		try {
			hasil = AccessDB.cek_ProjectPME(proyek_name);
			
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
	
	@RequestMapping("/PME/CheckColumn")     
	@ResponseBody
	public String checkColumn(HttpServletRequest request, HttpServletResponse response) {
 
		HttpSession session = request.getSession();
		
	    String name = request.getParameter("name");
	    String id_kolom = request.getParameter("id_kolom");
	    int id_proyek_pme = Integer.parseInt(session.getAttribute("projectIDPME").toString());
	    
		int hasil = 0;
		String namaKolomLama = "";
		
		try {
			namaKolomLama = AccessDB.getColumnName(Integer.parseInt(id_kolom));
			
			if (name.equalsIgnoreCase(namaKolomLama)){
				return "false";
			}else{
				hasil = AccessDB.checkNewColumn(name, id_proyek_pme);
				
				if(hasil > 0){
					return "true";
				}else {
					return "false";
				}				
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
	
	@RequestMapping("/PME/CheckJT")     
	@ResponseBody
	public String checkUser(HttpServletRequest request, HttpServletResponse response) {
 
	    String name = request.getParameter("name");	
	    String id_tahapan = request.getParameter("id_tahapan");	
		int hasil = 0;
		
		try {
			hasil = AccessDB.checkJT(name, Integer.parseInt(id_tahapan));
			
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
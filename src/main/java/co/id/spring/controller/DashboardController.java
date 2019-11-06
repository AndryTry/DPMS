package co.id.spring.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.HtmlUtils;

import co.id.spring.model.PmeEksportModel;
import co.id.spring.model.SearchFileModel;
import co.id.spring.model.SektorModel;
import co.id.spring.model.ProjectModel;
import co.id.spring.util.AccessDB;

@Controller
public class DashboardController {
	static Logger log = Logger.getLogger(DashboardController.class.getName());
	
	@RequestMapping("/Dashboard")
    public ModelAndView dashboard(HttpServletRequest request, HttpServletResponse response) {
				
		String filter = "";
		Map<String, Object> model = new HashMap<String, Object>();
		List<SektorModel> sector = null;
		List<ProjectModel> project = null;
		List<ProjectModel> progress = null;
		
		//penambahan irwanto 1//
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return new ModelAndView("redirect:/Login");
		}
		
		List<Integer> idPme = new ArrayList<>();
		List<Integer> idProjectPme = new ArrayList<>();
		List<String> namaPme = new ArrayList<>();
		List<String> investasiPme = new ArrayList<>();
		List<String> pjpkPme = new ArrayList<>();
		List<String> tahapanPme = new ArrayList<>();
		List<String> area = new ArrayList<>();
		List<String> persentasePme = new ArrayList<>();
		List<Integer> id_jenis_tahapan = new ArrayList<>();
		List<String> statusPme = new ArrayList<>();
		List<PmeEksportModel> eksport = null;
		
		List<Integer> idTahapan = new ArrayList<>();
		List<String> namaTahapan = new ArrayList<>();
		List<String> proyekDilalui = new ArrayList<>();
		List<String> fasilitas = new ArrayList<>();
		//penambahan irwanto 1//
        
        try {
        	sector = AccessDB.getAllSector();
        	progress = AccessDB.getProgress();
        	project = AccessDB.getTableDashboard();
        	//project = AccessDB.getMapArea();
        	//penambahan irwanto2//
        	//////////
        	
        	eksport = AccessDB.eGetAllProjectPME();
        	String namaProyek = "";
        	String nilaiProyek = "";
        	String pjpkProyek = "";
        	String areaProyek = "";
			for(int a = 0 ; a < eksport.size() ; a++){
				idPme.add(eksport.get(a).getId_proyek_pme());
				namaProyek = eksport.get(a).getProyek_name();
				nilaiProyek = eksport.get(a).getNilai_investasi();
				pjpkProyek = eksport.get(a).getPjpk();
				areaProyek = eksport.get(a).getArea();
				
				AccessDB.eTahapanPMEbyIdProject(idPme.get(a), idTahapan, namaTahapan, filter); //get data KPBU only, after edited.
				//for(int b = 0 ; b<idTahapan.size() ; b++){
					
					idProjectPme.add(idPme.get(a));
					namaPme.add(namaProyek);
					investasiPme.add(nilaiProyek);
					pjpkPme.add(pjpkProyek);
					area.add(areaProyek);
//					fasilitas.add(namaTahapan.get(b));
					String berlangsung = AccessDB.eGetTahapanBerlangsungbyIdTahapan(idTahapan.get(0));
					
					String fasilitasN = AccessDB.eFasilitasbyIdProject(idPme.get(a), null);
					fasilitas.add(fasilitasN);
					proyekDilalui.add(berlangsung);
					
					AccessDB.eGetTahapanPMEbyIdTahapanAll(idTahapan.get(0), id_jenis_tahapan);
    				String persen = "";
    				double percentace = 0;
    				double totalPersen = 0;
    				double persentaseFix = 0;
    				
    				if(id_jenis_tahapan.size() == 0){
    					statusPme.add("N/A");
    					persentasePme.add("0");
    				}else {
    					for(int i = 0 ; i < id_jenis_tahapan.size() ; i++){
        					
        					persen = AccessDB.eGetPersen(id_jenis_tahapan.get(i));
        					if(persen == null || persen.trim().equals("")){
        						percentace = 0;
        						
        					}else if(persen.contains(".")){
//        						String[] splt = persen.split("[.]");
//        						persen = splt[0];
        						percentace = Double.parseDouble(persen);
        					}
        					totalPersen = totalPersen + percentace;
        					
        					//kondisi di akhir perulangan id_jenis_tahapan
        					if(i == id_jenis_tahapan.size()-1){
        						
        						persentaseFix = totalPersen/id_jenis_tahapan.size();
        						String persenn = new DecimalFormat("##.##").format(persentaseFix);
            					persentasePme.add(persenn);
        						if(persentaseFix == 0){
        							statusPme.add("N/A");
        						}else if(persentaseFix > 0 && persentaseFix < 100){
        							statusPme.add("Sedang Berlangsung");
        						}else if(persentaseFix == 100){
        							statusPme.add("Selesai");
        						}
        						
        					}
        					
        				}
    				}
    				
				//}
			}
			
			model.put("idProjectPme", idProjectPme);
			model.put("namaPme", namaPme);
        	model.put("investasiPme", investasiPme);
        	model.put("pjpkPme", pjpkPme);
        	model.put("tahapanPme", tahapanPme);
        	model.put("area", area);
        	model.put("fasilitas", fasilitas);
        	model.put("proyekDilalui", proyekDilalui);
			model.put("statusPme", statusPme);
			model.put("persentasePme", persentasePme);
            //penambahan irwanto 2//
        	model.put("sector", sector);
        	model.put("progress", progress);
        	model.put("project", project);
       } catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}
        //msg = "Home Page";
		return new ModelAndView("dashboard", "msg", model);
        
    }
	
	
	@RequestMapping("/DashboardSearch")
    public ModelAndView dashboardSearch(HttpServletRequest request, HttpServletResponse response) {
				
		Map<String, Object> model = new HashMap<String, Object>();
		
		//penambahan irwanto 1//
		HttpSession session = request.getSession();
		
//		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
//			return new ModelAndView("redirect:/Login");
//		}
		
		List<Integer> idPme = new ArrayList<>();
		List<Integer> idProjectPme = new ArrayList<>();
		List<String> namaPme = new ArrayList<>();
		List<String> investasiPme = new ArrayList<>();
		List<String> pjpkPme = new ArrayList<>();
		List<String> tahapanPme = new ArrayList<>();
		List<String> area = new ArrayList<>();
		List<String> persentasePme = new ArrayList<>();
		List<Integer> id_jenis_tahapan = new ArrayList<>();
		List<String> statusPme = new ArrayList<>();
		List<PmeEksportModel> eksport = null;
		
		List<Integer> idTahapan = new ArrayList<>();
		List<String> namaTahapan = new ArrayList<>();
		List<String> proyekDilalui = new ArrayList<>();
		List<String> fasilitas = new ArrayList<>();
		
		String fasilitasAjax = request.getParameter("fasilitas");
		//penambahan irwanto 1//
        
        try {
        	//penambahan irwanto2//
        	//////////
        	
        	eksport = AccessDB.eGetAllProjectPME();
        	String namaProyek = "";
        	String nilaiProyek = "";
        	String pjpkProyek = "";
        	String areaProyek = "";
        	
        	for(int a = eksport.size() ; a > 0 ; a--){
        		//idPmeForSearch.add(eksport.get(a).getId_proyek_pme());
        		AccessDB.eFasilitasbyIdProjectArray(eksport.get(a-1).getId_proyek_pme(), namaTahapan);
        	
        		if(!(fasilitasAjax== null || fasilitasAjax.trim().equalsIgnoreCase("")) ){
        			if(!namaTahapan.contains(fasilitasAjax)){ //nama tahapan yg tidak ada di hapus dari list
            			eksport.remove(a-1);
            		}
        		}
     
        	}
        	
			for(int a = 0 ; a < eksport.size() ; a++){
				idPme.add(eksport.get(a).getId_proyek_pme());
				namaProyek = eksport.get(a).getProyek_name();
				nilaiProyek = eksport.get(a).getNilai_investasi();
				pjpkProyek = eksport.get(a).getPjpk();
				areaProyek = eksport.get(a).getArea();
				
				AccessDB.eTahapanPMEbyIdProject(idPme.get(a), idTahapan, namaTahapan, fasilitasAjax);

				//for(int b = 0 ; b<idTahapan.size() ; b++){
					
					idProjectPme.add(idPme.get(a));
					namaPme.add(namaProyek);
					investasiPme.add(nilaiProyek);
					pjpkPme.add(pjpkProyek);
					area.add(areaProyek);
//					fasilitas.add(namaTahapan.get(b));
					String berlangsung = AccessDB.eGetTahapanBerlangsungbyIdTahapan(idTahapan.get(0));
					String fasilitasN = AccessDB.eFasilitasbyIdProject(idPme.get(a), null);
					fasilitas.add(fasilitasN);
					proyekDilalui.add(berlangsung);
					
					AccessDB.eGetTahapanPMEbyIdTahapanAll(idTahapan.get(0), id_jenis_tahapan);
    				String persen = "";
    				double percentace = 0;
    				double totalPersen = 0;
    				double persentaseFix = 0;
    				
    				if(id_jenis_tahapan.size() == 0){
    					statusPme.add("N/A");
    					persentasePme.add("0");
    				}else {
    					for(int i = 0 ; i < id_jenis_tahapan.size() ; i++){
        					
        					persen = AccessDB.eGetPersen(id_jenis_tahapan.get(i));
        					if(persen == null || persen.trim().equals("")){
        						percentace = 0;
        						
        					}else if(persen.contains(".")){
//        						String[] splt = persen.split("[.]");
//        						persen = splt[0];
        						percentace = Double.parseDouble(persen);
        					}
        					totalPersen = totalPersen + percentace;
        					
        					//kondisi di akhir perulangan id_jenis_tahapan
        					if(i == id_jenis_tahapan.size()-1){
        						
        						persentaseFix = totalPersen/id_jenis_tahapan.size();
        						String persenn = new DecimalFormat("##.##").format(persentaseFix);
            					persentasePme.add(persenn);
        						if(persentaseFix == 0){
        							statusPme.add("N/A");
        						}else if(persentaseFix > 0 && persentaseFix < 100){
        							statusPme.add("Sedang Berlangsung");
        						}else if(persentaseFix == 100){
        							statusPme.add("Selesai");
        						}
        						
        					}
        					
        				}
    				}
    				
				//}
			}
			model.put("idProjectPme", idProjectPme);
			model.put("namaPme", namaPme);
        	model.put("investasiPme", investasiPme);
        	model.put("pjpkPme", pjpkPme);
        	model.put("tahapanPme", tahapanPme);
        	model.put("area", area);
        	model.put("fasilitas", fasilitas);
        	model.put("proyekDilalui", proyekDilalui);
			model.put("statusPme", statusPme);
			model.put("persentasePme", persentasePme);
            //penambahan irwanto 2//

       } catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}catch (Exception e) {
			e.printStackTrace();
		}
		
        //msg = "Home Page";
		return new ModelAndView("dashboard_table_search", "msg", model);
        
    }
	/*
	@RequestMapping("/Dashboard/ProgressBar")
	public ModelAndView getProgressBar(HttpServletRequest request, HttpServletResponse response) {
		String area = request.getParameter("area");
		List<ProjectModel> progress = null;
		try {
			progress = AccessDB.getProgressBar(area);
			ModelAndView mv = new ModelAndView("progressbar");
			mv.addObject("progress", progress);
			return mv;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return new ModelAndView("dashboard");
		} catch (SQLException e) {
			e.printStackTrace();
			return new ModelAndView("dashboard");
		}    
    }
    */
	
	@RequestMapping("/Dashboard/Search")
	public ModelAndView search(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
		System.out.println("1111");
		String jenisDok = request.getParameter("jenis_dokumen");
		String noSurat = request.getParameter("no_surat");
		String perihal = request.getParameter("perihal");
		String sektor = request.getParameter("sektor");
//		String proyekname = request.getParameter("proyekname");
		String tanggal  = request.getParameter("tgl_surat");
		
		List<SearchFileModel> searchFileList = null;
		try {
			searchFileList = AccessDB.searchFile(jenisDok, noSurat, perihal, sektor, tanggal/**, proyekname**/);
			ModelAndView mv = new ModelAndView("searchfile");
			mv.addObject("searchFileList", searchFileList);
			return mv;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			return new ModelAndView("dashboard");
		} catch (SQLException e) {
			e.printStackTrace();
			return new ModelAndView("dashboard");
		} 
        
    }
	
	@RequestMapping("/circleSearch")
	 public ModelAndView searchProject(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
//			String show = request.getParameter("show");
			String show = HtmlUtils.htmlEscape(request.getParameter("show"));
			String search = HtmlUtils.htmlEscape(request.getParameter("search"));
			String fasilitas = request.getParameter("fasilitas");
//			log.info("show atas "+show);
//			Pattern special = Pattern.compile ("[!@#$%&*()_+=|<>?{}\\[\\]~-]");
//	        Matcher resul = special.matcher(show);
//	        if(resul.find() == true){
//	        	show ="Lihat per halaman";
//	        	log.info("masuk sini terus "+show);
//            }
//			log.info("show bawah "+show);
			if(fasilitas == null || fasilitas.equals("null")){
				fasilitas = "";
			}
			
			Map<String, Object> model = new HashMap<String, Object>();
	        List<ProjectModel> progress = null;
	        
	        try {
	        	progress = AccessDB.searchProgress(search, fasilitas);
	        	model.put("progress", progress);
	        	model.put("show", show);
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			} catch (SQLException e) {
				e.printStackTrace();
			}catch (Exception e) {
				e.printStackTrace();
			}
	        
			return new ModelAndView("search_circle", "msg", model);
	             
	    }
}
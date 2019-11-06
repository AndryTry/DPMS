package co.id.spring.controller;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.lowagie.text.Chunk;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.ExceptionConverter;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfName;
import com.lowagie.text.pdf.PdfNumber;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

import co.id.spring.model.AreaModel;
import co.id.spring.model.PmeEksportModel;
import co.id.spring.model.ProjectModel;
import co.id.spring.model.SektorModel;
import co.id.spring.util.AccessDB;

@Controller
public class EksportController {
	
	@RequestMapping("/Eksport")
	public ModelAndView pme(HttpServletRequest request, HttpServletResponse response) {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return new ModelAndView("redirect:/Login");
		}

		
		Map<String, Object> model = new HashMap<String, Object>();
        
        List<Integer> idPme = new ArrayList<>();
		List<String> namaPme = new ArrayList<>();
		List<String> investasiPme = new ArrayList<>();
		List<String> pjpkPme = new ArrayList<>();
		List<String> tahapanPme = new ArrayList<>();
		List<String> PDF = new ArrayList<>();
		List<String> VGF = new ArrayList<>();
		List<String> penjaminanBersama = new ArrayList<>();
		List<String> AP = new ArrayList<>();
		List<String> persentasePme = new ArrayList<>();
		List<Integer> id_jenis_tahapan = new ArrayList<>();
		List<String> statusPme = new ArrayList<>();
		List<Integer> countTahapanIdProject = new ArrayList<>();
		List<PmeEksportModel> eksport = null;
        
        try {
        		//////////
    			eksport = AccessDB.eGetAllProjectPME();
    			for(int a = 0 ; a < eksport.size() ; a++){
    				idPme.add(eksport.get(a).getId_proyek_pme());
    				namaPme.add(eksport.get(a).getProyek_name());
    				investasiPme.add(eksport.get(a).getNilai_investasi());
    				pjpkPme.add(eksport.get(a).getPjpk());
    			}
    			
    			//get tahapan, status
    			for(int a = 0 ; a < idPme.size() ; a++){
    				//get tahapan
    				int idTahapanKPBU = AccessDB.eIdTahapanPMEbyIdProject(idPme.get(a), countTahapanIdProject);
    				String tahapan = AccessDB.eGetTahapanPMEbyIdTahapan(idTahapanKPBU, id_jenis_tahapan);
    				tahapanPme.add(tahapan);
    				
    				int idTahapanPDF = AccessDB.eIdTahapanPMEbyIdProjectPDF(idPme.get(a), countTahapanIdProject);
    				String tahapanPDF = AccessDB.eGetTahapanPMEbyIdTahapan(idTahapanPDF, id_jenis_tahapan);
    				PDF.add(tahapanPDF);
    				
    				int idTahapanVGF = AccessDB.eIdTahapanPMEbyIdProjectVGF(idPme.get(a), countTahapanIdProject);
    				String tahapanVGF = AccessDB.eGetTahapanPMEbyIdTahapan(idTahapanVGF, id_jenis_tahapan);
    				VGF.add(tahapanVGF);
    				
    				int idTahapanPB = AccessDB.eIdTahapanPMEbyIdProjectPenjaminanBersama(idPme.get(a), countTahapanIdProject);
    				String tahapanPB = AccessDB.eGetTahapanPMEbyIdTahapan(idTahapanPB, id_jenis_tahapan);
    				penjaminanBersama.add(tahapanPB);
    				
    				int idTahapanAP = AccessDB.eIdTahapanPMEbyIdProjectAP(idPme.get(a), countTahapanIdProject);
    				String tahapanAP = AccessDB.eGetTahapanPMEbyIdTahapan(idTahapanAP, id_jenis_tahapan);
    				AP.add(tahapanAP);
    				
    				//get status
    				tahapan = AccessDB.eGetTahapanPMEbyIdTahapanAll(idTahapanKPBU, id_jenis_tahapan);
    				String persen = "";
    				double percentace = 0;
    				double totalPersen = 0;
    				double persentaseFix = 0;
    				
    				for(int i = 0 ; i < id_jenis_tahapan.size() ; i++){
    					persen = AccessDB.eGetPersen(id_jenis_tahapan.get(i));
    					if(persen == null || persen.trim().equals("")){
    						percentace = 0;
    						
    					}else if(persen.contains(".")){
    						//String[] splt = persen.split("[.]");
    						//persen = splt[0];
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
       	    	
        	model.put("idPme", idPme);
        	model.put("namaPme", namaPme);
        	model.put("investasiPme", investasiPme);
        	model.put("pjpkPme", pjpkPme);
        	model.put("tahapanPme", tahapanPme);
        	model.put("PDF", PDF);
        	model.put("VGF", VGF);
        	model.put("penjaminanBersama", penjaminanBersama);
        	model.put("AP", AP);
        	model.put("persentasePme", persentasePme);
        	//model.put("id_jenis_tahapan", id_jenis_tahapan);
        	model.put("statusPme", statusPme);
        	//model.put("eksport", eksport);
        	/////////
        	
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
        
		return new ModelAndView("view_pme_eksport", "msg", model);
        
    }
	
	@RequestMapping("/Eksport/ViewPMEEksport")
    public ModelAndView ViewPMEEksport(HttpServletRequest request, HttpServletResponse response) {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return new ModelAndView("redirect:/Login");
		}

		Map<String, Object> model = new HashMap<String, Object>();
        
        List<Integer> idPme = new ArrayList<>();
		List<String> namaPme = new ArrayList<>();
		List<String> investasiPme = new ArrayList<>();
		List<String> pjpkPme = new ArrayList<>();
		List<String> tahapanPme = new ArrayList<>();
		List<String> PDF = new ArrayList<>();
		List<String> VGF = new ArrayList<>();
		List<String> penjaminanBersama = new ArrayList<>();
		List<String> AP = new ArrayList<>();
		List<String> persentasePme = new ArrayList<>();
		List<Integer> id_jenis_tahapan = new ArrayList<>();
		List<String> statusPme = new ArrayList<>();
		List<Integer> countTahapanIdProject = new ArrayList<>();
		List<PmeEksportModel> eksport = null;
		
		try {
			
			//ModelAndView mv = new ModelAndView("pme_eksport");
			//////////
			eksport = AccessDB.eGetAllProjectPME();
			for (int a = 0; a < eksport.size(); a++) {
				idPme.add(eksport.get(a).getId_proyek_pme());
				namaPme.add(eksport.get(a).getProyek_name());
				investasiPme.add(eksport.get(a).getNilai_investasi());
				pjpkPme.add(eksport.get(a).getPjpk());
			}

			// get tahapan, status
			for (int a = 0; a < idPme.size(); a++) {
				// get tahapan
				int idTahapanKPBU = AccessDB.eIdTahapanPMEbyIdProject(idPme.get(a), countTahapanIdProject);
				String tahapan = AccessDB.eGetTahapanPMEbyIdTahapan(idTahapanKPBU, id_jenis_tahapan);
				tahapanPme.add(tahapan);
				
				int idTahapanPDF = AccessDB.eIdTahapanPMEbyIdProjectPDF(idPme.get(a), countTahapanIdProject);
				String tahapanPDF = AccessDB.eGetTahapanPMEbyIdTahapan(idTahapanPDF, id_jenis_tahapan);
				PDF.add(tahapanPDF);
				
				int idTahapanVGF = AccessDB.eIdTahapanPMEbyIdProjectVGF(idPme.get(a), countTahapanIdProject);
				String tahapanVGF = AccessDB.eGetTahapanPMEbyIdTahapan(idTahapanVGF, id_jenis_tahapan);
				VGF.add(tahapanVGF);
				
				int idTahapanPB = AccessDB.eIdTahapanPMEbyIdProjectPenjaminanBersama(idPme.get(a), countTahapanIdProject);
				String tahapanPB = AccessDB.eGetTahapanPMEbyIdTahapan(idTahapanPB, id_jenis_tahapan);
				penjaminanBersama.add(tahapanPB);
				
				int idTahapanAP = AccessDB.eIdTahapanPMEbyIdProjectAP(idPme.get(a), countTahapanIdProject);
				String tahapanAP = AccessDB.eGetTahapanPMEbyIdTahapan(idTahapanAP, id_jenis_tahapan);
				AP.add(tahapanAP);

				// get status
				tahapan = AccessDB.eGetTahapanPMEbyIdTahapanAll(idTahapanKPBU, id_jenis_tahapan);
				String persen = "";
				double percentace = 0;
				double totalPersen = 0;
				double persentaseFix = 0;
				
				for(int i = 0 ; i < id_jenis_tahapan.size() ; i++){
					persen = AccessDB.eGetPersen(id_jenis_tahapan.get(i));
					if(persen == null || persen.trim().equals("")){
						percentace = 0;
						
					}else if(persen.contains(".")){
						//String[] splt = persen.split("[.]");
						//persen = splt[0];
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

			model.put("idPme", idPme);
			model.put("namaPme", namaPme);
			model.put("investasiPme", investasiPme);
			model.put("pjpkPme", pjpkPme);
			model.put("tahapanPme", tahapanPme);
			model.put("PDF", PDF);
        	model.put("VGF", VGF);
        	model.put("penjaminanBersama", penjaminanBersama);
        	model.put("AP", AP);
			model.put("persentasePme", persentasePme);
			//model.put("id_jenis_tahapan", id_jenis_tahapan);
			model.put("statusPme", statusPme);
			//model.put("eksport", eksport);
			/////////	
			return new ModelAndView("pme_eksport", "msg", model);					
					
		} catch (Exception e) {
			e.printStackTrace();
//			session.setAttribute("errMsg", "error");
			return new ModelAndView("redirect:/Eksport");
		}
        
    }
	
	@RequestMapping("/Eksport/ViewPMEEksportPDF")
    public void ViewPMEEksportPDF(HttpServletRequest request, HttpServletResponse response) {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			try {
				response.sendRedirect(request.getContextPath()+"/Login");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		List<Integer> idPme = new ArrayList<>();
		List<String> namaPme = new ArrayList<>();
		List<String> investasiPme = new ArrayList<>();
		List<String> pjpkPme = new ArrayList<>();
		List<String> tahapanPme = new ArrayList<>();
		List<String> PDF = new ArrayList<>();
		List<String> VGF = new ArrayList<>();
		List<String> penjaminanBersama = new ArrayList<>();
		List<String> AP = new ArrayList<>();
		List<String> persentasePme = new ArrayList<>();
		List<Integer> id_jenis_tahapan = new ArrayList<>();
		List<String> statusPme = new ArrayList<>();
		List<Integer> countTahapanIdProject = new ArrayList<>();
		List<PmeEksportModel> eksport = null;
		
		try {
			
			//////////
			eksport = AccessDB.eGetAllProjectPME();
			for(int a = 0 ; a < eksport.size() ; a++){
				idPme.add(eksport.get(a).getId_proyek_pme());
				namaPme.add(eksport.get(a).getProyek_name());
				investasiPme.add(eksport.get(a).getNilai_investasi());
				pjpkPme.add(eksport.get(a).getPjpk());
			}
			
			//get tahapan, status
			for(int a = 0 ; a < idPme.size() ; a++){
				//get tahapan
				int idTahapanKPBU = AccessDB.eIdTahapanPMEbyIdProject(idPme.get(a), countTahapanIdProject);
				String tahapan = AccessDB.eGetTahapanPMEbyIdTahapan(idTahapanKPBU, id_jenis_tahapan);
				tahapanPme.add(tahapan);
				
				int idTahapanPDF = AccessDB.eIdTahapanPMEbyIdProjectPDF(idPme.get(a), countTahapanIdProject);
				String tahapanPDF = AccessDB.eGetTahapanPMEbyIdTahapan(idTahapanPDF, id_jenis_tahapan);
				PDF.add(tahapanPDF);
				
				int idTahapanVGF = AccessDB.eIdTahapanPMEbyIdProjectVGF(idPme.get(a), countTahapanIdProject);
				String tahapanVGF = AccessDB.eGetTahapanPMEbyIdTahapan(idTahapanVGF, id_jenis_tahapan);
				VGF.add(tahapanVGF);
				
				int idTahapanPB = AccessDB.eIdTahapanPMEbyIdProjectPenjaminanBersama(idPme.get(a), countTahapanIdProject);
				String tahapanPB = AccessDB.eGetTahapanPMEbyIdTahapan(idTahapanPB, id_jenis_tahapan);
				penjaminanBersama.add(tahapanPB);
				
				int idTahapanAP = AccessDB.eIdTahapanPMEbyIdProjectAP(idPme.get(a), countTahapanIdProject);
				String tahapanAP = AccessDB.eGetTahapanPMEbyIdTahapan(idTahapanAP, id_jenis_tahapan);
				AP.add(tahapanAP);
				
				//get status
				tahapan = AccessDB.eGetTahapanPMEbyIdTahapanAll(idTahapanKPBU, id_jenis_tahapan);
				String persen = "";
				double percentace = 0;
				double totalPersen = 0;
				double persentaseFix = 0;
				
				for(int i = 0 ; i < id_jenis_tahapan.size() ; i++){
					persen = AccessDB.eGetPersen(id_jenis_tahapan.get(i));
					if(persen == null || persen.trim().equals("")){
						percentace = 0;
						
					}else if(persen.contains(".")){
						//String[] splt = persen.split("[.]");
						//persen = splt[0];
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
			//////////
			
			Document document=new Document(PageSize.A4.rotate());
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			PdfWriter.getInstance(document, baos);
			document.left(100f);
			document.top(150f);
			document.open();
			PdfPTable table=new PdfPTable(9);
			table.setTotalWidth(new float[]{ 35,100,100,70,110,80,80,85,80 });
			table.setLockedWidth(true);
			//Font boldFont = new 
			Font boldFont = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);

			Paragraph p0 = new Paragraph("No", boldFont);
			p0.setLeading(0,1);
			p0.setAlignment(Element.ALIGN_CENTER);
			PdfPCell pdfWordCell0 = new PdfPCell();
			pdfWordCell0.setFixedHeight(20f);
			pdfWordCell0.addElement(p0);
			
			Paragraph p1 = new Paragraph("Nama Proyek", boldFont);
			p1.setLeading(0,1);
			p1.setAlignment(Element.ALIGN_CENTER);
			PdfPCell pdfWordCell1 = new PdfPCell();
			pdfWordCell1.addElement(p1);
			Paragraph p2 = new Paragraph("Nilai Investasi", boldFont);
			p2.setLeading(0,1);
			p2.setAlignment(Element.ALIGN_CENTER);
			PdfPCell pdfWordCell2 = new PdfPCell();
			pdfWordCell2.addElement(p2);
			Paragraph p3 = new Paragraph("PJPK", boldFont);
			p3.setLeading(0,1);
			p3.setAlignment(Element.ALIGN_CENTER);
			PdfPCell pdfWordCell3 = new PdfPCell();
			pdfWordCell3.addElement(p3);
			Paragraph p4 = new Paragraph("Tahapan KPBU", boldFont);
			p4.setLeading(0,1);
			p4.setAlignment(Element.ALIGN_CENTER);
			PdfPCell pdfWordCell4 = new PdfPCell();
			pdfWordCell4.addElement(p4);
			Paragraph p5 = new Paragraph("PDF", boldFont);
			p5.setLeading(0,1);
			p5.setAlignment(Element.ALIGN_CENTER);
			PdfPCell pdfWordCell5 = new PdfPCell();
			pdfWordCell5.addElement(p5);
			
			Paragraph p6 = new Paragraph("VGF", boldFont);
			p6.setLeading(0,1);
			p6.setAlignment(Element.ALIGN_CENTER);
			PdfPCell pdfWordCell6 = new PdfPCell();
			pdfWordCell6.addElement(p6);
			Paragraph p7 = new Paragraph("Penjaminan", boldFont);
			p7.setLeading(0,1);
			p7.setAlignment(Element.ALIGN_CENTER);
			PdfPCell pdfWordCell7 = new PdfPCell();
			pdfWordCell7.addElement(p7);
			Paragraph p8 = new Paragraph("AP", boldFont);
			p8.setLeading(0,1);
			p8.setAlignment(Element.ALIGN_CENTER);
			PdfPCell pdfWordCell8 = new PdfPCell();
			pdfWordCell8.addElement(p8);
			
			table.addCell(pdfWordCell0);
		    table.addCell(pdfWordCell1);
		    table.addCell(pdfWordCell2);
		    table.addCell(pdfWordCell3);
		    table.addCell(pdfWordCell4);
		    table.addCell(pdfWordCell5);
		    
		    table.addCell(pdfWordCell6);
		    table.addCell(pdfWordCell7);
		    table.addCell(pdfWordCell8);
		    
		    //value field
		    Font fontValue = new Font(Font.TIMES_ROMAN, 12, Font.NORMAL);
		    Paragraph p11 = new Paragraph();
		    PdfPCell pdfWordCell11 = new PdfPCell();
		    for(int a = 0 ; a < idPme.size() ; a++){
		    	p11 = new Paragraph(String.valueOf(a+1), fontValue);
				p11.setLeading(0,1);
				p11.setAlignment(Element.ALIGN_CENTER);
				pdfWordCell11 = new PdfPCell();
				pdfWordCell11.setFixedHeight(18f);
				pdfWordCell11.addElement(p11);
		    	table.addCell(pdfWordCell11); // no
		    	
		    	p11 = new Paragraph(namaPme.get(a), fontValue);
				p11.setLeading(0,1);
				p11.setAlignment(Element.ALIGN_LEFT);
				pdfWordCell11 = new PdfPCell();
				pdfWordCell11.addElement(p11);
		    	table.addCell(pdfWordCell11); // nama
		    	
		    	p11 = new Paragraph(investasiPme.get(a), fontValue);
				p11.setLeading(0,1);
				p11.setAlignment(Element.ALIGN_LEFT);
				pdfWordCell11 = new PdfPCell();
				pdfWordCell11.addElement(p11);
		    	table.addCell(pdfWordCell11); // investasi
		    	
		    	p11 = new Paragraph(pjpkPme.get(a), fontValue);
				p11.setLeading(0,1);
				p11.setAlignment(Element.ALIGN_LEFT);
				pdfWordCell11 = new PdfPCell();
				pdfWordCell11.addElement(p11);
		    	table.addCell(pdfWordCell11); // pjpk
		    	
		    	p11 = new Paragraph(tahapanPme.get(a), fontValue);
				p11.setLeading(0,1);
				p11.setAlignment(Element.ALIGN_CENTER);
				pdfWordCell11 = new PdfPCell();
				pdfWordCell11.addElement(p11);
		    	table.addCell(pdfWordCell11); // tahapankpbu
		    	
		    	p11 = new Paragraph(PDF.get(a), fontValue);
				p11.setLeading(0,1);
				p11.setAlignment(Element.ALIGN_CENTER);
				pdfWordCell11 = new PdfPCell();
				pdfWordCell11.addElement(p11);
		    	table.addCell(pdfWordCell11); // pdf
			    
		    	p11 = new Paragraph(VGF.get(a), fontValue);
				p11.setLeading(0,1);
				p11.setAlignment(Element.ALIGN_CENTER);
				pdfWordCell11 = new PdfPCell();
				pdfWordCell11.addElement(p11);
		    	table.addCell(pdfWordCell11); // vgf
		    	
		    	p11 = new Paragraph(penjaminanBersama.get(a), fontValue);
				p11.setLeading(0,1);
				p11.setAlignment(Element.ALIGN_CENTER);
				pdfWordCell11 = new PdfPCell();
				pdfWordCell11.addElement(p11);
		    	table.addCell(pdfWordCell11); // penjaminan
		    	
		    	p11 = new Paragraph(AP.get(a), fontValue);
				p11.setLeading(0,1);
				p11.setAlignment(Element.ALIGN_CENTER);
				pdfWordCell11 = new PdfPCell();
				pdfWordCell11.addElement(p11);
		    	table.addCell(pdfWordCell11); // ap
		 
		    }
		    
			document.add(table);
			document.add(Chunk.NEWLINE);
			document.close();

			response.setHeader("Expires", "0");
			response.setHeader("Cache-Control", "must-revalidate, post-check=0, pre-check=0");
			response.setHeader("Pragma", "public");
			response.setContentType("application/pdf");
			response.setContentLength(baos.size());

			ServletOutputStream out1 = response.getOutputStream();
			baos.writeTo(response.getOutputStream());
			out1.flush();
			out1.close();   
					
		} catch (Exception e) {
			e.printStackTrace();
//			session.setAttribute("errMsg", "error");
			try {
				response.sendRedirect(request.getContextPath()+"/Login");
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
        
    }
	
	@RequestMapping("/DashboardPME")
	public ModelAndView pme_dashboard(HttpServletRequest request, HttpServletResponse response) {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			return new ModelAndView("redirect:/Login");
		}

		
		Map<String, Object> model = new HashMap<String, Object>();
        
        List<Integer> idPme = new ArrayList<>();
		List<String> namaPme = new ArrayList<>();
		List<String> investasiPme = new ArrayList<>();
		List<String> pjpkPme = new ArrayList<>();
		List<String> tahapanPme = new ArrayList<>();
		List<String> area = new ArrayList<>();
		List<String> persentasePme = new ArrayList<>();
		List<Integer> id_jenis_tahapan = new ArrayList<>();
		List<String> statusPme = new ArrayList<>();
		List<Integer> countTahapanIdProject = new ArrayList<>();
		List<PmeEksportModel> eksport = null;
        
        try {
        		//////////
    			eksport = AccessDB.eGetAllProjectPME();
    			for(int a = 0 ; a < eksport.size() ; a++){
    				idPme.add(eksport.get(a).getId_proyek_pme());
    				namaPme.add(eksport.get(a).getProyek_name());
    				investasiPme.add(eksport.get(a).getNilai_investasi());
    				pjpkPme.add(eksport.get(a).getPjpk());
    				area.add(eksport.get(a).getArea());
    			}
    			
    			//get tahapan, status
    			for(int a = 0 ; a < idPme.size() ; a++){
    				//get tahapan
    				int idTahapanKPBU = AccessDB.eIdTahapanPMEbyIdProject(idPme.get(a), countTahapanIdProject);
    				//System.out.println("idTahapanKPBU:" + idTahapanKPBU);
    				String tahapan = AccessDB.eGetTahapanPMEbyIdTahapan(idTahapanKPBU, id_jenis_tahapan);
    				tahapanPme.add(tahapan);
    				
    				//get status
    				AccessDB.eIdTahapanPMEbyIdProjectAll(idPme.get(a), countTahapanIdProject); //get semua id_tahapan --> countTahapanIdProject
    				double persenTotal = 0;
    				for(int s = 0 ; s < countTahapanIdProject.size() ; s++){
    					AccessDB.eGetTahapanPMEbyIdTahapanAll(countTahapanIdProject.get(s), id_jenis_tahapan);
        				String persen = "";
        				double percentace = 0;
        				double totalPersen = 0;
        				double persentaseFix = 0;
        				//System.out.println("id_jenis_tahapan:"+id_jenis_tahapan + "|" + id_jenis_tahapan.size());
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
        						persenTotal = persenTotal + persentaseFix;
        						
        					}
        					
        				}
        				
        				
        				if(s == countTahapanIdProject.size()-1){
        					double tPersen = persenTotal / countTahapanIdProject.size();
        					String persenn = new DecimalFormat("##.##").format(tPersen);
        					persentasePme.add(persenn);
    						if(tPersen == 0){
    							statusPme.add("N/A");
    						}else if(tPersen > 0 && persentaseFix < 100){
    							statusPme.add("Sedang Berlangsung");
    						}else if(tPersen == 100){
    							statusPme.add("Selesai");
    						}
        				}
    				}
    				
    			}
       	    	
        	model.put("idPme", idPme);
        	model.put("namaPme", namaPme);
        	model.put("investasiPme", investasiPme);
        	model.put("pjpkPme", pjpkPme);
        	model.put("tahapanPme", tahapanPme);
        	model.put("area", area);
        	model.put("persentasePme", persentasePme);
        	//model.put("id_jenis_tahapan", id_jenis_tahapan);
        	model.put("statusPme", statusPme);
        	//model.put("eksport", eksport);
        	/////////
        	
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
        
		return new ModelAndView("view_pme_eksport", "msg", model);
        
    }

}
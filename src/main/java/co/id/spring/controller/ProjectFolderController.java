package co.id.spring.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FilenameUtils;
import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import co.id.spring.model.ProjectModel;
import co.id.spring.model.FileModel;
import co.id.spring.model.FolderModel;
import co.id.spring.model.UserModel;
import co.id.spring.model.JenisDokumenModel;
import co.id.spring.util.AccessDB;

@Controller
public class ProjectFolderController {
	static Logger log = Logger.getLogger(ProjectFolderController.class.getName());
	
	@RequestMapping("/proyek_folder/proyek/{id}/{sub_id}/{id_folder}/{id_folder}")
    public ModelAndView folder(@PathVariable("id") int id, @PathVariable("sub_id") int sub_id, 
    		@PathVariable("id_folder") int id_folder, HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
		HttpSession session = request.getSession();
		List<FolderModel> listFolder = null;
		List<FileModel> listFile = null;
		List<FolderModel> folderName = null;
		List<ProjectModel> proyekName = null;
		List<JenisDokumenModel> dokumen = null;
		boolean allowed = false;
		
		try {
			if(sub_id == 1){
				listFolder = AccessDB.getFolderById(id, sub_id);				
			}else{
				listFolder = AccessDB.getFolderById(id, sub_id, id_folder);
				listFile = AccessDB.getFileById(id, id_folder);
			}
			folderName = AccessDB.getFolderName(id_folder);
			proyekName = AccessDB.getProjectById(id);
			dokumen = AccessDB.getAllJenisDokumen();
			
		} catch (ClassNotFoundException e) {
			session.setAttribute("msg", "server");
    		return new ModelAndView("detail_proyek_folder");
		}catch (SQLException e) {
			session.setAttribute("msg", "server");
    		return new ModelAndView("detail_proyek_folder");
		}
        
		
		ModelAndView mv = new ModelAndView("detail_proyek_folder");
		mv.addObject("listFolder", listFolder);
		mv.addObject("listFile", listFile);
		mv.addObject("proyekName", proyekName);
		mv.addObject("folderName", folderName);
		mv.addObject("project_id", id);
		mv.addObject("sub_id", sub_id);
		mv.addObject("id_folder", id_folder);
		mv.addObject("dokumen", dokumen);
		
		log.info("user id "+session.getAttribute("user_id"));
		log.info("user id table "+String.valueOf(proyekName.get(0).getUserID()));
		log.info("level "+session.getAttribute("level"));
		if (session.getAttribute("user_id").toString().equals(String.valueOf(proyekName.get(0).getUserID()))
				|| session.getAttribute("level").toString().equals("3"))
			allowed = true;
		else if (session.getAttribute("user_id").toString().equals(String.valueOf(proyekName.get(0).getUserID()))
				&& session.getAttribute("level").toString().equals("2"))
			allowed = true;
		else
			allowed = false;
		
		mv.addObject("allowed", allowed);
		
		return mv;
//		return new ModelAndView("detail_proyek_folder", "listFolder", listFolder);
        
    }
	
//	@RequestMapping("/proyek_folder/proyek/{id}/{sub_id}/{id_folder}/{id_folder}/tambah")
	@RequestMapping("/proyek_folder/createFolder")
    public String tambahFolder(/**@PathVariable("id") int project_id, @PathVariable("sub_id") int sub_id, @PathVariable("id_folder") int id_folder,
     * @throws ParseException 
     * @throws IOException 
     * @throws NumberFormatException **/ 
    		HttpServletRequest request, HttpServletResponse response) throws NumberFormatException, IOException, ParseException {
		
		String folderName = request.getParameter("nama_folder");
		String project_id = request.getParameter("project_id");
		String sub_id = request.getParameter("sub_id");
		String id_folder = request.getParameter("id_folder");
		try {
			AccessDB.addNewFolder(Integer.parseInt(project_id), Integer.parseInt(sub_id), 
					Integer.parseInt(id_folder), folderName);
		} catch (ClassNotFoundException e) {
			return "redirect:/proyek_folder/proyek/"+project_id+"/"+sub_id+"/"+id_folder+"/"+id_folder;
		}catch (SQLException e) {
			return "redirect:/proyek_folder/proyek/"+project_id+"/"+sub_id+"/"+id_folder+"/"+id_folder;
		}
		
		return "redirect:/proyek_folder/proyek/"+project_id+"/"+sub_id+"/"+id_folder+"/"+id_folder;
        
    }
	
	@RequestMapping("/proyek_folder/editFolder")
    public String editFolder(HttpServletRequest request, HttpServletResponse response) throws NumberFormatException, IOException, ParseException {
		
		String folderName = request.getParameter("nama_folder");
		String project_id = request.getParameter("project_id");
		String sub_id = request.getParameter("sub_id");
		String id_folder = request.getParameter("id_folder");
		String id_edit_folder =request.getParameter("id_edit_folder");
		int hasil = 0;
		try {
			hasil = AccessDB.editFolder(folderName, Integer.parseInt(id_edit_folder));
			if(hasil > 0){
				return "redirect:/proyek_folder/proyek/"+project_id+"/"+sub_id+"/"+id_folder+"/"+id_folder;				
			}else{
				return "redirect:/proyek_folder/proyek/"+project_id+"/"+sub_id+"/"+id_folder+"/"+id_folder;	
			}
		} catch (ClassNotFoundException e) {
			return "redirect:/proyek_folder/proyek/"+project_id+"/"+sub_id+"/"+id_folder+"/"+id_folder;
		}catch (SQLException e) {
			return "redirect:/proyek_folder/proyek/"+project_id+"/"+sub_id+"/"+id_folder+"/"+id_folder;
		}
    }
	
	@RequestMapping("/proyek_folder/deleteFolder")
    public String deleteFolder(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException {
		
		String project_id = request.getParameter("project_id");
		String sub_id = request.getParameter("sub_id");
		String id_folder = request.getParameter("id_folder");
		String id_delete_folder =request.getParameter("id_delete_folder");
		int hasil = 0;
		
//		log.info("ini log delete folder");
//		log.info("project_id "+project_id);
//		log.info("sub_id "+sub_id);
//		log.info("id_folder "+id_folder);
//		log.info("id_delete_folder "+id_delete_folder);
		
		System.out.println(project_id+" dan "+sub_id+" dan "+id_folder);
		
		try{
			AccessDB.deleteFolder(id_delete_folder);
			
			return "redirect:/proyek_folder/proyek/"+project_id+"/"+sub_id+"/"+id_folder+"/"+id_folder;
			
		}catch (ClassNotFoundException e) {
			return "redirect:/proyek_folder/proyek/"+project_id+"/"+sub_id+"/"+id_folder+"/"+id_folder;
		}catch (SQLException e) {
			return "redirect:/proyek_folder/proyek/"+project_id+"/"+sub_id+"/"+id_folder+"/"+id_folder;
		}
	}
	
	@SuppressWarnings("deprecation")
	@RequestMapping(value = "/proyek_folder/uploadFile", method = RequestMethod.POST)
    public String uploadFile(@RequestParam("file") MultipartFile file, HttpServletRequest request, 
    		HttpServletResponse response) throws NumberFormatException, IOException, ParseException {
		HttpSession session = request.getSession();
		SimpleDateFormat fileFormat = new SimpleDateFormat("yyyyMMdd");
		java.util.Date date = new java.util.Date();
		InputStream inputStream = null;  
		OutputStream outputStream = null; 
		//String nama_file = request.getParameter("nama_file");
		String sub_id = request.getParameter("sub_id");
		String project_id = request.getParameter("project_id");
		String id_folder = request.getParameter("id_folder");
		String folder_path = request.getParameter("folder_path");
		String jenisDok = request.getParameter("jenis_dokumen");
		String nomor_surat = request.getParameter("nomor_surat");
		String tanggal_surat = request.getParameter("tanggal_surat");
		String perihal = request.getParameter("perihal").replace("<p>", "").replace("</p>", "");
		String user_id = session.getAttribute("user_id").toString();
		
		String fileName = file.getOriginalFilename();
		String path =request.getRealPath("/");
////		for windows
//		String path_dasar = path.replace("\\dms\\", "");
//		//String type = "."+FilenameUtils.getExtension(file.getOriginalFilename());
//		String filePath = "\\assets\\images\\";
		
//		for linux
		String path_dasar = path.replace("/dms/", "");
		//String type = "."+FilenameUtils.getExtension(file.getOriginalFilename());
		String filePath = "/assets/images/";
		
		int hasil = 0;		
		
		//if(fileType.equalsIgnoreCase(type)){
			try {
				hasil = AccessDB.insertNewFile(fileName, "\\.."+filePath+fileFormat.format(date.getTime())+"_"+fileName, 
						Integer.parseInt(project_id), Integer.parseInt(id_folder), folder_path.replaceAll("\\s", ""),
						nomor_surat, tanggal_surat, perihal, jenisDok, Integer.parseInt(user_id));
				if(hasil > 0){
					try{
						inputStream = file.getInputStream();  
						File newFile = new File(path_dasar+filePath+fileFormat.format(date.getTime())+"_"+fileName);  
						log.info("upload "+path_dasar+filePath+fileFormat.format(date.getTime())+"_"+fileName);
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
					return "redirect:/proyek_folder/proyek/"+project_id+"/"+sub_id+"/"+id_folder+"/"+id_folder;				
				}else{
					return "redirect:/proyek_folder/proyek/"+project_id+"/"+sub_id+"/"+id_folder+"/"+id_folder;	
				}
			} catch (ClassNotFoundException e) {
				return "redirect:/proyek_folder/proyek/"+project_id+"/"+sub_id+"/"+id_folder+"/"+id_folder;
			}catch (SQLException e) {
				return "redirect:/proyek_folder/proyek/"+project_id+"/"+sub_id+"/"+id_folder+"/"+id_folder;
			}
    }
	
	@SuppressWarnings("deprecation")
	@RequestMapping("/proyek_folder/deleteFile")
    public String deleteFile(HttpServletRequest request, HttpServletResponse response) throws IOException, NumberFormatException, ParseException {
		
		String id_file = request.getParameter("id_file");
		String file_path = request.getParameter("file_path");
		String project_id = request.getParameter("project_id");
		String sub_id = request.getParameter("sub_id");
		String id_folder = request.getParameter("id_folder");
		String path =request.getRealPath("/");
////		windows
//		String path_dasar = path.replace("\\dms\\", "");
//		linux
		String path_dasar = path.replace("/dms/", "");
//		System.out.println("After SUBSTRING");
//		System.out.println(file_path.substring(15));
//		log.info("delete file "+path_dasar+file_path);
		String[] parts = file_path.split("\\.");
		String file_path1 = parts[2]+"."+parts[3];
		
		int hasil = 0;
		log.info("delete file_path1  "+file_path1);
		try {
			hasil = AccessDB.deleteFile(Integer.parseInt(id_file));
			if(hasil > 0){
				File file = new File(path_dasar+file_path1);
				log.info("delete "+path_dasar+file_path1);
				if (file.exists()) {  
					file.delete();
				}
			}
		} catch (ClassNotFoundException e) {
			return "redirect:/proyek_folder/proyek/"+project_id+"/"+sub_id+"/"+id_folder+"/"+id_folder;
		}catch (SQLException e) {
			return "redirect:/proyek_folder/proyek/"+project_id+"/"+sub_id+"/"+id_folder+"/"+id_folder;
		}
		return "redirect:/proyek_folder/proyek/"+project_id+"/"+sub_id+"/"+id_folder+"/"+id_folder;
    }
	
	@SuppressWarnings("deprecation")
	@RequestMapping("/proyek_folder/editFile")
	public String editFile(@RequestParam("file") MultipartFile file, HttpServletRequest request, 
			HttpServletResponse response) throws IOException, NumberFormatException, ParseException {
		HttpSession session = request.getSession();
		String id_file = request.getParameter("id_file");
		String file_path = request.getParameter("file_path");
		String project_id = request.getParameter("project_id");
		String sub_id = request.getParameter("sub_id");
		String id_folder = request.getParameter("id_folder");
		
		String jenis_dokumen = request.getParameter("jenis_dokumen");
		String nomor_surat = request.getParameter("nomor_surat");
		String tanggal_surat = request.getParameter("tanggal_surat");
		String perihal = request.getParameter("perihal");
		int hasil = 0;
		InputStream inputStream = null;  
		OutputStream outputStream = null; 
		String filePath = "/assets/images/";
		SimpleDateFormat fileFormat = new SimpleDateFormat("yyyyMMdd");
		java.util.Date date = new java.util.Date();
		
		SimpleDateFormat editDate = new SimpleDateFormat("yyyy-MM-dd");

//			System.out.println("File path: "+request.getRealPath("/"));
//			System.out.println("File path: "+file_path);
		
		if (file.getOriginalFilename().isEmpty()){
			try {
				hasil = AccessDB.updateFileDMS(Integer.parseInt(jenis_dokumen), nomor_surat, tanggal_surat, perihal, 
						Integer.parseInt(id_file), session.getAttribute("username").toString(), editDate.format(date.getTime()));
				if(hasil > 0){
					return "redirect:/proyek_folder/proyek/"+project_id+"/"+sub_id+"/"+id_folder+"/"+id_folder;				
				}else{
					return "redirect:/proyek_folder/proyek/"+project_id+"/"+sub_id+"/"+id_folder+"/"+id_folder;	
				}
			}catch (ClassNotFoundException e) {
				return "redirect:/proyek_folder/proyek/"+project_id+"/"+sub_id+"/"+id_folder+"/"+id_folder;
			}catch (SQLException e) {
				return "redirect:/proyek_folder/proyek/"+project_id+"/"+sub_id+"/"+id_folder+"/"+id_folder;
			}
		}else{
//				System.out.println("Old file : "+request.getRealPath("/")+file_path);
//				System.out.println("Database file : "+file_path+fileFormat.format(date.getTime())+file.getOriginalFilename());
			try {
				String fileBaru = filePath+fileFormat.format(date.getTime())+"_"+file.getOriginalFilename();
//					System.out.println("File Baru : "+fileBaru);
				hasil = AccessDB.updateFileDMS(Integer.parseInt(jenis_dokumen), nomor_surat, tanggal_surat, perihal, 
						Integer.parseInt(id_file), session.getAttribute("username").toString(), 
						FilenameUtils.removeExtension(file.getOriginalFilename()), 
						fileBaru, editDate.format(date.getTime()));
				if(hasil > 0){
					try{
						inputStream = file.getInputStream();  
						File newFile = new File(request.getRealPath("/")+fileBaru);  
						System.out.println(""+fileBaru);
						if (!newFile.exists()) {  
							newFile.createNewFile();  
						}

						File oldFile = new File(request.getRealPath("/")+file_path);
						if(oldFile.exists())
							oldFile.delete();
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
					return "redirect:/proyek_folder/proyek/"+project_id+"/"+sub_id+"/"+id_folder+"/"+id_folder;				
				}else{
					return "redirect:/proyek_folder/proyek/"+project_id+"/"+sub_id+"/"+id_folder+"/"+id_folder;	
				}
			} catch (ClassNotFoundException e) {
				return "redirect:/proyek_folder/proyek/"+project_id+"/"+sub_id+"/"+id_folder+"/"+id_folder;
			}catch (SQLException e) {
				return "redirect:/proyek_folder/proyek/"+project_id+"/"+sub_id+"/"+id_folder+"/"+id_folder;
			}
		}
	}

}
package co.id.spring.util;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.logging.Logger;

import co.id.spring.model.AdditionalColumnModel;
import co.id.spring.model.FileModel;
import co.id.spring.model.FolderModel;
import co.id.spring.model.JenisDokumenModel;
import co.id.spring.model.JenisTahapanModel;
import co.id.spring.model.KegiatanModel;
import co.id.spring.model.PmeEksportModel;
import co.id.spring.model.ProjectModel;
import co.id.spring.model.SearchFileModel;
import co.id.spring.model.SektorModel;
import co.id.spring.model.TahapanModel;
import co.id.spring.model.TahunModel;
import co.id.spring.model.UserModel;
import co.id.spring.model.AreaModel;
import co.id.spring.model.CountModel;
import co.id.spring.model.MenuBerandaModel;
import co.id.spring.model.MapModel;

public class AccessDB {
	
	static Connection conn = null;
	static ResultSet rs = null;
	static ResultSet rs1 = null;
	static PreparedStatement ps = null;
	static Statement st = null;
	static Logger log = Logger.getLogger(AccessDB.class.getName());
	
	public static List<UserModel> validationUserLogin(String email, String pass) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		List<UserModel> list = new ArrayList<UserModel>();
		String sql = "select * from users where email = ? AND password = ?";
		conn = DBConnection.getConnection();
		log.info("conn "+conn);
		
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		String qMd5 = "SELECT MD5('"+ pass +"')";
		String passEnc = null;
		
		try{
			
			ps2 = conn.prepareStatement(qMd5);
			rs2 = ps2.executeQuery();
			while(rs2.next()){
				passEnc = rs2.getString(1);
			}
			
			ps = conn.prepareStatement(sql);
			ps.setString(1, email);
			ps.setString(2, passEnc);
			rs = ps.executeQuery();
			
			if(rs.next()){
				UserModel user = new UserModel();
				user.setUserID(rs.getInt("id_user"));
				user.setUsername(rs.getString("username"));
				user.setPassword(rs.getString("password"));
				user.setEmail(rs.getString("email"));
				user.setLevel(rs.getInt("level"));
				user.setDesc(rs.getString("description"));
				user.setCreateDate(rs.getString("create_date"));
				list.add(user);
				return list;
			}else{
				return null;
			}
			
			
		}catch(SQLException e){
			e.printStackTrace();
			return null;
		}finally{
			if(rs != null) {rs.close();}
			if(ps != null){ps.close();}
			if(rs2 != null) {rs2.close();}
			if(ps2 != null){ps2.close();}
			if(conn != null){conn.close();}
		}
	}
	
//	public static List<ProjectModel> getAllProject() throws ClassNotFoundException, SQLException{
//		List<ProjectModel> list = new ArrayList<ProjectModel>();
//		String sql = "select * from proyek_dms";
//		conn = DBConnection.getConnection();
//		try{
//			ps = conn.prepareStatement(sql);
//			rs = ps.executeQuery();
//			
//			while(rs.next()){
//				ProjectModel project = new ProjectModel();
//				project.setProjectID(rs.getInt("id_proyek_dms"));
//				project.setProjectName(rs.getString("proyek_name"));
//				project.setArea(rs.getString("area"));
//				project.setProgress(rs.getString("proyek_progress"));
//				project.setProjectDate(rs.getString("proyek_date"));
//				list.add(project);
//			}				
//			return list;
//			
//		}catch(SQLException e){
//			e.printStackTrace();
//			return null;
//		}finally{
//			if(conn != null)
//				conn.close();
//			if(rs != null)
//				rs.close();
//			if(ps != null)
//				ps.close();
//		}
//	}
	
	public static List<CountModel> getCount() throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		List<CountModel> list = new ArrayList<CountModel>();
		String sql = "select p.total_proyek, f.total_dokumen, u.total_user "
				   + "from ( select count(*) as total_proyek from proyek_dms ) p "
				   + "cross join ( select count(*) as total_dokumen from file_dms ) f "
				   + "cross join ( select count(*) as total_user from users ) u";
		conn = DBConnection.getConnection();
		try{
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			
			while(rs.next()){
				CountModel count = new CountModel();
				count.setTotalproyek(rs.getString("total_proyek"));
				count.setTotaldokumen(rs.getString("total_dokumen"));
				count.setTotaluser(rs.getString("total_user"));
				list.add(count);
			}
			return list;
		}catch(SQLException e){
			e.printStackTrace();
			return null;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	/*
	public static List<ProjectModel> getAllProyek() throws ClassNotFoundException, SQLException{
		List<ProjectModel> list = new ArrayList<ProjectModel>();
		String sql = "select * from proyek_dms";
		conn = DBConnection.getConnection();
		try{
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			
			while(rs.next()){
				ProjectModel project = new ProjectModel();
				project.setProjectID(rs.getInt("id_proyek_dms"));
				project.setProjectName(rs.getString("proyek_name"));
				project.setArea(rs.getString("area"));
				project.setProgress(rs.getString("proyek_progress"));
				//project.setProjectDate(formatDate(rs.getDate("proyek_date")));
				list.add(project);
			}
			return list;
		}catch(SQLException e){
			e.printStackTrace();
			return null;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	*/
	
	public static List<ProjectModel> getAllProject() throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		List<ProjectModel> list = new ArrayList<ProjectModel>();
		String sql = "select id_proyek_dms, proyek_name, area, nama_sektor, s.id_sektor, date(create_date) as tanggal, p.id_user from proyek_dms p, sektor s "
				+ "where p.id_sektor = s.id_sektor order by create_date desc";
		conn = DBConnection.getConnection();
		try{
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			//project_id, project_name, project_region, project_progress, project_date, create_date
			int flag = 0;
			while(rs.next()){
				flag = 1;
				ProjectModel project = new ProjectModel();
				project.setProjectID(rs.getInt("id_proyek_dms"));
				project.setProjectName(rs.getString("proyek_name"));
				project.setArea(rs.getString("area"));
				project.setSector(rs.getString("nama_sektor"));
				project.setSectorID(rs.getInt("id_sektor"));
				project.setValueTahunFrom(rs.getString("tanggal"));
				project.setUserID(rs.getInt("id_user"));
				//project.setProjectDate2(formatDate3(rs.getDate("proyek_date")));
				
				//set value field search
//				project.setNameField(nama_proyek);
//				project.setAreaField(area_proyek);
//				project.setProgressField(progress);
//				if(progress==null || progress.trim().equalsIgnoreCase("")){
//					progress = "Pilih Progress";
//					project.setProgressFieldValueView(progress);
//				}else{
//					project.setProgressFieldValueView(progress);
//				}
//				
//				project.setDateField(tahun);
				
				list.add(project);
			}	
			
			if(flag==0){
				ProjectModel project = new ProjectModel();
				//set value field search
				project.setNoDataQuery("noDataFromQuery");
				list.add(project);
			}
			
			return list;
			
		}catch(SQLException e){
			e.printStackTrace();
			return null;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static List<SektorModel> getAllSector() throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		List<SektorModel> list = new ArrayList<SektorModel>();
		Map<String, Object> sectorMap = new HashMap<String, Object>();
		String sql = "select * from sektor order by nama_sektor";
		conn = DBConnection.getConnection();
		try{
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			
			while(rs.next()){
				SektorModel sector = new SektorModel();
				sector.setNamaSektor(rs.getString("nama_sektor"));
				sector.setIdSektor(rs.getInt("id_sektor"));
				sectorMap.put(rs.getString("id_sektor"), rs.getString("nama_sektor"));
				sector.setSectorMap(sectorMap);
				list.add(sector);
			}	
			
			return list;
			
		}catch(SQLException e){
			e.printStackTrace();
			return null;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static List<TahunModel> getAllTahun() throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		List<TahunModel> list = new ArrayList<TahunModel>();
		String sql = "select min(substring(create_date,1,4)) tahunMin, max(substring(create_date,1,4)) tahunMax from proyek_dms";
		conn = DBConnection.getConnection();
		try{
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			
			while(rs.next()){
				TahunModel tahun = new TahunModel();
				tahun.setTahunFrom(rs.getString("tahunMin"));
				tahun.setTahunTo(rs.getString("tahunMax"));
				
				list.add(tahun);
			}	
			
			return list;
			
		}catch(SQLException e){
			e.printStackTrace();
			return null;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static List<AreaModel> getAllArea() throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		List<AreaModel> list = new ArrayList<AreaModel>();
		String sql = "select * from area order by nama_area";
		conn = DBConnection.getConnection();
		try{
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			
			while(rs.next()){
				AreaModel area = new AreaModel();
				area.setIdArea(rs.getInt("id_area"));
				area.setNamaArea(rs.getString("nama_area"));
				list.add(area);
			}	
			
			return list;
			
		}catch(SQLException e){
			e.printStackTrace();
			return null;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static List<ProjectModel> searchProject(String jenis_dok, String no_surat, String tgl_surat,
			String perihal, String sektor , String proyekname) 
			throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		
		List<ProjectModel> list = new ArrayList<ProjectModel>();
		String sql = "select distinct z.cd create_date, z.id_sektor, z.id_proyek_dms, z.proyek_name, z.nama_area, z.nama_sektor, z.id_user from "
				+ "(select a.create_date cd, b.id_sektor, a.id_proyek_dms, a.proyek_name,a.area nama_area, b.nama_sektor, a.id_user,"
				+ "ifnull(c.id_jenis_dokumen,'') id_jenis_dokumen,"
				+ "ifnull(c.nomor_surat,'') nomor_surat,"
				+ "ifnull(c.create_date,'') create_date,"
				+ "ifnull(c.perihal,'') perihal,"
				+ "ifnull(f.nama_jenis_dokumen,'') nama_jenis_dokumen "
				+ "from proyek_dms a "
				+ "left join sektor b ON a.id_sektor = b.id_sektor "
				+ "left join file_dms c on a.id_proyek_dms = c.id_proyek_dms "
				+ "left join jenis_dokumen f ON c.id_jenis_dokumen = f.id_jenis_dokumen "
				+ "where a.proyek_name like concat ('%',ifnull(?,a.proyek_name),'%') "
				+ "and b.nama_sektor like concat ('%',ifnull(?,b.nama_sektor),'%') "
				+ ") z "
				+ "where z.nama_jenis_dokumen like ifnull(concat('%',?,'%'),'%') "
				+ "and z.nomor_surat like ifnull(concat('%',?,'%'),'%') "
				+ "and z.create_date like ifnull(concat('%',?,'%'),'%') "
				+ "and z.perihal like ifnull(concat('%',?,'%'),'%') "
				+ "order by create_date desc";
		
		conn = DBConnection.getConnection();
		try{
			ps = conn.prepareStatement(sql);
			ps.setString(1, proyekname);
			ps.setString(2, sektor);
			ps.setString(3, jenis_dok);
			ps.setString(4, no_surat);
			ps.setString(5, tgl_surat);
			ps.setString(6, perihal);
			rs = ps.executeQuery();
			
			
			int flag = 0;
			while(rs.next()){
				flag = 1;
//				ProjectModel project = new ProjectModel();
//				project.setProjectID(rs.getInt("id_proyek_dms"));
//				project.setProjectName(rs.getString("proyek_name"));
//				project.setArea(rs.getString("nama_area"));
//				project.setSector(rs.getString("id_sektor"));
//				//project.setProgress(rs.getString("proyek_progress"));
//				
//				//set value field search
//				//project.setValueFileName(filename);
//				project.setValueProjectName(proyekname);
//				//project.setValueTahunFrom(yearfrom);
//				//project.setValueTahunTo(yearto);
//				
//				list.add(project);
				
				ProjectModel project = new ProjectModel();
				project.setProjectID(rs.getInt("id_proyek_dms"));
				project.setProjectName(rs.getString("proyek_name"));
				project.setArea(rs.getString("nama_area"));
				//project.setProgress(rs.getString("proyek_progress"));
				project.setSector(rs.getString("nama_sektor"));
				project.setSectorID(rs.getInt("id_sektor"));
				project.setUserID(rs.getInt("id_user"));
				//project.setAreaID(rs.getInt("area"));
				//project.setValueTahunFrom(rs.getString("tanggal"));
				
				list.add(project);
			}
			
			
//			if(flag==0){
//				ProjectModel project = new ProjectModel();
//				//set value field search
////				project.setNameField(proyekname);
////				project.setAreaField(proyekname);
////				project.setProgressField(proyekname);
////				project.setProgressFieldValueView(proyekname);
////				project.setProgressFieldValueView(proyekname);
////				project.setDateField(proyekname);
//				
//				project.setNoDataQuery("noDataFromQuery");
//				
//				//set value field search
//				//project.setValueFileName(filename);
//				project.setValueProjectName(proyekname);
//				//project.setValueTahunFrom(yearfrom);
//				//project.setValueTahunTo(yearto);
//				
//				list.add(project);
//			}
			
			if(flag==0){
				ProjectModel project = new ProjectModel();
				//set value field search
				project.setNoDataQuery("noDataFromQuery");
				list.add(project);
			}
			
			
			return list;
			
		}catch(SQLException e){
			e.printStackTrace();
			return null;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static int createNewProject(String proyek_name, String area, String proyek_sektor) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		java.util.Date date = new java.util.Date();
		String sql = "insert into proyek_dms (proyek_name, area, id_sektor, create_date)"
				+ "values (?, ?, ?, ?)";
		try{
			conn = DBConnection.getConnection();
			ps = conn.prepareStatement(sql);
			ps.setString(1, proyek_name);
			ps.setString(2, area);
			ps.setString(3, proyek_sektor);
			ps.setString(4, format.format(date.getTime()));
//			ps.execute();
			return ps.executeUpdate();					
			
		}catch(SQLException e){
			e.printStackTrace();
			return 0;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static int deleteProject(String user_id) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		String sql = "DELETE FROM proyek_dms WHERE id_proyek_dms = ?";
		conn = DBConnection.getConnection();
		int ret = 0;
		try{
			ps = conn.prepareStatement(sql);
			ps.setString(1, user_id);
			ret = ps.executeUpdate();		
			
		}catch(SQLException e){
			e.printStackTrace();
		}finally{
			if(conn != null)
				conn.close();
			if(ps != null)
				ps.close();
		}
		return ret;
	}
	
	public static int updateProject(String proyek_id, String proyek_name, String area, String proyek_sektor) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		//SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		//java.util.Date date = new java.util.Date();
		String sql = "UPDATE proyek_dms SET proyek_name=?,area=?,id_sektor=? "
				+ "WHERE id_proyek_dms = ?";
		try{
			conn = DBConnection.getConnection();
			ps = conn.prepareStatement(sql);
			ps.setString(1, proyek_name);
			ps.setString(2, area);
			ps.setString(3, proyek_sektor);
//			proyek_date = formatDate2(proyek_date);
			ps.setString(4, proyek_id);
//			ps.execute();
			return ps.executeUpdate();					
			
		}catch(SQLException e){
			e.printStackTrace();
			return 0;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static int insertFolder(String folderName, int projectID) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		java.util.Date date = new java.util.Date();
		String sql = "insert into folder_dms (folder_name, folder_sub, folder_parent, create_date, project_id)"
				+ "values (?, ?, ?, ?, ?)";
		try{
			conn = DBConnection.getConnection();
			ps = conn.prepareStatement(sql);
			ps.setString(1, folderName);
			ps.setString(2, String.valueOf(2));
			ps.setString(3, String.valueOf(projectID));
			ps.setString(4, format.format(date));
			ps.setString(5, String.valueOf(projectID));
			return ps.executeUpdate();					
			
		}catch(SQLException e){
			e.printStackTrace();
			return 0;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static void createDefaultFolder() throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String[] folderName = {"PDF","VGF","Penjaminan","AP"};
		String[] subFolderName = {"Nota Dinas","SK Penugasan"};
		java.util.Date date = new java.util.Date();
		
		for(int i=0; i<folderName.length; i++){
			String sql = "insert into folder_dms (folder_name, folder_sub, folder_parent, create_date, id_proyek_dms, path_folder) "
					+ "SELECT '"+folderName[i]+"', 1, 0, '"+format.format(date)+"', (SELECT MAX(id_proyek_dms) FROM proyek_dms p), '|'";
			try{
				conn = DBConnection.getConnection();
				ps = conn.prepareStatement(sql);
				ps.execute();
			}catch(SQLException e){
				e.printStackTrace();
			}
			
			for(int j=0; j<subFolderName.length; j++){
				String sql2;
				if(j == 0){
					sql2 = "insert into folder_dms (folder_name, folder_sub, folder_parent, create_date, id_proyek_dms, path_folder) "
							+ "SELECT '"+subFolderName[j]+"', 2, (SELECT MAX(id_folder_dms) FROM folder_dms), '"+format.format(date)+"', (SELECT MAX(id_proyek_dms) FROM proyek_dms), CONCAT((SELECT MAX(id_folder_dms)+1 FROM folder_dms),'|')";
				}else{
					sql2 = "insert into folder_dms (folder_name, folder_sub, folder_parent, create_date, id_proyek_dms, path_folder) "
							+ "SELECT '"+subFolderName[j]+"', 2, (SELECT MAX(id_folder_dms)-1 FROM folder_dms), '"+format.format(date)+"', (SELECT MAX(id_proyek_dms) FROM proyek_dms), CONCAT((SELECT MAX(id_folder_dms)+1 FROM folder_dms),'|')";					
				}
				try{
					ps = conn.prepareStatement(sql2);
					ps.execute();
				}catch(SQLException e){
					e.printStackTrace();
				}				
			}
		}

		if(conn != null)
			conn.close();
		if(rs != null)
			rs.close();
		if(ps != null)
			ps.close();
	}	
	public static List<UserModel> getAllUsers() throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		List<UserModel> list = new ArrayList<UserModel>();
		String sql = "select u.*, l.nama_level from users u, user_level l WHERE u.level = l.id";
		conn = DBConnection.getConnection();
		try{
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			
			while(rs.next()){
				UserModel user = new UserModel();
				user.setUserID(Integer.parseInt(rs.getString("id_user")));
				user.setUsername(rs.getString("username"));
				user.setPassword(rs.getString("password"));
				user.setEmail(rs.getString("email"));
				user.setLevel(Integer.parseInt(rs.getString("level")));
				user.setDesc(rs.getString("description"));
				user.setCreateDate(rs.getString("create_date"));
				user.setUserLevel(rs.getString("nama_level"));
				list.add(user);
			}

			return list;
			
			
		}catch(SQLException e){
			e.printStackTrace();
			return null;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static List<UserModel> getUserById(int user_id) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		List<UserModel> list = new ArrayList<UserModel>();
		String sql = "select * from users where id_user = ?";
		conn = DBConnection.getConnection();
		try{
			ps = conn.prepareStatement(sql);
			ps.setInt(1, user_id);
			rs = ps.executeQuery();
			
			while(rs.next()){
				UserModel user = new UserModel();
				user.setUserID(Integer.parseInt(rs.getString("id_user")));
				user.setUsername(rs.getString("username"));
				user.setPassword(rs.getString("password"));
				user.setEmail(rs.getString("email"));
				user.setLevel(Integer.parseInt(rs.getString("level")));
				user.setDesc(rs.getString("description"));
				user.setCreateDate(rs.getString("create_date"));
				list.add(user);
			}

			return list;
			
			
		}catch(SQLException e){
			e.printStackTrace();
			return null;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static void deleteUser(int user_id) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		String sql = "DELETE FROM users WHERE id_user = ?";
		conn = DBConnection.getConnection();
		try{
			ps = conn.prepareStatement(sql);
			ps.setInt(1, user_id);
			ps.executeUpdate();		
			
		}catch(SQLException e){
			e.printStackTrace();
		}finally{
			if(conn != null)
				conn.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static int createNewUser(String username, String password, String email, String level, String desc) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		java.util.Date date = new java.util.Date();
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		String qMd5 = "SELECT MD5('"+ password +"')";
		String passEnc = null;
		String sql = "insert into users (username, password, email, level, description, create_date)"
				+ "values (?, ?, ?, ?, ?, ?)";
		try{
			conn = DBConnection.getConnection();
			
			ps2 = conn.prepareStatement(qMd5);
			rs2 = ps2.executeQuery();
			while(rs2.next()){
				passEnc = rs2.getString(1);
			}
			
			ps = conn.prepareStatement(sql);
			ps.setString(1, username);
			ps.setString(2, passEnc);
			ps.setString(3, email);
			ps.setString(4, level);
			ps.setString(5, desc);
			ps.setString(6, format.format(date));
//			ps.execute();
			return ps.executeUpdate();					
			
		}catch(SQLException e){
			e.printStackTrace();
			return 0;
		}finally{
			if(rs != null) {rs.close();}
			if(ps != null){ps.close();}
			if(rs2 != null) {rs2.close();}
			if(ps2 != null){ps2.close();}
			if(conn != null){conn.close();}
		}
	}
	
	public static int updateUser(int user_id, String username, String password, String level, 
			String desc, String ganti_password) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		String sql = "";
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		String qMd5 = "SELECT MD5('"+ password +"')";
		String passEnc = null;
		
		try{
			
			conn = DBConnection.getConnection();
			
			ps2 = conn.prepareStatement(qMd5);
			rs2 = ps2.executeQuery();
			while(rs2.next()){
				passEnc = rs2.getString(1);
			}
			
			if(ganti_password != null){
				sql = "update users SET username = '"+username+"', password = '"+passEnc+"', "
						+ "level = '"+level+"', description = '"+desc+"' WHERE id_user = '"+user_id+"'";
			}else{
				sql = "update users SET username = '"+username+"', "
						+ "level = '"+level+"', description = '"+desc+"' WHERE id_user = '"+user_id+"'";
			}
			ps = conn.prepareStatement(sql);
			return ps.executeUpdate();					
			
		}catch(SQLException e){
			e.printStackTrace();
			return 0;
		}finally{
			if(rs != null) {rs.close();}
			if(ps != null){ps.close();}
			if(rs2 != null) {rs2.close();}
			if(ps2 != null){ps2.close();}
			if(conn != null){conn.close();}
		}
	}
	
	public static List<MenuBerandaModel> getAllMenu() throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		List<MenuBerandaModel> list = new ArrayList<MenuBerandaModel>();
		String sql = "select * from menu_beranda order by id_menu desc";
		conn = DBConnection.getConnection();
		try{
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			
			while(rs.next()){
				MenuBerandaModel menu = new MenuBerandaModel();
				menu.setIdMenu(rs.getInt("id_menu"));
				menu.setNamaMenu(rs.getString("nama_menu"));
				menu.setUrl(rs.getString("url"));
				menu.setJenis(rs.getString("jenis"));
				menu.setContent(rs.getString("content"));
				list.add(menu);
			}

			return list;
			
			
		}catch(SQLException e){
			e.printStackTrace();
			return null;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static List<MenuBerandaModel> getMenuByUrl(String url) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		List<MenuBerandaModel> list = new ArrayList<MenuBerandaModel>();
		String sql = "select * from menu_beranda where url ='"+url+"'";
		conn = DBConnection.getConnection();
		try{
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			
			while(rs.next()){
				MenuBerandaModel menu = new MenuBerandaModel();
				menu.setIdMenu(rs.getInt("id_menu"));
				menu.setNamaMenu(rs.getString("nama_menu"));
				menu.setUrl(rs.getString("url"));
				menu.setJenis(rs.getString("jenis"));
				menu.setContent(rs.getString("content"));
				list.add(menu);
			}

			return list;
			
			
		}catch(SQLException e){
			e.printStackTrace();
			return null;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static void deleteMenu(int id_menu) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		String sql = "DELETE FROM menu_beranda WHERE id_menu = ?";
		conn = DBConnection.getConnection();
		try{
			ps = conn.prepareStatement(sql);
			ps.setInt(1, id_menu);
			ps.executeUpdate();		
			
		}catch(SQLException e){
			e.printStackTrace();
		}finally{
			if(conn != null)
				conn.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static int createNewMenu(String nama_menu, String url, String jenis, String content) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		String sql = "insert into menu_beranda (nama_menu, url, jenis, content)"
				+ "values (?, ?, ?, ?)";
		try{
			conn = DBConnection.getConnection();
			ps = conn.prepareStatement(sql);
			ps.setString(1, nama_menu);
			ps.setString(2, url);
			ps.setString(3, jenis);
			ps.setString(4, content);
//			ps.execute();
			return ps.executeUpdate();					
		}catch(SQLException e){
			e.printStackTrace();
			return 0;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static int updateMenu(int id_menu, String nama_menu, String url, String jenis, String content) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		String sql = "update menu_beranda SET nama_menu = '"+nama_menu+"', url = '"+url+"',"
					+ "jenis = '"+jenis+"', content = '"+content+"' WHERE id_menu = '"+id_menu+"'";
		try{
			conn = DBConnection.getConnection();
			ps = conn.prepareStatement(sql);
			return ps.executeUpdate();					
			
		}catch(SQLException e){
			e.printStackTrace();
			return 0;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static List<SearchFileModel> searchFile(String jenisDok, String noSurat, String perihal, String sektor, String tanggal/**, String proyekname**/) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		List<SearchFileModel> list = new ArrayList<SearchFileModel>();
		String sql = "";
		sql = "SELECT fl.file_name as filename, pr.proyek_name, jd.nama_jenis_dokumen as jenis_dokumen, fl.nomor_surat, fl.perihal, fl.file_path, date(fl.create_date) as tanggal, sk.nama_sektor, us.username "
			 + "FROM users us, sektor sk join proyek_dms pr on sk.id_sektor=pr.id_sektor join file_dms fl on pr.id_proyek_dms=fl.id_proyek_dms join jenis_dokumen jd on jd.id_jenis_dokumen=fl.id_jenis_dokumen "
			 + "where us.id_user=fl.id_user AND jd.nama_jenis_dokumen like '%"+jenisDok+"%' and fl.nomor_surat like '%"+noSurat+"%' and fl.perihal like '%"+perihal+"%' and sk.nama_sektor like '%"+sektor+"%' and date(fl.create_date) like '%"+tanggal+"%' and pr.proyek_name like '%%'";
	conn = DBConnection.getConnection();
		try{
			conn = DBConnection.getConnection();
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();					
			while(rs.next()){
				SearchFileModel search = new SearchFileModel();
				search.setFileName(rs.getString("filename"));
				search.setProyekName(rs.getString("proyek_name"));
				search.setJenisDok(rs.getString("jenis_dokumen"));
				search.setNoSurat(rs.getString("nomor_surat"));
				search.setPerihal(rs.getString("perihal"));
				search.setSektor(rs.getString("nama_sektor"));
				search.setProjectDate(rs.getString("tanggal"));
				search.setFilePath(rs.getString("file_path"));
				search.setUploadBy(rs.getString("username"));
				list.add(search);
			}
			return list;	
		}catch(SQLException e){
			e.printStackTrace();
			return null;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static int createNewProject(String proyek_name, String proyek_region, String proyek_sektor,
		    String user_id) 
		    throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		    java.util.Date date = new java.util.Date();
		    String sql = "insert into proyek_dms (proyek_name, area, id_sektor, create_date, id_user)"
		        + "values (?, ?, ?, ?, ?)";
		    try{
		      conn = DBConnection.getConnection();
		      ps = conn.prepareStatement(sql);
		      ps.setString(1, proyek_name);
		      ps.setString(2, proyek_region);
		      ps.setString(3, proyek_sektor);
		      ps.setString(4, format.format(date.getTime()));
		      ps.setInt(5, Integer.parseInt(user_id));
//		      ps.execute();
		      return ps.executeUpdate();          
		      
		    }catch(SQLException e){
		      e.printStackTrace();
		      return 0;
		    }finally{
		      if(conn != null)
		        conn.close();
		      if(rs != null)
		        rs.close();
		      if(ps != null)
		        ps.close();
		    }
	}
	
	public static int updateProject(String proyek_id, String proyek_name, String area, String proyek_sektor, String proyek_progress)
			throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		//SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		//java.util.Date date = new java.util.Date();
		String sql = "UPDATE proyek_dms SET proyek_name=?,area=?,id_sektor=?,proyek_progress=? "
				+ "WHERE id_proyek_dms = ?";
		try{
			conn = DBConnection.getConnection();
			ps = conn.prepareStatement(sql);
			ps.setString(1, proyek_name);
			ps.setString(2, area);
			ps.setString(3, proyek_sektor);
			ps.setString(4, proyek_progress);
//			proyek_date = formatDate2(proyek_date);
			ps.setString(5, proyek_id);
//			ps.execute();
			return ps.executeUpdate();					
			
		}catch(SQLException e){
			e.printStackTrace();
			return 0;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	
	public static List<ProjectModel> getProjectById(int proyek_id) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		List<ProjectModel> list =new ArrayList<ProjectModel>();
		String sql = "select * from proyek_dms where id_proyek_dms = ?";
		conn =DBConnection.getConnection();
		try{
			ps = conn.prepareStatement(sql);
			ps.setInt(1, proyek_id);
			rs = ps.executeQuery();
			
			while(rs.next()){
				ProjectModel project = new ProjectModel();
				project.setProjectID(rs.getInt("id_proyek_dms"));
				project.setProjectName(rs.getString("proyek_name"));
				project.setUserID(rs.getInt("id_user"));
				list.add(project);
			}
			return list;
		}catch(SQLException e){
			e.printStackTrace();
			return null;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static List<FolderModel> getFolderName(int folder_id) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		List<FolderModel> list =new ArrayList<FolderModel>();
		String sql = "SELECT * FROM (SELECT *, CASE WHEN id_folder_dms = ? "
				   + "THEN @id := folder_parent WHEN id_folder_dms = @id THEN @id := folder_parent END as checkId "
				   + "FROM folder_dms order by id_folder_dms desc)T WHERE checkId IS NOT NULL order by checkId ASC";
		conn =DBConnection.getConnection();
		try{
			ps = conn.prepareStatement(sql);
			ps.setInt(1, folder_id);
			rs = ps.executeQuery();
			
			while(rs.next()){
				FolderModel folder = new FolderModel();
				folder.setIdProyekDms(rs.getInt("id_proyek_dms"));
				folder.setIdFolderDms(rs.getInt("id_folder_dms"));
				folder.setFolderSub(rs.getInt("folder_sub"));
				folder.setFolderParent(rs.getInt("folder_parent"));
				folder.setFolderName(rs.getString("folder_name"));
				list.add(folder);
			}
			return list;
		}catch(SQLException e){
			e.printStackTrace();
			return null;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static List<FolderModel> getFolderById(int proyek_id, int sub_id) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		List<FolderModel> list = new ArrayList<FolderModel>();
		String sql = "select * from folder_dms where folder_sub = ? AND id_proyek_dms = ?";
		conn = DBConnection.getConnection();
		try{
			ps = conn.prepareStatement(sql);
			ps.setInt(1, sub_id);
			ps.setInt(2, proyek_id);
			rs = ps.executeQuery();
			
			while(rs.next()){
				FolderModel folder = new FolderModel();
				folder.setIdFolderDms(rs.getInt("id_folder_dms"));
				folder.setFolderName(rs.getString("folder_name"));
				folder.setFolderSub(rs.getInt("folder_sub"));
				folder.setFolderParent(rs.getInt("folder_parent"));
				folder.setIdProyekDms(rs.getInt("id_proyek_dms"));
				
				list.add(folder);
			}

			return list;
			
			
		}catch(SQLException e){
			e.printStackTrace();
			return null;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static List<FolderModel> getFolderById(int proyek_id, int sub_id, int id_folder) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		List<FolderModel> list = new ArrayList<FolderModel>();
		String sql = "select * from folder_dms where folder_sub = ? AND id_proyek_dms = ? AND folder_parent = ?";
		conn = DBConnection.getConnection();
		try{
			ps = conn.prepareStatement(sql);
			ps.setInt(1, sub_id);
			ps.setInt(2, proyek_id);
			ps.setInt(3, id_folder);
			rs = ps.executeQuery();
			
			while(rs.next()){
				FolderModel folder = new FolderModel();
				folder.setIdFolderDms(rs.getInt("id_folder_dms"));
				folder.setFolderName(rs.getString("folder_name"));
				folder.setFolderSub(rs.getInt("folder_sub"));
				folder.setFolderParent(rs.getInt("folder_parent"));
				folder.setIdProyekDms(rs.getInt("id_proyek_dms"));
				
				list.add(folder);
			}

			return list;
			
			
		}catch(SQLException e){
			e.printStackTrace();
			return null;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static void addNewFolder(int id_proyek_dms, int sub_id, int id_folder_dms, String folderName) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		java.util.Date date = new java.util.Date();
		String id_folder_dms_query="";
		String path_folder_query ="";
		conn = DBConnection.getConnection();
		log.info("id_proyek_dms "+id_proyek_dms);
		log.info("sub_id "+sub_id);
		log.info("id_folder_dms "+id_folder_dms);
		log.info("folderName "+folderName);
		try{
			String sql = "insert into folder_dms (folder_name, folder_sub, folder_parent, create_date, id_proyek_dms) "
					+ "values (?, ?, ?, ?, ?)";
			ps = conn.prepareStatement(sql);
			ps.setString(1, folderName);
			ps.setInt(2, sub_id);
			ps.setInt(3, id_folder_dms);
			ps.setString(4, format.format(date.getTime()));
			ps.setInt(5, id_proyek_dms);
			ps.execute();
//			return ps.executeUpdate();		
			
			String sql3="Select * from folder_dms where id_folder_dms=?";
			ps = conn.prepareStatement(sql3);
			ps.setInt(1, id_folder_dms);
			rs1 = ps.executeQuery();
			while(rs1.next()){
				path_folder_query = rs1.getString("path_folder");
			}
			
			String sql1="Select * from folder_dms where folder_name=? and  folder_parent=? and id_proyek_dms=?";
			ps = conn.prepareStatement(sql1);
			ps.setString(1, folderName);
			ps.setInt(2, id_folder_dms);
			ps.setInt(3, id_proyek_dms);
			rs = ps.executeQuery();
			while(rs.next()){
				id_folder_dms_query = rs.getString("id_folder_dms");
			}

			String sql2="Update folder_dms set path_folder=? where folder_name=? and  folder_parent=? and id_proyek_dms=?";
			ps = conn.prepareStatement(sql2);
			ps.setString(1, path_folder_query+""+id_folder_dms_query+"|");
			ps.setString(2, folderName);
			ps.setInt(3, id_folder_dms);
			ps.setInt(4, id_proyek_dms);
			ps.execute();
			
		}catch(SQLException e){
			e.printStackTrace();
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(rs1 != null)
				rs1.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static void deleteFolder(String id_path_folder) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		conn = DBConnection.getConnection();
		log.info("id_path_folder "+id_path_folder);
		try{
			String vsql="delete from folder_dms where path_folder like ?";
			ps = conn.prepareStatement(vsql);
			ps.setString(1, "%"+id_path_folder+"%");
			ps.executeUpdate();	
			
		}catch(SQLException e){
			e.printStackTrace();
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static int editFolder(String folderName, int id_folder) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		String sql = "UPDATE folder_dms SET folder_name = ? WHERE id_folder_dms = ?";
		try{
			conn = DBConnection.getConnection();
			ps = conn.prepareStatement(sql);
			ps.setString(1, folderName);
			ps.setInt(2, id_folder);
			return ps.executeUpdate();					
			
		}catch(SQLException e){
			e.printStackTrace();
			return 0;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static int insertNewFile(String fileName, String filePath, int project_id, 
			int id_folder_dms, String folder_path, String nomor_surat, String tanggal_surat,
			String perihal, String jenisDok, int id_user) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{		
		SimpleDateFormat format_date = new SimpleDateFormat("yyyy-MM-dd");
		java.util.Date date = new java.util.Date();
		
		String sql = "insert into file_dms (nomor_surat, file_name, file_path, folder_path, id_jenis_dokumen, perihal, create_date, id_proyek_dms, id_folder_dms, id_user, upload_date) "
				+ "values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		try{
			conn = DBConnection.getConnection();
			ps = conn.prepareStatement(sql);
			ps.setString(1, nomor_surat);
			ps.setString(2, fileName);
			ps.setString(3, filePath);
			ps.setString(4, folder_path);
			ps.setString(5, jenisDok);
			ps.setString(6, perihal);
			ps.setString(7, tanggal_surat);
			ps.setInt(8, project_id);
			ps.setInt(9, id_folder_dms);
			ps.setInt(10, id_user);
			ps.setString(11, format_date.format(date.getTime()));
			return ps.executeUpdate();
			
		}catch(SQLException e){ 
			e.printStackTrace();
			return 0;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static int deleteFile(int id_file_dms) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		String sql = "DELETE d.*, p.* FROM file_dms d LEFT JOIN file_pme p ON d.id_file_dms = p.id_file WHERE d.id_file_dms = ?";
				
		conn = DBConnection.getConnection();
		try{
			ps = conn.prepareStatement(sql);
			ps.setInt(1, id_file_dms);
			return ps.executeUpdate();		
			
		}catch(SQLException e){
			e.printStackTrace();
			return 0;
		}finally{
			if(conn != null)
				conn.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static List<FileModel> getFileById(int proyek_id, int id_folder) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		List<FileModel> list = new ArrayList<FileModel>();
		String sql = "select f.*, j.id_jenis_dokumen, j.nama_jenis_dokumen, u.username from file_dms f, jenis_dokumen j, users u where "
				+ "id_proyek_dms = ? AND id_folder_dms = ? AND f.id_jenis_dokumen = j.id_jenis_dokumen AND f.id_user=u.id_user";
		conn = DBConnection.getConnection();
		try{
			ps = conn.prepareStatement(sql);
			ps.setInt(1, proyek_id);
			ps.setInt(2, id_folder);
			rs = ps.executeQuery();
			
			while(rs.next()){
				FileModel file = new FileModel();
				file.setId_file(rs.getInt("id_file_dms"));
				file.setFile_name(rs.getString("file_name"));
				file.setFile_path(rs.getString("file_path"));
				file.setFolder_path(rs.getString("folder_path"));
				file.setPerihal(rs.getString("perihal"));
				file.setNomor_surat(rs.getString("nomor_surat"));
				file.setEditBy(rs.getString("edit_by"));
//				file.setFile_type(rs.getString("file_type"));
				file.setId_user(rs.getInt("id_user"));
				file.setDate(rs.getString("upload_date"));
				file.setDate_surat(rs.getString("create_date"));
				file.setNama_jenis_dokumen(rs.getString("nama_jenis_dokumen"));
				file.setUploadBy(rs.getString("username"));
				file.setId_jenis_dokumen(rs.getInt("id_jenis_dokumen"));
				file.setEditDate(rs.getString("edit_date"));
				list.add(file);
			}

			return list;
			
			
		}catch(SQLException e){
			e.printStackTrace();
			return null;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static List<SektorModel> getAllSektor() throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		List<SektorModel> list = new ArrayList<SektorModel>();
		String sql = "select * from sektor";
		conn = DBConnection.getConnection();
		try{
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			
			while(rs.next()){
				SektorModel sektor = new SektorModel();
				sektor.setIdSektor(rs.getInt("id_sektor"));
				sektor.setNamaSektor(rs.getString("nama_sektor"));
				list.add(sektor);
			}
			return list;
		}catch(SQLException e){
			e.printStackTrace();
			return null;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static int createNewSektor(String namasektor) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		String sql = "insert into sektor (nama_sektor)"
				+ "values (?)";
		try{
			conn = DBConnection.getConnection();
			ps = conn.prepareStatement(sql);
			ps.setString(1, namasektor);
//			ps.execute();
			return ps.executeUpdate();					
			
		}catch(SQLException e){
			e.printStackTrace();
			return 0;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static int updateSektor(int idsektor, String namasektor) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		String sql = "update sektor SET nama_sektor = '"+namasektor+"' where id_sektor = '"+idsektor+"'";
		try{
			conn = DBConnection.getConnection();
			ps = conn.prepareStatement(sql);
			return ps.executeUpdate();					
			
		}catch(SQLException e){
			e.printStackTrace();
			return 0;
		}finally{
			if(conn != null)
				conn.close();
			if(rs != null)
				rs.close();
			if(ps != null)
				ps.close();
		}
	}
	
	public static void deleteSektor(int idsektor) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		String sql = "DELETE FROM sektor WHERE id_sektor = ?";
		conn = DBConnection.getConnection();
		try{
			ps = conn.prepareStatement(sql);
			ps.setInt(1, idsektor);
			ps.executeUpdate();		
			
		}catch(SQLException e){
			e.printStackTrace();
		}finally{
			if(conn != null)
				conn.close();
			if(ps != null)
				ps.close();
		}
	}
	
	//PME
			public static List<ProjectModel> getAllProjectPME() throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
				List<ProjectModel> list = new ArrayList<ProjectModel>();
				String sql = "select a.*, b.nama_sektor from proyek_pme a, sektor b where a.id_sektor=b.id_sektor order by created_date desc";
				conn = DBConnection.getConnection();
				try{
					ps = conn.prepareStatement(sql);
					rs = ps.executeQuery();
					int flag = 0;
					while(rs.next()){
						flag = 1;
						ProjectModel project = new ProjectModel();
						project.setProjectID(rs.getInt("id_proyek_pme"));
						project.setProjectName(rs.getString("proyek_name"));
						project.setUserID(rs.getInt("id_user"));
						project.setSector(rs.getString("nama_sektor"));
						
						list.add(project);
					}	
					
					if(flag==0){
						ProjectModel project = new ProjectModel();
						//set value field search
						project.setNoDataQuery("noDataFromQuery");
						list.add(project);
					}
					
					return list;
					
				}catch(SQLException e){
					e.printStackTrace();
					return null;
				}finally{
					if(conn != null)
						conn.close();
					if(rs != null)
						rs.close();
					if(ps != null)
						ps.close();
				}
			}
			
			public static int createNewProjectPME(String proyek_name, String proyek_region, String wilayah, String pjpk, String nilai_proyek, String id_user, String id_sektor) 
					throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
				SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				java.util.Date date = new java.util.Date();
				String tahapan[] = {"Tahapan KPBU", "PDF", "VGF", "Penjaminan", "AP"}; 
				String sub_tahapan_kpbu[] = {"OBC", "FBC", "PQ", "RFP", "Bid Award", "PPP Agreement Signing", "FC", "Construction", "Operation"};
//				String sub_tahapan_fddk[] = {"PDF", "VGF", "Penjaminan Bersama", "AP"};
				
				String sql = "insert into proyek_pme (proyek_name, area, created_date, pjpk, nilai_investasi, id_user, id_map, id_sektor)"
						+ "values (?, ?, ?, ?, ?, ?, ?, ?)";
				try{
					conn = DBConnection.getConnection();
					ps = conn.prepareStatement(sql);
					ps.setString(1, proyek_name);
					ps.setString(2, proyek_region);
					ps.setString(3, format.format(date.getTime()));
					ps.setString(4, pjpk);
					ps.setString(5, nilai_proyek);
					ps.setInt(6, Integer.parseInt(id_user));
					ps.setString(7, wilayah);
					ps.setInt(8, Integer.parseInt(id_sektor));
					ps.execute();
//					return ps.executeUpdate();			
					
					for(int i=0; i<tahapan.length; i++){
						String sqlTahapan;
						if (i == 0){
							sqlTahapan = "insert into tahapan_pme (nama_tahapan, is_active, created_date, id_project_pme) "
									+ "SELECT '"+tahapan[i]+"', 1, '"+format.format(date)+"', (SELECT MAX(id_proyek_pme) FROM proyek_pme p)";	
							
							try{
								ps = conn.prepareStatement(sqlTahapan);
								ps.execute();
							}catch(SQLException e){
								e.printStackTrace();
								return 0;
							}
							
							for(int j=0; j<sub_tahapan_kpbu.length; j++){
								String sqlSubTahapan;
								if (j == 0)
									sqlSubTahapan = "insert into jenis_tahapan (nama_jenis, sub_name, status, disable, created_date, id_tahapan, step) "
										+ "SELECT '"+sub_tahapan_kpbu[j]+"', '"+sub_tahapan_kpbu[j]+"', 0, 'enabled', '"+format.format(date)+"', (SELECT MAX(id_tahapan) FROM tahapan_pme t), '"+(j+1)+"'";
								else
									sqlSubTahapan = "insert into jenis_tahapan (nama_jenis, sub_name, status, created_date, id_tahapan, step) "
											+ "SELECT '"+sub_tahapan_kpbu[j]+"', '"+sub_tahapan_kpbu[j]+"', 0, '"+format.format(date)+"', (SELECT MAX(id_tahapan) FROM tahapan_pme t), '"+(j+1)+"'";
								try{
									ps = conn.prepareStatement(sqlSubTahapan);
									ps.execute();
								}catch(SQLException e){
									e.printStackTrace();
									return 0;
								}	
							}
						}else {
							sqlTahapan = "insert into tahapan_pme (nama_tahapan, is_active, created_date, id_project_pme) "
									+ "SELECT '"+tahapan[i]+"', 1, '"+format.format(date)+"', (SELECT MAX(id_proyek_pme) FROM proyek_pme p)";	
							
							try{
								ps = conn.prepareStatement(sqlTahapan);
								ps.execute();
							}catch(SQLException e){
								e.printStackTrace();
								return 0;
							}
						}
					}
					
					return 1;
					
				}catch(SQLException e){
					e.printStackTrace();
					return 0;
				}finally{
					if(conn != null)
						conn.close();
					if(rs != null)
						rs.close();
					if(ps != null)
						ps.close();
				}
			}
			
			public static int deleteProjectPME(String user_id) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
				String sql = "DELETE FROM proyek_pme WHERE id_proyek_pme = ?";
				conn = DBConnection.getConnection();
				int ret = 0;
				try{
					ps = conn.prepareStatement(sql);
					ps.setString(1, user_id);
					ret = ps.executeUpdate();		
					
				}catch(SQLException e){
					e.printStackTrace();
				}finally{
					if(conn != null)
						conn.close();
					if(ps != null)
						ps.close();
				}
				return ret;
			}
			
		public static List<TahapanModel> getTahapanByProjectID(String project_id) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			List<TahapanModel> listTahapan = new ArrayList<TahapanModel>();
			String sql = "select * from tahapan_pme where id_project_pme = ?";

//				String sql = "select p.proyek_name, t.id_tahapan, t.nama_tahapan, t.is_active from proyek_pme p,"
//						+ " tahapan_pme t where p.id_proyek_pme = t.id_project_pme AND t.id_project_pme = ?";
			conn = DBConnection.getConnection();
			try{
				ps = conn.prepareStatement(sql);
				ps.setInt(1, Integer.parseInt(project_id));
				rs = ps.executeQuery();
				
				while(rs.next()){
					TahapanModel tahapan = new TahapanModel();
					tahapan.setIdTahapan(Integer.parseInt(rs.getString("id_tahapan")));
					tahapan.setNamaTahapan(rs.getString("nama_tahapan"));
					tahapan.setIsActive(Integer.parseInt(rs.getString("is_active")));
					listTahapan.add(tahapan);
				}
				return listTahapan;
			}catch(SQLException e){
				e.printStackTrace();
				return null;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static List<TahapanModel> getTahapanByProjectIDViewDash(String project_id) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			List<TahapanModel> listTahapan = new ArrayList<TahapanModel>();
			String sql = "select * from tahapan_pme where id_project_pme = ? and is_active='1'";

//				String sql = "select p.proyek_name, t.id_tahapan, t.nama_tahapan, t.is_active from proyek_pme p,"
//						+ " tahapan_pme t where p.id_proyek_pme = t.id_project_pme AND t.id_project_pme = ?";
			conn = DBConnection.getConnection();
			try{
				ps = conn.prepareStatement(sql);
				ps.setInt(1, Integer.parseInt(project_id));
				rs = ps.executeQuery();
				
				while(rs.next()){
					TahapanModel tahapan = new TahapanModel();
					tahapan.setIdTahapan(Integer.parseInt(rs.getString("id_tahapan")));
					tahapan.setNamaTahapan(rs.getString("nama_tahapan"));
					tahapan.setIsActive(Integer.parseInt(rs.getString("is_active")));
					listTahapan.add(tahapan);
				}
				return listTahapan;
			}catch(SQLException e){
				e.printStackTrace();
				return null;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static String getProjectNameAndUserID(String project_id) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			String sql = "select proyek_name, id_user from proyek_pme where id_proyek_pme = ?";
			
			conn = DBConnection.getConnection();
			String projectName = "";
			int id_user=0;
			try{
				ps = conn.prepareStatement(sql);
				ps.setInt(1, Integer.parseInt(project_id));
				rs = ps.executeQuery();
				
				while(rs.next()){
					projectName = rs.getString("proyek_name");
					id_user = rs.getInt("id_user");
				}
				return projectName+"|"+id_user;
			}catch(SQLException e){
				e.printStackTrace();
				return "|";
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static int checkTahapan(String id_tahapan) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			String sql = "select is_active from tahapan_pme where id_tahapan = ?";
			
			conn = DBConnection.getConnection();
			int is_active = 0;
			try{
				ps = conn.prepareStatement(sql);
				ps.setInt(1, Integer.parseInt(id_tahapan));
				rs = ps.executeQuery();
				
				while(rs.next()){
					is_active = rs.getInt("is_active");
				}
				return is_active;
			}catch(SQLException e){
				e.printStackTrace();
				return 0;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static int checkProject(String id_project) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			String sql = "select COUNT(proyek_name) as total from proyek_pme where id_proyek_pme = ?";
			
			conn = DBConnection.getConnection();
			int is_active = 0;
			try{
				ps = conn.prepareStatement(sql);
				ps.setInt(1, Integer.parseInt(id_project));
				rs = ps.executeQuery();
				
				while(rs.next()){
					is_active = rs.getInt("total");
				}
				return is_active;
			}catch(SQLException e){
				e.printStackTrace();
				return 0;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static List<JenisTahapanModel> getJenisTahapanById(String id_tahapan) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			List<JenisTahapanModel> listJenis = new ArrayList<JenisTahapanModel>();
			String sql = "select * from jenis_tahapan where id_tahapan = ?";

			conn = DBConnection.getConnection();
			try{
				ps = conn.prepareStatement(sql);
				ps.setInt(1, Integer.parseInt(id_tahapan));
				rs = ps.executeQuery();
				
				while(rs.next()){
					JenisTahapanModel jenis = new JenisTahapanModel();
					jenis.setIdJenisTahapan(rs.getInt("id_jenis_tahapan"));
					jenis.setNamaJenisTahapan(rs.getString("nama_jenis"));
					jenis.setSubName(rs.getString("sub_name"));
					jenis.setStatus(rs.getInt("status"));
					jenis.setDisableEnabled(rs.getString("disable"));
					jenis.setId_user(rs.getInt("id_user"));
					listJenis.add(jenis);
				}
				return listJenis;
			}catch(SQLException e){
				e.printStackTrace();
				return null;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static List<KegiatanModel> getKegiatanById(String id_jenis_tahapan) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			List<KegiatanModel> list = new ArrayList<KegiatanModel>();
			String sql = "select * from kegiatan_pme where id_jenis_tahapan = ?";

			conn = DBConnection.getConnection();
			try{
				ps = conn.prepareStatement(sql);
				ps.setInt(1, Integer.parseInt(id_jenis_tahapan));
				rs = ps.executeQuery();
				
				while(rs.next()){
					KegiatanModel jenis = new KegiatanModel();
					jenis.setIdKegiatan(rs.getInt("id_kegiatan_pme"));
					jenis.setNamaKegiatan(rs.getString("nama_kegiatan"));
					jenis.setTarget(rs.getString("target"));
					jenis.setRealisasi(rs.getString("realisasi"));
					jenis.setKeterangan(rs.getString("keterangan"));
					jenis.setStatus(rs.getString("status"));
					jenis.setId_user(rs.getInt("id_user"));
					jenis.setUsername(rs.getString("username"));
					list.add(jenis);
				}
				return list;
			}catch(SQLException e){
				e.printStackTrace();
				return null;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static int getIDProjectDMS(int id_project) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			String sql = "select id_user from proyek_dms where id_proyek_dms = ?";
			
			conn = DBConnection.getConnection();
			int id_user = 0;
			try{
				ps = conn.prepareStatement(sql);
				ps.setInt(1, id_project);
				rs = ps.executeQuery();
				
				while(rs.next()){
					id_user = rs.getInt("id_user");
				}
				return id_user;
			}catch(SQLException e){
				e.printStackTrace();
				return 0;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static int getUserIDProjectPME(int id_project) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			String sql = "select id_user from proyek_pme where id_proyek_pme = ?";
			
			conn = DBConnection.getConnection();
			int id_user = 0;
			try{
				ps = conn.prepareStatement(sql);
				ps.setInt(1, id_project);
				rs = ps.executeQuery();
				
				while(rs.next()){
					id_user = rs.getInt("id_user");
				}
				return id_user;
			}catch(SQLException e){
				e.printStackTrace();
				return 0;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static List<JenisDokumenModel> getAllJenisDokumen() throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			List<JenisDokumenModel> list = new ArrayList<JenisDokumenModel>();
			String sql = "select * from jenis_dokumen order by id_jenis_dokumen desc";
			conn = DBConnection.getConnection();
			try{
				ps = conn.prepareStatement(sql);
				rs = ps.executeQuery();
				
				while(rs.next()){
					JenisDokumenModel jd = new JenisDokumenModel();
					jd.setIdJenisDokumen(rs.getInt("id_jenis_dokumen"));
					jd.setNamaJenisDokumen(rs.getString("nama_jenis_dokumen"));
					list.add(jd);
				}

				return list;
				
				
			}catch(SQLException e){
				e.printStackTrace();
				return null;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static void deleteJenisDokumen(int id_jd) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			String sql = "DELETE FROM jenis_dokumen WHERE id_jenis_dokumen = ?";
			conn = DBConnection.getConnection();
			try{
				ps = conn.prepareStatement(sql);
				ps.setInt(1, id_jd);
				ps.executeUpdate();		
				
			}catch(SQLException e){
				e.printStackTrace();
			}finally{
				if(conn != null)
					conn.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static int createJenisDokumen(String nama_jd) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			String sql = "insert into jenis_dokumen (nama_jenis_dokumen)"
					+ "values (?)";
			try{
				conn = DBConnection.getConnection();
				ps = conn.prepareStatement(sql);
				ps.setString(1, nama_jd);
//				ps.execute();
				return ps.executeUpdate();					
			}catch(SQLException e){
				e.printStackTrace();
				return 0;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static int updateJenisDokumen(int id_jd, String nama_jd) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			String sql = "update jenis_dokumen SET nama_jenis_dokumen = '"+nama_jd+"' WHERE id_jenis_dokumen = '"+id_jd+"'";
			try{
				conn = DBConnection.getConnection();
				ps = conn.prepareStatement(sql);
				return ps.executeUpdate();					
				
			}catch(SQLException e){
				e.printStackTrace();
				return 0;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static int updateNilaiInvestasi(String nilai, int sektor, String pjpk, String area, int id_proyek_pme, String wilayah) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			String sql = "update proyek_pme SET nilai_investasi = '"+nilai+"',  id_sektor = '"+sektor+"', pjpk = '"+pjpk+"', area = '"+area+"', id_map = '"+wilayah+"' WHERE id_proyek_pme = '"+id_proyek_pme+"'";
			try{
				conn = DBConnection.getConnection();
				ps = conn.prepareStatement(sql);
				return ps.executeUpdate();					
				
			}catch(SQLException e){
				e.printStackTrace();
				return 0;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static int tambahKegiatan(String nama_kegiatan, String target, String realisasi, String keterangan,
				String status, int id_jenis_tahapan, int id_user, String userName) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			java.util.Date date = new java.util.Date();
			
			String sql = "insert into kegiatan_pme (nama_kegiatan, target, realisasi, keterangan, status, created_date, id_jenis_tahapan, id_user, username)"
					+ "values (?, ?, ?, ?, ?, ?, ?, ?, ?)";
			try{
				conn = DBConnection.getConnection();
				ps = conn.prepareStatement(sql);
				ps.setString(1, nama_kegiatan);
				ps.setString(2, target);
				ps.setString(3, realisasi);
				ps.setString(4, keterangan);
				ps.setString(5, status);
				ps.setString(6, format.format(date.getTime()));
				ps.setInt(7, id_jenis_tahapan);
				ps.setInt(8, id_user);
				ps.setString(9, userName);
				ps.execute();
				
				return 1;
//				return ps.executeUpdate();					
			}catch(SQLException e){
				e.printStackTrace();
				return 0;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static int tambahKolomBaru(String nama, String deskripsi, int id_proyek_pme) 
				throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			java.util.Date date = new java.util.Date();
			
			String sql = "insert into additional_column (nama_kolom, description, created_date, id_proyek_pme)"
					+ "values (?, ?, ?, ?)";
			try{
				conn = DBConnection.getConnection();
				ps = conn.prepareStatement(sql);
				ps.setString(1, nama);
				ps.setString(2, deskripsi);
				ps.setString(3, format.format(date.getTime()));
				ps.setInt(4, id_proyek_pme);
				ps.execute();
				
				return 1;			
			}catch(SQLException e){
				e.printStackTrace();
				return 0;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static int updateJenisName(String nama_tahapan, int id_jenis_tahapan) 
				throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			String sql = "UPDATE jenis_tahapan SET nama_jenis = ? WHERE id_jenis_tahapan = ?";
			conn = DBConnection.getConnection();
			int ret = 0;
			try{
				ps = conn.prepareStatement(sql);
				ps.setString(1, nama_tahapan);
				ps.setInt(2, id_jenis_tahapan);
				ret = ps.executeUpdate();		
				
			}catch(SQLException e){
				e.printStackTrace();
			}finally{
				if(conn != null)
					conn.close();
				if(ps != null)
					ps.close();
			}
			return ret;
		}
		
		public static int updateProgressPME(int id_jenis_tahapan, int status) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			String sql = "UPDATE jenis_tahapan SET status = ? WHERE id_jenis_tahapan = ?";
			conn = DBConnection.getConnection();
			int ret = 0;
			try{
				ps = conn.prepareStatement(sql);
				ps.setInt(1, status);
				ps.setInt(2, id_jenis_tahapan);
				ret = ps.executeUpdate();		
				
			}catch(SQLException e){
				e.printStackTrace();
			}finally{
				if(conn != null)
					conn.close();
				if(ps != null)
					ps.close();
			}
			return ret;
		}
		
		public static int updateJenisTahapanStep(int id_tahapan) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
		    String sql = "UPDATE jenis_tahapan j1 SET j1.disable = 'enabled' WHERE j1.step = (SELECT MIN(j2.step) FROM ("
		          + "SELECT * FROM jenis_tahapan) j2 WHERE j2.id_tahapan = '"+id_tahapan+"' AND j2.disable = 'disabled') AND id_tahapan = '"+id_tahapan+"'";
		    conn = DBConnection.getConnection();
		    try{
		      ps = conn.prepareStatement(sql);
		      ps.executeUpdate();
		      return 1;
		      
		    }catch(SQLException e){
		      e.printStackTrace();
		      return 1;
		    }finally{
		      if(conn != null)
		        conn.close();
		      if(ps != null)
		        ps.close();
		    }
		  }
		
		public static int tambahFilePME(String fileName, String filePath, int fileType, String nomorSurat,
				String tanggalSurat, String perihal, String createdDate, int idKegiatan, int id_user,
				String upload_by) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			java.util.Date date = new java.util.Date();
			
			String sql = "insert into file_pme (file_name, file_path, jenis_file, nomor_surat, tanggal_surat, perihal, created_date, id_kegiatan, id_user, upload_by)"
					+ "values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			try{
				conn = DBConnection.getConnection();
				ps = conn.prepareStatement(sql);
				ps.setString(1, fileName);
				ps.setString(2, filePath);
				ps.setInt(3, fileType);
				ps.setString(4, nomorSurat);
				ps.setString(5, tanggalSurat);
				ps.setString(6, perihal);
				ps.setString(7, createdDate);
				ps.setInt(8, idKegiatan);
				ps.setInt(9, id_user);
				ps.setString(10, upload_by);
				ps.execute();
				
				return 1;
//				return ps.executeUpdate();					
			}catch(SQLException e){
				e.printStackTrace();
				return 0;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static int tambahFilePMEDariDMS(String idfile, String fileName, String filePath, int jenisFile, String nomorSurat,
				String perihal, String tanggalsurat, int idKegiatan, int id_user, String upload_by) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			java.util.Date date = new java.util.Date();
			
			String sql = "insert into file_pme (id_file, file_name, file_path, jenis_file, nomor_surat, tanggal_surat, perihal, created_date, id_kegiatan, id_user, upload_by)"
					+ "values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			try{
				conn = DBConnection.getConnection();
				ps = conn.prepareStatement(sql);
				ps.setInt(1, Integer.parseInt(idfile));
				ps.setString(2, fileName);
				ps.setString(3, filePath);
				ps.setInt(4, jenisFile);
				ps.setString(5, nomorSurat);
				ps.setString(6, tanggalsurat);
				ps.setString(7, perihal);
				ps.setString(8, format.format(date.getTime()));
				ps.setInt(9, idKegiatan);
				ps.setInt(10, id_user);
				ps.setString(11, upload_by);
				ps.execute();
				
				return 1;
//				return ps.executeUpdate();					
			}catch(SQLException e){
				e.printStackTrace();
				return 0;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static int updateFileDMS(int jenis_dokumen, String nomor_surat, String tanggal_surat, String perihal,
				int id_file, String edit_by, String edit_date) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			String sql = "UPDATE file_dms SET id_jenis_dokumen = ?, nomor_surat = ?, create_date = ?, perihal = ?, edit_by = ?, edit_date = ? WHERE id_file_dms = ?";
			conn = DBConnection.getConnection();
			int ret = 0;
			try{
				ps = conn.prepareStatement(sql);
				ps.setInt(1, jenis_dokumen);
				ps.setString(2, nomor_surat);
				ps.setString(3, tanggal_surat);
				ps.setString(4, perihal);
				ps.setString(5, edit_by);
				ps.setString(6, edit_date);
				ps.setInt(7, id_file);
				
				ret = ps.executeUpdate();		
				
			}catch(SQLException e){
				e.printStackTrace();
			}finally{
				if(conn != null)
					conn.close();
				if(ps != null)
					ps.close();
			}
			return ret;
		}
		
		public static int updateFileDMS(int jenis_dokumen, String nomor_surat, String tanggal_surat, String perihal,
				int id_file, String edit_by, String file_name, String file_path, String edit_date) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			String sql = "UPDATE file_dms SET id_jenis_dokumen = ?, nomor_surat = ?, create_date = ?, perihal = ?, edit_by = ?, file_name = ?, file_path = ?, edit_date = ? WHERE id_file_dms = ?";
			conn = DBConnection.getConnection();
			int ret = 0;
			try{
				ps = conn.prepareStatement(sql);
				ps.setInt(1, jenis_dokumen);
				ps.setString(2, nomor_surat);
				ps.setString(3, tanggal_surat);
				ps.setString(4, perihal);
				ps.setString(5, edit_by);
				ps.setString(6, file_name);
				ps.setString(7, file_path);	
				ps.setString(8, edit_date);			
				ps.setInt(9, id_file);
				
				ret = ps.executeUpdate();		
				
			}catch(SQLException e){
				e.printStackTrace();
			}finally{
				if(conn != null)
					conn.close();
				if(ps != null)
					ps.close();
			}
			return ret;
		}
		
		public static int updateKegiatan(String namaKegiatan, String target, String realisasi,
				String deskripsi, String status, int id_kegiatan) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			String sql = "UPDATE kegiatan_pme SET nama_kegiatan = ?, target = ?, realisasi = ?, keterangan = ?, status = ? WHERE id_kegiatan_pme = ?";
			conn = DBConnection.getConnection();
			int ret = 0;
			try{
				ps = conn.prepareStatement(sql);
				ps.setString(1, namaKegiatan);
				ps.setString(2, target);
				ps.setString(3, realisasi);
				ps.setString(4, deskripsi);
				ps.setString(5, status);
				ps.setInt(6, id_kegiatan);
				ret = ps.executeUpdate();		
				
			}catch(SQLException e){
				e.printStackTrace();
				return 0;
			}finally{
				if(conn != null)
					conn.close();
				if(ps != null)
					ps.close();
			}
			return ret;
		}
		
		public static List<ProjectModel> getMapArea() throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			List<ProjectModel> list = new ArrayList<ProjectModel>();
			String sql = "select area, count(area) as jumlah from proyek_pme group by area";
			conn = DBConnection.getConnection();
			try{
				ps = conn.prepareStatement(sql);
				rs = ps.executeQuery();
				
				while(rs.next()){
					ProjectModel project = new ProjectModel();
					project.setArea(rs.getString("area"));
					project.setAreaID(rs.getInt("jumlah"));
					list.add(project);
				}
				return list;
				
			}catch(SQLException e){
				e.printStackTrace();
				return null;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static List<ProjectModel> getProgress() throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			List<ProjectModel> list = new ArrayList<ProjectModel>();
			String sql = "select pp.proyek_name, pp.id_proyek_pme, "
					+ "coalesce(100/COUNT(kp.status),0) in (select coalesce(COUNT(kp.status),0) "
					+ "from proyek_pme pp left join tahapan_pme tp on pp.id_proyek_pme=tp.id_project_pme "
					+ "left join jenis_tahapan jp on tp.id_tahapan=jp.id_tahapan "
					+ "left join kegiatan_pme kp on jp.id_jenis_tahapan=kp.id_jenis_tahapan "
					+ "where (kp.status = 1 OR kp.status = 2) group by pp.id_proyek_pme) as persentase "
					+ "from proyek_pme pp left join tahapan_pme tp on pp.id_proyek_pme=tp.id_project_pme "
					+ "left join jenis_tahapan jp on tp.id_tahapan=jp.id_tahapan "
					+ "left join kegiatan_pme kp on jp.id_jenis_tahapan=kp.id_jenis_tahapan "
					+ "group by pp.id_proyek_pme";
			conn = DBConnection.getConnection();
			try{
				ps = conn.prepareStatement(sql);
				rs = ps.executeQuery();
				
				while(rs.next()){
					ProjectModel project = new ProjectModel();
					project.setProgress(rs.getString("persentase"));
					project.setProjectName(rs.getString("proyek_name"));
					project.setProjectID(rs.getInt("id_proyek_pme"));
					list.add(project);       
				}
				return list;
				
			}catch(SQLException e){
				e.printStackTrace();
				return null;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static List<ProjectModel> getTableDashboard() throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			List<ProjectModel> list = new ArrayList<ProjectModel>();
			String sql = "select * from proyek_pme pp left join tahapan_pme tp on pp.id_proyek_pme=tp.id_project_pme left join jenis_tahapan jp on tp.id_tahapan=jp.id_tahapan where pp.id_proyek_pme";
			conn = DBConnection.getConnection();
			try{
				ps = conn.prepareStatement(sql);
				rs = ps.executeQuery();
				int flag = 0;
				while(rs.next()){
					flag = 1;
					ProjectModel project = new ProjectModel();
					project.setProjectID(rs.getInt("id_proyek_pme"));
					project.setProjectName(rs.getString("proyek_name"));
					project.setUserID(rs.getInt("id_user"));
					project.setPjpk(rs.getString("pjpk"));
					project.setNilaiProyek(rs.getString("nilai_investasi"));
					project.setArea(rs.getString("area"));
					list.add(project);
				}	
				
				if(flag==0){
					ProjectModel project = new ProjectModel();
					//set value field search
					project.setNoDataQuery("noDataFromQuery");
					list.add(project);
				}
				
				return list;
				
			}catch(SQLException e){
				e.printStackTrace();
				return null;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static int deleteFilePME(String id_file, String id_kegiatan) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			String sql = "DELETE FROM file_pme WHERE id_file = ? AND id_kegiatan = ?";
			conn = DBConnection.getConnection();
			int ret = 0;
			try{
				ps = conn.prepareStatement(sql);
				ps.setString(1, id_file);
				ps.setInt(2, Integer.parseInt(id_kegiatan));
				ret = ps.executeUpdate();		
				
			}catch(SQLException e){
				e.printStackTrace();
			}finally{
				if(conn != null)
					conn.close();
				if(ps != null)
					ps.close();
			}
			return ret;
		}
		
		public static int hapusKolomBaru(int id_kolom) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			String sql = "DELETE FROM additional_column WHERE id = ?";
			conn = DBConnection.getConnection();
			int ret = 0;
			try{
				ps = conn.prepareStatement(sql);
				ps.setInt(1, id_kolom);
				ret = ps.executeUpdate();		
				
			}catch(SQLException e){
				e.printStackTrace();
			}finally{
				if(conn != null)
					conn.close();
				if(ps != null)
					ps.close();
			}
			return ret;
		}
		
		public static int hapusKegiatan(int id_kegiatan) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			String sql = "DELETE FROM kegiatan_pme WHERE id_kegiatan_pme = ?";
			conn = DBConnection.getConnection();
			try{
				ps = conn.prepareStatement(sql);
				ps.setInt(1, id_kegiatan);
				ps.execute();		
				return 1;
				
			}catch(SQLException e){
				e.printStackTrace();
				return 0;
			}finally{
				if(conn != null)
					conn.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static int tambahTahapan(int id_tahapan, String nama_tahapan, int total, int id_user) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			java.util.Date date = new java.util.Date();
			String status;
			
			if (total > 0)
				status = "disabled";
			else
				status = "enabled";
			
			String sql = "insert into jenis_tahapan (nama_jenis, sub_name, status, disable, created_date, id_tahapan, step, id_user) "
					+ "SELECT '"+nama_tahapan+"', '"+nama_tahapan+"', 0, '"+status+"', '"+format.format(date.getTime())+"', "
							+ "'"+id_tahapan+"', (SELECT IFNULL(MAX(step)+1, 0+1) FROM jenis_tahapan where id_tahapan = '"+id_tahapan+"'),"+"'"+id_user+"'";
					
			try{
				conn = DBConnection.getConnection();
				ps = conn.prepareStatement(sql);
//				ps.setString(1, nama_tahapan);
//				ps.setString(2, nama_tahapan);
//				ps.setInt(3, 0);
//				ps.setString(4, status);
//				ps.setString(5, format.format(date));
//				ps.setInt(6, id_tahapan);
//				ps.setString(7, "");
				ps.execute();
//				return ps.executeUpdate();	
				return 1;
				
			}catch(SQLException e){
				e.printStackTrace();
				return 0;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static int checkJenisTahapan(int id_tahapan) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			String sql = "select COUNT(id_jenis_tahapan) as total from jenis_tahapan where id_tahapan = ?";
			
			conn = DBConnection.getConnection();
			int total = 0;
			try{
				ps = conn.prepareStatement(sql);
				ps.setInt(1, id_tahapan);
				rs = ps.executeQuery();
				
				while(rs.next()){
					total = rs.getInt("total");
				}
				return total;
			}catch(SQLException e){
				e.printStackTrace();
				return total;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static int hapusTahapan(int id_jenis_tahapan) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			String sql = "DELETE FROM jenis_tahapan WHERE id_jenis_tahapan = ?";
			conn = DBConnection.getConnection();
			try{
				ps = conn.prepareStatement(sql);
				ps.setInt(1, id_jenis_tahapan);
				ps.execute();		
				return 1;
				
			}catch(SQLException e){
				e.printStackTrace();
				return 0;
			}finally{
				if(conn != null)
					conn.close();
				if(ps != null)
					ps.close();
			}
		}
		
			
		public static int getPercentageFromJP(int id_jenis_tahapan) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			String sql = "select ((select 100*count(status) from kegiatan_pme where "
						+ "status = '1'  AND id_jenis_tahapan = ?)+(select 50*count(status) from kegiatan_pme where "
						+ "status = '2'  AND id_jenis_tahapan = ?))/count(status) as persentase from kegiatan_pme WHERE id_jenis_tahapan = ?";
			
			conn = DBConnection.getConnection();
			int percentage = 0;
			try{
				ps = conn.prepareStatement(sql);
				ps.setInt(1, id_jenis_tahapan);
				ps.setInt(2, id_jenis_tahapan);
				ps.setInt(3, id_jenis_tahapan);
				rs = ps.executeQuery();
				
				while(rs.next()){
					percentage = rs.getInt("persentase");
				}
				return percentage;
			}catch(SQLException e){
				e.printStackTrace();
				return 0;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		
		// BIKIN LEMOT LIMITATION
		public static List<FileModel> getAllFileDMS(int pageid, int total, String search_fileupload) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			String sql = "select a.*, b.proyek_name from file_dms a, proyek_dms b "
					+ "where a.id_proyek_dms = b.id_proyek_dms "
					+ "and a.file_name like '%"+search_fileupload+"%' or b.proyek_name like '%"+search_fileupload+"%'"
					+ "ORDER BY upload_date DESC "
					+ "LIMIT "+(pageid-1)+","+total;
			
			conn = DBConnection.getConnection();
			List<FileModel> list = new ArrayList<FileModel>();
			try{
				ps = conn.prepareStatement(sql);
				rs = ps.executeQuery();
				
				while(rs.next()){
					FileModel file = new FileModel();
					file.setId_file(rs.getInt("id_file_dms"));
					file.setFile_name(rs.getString("file_name"));
					file.setFile_path(rs.getString("file_path"));
					file.setPerihal(rs.getString("perihal"));
					file.setNomor_surat(rs.getString("nomor_surat"));
					file.setEditBy(rs.getString("edit_by"));
//					file.setFile_type(rs.getString("file_type"));
					file.setDate(rs.getString("create_date"));
					file.setId_user(rs.getInt("id_user"));
					file.setId_jenis_dokumen(rs.getInt("id_jenis_dokumen"));
					file.setFolder_path(rs.getString("folder_path"));
					file.setProyek_name(rs.getString("proyek_name"));
					
					list.add(file);
				}
				return list;
			}catch(SQLException e){
				e.printStackTrace();
				return null;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		
		public static List<ProjectModel> getProjectPMEByID(int proyek_id) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			List<ProjectModel> list =new ArrayList<ProjectModel>();
			String sql = "select p.*, s.nama_sektor, m.title from proyek_pme p, sektor s, map_area m where p.id_sektor = s.id_sektor AND p.id_map = m.id "
					+ "AND id_proyek_pme = ?";
			conn =DBConnection.getConnection();
			try{
				ps = conn.prepareStatement(sql);
				ps.setInt(1, proyek_id);
				rs = ps.executeQuery();
				
				while(rs.next()){
					ProjectModel project = new ProjectModel();
					project.setProjectID(rs.getInt("id_proyek_pme"));
					project.setProjectName(rs.getString("proyek_name"));
					project.setUserID(rs.getInt("id_user"));
					project.setPjpk(rs.getString("pjpk"));
					project.setNilaiInvestasi(rs.getString("nilai_investasi"));
					project.setSektor(rs.getString("nama_sektor"));
					project.setArea(rs.getString("area"));
					project.setMapTitle(rs.getString("title"));
					list.add(project);
				}
				return list;
			}catch(SQLException e){
				e.printStackTrace();
				return null;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static List<ProjectModel> getProjectPMEByUserID(int tahapan_id) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			List<ProjectModel> list =new ArrayList<ProjectModel>();
			String sql = "select * from tahapan_pme a, proyek_pme b where id_tahapan = ? and b.id_proyek_pme = a.id_project_pme";
			conn =DBConnection.getConnection();
			try{
				ps = conn.prepareStatement(sql);
				ps.setInt(1, tahapan_id);
				rs = ps.executeQuery();
				
				while(rs.next()){
					ProjectModel project = new ProjectModel();
					project.setProjectID(rs.getInt("id_proyek_pme"));
					project.setProjectName(rs.getString("proyek_name"));
					project.setUserID(rs.getInt("id_user"));
					project.setPjpk(rs.getString("pjpk"));
					project.setNilaiInvestasi(rs.getString("nilai_investasi"));
					project.setArea(rs.getString("area"));
					list.add(project);
				}
				return list;
			}catch(SQLException e){
				e.printStackTrace();
				return null;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static List<ProjectModel> getKegiatanPMEByUserID(int kegiatan_pme_id) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			List<ProjectModel> list =new ArrayList<ProjectModel>();
			String sql = "select * from jenis_tahapan a, tahapan_pme b, proyek_pme c where id_jenis_tahapan=? and a.id_tahapan = b.id_tahapan and c.id_proyek_pme = b.id_project_pme";
			conn =DBConnection.getConnection();
			try{
				ps = conn.prepareStatement(sql);
				ps.setInt(1, kegiatan_pme_id);
				rs = ps.executeQuery();
				
				while(rs.next()){
					ProjectModel project = new ProjectModel();
					project.setProjectID(rs.getInt("id_proyek_pme"));
					project.setProjectName(rs.getString("proyek_name"));
					project.setUserID(rs.getInt("id_user"));
					project.setPjpk(rs.getString("pjpk"));
					project.setNilaiInvestasi(rs.getString("nilai_investasi"));
					project.setArea(rs.getString("area"));
					list.add(project);
				}
				return list;
			}catch(SQLException e){
				e.printStackTrace();
				return null;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		public static List<AdditionalColumnModel> getAdditionalColumn(int proyek_id) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			List<AdditionalColumnModel> list =new ArrayList<AdditionalColumnModel>();
			String sql = "SELECT * FROM additional_column WHERE id_proyek_pme = ?";
			conn =DBConnection.getConnection();
			try{
				ps = conn.prepareStatement(sql);
				ps.setInt(1, proyek_id);
				rs = ps.executeQuery();
				
				while(rs.next()){
					AdditionalColumnModel column = new AdditionalColumnModel();
					column.setId(rs.getInt("id"));
					column.setNamaKolom(rs.getString("nama_kolom"));
					column.setDeskripsi(rs.getString("description"));
					list.add(column);
				}
				return list;
			}catch(SQLException e){
				e.printStackTrace();
				return null;
			}finally{
				if(conn != null)
					conn.close();
				if(rs != null)
					rs.close();
				if(ps != null)
					ps.close();
			}
		}
		
		//tambahan eksport
				public static List<PmeEksportModel> eGetAllProjectPME() throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					List<PmeEksportModel> list = new ArrayList<PmeEksportModel>();
					String sql = "select * from proyek_pme order by created_date desc";
					conn = DBConnection.getConnection();
					try{
						ps = conn.prepareStatement(sql);
						rs = ps.executeQuery();
						
						while(rs.next()){
							//id_proyek_pme, proyek_name, nilai_investasi, pjpk 
							PmeEksportModel project = new PmeEksportModel();
							project.setId_proyek_pme(rs.getInt("id_proyek_pme"));
							project.setProyek_name(rs.getString("proyek_name"));
							project.setNilai_investasi(rs.getString("nilai_investasi"));
							project.setPjpk(rs.getString("pjpk"));
							project.setArea(rs.getString("area"));
							
							list.add(project);
						}	
					
						return list;
						
					}catch(SQLException e){
						e.printStackTrace();
						return null;
					}finally{
						if(conn != null)
							conn.close();
						if(rs != null)
							rs.close();
						if(ps != null)
							ps.close();
					}
				}
				
				public static int eIdTahapanPMEbyIdProject(int id, List<Integer> countTahapanIdProject) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					String sql = "select id_tahapan from tahapan_pme where nama_tahapan = 'Tahapan KPBU' and id_project_pme =?";
					int ret = 0;
					conn = DBConnection.getConnection();
					try{
						ps = conn.prepareStatement(sql);
						ps.setInt(1, id);
						rs = ps.executeQuery();
						while(rs.next()){
							ret = rs.getInt(1);
							countTahapanIdProject.add(rs.getInt(1));
						}	
						
						return ret;
						
					}catch(SQLException e){
						e.printStackTrace();
						return ret;
					}finally{
						if(conn != null)
							conn.close();
						if(rs != null)
							rs.close();
						if(ps != null)
							ps.close();
					}
				}
				
				public static int eIdTahapanPMEbyIdProjectPDF(int id, List<Integer> countTahapanIdProject) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					String sql = "select id_tahapan from tahapan_pme where nama_tahapan = 'PDF' and id_project_pme =?";
					int ret = 0;
					conn = DBConnection.getConnection();
					try{
						ps = conn.prepareStatement(sql);
						ps.setInt(1, id);
						rs = ps.executeQuery();
						while(rs.next()){
							ret = rs.getInt(1);
							countTahapanIdProject.add(rs.getInt(1));
						}	
						
						return ret;
						
					}catch(SQLException e){
						e.printStackTrace();
						return ret;
					}finally{
						if(conn != null)
							conn.close();
						if(rs != null)
							rs.close();
						if(ps != null)
							ps.close();
					}
				}
				
				public static int eIdTahapanPMEbyIdProjectVGF(int id, List<Integer> countTahapanIdProject) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					String sql = "select id_tahapan from tahapan_pme where nama_tahapan = 'VGF' and id_project_pme =?";
					int ret = 0;
					conn = DBConnection.getConnection();
					try{
						ps = conn.prepareStatement(sql);
						ps.setInt(1, id);
						rs = ps.executeQuery();
						while(rs.next()){
							ret = rs.getInt(1);
							countTahapanIdProject.add(rs.getInt(1));
						}	
						
						return ret;
						
					}catch(SQLException e){
						e.printStackTrace();
						return ret;
					}finally{
						if(conn != null)
							conn.close();
						if(rs != null)
							rs.close();
						if(ps != null)
							ps.close();
					}
				}
				
				public static int eIdTahapanPMEbyIdProjectPenjaminanBersama(int id, List<Integer> countTahapanIdProject) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					String sql = "select id_tahapan from tahapan_pme where nama_tahapan = 'Penjaminan' and id_project_pme =?";
					int ret = 0;
					conn = DBConnection.getConnection();
					try{
						ps = conn.prepareStatement(sql);
						ps.setInt(1, id);
						rs = ps.executeQuery();
						while(rs.next()){
							ret = rs.getInt(1);
							countTahapanIdProject.add(rs.getInt(1));
						}	
						
						return ret;
						
					}catch(SQLException e){
						e.printStackTrace();
						return ret;
					}finally{
						if(conn != null)
							conn.close();
						if(rs != null)
							rs.close();
						if(ps != null)
							ps.close();
					}
				}
				
				public static int eIdTahapanPMEbyIdProjectAP(int id, List<Integer> countTahapanIdProject) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					String sql = "select id_tahapan from tahapan_pme where nama_tahapan = 'AP' and id_project_pme =?";
					int ret = 0;
					conn = DBConnection.getConnection();
					try{
						ps = conn.prepareStatement(sql);
						ps.setInt(1, id);
						rs = ps.executeQuery();
						while(rs.next()){
							ret = rs.getInt(1);
							countTahapanIdProject.add(rs.getInt(1));
						}	
						
						return ret;
						
					}catch(SQLException e){
						e.printStackTrace();
						return ret;
					}finally{
						if(conn != null)
							conn.close();
						if(rs != null)
							rs.close();
						if(ps != null)
							ps.close();
					}
				}
				
				public static String eGetTahapanPMEbyIdTahapan(int id, List<Integer> id_jenis_tahapan) 
						throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					
					String sql = "select * from jenis_tahapan where id_tahapan =? and disable='enabled'";
					String ret = null;
					String tahapan = "";
					conn = DBConnection.getConnection();
					try{
						id_jenis_tahapan.clear();
						ps = conn.prepareStatement(sql);
						ps.setInt(1, id);
						rs = ps.executeQuery();
						while(rs.next()){
							tahapan = rs.getString("nama_jenis");
						}	
					
						ret = tahapan;
						
						return ret;
					}catch(SQLException e){
						e.printStackTrace();
						return null;
					}finally{
						if(conn != null)
							conn.close();
						if(rs != null)
							rs.close();
						if(ps != null)
							ps.close();
					}
				}
				
				public static String eGetTahapanPMEbyIdTahapanAll(int id, List<Integer> id_jenis_tahapan) 
						throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					
					String sql = "select * from jenis_tahapan where id_tahapan =?";
					String ret = null;
					String tahapan = "";
					conn = DBConnection.getConnection();
					try{
						id_jenis_tahapan.clear();
						ps = conn.prepareStatement(sql);
						ps.setInt(1, id);
						rs = ps.executeQuery();
						while(rs.next()){
							id_jenis_tahapan.add(rs.getInt("id_jenis_tahapan"));
							tahapan = tahapan + ", " + rs.getString("nama_jenis");
						}	
						if(tahapan.startsWith(","))
							tahapan = tahapan.substring(1).trim();
					
						ret = tahapan;
						
						return ret;
					}catch(SQLException e){
						e.printStackTrace();
						return null;
					}finally{
						if(conn != null)
							conn.close();
						if(rs != null)
							rs.close();
						if(ps != null)
							ps.close();
					}
				}
				
				public static String eGetPersen(int id) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					
					String sql = "select 100/COUNT(status) * "
							+ "(select COUNT(status) from kegiatan_pme where status = 1 AND id_jenis_tahapan = ?) as persentase "
							+ "from kegiatan_pme WHERE id_jenis_tahapan = ?";
					String ret = null;
					String persen = "";
					conn = DBConnection.getConnection();
					try{
						ps = conn.prepareStatement(sql);
						ps.setInt(1, id);
						ps.setInt(2, id);
						rs = ps.executeQuery();
						while(rs.next()){
							persen =  rs.getString("persentase");
						}	
						
						ret = persen;
						
						return ret;
					}catch(SQLException e){
						e.printStackTrace();
						return null;
					}finally{
						if(conn != null)
							conn.close();
						if(rs != null)
							rs.close();
						if(ps != null)
							ps.close();
					}
					
				}
				
				public static void eIdTahapanPMEbyIdProjectAll(int id, List<Integer> countTahapanIdProject) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					String sql = "select id_tahapan from tahapan_pme where id_project_pme =?";
					//int ret = 0;
					conn = DBConnection.getConnection();
					try{
						countTahapanIdProject.clear();
						ps = conn.prepareStatement(sql);
						ps.setInt(1, id);
						rs = ps.executeQuery();
						while(rs.next()){
							//ret = rs.getInt(1);
							countTahapanIdProject.add(rs.getInt(1));
						}	
						
						//return ret;
						
					}catch(SQLException e){
						e.printStackTrace();
						//return ret;
					}finally{
						if(conn != null)
							conn.close();
						if(rs != null)
							rs.close();
						if(ps != null)
							ps.close();
					}
				}
				
				//
				//tambahan novri
				
				public static int editKolomBaru(String nama, String deskripsi, int id_kolom) 
						throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					String sql = "UPDATE additional_column SET nama_kolom = ?, description = ? WHERE id = ?";
					conn = DBConnection.getConnection();
					int ret = 0;
					try{
						ps = conn.prepareStatement(sql);
						ps.setString(1, nama);
						ps.setString(2, deskripsi);
						ps.setInt(3, id_kolom);
						ret = ps.executeUpdate();		
						
					}catch(SQLException e){
						e.printStackTrace();
					}finally{
						if(conn != null)
							conn.close();
						if(ps != null)
							ps.close();
					}
					return ret;
				}
				
				//tambahan dashboard
				public static void eTahapanPMEbyIdProject(int id, List<Integer> idTahapan, List<String> namaTahapan, String filter)
						throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					
					//String sql = "SELECT * FROM tahapan_pme where id_project_pme=? and nama_tahapan!='Tahapan KPBU'";
					String sql = "SELECT * FROM tahapan_pme "
							+ "where id_project_pme=? and "
							+ "nama_tahapan='Tahapan KPBU'";
					//int ret = 0;
					conn = DBConnection.getConnection();
					try{
						idTahapan.clear();
						namaTahapan.clear();
						ps = conn.prepareStatement(sql);
						ps.setInt(1, id);
						rs = ps.executeQuery();
						while(rs.next()){
							//ret = rs.getInt(1);
							idTahapan.add(rs.getInt("id_tahapan"));
							namaTahapan.add(rs.getString("nama_tahapan"));
						}	
						
						//return ret;
						
					}catch(SQLException e){
						e.printStackTrace();
						//return ret;
					}finally{
						if(conn != null)
							conn.close();
						if(rs != null)
							rs.close();
						if(ps != null)
							ps.close();
					}
				}
				
				public static String eFasilitasbyIdProject(int id, String filter)
						throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					
					String ret = "";
					String sql = "SELECT * FROM tahapan_pme where id_project_pme=?"
							+ " and nama_tahapan!='Tahapan KPBU'"
							+ " and is_active=1 "
							+ "and nama_tahapan like concat ('%',ifnull(?,nama_tahapan),'%')";
					conn = DBConnection.getConnection();
					try{
						ps = conn.prepareStatement(sql);
						ps.setInt(1, id);
						ps.setString(2, filter);
						rs = ps.executeQuery();
						
						while(rs.next()){
							ret = ret + ", " + rs.getString("nama_tahapan");
						}	
						if(ret.startsWith(","))
							ret = ret.substring(1).trim();
					
						
						return ret;
						
					}catch(SQLException e){
						e.printStackTrace();
						//return ret;
					}finally{
						if(conn != null)
							conn.close();
						if(rs != null)
							rs.close();
						if(ps != null)
							ps.close();
					}
					return ret;
				}
				
				public static void eFasilitasbyIdProjectArray(int id, List<String> namaTahapan)
						throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					
					String sql = "SELECT * FROM tahapan_pme where id_project_pme=?"
							+ " and nama_tahapan!='Tahapan KPBU'"
							+ " and is_active=1 ";
					conn = DBConnection.getConnection();
					try{
						namaTahapan.clear();
						ps = conn.prepareStatement(sql);
						ps.setInt(1, id);
						rs = ps.executeQuery();
						
						while(rs.next()){
							namaTahapan.add(rs.getString("nama_tahapan"));
						}	
						
					}catch(SQLException e){
						e.printStackTrace();
						//return ret;
					}finally{
						if(conn != null)
							conn.close();
						if(rs != null)
							rs.close();
						if(ps != null)
							ps.close();
					}
					
				}
				
				public static String eGetTahapanBerlangsungbyIdTahapan(int id) 
			            throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
			          
			          String sql_cekJum = "select count(*) from jenis_tahapan where id_tahapan =?";
			          
			          String sql = "select * from jenis_tahapan where id_tahapan =? and disable='enabled'";
			          String ret = null;
			          String tahapan = "";
			          conn = DBConnection.getConnection();
			          int rowTotal = 0;
			          int rowTotBerlangsung = 0 ; 
			          
			          PreparedStatement ps2 = null;
			          ResultSet rs2 = null;
			          
			          try{
			            ps = conn.prepareStatement(sql);
			            ps.setInt(1, id);
			            rs = ps.executeQuery();
			            while(rs.next()){
			              tahapan = rs.getString("nama_jenis");
			              rowTotBerlangsung = rowTotBerlangsung + 1;
			            }
			            
			            
			            ps2 = conn.prepareStatement(sql_cekJum);
			            ps2.setInt(1, id);
			            rs2 = ps2.executeQuery();
			            while(rs2.next()){
			              rowTotal = rs2.getInt(1);
			            }
			            
			            if(rowTotBerlangsung == 0 ){
			              tahapan = "N/A";
			            
			            }else if(rowTotBerlangsung == rowTotal){
			              tahapan = "Selesai"; 
			            }

			            ret = tahapan;
			            
			            return ret;
			          }catch(SQLException e){
			            e.printStackTrace();
			            return null;
			          }finally{
			            if(conn != null)
			              conn.close();
			            if(rs != null)
			              rs.close();
			            if(ps != null)
			              ps.close();
			            if(rs2 != null)
			              rs2.close();
			            if(ps2 != null)
			              ps2.close();
			          }
			        }
				
				//Tambahan Andri
				public static List<ProjectModel> searchProjectPME(String search)throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException {
					
					List<ProjectModel> list = new ArrayList<ProjectModel>();
					String sql = "select pm.*, ma.title, s.nama_sektor from proyek_pme pm join map_area ma on pm.id_map=ma.id join sektor s on pm.id_sektor=s.id_sektor "
							+ "where proyek_name like '%"+search+"%' or area like '%"+search+"%' or pjpk like '%"+search+"%' or nilai_investasi like '%"+search+"%' or title like '%"+search+"%' or nama_sektor like '%"+search+"%'"
							+ "order by created_date desc";
					log.info("sql "+sql);
					conn = DBConnection.getConnection();
					try{
						ps = conn.prepareStatement(sql);
						rs = ps.executeQuery();
						
						
						int flag = 0;
						while(rs.next()){
							flag = 1;
//							list.clear();
							ProjectModel project = new ProjectModel();
							project.setProjectID(rs.getInt("id_proyek_pme"));
							project.setProjectName(rs.getString("proyek_name"));
							project.setArea(rs.getString("area"));
							//project.setProgress(rs.getString("proyek_progress"));
							project.setSector(rs.getString("nama_sektor"));
							project.setSectorID(rs.getInt("id_sektor"));
							//project.setAreaID(rs.getInt("area"));
							//project.setValueTahunFrom(rs.getString("tanggal"));
							
							list.add(project);
						}
						
						
						if(flag==0){
							ProjectModel project = new ProjectModel();
							//set value field search
							project.setNoDataQuery("noDataFromQuery");
							list.add(project);
						}
						
						
						return list;
						
						}catch(SQLException e){
							e.printStackTrace();
							return null;
						}finally{
							if(conn != null)
								conn.close();
							if(rs != null)
								rs.close();
							if(ps != null)
								ps.close();
						}
					}
				
				//Tambahan Ardy disable enable tahapan
				public static int disableEnableTahapan(int id_tahapan, String nama_tahapan, int disabletahapn) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					log.info("disable "+disabletahapn);
					String sql = "update tahapan_pme set is_active='"+disabletahapn+"' where id_tahapan="+id_tahapan+" and nama_tahapan='"+nama_tahapan+"'";
					try{
						conn = DBConnection.getConnection();
						ps = conn.prepareStatement(sql);
						return ps.executeUpdate();					
						
					}catch(SQLException e){
						e.printStackTrace();
						return 0;
					}finally{
						if(conn != null)
							conn.close();
						if(rs != null)
							rs.close();
						if(ps != null)
							ps.close();
					}
				}
//				editeProyekPME
				
				public static int editeProyekPME(String proyek_name, int id_proyek) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
//					log.info("disable "+disabletahapn);
					String sql = "update proyek_pme set proyek_name='"+proyek_name+"' where id_proyek_pme="+id_proyek+"";
					try{
						conn = DBConnection.getConnection();
						ps = conn.prepareStatement(sql);
						return ps.executeUpdate();					
						
					}catch(SQLException e){
						e.printStackTrace();
						return 0;
					}finally{
						if(conn != null)
							conn.close();
						if(rs != null)
							rs.close();
						if(ps != null)
							ps.close();
					}
				}
				
				public static int cek_ProjectPME(String proyek_name) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					String sql = "SELECT * FROM proyek_pme WHERE proyek_name = ?";
					conn = DBConnection.getConnection();
					int ret = 0;
					try{
						ps = conn.prepareStatement(sql);
						ps.setString(1, proyek_name);
						rs = ps.executeQuery();
						while(rs.next()){
							ret = 1;
						}
						
					}catch(SQLException e){
						e.printStackTrace();
					}finally{
						if(conn != null)
							conn.close();
						if(ps != null)
							ps.close();
					}
					return ret;
				}
				
				public static int cek_ProjectDMS(String proyek_name) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					String sql = "SELECT * FROM proyek_dms WHERE proyek_name = ?";
					conn = DBConnection.getConnection();
					int ret = 0;
					try{
						ps = conn.prepareStatement(sql);
						ps.setString(1, proyek_name);
						rs = ps.executeQuery();
						while(rs.next()){
							ret = 1;
						}
						
					}catch(SQLException e){
						e.printStackTrace();
					}finally{
						if(conn != null)
							conn.close();
						if(ps != null)
							ps.close();
					}
					return ret;
				}
				
				public static List<ProjectModel> searchProgress(String search, String fasilitas) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					List<ProjectModel> list = new ArrayList<ProjectModel>();
					String sql = "select distinct * from v_datatable "
				              + "where "
				              + "(proyek_name like '%"+search+"%' "
				              + "or area like'%"+search+"%' "
				              + "or pjpk like'%"+search+"%' "
				              + "or nilai_investasi like'%"+search+"%' "
				              + "or sub_name like'%"+search+"%' "
				              + "or fasilitas like'%"+search+"%') "
				              + "and (fasilitas like '%"+fasilitas+"%')";
					conn = DBConnection.getConnection();
					try{
						ps = conn.prepareStatement(sql);
						rs = ps.executeQuery();
						
						while(rs.next()){
							ProjectModel project = new ProjectModel();
							project.setProgress(rs.getString("persentase"));
							project.setProjectName(rs.getString("proyek_name"));
							project.setProjectID(rs.getInt("id_proyek_pme"));
							list.add(project);       
						}
						return list;
						
					}catch(SQLException e){
						e.printStackTrace();
						return null;
					}finally{
						if(conn != null)
							conn.close();
						if(rs != null)
							rs.close();
						if(ps != null)
							ps.close();
					}
				}
				
				public static List<ProjectModel> searchProgress(String search) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					List<ProjectModel> list = new ArrayList<ProjectModel>();
					String sql = "select pp.*, "
							+ "coalesce(100/COUNT(kp.status),0) in (select coalesce(COUNT(kp.status),0) "
							+ "from proyek_pme pp left join tahapan_pme tp on pp.id_proyek_pme=tp.id_project_pme "
							+ "left join jenis_tahapan jp on tp.id_tahapan=jp.id_tahapan "
							+ "left join kegiatan_pme kp on jp.id_jenis_tahapan=kp.id_jenis_tahapan "
							+ "where (kp.status = 1 OR kp.status = 2) and pp.proyek_name like '%"+search+"%' or pp.area like '%"+search+"%' or pp.pjpk like '%"+search+"%' or pp.nilai_investasi like '%"+search+"%'"
							+ "group by pp.id_proyek_pme) as persentase "
							+ "from proyek_pme pp left join tahapan_pme tp on pp.id_proyek_pme=tp.id_project_pme "
							+ "left join jenis_tahapan jp on tp.id_tahapan=jp.id_tahapan "
							+ "left join kegiatan_pme kp on jp.id_jenis_tahapan=kp.id_jenis_tahapan "
							+ "where pp.proyek_name like '%"+search+"%' or pp.area like '%"+search+"%' or pp.pjpk like '%"+search+"%' or pp.nilai_investasi like '%"+search+"%'"
							+ "group by pp.id_proyek_pme";
					conn = DBConnection.getConnection();
					try{
						ps = conn.prepareStatement(sql);
						rs = ps.executeQuery();
						
						while(rs.next()){
							ProjectModel project = new ProjectModel();
							project.setProgress(rs.getString("persentase"));
							project.setProjectName(rs.getString("proyek_name"));
							project.setProjectID(rs.getInt("id_proyek_pme"));
							list.add(project);       
						}
						return list;
						
					}catch(SQLException e){
						e.printStackTrace();
						return null;
					}finally{
						if(conn != null)
							conn.close();
						if(rs != null)
							rs.close();
						if(ps != null)
							ps.close();
					}
				}
				public static List<MapModel> getAllMap() throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
				    List<MapModel> list = new ArrayList<MapModel>();
				    String sql = "select * from map_area";
				    conn = DBConnection.getConnection();
				    try{
				      ps = conn.prepareStatement(sql);
				      rs = ps.executeQuery();
				      
				      while(rs.next()){
				        MapModel map = new MapModel();
				        map.setId(rs.getString("id"));
				        map.setTitle(rs.getString("title"));
				        list.add(map);
				      }
				      return list;
				    }catch(SQLException e){
				      e.printStackTrace();
				      return null;
				    }finally{
				      if(conn != null)
				        conn.close();
				      if(rs != null)
				        rs.close();
				      if(ps != null)
				        ps.close();
				    }
				  }
				
				public static int checkFilePME(String id_file, String id_kegiatan) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					String sql = "";
					if(id_file == ""){
						sql = "select COUNT(*) as total from file_pme where id_kegiatan ="+id_kegiatan;
					}else{
						sql = "select COUNT(id_file) as total from file_pme where id_file = ? AND id_kegiatan = ?";
					}
					
					conn = DBConnection.getConnection();
					int has_file = 0;
					try{
						ps = conn.prepareStatement(sql);
						if(id_file != ""){
							ps.setInt(1, Integer.parseInt(id_file));
							ps.setInt(2, Integer.parseInt(id_kegiatan));
						}
						rs = ps.executeQuery();
						
						while(rs.next()){
							has_file = rs.getInt("total");
						}
						return has_file;
					}catch(SQLException e){
						e.printStackTrace();
						return 0;
					}finally{
						if(conn != null)
							conn.close();
						if(rs != null)
							rs.close();
						if(ps != null)
							ps.close();
					}
				}
				
				public static int checkUserEmail(String email) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					String sql = "SELECT * FROM users WHERE email = ?";
					conn = DBConnection.getConnection();
					int ret = 0;
					try{
						ps = conn.prepareStatement(sql);
						ps.setString(1, email);
						rs = ps.executeQuery();
						while(rs.next()){
							ret = 1;
						}
						
					}catch(SQLException e){
						e.printStackTrace();
					}finally{
						if(conn != null)
							conn.close();
						if(ps != null)
							ps.close();
					}
					return ret;
				}
				
				public static int checkSektor(String name) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					String sql = "SELECT * FROM sektor WHERE nama_sektor = ?";
					conn = DBConnection.getConnection();
					int ret = 0;
					try{
						ps = conn.prepareStatement(sql);
						ps.setString(1, name);
						rs = ps.executeQuery();
						while(rs.next()){
							ret = 1;
						}
						
					}catch(SQLException e){
						e.printStackTrace();
					}finally{
						if(conn != null)
							conn.close();
						if(ps != null)
							ps.close();
					}
					return ret;
				}
				
				public static int checkJD(String name) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					String sql = "SELECT * FROM jenis_dokumen WHERE nama_jenis_dokumen = ?";
					conn = DBConnection.getConnection();
					int ret = 0;
					try{
						ps = conn.prepareStatement(sql);
						ps.setString(1, name);
						rs = ps.executeQuery();
						while(rs.next()){
							ret = 1;
						}
						
					}catch(SQLException e){
						e.printStackTrace();
					}finally{
						if(conn != null)
							conn.close();
						if(ps != null)
							ps.close();
					}
					return ret;
				}
				
				public static int checkNewColumn(String name, int id_proyek) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					String sql = "SELECT * FROM additional_column WHERE nama_kolom = '"+name+"' AND id_proyek_pme = '"+id_proyek+"'";
					conn = DBConnection.getConnection();
					int ret = 0;
					try{
						ps = conn.prepareStatement(sql);
						rs = ps.executeQuery();
						while(rs.next()){
							ret = 1;
						}
						
					}catch(SQLException e){
						e.printStackTrace();
					}finally{
						if(conn != null)
							conn.close();
						if(ps != null)
							ps.close();
					}
					return ret;
				}
				
				public static int checkJT(String name, int id_tahapan) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					String sql = "SELECT * FROM jenis_tahapan WHERE nama_jenis = '"+name+"' AND id_tahapan = '"+id_tahapan+"'";
					conn = DBConnection.getConnection();
					int ret = 0;
					try{
						ps = conn.prepareStatement(sql);
						rs = ps.executeQuery();
						while(rs.next()){
							ret = 1;
						}
						
					}catch(SQLException e){
						e.printStackTrace();
					}finally{
						if(conn != null)
							conn.close();
						if(ps != null)
							ps.close();
					}
					return ret;
				}
				
				public static int checkKegiatan(String name, int id_jenis_tahapan) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					String sql = "SELECT * FROM kegiatan_pme WHERE nama_kegiatan = '"+name+"' AND id_jenis_tahapan = '"+id_jenis_tahapan+"'";
					conn = DBConnection.getConnection();
					int ret = 0;
					try{
						ps = conn.prepareStatement(sql);
						rs = ps.executeQuery();
						while(rs.next()){
							ret = 1;
						}
						
					}catch(SQLException e){
						e.printStackTrace();
					}finally{
						if(conn != null)
							conn.close();
						if(ps != null)
							ps.close();
					}
					return ret;
				}
				
				public static int checkHapusSektor(String id_sektor) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					String sql = "SELECT SUM(t.id_sektor) AS total "
							+ "FROM (SELECT COUNT(d.id_sektor) AS id_sektor FROM proyek_dms d WHERE d.id_sektor = ? "
							+ "UNION ALL SELECT COUNT(p.id_sektor) AS id_sektor FROM proyek_pme p WHERE p.id_sektor = ?) t";
					
					conn = DBConnection.getConnection();
					int total = 0;
					try{
						ps = conn.prepareStatement(sql);
						ps.setInt(1, Integer.parseInt(id_sektor));
						ps.setInt(2, Integer.parseInt(id_sektor));
						rs = ps.executeQuery();
						
						while(rs.next()){
							total = rs.getInt("total");
						}
						return total;
					}catch(SQLException e){
						e.printStackTrace();
						return 0;
					}finally{
						if(conn != null)
							conn.close();
						if(rs != null)
							rs.close();
						if(ps != null)
							ps.close();
					}
				}
				
				public static int checkHapusJD(String id_jd) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					String sql = "SELECT COUNT(id_jenis_dokumen) AS total FROM file_dms WHERE id_jenis_dokumen = ?";
					
					conn = DBConnection.getConnection();
					int total = 0;
					try{
						ps = conn.prepareStatement(sql);
						ps.setInt(1, Integer.parseInt(id_jd));
						rs = ps.executeQuery();
						
						while(rs.next()){
							total = rs.getInt("total");
						}
						return total;
					}catch(SQLException e){
						e.printStackTrace();
						return 0;
					}finally{
						if(conn != null)
							conn.close();
						if(rs != null)
							rs.close();
						if(ps != null)
							ps.close();
					}
				}
				
				public static String getColumnName(int id_kolom) throws ClassNotFoundException, SQLException, IOException, org.json.simple.parser.ParseException{
					String sql = "SELECT nama_kolom FROM additional_column WHERE id = '"+id_kolom+"'";
					conn = DBConnection.getConnection();
					String nama = "";
					try{
						ps = conn.prepareStatement(sql);
						rs = ps.executeQuery();
						while(rs.next()){
							nama = rs.getString("nama_kolom");
						}
						
					}catch(SQLException e){
						e.printStackTrace();
						return "";
					}finally{
						if(conn != null)
							conn.close();
						if(ps != null)
							ps.close();
					}
					return nama;
				}

}
package co.id.spring.util;


import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Logger;
import java.net.URL;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;


public class DBConnection {	
	static Logger log = Logger.getLogger(DBConnection.class.getName());
	static String driverName = "com.mysql.jdbc.Driver";
	static String dbUrl = "";
	static String dbUser = "";
	static String dbPass = "";
	static URL FILENAME =null;
	static String sCurrentLine;
	
	public static Connection getConnection() throws ClassNotFoundException, IOException, ParseException{
		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObject = null;
		StringBuffer sb = new StringBuffer();
		Connection conn = null;
		FILENAME = DBConnection.class.getResource("/");
//		log.info("file "+FILENAME);
		String pattt =FILENAME.toString().replace("file:", "");
//		log.info("pattt "+pattt);
		String path_dasar = pattt.replace("dms/WEB-INF/classes/", "")+"DBConnection.txt";
		path_dasar = path_dasar.replace("/", "/");
		path_dasar = path_dasar.replace("%20", " ");
//		log.info("path_dasar "+path_dasar);
		try{
			BufferedReader reader = new BufferedReader(new FileReader(path_dasar));
			while ((sCurrentLine = reader.readLine()) != null) {
//				System.out.println(sCurrentLine);
				sb.append(sCurrentLine);
				
			}
			jsonObject = (JSONObject) jsonParser.parse(sb.toString());
			dbUrl = (String) jsonObject.get("dbUrl");
			dbUser = (String) jsonObject.get("dbUser");
			dbPass = (String) jsonObject.get("dbPass");

			Class.forName(driverName);
			conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
		}catch(SQLException ex){
			log.info("Could not connect to DB"+ex.getMessage());
	         ex.printStackTrace();
		}catch (ParseException es) {
			// TODO: handle exception
			log.info("sc "+es.getMessage());
		}catch(Exception exc){
			log.info("escdd "+exc);
		}
		return conn;
	}
	
	
}

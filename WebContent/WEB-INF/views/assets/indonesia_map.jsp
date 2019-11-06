<%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<%@page import= "org.json.simple.JSONObject" %>
<%@page import = "org.json.simple.parser.JSONParser" %>
<%@page import = "org.json.simple.parser.ParseException" %>
<%@page  import = "java.net.URL" %>
<%@page import = "java.util.logging.Logger" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix = "sql"%>
<%@page contentType="image/svg+xml" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN"
  "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">

<style>
	#indo-map{
	  display: block;
	  position: absolute;
	  margin-top: 10px;
	  margin-left: 20px;
	  width: 100%;
	  height: 100%;
	  zoom : 128%;
	}
	path:hover, circle:hover {
	  stroke: #002868 !important;
	  stroke-width:2px;
	  stroke-linejoin: round;
	  fill: #002868 !important;
	  cursor: pointer;
	}
	
	#info-box {
	  display: none;
	  position: fixed;
	  left: 0px;
	  padding : 5px;
	  z-index: 1;
	  background-color: #ffffff;
	  border: 2px solid #BF0A30;
	  border-radius: 10px;
	  font-family: arial;
	}
	.land
	{
		fill:#1abb9c;
		fill-opacity: 1;
		stroke:white;
		stroke-opacity: 1;
		stroke-width:0.5;
	}

	.land-empty
	{
		fill-opacity: 1;
		stroke:white;
		stroke-opacity: 1;
		stroke-width:0.5;
	}
	a:hover { 
    	color: #1abb9c;
	}

</style>

<% Logger logger = Logger.getLogger(this.getClass().getName());%>
		<%
				String sCurrentLine;
				JSONParser jsonParser = new JSONParser();
				JSONObject jsonObject = null;
				StringBuffer sb = new StringBuffer();
				String FILENAME = request.getRealPath("/");
				String pattt =FILENAME.toString().replace("file:/", "");
				//String path_dasar = pattt.replace("dms/", "")+"DBConnection.txt"; //linux
				String path_dasar = pattt.replace("dms\\", "")+"DBConnection.txt"; //windows
				path_dasar = path_dasar.replace("%20", " ");
				logger.info(""+FILENAME);
				logger.info("pattt "+pattt);
				logger.info(""+path_dasar);
				BufferedReader reader = new BufferedReader(new FileReader(path_dasar));
				while ((sCurrentLine = reader.readLine()) != null) {
//					System.out.println(sCurrentLine);
					sb.append(sCurrentLine);
					
				}
				jsonObject = (JSONObject) jsonParser.parse(sb.toString());
				String dbUrl = (String) jsonObject.get("dbUrl");
				String dbUser = (String) jsonObject.get("dbUser");
				String dbPass = (String) jsonObject.get("dbPass");
				request.setAttribute("dbUrl", dbUrl);
				request.setAttribute("dbUser", dbUser);
				request.setAttribute("dbPass", dbPass);
	%>

				<c:set var = "urllogin1" value ="${dbUrl}"/>
      			<c:set var = "user1"  value ="${dbUser}"/>
      			<c:set var = "psswd1"  value ="${dbPass}"/>
      			<sql:setDataSource var="dbPME" 
      				 driver="com.mysql.jdbc.Driver"
				     url="${urllogin1}"
				     user="${user1}"  
				     password="${psswd1}"
				/>
      			
<div id="info-box"></div>
<?xml version="1.0" encoding="utf-8"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:amcharts="http://amcharts.com/ammap" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" id="indo-map" width="1500px" height="700px">
<sodipodi:namedview bordercolor="#666666" objecttolerance="10" pagecolor="#ffffff" borderopacity="1" gridtolerance="10" guidetolerance="10" inkscape:cx="509.19152" inkscape:cy="282.2353" inkscape:zoom="1.2137643" showgrid="false" id="namedview71" inkscape:current-layer="g5" inkscape:window-maximized="1" inkscape:window-y="-8" inkscape:window-x="-8" inkscape:pageopacity="0" inkscape:window-height="1017" inkscape:window-width="1920" inkscape:pageshadow="2">
	</sodipodi:namedview>

<g id="g5">
	<sql:query var="map" dataSource="${dbPME}">
		select * from map_area
	</sql:query>
	<c:forEach var="row" items="${map.rows}">
	
	<sql:query var="project" dataSource="${dbPME}">
		select * from proyek_pme where id_map = ?
		<sql:param value="${row.id}"></sql:param>
	</sql:query>
	
	
	<sql:query var="total" dataSource="${dbPME}">
		select count(*) as total from proyek_pme where id_map = ?
		<sql:param value="${row.id}"></sql:param>
	</sql:query>
		<path id=<c:out value="${row.id}"/> 
			  title=<c:out 
			  value="${row.title}"/> 
			  d="<c:out value="${row.coord}"/>"  
			  data-info="<div><h4><b>Provinsi : ${row.title} </b>&nbsp;
			  			<button type='button' title='close' onclick='closeInfo();' class='close' aria-label='Close'>&times;</button></h3></div>
			  			<c:forEach var="total" items="${total.rows}">
			  				<div><b>Total Proyek :<c:out value="${total.total}"/></b></div>
			  			</c:forEach>
			  			<c:forEach var="data" items="${project.rows}">
			  				<sql:query dataSource="${dbPME}" var="result">
								select * from tahapan_pme where id_project_pme = ? and nama_tahapan=?
								<sql:param value="${data.id_proyek_pme}" />
								<sql:param value="Tahapan KPBU" />
							</sql:query>
			  				<c:set var="totalPercentageProject" value="${0}"/>
							<c:forEach var="row" items="${result.rows}">
														
															<sql:query dataSource="${dbPME}" var="resultJT">
																select * from jenis_tahapan where id_tahapan = ?
																<sql:param value="${row.id_tahapan}" />
															</sql:query>
															
															<c:set var="totalJenisTahapan" value="${resultJT.rowCount}"/>
															<c:set var="totalPercentage" value="${0}"/>
					
															<c:choose>
																<c:when test="${totalJenisTahapan > 0}">												
																	<c:forEach var="rowKegiatan" items="${resultJT.rows}">											
																		<sql:query dataSource="${dbPME}" var="resultPercentageTahapan">
																			select ((select 100*count(status) from kegiatan_pme where  status = '1'  AND id_jenis_tahapan = ?)+(select 50*count(status) from kegiatan_pme where status = '2'  AND id_jenis_tahapan = ?))/count(status) as persentase from kegiatan_pme WHERE id_jenis_tahapan = ?
																			<sql:param value="${rowKegiatan.id_jenis_tahapan}" />
																			<sql:param value="${rowKegiatan.id_jenis_tahapan}" />
																			<sql:param value="${rowKegiatan.id_jenis_tahapan}" />
																		</sql:query>
																		
																		<c:forEach  var="row3" items="${resultPercentageTahapan.rows}">
																			<c:set var="totalPercentage" value="${totalPercentage + row3.persentase}"/>
																		</c:forEach>
																	</c:forEach>		
																	
																	<c:set value="${totalPercentage/totalJenisTahapan}"  var="hasil"/>									
																</c:when>
																<c:otherwise>
																	<c:set value="${0}"  var="hasil"/>
																</c:otherwise>
															</c:choose>
															<c:set var="totalPercentageProject" value="${totalPercentageProject + hasil}"/>	
														</c:forEach>
			  				<fmt:formatNumber var="percent_proyek" type = "percent" pattern = "#0.##" value="${totalPercentage/totalJenisTahapan}"/>
			  				<div><b>-&nbsp;<a title='detail' href='<%=request.getContextPath()%>/PME/ViewProjectPME_dashboard?id=${data.id_proyek_pme}' ><c:out value="${data.proyek_name}"/></a> <c:out value="${percent_proyek} %"/></b></div>
			  			</c:forEach>" 
			  			<c:forEach var="fill" items="${project.rows}">
				  			<c:choose><c:when test="${fill.rowCount == 0}">class="land-empty"</c:when>
	        					<c:otherwise>class="land"</c:otherwise>
	        				</c:choose>
        				</c:forEach>
        	fill="#D3D3D3"
        	fill-opacity="1"
        	stroke="white"
			stroke-opacity="1"
			stroke-width="0.5"
			onclick="showInfo();"
			    />
	</c:forEach>
</g>

</svg>

<script>
	
	function closeInfo(){
		$('#info-box').css('display','none');
	}
</script>
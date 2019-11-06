<%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<%@page import= "org.json.simple.JSONObject" %>
<%@page import = "org.json.simple.parser.JSONParser" %>
<%@page import = "org.json.simple.parser.ParseException" %>
<%@page  import = "java.net.URL" %>
<%@page import = "java.util.logging.Logger" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix = "sql"%>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>    						
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

<style>
		#easyPaginate {width:100px;margin:0;white-space: nowrap;}
		.easyPaginateNav a.current {font-weight:bold;text-decoration:underline;}
		.easyPaginateNav{padding-top:0px; margin-right:20px; width: 1000px;}
		.dataTables_filter { visibility: hidden;}
</style>
	
<c:set var="urllogin1" value="${dbUrl}" />
<c:set var="user1" value="${dbUser}" />
<c:set var="psswd1" value="${dbPass}" />
<sql:setDataSource var="dbPME" 
      				driver="com.mysql.jdbc.Driver"
				    url="${urllogin1}"
				    user="${user1}"  
				    password="${psswd1}"/>

<div id="paging" class="paging">
<input type="hidden" value="${msg.show}" id="show">
	<c:forEach begin="1" end="${msg.progress.size()}" varStatus="loop">
															
														<sql:query dataSource="${dbPME}" var="result">
																select * from tahapan_pme where id_project_pme = ? and nama_tahapan=?
																<sql:param value="${msg.progress.get(loop.index-1).getProjectID()}" />
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
															
															<c:set var = "percentage" value = "${msg.progress.get(loop.index-1).getProgress()}"/>
															<grid>
															<div class="grid-col col-sm-2">
											                     <div class="row">
												                     <a href="<%=request.getContextPath()%>/PME/ViewProjectPME_dashboard?id=${msg.progress.get(loop.index-1).getProjectID()}">
												                     <div class="c100 p<fmt:formatNumber type = "percent" pattern = "#0" value="${totalPercentage/totalJenisTahapan}"/>" style="margin-left:40px">
												                             <span><fmt:formatNumber type = "percent" pattern = "#0.##" value="${totalPercentage/totalJenisTahapan}"/>%</span>
													                     <div class="slice">
													                     	<div class="bar"></div>
													                        <div class="fill"></div>
													                     </div>
												                     </div>
											                     	</a>
											                     </div>
											                     <div class="row">
											                     	<b><p style="text-align: center;">${msg.progress.get(loop.index-1).getProjectName()}</p></b>
											                  	</div>
											                  </div>
															</grid>
														</c:forEach>
</div>

<script>
$(document).ready(function(){
	//alert($("#show").val());
	if($("#show").val() == 'Lihat Semua'){ 
		$("div#paging").removeClass("paging");
	}
});

$('.paging').easyPaginate({
    paginateElement: 'grid',
    elementsPerPage: 15,
    numeric: false,
    firstButton : false,
    lastButton : false,
    prevButtonText : 'Previous',
    nextButtonText : 'Next' 
});
</script>
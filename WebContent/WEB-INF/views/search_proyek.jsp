 <%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="org.json.simple.parser.ParseException"%>
<%@page import="java.net.URL"%>
<%@page import="java.util.logging.Logger"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix = "sql"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">    						
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
	.easyPaginateNav{padding-top:20px; margin-right:15px; width: 1000px;}

</style>

<c:set var="urllogin1" value="${dbUrl}" />
				<c:set var="user1" value="${dbUser}" />
				<c:set var="psswd1" value="${dbPass}" />
				<sql:setDataSource var="dbPME" driver="com.mysql.jdbc.Driver"
					url="${urllogin1}" user="${user1}" password="${psswd1}" />

<c:set var="currentPage" value="${header.referer}"/>
<c:set var="splitURI" value="${fn:split(currentPage, '/')}"/> 
<c:set var="lastValue" value="${splitURI[fn:length(splitURI)-1]}"/>

<!-- blok DMS -->
<c:if test="${(lastValue == 'DMS')}">	
										<c:set var = "noDataQuery" scope = "session" value = "${msg.userlist.get(0).getNoDataQuery()}"/>

								<!-- <c:set var = "tahun" scope = "session" value = "${msg.userlist.get(0).getProjectDate()}"/> -->
								<c:set var = "jum" scope = "session" value = "${msg.userlist.size()}"/>
								<c:set var = "itr" scope = "session" value = "${msg.userlist.size()}"/>
								
      							<!-- kondisi agar untuk element tidak ditemukan makan index iterasi 1 di jadi 0 biar tidak err -->
      							<c:if test = "${noDataQuery == 'noDataFromQuery' && jum==1}">
         							<c:set var = "itr" scope = "session" value = "0"/>
      							</c:if>
      							
							<div id="paging">	
								
								<!-- looping content -->
								<c:forEach begin="1" end="${itr}" varStatus="loop">
									<%String title = "User Agent Example";%>
									<grid>
    								<div class="grid-col col-sm-3">
    									<div class="col-container">
    									
    										<div class="col2 col-sm-12" align="center">
												<a data-toggle="tooltip" data-placement="top" title="Daftar File"
													href="<%=request.getContextPath()%>/proyek_folder/proyek/${msg.userlist.get(loop.index-1).getProjectID()}/1/0/0">
													<img style="width:70px; height:70px; margin: auto;" src="<%=request.getContextPath()%>/assets/images/image-proyek.jpg" />
												</a>
												<div class="clearfix"></div>
		
												<h5 style="margin-top:20px"><b>
													<label class="control-label">${msg.userlist.get(loop.index-1).getProjectName()} </label><br>
													<label class="control-label">${msg.userlist.get(loop.index-1).getArea()}</label>
													</b>
												</h5>
													<label id="sektor_view" style="font-size:80%;">${msg.userlist.get(loop.index-1).getSector()}</label>
											</div>
											
											
												<div class="col3 col-sm-2">
												
													<a data-toggle="tooltip" data-placement="top"title="Daftar File"
														href="<%=request.getContextPath()%>/proyek_folder/proyek/${msg.userlist.get(loop.index-1).getProjectID()}/1/0/0"
														class="btn btn-sm btn-success"><i class="fa fa-eye">
														</i>
													</a>
													<br>
													<c:if test="${msg.userlist.get(loop.index-1).getUserID() == user_id || level > 2}">
														<a data-toggle="tooltip" data-placement="top" title="Edit">
															<button type="button" class="btn btn-sm btn-warning"
																onclick="selectedSektor(${msg.userlist.get(loop.index-1).getSectorID()});"
																data-toggle="modal"
																data-target="#edit_${msg.userlist.get(loop.index-1).getProjectID()}">
																<i class="fa fa-pencil"></i>
															</button>
														</a>
														<br>
														<a data-toggle="tooltip" data-placement="top" title="Delete">
															<button type="button" class="btn btn-sm btn-danger"
																data-toggle="modal"
																data-target="#formDeleteProject_${msg.userlist.get(loop.index-1).getProjectID()}">
																<i class="fa fa-trash"></i>
															</button>
														</a>
													</c:if>
		
												</div>
											
										</div>
									</div>
								
								<!-- Form Delete Project -->
								<div class="modal fade" id="formDeleteProject_${msg.userlist.get(loop.index-1).getProjectID()}" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    								<div class="modal-dialog">
        								<div class="modal-content">
            								<div class="modal-header">
                								<button type="button" class="close" data-dismiss="modal">
                       								<span aria-hidden="true">&times;</span>
                       								<span class="sr-only">Close</span>
                								</button>
                								<h4 class="modal-title" id="myModalLabel">DELETE PROJECT</h4>
            								</div>
            								<div class="modal-body">
                								<form role="form" action="<%=request.getContextPath()%>/DMS/DeleteProject?id=${msg.userlist.get(loop.index-1).getProjectID()}" method="post" id="delete_project">
                  									<div class="form-group">
                  										<label class="control-label"><div align="left">Apakah Anda yakin akan menghapus Project "${msg.userlist.get(loop.index-1).getProjectName()}"?</div></label>
                  									</div>
                  									
										            <div class="modal-footer">
										                <button type="button" class="btn btn-default"
										                        data-dismiss="modal">
										                            Close
										                </button>
										                
										                <button type="submit" class="btn btn-danger">Delete</button>
										            </div>
                								</form>   
								            </div>
								        </div>
								    </div>
								</div>
								
								
								<!-- form edit -->
								<div id="edit_${msg.userlist.get(loop.index-1).getProjectID()}" class="modal fade " tabindex="-1" role="dialog" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<form action="<%=request.getContextPath()%>/DMS/UpdateProject?id=${msg.userlist.get(loop.index-1).getProjectID()}" method="POST" id="formEdit" role="form">
												<input type="hidden" name="id_proyek_dms" value="11">
												<input type="hidden" class="form-control" name="compare_proyek" value="${msg.userlist.get(loop.index-1).getProjectName()}" >
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span>
													</button>
													<h4 class="modal-title" id="myModalLabel">UPDATE PROJECT</h4>
												</div>
												<div class="modal-body">
													<div class="form-group">
														<label for="">Project Name</label>
														<input type="text" class="form-control" name="proyek_name" value="${msg.userlist.get(loop.index-1).getProjectName()}" >
													</div>
													
													<div class="form-group">
														<label for="">Area</label>
														<input type="text" class="form-control" name="proyek_region" value="${msg.userlist.get(loop.index-1).getArea()}" >
													</div>

													
													<div class="form-group">
														<label for="">Sektor</label>
														<select name="proyek_sektor" class="sektoredit form-control selectpicker" data-live-search="true">
							
															
															<c:forEach begin="1" end="${msg.sector.size()}" varStatus="loop">
																<option value="${msg.sector.get(loop.index-1).getIdSektor()}">${msg.sector.get(loop.index-1).getNamaSektor()}</option>
															</c:forEach>
														</select>
														
													</div>
													
												</div>
												<div class="modal-footer">
													<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
													<button type="submit" class="btn btn-warning">Update</button>
												</div>
											</form>
										</div>
									</div>
								</div>
							 	</grid>
								</c:forEach>
								</div>

</c:if>


<!-- blok PME -->
<c:if test="${(lastValue == 'PME')}">
								<c:set var = "noDataQuery" scope = "session" value = "${msg.userlist.get(0).getNoDataQuery()}"/>

								<!-- <c:set var = "tahun" scope = "session" value = "${msg.userlist.get(0).getProjectDate()}"/> -->
								<c:set var = "jum" scope = "session" value = "${msg.userlist.size()}"/>
								<c:set var = "itr" scope = "session" value = "${msg.userlist.size()}"/>
      							<!-- kondisi agar untuk element tidak ditemukan makan index iterasi 1 di jadi 0 biar tidak err -->
      							<c:if test = "${noDataQuery == 'noDataFromQuery' && jum==1}">
         							<c:set var = "itr" scope = "session" value = "0"/>
      							</c:if>
								
								<div id="paging">
								<!-- looping content -->
								<c:forEach begin="1" end="${itr}" varStatus="loop">
									<grid>
									<%String title = "User Agent Example";%>
											<sql:query dataSource="${dbPME}" var="result">
													select * from tahapan_pme where id_project_pme = ? and nama_tahapan=?
												<sql:param value="${msg.userlist.get(loop.index-1).getProjectID()}" />
												<sql:param value="Tahapan KPBU" />
											</sql:query>

											<c:set var="totalPercentageProject" value="${0}" />

											<c:forEach var="row" items="${result.rows}">

												<sql:query dataSource="${dbPME}" var="resultJT">
													select * from jenis_tahapan where id_tahapan = ?
													<sql:param value="${row.id_tahapan}" />
												</sql:query>

												<c:set var="totalJenisTahapan" value="${resultJT.rowCount}" />
												<c:set var="totalPercentage" value="${0}" />

												<c:choose>
													<c:when test="${totalJenisTahapan > 0}">
														<c:forEach var="rowKegiatan" items="${resultJT.rows}">
															<sql:query dataSource="${dbPME}"
																var="resultPercentageTahapan">
																select 100/COUNT(status) * (select COUNT(status) from kegiatan_pme where status = 1 AND id_jenis_tahapan = ?) as persentase from kegiatan_pme WHERE id_jenis_tahapan = ?
																<sql:param value="${rowKegiatan.id_jenis_tahapan}" />
																<sql:param value="${rowKegiatan.id_jenis_tahapan}" />
															</sql:query>

															<c:forEach var="row3"
																items="${resultPercentageTahapan.rows}">
																<c:set var="totalPercentage"
																	value="${totalPercentage + row3.persentase}" />
															</c:forEach>
														</c:forEach>

														<c:set value="${totalPercentage/totalJenisTahapan}"
															var="hasil" />
													</c:when>
													<c:otherwise>
														<c:set value="${0}" var="hasil" />
													</c:otherwise>
												</c:choose>

												<c:set var="totalPercentageProject"
													value="${totalPercentageProject + hasil}" />


											</c:forEach>
    								    								<div class="grid-col">
    									<div class="col-container">
    									
    										<div class="col2 col-sm-12" align="center">
												<img style="width:70px; height:70px; margin: auto;" src="<%=request.getContextPath()%>/assets/images/proyek-pme.jpg" />
												<div class="clearfix"></div>
												
												<h5><b>
													<label class="control-label">${msg.userlist.get(loop.index-1).getProjectName()} </label><br>
													</b>
												</h5>
													<label id="sektor_view" style="font-size:80%;">${msg.userlist.get(loop.index-1).getSector()}</label>
											<!-- 	
												<div
													style="height: 10vh; width: 100%; margin-bottom: -15px;">
													<h1 style="width: 100%; font-size: 3.5vh;">
														${msg.userlist.get(loop.index-1).getProjectName()}</h1>
												</div>
												<div
													style="height: 10vh; width: 100%; margin-bottom: -15px;">
													<h1 style="width: 100%; font-size: 3.5vh;">
														${msg.userlist.get(loop.index-1).getSector()}</h1>
												</div>
												 -->

											</div>
											
											
												<div class="col3 col-sm-2">
														<c:choose>
											               	<c:when test="${level == 1}">
													            <a data-toggle="tooltip" data-placement="top" title="Manage" class="btn btn-md btn-warning"
																href="<%=request.getContextPath()%>/PME/ViewProjectPME?id=${msg.userlist.get(loop.index-1).getProjectID()}"><i class="fa fa-eye"></i> </a>
		
															</c:when>
															<c:otherwise>
																<a data-toggle="tooltip" data-placement="top" title="Manage" class="btn btn-md btn-warning"
																href="<%=request.getContextPath()%>/PME/ViewProjectPME?id=${msg.userlist.get(loop.index-1).getProjectID()}"><i class="fa fa-tasks"></i> </a>
																				
															</c:otherwise>
										               	</c:choose>
														
														<br>
														<c:if test="${msg.userlist.get(loop.index-1).getUserID() == user_id || level > 2}">
														<a data-toggle="tooltip" data-placement="top" title="Delete">
															<button type="button" class="btn btn-md btn-danger"
																data-toggle="modal"
																data-target="#formDeleteProject_${msg.userlist.get(loop.index-1).getProjectID()}">
																<i class="fa fa-trash"></i>
															</button>
														</a>
														</c:if>
												</div>
											
											
										</div>
									</div>
								
								<!-- Form Delete Project -->
								<div class="modal fade" id="formDeleteProject_${msg.userlist.get(loop.index-1).getProjectID()}" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    								<div class="modal-dialog">
        								<div class="modal-content">
            								<div class="modal-header">
                								<button type="button" class="close" data-dismiss="modal">
                       								<span aria-hidden="true">&times;</span>
                       								<span class="sr-only">Close</span>
                								</button>
                								<h4 class="modal-title" id="myModalLabel">DELETE PROJECT</h4>
            								</div>
            								<div class="modal-body">
                								<form role="form" action="<%=request.getContextPath()%>/PME/DeleteProject?id=${msg.userlist.get(loop.index-1).getProjectID()}" method="post" id="delete_project">
                  									<div class="form-group">
                  										<label class="control-label"><div align="left">Apakah Anda yakin akan menghapus proyek "${msg.userlist.get(loop.index-1).getProjectName()}"?</div></label>
                  									</div>
                  									
										            <div class="modal-footer">
										                <button type="button" class="btn btn-default"
										                        data-dismiss="modal">
										                            Close
										                </button>
										                
										                <button type="submit" class="btn btn-danger">Delete</button>
										            </div>
                								</form>   
								            </div>
								        </div>
								    </div>
								</div>
								
								
								<!-- form edit -->
								<div id="edit_${msg.userlist.get(loop.index-1).getProjectID()}" class="modal fade " tabindex="-1" role="dialog" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<form action="<%=request.getContextPath()%>/DMS/ViewProjectPME?id=${msg.userlist.get(loop.index-1).getProjectID()}" method="POST" role="form">
												<input type="hidden" name="id_proyek_dms" value="11">
												<div class="modal-body">
													<div class="form-group">
														<label for="">Project Name</label>
														<input type="text" class="form-control" name="proyek_name"  value="${msg.userlist.get(loop.index-1).getProjectName()}" required>
													</div>
													
													<div class="form-group">
														<label for="">Area</label>
														<select name="proyek_region" id="Area" class="form-control"  required>
															<option value="${msg.userlist.get(loop.index-1).getArea()}">${msg.userlist.get(loop.index-1).getArea()}</option>
															<c:forEach begin="1" end="${msg.area.size()}" varStatus="looparea">
																<option value="${msg.area.get(looparea.index-1).getNamaArea()}">${msg.area.get(looparea.index-1).getNamaArea()}</option>
															</c:forEach>
														</select>
													</div>
													
												</div>
												<div class="modal-footer">
													<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
													<button type="submit" class="btn btn-warning">Update</button>
												</div>
											</form>
										</div>
									</div>
								</div>
								</grid>
								</c:forEach>


</c:if>


<script type="text/javascript">


$(document).ready(function(){
	$('.modal').on('hidden.bs.modal', function(){
	    $(this).find('form')[0].reset();
		
	});	
	
	 //$('.selectpicker').selectpicker();

});

$('#paging').easyPaginate({
    paginateElement: 'grid',
    elementsPerPage: 12,
    firstButton : false,
    lastButton : false,
    prevButtonText : 'Previous',
    nextButtonText : 'Next'
    
});

function selectedSektor(sektor){
	//alert(sektor);
	$('.selectpicker').selectpicker('val', [sektor]); 
}

</script>


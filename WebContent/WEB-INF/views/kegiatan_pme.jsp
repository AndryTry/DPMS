<%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<%@page import= "org.json.simple.JSONObject" %>
<%@page import = "org.json.simple.parser.JSONParser" %>
<%@page import = "org.json.simple.parser.ParseException" %>
<%@page  import = "java.net.URL" %>
<%@page import = "java.util.logging.Logger" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix = "sql"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<link rel="shortcut icon" href="<%=request.getContextPath()%>/assets/images/logo-login.png" type="image/x-icon">
		<title>Kegiatan Proyek ${projectName}</title>
		<jsp:include page="/WEB-INF/views/assets/style.jsp"></jsp:include>
		<link href="<%=request.getContextPath()%>/assets/summernote/dist/summernote.css" rel="stylesheet" type="text/css" />
   <!-- <link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/codemirror.css">
		<link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/theme/monokai.css">
	-->
		<style type="text/css">
			h1 {
			color: #000000;
			}
			h2 {
			color: #000000;
			}
			h3 {
			color: #000000;
			}
			h4 {
			color: #000000;
			}
			span {
			color: #000000;
			}
			td {
			color: #000000;
			}
			th {
			color: #000000;
			}
			div {
			color: #000000;
			}
			
			
		</style>
		
	</head>
	<body class="nav-md">
	<% Logger logger = Logger.getLogger(this.getClass().getName());%>
	<% 
		HttpServletResponse httpResponse = (HttpServletResponse)response;
		
		httpResponse.setHeader("Cache-Control","no-cache, no-store, must-revalidate"); 
		response.addHeader("Cache-Control", "post-check=0, pre-check=0");
		httpResponse.setHeader("Pragma","no-cache"); 
		httpResponse.setDateHeader ("Expires", 0); 
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
               response.sendRedirect("Login");
               return;
		 }
	%>
	
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
    	<div class="container body">
      		<div class="main_container">
      			<jsp:include page="header_admin.jsp"></jsp:include>
      			<jsp:include page="sidebar.jsp"></jsp:include>
      			
      			<c:set var = "urllogin1" value ="${dbUrl}"/>
      			<c:set var = "user1"  value ="${dbUser}"/>
      			<c:set var = "psswd1"  value ="${dbPass}"/>
      			<sql:setDataSource var="dbPME" 
      				 driver="com.mysql.jdbc.Driver"
				     url="${urllogin1}"
				     user="${user1}"  
				     password="${psswd1}"
				/>
      			
      			<!-- main content -->
      			<div class="right_col" role="main">
          			<div class="row">
            			<div class="col-md-12 col-sm-12 col-xs-12">
              				<div class="dashboard_graph">
                				<div class="row x_title">            								
        							<sql:query dataSource="${dbPME}" var="resultDoneTahapan">
										select nama_jenis from jenis_tahapan where id_jenis_tahapan = (select min(id_jenis_tahapan) from jenis_tahapan where id_jenis_tahapan > ?) AND id_tahapan = ?  AND disable = 'disabled'
										<sql:param value="${idJenisTahapan}" />
										<sql:param value="${idTahapan}" />
									</sql:query>
									
									<c:choose>
										<c:when test="${resultDoneTahapan.rowCount == 0}">
											<c:set var="tahapanBerikut" value=""/>
										</c:when>
										<c:otherwise>
											<c:forEach  var="row" items="${resultDoneTahapan.rows}">
												<c:set var="tahapanBerikut" value="${row.nama_jenis}"/>
											</c:forEach>										
										</c:otherwise>
									</c:choose>
									<h4><a href="<%=request.getContextPath()%>/PME/ViewProjectPME_dashboard?id=${projectIDPME}"  > Proyek ${projectNamePME} </a></h4>
                   					                					           			
                  					<div class="nav navbar-right panel_toolbox">
                  						<c:if test="${level > 2}">		
                  						<c:choose>
                  							<c:when test="${tahapanBerikut.length() > 0 && percentage >= 100}">
												<button class="btn btn-primary" data-toggle="modal" data-target="#done">
			   										<i class="fa fa-check"> Selesai</i>
												</button>	                  							
                  							</c:when>
                  							<c:otherwise>
                  								<button class="btn btn-primary" disabled="disabled" data-toggle="modal" data-target="#done">
			   										<i class="fa fa-check"> Selesai</i>
												</button>
                  							</c:otherwise>
                  						</c:choose>
                  						</c:if>
									</div>									
                   					<h4><font class="nama_tahapan">${namaTahapan}</font>  ${jenis_tahapan} (${percentage}%)</h4> 
                				</div>
                				<div class="row x_title">
                  					<label id="nav"><a href="<%=request.getContextPath()%>/Home">Home</a></label> / 
                					<label id="nav"><a href="<%=request.getContextPath()%>/PME">Proyek</a></label> /
	                				<label id="nav"><a href="<%=request.getContextPath()%>/PME/ViewProjectPME?id=${projectIDPME}"  > ${projectNamePME} </a>
	                				</label> /
	                				<label id="nav"><a href="<%=request.getContextPath()%>/PME/ViewJenisTahapan?id=${id_tahapan}&name=${namaTahapan}"  > ${namaTahapan} </a>
	                				</label> /
                					<c:forEach items="${namaJenisTahapan}" var="tahapan">
	                					   <label id="nav"><a href="<%=request.getContextPath()%>/PME/KegiatanTahapan?id=${idJenisTahapan}&nama=${projectNamePME}&nama_jenis=${namaJenisTahapan}&name=${namaTahapan}&id_tahap=${id_tahapan}"  > ${namaJenisTahapan} </a>
	                					   </label>
                					</c:forEach>
                				</div>
                				
                				<!-- Tahapan Selesai -->
								<div class="modal fade" id="done" tabindex="-1" role="dialog" aria-labelledby="myModalLabel22" aria-hidden="true">
    								<div class="modal-dialog">
        								<div class="modal-content">
            								<div class="modal-header">
                								<button type="button" class="close" data-dismiss="modal">
                       								<span aria-hidden="true">&times;</span>
                       								<span class="sr-only">Close</span>
                								</button>
                								<h4 class="modal-title" id="myModalLabel22">Lanjut Tahapan</h4>
            								</div>
            								
            								<div class="modal-body">
            									Lanjut ke tahapan "${tahapanBerikut}" ?
								            </div>
								            <div class="modal-footer">
            									<input type="hidden" name="projectName" value="${projectNamePME}"/>
            									<input type="hidden" name="jenis_tahapan" value="${jenis_tahapan}"/>
            									<input type="hidden" id="doneIdTahapan" name="id_tahapan" value="${idTahapan}"/>
            									<input type="hidden" name="id_jenis_tahapan" value="${id_jenis_tahapan}"/>
								                <button type="button" class="btn btn-default"
								                        data-dismiss="modal">
								                            Tutup
								                </button>
								                <c:choose>
		                  							<c:when test="${tahapanBerikut.length() == 0 || tahapanBerikut.equals('')}">
														<button class="btn btn-default" disabled="disabled" data-toggle="modal" data-target="#done">
					   										Ya
														</button>	                  							
		                  							</c:when>
		                  							<c:otherwise>
		                  								<button class="btn btn-default" data-toggle="modal" data-target="#done" onclick="tahapanBerikut()">
					   										Ya
														</button>
		                  							</c:otherwise>
		                  						</c:choose>
								            </div>
								        </div>
								    </div>
								</div>
                				
                				<c:set var = "noDataQuery" scope = "session" value = "noDataFromQuery"/>

								<c:set var = "jum" scope = "session" value = "${listKegiatan.size()}"/>
								<c:set var = "itr" scope = "session" value = "${listKegiatan.size()}"/>
      							
                				<div class="col-md-12 col-sm-12 col-xs-12">                				  	
                				  	<table id="table_kegiatan" class="table table-striped table-bordered" cellspacing="0" width="100%">
								         <thead>
									         <tr>
									            <th class="sorting_disabled" rowspan="1" colspan="1" style="width: 3%;" align="center">No</th>
									            <th class="sorting_disabled" rowspan="1" colspan="1" style="width: 17%;" align="center">Nama Kegiatan</th>
									            <th class="sorting_disabled" rowspan="1" colspan="1" style="width: 10%;" align="center">Target</th>
									            <th class="sorting_disabled" rowspan="1" colspan="1" style="width: 10%;" align="center">Realisasi</th>
									            <th class="sorting_disabled" rowspan="1" colspan="1" style="width: 40%;" align="center">Keterangan</th>
									            <th class="sorting_disabled" rowspan="1" colspan="1" style="width: 10%;" align="center">Status</th>
									            <th class="sorting_disabled" rowspan="1" colspan="1" style="width: 10%;" align="center">Opsi</th>
									         </tr>
									      </thead>
									      <tbody>	
									      											
											<c:forEach begin="1" end="${itr}" varStatus="loop">
												<sql:query dataSource="${dbPME}" var="result">
													select count(id_file) as total_file from file_pme where id_kegiatan = ?
													<sql:param value="${listKegiatan.get(loop.index-1).getIdKegiatan()}" />
												</sql:query>
												<c:forEach  var="row" items="${result.rows}">
													<c:set var="totalFile" value="${row.total_file}"/>
												</c:forEach>
												
												<!-- Edit Kegiatan -->
												<div class="modal fade" id="editKegiatan" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
				    								<div class="modal-dialog">
				        								<div class="modal-content">
				            								<div class="modal-header">
				                								<button type="button" class="close" data-dismiss="modal">
				                       								<span aria-hidden="true">&times;</span>
				                       								<span class="sr-only">Close</span>
				                								</button>
				                								<h4 class="modal-title" id="myModalLabel">Edit Kegiatan</h4>
				            								</div>
				            								<div class="modal-body">
			                									<input type="hidden" id="editProjectName" name="projectName" value="${projectNamePME}"/>
			                									<input type="hidden" id="editJenisTahapan" name="jenis_tahapan" value="${jenis_tahapan}"/>
			                									<input type="hidden" id="editIdJenisTahapan" name="id_jenis_tahapan" value="${id_jenis_tahapan}"/>
			                									<input type="hidden" id="editIdKegiatan" name="id_kegiatan" class="form-control edit_id_kegiatan"/>
			                									<input type="hidden" name="projectNamaPME" value="${projectNamePME}"/>
			                									<input type="hidden" id="editNamaTahapan" name="nameTahapan" value="${namaTahapan}"/>
			                									<input type="hidden" id="editIdTahapan" name="id_tahapan" value="${id_tahapan}"/>
			                									
			                  									<div class="form-group">
			                    									<input type="text" class="form-control edit_name" name="name" placeholder="Nama Kegiatan" id="editNamaKegiatan" required/>
			                  									</div>
			                  									<div class="form-group">
			                    									<input type="text" class="form-control edit_target" name="target" placeholder="Target" id="tanggal" required/>
			                  									</div>
			                  									<div class="form-group">
			                    									<input type="text" class="form-control edit_realisasi"  name="realisasi" placeholder="Realisasi" id="tanggal2"/>
			                  									</div>
			                  									<div class="form-group">
			                      									<select id="pilihan" class="form-control" name="status" required>
			                      										<option value="">Pilih Status</option>
			                      										<c:set var="statusValue" value="${listKegiatan.get(loop.index-1).getStatus()}"/>
			                      										<% 
			                      												String[] status = {"Selesai", "Sedang Berlangsung", "N/A"};
			                      												String statusValue = (String)pageContext.getAttribute("statusValue");
																				
																				for(int i=0; i<status.length; i++){
																					if (i+1 == Integer.parseInt(statusValue)){
																						%>
																						<option value="<%out.print(i+1);%>" selected><%out.print(status[i]); %></option><%																						
																					}else {%>
																						<option value="<%out.print(i+1);%>"><%out.print(status[i]); %></option><%
																					}%>
			                      											<% } 
			                      										%>
			                      									</select>
			                  									</div>
			                  									<div class="form-group">
			                  										<label class="control-label">Keterangan</label>
			                      									<textarea class="control-label description" id="description" name="desc" rows="5" style="width:100%;" required ></textarea>
			                  									</div>					                  									
													            <div class="modal-footer">
													                <button type="button" class="btn btn-default"
													                        data-dismiss="modal">
													                            Close
													                </button>
													                <input type="submit" value="Save changes" class="btn btn-primary" onclick="editKegiatan()">
													            </div>
												            </div>
												        </div>
												    </div>
												</div>
												
												<!-- Hapus Kegiatan -->
												<div class="modal fade" id="hapusKegiatan" tabindex="-1" role="dialog" aria-labelledby="myModalLabel22" aria-hidden="true">
				    								<div class="modal-dialog">
				        								<div class="modal-content">
				            								<div class="modal-header">
				                								<button type="button" class="close" data-dismiss="modal">
				                       								<span aria-hidden="true">&times;</span>
				                       								<span class="sr-only">Close</span>
				                								</button>
				                								<h4 class="modal-title" id="myModalLabel22">Hapus Kegiatan</h4>
				            								</div>
				            								<div class="modal-body">
				            									Apakah Anda yakin ingin menghapus kegiatan "<span class="hapus_name"></span>" ?
												            </div>
												            <div class="modal-footer">
			                									<input type="hidden" name="projectName" id="hapusProjectName" value="${projectNamePME}"/>
			                									<input type="hidden" name="jenis_tahapan" id="hapusJenisTahapan" value="${jenis_tahapan}"/>
			                									<input type="hidden" name="id_jenis_tahapan" id="hapusIdJenisTahapan" value="${id_jenis_tahapan}"/>
			                									<input type="hidden" name="id_kegiatan" id="hapusIdKegiatan" class="form-control hapus_id"/>
			                									<input type="hidden" name="projectNamaPME" value="${projectNamePME}"/>
			                									<input type="hidden" id="hapusNamaTahapan" name="nameTahapan" value="${namaTahapan}"/>
			                									<input type="hidden" id="hapusIdTahapan" name="id_tahapan" value="${id_tahapan}"/>
												                <button type="button" class="btn btn-default"
												                        data-dismiss="modal">
												                            Close
												                </button>
												                <input type="submit" value="Delete" class="btn btn-danger" onclick="hapusKegiatan()"/>
												            </div>
												        </div>
												    </div>
												</div>
												
												<tr>
									               <td width="3%" align="center"><c:out value="${loop.index}"/></td>
									               <td width="17%"><c:out value="${listKegiatan.get(loop.index-1).getNamaKegiatan()}"/></td>
									               <td width="10%" align="center"><c:out value="${listKegiatan.get(loop.index-1).getTarget()}"/></td>
									               <td width="10%" align="center"><c:out value="${listKegiatan.get(loop.index-1).getRealisasi().isEmpty() ? '-' : listKegiatan.get(loop.index-1).getRealisasi()}"/></td>
									               <td width="40%"><div class="showmore"><c:out value="${listKegiatan.get(loop.index-1).getKeterangan()}" escapeXml="false"/></div></td>
									               <c:choose>
										               	<c:when  test="${listKegiatan.get(loop.index-1).getTarget() > (listKegiatan.get(loop.index-1).getRealisasi().isEmpty() ? '-' : listKegiatan.get(loop.index-1).getRealisasi()) && (listKegiatan.get(loop.index-1).getStatus() == 1)}">
										               		 <td width="10%" style="background-color: #82e0aa;" align="center">
									               				<c:set var="statusKegiatanValue" value="${listKegiatan.get(loop.index-1).getStatus()}"/>
											               		<% 
											               			String[] statusKegiatan = {"Selesai", "Sedang Berlangsung", "N/A"};
											               			String statusKegiatanValue = (String)pageContext.getAttribute("statusKegiatanValue");
											               			
											               			for (int i=0; i<3; i++){
											               				if (i+1 == Integer.parseInt(statusKegiatanValue)){
											               					out.print(statusKegiatan[i]);
											               					break;
											               				}
											               			}
											               		%>									               
									               			</td>
										               	</c:when>
										               	
										               	<c:when  test="${listKegiatan.get(loop.index-1).getTarget() == (listKegiatan.get(loop.index-1).getRealisasi().isEmpty() ? '-' : listKegiatan.get(loop.index-1).getRealisasi()) && (listKegiatan.get(loop.index-1).getStatus() == 1)}">
										               		 <td width="10%" style="background-color: #82e0aa;" align="center">
									               				<c:set var="statusKegiatanValue" value="${listKegiatan.get(loop.index-1).getStatus()}"/>
											               		<% 
											               			String[] statusKegiatan = {"Selesai", "Sedang Berlangsung", "N/A"};
											               			String statusKegiatanValue = (String)pageContext.getAttribute("statusKegiatanValue");
											               			
											               			for (int i=0; i<3; i++){
											               				if (i+1 == Integer.parseInt(statusKegiatanValue)){
											               					out.print(statusKegiatan[i]);
											               					break;
											               				}
											               			}
											               		%>									               
									               			</td>
										               	</c:when>
										               	<c:when  test="${listKegiatan.get(loop.index-1).getTarget() < (listKegiatan.get(loop.index-1).getRealisasi().isEmpty() ? '-' : listKegiatan.get(loop.index-1).getRealisasi()) && (listKegiatan.get(loop.index-1).getStatus() == 1)}">
										               		 <td width="10%" style="background-color:  #ec7063 ;" align="center">
									               				<c:set var="statusKegiatanValue" value="${listKegiatan.get(loop.index-1).getStatus()}"/>
											               		<% 
											               			String[] statusKegiatan = {"Selesai", "Sedang Berlangsung", "N/A"};
											               			String statusKegiatanValue = (String)pageContext.getAttribute("statusKegiatanValue");
											               			
											               			for (int i=0; i<3; i++){
											               				if (i+1 == Integer.parseInt(statusKegiatanValue)){
											               					out.print(statusKegiatan[i]);
											               					break;
											               				}
											               			}
											               		%>									               
									               			</td>
										               	</c:when>
										               	<c:otherwise>
										               		 <td width="10%" align="center">
											               		<c:set var="statusKegiatanValue" value="${listKegiatan.get(loop.index-1).getStatus()}"/>
											               		<% 
											               			String[] statusKegiatan = {"Selesai", "Sedang Berlangsung", "N/A"};
											               			String statusKegiatanValue = (String)pageContext.getAttribute("statusKegiatanValue");
											               			
											               			for (int i=0; i<3; i++){
											               				if (i+1 == Integer.parseInt(statusKegiatanValue)){
											               					out.print(statusKegiatan[i]);
											               					break;
											               				}
											               			}
											               		%>									               
									               			</td>
										               	</c:otherwise>
								               	 	</c:choose>
									              
									               
									               <td width="10%">
									               		<c:choose>
										               		<c:when  test="${totalFile > 0}">
										               			<a data-toggle="tooltip" data-placement="top" title="Unduh">
													               <button onclick="listUnduhFile(${listKegiatan.get(loop.index-1).getIdKegiatan()})"; class="btn btn-xs btn-info" data-toggle="modal" data-backdrop="static" data-keyboard="false" data-target="#unduhFile">
							    										<i class="fa fa-download"></i>
																	</button>	
																</a>				               			
										               		</c:when>
										               		<c:otherwise>
										               			<a data-toggle="tooltip" data-placement="top">
													               <button onclick="listUnduhFile(${listKegiatan.get(loop.index-1).getIdKegiatan()})"; id="b_unduh_${listKegiatan.get(loop.index-1).getIdKegiatan()}" class="btn btn-xs btn-info" disabled="disabled" data-toggle="modal" data-target="#unduhFile">
							    										<i class="fa fa-download"></i>
																	</button>
																</a>
										               		</c:otherwise>
								               			</c:choose>
								               			<c:if test="${level != 1}">
								               			<a data-toggle="tooltip" data-placement="top" title="Upload">
															<button class="btn btn-xs btn-primary" data-toggle="modal" data-target="#uploadFile"
																data-name="<c:out value="${listKegiatan.get(loop.index-1).getNamaKegiatan()}"/>"
																data-id="<c:out value="${listKegiatan.get(loop.index-1).getIdKegiatan()}"/>">
					    										<i class="fa fa-upload"></i>
															</button>
														</a>
														</c:if>
														<c:set var="kegiatan_user" value="${listKegiatan.get(loop.index-1).getId_user()}"/>
														<c:if test="${(level > 1 && kegiatan_user == user_id) || allowed ||level > 2}">
															<a data-toggle="tooltip" data-placement="top" title="Edit">
																<button class="btn btn-xs btn-warning" data-toggle="modal" data-target="#editKegiatan"
																	data-content="<c:out value="${listKegiatan.get(loop.index-1).getKeterangan()}"/>"
																	data-name="<c:out value="${listKegiatan.get(loop.index-1).getNamaKegiatan()}"/>"
																	data-targetKegiatan="<c:out value="${listKegiatan.get(loop.index-1).getTarget()}"/>"
																	data-realisasi="<c:out value="${listKegiatan.get(loop.index-1).getRealisasi()}"/>"
																	data-status="<c:out value="${listKegiatan.get(loop.index-1).getStatus()}"/>"
																	data-id="<c:out value="${listKegiatan.get(loop.index-1).getIdKegiatan()}"/>">
						    										<i class="fa fa-edit"></i>
																</button>
															</a>
														
															<!-- Hapus Kegiatan Button -->
															<a data-toggle="tooltip" data-placement="top" title="Delete">
																<button class="btn btn-xs btn-danger" data-toggle="modal" data-target="#hapusKegiatan"
																	data-id="<c:out value="${listKegiatan.get(loop.index-1).getIdKegiatan()}"/>"
																	data-name="<c:out value="${listKegiatan.get(loop.index-1).getNamaKegiatan()}"/>">
						    										<i class="fa fa-trash"></i>
																</button>
															</a>
														</c:if>
														
														<!-- Create By -->
														<c:if test="${level > 1}">
															<a data-toggle="tooltip" data-placement="top" title="${listKegiatan.get(loop.index-1).getUsername()}">
																<button class="btn btn-xs btn-info" data-toggle="modal" data-target="#"
																	data-id="<c:out value="${listKegiatan.get(loop.index-1).getIdKegiatan()}"/>">
						    										<i class="fa fa-info"></i>
																</button>
															</a>
														</c:if>
												
														<!-- Unduh File -->
														<div class="modal fade" id="unduhFile" role="dialog" aria-labelledby="myModalLabel41" aria-hidden="true" style="padding-top: 40px;">
						    								<c:set var="myIdKegiatan" value="${listKegiatan.get(loop.index-1).getIdKegiatan()}"/>
						    								<div class="modal-dialog vertical-align-center"  style="width:1000px; margin: auto;">
						        								<div class="modal-content">
						            								<div class="modal-header">
						                								<button type="button" class="close" onclick="closeModalUpload()">
						                       								<span aria-hidden="true">&times;</span>
						                       								<span class="sr-only">Close</span>
						                								</button>
						                								<h4 class="modal-title" id="myModalLabel41">Unduh File</h4>
						            								</div>
						            								<div class="modal-body" style="height:500px;">
																		<div id="table_download"></div>
														            </div>	
														        </div>
														    </div>
														</div>
												   </td>
									            </tr>									            				
												
											</c:forEach>
										</tbody>
								   </table>
								   
								   
									<!-- Form Upload File perbaikan 27 agustus 2019 -->
               						<div class="modal fade" id="uploadFile" tabindex="-1" role="dialog" aria-labelledby="myModalLabe3" aria-hidden="true" style="padding-top: 40px;">
										<div class="modal-dialog vertical-align-center"  style="width:1000px; margin: auto;">
											<div class="modal-content">
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
													<h4 class="modal-title" id="myModalLabe3">Upload File</h4>
												</div>
												<div class="modal-body" style="height:580px;">			  	
				                				  	<input type="hidden" name="id_kegiatan" class="id_kegiatan" id="idsusah"/>
				                				  	<input type="hidden" name="nama_kegiatan" class="nama_kegiatan" id="idsusahnama"/>
				                				  	<div class="row"  style="padding-bottom:15px;">
														<div class="col-sm-8"><input type="text" name="search_fileupload" class="form-control" id="search_fileupload" placeholder="search nama file atau nama proyek"/></div>
														<div class="col-sm-4"><button type="button" class="btn btn-sm btn-primary" id="b_searchUpload" onclick="pagingListUpload(1)"><i class="fa fa-search"></i></button></div>
													</div>
				                				  	
				                				  	<div id="table_upload" ></div>
													

													
													<sql:query dataSource="${dbPME}" var="tot_upload">
														select count(*) as total from file_dms
													</sql:query>
													<c:forEach var="total" items="${tot_upload.rows}">
										  					<input type="hidden" value="${total.total}" id="tot_rec"/>
										  			</c:forEach>
													
													<div class="pagination_upload col-sm-12"></div>
													
												</div>
											</div>
										</div>
									</div>
								   
								   <!-- TOMBOL -->
	               				  	<div>
	               				  		<c:if test="${allowed || level > 1}">
						               <button class="btn btn-primary" data-toggle="modal" data-target="#tambahKegiatan">
    										<i class="fa fa-plus"> Tambah Kegiatan</i>
										</button> 
										</c:if> 		
	               				  	</div>
	               				  	
	               				  	
	               				  	<!-- Tambah Kegiatan -->
									<div class="modal fade" id="tambahKegiatan" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	    								<div class="modal-dialog">
	        								<div class="modal-content">
	            								<div class="modal-header">
	                								<button type="button" class="close" data-dismiss="modal">
	                       								<span aria-hidden="true">&times;</span>
	                       								<span class="sr-only">Close</span>
	                								</button>
	                								<h4 class="modal-title" id="myModalLabel">Tambah Kegiatan</h4>
	            								</div>
	            								<div class="modal-body">
                									<input type="hidden" id="addProjectName" name="projectName" value="${projectNamePME}"/>
                									<input type="hidden" id="addJenisTahapan" name="jenis_tahapan" value="${jenis_tahapan}"/>
                									<input type="hidden" id="addIdJenisTahapan" name="id_jenis_tahapan" value="${id_jenis_tahapan}"/>
                									<input type="hidden" name="projectNamaPME" value="${projectNamePME}"/>
			                						<input type="hidden" id="addNamaTahapan" name="nameTahapan" value="${namaTahapan}"/>
			                						<input type="hidden" id="addIdTahapan" name="id_tahapan" value="${id_tahapan}"/>
                									
                  									<div class="form-group">
                    									<input type="text" class="form-control" id="addName" name="name" placeholder="Nama Kegiatan" required/>
                  									</div>
                  									<div class="form-group">
                    									<input type="text" id="tanggal3" class="form-control" name="target" placeholder="Target" required/>
                  									</div>
                  									<div class="form-group">
                    									<input type="text" id="tanggal4" class="form-control" name="realisasi" placeholder="Realisasi"/>
                  									</div>
                  									<div class="form-group">
                      									<select class="form-control" id="addStatus" name="status" required>
                      										<option value="">Pilih Status</option>
                      										<% 
                      											String[] status = {"Selesai", "Sedang Berlangsung", "N/A"};
																for(int i=0; i<3; i++){%>
                      												<option value="<%out.print(i+1);%>"><%out.print(status[i]); %></option>
                      										<% } %>
                      									</select>
                  									</div>
                  									<div class="form-group">
                  										<!--  <label class="control-label"><div align="left">Keterangan</div></label> -->
                      									<textarea name="desc" id="addDesc" rows="5" style="width:100%;" required></textarea>
                  									</div>
                  									
										            <div class="modal-footer">
										                <button type="button" class="btn btn-default"
										                        data-dismiss="modal">
										                            Close
										                </button>
										                <button type="submit" value="Save changes" class="btn btn-primary" onclick="addKegiatan()">Save changes</button>
										            </div>
									            </div>
									        </div>
									    </div>
									</div>							
                				</div>
                				
                				<div class="clearfix"></div> 
                				<div class="row x_title"></div>
                				<div class="row x_title">
                					<sql:query dataSource="${dbPME}" var="nextTahapanQuery">
										select a.id_jenis_tahapan, a.nama_jenis, b.nama_tahapan from jenis_tahapan a, tahapan_pme b where a.id_jenis_tahapan =(select min(id_jenis_tahapan) from jenis_tahapan where id_jenis_tahapan > ?) and a.disable='enabled' and a.id_tahapan=? and a.id_tahapan = b.id_tahapan
										<sql:param value="${idJenisTahapan}" />
										<sql:param value="${idTahapan}" />
									</sql:query>
									
									<sql:query dataSource="${dbPME}" var="backTahapanQuery">
										select a.id_jenis_tahapan, a.nama_jenis, b.nama_tahapan from jenis_tahapan a, tahapan_pme b where a.id_jenis_tahapan =(select max(id_jenis_tahapan) from jenis_tahapan where id_jenis_tahapan < ?) and a.disable='enabled' and a.id_tahapan=? and a.id_tahapan = b.id_tahapan
										<sql:param value="${idJenisTahapan}" />
										<sql:param value="${idTahapan}" />
									</sql:query>
									
									<c:choose>
										<c:when test="${backTahapanQuery.rowCount == 0}">
											<div class="nav navbar-left panel_toolbox">
												<a class="btn btn-primary" disabled="disabled" data-toggle="modal" href="#Back_tahapan">
												<i class="fa "></i> Kembali Tahapan</a>					
										</div>
										</c:when>
										<c:otherwise>
											<c:forEach  var="backrow" items="${backTahapanQuery.rows}">
												<c:set var="back_id_jenis_tahapan" value="${backrow.id_jenis_tahapan}"/>
												<c:set var="back_nama_jenis" value="${backrow.nama_jenis}"/>
												<c:set var="back_nama_tahapan" value="${backrow.nama_tahapan}"/>
											</c:forEach>
											<div class="nav navbar-left panel_toolbox">
												<a class="btn btn-primary" data-toggle="modal" href="<%=request.getContextPath()%>/PME/KegiatanTahapan?id=${back_id_jenis_tahapan}&nama=${projectNamePME}&nama_jenis=${back_nama_jenis}&name=${back_nama_tahapan}&id_tahap=${idTahapan}">
												<i class="fa "></i> Kembali Tahapan</a>					
											</div>									
										</c:otherwise>
									</c:choose>
									
									<c:choose>
										<c:when test="${nextTahapanQuery.rowCount == 0}">
											<div class="nav navbar-right panel_toolbox">
												<a class="btn btn-primary" disabled="disabled" data-toggle="modal" href="#Next_tahapan">
												<i class="fa "></i> Lanjut Tahapan</a>					
											</div>
										</c:when>
										<c:otherwise>
											<c:forEach  var="nextrow" items="${nextTahapanQuery.rows}">
												<c:set var="next_id_jenis_tahapan" value="${nextrow.id_jenis_tahapan}"/>
												<c:set var="next_nama_jenis" value="${nextrow.nama_jenis}"/>
												<c:set var="next_nama_tahapan" value="${nextrow.nama_tahapan}"/>
											</c:forEach>
											<div class="nav navbar-right panel_toolbox">
												<a class="btn btn-primary" data-toggle="modal" href="<%=request.getContextPath()%>/PME/KegiatanTahapan?id=${next_id_jenis_tahapan}&nama=${projectNamePME}&nama_jenis=${next_nama_jenis}&name=${next_nama_tahapan}&id_tahap=${idTahapan}">
												<i class="fa "></i> Lanjut Tahapan</a>					
											</div>										
										</c:otherwise>
									</c:choose>
									
                				</div> 
              				</div>
              				
            			</div>
          			</div>
          			<br />
        		</div>
      		</div>
     	</div>
     	<jsp:include page="/WEB-INF/views/assets/script.jsp"></jsp:include>
     	<script type="text/javascript" src="<%=request.getContextPath()%>/assets/readmore/readmore.js"></script>
     	<script type="text/javascript" src="<%=request.getContextPath()%>/assets/summernote/dist/summernote.js"></script>     	
  <!-- 	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/codemirror.js"></script>
		<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/mode/xml/xml.js"></script>
		<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/codemirror/2.36.0/formatting.js"></script>
	-->
		
	</body>
	<script>
	function closeModalUpload(){
		$('#unduhFile').modal('hide');
	}
	
	//tinymce.init({selector:'textarea'});
	$('#tambahKegiatan').on('hidden.bs.modal', function (e) {
		  $(this)
		    .find("input,textarea,select")
		       .val('')
		       .end();
		  $('#addDesc').summernote ('code', '');
	});
	
	
	$('.showmore').readmore({
		speed: 300,
		collapsedHeight: 40,
		moreLink: '<a href="#">More</a>',
        lessLink: '<a href="#">Less</a>'
	});
	
	/*
	$('.showmore').showMore({
		speedDown: 300,
	        speedUp: 300,
	        height: '40px',
	        showText: 'Show more',
	        hideText: 'Show less'
	});
	*/
	
	 
	 	$('[name=desc]').summernote({
		  height: 150,
		  placeholder: 'Keterangan',
		  /*
		  codemirror: {
			mode: 'text/html',
	        htmlMode: true,
	        lineNumbers: true,
	        theme: 'monokai'
		  },
		  */
		  toolbar: [
		            // [groupName, [list of button]]
		            ['fullscreen', ['fullscreen']],
		            ['style', ['bold', 'italic', 'underline', 'clear']],
		            ['fontsize', ['fontsize']],
		            ['color', ['color']],
		            //['para', ['ul', 'ol', 'paragraph']],
		            ['height', ['height']],
		            ['codeview', ['codeview']]
		          ]
		});
	

		function editKegiatan(){
			var name = $("#editNamaKegiatan").val();
			var target = $("#tanggal").val();
			var realisasi = $("#tanggal2").val();
			var status = $("#pilihan").val();
			var desc = $("#description").val();
			
			var idKegiatan = $("#editIdKegiatan").val();
			var idJenisTahapan= $("#editIdJenisTahapan").val();
			var jenisTahapan= $("#editJenisTahapan").val();
			var projectName = $("#editProjectName").val();
			var idTahapan = $("#editIdTahapan").val();
			var namaTahapan = $("#editNamaTahapan").val();
			var arr = ["<", ">", "?", "[", "]", "{", "}", "&", "/", "'\'", "`", "^", "*", "#", "~", ";", ":", "|"];
	      	
	      	var xss = false;
	       	for (var i=0; i < arr.length; i++) {
	       		if (name.includes(arr[i])){
	       			xss = true;
	       			break;
	       		}else {
	       			xss = false;
	       		}
	       	}
		   		
	  		if (name == ""){
	  			alert('Nama kegiatan tidak boleh kosong.');
	  		}else if (target == ""){
	  			alert('Tanggal target tidak boleh kosong.');
	  		}else if (status == ""){
	  			alert('Silahkan pilih status kegiatan.');
	  		}else if (desc == ""){
	  			alert('Keterangan tidak boleh kosong.');
	  		}else if (xss){
    			alert("Inputan tidak bisa mengandung karakter spesial ex: <, >, #...");
    		}else{
	  			$.ajax({
					type: "POST",
					url : "<%=request.getContextPath()%>/PME/EditKegiatan",
					data: {name:name,target:target,realisasi:realisasi,status:status,desc:desc,projectName:projectName,jenis_tahapan:jenisTahapan,id_jenis_tahapan:idJenisTahapan,id_kegiatan:idKegiatan,projectNamaPME:projectName,nameTahapan:namaTahapan,id_tahapan:idTahapan},
						success: function(data){
							alert('Berhasil merubah kegiatan.');
							window.location.reload();
						},
						error:function(){
							error('Gagal merubah kegiatan.');
						}
				});	
		  	}
		}

		function hapusKegiatan(){			
			var idJenisTahapan= $("#hapusIdJenisTahapan").val();
			var jenisTahapan= $("#hapusJenisTahapan").val();
			var projectName = $("#hapusProjectName").val();
			var idKegiatan = $("#hapusIdKegiatan").val();
			var namaTahapan = $("#hapusNamaTahapan").val();
			var idTahapan = $("#hapusIdTahapan").val();
			
			$.ajax({
				type: "POST",
				url : "<%=request.getContextPath()%>/PME/HapusKegiatan",
				data: {projectName:projectName,jenis_tahapan:jenisTahapan,id_jenis_tahapan:idJenisTahapan,id_kegiatan:idKegiatan,projectNamaPME:projectName,nameTahapan:namaTahapan,id_tahapan:idTahapan},
					success: function(data){
						alert('Kegiatan berhasil dihapus.');
						window.location.reload();
					},
					error:function(){
						error('Kegiatan gagal dihapus.');
					}
			});
		}

		function addKegiatan(){
			var name = $("#addName").val();
			var target = $("#tanggal3").val();
			var realisasi = $("#tanggal4").val();
			var status = $("#addStatus").val();
			var desc = $("#addDesc").val();
			
			var idJenisTahapan= $("#addIdJenisTahapan").val();
			var jenisTahapan= $("#addJenisTahapan").val();
			var projectName = $("#addProjectName").val();
			var idTahapan = $("#addIdTahapan").val();
			var namaTahapan = $("#addNamaTahapan").val();
			var arr = ["<", ">", "?", "[", "]", "{", "}", "&", "/", "'\'", "`", "^", "*", "#", "~", ";", ":", "|"];
	      	
	      	var xss = false;
	       	for (var i=0; i < arr.length; i++) {
	       		if (name.includes(arr[i])){
	       			xss = true;
	       			break;
	       		}else {
	       			xss = false;
	       		}
	       	}
		   		
	  		if (name == ""){
	  			alert('Nama kegiatan tidak boleh kosong.');
	  		}else if (target == ""){
	  			alert('Tanggal target tidak boleh kosong.');
	  		}else if (realisasi == ""){
	  			alert('Tanggal realisasi tidak boleh kosong.');
	  		}else if (status == ""){
	  			alert('Silahkan pilih status kegiatan.');
	  		}else if (desc == ""){
	  			alert('Keterangan tidak boleh kosong.');
	  		}else if (xss){
    			alert("Inputan tidak bisa mengandung karakter spesial ex: <, >, #...");
    		}else{
	  			$.ajax({
	  				type: "POST",
	  				url : "<%=request.getContextPath()%>/PME/CheckKegiatan",
	  				data: {name:name,id_jenis_tahapan:idJenisTahapan},
	  					success: function(data){
	  						if(data == "true"){
	  							alert("Kegiatan ini sudah ada.");
	  						}else{	
	  				  			$.ajax({
	  								type: "POST",
	  								url : "<%=request.getContextPath()%>/PME/TambahKegiatan",
	  								data: {name:name,target:target,realisasi:realisasi,status:status,desc:desc,projectName:projectName,jenis_tahapan:jenisTahapan,id_jenis_tahapan:idJenisTahapan,projectNamaPME:projectName,nameTahapan:namaTahapan,id_tahapan:idTahapan},
	  									success: function(data){
	  										alert('Berhasil menambah kegiatan baru.');
	  										window.location.reload();
	  									},
	  									error:function(){
	  										error('Gagal manambah kegiatan baru.');
	  									}
	  							});		
	  						}
	  					},
	  					error:function(){
	  						error('error request !');
	  					}
	  				});
		  	}
		}
	 	
	 	function tahapanBerikut(){
			var id_tahapan= $("#doneIdTahapan").val();
			$.ajax({
				type: "POST",
				url : "<%=request.getContextPath()%>/PME/DoneTahapan",
				data: {id_tahapan:id_tahapan},
					success: function(data){
						alert('Tahapan berikut telah diaktifkan.');
						window.location.reload();
					},
					error:function(){
						error('Error.');
					}
			});
		}
		
	 	$(function(){
			$("#tanggal").datepicker({
				dateFormat : 'yy-mm-dd',
				changeMonth: true,
				changeYear: true,
				autoSize: true
			});
		});
	 	
	 	$(function(){
			$("#tanggal2").datepicker({
				dateFormat : 'yy-mm-dd',
				changeMonth: true,
				changeYear: true,
				autoSize: true
			});
		});
	 	
	 	$(function(){
			$("#tanggal3").datepicker({
				dateFormat : 'yy-mm-dd',
				changeMonth: true,
				changeYear: true,
				autoSize: true
			});
		});
	 	
	 	$(function(){
			$("#tanggal4").datepicker({
				dateFormat : 'yy-mm-dd',
				changeMonth: true,
				changeYear: true,
				autoSize: true
			});
		});
	 	$(function(){
			$("#tanggal_surat").datepicker({
				dateFormat : 'yy-mm-dd',
				changeMonth: true,
				changeYear: true,
				autoSize: true
			});
		});
		
		function alignModal(){
	        var modalDialog = $(this).find(".modal-dialog");
	        
	        // Applying the top margin on modal dialog to align it vertically center
	        modalDialog.css("margin-top", Math.max(0, 70));
	    }
	 	
	 	
	 	$('#editKegiatan').on('show.bs.modal', function (e) {
	 		var myName = $(e.relatedTarget).attr('data-name');
	 		var myTarget = $(e.relatedTarget).attr('data-targetKegiatan');
	 		var myRealisasi = $(e.relatedTarget).attr('data-realisasi');
		    var myDesc = $(e.relatedTarget).attr('data-content');
		    var myStatus = $(e.relatedTarget).attr('data-status');
		    var myID = $(e.relatedTarget).attr('data-id');
		    //tinyMCE.get('desc').setContent(myName);
		    //$(".description").val(myDesc);
		    $('#description').summernote ('code', myDesc);
		    $(".edit_name").val(myName);
		    $(".edit_target").val(myTarget);
		    $(".edit_realisasi").val(myRealisasi);
		    $(".edit_id_kegiatan").val(myID);
		    
		    var element = document.getElementById('pilihan');
		    element.value = myStatus;
		}); 	

		$('#hapusKegiatan').on('show.bs.modal', function (e) {
		    var myID = $(e.relatedTarget).attr('data-id');
		    var myName = $(e.relatedTarget).attr('data-name');
		    $(".hapus_id").val(myID);
		    $(this).find('.hapus_name').text(myName.trim());
		});
		
		$('#uploadFile').on('show.bs.modal', function (e) {
		    var myID = $(e.relatedTarget).attr('data-id');
		    var name = $(e.relatedTarget).attr('data-name');
		    
		    $(".id_kegiatan").val(myID);
		    $(".nama_kegiatan").val(name);
		    
		});
		
		$('#unduhFile').on('show.bs.modal', function (e) {
		    var myID = $(e.relatedTarget).attr('data-id');
		    $(".id_kegiatan").val(myID);
		    
		});
		
		
		$(function() {
		    
		    $('#table_kegiatan').DataTable( {
		    	//scrollY:        "300px",
		        //scrollX:        true,
		        //scrollCollapse: true,
		        responsive: {
		            details: {
		                renderer: $.fn.dataTable.Responsive.renderer.tableAll( {
		                    tableClass: 'table'
		                } )
		            }
		        }
		    } );
		} );
		

		/*
		$(function() {
		    $('#datatable-responsive2').DataTable( {
		    	scrollY:        "300px",
		        scrollX:        true,
		        scrollCollapse: true,
		        //columns: [{width: '10px'}, {width: '30px'}, {width: '40px'}, {width: '10px'}],
		        responsive: {
		            details: {
		                renderer: $.fn.dataTable.Responsive.renderer.tableAll( {
		                    tableClass: 'table'
		                } )
		            }
		        }
		    } );
		} );
		*/
		
		$('#tampil').click(function(){
			var id = $(this).attr('data-button');
			
			alert(id);
			$.ajax({
				type: "POST",
				url : "KegiatanTahapan/FilePME",
				data: {id:id},
					success: function(msg){
						//alert(yearfrom);
						$('#table-search').html(msg);
					},
					error:function(){
						error('error request !');
					}
			});
		});
			
		

		//tambahan andry untuk buat paging sendiri via backend
		// Returns an array of maxLength (or less) page numbers
		// where a 0 in the returned array denotes a gap in the series.
		// Parameters:
		//   totalPages:     total number of pages
		//   page:           current page
		//   maxLength:      maximum size of returned array
		function getPageList(totalPages, page, maxLength) {
		    if (maxLength < 5) throw "maxLength must be at least 5";
		
		    function range(start, end) {
		        return Array.from(Array(end - start + 1), (_, i) => i + start); 
		    }
		
		    var sideWidth = maxLength < 9 ? 1 : 2;
		    var leftWidth = (maxLength - sideWidth*2 - 3) >> 1;
		    var rightWidth = (maxLength - sideWidth*2 - 2) >> 1;
		    if (totalPages <= maxLength) {
		        // no breaks in list
		        return range(1, totalPages);
		    }
		    if (page <= maxLength - sideWidth - 1 - rightWidth) {
		        // no break on left of page
		        return range(1, maxLength-sideWidth-1)
		            .concat([0])
		            .concat(range(totalPages-sideWidth+1, totalPages));
		    }
		    if (page >= totalPages - sideWidth - 1 - rightWidth) {
		        // no break on right of page
		        return range(1, sideWidth)
		            .concat([0])
		            .concat(range(totalPages - sideWidth - 1 - rightWidth - leftWidth, totalPages));
		    }
		    // Breaks on both sides
		    return range(1, sideWidth)
		        .concat([0])
		        .concat(range(page - leftWidth, page + rightWidth)) 
		        .concat([0])
		        .concat(range(totalPages-sideWidth+1, totalPages));
		}
		
		$(function () {
		    // Number of items and limits the number of items per page
		    //var numberOfItems = $("#jar .content").length;
			var numberOfItems = $("#tot_rec").val();
			//alert(numberOfItems);
		    var limitPerPage = 10;
		    // Total pages rounded upwards
		    var totalPages = Math.ceil(numberOfItems / limitPerPage);
		    // Number of buttons at the top, not counting prev/next,
		    // but including the dotted buttons.
		    // Must be at least 5:
		    var paginationSize = 7; 
		    var currentPage;
		
		    function showPage(whichPage) {
		    	//pagingListUpload(whichPage);
				if (whichPage < 1 || whichPage > totalPages) return false;
		        currentPage = whichPage;
		        
		        // Replace the navigation items (not prev/next):            
		        $(".pagination_upload li").slice(1, -1).remove();
		        getPageList(totalPages, currentPage, paginationSize).forEach( item => {
		            $("<li>").addClass("page-item")
		                     .addClass(item ? "current-page" : "disabled")
		                     .toggleClass("active", item === currentPage).append(
		                $("<a>").addClass("page-link").attr({
		                    href: "javascript:void(0)"}).text(item || "...")
		            ).insertBefore("#next-page");
		        });
		        // Disable prev/next when at first/last page:
		        $("#previous-page").toggleClass("disabled", currentPage === 1);
		        $("#next-page").toggleClass("disabled", currentPage === totalPages);
		        return true;
		    }
		
		    // Include the prev/next buttons:
		    $(".pagination_upload").append(
		        $("<li>").addClass("page-item").attr({ id: "previous-page" }).append(
		            $("<a>").addClass("page-link").attr({
		                href: "javascript:void(0)"}).text("Prev")
		        ),
		        $("<li>").addClass("page-item").attr({ id: "next-page" }).append(
		            $("<a>").addClass("page-link").attr({
		                href: "javascript:void(0)"}).text("Next")
		        )
		    );
		    // Show the page links
		    showPage(1);
		    pagingListUpload(1);
		
		    // Use event delegation, as these items are recreated later    
		    $(document).on("click", ".pagination_upload li.current-page:not(.active)", function () {
		        return pagingListUpload(+$(this).text());
		    });
		    $("#next-page").on("click", function () {
		        return pagingListUpload(currentPage+1);
		    });
		
		    $("#previous-page").on("click", function () {
		        return pagingListUpload(currentPage-1);
		    });
		});

		
		
		function pagingListUpload(pageidDMS){
			var search_fileupload = $("#search_fileupload").val();	
			//alert(search_fileupload);
			$.ajax({
				type: "POST",
				url : "<%=request.getContextPath()%>/PME/PagingListUpload",
				data: {pageidDMS:pageidDMS,search_fileupload:search_fileupload},
					success: function(msg){
						//$("#searchInput").val(searchInput);
						$('#table_upload').html(msg);
						if(search_fileupload != "" && pageidDMS == 1){
							var tot_recfilter = $("#tot_rec_filter").val(); 
							$("#tot_rec").val(tot_recfilter);
							showPage_filter(1);
							//$("#search_fileupload").val(search_fileupload);
							//showPage(1);
							//$(".pagination_upload").hide();
						}
						if(search_fileupload != "" && pageidDMS != 1 ){
							showPage_filter(pageidDMS);
						}
						if(search_fileupload == ""){
							showPage_filter(pageidDMS);
						}
						
						
					},
					error:function(){
						error('error request !');
					}
			});
		}

		function listUnduhFile(id_kegiatan){
			$.ajax({
				type: "POST",
				url : "<%=request.getContextPath()%>/PME/ListFilePme",
				data: {id_kegiatan:id_kegiatan},
					success: function(msg){
						//$("#searchInput").val(searchInput);
						$('#table_download').html(msg);
					},
					error:function(){
						error('error request !');
					}
			});
		}
		
	 </script>
	
	 <style>
	 	.nama_tahapan{
	 		font-weight: bold;
	 		color: black;
	 	}
	 	
	 	.pagination_upload {
		    display: inline-block;
		    padding-left: 0;
		    margin: 20px 0;
		    border-radius: 4px;
		}
		
		.pagination_upload > li {
		    display: inline;
		}
		
		.pagination_upload > li:first-child > a, .pagination_upload > li:first-child > span {
		    margin-left: 0;
		    border-top-left-radius: 4px;
		    border-bottom-left-radius: 4px;
		}
		.pagination_upload > .active > a, .pagination_upload > .active > span, .pagination_upload > .active > a:hover, .pagination_upload > .active > span:hover, .pagination_upload > .active > a:focus, .pagination_upload > .active > span:focus {
		    z-index: 3;
		    color: #fff;
		    cursor: default;
		    background-color: #337ab7;
		    border-color: #337ab7;
		}
		.pagination_upload > li > a, .pagination_upload > li > span {
		    position: relative;
		    float: left;
		    padding: 6px 12px;
		    margin-left: -1px;
		    line-height: 1.42857143;
		    color: #337ab7;
		    text-decoration: none;
		    background-color: #fff;
		    border: 1px solid #ddd;
		}

	 </style>
</html>
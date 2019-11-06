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
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<link rel="shortcut icon" href="<%=request.getContextPath()%>/assets/images/logo-login.png" type="image/x-icon">
		<title>Proyek ${projectName}</title>
		<jsp:include page="/WEB-INF/views/assets/style.jsp"></jsp:include>
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
		<style id="antiClickjack">
	        body
	        {
	            display:none !important;
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
                  					<div class="col-md-6">
                  						<h4><a href="<%=request.getContextPath()%>/PME/ViewProjectPME_dashboard?id=${projectIDPME}"  > Proyek ${projectNamePME} </a></h4>
                  					</div>
                  					<c:if test="${allowed || level > 2}">
                  					<div class="nav navbar-right panel_toolbox">
                  						<button class="btn btn-primary" data-toggle="modal" data-target="#editeProyek">
			   										<i class="fa "> Edit Proyek</i>
										</button>
                  					</div>	
                  					</c:if>
                				</div>
                				<div class="row x_title">
                  					<label id="nav"><a href="<%=request.getContextPath()%>/Home">Home</a></label> / 
                					<label id="nav"><a href="<%=request.getContextPath()%>/PME">Proyek</a></label> /
	                					<c:forEach items="${projectNamePME}" var="proyek">
		                					   <label id="nav"><a href="<%=request.getContextPath()%>/PME/ViewProjectPME?id=${projectIDPME}"  > ${projectNamePME} </a>
		                					   </label>
                					   </c:forEach> 
                				</div>
                				
                				<div class="row x_title">
                  					<div class="col-md-6">
                    					<h4>Tahapan Pengadaan KPBU</h4>
                  					</div>
                				</div>
                				
                				<div class="col-md-12 col-sm-12 col-xs-12">                				  	
                				  	<table id="datatable2" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
								         <thead>
									         <tr>
									            <th class="sorting_disabled" rowspan="1" colspan="1" style="width: 5%;">No</th>
												<th class="sorting_disabled" rowspan="1" colspan="1" style="width: 55%;">Name</th>
												<th class="sorting_disabled" rowspan="1" colspan="1" style="width: 20%;">Status</th>
												<th class="sorting_disabled" rowspan="1" colspan="1" style="width: 20%;">Opsi</th></tr>
									         </tr>
									      </thead>
									      <tbody>
													
									<c:forEach items="${listTahapan}" var="tahapan" begin="0" end="0" varStatus="loop">
										<sql:query dataSource="${dbPME}" var="result">
											select * from jenis_tahapan where id_tahapan = ?
											<sql:param value="${tahapan.idTahapan}" />
										</sql:query>
										
										<c:set var="totalPercentage" value="${0}"/>
										<c:set var="totalJenisTahapan" value="${result.rowCount}"/>
										
										<c:forEach var="row" items="${result.rows}">
											
											<sql:query dataSource="${dbPME}" var="result2">
												select ((select 100*count(status) from kegiatan_pme where  status = '1'  AND id_jenis_tahapan = ?)+(select 50*count(status) from kegiatan_pme where status = '2'  AND id_jenis_tahapan = ?))/count(status) as persentase from kegiatan_pme WHERE id_jenis_tahapan = ?
												<sql:param value="${row.id_jenis_tahapan}" />
												<sql:param value="${row.id_jenis_tahapan}" />
												<sql:param value="${row.id_jenis_tahapan}" />
											</sql:query>
											
											<c:forEach  var="row2" items="${result2.rows}">
												<c:set var="totalPercentage" value="${totalPercentage + row2.persentase}"/>
											</c:forEach>
										</c:forEach>										
										
										<tr>
							               <td width="5%"><c:out value="${loop.index+1}"/></td>
							               <td><c:out value="${tahapan.namaTahapan}"/></td>
							               <c:choose>
							               		<c:when test="${(totalPercentage != null && totalPercentage > 0)}">
							               			<td><fmt:formatNumber type = "percent" pattern = "#0.##" value="${totalPercentage/totalJenisTahapan}"/>%</td>
							               		</c:when>
							               		<c:otherwise>
							               			<td>N/A</td>
							               		</c:otherwise>
							               </c:choose>
							               
							               			<td> 
							               				<c:choose>
									               			<c:when test="${level == 1}">
											               			<a data-toggle="tooltip" data-placement="top" class="btn btn-xs btn-warning"
															href="<%=request.getContextPath()%>/PME/ViewJenisTahapan?id=${tahapan.idTahapan}&name=${tahapan.namaTahapan}">Lihat Tahapan</a>	

															</c:when>
															<c:otherwise>
																	<a data-toggle="tooltip" data-placement="top" class="btn btn-xs btn-warning"
															href="<%=request.getContextPath()%>/PME/ViewJenisTahapan?id=${tahapan.idTahapan}&name=${tahapan.namaTahapan}">Manage Tahapan</a>	
																		
															</c:otherwise>
									               		</c:choose>
									               		
									               	</td>
							            </tr>
									</c:forEach>
									</tbody>
								   </table>
                				  	
                				</div>
                				
                				
                				<div class="row x_title">
                  					<div class="col-md-6">
                    					<h4>Fasilitas Dan Dukungan Pemerintah</h4>
                  					</div>
                				</div>
                				
    <!-- Pemisah Div atas dengan bawah -->	
                				<div class="col-md-12 col-sm-12 col-xs-12">                				  	
                				  	<table id="datatable2" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
								         <thead>
									         <tr>
									            <th class="sorting_disabled" rowspan="1" colspan="1" style="width: 5%;">No</th>
												<th class="sorting_disabled" rowspan="1" colspan="1" style="width: 55%;">Name</th>
												<th class="sorting_disabled" rowspan="1" colspan="1" style="width: 20%;">Status</th>
												<th class="sorting_disabled" rowspan="1" colspan="1" style="width: 20%;">Opsi</th></tr>
									         </tr>
									      </thead>
									      <tbody>
													
									<c:forEach items="${listTahapan}" var="tahapan" begin="1" end="${listTahapan.size()}" varStatus="loop">
										<sql:query dataSource="${dbPME}" var="result">
											select * from jenis_tahapan where id_tahapan = ?
											<sql:param value="${tahapan.idTahapan}" />
										</sql:query>
										
										<c:set var="totalPercentage" value="${0}"/>
										<c:set var="totalJenisTahapan" value="${result.rowCount}"/>
										
										<c:forEach var="row" items="${result.rows}">
											
											<sql:query dataSource="${dbPME}" var="result2">
												select ((select 100*count(status) from kegiatan_pme where  status = '1'  AND id_jenis_tahapan = ?)+(select 50*count(status) from kegiatan_pme where status = '2'  AND id_jenis_tahapan = ?))/count(status) as persentase from kegiatan_pme WHERE id_jenis_tahapan = ?
												<sql:param value="${row.id_jenis_tahapan}" />
												<sql:param value="${row.id_jenis_tahapan}" />
												<sql:param value="${row.id_jenis_tahapan}" />
											</sql:query>
											
											<c:forEach  var="row2" items="${result2.rows}">
												<c:set var="totalPercentage" value="${totalPercentage + row2.persentase}"/>
											</c:forEach>
										</c:forEach>										
										
										<tr>
							               <td width="5%"><c:out value="${loop.index}"/></td>
							               <td><c:out value="${tahapan.namaTahapan}"/></td>
							               <c:choose>
							               		<c:when test="${(totalPercentage != null && totalPercentage > 0)}">
							               			<td><fmt:formatNumber type = "percent" pattern = "#0.##" value="${totalPercentage/totalJenisTahapan}"/>%</td>
							               		</c:when>
							               		<c:otherwise>
							               			<td>N/A</td>
							               		</c:otherwise>
							               </c:choose>
							               
							              
							               			<td> 
														<c:choose>
				                  							<c:when test="${tahapan.isActive > 0}">
				                  								<c:choose>
											               			<c:when test="${level == 1}">
													               			<a data-toggle="tooltip" data-placement="top" class="btn btn-xs btn-warning"
																		href="<%=request.getContextPath()%>/PME/ViewJenisTahapan?id=${tahapan.idTahapan}&name=${tahapan.namaTahapan}">Lihat Fasilitas</a>
		
																	</c:when>
																	<c:otherwise>
																			<a data-toggle="tooltip" data-placement="top" class="btn btn-xs btn-warning"
																		href="<%=request.getContextPath()%>/PME/ViewJenisTahapan?id=${tahapan.idTahapan}&name=${tahapan.namaTahapan}">Manage Fasilitas</a>
																				
																	</c:otherwise>
										               			</c:choose>
																
																<c:if test="${level > 1 && allowed}">
																<a data-toggle="modal" class="btn btn-xs btn-warning"
																	data-target="#disableEnableTahapan_${tahapan.idTahapan}">Disable</a>	
																<c:set var="disabletahapn" value="${0}"/>        
																</c:if>          							
				                  							</c:when>
				                  							<c:otherwise>
				                  								<c:choose>
											               			<c:when test="${level == 1}">
													               			<a data-toggle="tooltip" data-placement="top" class="btn btn-xs btn-warning disabled"
																			href="<%=request.getContextPath()%>/PME/ViewJenisTahapan?id=${tahapan.idTahapan}&name=${tahapan.namaTahapan}">Lihat Fasilitas</a>
		
																	</c:when>
																	<c:otherwise>
																			<a data-toggle="tooltip" data-placement="top" class="btn btn-xs btn-warning disabled"
																			href="<%=request.getContextPath()%>/PME/ViewJenisTahapan?id=${tahapan.idTahapan}&name=${tahapan.namaTahapan}">Manage Fasilitas</a>
																				
																	</c:otherwise>
										               			</c:choose>
				                  								
				                  								<c:if test="${level > 1 && allowed}">
				                  								<a data-toggle="modal" class="btn btn-xs btn-warning"
																	data-target="#disableEnableTahapan_${tahapan.idTahapan}">Enable</a>
																<c:set var="disabletahapn" value="${1}"/>
																</c:if> 
				                  							</c:otherwise>
				                  						</c:choose>
									               	</td>
							            </tr>
									 <!-- form edit -->
												<div id="editeProyek" class="modal fade " tabindex="-1" role="dialog" aria-hidden="true">
													<div class="modal-dialog">
														<div class="modal-content">
															<form action="EditeProyekPME" method="POST" role="form" id="edit_proyek_pme">
																<input type="hidden" name="id_proyek_dms" value="11">
																<div class="modal-header">
																	<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span>
																	</button>
																	<h4 class="modal-title" id="myModalLabel">Edit Proyek</h4>
																</div>
																<div class="modal-body">
																	<input type="hidden" name="id_proyek" value="${projectIDPME}"/>
																	<div class="form-group">
																		<label for="">Project Name</label>
																		<input type="text" class="form-control" name="proyek_name"  value="${projectNamePME}" required>
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
							            <!-- Disable Enable Tahapan-->
												<div class="modal fade" id="disableEnableTahapan_${tahapan.idTahapan}" tabindex="-1" role="dialog" aria-labelledby="myModalLabe2" aria-hidden="true">
				    								<div class="modal-dialog">
				        								<div class="modal-content">
				            								<div class="modal-header">
				                								<button type="button" class="close" data-dismiss="modal">
				                       								<span aria-hidden="true">&times;</span>
				                       								<span class="sr-only">Close</span>
				                								</button>
				                								<h4 class="modal-title" id="myModalLabe2">Disable Enable Fasilitas</h4>
				            								</div>
				            								
				            								<div class="modal-body">
				                								<form role="form" action="DisableEnableTahapan" method="post" id="disableTahapan">
				                									<input type="hidden" name="id_tahapan" value="${tahapan.idTahapan}"/>
				                									<input type="hidden" name="nama_tahapan" value="${tahapan.namaTahapan}"/>
				                									<input type="hidden" name="id_proyek" value="${projectIDPME}"/>
				                									<c:choose>
				                  									<c:when test="${tahapan.isActive > 0}">
							            								<div class="modal-body">
							            									Apakah anda yakin ingin disable fasilitas?
															            </div>
															            <input type="hidden" name="disabletahapn" value="${0}"/>
														            </c:when>
														            <c:otherwise>
														            	<div class="modal-body">
							            									Apakah anda yakin ingin enable fasilitas?
															            </div>
															            <input type="hidden" name="disabletahapn" value="${1}"/>
														            </c:otherwise>
														            </c:choose>
														            <div class="modal-footer">
														                <button type="button" class="btn btn-default"
														                        data-dismiss="modal">
														                            Close
														                </button>
														                <input type="submit" value="Ya" class="btn btn-primary">
														            </div>
				                								</form>   
												            </div>
												        </div>
												    </div>
												</div>
							            
									</c:forEach>
									</tbody>
								   </table>
                				  	
                				</div>
                				
                				<div class="clearfix"></div>  
              				</div>
              				
            			</div>
          			</div>
          			<br />
        		</div>
      		</div>
     	</div>
     	<jsp:include page="/WEB-INF/views/assets/script.jsp"></jsp:include>
     		<script>
	    if(self === top)
	    {
	        var antiClickjack = document.getElementById("antiClickjack");
	        antiClickjack.parentNode.removeChild(antiClickjack);
	    }
	    else
	    {
	        top.location = self.location;
	    }
	</script>
	</body>
	

	<script type="text/javascript">
	$(document).ready(function() {
        $('#datatable2').DataTable( {
            "paging":   false,
            "ordering": false,
            "info":     false,
            "searching": false
        } );
    } );

			$(document).on('submit', "#edit_proyek_pme", function(e) {
		        e.preventDefault();
		     	var urlForm = $(this).attr('action');
		      	var dataForm = $(this).serialize();
		      	var name = this.proyek_name.value;
		      	var id = this.id_proyek.value;
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
		        if(name == ""){
					alert("Nama proyek tidak boleh kosong");
				}else if (xss){
	    			alert("Inputan tidak bisa mengandung karakter spesial ex: <, >, #...");
	    		}else{
					$.ajax({  
			            url: urlForm,
			            type: "post",  
			            data: dataForm,
			            error:function(){
			                alert("ERROR : CANNOT CONNECT TO SERVER");
			            },
			            success: function(data) {
			            	alert("berhasil edit proyek");
			                window.location.reload();
			            }
			        });
				} 
		    });



			$(document).on('submit', "#disableTahapan", function(e) {
		        e.preventDefault();
		        $.ajax({  
		            url: $(this).attr('action'),
		            type: "post",  
		            data: $(this).serialize(),
		            error:function(){
		                alert("ERROR : CANNOT CONNECT TO SERVER");
		            },
		            success: function(data) {
		            	alert("tahapan berhasil di disabled/enabled");
		                window.location.reload();
		            }
		        });
		    });
	</script>

</html>


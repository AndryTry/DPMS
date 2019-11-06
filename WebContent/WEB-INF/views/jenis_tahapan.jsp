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
		<title>Jenis Tahapan</title>
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
                   					<h2><a href="<%=request.getContextPath()%>/PME/ViewProjectPME_dashboard?id=${projectIDPME}"  > ${projectNamePME} </a></h2>
                  					<c:if test="${level != 1}">
                  					<div class="nav navbar-right panel_toolbox">
												<a class="btn btn-primary" data-toggle="modal" href="#tambah_tahapan">
												<i class="fa fa-plus"></i> Tambah Tahapan</a>					
									</div>
									</c:if>
                				</div>
                				<div class="row x_title">
                  					<label id="nav"><a href="<%=request.getContextPath()%>/Home">Home</a></label> / 
                					<label id="nav"><a href="<%=request.getContextPath()%>/PME">Proyek</a></label> /
	                					   <label id="nav"><a href="<%=request.getContextPath()%>/PME/ViewProjectPME?id=${projectIDPME}"  > ${projectNamePME} </a>
	                					   </label> /
                					<c:forEach items="${namaTahapan}" var="tahapan">
	                					   <label id="nav"><a href="<%=request.getContextPath()%>/PME/ViewJenisTahapan?id=${idTahapan}&name=${namaTahapan}"  > ${namaTahapan} </a>
	                					   </label>
                					</c:forEach>
                				</div>
                				
                				<!-- form tambah jenis tahapan -->
								<div class="modal fade" id="tambah_tahapan">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-header">
												<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
												<h4 class="modal-title">Tambah Tahapan</h4>
											</div>
											
												<input type="hidden" name="id_tahapan" id="addIdTahapan" value="${idTahapan}"/>
												<input type="hidden" name="nama_tahapan" id="addNamaTahapan" value="${namaTahapan}"/>
												<div class="modal-body">
													<div class="form-group">
														<label>Nama Tahapan</label>
														<input type="text" name="nama_jenis_tahapan" id="addNamaJenisTahapan" required class="form-control">
													</div>
												</div>
												<div class="modal-footer">
													<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
													<button type="submit" class="btn btn-success" onclick="AddJT()">Tambah</button>
												</div>
											
											
										</div>
									</div>
								</div>
								
                				<div class="col-md-12 col-sm-12 col-xs-12">                				  	
                				  	<table id="datatable-responsive" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
								         <thead>
									         <tr>
									            <th>No</th>
									            <th>Name</th>
									            <th>Status</th>
									            <th>Opsi</th>
									         </tr>
									      </thead>
									      <tbody>
													
											<c:forEach items="${jenisTahapan}" var="jenis" begin="0" end="${jenisTahapan.size()}" varStatus="loop">
												<sql:query dataSource="${dbPME}" var="result">
													select ((select 100*count(status) from kegiatan_pme where  status = '1'  AND id_jenis_tahapan = ?)+(select 50*count(status) from kegiatan_pme where status = '2'  AND id_jenis_tahapan = ?))/count(status) as persentase from kegiatan_pme WHERE id_jenis_tahapan = ?
													<sql:param value="${jenis.idJenisTahapan}" />
													<sql:param value="${jenis.idJenisTahapan}" />
													<sql:param value="${jenis.idJenisTahapan}" />
												</sql:query>
												<c:forEach  var="row" items="${result.rows}">
													<c:set var="percentage" value="${row.persentase}"/>
												</c:forEach>
											<tr>
									               <td><c:out value="${loop.index+1}"/></td>
									               <td><c:out value="${jenis.namaJenisTahapan}"/></td>
									               <c:choose>
									               		<c:when test="${(percentage != null && percentage > 0)}">
									               			<td><fmt:formatNumber type = "percent" pattern = "#0.##" value="${percentage}"/>%</td>
									               		</c:when>
									               		<c:otherwise>
									               			<td>N/A</td>
									               		</c:otherwise>
									               </c:choose>
									               
									               <td> 
									               		<c:choose>
									               			<c:when test="${jenis.disableEnabled.equals('enabled')}">
									               				<c:choose>
									               					<c:when test="${level == 1}">
											               				<a data-toggle="tooltip" data-placement="top" class="btn btn-xs btn-warning"
																			href="<%=request.getContextPath()%>/PME/KegiatanTahapan?id=
																			${jenis.idJenisTahapan}&nama=${projectNamePME}&nama_jenis=${jenis.namaJenisTahapan}&name=${namaTahapan}&id_tahap=${idTahapan}">Lihat</a>
																	</c:when>
																	<c:otherwise>
																		<a data-toggle="tooltip" data-placement="top" class="btn btn-xs btn-warning"
																			href="<%=request.getContextPath()%>/PME/KegiatanTahapan?id=
																			${jenis.idJenisTahapan}&nama=${projectNamePME}&nama_jenis=${jenis.namaJenisTahapan}&name=${namaTahapan}&id_tahap=${idTahapan}">Manage</a>
																	</c:otherwise>
									               				</c:choose>
																	
												              <!--  <a data-toggle="modal" class="btn btn-xs btn-warning"
																	data-target="#editJenisTahapan_${jenis.idJenisTahapan}">Edit</a>
																	
															   <a data-toggle="modal" class="btn btn-xs btn-warning"
																	data-target="#hapusJenisTahapan_${jenis.idJenisTahapan}">Hapus</a> -->
									               			</c:when>
									               			<c:otherwise>
									               				<c:choose>
									               					<c:when test="${level == 1}">
											               				<a data-toggle="tooltip" data-placement="top" class="btn btn-xs btn-warning disabled"
																	href="<%=request.getContextPath()%>/PME/KegiatanTahapan?id=
																	${jenis.idJenisTahapan}&nama=${projectNamePME}&nama_jenis=${jenis.namaJenisTahapan}&name=${namaTahapan}&id_tahap=${idTahapan}">Lihat</a>

																	</c:when>
																	<c:otherwise>
																		<a data-toggle="tooltip" data-placement="top" class="btn btn-xs btn-warning disabled"
																	href="<%=request.getContextPath()%>/PME/KegiatanTahapan?id=
																	${jenis.idJenisTahapan}&nama=${projectNamePME}&nama_jenis=${jenis.namaJenisTahapan}&name=${namaTahapan}&id_tahap=${idTahapan}">Manage</a>
																		
																	</c:otherwise>
									               				</c:choose>
											           			
																	
												                   			
									               			</c:otherwise>
									               		</c:choose>
									               	<c:if test="${(level > 1 && jenis.id_user == user_id) || allowed ||level > 2}">
										               <a data-toggle="modal" class="btn btn-xs btn-warning"
																	data-target="#editJenisTahapan"
																	data-id="<c:out value="${jenis.idJenisTahapan}"/>"
																	data-name="<c:out value="${jenis.namaJenisTahapan}"/>">Edit</a>
																	
													   <a data-toggle="modal" class="btn btn-xs btn-warning"
																	data-target="#hapusJenisTahapan"
																	data-id="<c:out value="${jenis.idJenisTahapan}"/>"
																	data-name="<c:out value="${jenis.namaJenisTahapan}"/>">Hapus</a>
													</c:if>
														
													<!-- <a class="btn btn-xs btn-warning" data-toggle="modal" 
														data-target="#updateProgress" data-id="<c:out value="${jenis.idJenisTahapan}"/>"
														data-progress="<c:out value="${jenis.status}"/>">Update Progress</a> -->
									               </td>
									            </tr>
																					
												<!-- Edit Jenis Tahapan-->
												<div class="modal fade" id="editJenisTahapan" tabindex="-1" role="dialog" aria-labelledby="myModalLabe2" aria-hidden="true">
				    								<div class="modal-dialog">
				        								<div class="modal-content">
				            								<div class="modal-header">
				                								<button type="button" class="close" data-dismiss="modal">
				                       								<span aria-hidden="true">&times;</span>
				                       								<span class="sr-only">Close</span>
				                								</button>
				                								<h4 class="modal-title" id="myModalLabe2">Edit Tahapan</h4>
				            								</div>
				            								<div class="modal-body">
				                									
				                									<input type="hidden" name="id_jenis_tahapan" id="editIdJenisTahapan" class="form-control id_edit"/>
				                									<input type="hidden" name="id_tahapan" id="editIdTahapan" value="${idTahapan}"/>
				                									<input type="hidden" name="nama_tahapan" id="editNamaTahapan" value="${namaTahapan}"/>
				                									
				                  									<div class="form-group">
				                  										<label for="">Nama Tahapan</label>
				                  										<input type="text" class="form-control name_edit" id="editNamaJenisTahapan" name="name" placeholder="Name" required/>
				                  									</div>
				                  									
														            <div class="modal-footer">
														                <button type="button" class="btn btn-default"
														                        data-dismiss="modal">
														                            Close
														                </button>
														                <input type="submit" value="Save changes" onclick="editJT()" class="btn btn-primary">
														            </div>
				                								 
												            </div>
												        </div>
												    </div>
												</div>
												
												<!-- Edit Hapus Jenis Tahapan-->
												<div class="modal fade" id="hapusJenisTahapan" tabindex="-1" role="dialog" aria-labelledby="myModalLabe2" aria-hidden="true">
				    								<div class="modal-dialog">
				        								<div class="modal-content">
				            								<div class="modal-header">
				                								<button type="button" class="close" data-dismiss="modal">
				                       								<span aria-hidden="true">&times;</span>
				                       								<span class="sr-only">Close</span>
				                								</button>
				                								<h4 class="modal-title" id="myModalLabe2">Hapus Tahapan</h4>
				            								</div>
				            								<div class="modal-body">
				                									<input type="hidden" name="id_jenis_tahapan" id="hapusIdJenisTahapan" class="form-control hapus_id"/>
				                									<input type="hidden" name="id_tahapan" id="hapusIdTahapan" value="${idTahapan}"/>
				                									<input type="hidden" name="nama_tahapan" id="hapusNamaTahapan" value="${namaTahapan}"/>
				                									
				                  									Apakah anda yakin ingin menghapus tahapan "<span class="hapus_jenis_tahapan"></span>" ?
				                  									
														            <div class="modal-footer">
														                <button type="button" class="btn btn-default"
														                        data-dismiss="modal">
														                            TIDAK
														                </button>
														                <input type="submit" value="HAPUS" class="btn btn-primary" onclick="deleteJT()">
														            </div>
												            </div>
												        </div>
												    </div>
												</div>
									            
									            <!-- Update Progress 
												<div class="modal fade" id="updateProgress" tabindex="-1" role="dialog" aria-labelledby="myModalLabe2" aria-hidden="true">
				    								<div class="modal-dialog">
				        								<div class="modal-content">
				            								<div class="modal-header">
				                								<button type="button" class="close" data-dismiss="modal">
				                       								<span aria-hidden="true">&times;</span>
				                       								<span class="sr-only">Close</span>
				                								</button>
				                								<h4 class="modal-title" id="myModalLabe2">Update Progress</h4>
				            								</div>
				            								<div class="modal-body">
				                								<form role="form" action="UpdateProgress" method="post" id="save" name="updateprogress" onsubmit="return validateForm()">
				                									<input type="hidden" class="form-control id_jenis_tahapan" name="id_jenis_tahapan"/>
				                									<input type="hidden" name="projectName" value="${projectName}"/>
				                									<input type="hidden" name="id_tahapan" value="${idTahapan}"/>
				                									
				                  									<div class="form-group">
				                    									<input type="number" class="form-control status" value="<span class='status'></span>" name="status" placeholder="Update Progress" required="required"/>
				                  									</div>
				                  									
														            <div class="modal-footer">
														                <button type="button" class="btn btn-default"
														                        data-dismiss="modal">
														                            Close
														                </button>
														                <input type="submit" value="Save changes" class="btn btn-primary" onclick="form_submit()">
														            </div>
				                								</form>   
												            </div>
												        </div>
												    </div>
												</div>-->
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
	</body>
	<script>
	
		function form_submit() {
	    	document.getElementById("save").submit();
	   	}  
	   	
	   	$('#editJenisTahapan').on('show.bs.modal', function (e) {
		    var id = $(e.relatedTarget).attr('data-id');
		    var name = $(e.relatedTarget).attr('data-name');
		    $(".id_edit").val(id);
		    $(".name_edit").val(name);
		});
	   	
	   	$('#hapusJenisTahapan').on('show.bs.modal', function (e) {
		    var id = $(e.relatedTarget).attr('data-id');
		    var name = $(e.relatedTarget).attr('data-name');
		    $(".hapus_id").val(id);
		    $(this).find('.hapus_jenis_tahapan').text(name.trim());
		});
		
	
		$('#updateProgress').on('show.bs.modal', function (e) {
		    var myID = $(e.relatedTarget).attr('data-id');
		    var myStatus = $(e.relatedTarget).attr('data-progress');
		    $(".id_jenis_tahapan").val(myID);
		    $(".status").val(myStatus);
		});
		
		function AddJT(){
	   		var name = $("#addNamaJenisTahapan").val();
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
	   			alert('Nama jenis tahapan tidak boleh kosong.');
	   		}else if (xss){
				alert("Inputan tidak bisa mengandung karakter spesial ex: <, >, #...");
			}else{
	   			$.ajax({
					type: "POST",
					url : "<%=request.getContextPath()%>/PME/CheckJT",
					data: {name:name,id_tahapan:$("#addIdTahapan").val()},
						success: function(data){
							if(data == "true"){
								alert("Jenis tahapan ini sudah ada.");
							}else{
								$.ajax({
									type: "POST",
									url : "<%=request.getContextPath()%>/PME/TambahJenisTahapan",
									data: {id_tahapan:$("#addIdTahapan").val(),nama_jenis_tahapan:$("#addNamaJenisTahapan").val(),nama_tahapan:$("#addNamaTahapan").val()},
										success: function(data){
											alert('Berhasil menambah jenis tahapan baru.');
											window.location.reload();
										},
										error:function(){
											error('Gagal menambah jenis tahapan baru.');
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
		
		function editJT(){
	  		var name = $("#editNamaJenisTahapan").val();
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
	  			alert('Nama tahapan tidak boleh kosong.');
	  		}else if (xss){
				alert("Inputan tidak bisa mengandung karakter spesial ex: <, >, #...");
			}else{
	  			$.ajax({
	  				type: "POST",
	  				url : "<%=request.getContextPath()%>/PME/CheckJT",
	  				data: {name:name,id_tahapan:$("#editIdTahapan").val()},
	  					success: function(data){
	  						if(data == "true"){
	  							alert("Jenis tahapan ini sudah ada.");
	  						}else{
	  							$.ajax({
	  								type: "POST",
	  								url : "<%=request.getContextPath()%>/PME/EditJenisTahapan",
	  								data: {name:name,id_jenis_tahapan:$("#editIdJenisTahapan").val(),id_tahapan:$("#editIdTahapan").val(),nama_tahapan:$("#editNamaTahapan").val()},
	  									success: function(data){
	  										alert('Berhasil Mengubah Jenis Tahapan.');
	  										window.location.reload();
	  									},
	  									error:function(){
	  										error('Gagal Mengubah Jenis Tahapan.');
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
		
		function deleteJT(){
	   		$.ajax({
				type: "POST",
				url : "<%=request.getContextPath()%>/PME/HapusTahapan",
				data: {id_jenis_tahapan:$("#hapusIdJenisTahapan").val(),id_tahapan:$("#hapusIdTahapan").val(),nama_tahapan:$("#hapusNamaTahapan").val()},
					success: function(data){
						alert('Jenis tahapan berhasil dihapus.');
						window.location.reload();
					},
					error:function(){
						error('Jenis tahapan gagal dihapus.');
					}
			});	
	   	}
	</script>
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
</html>


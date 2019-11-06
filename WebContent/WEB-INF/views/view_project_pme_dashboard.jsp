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
		<link href="<%=request.getContextPath()%>/assets/summernote/dist/summernote.css" rel="stylesheet" type="text/css" />
		
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
                  					<div>
                    					<center><h4>Proyek ${projectNamePME}</h4></center>
                  					</div>
                				</div>
								
								<div>
									<c:forEach items="${listTahapan}" var="tahapan" begin="0" end="${listTahapan.size()}" varStatus="loop">
										<sql:query dataSource="${dbPME}" var="result">
											select a.*, b.is_active from jenis_tahapan a, tahapan_pme b where a.id_tahapan=? and b.id_tahapan = a.id_tahapan and b.is_active='1'
											<sql:param value="${tahapan.idTahapan}" />
										</sql:query>	
										
										<c:set var="totalJenisTahapan" value="${result.rowCount}"/>
										<c:set var="totalPercentage" value="${0}"/>
										
										<c:if test="${loop.index == 1}">
											<div class="judul">Fasilitas Dan Dukungan Pemerintah</div>
										</c:if>
										
										
										<c:forEach var="row" items="${result.rows}">											
											<sql:query dataSource="${dbPME}" var="resultPercentageTahapan">
												select ((select 100*count(status) from kegiatan_pme where  status = '1'  AND id_jenis_tahapan = ?)+(select 50*count(status) from kegiatan_pme where status = '2'  AND id_jenis_tahapan = ?))/count(status) as persentase from kegiatan_pme WHERE id_jenis_tahapan = ?
												<sql:param value="${row.id_jenis_tahapan}" />
												<sql:param value="${row.id_jenis_tahapan}" />
												<sql:param value="${row.id_jenis_tahapan}" />
											</sql:query>
											
											<c:forEach  var="row3" items="${resultPercentageTahapan.rows}">
												<c:set var="totalPercentage" value="${totalPercentage + row3.persentase}"/>
											</c:forEach>
										</c:forEach>
										
										
										<c:choose>
											<c:when  test="${loop.index == 0}">
												<div style="float: none; clear: left;" class="judul">
													<c:out value="${tahapan.namaTahapan}"/> 
													<c:choose>
							                            <c:when test="${totalJenisTahapan > 0}">
							                              (<fmt:formatNumber type = "percent" pattern = "#0.##" value="${totalPercentage/totalJenisTahapan}"/>%) &nbsp;
							                            </c:when>
							                            <c:otherwise>
							                              (-%) &nbsp;
							                            </c:otherwise>
							                          </c:choose>
														<a class="btn btn-danger btn-xs"
															href="<%=request.getContextPath()%>/PME/ViewJenisTahapan?id=${tahapan.idTahapan}&name=${tahapan.namaTahapan}">
															<c:choose>
												               	<c:when test="${level == 1}">
												               			<i class="fa fa-eye"></i>
												               	</c:when>
												               	<c:otherwise>
														           		<i class="fa fa-pencil"></i>
												               	</c:otherwise>
												            </c:choose>
														</a>
												</div>
											</c:when>
											<c:otherwise>
												<div style="float: none; clear: left;">
													<c:out value="${tahapan.namaTahapan}"/> 
													<c:choose>
							                            <c:when test="${totalJenisTahapan > 0}">
							                              (<fmt:formatNumber type = "percent" pattern = "#0.##" value="${totalPercentage/totalJenisTahapan}"/>%) &nbsp;
							                            </c:when>
							                            <c:otherwise>
							                              (-%) &nbsp;
							                            </c:otherwise>
							                          </c:choose>
														<a class="btn btn-danger btn-xs"
															href="<%=request.getContextPath()%>/PME/ViewJenisTahapan?id=${tahapan.idTahapan}&name=${tahapan.namaTahapan}">
															<c:choose>
												               	<c:when test="${level == 1}">
												               			<i class="fa fa-eye"></i>	
												               	</c:when>
												               	<c:otherwise>
														           		<i class="fa fa-pencil"></i>
												               	</c:otherwise>
												            </c:choose>
														</a>
												</div>
											</c:otherwise>
										</c:choose>
										
									  	
										<c:forEach var="row" items="${result.rows}">
										
											<sql:query dataSource="${dbPME}" var="kegiatan">
												select ((select 100*count(status) from kegiatan_pme where  status = '1'  AND id_jenis_tahapan = ?)+(select 50*count(status) from kegiatan_pme where status = '2'  AND id_jenis_tahapan = ?))/count(status) as persentase from kegiatan_pme WHERE id_jenis_tahapan = ?
												<sql:param value="${row.id_jenis_tahapan}" />
												<sql:param value="${row.id_jenis_tahapan}" />
												<sql:param value="${row.id_jenis_tahapan}" />
											</sql:query>	
											<c:forEach  var="row2" items="${kegiatan.rows}">
												<c:set var="percentage" value="${row2.persentase}"/>
											</c:forEach>
											
											<div style="width: <c:out value="${100/totalJenisTahapan}%"/>; float: left;">
									        	<div class="progress" style="height: 30px; margin-bottom: 0px; background-color: #cccccc; border-radius: 0px;">
										            <div class="progress-bar" style="height: 30px; width:<c:out value="${percentage}"/>%; background-color: #307bbb; border-radius: 0px;">
										            </div><div class="vl"></div>
										   		</div>
										   		<c:choose>
									               	<c:when test="${row.disable.equals('enabled')}">
									               			<div class="name"><a href="<%=request.getContextPath()%>/PME/KegiatanTahapan?id=${row.id_jenis_tahapan}&nama=${projectNamePME}&nama_jenis=${row.nama_jenis}&name=${tahapan.namaTahapan}&id_tahap=${tahapan.idTahapan}"  > <c:out value="${row.nama_jenis}"/> </a></div>	
									               	</c:when>
									               	<c:otherwise>
											           		<div class="name"> <c:out value="${row.nama_jenis}"/></div>	
									               	</c:otherwise>
									            </c:choose>
									        	
											</div>
										</c:forEach>
										
										<c:choose>
											<c:when  test="${loop.index == 0}">
											<br/><br/><br/><br/><br/>
											</c:when>
											<c:otherwise>
											<br/><br/><br/>
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</div>
                				<br><br>
                				<div>
                					<div class="judul">Profil Proyek  
                						<c:if test="${allowed || level > 2}">
	           							<a data-toggle="tooltip" data-placement="top" title="Edit">
											<button class="btn btn-xs btn-warning" data-toggle="modal" 
												data-target="#editNilaiInventasi">
		   										<i class="fa fa-edit"></i>
											</button>
										</a>
										</c:if>
									</div><br>
									
                					<table border="1" cellpadding="0" cellspacing="0" width="100%">
	                					<c:forEach items="${listProject}" var="project" begin="0" end="${listProject.size()}">
	                						
	                						<!-- edit nilai inventasi -->
											<div class="modal fade" id="editNilaiInventasi">
												<div class="modal-dialog">
													<div class="modal-content">
														<div class="modal-header">
															<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
															<h4 class="modal-title">Edit Nilai Investasi</h4>
														</div>
														
															<div class="modal-body">
																<div class="form-group">
																	<label>Nilai Investasi</label>
																	<input type="text" name="nilai" id="nilai" required class="form-control" value="${project.nilaiInvestasi}">
																</div>
																
																<div class="form-group">
																	<label>PJPK</label>
																	<input type="text" name="pjpk" id="pjpk" required class="form-control" value="${project.pjpk}">
																</div>
																
																<div class="form-group">
																	<label>Area</label>
																	<input type="text" name="area" id="area" required class="form-control" value="${project.area}">
																</div>
																
																<div class="form-group">
																	<label for="">Sektor</label>
																	<select name="proyek_sektor"  id="sektor" class="form-control"  required>
																		<option value="">Pilih Sektor</option>
																		<c:forEach begin="0" items="${sektor}" var="sektor1" end="${sektor.size()}">
																			<c:set var="sektorValue" value="${sektor1.getNamaSektor()}"/>
																			<c:set var="sektorValueFromData" value="${project.sektor}"/>
																			<% 
				                      												String sektorValue = (String)pageContext.getAttribute("sektorValue");
																					String sektorValueFromData = (String)pageContext.getAttribute("sektorValueFromData");
																					
																					if (sektorValueFromData.equalsIgnoreCase(sektorValue)){%>
																						<option value="${sektor1.getIdSektor()}" selected>${sektor1.getNamaSektor()}</option><%																						
																					}else {%>
																						<option value="${sektor1.getIdSektor()}">${sektor1.getNamaSektor()}</option><%
																					}%>
				                      										%>
																			
																		</c:forEach>
																	</select>
																</div>

																<div class="form-group">
																	<label for="">Wilayah</label>
																	<select name="wilayah" id="wilayah" class="form-control"  required>
																		<option value="">Pilih Wilayah</option>
																		<c:forEach begin="0" items="${map}" var="map1" end="${map.size()}">
																			<c:set var="mapValue" value="${map1.getTitle()}"/>
																			<c:set var="mapValueFromData" value="${project.mapTitle}"/>
																			<% 
				                      												String mapValue = (String)pageContext.getAttribute("mapValue");
																					String mapValueFromData = (String)pageContext.getAttribute("mapValueFromData");
																					
																					if (mapValueFromData.equalsIgnoreCase(mapValue)){%>
																						<option value="${map1.getId()}" selected>${map1.getTitle()}</option><%																						
																					}else {%>
																						<option value="${map1.getId()}">${map1.getTitle()}</option><%
																					}%>
				                      										%>
																			
																		</c:forEach>
																	</select>
																</div>
															</div>
															<div class="modal-footer">
																<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
																<button type="submit" class="btn btn-success" onclick="editProfile()">Submit</button>
															</div>
														
													</div>
												</div>
											</div>
	                						
	                						<tr>
	                							<td width="20%" height="40px" align="center">Nilai Investasi</td>
	                							<td width="70%" colspan="2" height="40px" style="padding-left:20px"><c:out value="${project.nilaiInvestasi}"/></td>
	                																			
	                						</tr>
	                						<tr>
	                							<td width="20%" height="40px" align="center">PJPK</td>
	                							<td width="70%" colspan="2" height="40px" style="padding-left:20px"><c:out value="${project.pjpk}"/></td>
	                						</tr>
	                						<tr>
	                							<td width="20%" height="40px" align="center">Area</td>
	                							<td width="70%" colspan="2" height="40px" style="padding-left:20px"><c:out value="${project.area}"/></td>
	                						</tr>
	                						<tr>
	                							<td width="20%" height="40px" align="center">Sektor</td>
	                							<td width="70%" colspan="2" height="40px" style="padding-left:20px"><c:out value="${project.sektor}"/></td>
	                						</tr>
	                						<tr>
	                							<td width="20%" height="40px" align="center">Wilayah</td>
	                							<td width="70%" colspan="2" height="40px" style="padding-left:20px"><c:out value="${project.mapTitle}"/></td>
	                						</tr>
	                						
	                						<c:forEach items="${listColumn}" var="column" begin="0" end="${listColumn.size()}">
		                						<tr>
		                							<td width="20%" height="40px" align="center"><c:out value="${column.namaKolom}"/></td>
		                							<td width="70%" height="40px" style="padding-left:20px"><div class="showmore"><c:out value="${column.deskripsi}" escapeXml="false"/></div></td>
		                							<c:if test="${allowed || level > 2}">
		                							<td width="10%" height="40px" align="center">
			                							<a data-toggle="tooltip">
															<button class="btn btn-xs btn-warning" data-toggle="modal" 
																data-target="#editKolomBaru"
																data-id="<c:out value="${column.id}"/>"
																data-name="<c:out value="${column.namaKolom}"/>"
																data-deskripsi="<c:out value="${column.deskripsi}"/>">
					    										<i class="fa fa-edit"></i>
															</button>
														</a>
														<a data-toggle="tooltip">
															<button class="btn btn-xs btn-danger" data-toggle="modal" 
																data-target="#hapusKolomBaru"
																data-name="<c:out value="${column.namaKolom}"/>"
																data-id="<c:out value="${column.id}"/>">
					    										<i class="fa fa-trash"></i>
															</button>
														</a>
													</td>
													</c:if>													
		                						</tr>
		                						
		                						<!-- hapus kolom baru -->
												<div class="modal fade" id="hapusKolomBaru">
													<div class="modal-dialog">
														<div class="modal-content">
															<div class="modal-header">
																<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
																<h4 class="modal-title">Hapus Kolom Baru</h4>
															</div>
															<div class="modal-body">
				                									<input type="hidden" id="hapus_kolom" name="id_kolom" class="form-control hapus_id_kolom"/>
				                									
				                  									Apakah anda yakin ingin menghapus kolom "<span class="hapus_nama_kolom"></span>" ?
				                  									
														            <div class="modal-footer">
														                <button type="button" class="btn btn-default"
														                        data-dismiss="modal">
														                            Close
														                </button>
														                <input type="submit" value="Delete" class="btn btn-danger" onclick="deleteNewColumn()">
														            </div>
															</div>
														</div>
													</div>
												</div>
		                						
												<!-- edit kolom baru -->
												<div class="modal fade" id="editKolomBaru">
													<div class="modal-dialog">
														<div class="modal-content">
															<div class="modal-header">
																<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
																<h4 class="modal-title">Edit Kolom Baru</h4>
															</div>
																<input type="hidden" id="edit_id_kolom" name="id_kolom" class="form-control id_kolom"/>
																<div class="modal-body">
																	<div class="form-group">
																		<label>Nama Kolom</label>
																		<input type="text" name="nama" id="edit_name" required class="form-control nama_kolom" placeholder="Nama">
																	</div>
				
																	<div class="form-group">
																		<label>Deskripsi</label>
																		<input type="text" name="deskripsi" id="edit_description" required class="form-control deskripsi" placeholder="Deskripsi">
																	</div>
																	
																</div>
																<div class="modal-footer">
																	<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
																	<button type="submit" class="btn btn-success" onclick="editNewColumn()">Save Changes</button>
																</div>
														</div>
													</div>
												</div>
	                						</c:forEach>
	                					</c:forEach>                						
                					</table>
                					<br>
                					<c:if test="${allowed || level > 2}">
                					<button class="btn btn-primary" data-toggle="modal" 
										data-target="#kolomBaru">
   										<i class="fa fa-plus"></i> Tambah Baru
									</button>
									</c:if>
                				</div>
                				
                				<!-- form kolom baru -->
								<div class="modal fade" id="kolomBaru">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-header">
												<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
												<h4 class="modal-title">Tambah Kolom Baru</h4>
											</div>
											
												<div class="modal-body">
													<div class="form-group">
														<label>Nama Kolom</label>
														<input type="text" name="nama" id="add_name" required class="form-control" placeholder="Nama">
													</div>

													<div class="form-group">
														<label>Deskripsi</label>
														<input type="text" name="deskripsi" id="add_description" required class="form-control" placeholder="Deskripsi">
													</div>
													
												</div>
												<div class="modal-footer">
													<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
													<button type="submit" class="btn btn-success" onclick="addNewColumn()">Submit</button>
												</div>
											
											
										</div>
									</div>
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
     	<script type="text/javascript" src="<%=request.getContextPath()%>/assets/readmore/readmore.js"></script>
     	<script type="text/javascript" src="<%=request.getContextPath()%>/assets/summernote/dist/summernote.js"></script>     	
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
	<style>
		.vl {
		    border-left: 2px solid black;
		    height: 50px;
		    margin-bottom: 20px;
		    float: right;
		}
		
		.judul{
			font-size: 20px;
			font-weight: bold;
		}
	</style>
	
	<script>
	 	
		$('.showmore').readmore({
			speed: 300,
			collapsedHeight: 20,
			moreLink: '<a href="#">More</a>',
	        lessLink: '<a href="#">Less</a>'
		});
	
		$('[name=deskripsi]').summernote({
		  height: 180,
		  placeholder: 'Deskripsi',
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
		
		$('#kolomBaru').on('hidden.bs.modal', function (e) {
			  $(this)
			    .find("input,textarea")
			       .val('')
			       .end();
			  $('#add_description').summernote ('code', '');
		});
		
	 
		$('#editKolomBaru').on('show.bs.modal', function (e) {
		    var id = $(e.relatedTarget).attr('data-id');
		    var nama = $(e.relatedTarget).attr('data-name');
		    var deskripsi = $(e.relatedTarget).attr('data-deskripsi');
		    $(".id_kolom").val(id);
		    $(".nama_kolom").val(nama);
		    $('.deskripsi').summernote ('code', deskripsi);
		    //$(".deskripsi").val(deskripsi);
		});
		
		$('#hapusKolomBaru').on('show.bs.modal', function (e) {
		    var id = $(e.relatedTarget).attr('data-id');
		    var nama = $(e.relatedTarget).attr('data-name');
		    $(".hapus_id_kolom").val(id);
		    $(this).find('.hapus_nama_kolom').text(nama.trim());
		});
	
		function editProfile(){
			var nilai = $("#nilai").val();
	   		var pjpk = $("#pjpk").val();
	   		var area = $("#area").val();
	   		var sektor = $("#sektor").val();
	   		var wilayah = $("#wilayah").val();
	   		
	   		if (nilai == ""){
	   			alert('Nilai investasi tidak boleh kosong.');
	   		}else if (pjpk == ""){
	   			alert('PJPK tidak boleh kosong.');
	   		}else if (area == ""){
	   			alert('Area tidak boleh kosong.');
	   		}else if (sektor == ""){
	   			alert('Silahkan pilih sektor anda.');
	   		}else if (wilayah == ""){
	   			alert('Silahkan pilih wilayah anda.');
	   		}else{
				$.ajax({
					type: "POST",
					url : "<%=request.getContextPath()%>/PME/EditNilaiInvestasi",
					data: {nilai:nilai, proyek_sektor:sektor, pjpk:pjpk, area:area,wilayah:wilayah},
						success: function(data){
							alert('Profile proyek berhasil dirubah.');
							window.location.reload();
						},
						error:function(){
							error('Profile proyek gagal dirubah');
						}
				});			
			}
		}
		
		function addNewColumn(){
			var name = $("#add_name").val();
	   		var description = $("#add_description").summernote('code');
	   		//var arr = ["<", ">", "?", "[", "]", "{", "}", "&", "/", "'\'", "`", "^", "*", "#", "~", ";", ":", "|"];
          	/*
          	var xss = false;
           	for (var i=0; i < arr.length; i++) {
           		if (name.includes(arr[i])){
           			xss = true;
           			break;
           		}else if(description.includes(arr[i])){
           			xss = true;
           			break;
                }else {
           			xss = false;
           		}
           	}
	   		*/
           	
	   		if (name == ""){
	   			alert('Nama kolom tidak boleh kosong.');
	   		}else if (description == ""){
	   			alert('Deskripsi tidak boleh kosong.');
	   		//}else if (xss){
    		//	alert("Inputan tidak bisa mengandung karakter spesial ex: <, >, #...");
    		}else{
	   			$.ajax({
					type: "POST",
					url : "<%=request.getContextPath()%>/PME/CheckColumn",
					data: {name:name},
						success: function(data){
							if(data == "true"){
								alert("Kolom ini sudah ada.");
							}else{
								$.ajax({
									type: "POST",
									url : "<%=request.getContextPath()%>/PME/NewColumn",
									data: {nama:name, deskripsi:description},
										success: function(data){
											alert('Berhasil menambah kolom baru.');
											window.location.reload();
										},
										error:function(){
											error('Gagal menambah kolom baru.');
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
		
		function editNewColumn(){
			var editname = $("#edit_name").val();
	   		var editdescription = $("#edit_description").summernote("code");
		/*	var arr = ["<", ">", "?", "[", "]", "{", "}", "&", "/", "'\'", "`", "^", "*", "#", "~", ";", ":", "|"];
          	
          	var xss = false;
           	for (var i=0; i < arr.length; i++) {
           		if (editname.includes(arr[i])){
           			xss = true;
           			break;
           		}else if(editdescription.includes(arr[i])){
           			xss = true;
           			break;
                }else {
           			xss = false;
           		}
           	}
	   	*/	
	   		if (editname == ""){
	   			alert('Nama kolom tidak boleh kosong.');
	   		}else if (editdescription == ""){
	   			alert('Deskripsi tidak boleh kosong.');
	   	//	}else if (xss){
    	//		alert("Inputan tidak bisa mengandung karakter spesial ex: <, >, #...");
    		}else{
	   			$.ajax({
					type: "POST",
					url : "<%=request.getContextPath()%>/PME/CheckColumn",
					data: {name:editname, id_kolom:$("#edit_id_kolom").val()},
						success: function(data){
							if(data == "true"){
								alert("Kolom ini sudah ada.");
							}else{
								$.ajax({
									type: "POST",
									url : "<%=request.getContextPath()%>/PME/EditNewColumn",
									data: {nama:editname, deskripsi:editdescription, id_kolom:$("#edit_id_kolom").val()},
										success: function(data){
											alert('Kolom berhasil dirubah.');
											window.location.reload();
										},
										error:function(){
											error('Kolom gagal dirubah.');
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
		
		function deleteNewColumn(){
			$.ajax({
				type: "POST",
				url : "<%=request.getContextPath()%>/PME/HapusKolomBaru",
				data: {id_kolom:$("#hapus_kolom").val()},
					success: function(data){
						alert('Kolom berhasil dihapus.');
						window.location.reload();
					},
					error:function(){
						error('Kolom gagal dihapus.');
					}
			});
		}
	</script>

</html>
 <%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="org.json.simple.parser.ParseException"%>
<%@page import="java.net.URL"%>
<%@page import="java.util.logging.Logger"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix = "sql"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<link rel="shortcut icon" href="<%=request.getContextPath()%>/assets/images/logo-login.png" type="image/x-icon">
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/assets/select2/dist/css/select2.css" />
		<title>PME Project</title>
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

	
	<style>
* {
    box-sizing: border-box;
}

[class*="grid-c"] {
    float: left;
    padding: 15px;
    border: 1px solid #ffb366;
}

.grid-luas{
width: 100%;
margin:0px;
}

@-moz-document url-prefix() {
.grid-col{
/*width: 20%;*/
width: 298px;
margin:0px;
height: 250px;
}
}

@media screen and (-webkit-min-device-pixel-ratio:0) {
.grid-col{
width: 257px;
margin:0px;
height: 240px;
}
}

.grid-kiri{
width: 80%;
}

.grid-kanan{
width: 20%;
}


.col-container {
    display: table;
    width: 100%;
}
.col1 {
    display: table-cell;
    padding: 16px;
}

.col2 {
    display: table-cell;
    padding: 16px;
    margin-left: 10px;
    /*width: 100%;*/
}
.col3 {
    display: table-cell;
    padding: 10px;
    position:absolute;
    /*width: 10%;*/
}
			#easyPaginate {width:100px;margin:0;white-space: nowrap;}
		.easyPaginateNav a.current {font-weight:bold;text-decoration:underline;}
		.easyPaginateNav{padding-top:20px; margin-right:15px; width: 1000px;}

</style>
<style id="antiClickjack">
	        body
	        {
	            display:none !important;
	        }
    	</style>
	</head>
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
	<body class="nav-md">
    	<div class="container body">
      		<div class="main_container">
      			<jsp:include page="header_admin.jsp"></jsp:include>
      			<jsp:include page="sidebar.jsp"></jsp:include>
    
    			<c:set var="urllogin1" value="${dbUrl}" />
				<c:set var="user1" value="${dbUser}" />
				<c:set var="psswd1" value="${dbPass}" />
				<sql:setDataSource var="dbPME" driver="com.mysql.jdbc.Driver"
					url="${urllogin1}" user="${user1}" password="${psswd1}" />
      			
      			<!-- main content -->
      			<div class="right_col" role="main">
          			<div class="row">
            			<div class="col-md-12 col-sm-12 col-xs-12">
              				<div class="dashboard_graph">
                				<div class="x_title">
									<h2>Data Proyek PME</h2>
										<div class="nav navbar-right panel_toolbox">
											<c:if test="${level != 1}">
												<a class="btn btn-primary" data-toggle="modal" href='#tambah_proyek'>
												<i class="fa fa-plus"></i> Proyek Baru</a>						
											</c:if>
										</div>
									<div class="clearfix"></div>
								</div>
								
								<!-- form tambah project -->
								<div class="modal fade" id="tambah_proyek">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-header">
												<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
												<h4 class="modal-title">Tambah Proyek Pme</h4>
											</div>
												<div class="modal-body">
													<div class="form-group">
														<label for="">Project Name <span class="required">*</span></label>
														<input type="text" name="proyek_name" id="proyek_name"  value="" required class="form-control ">
														<div style="color:red" id="cek_proyek"></div>
													</div>
													<div class="form-group">
														<label for="">PJPK</label>
														<input type="text" name="pjpk" id="pjpk"  value="" required class="form-control" placeholder="PJPK">
														
													</div>
													<div class="form-group">
														<label for="">Nilai Proyek</label>
														<input type="text" name="nilai_proyek" id="nilai_proyek"  value="" required class="form-control" placeholder="Nilai Proyek">
													</div>
													<div class="form-group">
														<label for="">Area</label>
														<input type="text" name="proyek_region" id="proyek_region"  value="" required class="form-control" placeholder="Nama Area">
													</div>
													<div class="form-group">
														<label for="">Wilayah</label>
														<select name="wilayah" id="wilayah" class="form-control"  required>
															<option value="">Pilih Wilayah</option>
															<option value="ID-AC">Aceh</option>
															<option value="ID-BA">Bali</option>
															<option value="ID-BB">Bangka Belitung</option>
															<option value="ID-BE">Bengkulu</option>
															<option value="ID-BT">Banten</option>
															<option value="ID-GO">Gorontalo</option>
															<option value="ID-JA">Jambi</option>
															<option value="ID-JB">Jawa Barat</option>
															<option value="ID-JI">Jawa Timur</option>
															<option value="ID-JK">Jakarta Raya</option>
															<option value="ID-JT">Jawa Tengah</option>
															<option value="ID-KB">Kalimantan Barat</option>
															<option value="ID-KR">Kepulauan Riau</option>
															<option value="ID-KS">Kalimantan Selatan</option>
															<option value="ID-KT">Kalimantan Tengah</option>
															<option value="ID-KU">Kalimantan Utara</option>
															<option value="ID-LA">Lampung</option>
															<option value="ID-MA">Maluku</option>
															<option value="ID-MU">Maluku Utara</option>
															<option value="ID-NB">Nusa Tenggara Barat</option>
															<option value="ID-NT">Nusa Tenggara Timur</option>
															<option value="ID-PA">Papua</option>
															<option value="ID-PB">Papua Barat</option>
															<option value="ID-RI">Riau</option>
															<option value="ID-SA">Sulawesi Utara</option>
															<option value="ID-SB">Sumatera Barat</option>
															<option value="ID-SG">Sulawesi Tenggara</option>
															<option value="ID-SN">Sulawesi Selatan</option>
															<option value="ID-SR">Sulawesi Barat</option>
															<option value="ID-SS">Sumatera Selatan</option>
															<option value="ID-ST">Sulawesi Tengah</option>
															<option value="ID-SU">Sumatera Utara</option>
															<option value="ID-YO">Yogyakarta</option>
														</select>
													</div>
													<div class="form-group">
													<label for="">Sektor</label> <select name="proyek_sektor"
														id="proyek_sektor" class="form-control" required>
														<option value="">Pilih Sektor</option>
														<c:forEach begin="1" end="${msg.sector.size()}"
															varStatus="loop">
															<option
																value="${msg.sector.get(loop.index-1).getIdSektor()}">${msg.sector.get(loop.index-1).getNamaSektor()}</option>
														</c:forEach>
													</select>
												</div>
												</div>
												<div class="modal-footer">
													<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
													<button type="button" class="btn btn-success" onclick="saveProject();">Submit</button>
												</div>
											
										</div>
									</div>
								</div>
								
								
				            <div class="col-md-12 col-sm-12 col-xs-12">                				  	
                				  	
                				  	<!-- ${msg } -->
                				<div class="x_content">
									<div class="row">
										<!-- <form action="<%=request.getContextPath()%>/DMS/search_proyek" method="post" role="form">  -->
											<div class="form-group col-sm-3">
												<input type="text" class="form-control" name="search" id="search" value="" placeholder="Cari Proyek">
											</div>
										<!-- </form>  -->
									</div>
								</div>
							
							<div id="table-search">
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
																	select 100/COUNT(status) * (select COUNT(status) from kegiatan_pme where status = 1 AND id_jenis_tahapan = ?) as persentase from kegiatan_pme WHERE id_jenis_tahapan = ?
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
								</div>
								</div>

							</div>
                				<div class="clearfix"></div>
              				</div>
            			</div>
          			</div>
          			<br />
          			<div class="row"></div>
        		</div>
      		</div>
     	</div>
     	<jsp:include page="/WEB-INF/views/assets/script.jsp"></jsp:include>
     	  	<script src="<%=request.getContextPath()%>/assets/select2/dist/js/select2.full.js"></script>
	     	<script src="<%=request.getContextPath()%>/assets/easy-paginate/lib/easyPaginate.js"></script>
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
	
	$(document).ready(function(){
		$("#wilayah").select2({
			width:'570px'
		});

		$("#proyek_sektor").select2({
		      width:'570px'
		    });
	
	
		$('#search').keyup(function(){
			var search = $('#search').val();
			$.ajax({
				type: "POST",
				url : "<%=request.getContextPath()%>/PME/search_proyek",
				data: {search:search},
					success: function(msg){
						//alert(yearfrom);
						$('#table-search').html(msg);
					},
					error:function(){
						error('error request !');
					}
			});
		});
		
		$(document).on('submit', "#delete_project", function(e) {
	        e.preventDefault();
	        $.ajax({  
	            url: $(this).attr('action'),
	            type: "post",  
	            data: $(this).serialize(),
	            error:function(){
	                alert("ERROR : CANNOT CONNECT TO SERVER");
	            },
	            success: function(data) {
	            	alert("berhasil hapus proyek");
	                window.location.reload();
	            }
	        });
	        return false; 
	    });
	    
	
	});
	
	$('#paging').easyPaginate({
	    paginateElement: 'grid',
	    elementsPerPage: 12,
	    numeric: true,
	    firstButton : false,
	    lastButton : false,
	    prevButtonText : 'Previous',
	    nextButtonText : 'Next'
	    
	});
	
	
	
	function saveProject(){
		var proyek_name=$("#proyek_name").val();
		var pjpk=$("#pjpk").val();
		var nilai_proyek=$("#nilai_proyek").val();
		var proyek_region=$("#proyek_region").val();
		var wilayah=$("#wilayah").val();
		var proyek_sektor=$("#proyek_sektor").val();
		var arr = ["<", ">", "?", "[", "]", "{", "}", "&", "/", "'\'", "`", "^", "*", "#", "~", ";", ":", "|"];
      	
      	var xss = false;
       	for (var i=0; i < arr.length; i++) {
       		if (proyek_name.includes(arr[i])){
       			xss = true;
       			break;
       		}else if(pjpk.includes(arr[i])){
       			xss = true;
       			break;
            }else if(nilai_proyek.includes(arr[i])){
       			xss = true;
       			break;
            }else if(proyek_region.includes(arr[i])){
       			xss = true;
       			break;
            }else {
       			xss = false;
       		}
       	}
       	
		if(proyek_name == ""){
			alert("Nama Proyek tidak boleh kosong");
		}
		else if(pjpk == ""){
			alert("PJPK tidak boleh kosong");
		}
		else if(nilai_proyek == ""){
			alert("Nilai Proyek tidak boleh kosong");
		}
		else if(proyek_region == ""){
			alert("Area tidak boleh kosong");
		}
		else if(wilayah == ""){
			alert("Wilayah tidak boleh kosong");
		}
		else if(proyek_sektor == ""){
			alert("Sektor tidak boleh kosong");
		}else if (xss){
			alert("Inputan tidak bisa mengandung karakter spesial ex: <, >, #...");
		}else{
			$.ajax({
				type: "POST",
				url : "<%=request.getContextPath()%>/PME/cek_proyek",
				data: {proyek_name:proyek_name},
					success: function(data){
						if(data == "true"){
							alert("Nama Proyek sudah ada, silahkan pilih yang lain");
						}else{
							$.ajax({
								type: "POST",
								url : "<%=request.getContextPath()%>/PME/SaveProject",
								data: {proyek_name:proyek_name,pjpk:pjpk, nilai_proyek:nilai_proyek, proyek_region:proyek_region, wilayah:wilayah, proyek_sektor:proyek_sektor},
									success: function(data){
										alert("Berhasil tambah proyek");
										window.location.reload();
									},
									error:function(){
										error('error request !');
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

	    		  
		  $('.nav-tabs a').on('shown.bs.tab', function(event){
		        var x = $(event.target).text();         // active tab
		        var y = $(event.relatedTarget).text();  // previous tab
		        $(".act span").text(x);
		        $(".prev span").text(y);
		        //initialize();
		    });
	</script>

</html>
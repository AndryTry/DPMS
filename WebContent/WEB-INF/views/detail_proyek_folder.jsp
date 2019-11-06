<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<link rel="shortcut icon" href="<%=request.getContextPath()%>/assets/images/logo-login.png" type="image/x-icon">
		<title>DMS Project</title>
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
	<% 
		HttpServletResponse httpResponse = (HttpServletResponse)response;
		
		httpResponse.setHeader("Cache-Control","no-cache, no-store, must-revalidate"); 
		response.addHeader("Cache-Control", "post-check=0, pre-check=0");
		httpResponse.setHeader("Pragma","no-cache"); 
		httpResponse.setDateHeader ("Expires", 0); 
		if (session.getAttribute("email") == null || session.getAttribute("username") == null ) {                               
			response.sendRedirect("../../Login");
             return;
		}
		if(session.getAttribute("errorFileType") != null && session.getAttribute("errorFileType").equals("errorFileType")){
			session.removeAttribute("errorFileType");
			out.println("<script type=\"text/javascript\">");
		    out.println("alert('Invalid file type!!');");
		    out.println("</script>");
		}
	%>
    	<div class="container body">
      		<div class="main_container">
      			<jsp:include page="header_admin.jsp"></jsp:include>
      			<jsp:include page="sidebar.jsp"></jsp:include>
      			
      			<!-- main content -->
      			<div class="right_col" role="main">
          			<div class="row">
            			<div class="col-md-12 col-sm-12 col-xs-12">
              				<div class="dashboard_graph">
                				<div class="row x_title">
                					<label id="nav"><a href="<%=request.getContextPath()%>/Home">Home</a></label> / 
                					<label id="nav"><a href="<%=request.getContextPath()%>/DMS">Proyek</a></label> / 
                					   <c:forEach items="${proyekName}" var="proyek">
	                					   <label id="nav"><a href="<%=request.getContextPath()%>/proyek_folder/proyek/${proyek.projectID}/1/0/0"  > ${proyek.projectName} </a>
	                					   </label>
                					   </c:forEach> 
                					   <c:if test="${sub_id < sub_id+1}"> 
	                					   <c:forEach items="${folderName}" var="folder">  
		                					   <label id="nav" class="folderPath"><a href="<%=request.getContextPath()%>/proyek_folder/proyek/${folder.idProyekDms}/${folder.folderSub+1}/${folder.idFolderDms}/${folder.idFolderDms}"> / ${folder.folderName} </a>
		                					   </label> 
	                					   </c:forEach> 
                					   </c:if> 
                						<style>
											.aktif, a.aktif {
										    color: black;
										    pointer-events: none;
											}
											#file_edit{
										    	color: transparent;
											}
											input[type="file"] {
											    display: relative;
											}
										</style>
                				</div>
                				<div class="clearfix"></div>
                				<div>
									<c:if test="${level > 1 && allowed}">
	                					<div class="col-md-55">
											<div class="thumbnail">
													<div class="image view view-first">
														<a data-toggle="modal" href="#tambah"><img style="height: 100%; margin: auto;" src="<%=request.getContextPath()%>/assets/images/add_folder.png" alt="folder" /></a>
													</div>
													<div class="caption">
														<a data-toggle="modal" href="#tambah">Tambah</a>
													</div>
											</div>
										</div>
									</c:if>
									<c:forEach items="${listFolder}" var="folder">
                						<div class="col-md-55">
											<div class="thumbnail">
												<div class="image view view-first">
													<img style="height: 100%; margin: auto;" src="<%=request.getContextPath()%>/assets/images/folder.jpg" alt="folder" />
													<div class="mask" style="height:100%;">														
														<div class="tools tools-bottom" style="margin-top:90px">
															<a href="../../../${folder.idProyekDms}/${folder.folderSub+1}/${folder.idFolderDms}/${folder.idFolderDms}"><i class="fa fa-link"></i></a>
															<c:if test="${level > 1 && allowed}">
															<a data-toggle="modal" href="#editFolder_${folder.idFolderDms}"><i class="fa fa-pencil"></i></a>
															<a data-toggle="modal" href="#deleteFolder_${folder.idFolderDms}"><i class="fa fa-trash"></i></a>
															</c:if>
														</div>
													</div>
												</div>
												<div class="caption">
													<a href="../../../${folder.idProyekDms}/${folder.folderSub+1}/${folder.idFolderDms}/${folder.idFolderDms}"><c:out value="${folder.folderName}"/></a>
												</div>
												
												<!-- Form Edit Folder -->
												<div class="modal fade" id="editFolder_${folder.idFolderDms}">
													<div class="modal-dialog">
														<div class="modal-content">
															<div class="modal-header">
																<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
																<h4 class="modal-title">Edit Folder</h4>
															</div>
															
															<form action="../../../../editFolder" method="post" role="form" id="folder_edit">
																<input class="form-control" type="hidden" name="project_id" value="${project_id}">
																<input class="form-control" type="hidden" name="sub_id" value="${sub_id}">
																<input class="form-control" type="hidden" name="id_folder" value="${id_folder}">
																<input class="form-control" type="hidden" name="id_edit_folder" value="${folder.idFolderDms}">
																
																<div class="modal-body">
																	<div class="form-group">
																		<label>Nama Folder</label>
																		<input type="text" name="nama_folder" value="${folder.folderName}"  class="form-control ">
																	</div>
																</div>
																<div class="modal-footer">
																	<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
																	<button type="submit" class="btn btn-success">Submit</button>
																</div>
															</form>
														</div>
													</div>
												</div>
												
												<!-- Form Delete Folder -->
												<div class="modal fade" id="deleteFolder_${folder.idFolderDms}">
													<div class="modal-dialog">
														<div class="modal-content">
															<div class="modal-header">
																<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
																<h4 class="modal-title">Delete Folder</h4>
															</div>
															
															<form action="../../../../deleteFolder" method="post" role="form" id="folder_hapus">
																<input class="form-control" type="hidden" name="project_id" value="${project_id}">
																<input class="form-control" type="hidden" name="sub_id" value="${sub_id}">
																<input class="form-control" type="hidden" name="id_folder" value="${id_folder}">
																<input class="form-control" type="hidden" name="id_delete_folder" value="${folder.idFolderDms}">
																
																<div class="modal-body">
																	Apakah anda yakin akan menghapus folder ${folder.folderName}?<br/>
																	semua isi dari folder akan ikut terhapus 
																</div>
																<div class="modal-footer">
																	<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
																	<button type="submit" class="btn btn-success">Submit</button>
																</div>
															</form>
														</div>
													</div>
												</div>
											</div>
										</div>
									</c:forEach>
									<!-- Form Tambah Folder -->
	                				<div class="modal fade" id="tambah">
										<div class="modal-dialog">
											<div class="modal-content">
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
													<h4 class="modal-title">Tambah</h4>
												</div>
												
												<form action="../../../../createFolder" method="post" role="form" id="folder_tambah">
													<input class="form-control" type="hidden" name="project_id" value="${project_id}">
													<input class="form-control" type="hidden" name="sub_id" value="${sub_id}">
													<input class="form-control" type="hidden" name="id_folder" value="${id_folder}">
													
													<div class="modal-body">
														<div class="form-group">
															<label>Nama Folder</label>
															<input type="text" name="nama_folder"  class="form-control ">
														</div>
														
													</div>
													<div class="modal-footer">
														<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
														<button type="submit" class="btn btn-success">Submit</button>
													</div>
												</form>
												
											</div>
										</div>
									</div>
                				</div>
                				<div class="clearfix"></div>
                				<c:if test = "${sub_id != 1}">
                					<div class="col-md-12">
                						<table class="table table-hover">
                							<thead>
												<tr>
													<th width="25%"><b>File</b><br/></th>
													<th><b>Jenis Dokumen</b></th>
													<th width="20%"><b>Perihal</b></th>
													<th><b>No.Surat</b></th>
													<th><b>Tanggal</b></th>
													<th><b>Ket</b></th>
													<th><b>Pilihan</b></th>
												</tr>
											</thead>
                							<tbody>
												<c:forEach items="${listFile}" var="file">
													<tr>
														<td><c:out value="${file.file_name}"/></td>
														<td><c:out value="${file.nama_jenis_dokumen}"/> </td>
														<td><c:out value="${file.perihal}"/> </td>
														<td><c:out value="${file.nomor_surat}"/> </td>
														<td><c:out value="${file.date_surat}"/> </td>
														<c:choose>
															<c:when  test="${file.editBy == null || file.editBy.length() == 0}">
																<td>pengunggah <c:out value="${file.uploadBy}"/> <c:out value="${file.date}"/></td>
															</c:when>
															<c:otherwise>
																<td>diubah oleh <c:out value="${file.editBy}"/> <c:out value="${file.editDate}"/></td>
															</c:otherwise>
														</c:choose>
														<td>
															<a href="<%=request.getContextPath()%>${file.file_path}" target="_blank" class="btn btn-xs btn-success"><i class="fa fa-eye"></i></a> 
															<c:if test="${(level > 1 && file.id_user == user_id) || allowed ||level > 2}">
								                                <a href="#formEditFile" data-toggle="modal" class="btn btn-danger btn-xs"
								                                  data-nameFile="${file.file_name}"
								                                  data-file="${file.file_path}"
								                                  data-dokumen="${file.nama_jenis_dokumen}"
								                                  data-date="${file.date}"
								                                  data-perihal="${file.perihal}"
								                                  data-nomor="${file.nomor_surat}"
								                                  data-idFile="${file.id_file}"
								                                  data-idDoc="${file.id_jenis_dokumen}"><i class="fa fa-edit"></i></a>
								                                <a href="#formDeleteFile_${file.id_file}" data-toggle="modal" class="btn btn-danger btn-xs"><i class="fa fa-trash"></i></a>
								                             </c:if>
														</td>
											
													</tr>
													<!-- Form Delete File -->
													<div class="modal fade" id="formDeleteFile_${file.id_file}" tabindex="-1" role="dialog" aria-labelledby="myModalLabel5" aria-hidden="true">
					    								<div class="modal-dialog">
					        								<div class="modal-content">
					            								<div class="modal-header">
					                								<button type="button" class="close" data-dismiss="modal">
					                       								<span aria-hidden="true">&times;</span>
					                       								<span class="sr-only">Close</span>
					                								</button>
					                								<h4 class="modal-title" id="myModalLabel5">DELETE FILE</h4>
					            								</div>
					            								<div class="modal-body">
					                  									Apakah Anda yakin akan menghapus file <c:out value="${file.file_name}"/>?
					                  								
													            </div>
													            <div class="modal-footer">
														            <form role="form" action="../../../../deleteFile" method="post" id="deleted">
					                 									<input class="form-control" type="hidden" name="id_file" value="${file.id_file}">
					                 									<input class="form-control" type="hidden" name="file_path" value="${file.file_path}">
																		<input class="form-control" type="hidden" name="project_id" value="${project_id}">
																		<input class="form-control" type="hidden" name="sub_id" value="${sub_id}">
																		<input class="form-control" type="hidden" name="id_folder" value="${id_folder}">
														                <button type="button" class="btn btn-default"
														                        data-dismiss="modal">
														                            Close
														                </button>
														                <input type="submit" value="Delete" class="btn btn-danger">
														            </form> 
													            </div>
													        </div>
													    </div>
													</div>
													
													<!-- Form Edit File -->
			                						<div class="modal fade" id="formEditFile">
														<div class="modal-dialog">
															<div class="modal-content">
																<div class="modal-header">
																	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
																	<h4 class="modal-title">Edit File</h4>
																</div>
																
																<form action="../../../../editFile" method="post" role="form" enctype="multipart/form-data" id="save">
																	<input class="form-control" type="hidden" name="project_id" value="${project_id}">
																	<input class="form-control" type="hidden" name="sub_id" value="${sub_id}">
																	<input class="form-control" type="hidden" name="id_folder" value="${id_folder}">
																	<input class="form-control folder_path" type="hidden" name="folder_path">
				                 									<input class="form-control id_file" type="hidden" name="id_file">
				                 									<input class="form-control file_path" type="hidden" name="file_path">
																	
																	<div class="modal-body">
					                  									<div class="form-group">
					                      									<select id="pilihan" class="form-control" name="jenis_dokumen">
					                      										<option value="">Jenis Dokumen</option>
					                      										<c:forEach items="${dokumen}" var="dokumen">
					                      											<option value="${dokumen.getIdJenisDokumen()}">${dokumen.getNamaJenisDokumen()}</option>
					                      										</c:forEach>
					                      										
					                      									</select>
					                  									</div>
																		<div class="form-group">
																			<label>Nomor Surat</label>
																			<input type="text" name="nomor_surat" class="form-control nomor">
																		</div>
																		<!-- 
																		<div class="form-group">
																			<label>Nama File</label>
																			<input type="text" name="nama_file" required class="form-control">
																		</div>
																		 -->
																		<div class="form-group">
																			<label>Tanggal Surat</label>
																			<input type="text" id="tanggal_surat" name="tanggal_surat" value="" class="form-control tanggal_surat">
																		</div>
					                  									<div class="form-group">
					                  										<label class="control-label"><div align="left">Perihal</div></label>
					                      									<textarea id="description" name="perihal" rows="4" style="width:100%;" class="form-control perihal"></textarea>
					                  									</div>
					                  									<div class="form-group">
																			<label>File</label><br>
																			<div class="col-sm-3" style="width:130px">
																				<input type="file" name="file" onchange="pressed()" id="file_edit" class="form-control">
																			</div>
																			<span id="fileLabel"></span>
																			<input type="hidden" id="fileCompare">
																		</div>															
																	</div>
																	
																	<div class="modal-footer">
																		<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
																		<button type="submit" class="btn btn-success">Submit</button>
																	</div>
																</form>
															</div>
														</div>
													</div>
												</c:forEach>
											</tbody>
										</table>
									</div>
										<c:if test="${level > 1}">									
                							<button class="btn btn-primary" data-toggle="modal" data-target="#uploadFile">Tambah File</button>
                						</c:if>
                						
                						<!-- Form Upload File -->
                						<div class="modal fade" id="uploadFile">
											<div class="modal-dialog">
												<div class="modal-content">
													<div class="modal-header">
														<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
														<h4 class="modal-title">Tambah File</h4>
													</div>
													
													<form action="../../../../uploadFile" id="qwerty" method="post" role="form" enctype="multipart/form-data">
														<input class="form-control" type="hidden" name="project_id" value="${project_id}">
														<input class="form-control" type="hidden" name="sub_id" value="${sub_id}">
														<input class="form-control" type="hidden" name="id_folder" value="${id_folder}">
														<input class="form-control folder_path" type="hidden" name="folder_path">
														
														<div class="modal-body">
		                  									<div class="form-group">
		                      									<select class="form-control" name="jenis_dokumen">
		                      										<option value="">Jenis Dokumen</option>
		                      										<c:forEach items="${dokumen}" var="dokumen">
		                      											<option value="${dokumen.getIdJenisDokumen()}">${dokumen.getNamaJenisDokumen()}</option>
		                      										</c:forEach>
		                      										
		                      									</select>
		                  									</div>
															<div class="form-group">
																<label>Nomor Surat</label>
																<input type="text" name="nomor_surat" class="form-control">
															</div>
															<!-- 
															<div class="form-group">
																<label>Nama File</label>
																<input type="text" name="nama_file" required class="form-control">
															</div>
															 -->
															<div class="form-group">
																<label>Tanggal Surat</label>
																<input type="text" id="tanggal_upload" name="tanggal_surat" value="" class="form-control tanggal_surat">
															</div>
		                  									<div class="form-group">
		                  										<label class="control-label"><div align="left">Perihal</div></label>
		                      									<textarea name="perihal" rows="4" style="width:100%;" ></textarea>
		                  									</div>
															<div class="form-group">
																<label>File</label>
																<input type="file" name="file" class="form-control">
															</div>															
														</div>
														
														<div class="modal-footer">
															<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
															<button type="submit" class="btn btn-success" >Submit</button>
														</div>
													</form>
												</div>
											</div>
										</div>
	                				</div>
                				</c:if>
              				
            			</div>
          			</div>
          			<br />
          			<div class="row"></div>
        		</div>
      		</div>
     	</div>
     	<jsp:include page="/WEB-INF/views/assets/script.jsp"></jsp:include>
		<script type="text/javascript">
				
			jQuery(function($) {
			    var path = window.location.href; // because the 'href' property of the DOM element is the absolute path
			    $('label a').each(function() {
			     if (this.href === path) {
			      $(this).addClass('aktif');
			     }
			    });
			   });
			
			$('#uploadFile').on('show.bs.modal', function (e) {
				var folderPath = $('.folderPath').text();				
			    $(".folder_path").val(folderPath);
			});
			$(function(){
			  	$('#tanggal_surat').datepicker({
		            format : 'yyyy-mm-dd',
		            dateFormat : 'yy-mm-dd',
					changeMonth: true,
					changeYear: true,
				});
			  	$('#tanggal_upload').datepicker({
		            format : 'yyyy-mm-dd',
		            dateFormat : 'yy-mm-dd',
					changeMonth: true,
					changeYear: true,
				});
			  });
			
			$('#formEditFile').on('show.bs.modal', function (e) {
				
		 		var id_file = $(e.relatedTarget).attr('data-idFile');
		 		var tanggal_surat = $(e.relatedTarget).attr('data-date');
		 		var perihal = $(e.relatedTarget).attr('data-perihal');
			    var nomor = $(e.relatedTarget).attr('data-nomor');
			    var idDoc = $(e.relatedTarget).attr('data-idDoc');
			    var dataFile = $(e.relatedTarget).attr('data-file');
			    var file = $(e.relatedTarget).attr('data-nameFile');
			    $(".nomor").val(nomor);
			    $(".tanggal_surat").val(tanggal_surat);
			    $(".perihal").val(perihal);
			    $(".id_file").val(id_file);
			    $(".file_path").val(dataFile);
			    $("#fileLabel").text(file);
			    $("#fileCompare").val(file);
			    //$(".target").val(myTarget);
			    //$(".realisasi").val(myRealisasi);
			    
			    var element = document.getElementById('pilihan');
			    element.value = idDoc;
			});
			
			function form_submit() {
			    document.getElementById("save").submit();
			} 
			
			function submit_upload(){
				document.getElmentById("qwerty").submit();
			}
			
			 $(document).on('submit', "#folder_tambah", function(e) {
		        e.preventDefault();
		        if(this.nama_folder.value == ""){
					alert("nama folder tidak boleh kosong");
				}else{
					$.ajax({  
			            url: $(this).attr('action'),
			            type: "post",  
			            data: $(this).serialize(),
			            error:function(){
			                alert("ERROR : CANNOT CONNECT TO SERVER");
			            },
			            success: function(data) {
			            	alert("berhasil tambah folder");
			                window.location.reload();
			            }
			        });
			        //return false;	
				} 
		    });
		    
		    $(document).on('submit', "#folder_edit", function(e) {
		        e.preventDefault();
		        if(this.nama_folder.value == ""){
					alert("nama folder tidak boleh kosong");
				}else{
					$.ajax({  
			            url: $(this).attr('action'),
			            type: "post",  
			            data: $(this).serialize(),
			            error:function(){
			                alert("ERROR : CANNOT CONNECT TO SERVER");
			            },
			            success: function(data) {
			            	alert("berhasil  edit folder");
			                window.location.reload();
			            }
			        });
			        //return false;	
				} 
		    });
		    
		    $(document).on('submit', "#folder_delete", function(e) {
		        e.preventDefault();
		        $.ajax({  
		            url: $(this).attr('action'),
		            type: "post",  
		            data: $(this).serialize(),
		            error:function(){
		                alert("ERROR : CANNOT CONNECT TO SERVER");
		            },
		            success: function(data) {
		            	alert("berhasil hapus folder");
		                window.location.reload();
		            }
		        });
		        //return false; 
		    }); 
		    
		    
		    ////////// upload file
		    $(function () {
			     $('#file_edit').change(function () {
			          if ($(this).val() != "") {
			                 $(this).css('color', '#333');
			          }else{
			                 $(this).css('color', 'transparent');
			          }
			     });
			});
		    
		    window.pressed = function(){
		        var a = document.getElementById('file_edit');
		        var b = document.getElementById('fileCompare').value;
		        if(a.value == "")
		        {
		        	$("#fileLabel").text(b);
		        	//fileLabel.innerHTML = b;
		        }
		        else
		        {
		            var theSplit = a.value.split('\\');
		            $("#fileLabel").text(theSplit[theSplit.length-1]);
		            //fileLabel.innerHTML = theSplit[theSplit.length-1];
		        }
		    };
		    
		    $(document).on('submit', "#qwerty", function(e) {
		   	 var gif = "<br> <div class='loader'><img src='<%=request.getContextPath()%>/assets/images/loadingAnimation.gif'/></div>";
		   	 document.getElementById('uploadFile').innerHTML = gif;
		   	var form = $(this)[0];
		       var data = new FormData(form);
		    	var fileSplit = this.file.value.split('\\');
		    	var fileLength = fileSplit[fileSplit.length-1];
		    	var extension = fileLength.substr( (fileLength.lastIndexOf('.') +1) );
		      	var arr = ["doc", "docx", "xls", "xlsx", "ppt", "pptx", "pdf", "jpg", "jpeg", "mpg", "mpeg", "mov", "avi", "mp3", "mp4",
		      	           "zip", "rar", "wav", "amr", "png", "txt", ""];
		   	 	//alert(extension);
		   	//$('.loader').css("visibility", "visible");
		   	    e.preventDefault();
		   	    
		      	var ext = false;
		   	for (var i=0; i < arr.length; i++) {
		   		if (extension.toLowerCase() == (arr[i])){
		   			ext = true;
		   			break;
		   		}else {
		   			ext = false;
		   		}
		   	}
		   	
		       if(this.jenis_dokumen.value == ""){
		   		alert("nama jenis dokumen tidak boleh kosong");
		   		window.location.reload();
		       }else if(this.nomor_surat.value == ""){
		   		alert("nama nomor surat tidak boleh kosong");
		   		window.location.reload();
		       }else if(this.tanggal_surat.value == ""){
		       	alert("nama tanggal surat tidak boleh kosong");
		       	window.location.reload();
		       }else if(this.perihal.value == ""){
		       	alert("nama perihal tidak boleh kosong");
		       	window.location.reload();
		       }else if(this.file.value == ""){
		       	alert("nama file tidak boleh kosong");
		       	window.location.reload();
		   	}else if(/*arr.indexOf(extension) === -1*/!ext){
		       	alert("format file tidak mendukung, silahkan upload yang lain");
		       	window.location.reload();
		   	}else{
		   		$.ajax({  
		               url: $(this).attr('action'),
		               type: "post",  
		               data: data,
		               enctype: $(this).attr('enctype'),
		               processData: false,  // Important!
		               contentType: false,
		               cache: false,
		               error:function(){
		                   alert("ukuran file terlalu besar. maksimal 50mb");
		                   window.location.reload();
		               },
		               success: function(data) {
		               	alert("berhasil upload file");
		                   window.location.reload();
		               }
		           });
		           //return false;	
		   	} 
		   });
		    
		    $(document).on('submit', "#save", function(e) {
				var gif = "<br> <div class='loader'><img src='<%=request.getContextPath()%>/assets/images/loadingAnimation.gif'/></div>";
				 document.getElementById('formEditFile').innerHTML = gif;
		    e.preventDefault();
		    var form = $(this)[0];
			    var data = new FormData(form);
			 	var fileSplit = this.file.value.split('\\');
			 	var fileLength = fileSplit[fileSplit.length-1];
			 	var extension = fileLength.substr( (fileLength.lastIndexOf('.') +1) );
			 	var arr = ["doc", "docx", "xls", "xlsx", "ppt", "pptx", "pdf", "jpg", "jpeg", "mpg", "mpeg", "mov", "avi", "mp3", "mp4",
		   	           "zip", "rar", "wav", "amr", "png", "txt", ""];
		   	var ext = false;
			for (var i=0; i < arr.length; i++) {
				if (extension.toLowerCase() == (arr[i])){
					ext = true;
					break;
				}else {
					ext = false;
				}
			}
			 	
			if(this.jenis_dokumen.value == ""){
				alert("nama jenis dokumen tidak boleh kosong");
				window.location.reload();
		    }else if(this.nomor_surat.value == ""){
				alert("nama nomor surat tidak boleh kosong");
				window.location.reload();
		    }else if(this.tanggal_surat.value == ""){
		    	alert("nama tanggal surat tidak boleh kosong");
		    	window.location.reload();
		    }else if(this.perihal.value == ""){
		    	alert("nama perihal tidak boleh kosong");
		    	window.location.reload();
		    }else if(/*arr.indexOf(extension) === -1*/!ext){
		    	alert("format file tidak mendukung, silahkan upload yang lain");
		    	window.location.reload();
			}else{
				$.ajax({  
		            url: $(this).attr('action'),
		            type: "post",  
		            data: data,
		            enctype: $(this).attr('enctype'),
		            processData: false,  // Important!
		            contentType: false,
		            cache: false,
		            error:function(){
		                alert("ukuran file terlalu besar. maksimal 50mb");
		                window.location.reload();
		            },
		            success: function(data) {
		            	alert("berhasil edit file");
		                window.location.reload();
		            }
		        });
			} 
		});
		    
		    $(document).on('submit', "#deleted", function(e) {
		        e.preventDefault();
		        $.ajax({  
		            url: $(this).attr('action'),
		            type: "post",  
		            data: $(this).serialize(),
		            error:function(){
		                alert("ERROR : CANNOT CONNECT TO SERVER");
		            },
		            success: function(data) {
		            	alert("berhasil hapus file");
		                window.location.reload();
		            }
		        });
		        //return false; 
		    });
		    
			
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
		
	</body>
</html>
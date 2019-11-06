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
<style>
.tableFixHead          { overflow-y: auto; height: 450px; }
.tableFixHead thead th { position: sticky; top: 0; }
.tableFixHead table  { width: 100%; }
.tableFixHead th     { background:#eee; }
</style>
<html>
	<head>	
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
    	
      			
      			<c:set var = "urllogin1" value ="${dbUrl}"/>
      			<c:set var = "user1"  value ="${dbUser}"/>
      			<c:set var = "psswd1"  value ="${dbPass}"/>
      			<sql:setDataSource var="dbPME" 
      				 driver="com.mysql.jdbc.Driver"
				     url="${urllogin1}"
				     user="${user1}"  
				     password="${psswd1}"
				/>		


<div class="row">
		<div class="col-sm-12">
			<div class="tableFixHead">
			<table class="table table-striped table-bordered" cellspacing="0" width="100%">
												    	<thead>
												        	<tr>
													            <th class="sorting_disabled" rowspan="1" colspan="1" style="width: 5%;">No</th>
													            <th class="sorting_disabled" rowspan="1" colspan="1" style="width: 20%;">Nama File</th>
													            <th class="sorting_disabled" rowspan="1" colspan="1" style="width: 30%;">Folder</th>
													            <th class="sorting_disabled" rowspan="1" colspan="1" style="width: 35%;">Nama Proyek</th>
													            <th class="sorting_disabled" rowspan="1" colspan="1" style="width: 10%;">Action</th>
												        	</tr>
													    </thead>
													    <tbody>
														<c:set var="no" value="${msg.pageid}" />		
														<c:forEach begin="1" end="${msg.listFileDMS.size()}" varStatus="loop">															
															<tr>
																<td class="sorting_disabled" rowspan="1" colspan="1" style="width: 5%;"><c:out value="${no}"/></td>
												               	<td class="sorting_disabled" rowspan="1" colspan="1" style="width: 20%;"><c:out value="${msg.listFileDMS.get(loop.index-1).getFile_name()}"/></td>
												               	<td class="sorting_disabled" rowspan="1" colspan="1" style="width: 30%;"><c:out value="${msg.listFileDMS.get(loop.index-1).getFolder_path()}"/></td>
												               	<td class="sorting_disabled" rowspan="1" colspan="1" style="width: 35%;"><c:out value="${msg.listFileDMS.get(loop.index-1).getProyek_name()}"/></td>
												               	<td class="sorting_disabled" rowspan="1" colspan="1" style="width: 10%;">
																	<a data-toggle="tooltip" data-placement="top" title="Add">
																		<button type="button" class="btn btn-xs btn-primary"
																			data-toggle="modal"
																			data-target="#addFilePME"
																			data-id="<c:out value="${msg.listFileDMS.get(loop.index-1).getId_file()}"/>"
																			data-filename="<c:out value="${msg.listFileDMS.get(loop.index-1).getFile_name()}"/>"
																			data-filepath="<c:out value="${msg.listFileDMS.get(loop.index-1).getFile_path()}"/>"
																			data-jenisfile="<c:out value="${msg.listFileDMS.get(loop.index-1).getId_jenis_dokumen()}"/>"
																			data-nomorsurat="<c:out value="${msg.listFileDMS.get(loop.index-1).getNomor_surat()}"/>"
																			data-perihal="<c:out value="${msg.listFileDMS.get(loop.index-1).getPerihal()}"/>"
																			data-tanggalsurat="<c:out value="${msg.listFileDMS.get(loop.index-1).getDate()}"/>">
																			<i class="fa fa-plus"></i>
																		</button>
																	</a>
																</td>
															</tr>
															
															<!-- Form Add File -->
															<div class="modal fade" id="addFilePME" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
							    								<div class="modal-dialog">
							        								<div class="modal-content">
							            								<div class="modal-header">
							                								<button type="button" id="b_close"  class="close">
							                       								<span aria-hidden="true">&times;</span>
							                       								<span class="sr-only">Close</span>
							                								</button>
							                								<h4 class="modal-title" id="myModalLabel">TAMBAH BERKAS</h4>
							            								</div>
							            								<div class="modal-body">
							            									
							                								<div id="formTambahfile">
							                								<form role="form" action="AddFilePME" method="post" name="tambahFile" id="tambahFilePME">
							                  									<input type="hidden" name="projectName" value="${projectNamePME}"/>
							                									<input type="hidden" name="jenis_tahapan" value="${jenis_tahapan}"/>
							                									<input type="hidden" name="id_jenis_tahapan" value="${id_jenis_tahapan}"/>
							                  									<input type="hidden" name="filename" class="form-control filename"/>
							                  									<input type="hidden" name="filepath" class="form-control filepath"/>
							                  									<input type="hidden" name="jenisfile" class="form-control jenisfile"/>
							                  									<input type="hidden" name="nomorsurat" class="form-control nomorsurat"/>
							                  									<input type="hidden" name="perihal" class="form-control perihal"/>
							                  									<input type="hidden" name="tanggalsurat" class="form-control tanggalsurat"/>
							                  									<input type="hidden" name="id_kegiatan_add" class="form-control id_kegiatan_add"/>
							                  									<input type="hidden" name="nama_kegiatan_add" class="form-control nama_kegiatan_add"/>
							                  									<input type="hidden" name="idfile" class="form-control idfile"/>
							                  									<input type="hidden" name="projectNamaPME" value="${projectNamePME}"/>
							                									<input type="hidden" name="nameTahapan" value="${namaTahapan}"/>
							                									<input type="hidden" name="id_tahapan" value="${id_tahapan}"/>
							                  																					                  									
							                  									<div class="form-group">
							                  										<label class="control-label"><div align="left">Apakah anda ingin menambah berkas ini di kegiatan "<span class='nama_k'></span>" ?</div></label>
							                  									</div>
							                  									
																	            <div class="modal-footer">
																	            <!--     <button type="button" class="btn btn-default" id="b_close">
																	                            Close
																	                </button>
																	             -->   
																	                <button type="submit" class="btn btn-primary" onclick="tambahFilePME();">Tambah</button>
																	            </div>
							                								</form>
							                								</div>   
															            </div>
															        </div>
															    </div>
															</div>
															
															<c:set var="no" value="${msg.pageid+loop.index}" />
															
														</c:forEach>
													    </tbody>
													</table>
												</div>
											</div>
										</div>
													<sql:query dataSource="${dbPME}" var="tot_upload2">
														select count(*) total from(select a.*, b.proyek_name from file_dms a, proyek_dms b where a.id_proyek_dms = b.id_proyek_dms)X where file_name like '%${msg.search_fileupload}%' or proyek_name like '%${msg.search_fileupload}%'
													</sql:query>
													<c:forEach var="total2" items="${tot_upload2.rows}">
										  					<input type="hidden" value="${total2.total}" id="tot_rec_filter"/>
										  			</c:forEach>
													<div class="pagination2 col-sm-12"></div>
												
	</head>
</html>

<script>

$("#b_close").on("click", function () {
	  	$('#addFilePME').modal('hide');
	    $("#idsusah").val($(".id_kegiatan_add").val());
	    $("#idsusahnama").val($(".nama_kegiatan_add").val());
	    $('.nama_k').text(document.getElementById('idsusahnama').value);
	    //alert(document.getElementById('idsusahnama').value);
});

$('#addFilePME').on('show.bs.modal', function (e) {
	var idfile = $(e.relatedTarget).attr('data-id');
    var filename = $(e.relatedTarget).attr('data-filename');
    var filepath = $(e.relatedTarget).attr('data-filepath');
    var jenisfile = $(e.relatedTarget).attr('data-jenisfile');
    var nomorsurat = $(e.relatedTarget).attr('data-nomorsurat');
    var perihal = $(e.relatedTarget).attr('data-perihal');
    var tanggalsurat = $(e.relatedTarget).attr('data-tanggalsurat');
    //var id_kegiatan = $(e.relatedTarget).attr('data-id');
    
    $(".idfile").val(idfile);
    $(".filename").val(filename);
    $(".filepath").val(filepath);
    $(".jenisfile").val(jenisfile);
    $(".nomorsurat").val(nomorsurat);
    $(".perihal").val(perihal);
    $(".tanggalsurat").val(tanggalsurat);
    
    $(".id_kegiatan_add").val(document.getElementById('idsusah').value);
    $(".nama_kegiatan_add").val(document.getElementById('idsusahnama').value);
    $(this).find('.nama_k').text(document.getElementById('idsusahnama').value);
});

//$(document).on('submit', "#tambahFilePME", function(e) {
function tambahFilePME(){
	//e.preventDefault();	        
	      //var a = this.idfile.value;
	      //var urlForm = $(this).attr('action');
	      //var dataForm = $(this).serialize();
	      	var projectName = $("input[name=projectName]").val();
			var jenis_tahapan = $("input[name=jenis_tahapan]").val();
			var id_jenis_tahapan = $("input[name=id_jenis_tahapan]").val();
			var filename = $("input[name=filename]").val();
			var filepath = $("input[name=filepath]").val();
			var jenisfile = $("input[name=jenisfile]").val();
			var nomorsurat = $("input[name=nomorsurat]").val();
			var perihal = $("input[name=perihal]").val();
			var tanggalsurat = $("input[name=tanggalsurat]").val();
			var id_kegiatan_add = $("input[name=id_kegiatan_add]").val();
			var nama_kegiatan_add = $("input[name=nama_kegiatan_add]").val();
			var idfile = $("input[name=idfile]").val();
			var projectNamaPME = $("input[name=projectNamaPME]").val();
			var nameTahapan = $("input[name=nameTahapan]").val();
			var id_tahapan = $("input[name=id_tahapan]").val();
	      var urlForm = $("#tambahFilePME").attr('action');
	      $.ajax({
			type: "POST",
			url : "<%=request.getContextPath()%>/PME/CheckFilePME",
			data: {idKegiatan:id_kegiatan_add,idFile:idfile},
				success: function(data){
					if(data == "true"){
						alert("File ini sudah ada.");
					}else{	
						$.ajax({  
			              url: urlForm,
			              type: "post",  
			              data: {projectName:projectName,jenis_tahapan:jenis_tahapan,id_jenis_tahapan:id_jenis_tahapan,filename:filename,filepath:filepath,jenisfile:jenisfile,nomorsurat:nomorsurat,perihal:perihal,tanggalsurat:tanggalsurat,id_kegiatan_add:id_kegiatan_add,nama_kegiatan_add:nama_kegiatan_add,idfile:idfile,projectNamaPME:projectNamaPME,nameTahapan:nameTahapan,id_tahapan:id_tahapan},
			              error:function(){
			                  alert("ERROR : CANNOT CONNECT TO SERVER");
			              },
			              success: function(data) {
				            alert("Berhasil tambah file.");
			                //window.location.reload();
			              	$('#addFilePME').modal('hide');
			              	$("#idsusah").val($(".id_kegiatan_add").val());
			        	    $("#idsusahnama").val($(".nama_kegiatan_add").val());
			        	    $('.nama_k').text(document.getElementById('idsusahnama').value);
			        	    $("#b_unduh_"+id_kegiatan_add).removeAttr("disabled");
			              }
			          });
					}
				},
				error:function(){
					error('error request !');
				}
			});
}
//});


function showPage_filter(whichPage) {
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
</script>

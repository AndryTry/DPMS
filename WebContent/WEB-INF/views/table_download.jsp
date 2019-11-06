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

<sql:query dataSource="${dbPME}" var="result">
	select * from file_pme where id_kegiatan = ?
	<sql:param value="${msg.id_kegiatan}" />
</sql:query>


<div class="row">
		<div class="col-sm-12">
				<table  id="example" class="table table-striped table-bordered nowrap" width="100%" cellspacing="0">
			<thead>
		         <tr>
		            <th width="5%">No</th>
		            <th width="30%">Nama File</th>
		            <th width="20%">Tanggal Upload</th>
		            <th width="25%">Keterangan</th>
		            <th width="20%">Opsi</th>
		         </tr>
		      </thead>
		      <tbody>																		
					<c:forEach begin="0" var="row" items="${result.rows}" varStatus="loop2">
						
						<!-- Form Delete File -->
						 <div class="modal fade" id="deleteFilePME_${row.id_file}" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  								<div class="modal-dialog">
      								<div class="modal-content">
          								<div class="modal-header">
              								<button type="button" onclick="closeHapus(${row.id_file})" class="close">
                     								<span aria-hidden="true">&times;</span>
                     								<span class="sr-only">Close</span>
              								</button>
              								<h4 class="modal-title" id="myModalLabel">HAPUS BERKAS</h4>
          								</div>
          								<div class="modal-body">
              								<form role="form" id="hapusFilePME" action="deleteFilePME" method="post">
              									<input type="hidden" name="id_file" value="${row.id_file}"/>
              									<input type="hidden" name="id_kegiatan2" id="id_kegiatan2" value="${row.id_kegiatan}"/>
                								<input type="hidden" name="projectName" value="${projectName}"/>
              									<input type="hidden" name="jenis_tahapan" value="${jenis_tahapan}"/>
              									<input type="hidden" name="id_jenis_tahapan" value="${id_jenis_tahapan}"/>
                								<input type="hidden" name="projectNamaPME" value="${projectNamePME}"/>
              									<input type="hidden" name="nameTahapan" value="${namaTahapan}"/>
              									<input type="hidden" name="id_tahapan2" id="id_tahapan2" value="${id_tahapan}"/>
                									<div class="form-group">
                										<label class="control-label"><div align="left">Apakah Anda yakin akan menghapus berkas ini "${row.file_name}"?</div></label>
                									</div>
                									
								            <div class="modal-footer">
								                <button type="button" class="btn btn-default"
								                        onclick="closeHapus(${row.id_file})">
								                            Close
								                </button>
								                
								                <button type="submit" class="btn btn-danger" onclick="hapusFilePME()">Delete</button>
								            </div>
              								</form>   
						            </div>
						        </div>
						    </div>
						</div> 
						
						<tr>
							<td width="5%"><c:out value="${loop2.index+1}"/></td>
							<td width="30%"><c:out value="${row.file_name}"/></td>
							<td width="20%"><c:out value="${row.created_date}"/></td>
							<c:choose>
								<c:when  test="${row.edit_by == null || row.edit_by.length() == 0}">
									<td width="25%">pengunggah <c:out value="${row.upload_by}"/> <c:out value="${row.created_date}"/></td>
								</c:when>
								<c:otherwise>
									<td width="25%">diubah oleh <c:out value="${row.edit_by}"/> <c:out value="${row.edit_date}"/></td>
								</c:otherwise>
							</c:choose>
							<td width="20%">
								<a class="btn btn-xs btn-primary" title="View" href="<%=request.getContextPath()%>${row.file_path}" target="_blank"><i class="fa fa-eye"></i></a>
								 <!--<a data-toggle="tooltip" data-placement="top" title="Edit">
									<button type="button" class="btn btn-xs btn-warning"
										data-toggle="modal"
										data-target="#editFilePME_${row.id_file}">
										<i class="fa fa-pencil"></i>
									</button>
								</a> -->
								<c:if test="${(level > 1 && row.id_user == user_id) || allowed ||level > 2}">
								<a data-toggle="tooltip" data-placement="top" title="Delete">
									<button type="button" class="btn btn-xs btn-danger"
										data-toggle="modal"
										data-target="#deleteFilePME_${row.id_file}">
										<i class="fa fa-trash"></i>
									</button>
								</a>
								</c:if>

							</td>
						</tr>
					</c:forEach>
		      </tbody>
		</table>
	</div>
</div>

	</head>
</html>

<script>

//$("#b_close2").on("click", function () {
function closeHapus(id_file){	
	  	$('#deleteFilePME_'+id_file).modal('hide');
	    //$("#idsusah").val($(".id_kegiatan_add").val());
	    //$("#idsusahnama").val($(".nama_kegiatan_add").val());
	    //$('.nama_k').text(document.getElementById('idsusahnama').value);
	    //alert(document.getElementById('idsusahnama').value);
//});
}

	//$(document).on('submit', "#hapusFilePME", function(e) {
	function hapusFilePME(){
		var id_file = $("input[name=id_file]").val();
		var id_kegiatan = $("input[name=id_kegiatan2]").val();
      	var urlForm = $("#hapusFilePME").attr('action');
		
		$.ajax({  
            url: urlForm,
            type: "post",  
            data: {id_file:id_file,id_kegiatan:id_kegiatan},
            success: function(data) {
            	alert("Berhasil hapus file.");
              	//window.location.reload();
              	$('#deleteFilePME_'+id_file).modal('hide');
              	//listUnduhFile(id_kegiatan);
              	if(data != "exits"){
              		$("#b_unduh_"+id_kegiatan).attr("disabled","disabled");
				}
              	$('#unduhFile').modal('hide');
            },
            error:function(){
                alert("ERROR : CANNOT CONNECT TO SERVER");
            }
        });
	}
	//});


$(function(){
	$('#example').DataTable( {
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
});



</script>

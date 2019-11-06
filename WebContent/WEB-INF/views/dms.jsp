 <%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix = "sql"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<link rel="shortcut icon" href="<%=request.getContextPath()%>/assets/images/logo-login.png" type="image/x-icon">
		<title>DMS Project</title>
		<jsp:include page="/WEB-INF/views/assets/style.jsp"></jsp:include>
	    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/assets/select2/dist/css/select2.css" />
	     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.12.4/css/bootstrap-select.min.css">
	<style>
* {
    box-sizing: border-box;
}

[class*="grid-c"] {
    float: left;
    padding: 15px;
    border: 2px solid #2e6da4; /*#ffb366;*/
}

.grid-luas{
/*width: 100%;*/
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
/*width: 50%;*/
}

.grid-kanan{
/*width: 20%;*/
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
	.easyPaginateNav{padding-top:20px; margin-right:8px; width: 1000px;}

</style>
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
    	<div class="container body">
      		<div class="main_container">
      			<jsp:include page="header_admin.jsp"></jsp:include>
      			<jsp:include page="sidebar.jsp"></jsp:include>
      			
      			<!-- main content -->
      			<div class="right_col" role="main">
          			<div class="row">
            			<div class="col-md-12 col-sm-12 col-xs-12">
              				<div class="dashboard_graph">
                				<div class="x_title">
									<h2>Data Proyek</h2>
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
												<h4 class="modal-title">Tambah Proyek Dms</h4>
											</div>
												<div class="modal-body">
													<input type="hidden" name="user_id" id="user_id" value="<% out.print(session.getAttribute("user_id")); %>">
													<div class="form-group">
														<label for="">Project Name <span class="">*</span></label>
														<input type="text" name="proyek_name" id="proyek_name"  value=""  class="form-control" placeholder="Nama Proyek">
													</div>
													<div class="form-group">
														<label for="">Area</label>
														<input type="text" name="proyek_region" id="proyek_region"  value=""  class="form-control" placeholder="Nama Area">
													</div>
											
													<div class="form-group">
														<label for="">Sektor</label>
														<select name="proyek_sektor"  id="sektor" class="form-control selectpicker" data-live-search="true"  >
															<option value="">Pilih Sektor</option>
															<c:forEach begin="1" end="${msg.sector.size()}" varStatus="loop">
																<option value="${msg.sector.get(loop.index-1).getIdSektor()}">${msg.sector.get(loop.index-1).getNamaSektor()}</option>
															</c:forEach>
														</select>
													</div>
												</div>
												<div class="modal-footer">
													<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
													<button type="submit" class="btn btn-success" onclick="saveProject();">Submit</button>
												</div>
											
										</div>
									</div>
								</div>
								
								
				            <div class="col-md-12 col-sm-12 col-xs-12">                				  	
                				  	
                				  	<!-- ${msg } -->
                				<div class="x_content">
									<div class="row">
										<!-- <form action="<%=request.getContextPath()%>/DMS/search_proyek" method="post" role="form">  -->
											<div class="form-group col-sm-2">
											<!-- <label for="">Jenis Dokumen</label>
											<input type="text" class="form-control" name="jenis_dok" id="jenis_dok" value="">-->
											</div>
											
											<div class="form-group col-sm-2">
												<!-- <label for="">No. Surat</label>
												<input type="text" class="form-control" name="no_surat" id="no_surat"  value="">-->
											</div>
											<div class="form-group col-sm-2">
												<!-- <label for="">Tgl. Surat</label>
												<input type="text" class="form-control" name="tgl_surat" id="tgl_surat"  value="">-->
											</div>
											<div class="form-group col-sm-2">
												<!-- <label for="">Perihal</label>
												<input type="text" class="form-control" name="perihal" id="perihal"  value="">-->
											</div>
											
											<!-- 
											<div class="form-group col-sm-2">
												<label for="">Sektor</label>
												<input type="text" class="form-control" name="sektor" id="sktor"  value="">
											</div>
											 -->
											<div class="form-group col-sm-6 select2-container">
														<label for="">Sektor</label>
														<select name="sektor" id="sktor" class="form-control selectpicker" data-live-search="true"  >
															<option value="">Pilih Sektor</option>
															<c:forEach begin="1" end="${msg.sector.size()}" varStatus="loop">
																<option value="${msg.sector.get(loop.index-1).getNamaSektor()}">${msg.sector.get(loop.index-1).getNamaSektor()}</option>
															</c:forEach>
														</select>
											</div>
											<div class="form-group col-sm-1"></div>
											<!--<div class="form-group col-sm-2">
												<label for="">Nama Proyek</label>
												<input type="text" class="form-control" name="proyekname" id="proyekname"  value="">
											</div>-->
											<div class="form-group col-sm-2">
												<label for="">&nbsp</label>
												<button type="submit" id="cari" class="form-control btn btn-primary" onclick="cariProyek()">Cari</button>
											</div>
										<!-- </form>  -->
									</div>
								</div>
							
							<div id="table-search">	
								<!-- load dari search_proyek.jsp -->
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
		<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.12.4/js/bootstrap-select.min.js"></script>
	</body>
	
	<script type="text/javascript">
	
	$(document).ready(function(){
		cariProyek();
		
		$('.selectpicker').selectpicker();
		
		/*
		$("#sektor").select2({
			width:'570px'
		});
		
		$(".sektoredit").select2({
			width:'570px'
		});
		$("#sktor").select2({
			//width:'500px'
		});
		*/
		
		$("#tgl_surat").datepicker({
			dateFormat : 'yy-mm-dd',
			changeMonth: true,
			changeYear: true,
			autoSize: true
		});
		
		$(window).on('resize', function() {
		      $('.form-group').each(function() {
		        var formGroup = $(this),
		          formgroupWidth = formGroup.outerWidth();  
		        formGroup.find('.select2-container').css('width', formgroupWidth);
		        
		      });
		    });

		$('.modal').on('hidden.bs.modal', function(){
		    $(this).find('form')[0].reset();
		});		
	
	});
	
	
	$('#paging').easyPaginate({
	    paginateElement: 'grid',
	    elementsPerPage: 4,
	    numeric: true,
	    firstButton : false,
	    lastButton : false,
	    prevButtonText : 'Previous',
	    nextButtonText : 'Next'
	    
	});

	
	
	function cariProyek(){
		var jenis_dok = $('#jenis_dok').val();
		var foldername = '';
		var no_surat = $('#no_surat').val();
		var tgl_surat = $('#tgl_surat').val();
		var perihal = $('#perihal').val();
		var proyekname = $('#proyekname').val();
		var sktor = $('#sktor').val();
		
		//alert(filename);
		//$('#loading').html('<img src="../images/ajax-loader.gif" /><br/>Loading');
		//
		$.ajax({
			type: "POST",
			url : "DMS/search_proyek",
			data: {jenis_dok:jenis_dok, foldername:foldername, no_surat:no_surat, tgl_surat:tgl_surat, perihal:perihal, proyekname:proyekname,sktor:sktor},
				success: function(msg){
					//alert(yearfrom);
					$('#table-search').html(msg);
				},
				error:function(){
					error('error request !');
				}
		});
	}
	
	
	function saveProject(){
		var proyek_name=$("#proyek_name").val();
		var proyek_region=$("#proyek_region").val();
		var proyek_sektor=$("#sektor").val();
		var arr = ["<", ">", "?", "[", "]", "{", "}", "&", "/", "'\'", "`", "^", "*", "#", "~", ";", ":", "|"];
      	
      	var xss = false;
       	for (var i=0; i < arr.length; i++) {
       		if (proyek_name.includes(arr[i])){
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
		else if(proyek_region == ""){
			alert("Area tidak boleh kosong");
		}
		else if(proyek_sektor == ""){
			alert("Sektor tidak boleh kosong");
		}else if (xss){
			alert("Inputan tidak bisa mengandung karakter spesial ex: <, >, #...");
		}else{
			$.ajax({
				type: "POST",
				url : "<%=request.getContextPath()%>/DMS/cek_proyek",
				data: {proyek_name:proyek_name},
					success: function(data){
						if(data == "true"){
							alert("Nama Proyek sudah ada, silahkan pilih yang lain");
						}else{
							$.ajax({
								type: "POST",
								url : "<%=request.getContextPath()%>/DMS/SaveProject",
								data: {proyek_name:proyek_name, proyek_region:proyek_region, proyek_sektor:proyek_sektor, user_id:$("#user_id").val()},
									success: function(data){
										alert("Berhasil Tambah Proyek");
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
	
	
	 $(function() { 
	        $(document).on('submit', "#formEdit", function(e) {
	            e.preventDefault();
	            var url = $(this).attr('action');
	            var form = $(this).serialize();
				var names = this.proyek_name.value;
				var regions = this.proyek_region.value;
	            var arr = ["<", ">", "?", "[", "]", "{", "}", "&", "/", "'\'", "`", "^", "*", "#", "~", ";", ":", "|"];
	          	
	          	var xss = false;
	           	for (var i=0; i < arr.length; i++) {
	           		if (names.includes(arr[i])){
	           			xss = true;
	           			break;
	           		}else if(regions.includes(arr[i])){
	           			xss = true;
	           			break;
	                }else {
	           			xss = false;
	           		}
	           	}
	    		if(names == ""){
	    			alert("Nama Proyek tidak boleh kosong");
	    		}
	    		else if(regions == ""){
	    			alert("Area tidak boleh kosong");
	    		}
	    		else if(this.proyek_sektor.value == ""){
	    			alert("Sektor tidak boleh kosong");
	    		}else if (xss){
	    			alert("Inputan tidak bisa mengandung karakter spesial ex: <, >, #...");
	    		}else{
	    			if(this.compare_proyek.value==this.proyek_name.value){
	    	    		$.ajax({  
	    	                url: url,
	    	                type: "post",  
	    	                data: form,
	    	                error:function(){
	    	                    alert("ERROR : CANNOT CONNECT TO SERVER");
	    	                },
	    	                success: function(data) {
	    	                    alert("berhasil edit proyek");
	    	                    window.location.reload();
	    	                }
	    	            });	
	    			}else{
	    				$.ajax({
	    					type: "POST",
	    					url : "<%=request.getContextPath()%>/DMS/cek_proyek",
	    					data: {proyek_name:this.proyek_name.value},
	    						success: function(data){
	    							if(data == "true"){
	    								alert("Nama Proyek sudah ada, silahkan pilih yang lain");
	    							}else{
	    					    		$.ajax({  
	    					                url: url,
	    					                type: "post",  
	    					                data: form,
	    					                error:function(){
	    					                    alert("ERROR : CANNOT CONNECT TO SERVER");
	    					                },
	    					                success: function(data) {
	    					                    alert("berhasil edit proyek");
	    					                    window.location.reload();
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
	            return false; 
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
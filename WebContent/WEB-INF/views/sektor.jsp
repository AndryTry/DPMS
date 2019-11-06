<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<link rel="shortcut icon" href="<%=request.getContextPath()%>/assets/images/logo-login.png" type="image/x-icon">
		<title>Sektor Management</title>
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
			if (session.getAttribute("sektorNull") != null){
				session.removeAttribute("sektorNull");
				out.println("<script type=\"text/javascript\">");
			    out.println("alert('Nama sektor harus di isi');");
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
                  					<div class="col-md-6">
                    					<button class="btn btn-primary" data-toggle="modal" data-target="#formAdd">
    										<i class="fa fa-plus"> ADD NEW SEKTOR</i>
										</button>

                  					</div>
                				</div>
                				
								<div class="modal fade" id="formAdd" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    								<div class="modal-dialog">
        								<div class="modal-content">
            								<div class="modal-header">
                								<button type="button" class="close" data-dismiss="modal">
                       								<span aria-hidden="true">&times;</span>
                       								<span class="sr-only">Close</span>
                								</button>
                								<h4 class="modal-title" id="myModalLabel">ADD NEW SEKTOR</h4>
            								</div>
            								<div class="modal-body">
                								<form role="form" action="Sektor/Add" method="post" id="tambah_sektor">
                  									<div class="form-group">
                    									<input type="text" class="form-control" name="namasektor" placeholder="Nama Sektor"/>
                  									</div>
                  									
										            <div class="modal-footer">
										                <button type="button" class="btn btn-default"
										                        data-dismiss="modal">
										                            Close
										                </button>
										                <input type="submit" value="Save changes" class="btn btn-primary">
										            </div>
                								</form>   
								            </div>
								        </div>
								    </div>
								</div>
								
								<div class="modal fade" id="formEdit" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    								<div class="modal-dialog">
        								<div class="modal-content">
            								<div class="modal-header">
                								<button type="button" class="close" data-dismiss="modal">
                       								<span aria-hidden="true">&times;</span>
                       								<span class="sr-only">Close</span>
                								</button>
                								<h4 class="modal-title" id="myModalLabel1">EDIT Sektor </h4>
            								</div>
            								<div class="modal-body">
                								<form role="form" action="Sektor/Edit" method="post" id="edit_sektor">
                  									<input class="form-control sektor_id" type="hidden" name="sektor_id"/>
                  									<div class="form-group">
                    									<input type="text" class="form-control name" name="name" placeholder="Nama Sektor" value="<span class='name'></span>"/>
                  									</div>
                  									
										            <div class="modal-footer">
										                <button type="button" class="btn btn-default"
										                        data-dismiss="modal">
										                            Close
										                </button>
										                <input type="submit" value="Save changes" class="btn btn-primary">
										            </div>
                								</form>   
								            </div>
								        </div>
								    </div>
								</div>
								
								<div class="modal fade" id="formDelete" tabindex="-1" role="dialog" aria-labelledby="myModalLabel2" aria-hidden="true">
    								<div class="modal-dialog">
        								<div class="modal-content">
            								<div class="modal-header">
                								<button type="button" class="close" data-dismiss="modal">
                       								<span aria-hidden="true">&times;</span>
                       								<span class="sr-only">Close</span>
                								</button>
                								<h4 class="modal-title" id="myModalLabel2">DELETE SEKTOR</h4>
            								</div>
            								<div class="modal-body">
                  									Apakah Anda yakin akan menghapus Sektor "<span class="name"></span>" ?
                  								
								            </div>
								            <div class="modal-footer">
										            <form role="form" action="Sektor/Delete" method="post" id="delete_sektor">
                 									<input class="form-control sektor_id" type="hidden" name="sektor_id"/>
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
                				
                				
				                <div class="col-md-12 col-sm-12 col-xs-12">                				  	
                				  	<table id="datatable-responsive" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
								         <thead>
									         <tr>
									            <th>No</th>
									            <th>User Name</th>
									            <th>Action</th>
									         </tr>
									      </thead>
									      <tbody>
													
									<c:forEach items="${sektorList}" var="sektor" begin="0" end="${sektorList.size()}" varStatus="loop">
										<tr>
							               <td><c:out value="${loop.index+1}"/></td>
							               <td><c:out value="${sektor.namaSektor}"/></td>
							               <td> 
										   <a data-target="#formEdit" class="btn btn-warning btn-xs" data-toggle="modal" 
										   		data-id="<c:out value="${sektor.idSektor}"/>" 
										   		data-name="<c:out value="${sektor.namaSektor}"/>">
										   		<i class="fa fa-edit"></i> Edit</a> 
							               <a data-target="#formDelete" class="btn btn-danger btn-xs" data-toggle="modal" data-id="<c:out value="${sektor.idSektor}"/>" data-name="<c:out value="${sektor.namaSektor}"/>"><i class="fa fa-trash"></i> Delete</a>
							               </td>
							            </tr>
									</c:forEach>
									</tbody>
								   </table>
                				  	
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
 <script>
  
  	$('#formDelete').on('show.bs.modal', function (e) {
	    var myID = $(e.relatedTarget).attr('data-id');
	    var myName = $(e.relatedTarget).attr('data-name');
	    $(".sektor_id").val(myID);
	    $(this).find('.name').text(myName.trim());
	});
	
   	$('#formEdit').on('show.bs.modal', function (e) {
	    var myID = $(e.relatedTarget).attr('data-id');
	    var myName = $(e.relatedTarget).attr('data-name');
	    $(".sektor_id").val(myID);
	    $(".name").val(myName);
	});
   	
   	$('#formAdd').on('show.bs.modal', function(){
   	    $(this).find('form')[0].reset();
   	});
   	
   	$(document).on('submit', "#tambah_sektor", function(e) {
        e.preventDefault();
     	var urlForm = $(this).attr('action');
      	var dataForm = $(this).serialize();
      	var name = this.namasektor.value;
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
			alert("Nama Sektor tidak boleh kosong");
		}else if (xss){
			alert("Inputan tidak bisa mengandung karakter spesial ex: <, >, #...");
		}else{
			$.ajax({
				type: "POST",
				url : "<%=request.getContextPath()%>/Sektor/CheckSektor",
				data: {name:name},
					success: function(data){
						if(data == "true"){
							alert("Sektor ini sudah terdaftar.");
						}else{
							$.ajax({  
					            url: urlForm,
					            type: "post",  
					            data: dataForm,
					            error:function(){
					                alert("ERROR : CANNOT CONNECT TO SERVER");
					            },
					            success: function(data) {
					            	alert("berhasil tambah sektor");
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
    });
    
    $(document).on('submit', "#edit_sektor", function(e) {
        e.preventDefault();
     	var urlForm = $(this).attr('action');
      	var dataForm = $(this).serialize();
      	var name = this.name.value;
        if(name == ""){
			alert("Nama Sektor tidak boleh kosong");
		}else{
			$.ajax({
				type: "POST",
				url : "<%=request.getContextPath()%>/Sektor/CheckSektor",
				data: {name:name},
					success: function(data){
						if(data == "true"){
							alert("Sektor ini sudah terdaftar.");
						}else{
							$.ajax({  
					            url: urlForm,
					            type: "post",  
					            data: dataForm,
					            error:function(){
					                alert("ERROR : CANNOT CONNECT TO SERVER");
					            },
					            success: function(data) {
					            	alert("berhasil edit sektor");
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
    });      
    
    $(document).on('submit', "#delete_sektor", function(e) {
        e.preventDefault();
     	var urlForm = $(this).attr('action');
      	var dataForm = $(this).serialize();
      	var id = this.sektor_id.value;

      	$.ajax({
			type: "POST",
			url : "<%=request.getContextPath()%>/Sektor/CheckHapusSektor",
			data: {id_sektor:id},
				success: function(data){
					if(data == "true"){
						alert("Sektor ini sudah dipakai.");
					}else{	
				        $.ajax({  
				            url: urlForm,
				            type: "post",  
				            data: dataForm,
				            error:function(){
				                alert("ERROR : CANNOT CONNECT TO SERVER");
				            },
				            success: function(data) {
				            	alert("Berhasil hapus sektor");
				                window.location.reload();
				            }
				        });
					}
				},
				error:function(){
					error('error request !');
				}
			});
		});

 </script> 
 
</html>

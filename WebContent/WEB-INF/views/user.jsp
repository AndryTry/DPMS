<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<link rel="shortcut icon" href="<%=request.getContextPath()%>/assets/images/logo-login.png" type="image/x-icon">
		<title>User Management</title>
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
	
		if(session.getAttribute("errorCreateUser") != null && session.getAttribute("msg") != null){
			session.removeAttribute("errorCreateUser");
			if (session.getAttribute("msg").equals("password")){
				out.println("<script type=\"text/javascript\">");
			    out.println("alert('Password minimal 8 character');");
			    out.println("</script>");
		    }
		}else if (session.getAttribute("errorCreateUser") != null){
			if (session.getAttribute("errorCreateUser").equals("duplicate")){
				session.removeAttribute("errorCreateUser");
				out.println("<script type=\"text/javascript\">");
			    out.println("alert('Duplicate email address');");
			    out.println("</script>");
			}
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
                    					<button class="btn btn-primary" data-toggle="modal" data-target="#formUser">
    										<i class="fa fa-plus"> ADD NEW USER</i>
										</button>

                  					</div>
                				</div>
                				
                				<!-- Form User -->
								<div class="modal fade" id="formUser" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    								<div class="modal-dialog">
        								<div class="modal-content">
            								<div class="modal-header">
                								<button type="button" class="close" data-dismiss="modal">
                       								<span aria-hidden="true">&times;</span>
                       								<span class="sr-only">Close</span>
                								</button>
                								<h4 class="modal-title" id="myModalLabel">ADD NEW USER</h4>
            								</div>
            								<div class="modal-body">
                  									<div class="form-group">
                    									<input type="text" class="form-control" name="name" id="name" placeholder="Nama User" required/>
                  									</div>
                  									<div class="form-group">
                      									<select class="form-control" name="level" id="level" required>
                      										<option value="">Pilih User Level</option>
                      										<% 
																for(int i=1; i<4; i++){%>
                      												<option value="<%out.println(i);%>"><%out.println("Level "+i); %></option>
                      										<% } %>
                      									</select>
                  									</div>
                  									<div class="form-group">
                      									<input type="email" class="form-control" name="email" id="email" placeholder="User" required/>
                  									</div>
                  									<div class="form-group">
                      									<input type="password" class="form-control" name="password" id="password" placeholder="password" required/>
                  									</div>
                  									<div class="form-group">
                  										<label class="control-label"><div align="left">Keterangan</div></label>
                      									<textarea name="desc" id="desc" rows="10" required></textarea>
                  									</div>
                  									
										            <div class="modal-footer">
										                <button type="button" class="btn btn-default"
										                        data-dismiss="modal">
										                            Close
										                </button>
										                <input type="submit" value="Save changes" class="btn btn-primary" onclick="saveUser()">
										            </div>
								            </div>
								        </div>
								    </div>
								</div>
								
								
								<!-- Form Edit User -->
								<div class="modal fade" id="formEditUser" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    								<div class="modal-dialog">
        								<div class="modal-content">
            								<div class="modal-header">
                								<button type="button" class="close" data-dismiss="modal">
                       								<span aria-hidden="true">&times;</span>
                       								<span class="sr-only">Close</span>
                								</button>
                								<h4 class="modal-title" id="myModalLabel1">EDIT USER</h4>
            								</div>
            								<div class="modal-body">
                  									<input class="form-control user_id" type="hidden" id="user_id" name="user_id">
                  									<div class="form-group">
                    									<input type="text" required class="form-control name" name="name" id="edit_name" placeholder="Nama User" value="<span class='name'></span>"/>
                  									</div>
                  									<div class="form-group">
                      									<select id="pilih" class="form-control" name="level" required>
                      										<option value="">Pilih User Level</option>
                      										<% 
																for(int i=1; i<4; i++){%>
                      												<option value="<%out.println(i);%>"><%out.println("Level "+i); %></option>
                      										<% } %>
                      									</select>
                  									</div>
                  									<div class="form-group">
                      									<input type="password" class="form-control" name="password" id="edit_password" placeholder="password"/>
                  										<div class="checkbox">
														<label>
															<input type="checkbox" value="yes" name="ganti_password" id="ganti_password" class="edit_ganti_password"> Ganti Password
														</label>
													</div>
                  									</div>
                  									<div class="form-group">
                  										<label class="control-label"><div align="left">Keterangan</div></label>
                      										<textarea id="description" name="description" id="description" rows="10" required></textarea>
                  									</div>
                  									
										            <div class="modal-footer">
										                <button type="button" class="btn btn-default"
										                        data-dismiss="modal">
										                            Close
										                </button>
										                <input type="submit" value="Save changes" class="btn btn-primary" onclick="editUser()">
										            </div>
								            </div>
								        </div>
								    </div>
								</div>
								
								<!-- Form Delete User -->
								<div class="modal fade" id="formDeleteUser" tabindex="-1" role="dialog" aria-labelledby="myModalLabel2" aria-hidden="true">
    								<div class="modal-dialog">
        								<div class="modal-content">
            								<div class="modal-header">
                								<button type="button" class="close" data-dismiss="modal">
                       								<span aria-hidden="true">&times;</span>
                       								<span class="sr-only">Close</span>
                								</button>
                								<h4 class="modal-title" id="myModalLabel2">DELETE USER</h4>
            								</div>
            								<div class="modal-body">
                 									<input class="form-control user_id" type="hidden" id="user_id" name="user_id">
                  									Apakah Anda yakin akan menghapus user "<span class="name"></span>" ?
                  								
								            </div>
								            <div class="modal-footer">
									                <button type="button" class="btn btn-default"
									                        data-dismiss="modal">
									                            Close
									                </button>
									                <input type="submit" value="Delete" class="btn btn-danger" onclick="deleteUser()">
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
									            <th>Level</th>
									            <th>Action</th>
									         </tr>
									      </thead>
									      <tbody>
													
									<c:forEach items="${userList}" var="user" begin="0" end="${userList.size()}" varStatus="loop">
										<tr>
							               <td><c:out value="${loop.index+1}"/></td>
							               <td><c:out value="${user.username}"/></td>
							               <td><c:out value="${user.userLevel}"/></td>
							               <td> 
										   <a data-target="#formEditUser" class="btn btn-warning btn-xs" data-toggle="modal" 
										   		data-id="<c:out value="${user.userID}"/>" 
										   		data-name="<c:out value="${user.username}"/>"
										   		data-email="<c:out value="${user.email}"/>"
										   		data-level="<c:out value="${user.level}"/>"
										   		data-content="<c:out value="${user.desc}"/>">
										   		<i class="fa fa-edit"></i> Edit</a> 
							               <a data-target="#formDeleteUser" class="btn btn-danger btn-xs" data-toggle="modal" data-id="<c:out value="${user.userID}"/>" data-name="<c:out value="${user.username}"/>"><i class="fa fa-trash"></i> Delete</a>
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
 	tinymce.init({ selector:'textarea' });
 	function form_submit_delete() {
	    document.getElementById("delete_user").submit();
	   }   
	  
  	$('#formDeleteUser').on('show.bs.modal', function (e) {
	    var myID = $(e.relatedTarget).attr('data-id');
	    var myName = $(e.relatedTarget).attr('data-name');
	    $(".user_id").val(myID);
	    $(this).find('.name').text(myName.trim());
	});
	
   	$('#formEditUser').on('show.bs.modal', function (e) {
	    var myID = $(e.relatedTarget).attr('data-id');
	    var myName = $(e.relatedTarget).attr('data-name');
	    var myEmail = $(e.relatedTarget).attr('data-email');
	    var myDesc = $(e.relatedTarget).attr('data-content');
	    var myLevel = $(e.relatedTarget).attr('data-level');
	    $(".user_id").val(myID);
	    $(".name").val(myName);
	    $(".email").val(myEmail);
	    tinyMCE.get('description').setContent(myDesc);
	    document.getElementById('pilih').options[myLevel].selected = 'selected';
	    
	});
   	
   	function saveUser(){
   		var name = $("#name").val();
   		var email = $("#email").val();
   		var password = $("#password").val();
   		var level = $("#level").val();
   		
   		tinyMCE.activeEditor.getContent();
   		tinyMCE.activeEditor.getContent({format : 'raw'});
   		var desc = tinyMCE.get("desc").getContent();
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
   			alert('Nama tidak boleh kosong.');
   		}else if (level == ""){
   			alert('Silahkan pilih level anda.');
   		}else if (!validateEmail(email) || email == ""){
   			alert('Format email anda salah.');
   		}else if (password.length < 7 || password == ""){
   			alert('Password harus lebih dari 7 karakter.');
   		}else if (desc == ""){
   			alert('Keterangan tidak boleh kosong.');
   		}else if (xss){
			alert("Inputan tidak bisa mengandung karakter spesial ex: <, >, #...");
		}else{
   			$.ajax({
				type: "POST",
				url : "<%=request.getContextPath()%>/User/CheckUser",
				data: {email:email},
					success: function(data){
						if(data == "true"){
							alert("Email ini sudah terdaftar.");
						}else{
							$.ajax({
								type: "POST",
								url : "<%=request.getContextPath()%>/User/SaveUser",
								data: {name:name, email:email, password:password, level:level, desc:desc},
									success: function(data){
										alert('Berhasil menambah user baru.');
										window.location.reload();
									},
									error:function(){
										error('Gagal menambah user baru.');
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
   	
   	function editUser(){
   		var name = $("#edit_name").val();
   		var password = $("#edit_password").val();
   		var level = $("#pilih").val();
   		var ganti_password = $('.edit_ganti_password:checked').val();
   		
   		tinyMCE.activeEditor.getContent();
   		tinyMCE.activeEditor.getContent({format : 'raw'});
   		var desc = tinyMCE.get("description").getContent();
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
   			alert('Nama tidak boleh kosong.');
   		}else if (level == ""){
   			alert('Silahkan pilih level anda.');
   		}else if (password.length > 0 && !document.getElementById('ganti_password').checked){
   			alert('Checkbox ganti password belum di centang.');
   		}else if (ganti_password == "yes" && password.length < 7){
  			alert('Password harus lebih dari 7 karakter.');
   		}else if (desc == ""){
   			alert('Keterangan tidak boleh kosong.');
   		}else if (xss){
			alert("Inputan tidak bisa mengandung karakter spesial ex: <, >, #...");
		}else{
			$.ajax({
				type: "POST",
				url : "<%=request.getContextPath()%>/User/EditUser",
				data: {name:name, password:password, level:level, description:desc,ganti_password:ganti_password,user_id:$("#user_id").val()},
					success: function(data){
						alert('User berhasil dirubah.');
						window.location.reload();
					},
					error:function(){
						error('User gagal dirubah.');
					}
			});			
		}
   	}
   	
   	function deleteUser(){
   		$.ajax({
			type: "POST",
			url : "<%=request.getContextPath()%>/User/DeleteUser",
			data: {user_id:$("#user_id").val()},
				success: function(data){
					alert('User berhasil dihapus.');
					window.location.reload();
				},
				error:function(){
					error('User gagal dihapus.');
				}
		});	
   	}
   	
   	function validateEmail(email) {
   	  var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
   	  return re.test(email);
   	}
   	
   	//$('#formUser').on('show.bs.modal', function(){
   	  //  $(this).find('form')[0].reset();
   	//});
 </script> 

</html>

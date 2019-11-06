<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Menu Beranda Management</title>
		<jsp:include page="/WEB-INF/views/assets/style.jsp"></jsp:include>
		<link href="<%=request.getContextPath()%>/assets/summernote/dist/summernote.css" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/codemirror.css">
		<link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/theme/monokai.css">
	<!-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.25.0/codemirror.min.css">
		<link href="https://cdnjs.cloudflare.com/ajax/libs/froala-editor/2.6.0/css/froala_editor.pkgd.min.css" rel="stylesheet" type="text/css" />
	  <link href="https://cdnjs.cloudflare.com/ajax/libs/froala-editor/2.6.0/css/froala_style.min.css" rel="stylesheet" type="text/css" /> -->
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
	
		if(session.getAttribute("errorCreatemenu") != null && session.getAttribute("msg").equals("password")){
			session.removeAttribute("errorCreatemenu");
			out.println("<script type=\"text/javascript\">");
		    out.println("alert('Password length must be at least 8 character');");
		    out.println("</script>");
		}else if(session.getAttribute("errorCreatemenu") != null){
			session.removeAttribute("errorCreatemenu");
			out.println("<script type=\"text/javascript\">");
		    out.println("alert('Duplicate email address');");
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
                    					<button class="btn btn-primary" data-toggle="modal" data-target="#formmenu">
    										<i class="fa fa-plus"> ADD NEW Menu</i>
										</button>

                  					</div>
                				</div>
                				
                				<!-- Form menu -->
								<div class="modal fade" id="formmenu" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    								<div class="modal-dialog">
        								<div class="modal-content">
            								<div class="modal-header">
                								<button type="button" class="close" data-dismiss="modal">
                       								<span aria-hidden="true">&times;</span>
                       								<span class="sr-only">Close</span>
                								</button>
                								<h4 class="modal-title" id="myModalLabel">ADD NEW Menu</h4>
            								</div>
            								<div class="modal-body">
                								<form role="form" action="Menu_beranda/Add" method="post" id="menu">
                  									<div class="form-group">
                    									<input type="text" class="form-control" name="name" placeholder="Nama Menu" required/>
                  									</div>
                  									<div class="form-group">
                      									<input type="text" class="form-control" name="url" placeholder="Url Menu" required/>
                  									</div>
                  									<div class="form-group">
                      									<select class="form-control" name="jenis" required>
                      										<option value="">Pilih Jenis Menu</option>
                      										<option value="menu_header">menu_header</option>
                      										<option value="menu_linksitus">menu_linksitus</option>
                      										<option value="menu_sop">menu_sop</option>
                      									</select>
                  									</div>
                  									<div class="form-group">
                  										<label class="control-label"><div align="left">Content</div></label>
                      									<textarea id="content" name="content"></textarea>
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
								</div>
								
								
								<!-- Form Edit menu -->
								<div class="modal fade" id="formEditmenu" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    								<div class="modal-dialog">
        								<div class="modal-content">
            								<div class="modal-header">
                								<button type="button" class="close" data-dismiss="modal">
                       								<span aria-hidden="true">&times;</span>
                       								<span class="sr-only">Close</span>
                								</button>
                								<h4 class="modal-title" id="myModalLabel1">EDIT menu</h4>
            								</div>
            								<div class="modal-body">
                								<form role="form" action="Menu_beranda/Edit" method="post" id="menu">
                  									<input class="form-control id_menu" type="hidden" name="id_menu">
                  									<div class="form-group">
                    									<input type="text" required class="form-control name" name="name" placeholder="Nama menu" value="<span class='name'></span>"/>
                  									</div>
                  									<div class="form-group">
                      									<select id="pilih" class="form-control" name="jenis" required>
                      										<option value="">Pilih Jenis menu</option>
                      										<option value="menu_header">menu_header</option>
                      										<option value="menu_linksitus">menu_linksitus</option>
                      										<option value="menu_sop">menu_sop</option>
                      									</select>
                  									</div>
                  									<div class="form-group">
                      									<input type="input" required class="form-control url" name="url" placeholder="url" value="<span class='url'></span>"/>
                  									</div>
                  									<div class="form-group">
                  										<label class="control-label"><div align="left">Content</div></label>
                      									<textarea id="content_edit" name="content" style="height: 350px; width: 100%;"></textarea>	
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
								</div>
								
								<!-- Form Delete menu -->
								<div class="modal fade" id="formDeletemenu" tabindex="-1" role="dialog" aria-labelledby="myModalLabel2" aria-hidden="true">
    								<div class="modal-dialog">
        								<div class="modal-content">
            								<div class="modal-header">
                								<button type="button" class="close" data-dismiss="modal">
                       								<span aria-hidden="true">&times;</span>
                       								<span class="sr-only">Close</span>
                								</button>
                								<h4 class="modal-title" id="myModalLabel2">DELETE menu</h4>
            								</div>
            								<div class="modal-body">
                  									Apakah Anda yakin akan menghapus menu "<span class="name"></span>" ?
                  								
								            </div>
								            <div class="modal-footer">
										            <form role="form" action="Menu_beranda/Delete" method="post" id="menu">
                 									<input class="form-control id_menu" type="hidden" name="id_menu">
									                <button type="button" class="btn btn-default"
									                        data-dismiss="modal">
									                            Close
									                </button>
									                <input type="submit" value="Delete" class="btn btn-danger" onclick="form_submit()">
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
									            <th>Nama Menu</th>
									            <th>URL</th>
									            <th>Jenis</th>
									            <th>Content</th>
									            <th>Action</th>
									         </tr>
									      </thead>
									      <tbody>
													
									<c:forEach items="${menuList}" var="menu" begin="0" end="${menuList.size()}" varStatus="loop">
										<tr>
							               <td><c:out value="${loop.index+1}"/></td>
							               <td><c:out value="${menu.namaMenu}"/></td>
							               <td><c:out value="${menu.url}"/></td>
							               <td><c:out value="${menu.jenis}"/></td>
							               <td> <c:choose><c:when test="${menu.namaMenu == 'Beranda'}">Default</c:when><c:otherwise><c:out value="${menu.content}" escapeXml="false"/></c:otherwise></c:choose></td>
							               <td> 
							               <c:if test="${menu.namaMenu != 'Beranda'}">
											   <a data-target="#formEditmenu" class="btn btn-warning btn-xs" data-toggle="modal" 
											   		data-id="<c:out value="${menu.idMenu}"/>" 
											   		data-name="<c:out value="${menu.namaMenu}"/>"
											   		data-url="<c:out value="${menu.url}"/>"
											   		data-jenis="<c:out value="${menu.jenis}"/>"
											   		data-content="<c:out value="${menu.content}"/>">
											   		<i class="fa fa-edit"></i> Edit</a> 
								               <a data-target="#formDeletemenu" class="btn btn-danger btn-xs" data-toggle="modal" data-id="<c:out value="${menu.idMenu}"/>" data-name="<c:out value="${menu.namaMenu}"/>"><i class="fa fa-trash"></i> Delete</a>
								            </c:if>
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
     	<script type="text/javascript" src="<%=request.getContextPath()%>/assets/summernote/dist/summernote.js"></script>
     	  
     	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/codemirror.js"></script>
		<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/codemirror/3.20.0/mode/xml/xml.js"></script>
		<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/codemirror/2.36.0/formatting.js"></script>
     	<!--
     	<script type="text/javascript" src="<%=request.getContextPath()%>/assets/edit_area/edit_area_full.js"></script>
     	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/froala-editor/2.6.0//js/froala_editor.pkgd.min.js"></script>
		-->
	</body>
 <script>
 
 $('#datatable-responsive').dataTable( {
	 "rowCallback": function( row, data, index ) {
		    if ( data[2] == "Beranda" )
		    {
		        $('td', row).css('background-color', '#ddd!important');
		    }
		  }
});
 
 $(function() {
	
	 $('#content').summernote({
		  height: 150,   //set editable area's height
		  codemirror: {
			mode: 'text/html',
	        htmlMode: true,
	        lineNumbers: true,
		    theme: 'monokai'
		  }
	});
	 
	 $('#content_edit').summernote({
		  height: 150,   //set editable area's height
		  codemirror: {
			mode: 'text/html',
	        htmlMode: true,
	        lineNumbers: true,
		    theme: 'monokai'
		  }
	});
	 
	 
	 
	 /*
	 editAreaLoader.init({
			id: "content"	// id of the textarea to transform		
			,start_highlight: true	// if start with highlight
			,allow_resize: "both"
			,allow_toggle: true
			,word_wrap: true
			,language: "en"
			,syntax: "html"
			,syntax_selection_allow: "css,html,js,java,php,python,vb,xml,c,cpp,sql,basic,pas,brainfuck"
	});
	
	 $('textarea#content').froalaEditor({
	    	fullPage : true
	    });
	 */
	});
 /*
 function uploadImage(image) {
	    var data = new FormData();
	    data.append("image", image);
	    $.ajax({
	        url: './assets/images/',
	        cache: false,
	        contentType: false,
	        processData: false,
	        data: data,
	        type: "post",
	        success: function(url) {
	            var image = $('<img>').attr('src', + url);
	            $('#summernote').summernote("insertNode", image[0]);
	        },
	        error: function(data) {
	            console.log(data);
	        }
	    });
	}
 */
 	function form_submit() {
	    document.getElementById("menu").submit();
	    if ($('#content').summernote('codeview.isActivated')) {
	        $('#content').summernote('codeview.deactivate'); 
	    }
	    if ($('#content_edit').summernote('codeview.isActivated')) {
	        $('#content_edit').summernote('codeview.deactivate'); 
	    }
	   }   
	  
  	$('#formDeletemenu').on('show.bs.modal', function (e) {
	    var myID = $(e.relatedTarget).attr('data-id');
	    var myName = $(e.relatedTarget).attr('data-name');
	    $(".id_menu").val(myID);
	    $(this).find('.name').text(myName.trim());
	});
	
   	$('#formEditmenu').on('show.bs.modal', function (e) {
	    var myID = $(e.relatedTarget).attr('data-id');
	    var myName = $(e.relatedTarget).attr('data-name');
	    var myUrl = $(e.relatedTarget).attr('data-url');
	    var myJenis = $(e.relatedTarget).attr('data-jenis');
	    var myContent = $(e.relatedTarget).attr('data-content');
	    $(".id_menu").val(myID);
	    $(".name").val(myName);
	    $(".url").val(myUrl);
	    $('#content_edit').summernote ('code', myContent);
	    $('#pilih option[value='+myJenis+']').prop('selected', true);
	    //editAreaLoader.setValue("content_edit", myContent);
	    //froalaEditor.get('content').setContent(myContent);
	    //document.getElementById("pilih").options[myJenis].selected = "selected";
	});
   	
   	$('#formmenu').on('show.bs.modal', function(){
   	    $(this).find('form')[0].reset();
   	});
 </script> 
</html>

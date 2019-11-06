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
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<link rel="shortcut icon" href="<%=request.getContextPath()%>/assets/images/logo-login.png" type="image/x-icon">
		<title>Dashboard</title>
		<jsp:include page="/WEB-INF/views/assets/style.jsp"></jsp:include>
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/assets/select2/dist/css/select2.css" />
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/assets/circle/css/circle.css" />
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/assets/jPages/css/jPages.css" />
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
		<% Logger logger = Logger.getLogger(this.getClass().getName());%>
		#map_canvas {
		    /*width: 1080px;*/
		    width: 100%;
		    height: 430px;
		    margin-left:0px;
		    margin-right:0px;
		}
		
		@media screen and (max-width: 767px) {
	    #sektor {
	        width: 100% !important;
	    }
	    }
	    .block {
		    pointer-events: none;
		    cursor: default;
		     opacity: 0.6;
		}
		.c100:hover {
			pointer-events: auto;
		}
		
		.grid-col{
			width: 200px;
			height: 220px;
			margin:0px;
		}
		
		#easyPaginate {width:100px;margin:0;white-space: nowrap;}
		.easyPaginateNav a.current {font-weight:bold;text-decoration:underline;}
		.easyPaginateNav{padding-top:0px; margin-right:20px; width: 1000px;}
		.dataTables_filter { visibility: hidden;}
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
		httpResponse.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
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
				logger.info("path_dasar "+path_dasar);
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
      			<!-- main content dms -->
      		<div class="right_col" role="main">
    			<ul class="nav nav-tabs">
		    			<li class="active" id="switchdms"><a href="#dms">DMS</a></li>
	 					<li id="switchpme"><a href="#pme">PME</a></li>
		  		</ul>
    			<div class="tab-content">
    				<!-- content pme -->
    					<div id="pme" class="tab-pane fade">
    						<div class="dashboard_graph">
    						<div class="row">
	              				<div class="col-md-12 col-sm-12 col-xs-12">
	                				<div class="row x_title">
	                  					<div class="col-md-10">
		                  					<div class="btn-group btn-toggle"> 
											  <button class="btn btn-primary" id="get_map">Map</button>
											  <button class="btn btn-default" id="get_diagram">Diagram</button>
											</div>
										</div>
	                				</div>
	                				<div class="x_content">
					                	<div class="col-md-12">      
											<div id="map">
												<div class="row" style="height:500px">
													 <jsp:include page="/WEB-INF/views/assets/indonesia_map.jsp"></jsp:include>
												</div>
											</div>
											<div id="diagram" style="display:none">
												<div class="row" style="margin-left:25px; margin-top:20px">
													<div id="search-circle">
														<!-- load circle dari search_circle.jsp  -->
													</div>
													<div class="col-sm-12 pull-left">
														 <button class="showAll" id="showhide" onclick="showCircle()">Lihat per halaman</button>
													</div>
												</div>
											</div>
											
											<div class="row x_title">
			                  					<div class="col-md-10">
			                    					
			                  					</div>
	                						</div>
	                						
											<div class="col-sm-12">
												<div class="col-sm-3">
													<input id="searchInput" class="form-control" placeholder="Kata Kunci"/>
												</div>
												<div class="col-sm-3">
													<select class="form-control" id="fasilitas" onchange="search_dashboard(this.value), search_dashboard2(this.value);">
							                            <option value="">All Fasilitas</option>
							                            <option value="PDF">PDF</option>
							                            <option value="VGF">VGF</option>
							                            <option value="Penjaminan">Penjaminan</option>
							                            <option value="AP">AP</option>
							                          </select>
												</div>
											</div>
											&nbsp;
											<div class="col-sm-12">
												<div id="searchbro">
												<table id="table-dashbord" class="table table-hover table-striped">
													<thead>
														<tr>
															<th>Nama Proyek</th>
															<th>Wilayah</th>
															<th>PJPK</th>
															<th>Nilai Proyek</th>
															<th>Tahapan Dilalui</th>
															<th>Fasilitas</th>
															
														</tr>
													</thead>
													<tbody id="tdbody">
													<c:forEach begin="1" end="${msg.namaPme.size()}" varStatus="loop">
														<tr>
															<td><a href="<%=request.getContextPath()%>/PME/ViewProjectPME_dashboard?id=${msg.idProjectPme.get(loop.index-1)}">${msg.namaPme.get(loop.index-1)}</a></td>
															<td>${msg.area.get(loop.index-1)}</td>
															<td>${msg.pjpkPme.get(loop.index-1)}</td>
															<td>${msg.investasiPme.get(loop.index-1)}</td>
															<td>${msg.proyekDilalui.get(loop.index-1)}</td>
															<td>${msg.fasilitas.get(loop.index-1)}</td>
														</tr>
													</c:forEach>
													</tbody>
												</table>
												</div>
											</div>							
    									</div>
    								</div>
    								</div>
    							</div>
    						</div>
    					</div>
    					<div id="dms" class="tab-pane fade in active">
    						<div class="row">
	            				<div class="col-md-12 col-sm-12 col-xs-12">
	              				<div class="dashboard_graph">
	                				<div class="row x_title">
	                  					<div class="col-md-6">
	                    					<h4>Cari Document</h4>
	                  					</div>
	                				</div>
					                <div class="col-md-12">      
	                				  	
	                				  	<div class="x_content">
											<div class="row">
												<div class="form-group col-sm-2">
												<label for="">Jenis Dokumen</label>
												<input type="text" class="form-control" name="jenis_dok" id="jenis_dokumen" value="">
												</div>
												
												<div class="form-group col-sm-1">
													<label for="">No. Surat</label>
													<input type="text" class="form-control" name="no_surat" id="no_surat"  value="">
												</div>
												<div class="form-group col-sm-2">
													<label for="">Tgl. Surat</label>
													<input type="text" class="form-control" name="tgl_surat" id="tgl_surat"  value="">
												</div>
												<div class="form-group col-sm-2">
													<label for="">Perihal</label>
													<input type="text" class="form-control" name="perihal" id="perihal"  value="">
												</div>
												<!-- 
												<div class="form-group col-sm-2">
													<label for="">Sektor</label>
													<input type="text" class="form-control" name="sektor" id="sektor"  value="">
												</div>
												 -->
												<div class="form-group col-sm-3 select2-container">
													<label for="">Sektor</label>
													<div class="clearfix"></div>
													<select name="sektor" id="sektor" class="form-control"  required>
														<option value="">Pilih Sektor</option>
														<c:forEach begin="1" end="${msg.sector.size()}" varStatus="loop">
															<option value="${msg.sector.get(loop.index-1).getNamaSektor()}">${msg.sector.get(loop.index-1).getNamaSektor()}</option>
														</c:forEach>
													</select>
													
												</div>
												
												<!-- <div class="form-group col-sm-2">
													<label for="">Nama Proyek</label>
													<input type="text" class="form-control" name="proyekname" id="proyekname"  value="">
												</div> -->
											<!--  <div class="row col-sm-12"> -->
												<div class="form-group col-sm-2">
													<label for="">&nbsp</label>
													<button type="submit" id="cari" onclick="table_search();" class="form-control btn btn-primary"><i class="fa fa-search"></i> Cari</button>
												</div>
											<!--</div>-->
											<!-- </form>  -->
										</div>
									</div>
									<div class="row x_title"></div>           				
				          			<div class="row">
				          				<div id="table-search"></div>
				          			</div>
	                				  	
	                				</div>
	                				<div class="clearfix"></div>  
	              				</div>
	              				
	            			</div>
	          			</div>
    				</div>
				</div>
        		<br/>
        	</div>
      	</div>
     </div>
     	<jsp:include page="/WEB-INF/views/assets/script.jsp"></jsp:include>
     	<script src="<%=request.getContextPath()%>/assets/select2/dist/js/select2.full.js"></script>
		<script src="<%=request.getContextPath()%>/assets/easy-paginate/lib/easyPaginate.js"></script>
		<script src="<%=request.getContextPath()%>/assets/jPages/js/jPages.js"></script>
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
		showCircle(); 
		var table = $('#table-dashbord').DataTable({
	         "bLengthChange": true, 
	        "searching": true,
	        "pageLength": 10,
	        "order": [[ 0, "desc" ]],
	         dom: 'lrtip'
	        });
	        
		/*
	        $('#fasilitas').on('change', function(){
	           table.search(this.value).draw();   
	        });
		*/
		$('#searchInput').keyup(function(){
		      $('#table-dashbord').dataTable().fnFilter(this.value);
		})
		
		
		
		$('#get_map').click(function(){
			 $('#get_map').addClass('btn-primary');
			 $('#get_map').removeClass('btn-default');
			 $('#get_diagram').addClass('btn-default');
			 $('#get_diagram').removeClass('btn-primary');
			 $("#map").show();
	         $("#diagram").hide();
		});
		
		$('#get_diagram').click(function(){
			 $('#get_diagram').addClass('btn-primary');
			 $('#get_diagram').removeClass('btn-default');
			 $('#get_map').addClass('btn-default');
			 $('#get_map').removeClass('btn-primary');
			 $("#diagram").show();
	         $("#map").hide();
		});
		
		
		
			$("path, circle").click(function(e) {
			  $('#info-box').css('display','block');
			  $('#info-box').html($(this).data('info'));	 
			  $('#info-box').css('left',e.pageX-($('#info-box').width())/2);
			  var scrollTop = $(window).scrollTop(),
			      elementOffset = $("path, circle").offset().top,
			      distance = (elementOffset - scrollTop);
			  if(distance > 0 ){
				  $('#info-box').css('top',e.pageY-$('#info-box').height()-30);
			  }else{
				  $('#info-box').css('top',e.pageY-$('#info-box').height()-300);
			  }
			});
			
			$(document).ready(function() {
			    $(window).scroll(function() {
			    	$('#info-box').css('display','none');
			    });
			    //$("#info-box").offset().top;
			});
		
			$('#showAll').click(function(){
				document.getElementById("paging").remove();
			});
		
		
		<!-- table_search();-->
		
		$("#sektor").select2({
			width:'230px'
		});
		
		$(window).on('resize', function() {
			$('.form-group').each(function() {
				var formGroup = $(this),
					formgroupWidth = formGroup.outerWidth();	
				formGroup.find('.select2-container').css('width', formgroupWidth);
				
			});
		});
		
		
		$('#tgl_surat').datepicker({
			dateFormat : 'yy-mm-dd',
			changeMonth: true,
			changeYear: true,
			autoSize: true,
			inline: true
		});
		
		$(".nav-tabs a").click(function(){
	        $(this).tab('show');
	        //initialize();
	        //resetMap(map);
	    });
	    $('.nav-tabs a').on('shown.bs.tab', function(event){
	        var x = $(event.target).text();         // active tab
	        var y = $(event.relatedTarget).text();  // previous tab
	        $(".act span").text(x);
	        $(".prev span").text(y);
	        //initialize();
	       	var pageURL = window.location;
	       	stringUrl = String(pageURL);
	       	var lastURLSegment = stringUrl.substr(stringUrl.lastIndexOf('#') + 1);
	        //alert(lastURLSegment);
	        if(lastURLSegment == 'pme'){
	        	$("#menu-dms").hide();
	        	$("#menu-pme").show();
	        	$('#pme').addClass('in active');
	        	$('#dms').removeClass('in active');
	        	$('#switchdms').removeClass('active');
	        	 $('#switchpme').addClass('in active');
	        }else{
	        	 $("#menu-dms").show();
	        	 $("#menu-pme").hide();
	        	 $('#dms').addClass('in active');
	        	 $('#pme').removeClass('in active');
	        	 $('#switchpme').removeClass('active');
	        	 $('#switchdms').addClass('in active');
	        }
	       // console.log(lastURLSegment);
	    });
	    
	});

	//$('#cari').click(function(){
	function table_search(){
		var jenis_dokumen = $('#jenis_dokumen').val();
		var no_surat = $('#no_surat').val();
		var perihal = $('#perihal').val();
		var tgl_surat = $('#tgl_surat').val();
		var sektor = $('#sektor').val();
		//var proyekname = $('#proyekname').val();
		
		//alert(filename);
		//$('#loading').html('<img src="../images/ajax-loader.gif" /><br/>Loading');
		$.ajax({
			type: "POST",
			url : "Dashboard/Search",
			data: {jenis_dokumen:jenis_dokumen, no_surat:no_surat, perihal:perihal, tgl_surat:tgl_surat, sektor:sektor/**, proyekname:proyekname**/},
				success: function(msg){
					//alert(yearfrom);
					$('#table-search').html(msg);
				},
				error:function(){
					error('error request !');
				}
		});
	//});
	}

	function showCircle(){
		var show = $('#showhide').text();
		var arr = ["<", ">", "?", "[", "]", "{", "}", "&", "/", "'\'", "`", "^", "*", "#", "~", ";", ":", "|"];
      	
      	var xss = false;
       	for (var i=0; i < arr.length; i++) {
       		if (show.includes(arr[i])){
       			xss = true;
       			break;
       		}else {
       			xss = false;
       		}
       	}
       	if (xss){
			alert("Inputan tidak bisa mengandung karakter spesial ex: <, >, #...");
		}else{
			$.ajax({
				type: "POST",
				url : "<%=request.getContextPath()%>/circleSearch",
				data: {show:show,search:""},
					success: function(msg){
						$("#search-circle").html(msg);
						if(show == 'Lihat Semua'){ 
							//$("div#paging").removeClass("paging");
							$('button#showhide').text('Lihat per halaman');
						}else{
							//$('.paging').attr('id','paging');
							$('button#showhide').text('Lihat Semua');
						}
					},
					error:function(){
						error('error request !');
					}
			});
		}
		
	}
	
	var delay = (function(){
		  var timer = 0;
		  return function(callback, ms){
		    clearTimeout (timer);
		    timer = setTimeout(callback, ms);
		  };
		})();
	
	$('#searchInput').keyup(function(){
		delay(function(){
			var search = $('#searchInput').val();
			var fasilitas = $("#fasilitas").val();
				$.ajax({
					type: "POST",
					url : "<%=request.getContextPath()%>/circleSearch",
					data: {search:search,fasilitas:fasilitas},
						success: function(msg){
							$("#search-circle").html(msg);
							$('button#showhide').text('Lihat Semua');
						},
						error:function(){
							error('error request !');
						}
				});
		}, 500 );
	});
	
	function search_circle(search,fasilitas){
		$.ajax({
			type: "POST",
			url : "<%=request.getContextPath()%>/circleSearch",
			data: {search:search,fasilitas:fasilitas},
				success: function(msg){
					$("#search-circle").html(msg);
					$('button#showhide').text('Lihat Semua');
				},
				error:function(){
					error('error request !');
				}
		});
	}

	function search_dashboard(fasilitas){	
		var searchInput = $("#searchInput").val();
			search_circle(searchInput,fasilitas);
			$.ajax({
				type: "POST",
				url : "<%=request.getContextPath()%>/DashboardSearch",
				data: {fasilitas:fasilitas, searchInput:searchInput},
					success: function(msg){
						$("#searchInput").val(searchInput);
						$('#searchbro').html(msg);
						$('#table-dashbord').dataTable().fnFilter(searchInput);
					},
					error:function(){
						error('error request !');
					}
			});	
		
	}

	function search_dashboard2(fasilitas){	
		var search = $("#searchInput").val();
		$.ajax({
			type: "POST",
			url : "<%=request.getContextPath()%>/circleSearch",
			data: {search:search,fasilitas:fasilitas},
				success: function(msg){
					$("#search-circle").html(msg);
					$('button#showhide').text('Lihat Semua');
				},
				error:function(){
					error('error request !');
				}
		});	
		
	}
	
	</script>

</html>

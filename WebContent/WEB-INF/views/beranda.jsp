<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!-- <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%> -->
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<jsp:include page="/WEB-INF/views/assets/style.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/assets/script.jsp"></jsp:include>
<style>
.panel-heading {
       height:50px;
    }
    
.panel-default div.panel-heading:hover {
    background-color: #043377;
    color: white;
    cursor: pointer;
}
    
.panel-heading a:after {
    font-family:'Glyphicons Halflings';
    content:"\e114";
    float: left;
    color: black;
}

.panel-heading a.collapsed:after {
    content:"\e080";
}
</style>
<c:forEach items="${MenuUrl}" var="menu">
	<title>${menu.namaMenu}</title>
</c:forEach>
</head>
<body>	

<div id="container">
  <div id="top">
    <img style="height: 95%; margin-left:20px; margin-right:20px" src="<%=request.getContextPath()%>/assets/images/logo.png" class="pull-left img-responsive"/> 
    <span style="margin-left:90px;"></span><h3 style="color:white;"><b> Document Management Proyek System </b></h3></span>
  </div>
  
<nav class="navbar navbar-default" style="min-height:0px">

  		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
				<span class="sr-only">Toggle navigation</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
		</div>
  
  <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
  <div id="navigation">
    <div id="menu">
      <ul>
        <li> <a target="_blank" href="<%=request.getContextPath()%>/Login">Login</a> </li>
        <c:forEach items="${ListMenu}" var="listmenu" varStatus="loop">
        
        	<c:if test="${listmenu.jenis == 'menu_header'}">
	        	<li> <a href="<%=request.getContextPath()%>/${listmenu.url}">${listmenu.namaMenu}</a> </li>
	    	</c:if>
	    </c:forEach>
      </ul>
    </div>
  </div>
  
    </div>
</nav>
 
 <div class="row" style="padding-top:20px; margin:5px">
 <c:forEach items="${MenuUrl}" var="menu">
 	<c:choose>
 		<c:when test="${menu.namaMenu == 'Beranda'}">
 			<div class="col-sm-3">
			    <div class="clear text-center" style="padding: 10px; color: #fff"><i class="fa fa-search"></i>&nbsp; Cari Dokumen </div>
			    <div id="event" style="padding: 5px;">
					<div class="row">
					 	<div class="form-group form-group-sm col-sm-12">
						<label>Nama File</label>
							<input type="text" class="form-control" name="filename" id="filename" value="">
						</div>
						<div class="form-group form-group-sm col-sm-12">
						<label for="">Nama Proyek</label>
						<input type="text" class="form-control" name="proyekname" id="proyekname"  value="">
						</div>
						<div class="form-group form-group-sm col-sm-12">
						<label for="">Tanggal</label>
						<input type="text" class="form-control" name="tanggal" id="tanggal"  value="">
						</div>
						<div class="col-sm-12">
						<button type="submit" id="cari" class="btn btn-primary">Cari</button>
						</div>
					</div>
			    </div>
			    <div class="clear text-center" style="padding: 10px; color: #fff"><i class="fa fa-link"></i>&nbsp; Link Situs </div>
			    <div id="news">
					<div class="row">
						<div class="col-sm-12" style="padding: 20px;">
						<c:forEach items="${ListMenu}" var="listmenu" begin="0" end="${ListMenu.size()}" varStatus="loop">
				        	<c:if test="${listmenu.jenis == 'menu_linksitus'}">
					        	<a target="_blank" href="${listmenu.url}"><i class="fa fa-angle-double-right"></i> ${listmenu.namaMenu}</a><br>
					    	</c:if>
				    	</c:forEach>
				    	</div>
					</div>
			    </div>
			    
			    <div class="clear text-center" style="padding: 10px; color: #fff"><i class="fa fa-clipboard"></i>&nbsp; SOP dan Proses Bisnis </div>
			    <div id="designs">
			    <div class="row">
						<div class="col-sm-12" style="padding: 20px;">
							<c:forEach items="${ListMenu}" var="listmenu" varStatus="loop">
				        		<c:if test="${listmenu.jenis == 'menu_sop'}">
					        		 <a href="<%=request.getContextPath()%>/${listmenu.url}"><i class="fa fa-angle-double-right"></i> ${listmenu.namaMenu}</a> <br>
					    		</c:if>
					    	</c:forEach>
					    </div>
					</div>
				</div>
			  </div>
			  
			   <div class="col-sm-6">
			    <div id="content_top">
			    
				<div id="show">    
			    	<div class="text-center">
			    		<h2><i class="fa fa-tasks"></i><b>&nbsp; Daftar Proyek Terbaru</b></h2>
			    	</div>
			 		<table id="datatable-responsive" class="table dt-responsive nowrap">
						<thead>
							<tr><th></th></tr>
						</thead>
						<tbody>
						<!-- looping content -->
						<c:forEach items="${project}" var="proyek" varStatus="loop">
						    <tr><td>
							<%String title = "User Agent Example";%>
										<div class="x_content">
							<div class="row">
								<div class="col-md-12">
									<div class="x_panel proyek">
										<div class="x_title" id="idlist">
											<h2>
												<a href="#">
													${proyek.projectName}</a> - ${proyek.area}
											</h2>
										
									
											<div class="clearfix"></div>
										</div>
										<div class="x_content">
											<div class="kontent_proyek">Sektor : ${proyek.sector} <br><span> Mulai : ${proyek.valueTahunFrom} . &nbsp; Progress : ${proyek.progress} </span></div>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
			       	    					
			       						</div>   
						</div>
						</td></tr>
						</c:forEach>
						</tbody>
					</table>
				</div>
									
			    </div>
			  </div>
			  
			  <div class="col-sm-3">
			    <div class="clear text-center" style="padding: 10px; color: #fff"><i class="fa fa-bullhorn"></i>&nbsp; Data Infomation</div>
			    <div id="event">
			      <div class="row">
			            <c:forEach items="${count}" var="count">
			            
							<div class="col-sm-12" style="padding: 10px;">
								<div class="col-xs-2">
									<i class="fa fa-archive fa-3x"></i>
								</div>
								<div class="col-xs-10 text-center">
								    <p>Total Seluruh Proyek :<br><b>${count.totalproyek} proyek</b></p>
								</div>
							</div>
							<div class="col-sm-12" style="padding: 10px;">
								<div class="col-xs-2">
									<i class="fa fa-clipboard fa-3x"></i>
								</div>
								<div class="col-xs-10 text-center">
								    <p>Total Seluruh Dokumen :<br><b>${count.totaldokumen} dokumen</b></p>
								</div>
							</div>
							<div class="col-sm-12" style="padding: 10px;">
							    <div class="col-xs-2">
									<i class="fa fa-users fa-3x"></i>
								</div>
								<div class="col-xs-10 text-center">
								    <p>User Aktif :<br><b>${count.totaluser} user</b></p>
								</div>
							</div>
						</c:forEach>
					</div>
			    </div>
			  </div>
 		</c:when> 
 		<c:otherwise>
 			<c:out value="${menu.content}" escapeXml="false"/>
 		</c:otherwise>
 	</c:choose>
  </c:forEach>
 
 
 </div>
  
<jsp:include page="footer.jsp"></jsp:include>

</div>
		<script type="text/javascript">
			$('#datatable-responsive').dataTable( {
				 "searching": false,
				 "bLengthChange": false,
				 "pageLength": 5,
				 "order": [[ 0, "desc" ]]
			} );
			
			$(function(){
				$("#tanggal").datepicker({
					dateFormat : 'yy-mm-dd',
					changeMonth: true,
					changeYear: true,
					autoSize: true
				});
			});
			
			$('#cari').click(function(){
				var filename = $('#filename').val();
				var proyekname = $('#proyekname').val();
				var tanggal = $('#tanggal').val();
				
				$.ajax({
					type : 'post',
					url : 'Beranda/Search',
					data :{filename:filename, proyekname:proyekname, tanggal:tanggal},
					success:function(msg){
						//alert(tanggal);
						$('#show').html(msg);
					},
					error:function(msg){
						error('error request');
					}
				});
			});
			
			function get_page(id){
				alert(id);
			}
		</script>
	</body>
</html>
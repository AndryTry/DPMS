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
		<style id="antiClickjack">
	        body
	        {
	            display:none !important;
	        }
    	</style>
	
	</head>
	
	<body class="nav-md">
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
									<h2>Report</h2>
										<ul class="nav navbar-right panel_toolbox">
											<div class="nav navbar-right panel_toolbox">
												<a class="btn btn-primary" data-toggle="modal" href="<%=request.getContextPath()%>/Eksport/ViewPMEEksportPDF">
												Eksport PDF</a></a>						
											</div>	
											<div class="nav navbar-right panel_toolbox">
												<a class="btn btn-primary" data-toggle="modal" href="<%=request.getContextPath()%>/Eksport/ViewPMEEksport?exportToExcel=YES">
												Eksport Excel</a></a>						
											</div>
										</ul>
										
									<div class="clearfix"></div>
								</div>
								
								<dir>
									<table id="datatable-responsive" class="table table-striped table-bordered dt-responsive nowrap" cellspacing="0" width="100%">
										<thead>
											<tr>
												<th Style="text-align:center"><b>No</b></th>
												<th Style="text-align:center"><b>Nama Proyek</b></th>
												<th Style="text-align:center"><b>Nilai Investasi</b></th>
												<th Style="text-align:center"><b>PJPK</b></th>
												<th Style="text-align:center"><b>Tahapan KPBU</b></th>
												<th Style="text-align:center"><b>PDF</b></th>
												<th Style="text-align:center"><b>VGF</b></th>
												<th Style="text-align:center"><b>Penjaminan</b></th>
												<th Style="text-align:center"><b>AP</b></th>
											</tr>
										</thead>
										<tbody>
											
											<c:forEach begin="1" end="${msg.idPme.size()}" varStatus="loop">
												<tr>
													<td align="center">${loop.index}</td>
													<td align="left">${msg.namaPme.get(loop.index-1)}</td>
													<td align="left">${msg.investasiPme.get(loop.index-1)}</td>
													<td align="left">${msg.pjpkPme.get(loop.index-1)}</td>
													<td align="center">${msg.tahapanPme.get(loop.index-1)}</td>
													<td align="center">${msg.PDF.get(loop.index-1)}</td>
													<td align="center">${msg.VGF.get(loop.index-1)}</td>
													<td align="center">${msg.penjaminanBersama.get(loop.index-1)}</td>
													<td align="center">${msg.AP.get(loop.index-1)}</td>
												</tr>
											</c:forEach>
											
										</tbody>
									</table>
								</dir>
								
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
	
	
	
</html>
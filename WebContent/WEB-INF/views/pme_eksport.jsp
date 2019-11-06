 <%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix = "sql"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
 <%@taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
 <%@page import="java.io.*"%>
<%@page import="com.lowagie.text.*"%>
<%@page import="com.lowagie.text.pdf.*"%>
<%@ page trimDirectiveWhitespaces="true" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>

</head>
<body>
		
		<%
			String a = new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Timestamp(System.currentTimeMillis()));
		
		     String exportToExcel = request.getParameter("exportToExcel");
		     String exportToPDF = request.getParameter("exportToPDF");
		     if (exportToExcel != null && exportToExcel.toString().equalsIgnoreCase("YES")) {
			            response.setContentType("application/vnd.ms-excel");
						response.setHeader("Content-Disposition", "inline; filename="+a+"e.xls");	 
		     }
		    
		%>
		
		 <table align="left" border="1">
	    	  <thead>
	            <tr>
	            	<th>No</th>
	                <th>Nama Proyek</th>
	                <th>Nilai Investasi</th>
	                <th>PJPK</th>
	                <th>Tahapan KPBU</th>
	                <th>PDF</th>
					<th>VGF</th>
					<th>Penjaminan</th>
					<th>AP</th>
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
		
		 
</body>
</html>
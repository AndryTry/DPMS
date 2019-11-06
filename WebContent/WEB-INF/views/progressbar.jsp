<%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix = "sql"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Dashboard</title>
		<jsp:include page="/WEB-INF/views/assets/style.jsp"></jsp:include>
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/assets/select2/dist/css/select2.css" />		
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
	<div class ="MarkerPopUp" style="width: 300px;">
	    <c:forEach items="${progress}" var="progress" begin="0" end="${progress.size()}" varStatus="loop">
			<div class row>
				<label><c:out value="${progress.projectName}"></c:out></label>
				<button class="btn btn-xs btn-primary"><i class="fa fa-eye"></i> View</button>
				<div class="progress"><div class="progress-bar" style="width:${progress.progress}%">${progress.progress}%</div></div>
			</div>
		</c:forEach>
    </div>
     	<jsp:include page="/WEB-INF/views/assets/script.jsp"></jsp:include>
	</body>
</html>


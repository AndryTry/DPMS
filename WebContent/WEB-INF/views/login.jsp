<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!-- <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%> -->
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<jsp:include page="/WEB-INF/views/assets/style.jsp"></jsp:include>
<link rel="shortcut icon" href="<%=request.getContextPath()%>/assets/images/logo-login.png" type="image/x-icon">
<title>Login</title>
<style>
	form[role=login] {
	color: #5d5d5d;
	background: #f2f2f2;
	padding: 23px;
	width:500px;
	border-radius: 10px;
	-moz-border-radius: 10px;
	-webkit-border-radius: 10px;
}
	form[role=login] img {
		display: block;
		margin: 0 auto;
		margin-bottom: 35px;
	}
	form[role=login] input,
	form[role=login] button {
		font-size: 18px;
		margin: 16px 0;
	}
	form[role=login] > div {
		text-align: center;
	}
</style>

</head>
<body>	
		<%
			if(session.getAttribute("msg") != null){
				if(session.getAttribute("msg").equals("error")){
					session.removeAttribute("msg");
					out.println("<script type=\"text/javascript\">");
				    out.println("alert('Username or password is not match');");
				    out.println("</script>");					
				}else if(session.getAttribute("msg").equals("server")){
					session.removeAttribute("msg");
					out.println("<script type=\"text/javascript\">");
				    out.println("alert('Server down');");
				    out.println("</script>");					
				}
			}
		
			if(session.getAttribute("username") != null){
				response.sendRedirect("Dashboard");
			}
		%>
		<div class="login_wrapper">
			<div class="animate form login_form">
		    	<section class="login_content">
		        	<form method="post" action="Home" role="login">
		              <img style="height:100px; width:110px; margin-left:10px; margin-right:10px" src="<%=request.getContextPath()%>/assets/images/logo-login.png" class="pull-left img-responsive"/>
		              <p style="font-size:20px; font-color:#3A5672; padding:20px; line-height:30px;"><b>Document Management System and Project Monitoring and Evaluation</b>
		              </p>
		              <div class="form-group">
		                <input type="email" class="form-control" name="username" placeholder="Email" required/>
		              </div>
		              <div class="form-group">
		                <input type="password" class="form-control" name="password" placeholder="Password" required/>
		              </div>
		              <div>
		                <button type="submit" class="btn btn-primary submit"><i class="fa fa-sign-in"></i> Login</button>
		              </div>
		
		              <div class="clearfix"></div>
		              <div class="separator">
		              	<div class="clearfix"></div><br/>
		                <div>
		                  <p>©2018 All Rights Reserved. </p>
		                </div>
					   </div>
		        	</form>
		    	</section>
			</div>
		</div>
	</body>
</html>
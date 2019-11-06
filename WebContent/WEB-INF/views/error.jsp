<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Spring Login Form</title>
</head>
<body>

    <% 
    	if(session.getAttribute("msg").equals("error")){
    		   out.println("<script type=\"text/javascript\">");
    		   out.println("alert('User or password incorrect');");
    		   out.println("</script>");    		
    	}
    	response.sendRedirect("index.jsp");
    %>
    
</body>
</html>
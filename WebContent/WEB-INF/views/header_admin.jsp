<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<div class="top_nav">
	<div class="nav_menu">
		<nav>
			<div class="nav toggle">
         		<a id="menu_toggle"><i class="fa fa-bars"></i></a>
       		</div>

       		<ul class="nav navbar-nav navbar-right">
         		<li class="">
           			<a href="javascript:;" class="user-profile dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
             			<img src="images/img.jpg" alt=""><i class="fa fa-smile-o"></i> ${username}
             			<span class=" fa fa-angle-down"></span>
           			</a>
           			<ul class="dropdown-menu dropdown-usermenu pull-right">
             		<!--	<li><a href="#"><i class="fa fa-user pull-right"></i> Profile</a></li> -->
             			<li><a href="<%=request.getContextPath()%>/Logout"><i class="fa fa-sign-out pull-right"></i> Log Out</a></li>
           			</ul>
         		</li>
       		</ul>
     	</nav>
   	</div>
</div>


<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<!-- sidebar menu -->
<div class="col-md-3 left_col">
	<div class="left_col scroll-view">
    	<div class="navbar nav_title" style="border: 0; padding-top:10px">
      		<a href="<%=request.getContextPath()%>/Home" class="site_title"><img style="height: 90%; margin: auto; display: inline" src="<%=request.getContextPath()%>/assets/images/logo.png" /> </a>
    	</div>
    	<div class="clearfix"></div>
    	<br />
    	<div id="sidebar-menu" class="main_menu_side hidden-print main_menu">
      		
      		<div class="menu_section">
      		<div id="menu-dms">
        		<ul class="nav side-menu">
          			<li><a href="<%=request.getContextPath()%>/Dashboard"><i class="fa fa-home"></i> Dashboard </a></li>
          			<li><a><i class="fa fa-briefcase"></i> Proyek <span class="fa fa-chevron-down"></span></a>
            			<ul class="nav child_menu">
              				<li><a href="<%=request.getContextPath()%>/DMS">DMS</a></li>
			            </ul>
			        </li>
			        <c:if test="${level > 2}">
				       	<li><a href="<%=request.getContextPath()%>/Sektor"><i class="fa fa-flag"></i> Manage Sektor </a></li>
	              		<li><a href="<%=request.getContextPath()%>/Jenis_dokumen"><i class="fa fa-paste"></i> Manage Jenis Dokumen </a></li>
			          	<li><a href="<%=request.getContextPath()%>/User"><i class="fa fa-users"></i> Manage User </a></li>
		          	</c:if>
        		</ul>
      		</div>
      		<div id="menu-pme" style="display:none">
        		<ul class="nav side-menu">
          			<li><a href="<%=request.getContextPath()%>/Dashboard"><i class="fa fa-home"></i> Dashboard </a></li>
          			<li><a><i class="fa fa-briefcase"></i> Proyek <span class="fa fa-chevron-down"></span></a>
            			<ul class="nav child_menu">
              				<li><a href="<%=request.getContextPath()%>/PME">PME</a></li>
			            </ul>
			        </li>
			       
                  		<li><a href="<%=request.getContextPath()%>/Eksport"><i class="fa fa-table"></i> Report </a></li>
                		<c:if test="${level > 2}">
			          		<li><a href="<%=request.getContextPath()%>/User_p"><i class="fa fa-users"></i> Manage User </a></li>
		          		</c:if>
        		</ul>
      		</div>
      		</div>
    	</div>
  	</div>
</div>
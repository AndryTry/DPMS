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
		<title>Insert title here</title>
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
	<body>
	<div id="searchbro">
		<table id="table-dashbord" class="table table-hover table-striped">
				<thead>
					<tr>
						<th width="23%">Nama Proyek </th>
			            <th width="17%">Wilayah</th>
			            <th width="13%">PJPK</th>
			            <th width="16%">Nilai Proyek</th>
			            <th width="15%">Tahapan Dilalui</th>
			            <th width="16%">Fasilitas</th>
						
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
		
		
		
		$('#paging').easyPaginate({
		    paginateElement: 'grid',
		    elementsPerPage: 20,
		    numeric: true,
		    firstButton : false,
		    lastButton : false,
		    prevButtonText : 'Previous',
		    nextButtonText : 'Next' 
		});
		
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
	        }else{
	        	$("#menu-dms").show();
	        	$("#menu-pme").hide();
	        }
	       // console.log(lastURLSegment);
	    });
	    
	});
	

	function search_dashboard(fasilitas){	
		var searchInput = $("#searchInput").val();
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
	
	</script>
</html>

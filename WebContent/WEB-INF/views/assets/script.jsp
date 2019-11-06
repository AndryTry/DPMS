<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- jQuery -->
<script src="<%=request.getContextPath()%>/assets/jquery/dist/jquery.min.js"></script>
<!-- Bootstrap -->
<script src="<%=request.getContextPath()%>/assets/bootstrap/dist/js/bootstrap.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<!-- Datatables -->
<script src="<%=request.getContextPath()%>/assets/datatables/datatables.net/js/jquery.dataTables.min.js"></script>
<script src="<%=request.getContextPath()%>/assets/datatables/datatables.net-bs/js/dataTables.bootstrap.min.js"></script>
<script src="<%=request.getContextPath()%>/assets/datatables/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
<script src="<%=request.getContextPath()%>/assets/datatables/datatables.net-buttons-bs/js/buttons.bootstrap.min.js"></script>
<script src="<%=request.getContextPath()%>/assets/datatables/datatables.net-buttons/js/buttons.flash.min.js"></script>
<script src="<%=request.getContextPath()%>/assets/datatables/datatables.net-buttons/js/buttons.html5.min.js"></script>
<script src="<%=request.getContextPath()%>/assets/datatables/datatables.net-buttons/js/buttons.print.min.js"></script>
<script src="<%=request.getContextPath()%>/assets/datatables/datatables.net-fixedheader/js/dataTables.fixedHeader.min.js"></script>
<script src="<%=request.getContextPath()%>/assets/datatables/datatables.net-keytable/js/dataTables.keyTable.min.js"></script>
<script src="<%=request.getContextPath()%>/assets/datatables/datatables.net-responsive/js/dataTables.responsive.min.js"></script>
<script src="<%=request.getContextPath()%>/assets/datatables/datatables.net-responsive-bs/js/responsive.bootstrap.js"></script>
<script src="<%=request.getContextPath()%>/assets/datatables/datatables.net-scroller/js/dataTables.scroller.min.js"></script>
<!-- Custom Theme Scripts -->
<script src="<%=request.getContextPath()%>/assets/build/js/custom.min.js"></script>
<script src="<%=request.getContextPath()%>/assets/tinymce/tinymce.min.js"></script>

<script type="text/javascript">
	var pageURL = window.location.pathname;
   	stringUrl = String(pageURL);
   	var previous = document.referrer;
   	var ref = previous.substr(previous.lastIndexOf('/') + 1);
   	var lastURLSegment = stringUrl.substr(stringUrl.lastIndexOf('/') + 1);
   	arr = ["PME", "Eksport", "ViewProjectPME", "ViewJenisTahapan", "KegiatanTahapan", "ViewProjectPME_dashboard", "User_p"];
   	
   	var pme = false;
   	for (var i=0; i < arr.length; i++) {
   		if (previous.includes(arr[i])){
   			pme = true;
   			break;
   		}else {
   			pme = false;
   		}
   	}
   	if ((arr.indexOf(lastURLSegment) > -1) || (arr.indexOf(ref) > -1) || pme){
    	$("#menu-dms").hide();
    	$("#menu-pme").show();
    	$('#pme').addClass('in active');
		$('#dms').removeClass('in active');
		$('#switchdms').removeClass('active');
    	$('#switchpme').addClass('active');
    }else{
    	$("#menu-dms").show();
    	$("#menu-pme").hide();
    	$('#dms').addClass('in active');
		$('#pme').removeClass('in active');
		$('#switchpme').removeClass('active');
    	$('#switchdms').addClass('active');
    }
   	
   	
</script>



<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<c:set var="currentPage" value="${header.referer}"/>
<c:set var="splitURI" value="${fn:split(currentPage, '/')}"/> 
<c:set var="lastValue" value="${splitURI[fn:length(splitURI)-1]}"/>
<c:if test="${(lastValue == 'Home') || (lastValue == 'Dashboard')}">


			<div class="col-lg-2">
			  <div id="checked"></div>
			</div>
			<div class="col-lg-10">
				<table id="datatable-respon" class="table table-hover table-striped">
					<thead>
						<tr class="nowrap">
							<th style="width:100px">Nama File</th>
							<th style="width:150px" nowrap>Jenis Dokumen</th>
							<th style="width:210px">Perihal</th>
							<th style="width:100px">No Surat</th>
							<th style="width:80px">Tanggal</th>
							<th style="width:80px">Pengunggah</th>
							<th>Show</th>
							<th style="visibility: hidden; width:1px;">Nama Proyek</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${searchFileList}" var="search">
						<c:set var="file" value="${search.fileName}"/>
						<c:set var="type" value="${fn:substringAfter(file, '.')}"></c:set>
						
						<tr>
							<td style="width:100px"><c:out value="${search.fileName}"/></td>
							<td style="width:150px"><c:out value="${search.jenisDok}"/></td>
							<td style="width:210px"><c:out value="${search.perihal}"/></td>
							<td style="width:100px"><c:out value="${search.noSurat}"/></td>
							<td style="width:80px"><c:out value="${search.projectDate}"/></td>
							<td style="width:80px"><c:out value="${search.uploadBy}"/></td>
							<c:choose>
							<c:when test="${(type == 'txt')}">
								<td><a href="<%=request.getContextPath()%>${search.filePath}" target="_blank"><img style="width:33px; height:33px;"  src="<%=request.getContextPath()%>/assets/images/txt.png"/></a></td>
							</c:when>
							<c:when test="${(type == 'pdf')}">
								<td><a href="<%=request.getContextPath()%>${search.filePath}" target="_blank"><img style="width:33px; height:33px;" src="<%=request.getContextPath()%>/assets/images/pdf.png"/></a></td>
							</c:when>
							<c:when test="${(type == 'zip')}">
								<td><a href="<%=request.getContextPath()%>${search.filePath}" target="_blank"><img style="width:33px; height:33px;" src="<%=request.getContextPath()%>/assets/images/zip.png"/></a></td>
							</c:when>
							<c:when test="${(type == 'rar') || (type == 'tar')}">
								<td><a href="<%=request.getContextPath()%>${search.filePath}" target="_blank"><img style="width:33px; height:33px;" src="<%=request.getContextPath()%>/assets/images/rar.png"/></a></td>
							</c:when>
							<c:when test="${(type == 'doc') || (type == 'docx') }">
								<td><a href="<%=request.getContextPath()%>${search.filePath}" target="_blank"><img style="width:33px; height:33px;" src="<%=request.getContextPath()%>/assets/images/word.png"/></a></td>
							</c:when>
							<c:when test="${(type == 'xls') || (type == 'xlsx') }">
								<td><a href="<%=request.getContextPath()%>${search.filePath}" target="_blank"><img style="width:33px; height:33px;" src="<%=request.getContextPath()%>/assets/images/excel.png"/></a></td>
							</c:when>
							<c:when test="${(type == 'ppt') || (type == 'pptx') }">
								<td><a href="<%=request.getContextPath()%>${search.filePath}" target="_blank"><img style="width:33px; height:33px;" src="<%=request.getContextPath()%>/assets/images/ppt.png"/></a></td>
							</c:when>
							<c:when test="${(type == 'jpg') || (type == 'jpeg') || (type == 'png') || (type == 'gif') }">
								<td><a href="<%=request.getContextPath()%>${search.filePath}" target="_blank"><img style="width:33px; height:33px;" src="<%=request.getContextPath()%>/assets/images/image.png""/></a></td>
							</c:when>
							<c:when test="${(type == 'zip')}">
								<td><a href="<%=request.getContextPath()%>${search.filePath}" target="_blank"><img style="width:33px; height:33px;" src="<%=request.getContextPath()%>/assets/images/zip.png"/></a></td>
							</c:when>
							<c:otherwise>
								<td><a  href="<%=request.getContextPath()%>${search.filePath}" target="_blank"><img style="width:40px; height:40px;" src="<%=request.getContextPath()%>/assets/images/blank.png"/></a></td>
							</c:otherwise>
							</c:choose>
							<td style="visibility: hidden; width:1px;"><c:out value="${search.proyekName}"/></td>
						</tr>
						</c:forEach>
					</tbody>
				</table> 
			</div>

</c:if>

<c:if test="${lastValue == 'Beranda'}">
	<div class="text-center">
    		<h2><i class="fa fa-tasks"></i><b> Hasil Pencarian File</b></h2>
    	</div>
 		<table id="datatable-res" class="table dt-responsive nowrap">
			<thead>
				<tr><th></th></tr>
			</thead>
			<tbody>
			<!-- looping content -->
			<c:forEach items="${searchFileList}" var="search" varStatus="loop">
			    <tr><td>
				<%String title = "User Agent Example";%>
							<div class="x_content">
				<div class="row">
					<div class="col-md-12">
						<div class="x_panel proyek">
							<div class="x_title" id="idlist">
								<h2>
									<a href="<%=request.getContextPath()%>${search.filePath}" target="_blank">
										${search.fileName}</a> - ${search.folderPath} -  ${search.projectDate}
								</h2>
							
						
								<div class="clearfix"></div>
							</div>
							<div class="x_content">
								<div class="kontent_proyek">Nama Proyek ${search.proyekName} <span> </span><br>
								
								</div>
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
</c:if>

<script type="text/javascript">
	

$('#datatable-res').dataTable( {
	"bLengthChange": false, 
	"searching": false,
	"pageLength": 5,
	 "order": [[ 0, "desc" ]]
} );
	
	var oTable = $('#datatable-respon').dataTable( {
		sDom: 'T<"row view-filter"<"col-sm-12"<"pull-right"l>>>t<"row view-pager"<"col-sm-12"<"pull-right"p><"pull-left"i>>>',
		 AutoWidth: false,
		 //scrollY:        "300px",
	        scrollX:        true,
	        scrollCollapse: true		 
	} );
	
	
	var $rows = oTable.fnGetNodes();
    var values = {};
    var colnums = [8];

    for (var col = 0, n = colnums.length; col < n; col++) {

        var colnum = colnums[col];
        if (typeof values[colnum] === "undefined") values[colnum] = {};

        // Create Unique List of Values
        $('td:nth-child(' + colnum + ')', $rows).each(function () {
            values[colnum][$(this).text()] = 1;
        });

        // Create Checkboxes
        var labels = [];
        $.each(values[colnum], function (key, count) {
            var $checkbox = $('<input />', {
                'class': 'filter-column filter-column-' + colnum,
                    'type': 'checkbox',
                    'value': key
            });
            var $label = $('<table><td><h5></h5></td></table>', {
                'class': 'filter-container'
            }).append($checkbox).append(' ' + key);
            $checkbox.on('click', function () {
                oTable.fnDraw();
            }).data('colnum', colnum);
            labels.push($label.get(0));
        });
        var $sorted_containers = $(labels).sort(function (a, b) {
            return $(a).text().toLowerCase() > $(b).text().toLowerCase();
        });
        $('#checked').prepend($sorted_containers);
        $sorted_containers.wrapAll($('<div></div>', {
            'class': 'checkbox-group checkbox-group-column-' + colnum
        }));
    }

    $.fn.dataTableExt.afnFiltering.push(function (oSettings, aData, iDataIndex) {
        var checked = [];
        $('.filter-column').each(function () {
            var $this = $(this);
            if ($this.is(':checked')) checked.push($this);
        });

        if (checked.length) {
            var returnValue = false;
            $.each(checked, function (i, $obj) {
                if (aData[$obj.data('colnum') - 1] == $obj.val()) {
                    returnValue = true;
                    return false; // exit loop early
                }
            });

            return returnValue;
        }

        if (!checked.length) return true;
        return false;
    	});
	
</script>
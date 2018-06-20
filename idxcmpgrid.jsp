<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="irp" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<irp:header hasTopbar="false" noPadding="true">
<link href="${pageContext.request.contextPath}/styles/idxcmp.css" rel="stylesheet" type="text/css"/>
<style>
.lcrow:hover{
	cursor:pointer;
}
#diff-arrow:hover{
	cursor:pointer;
}
#diffpop{
	position:absolute;
	top:28px;
	right:19px;
	width:80px;
	z-index:5;
	display:none;
	background-color:#ffffff;
	border:1px solid #cccccc;
	border-radius:4px;
	overflow-y:auto;
	-webkit-box-shadow:#dddddd 0px 0px 3px;
	-moz-box-shadow:#dddddd 0px 0px 3px;
	box-shadow:#dddddd 0px 0px 3px;
}
.diffpop-li{
	width:100%;
	height:26px;
	line-height:26px;
	font-size:14px;
	padding-left:10px;
	border-radius:4px;
}
.diffpop-li:hover{
	background-color:#efefef;
	cursor:pointer;
}
</style>
</irp:header>

<div style="background-color:#ffffff;">
<div class="cmpgriddiv-header" style="background-color:#ffffff">
	<label class="lbl3" id="conditionlbl">${datech}&nbsp|&nbsp${ccych}&nbsp|&nbsp${cntflgch}&nbsp|&nbsp${mrtch}&nbsp|&nbsp${org1ch}&nbsp|&nbsp${org2ch}&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp${untnam}</label>
</div>
<div class="cmpgriddiv-griddiv" style="position:relative;height:383px;background-color:#ffffff">
	<div id="hdiv" style="position:absolute;top:0px;left:0px;height:30px;width:100%;overflow-x:hidden;overflow-y:hidden">
		<div id="lhdiv" class="leftdiv" align="left" style="position:absolute;left:0px;top:0px;float:left;width:240px;padding:8px 0px 0px 20px;z-index:2;background-color:#ffffff"></div>
		<div id="rhdiv" class="rightdiv" style="position:absolute;left:240px;top:0px;padding:8px 0px 0px 0px;z-index:1"></div>
	</div>
	<div id="cdiv" style="position:absolute;top:30px;left:0px;width:100%;height:353px;overflow-x:auto;overflow-y:auto">
		<div id="lcdiv" class="leftdiv" align="left" style="position:absolute;left:0px;width:240px;background-color:#ffffff;z-index:2"></div>
		<div id="rcdiv" class="rightdiv" style="position:absolute;left:240px;top:0px;z-index:1"></div>
	</div>
	<div id="diffpop">
	</div>
</div>
</div>

<irp:footer>
<script src="${pageContext.request.contextPath}/Common/extra/bootstrap-table.js"></script>
</irp:footer>
<script>
var date = '${date}';
var ccy = '${ccy}';
var cntflg = '${cntflg}';
var mrt = '${mrt}';
var org1 = '${org1}';
var org2 = '${org2}';
var blncod = '${blncod}';
var cmpcod = '${cmpcod}';
var unt = '${unt}';
var org1ch = '${org1ch}';
var org2ch = '${org2ch}';
var idxnam = '${idxnamlist}';

var idxnamarr = idxnam.substring(1,idxnam.length-1).split(',');
var org1arr = org1.split(',');
if($.inArray(org2,org1arr) != -1){
	org1arr.splice($.inArray(org2,org1arr),1);
}
var org1charr = org1ch.split(',');

loadgrid();

function loading(){
	$('<div class="loadingdiv" style="position:absolute;top:0px;left:0px;width:100%;height:100%;background-color:#ffffff;z-index:3"><img src="images/loading.gif" style="width:100px;display:block;margin:100px auto" /></div>').appendTo('.cmpgriddiv-griddiv');
}

function loadend(){
	$('.loadingdiv').remove();
}

function loadgrid(){
	$('#lhdiv').append('<label class="lbl4">指标</label>');
	var lwidth = (org1arr.length+2)*140+20;
	var dpheight = (org1arr.length)*26+2;
	if(dpheight > 140){
		dpheight = 140;
	}
	var cheight = (idxnamarr.length)*28;
	$('#rhdiv').css('width',lwidth+'px');
	$('#rcdiv').css('width',lwidth+'px');
	$('#lcdiv').css('height',cheight+'px');
	$('#rcdiv').css('height',cheight+'px');
	$('#diffpop').css('height',dpheight+'px');
	$.each(org1charr,function(index,value){
		$('#rhdiv').append('<div align="right" style="float:left;width:140px"><label class="lbl4" style="float:right">'+value+'</label></div>');
		$('#diffpop').append('<div class="diffpop-li" data-value="'+org1arr[index]+'" >'+value+'</label></div>');
	})
	$('#rhdiv').append('<div align="right" style="float:left;width:140px"><label class="lbl4" style="float:right">'+org2ch+'</label></div>');
	$('#rhdiv').append('<div align="right" id="rhdiff" style="float:left;width:160px;padding-right:15px"><img id="diff-arrow" src="images/arrow-down-b.png" style="float:right;height:14px;width:14px;margin-top:4px" /><label class="lbl4" style="float:right;margin-right:2px">差值</label></div>');
	$.each(idxnamarr,function(index,value){
		var html = '<div class="lcrow" style="width:240px;height:28px"><div style="width:5px;height:28px;float:left"></div>'+
							'<div align=left style="width:235px;height:28px;line-height:28px;float:left;color:#32d2c9;padding-left:10px">'+value+'</div></div>';
		$('#lcdiv').append(html);
	})
	$.ajax({
		url:'getidxcmpdataforgrid',
		data:{blncod:blncod,cmpcod:cmpcod,date:date,cntflg:cntflg,ccy:ccy,mrt:mrt,org1:org1,org2:org2,unt:unt},
		type:'post',
		success:function(data){
			$.each(data,function(index,obj){
				var html = '<div class="lcrow" style="width:'+lwidth+'px;height:28px;line-height:28px">';
				$.each(org1arr,function(ind,orgcod){
					var key = orgcod+'fin';
					if(typeof(obj[key]) == 'undefined' || obj[key] == '' || obj[key] == null || obj[key] == 'null'){
						html += '<div align="right" id="'+obj.idxcod+'-'+key+'" style="width:140px;float:left;height:28px;line-height:28px;font-size:12px">-</div>';
					}else{
						html += '<div align="right" id="'+obj.idxcod+'-'+key+'" style="width:140px;float:left;height:28px;line-height:28px;font-size:12px">'+obj[key]+'</div>';
					}
				})
				var key = 'baseorgfin';
				if(typeof(obj[key]) == 'undefined' || obj[key] == '' || obj[key] == null || obj[key] == 'null'){
					html += '<div align="right" id="'+obj.idxcod+'-'+key+'" style="width:140px;float:left;height:28px;line-height:28px;font-size:12px">-</div>';
				}else{
					html += '<div align="right" id="'+obj.idxcod+'-'+key+'" style="width:140px;float:left;height:28px;line-height:28px;font-size:12px">'+obj[key]+'</div>';
				}
				var key = 'difffin';
				if(typeof(obj[key]) == 'undefined' || obj[key] == '' || obj[key] == null || obj[key] == 'null'){
					html += '<div align="right" id="'+obj.idxcod+'-'+key+'" style="width:160px;float:left;height:28px;line-height:28px;font-size:12px;padding-right:20px">-</div>';
				}else{
					html += '<div align="right" id="'+obj.idxcod+'-'+key+'" style="width:160px;float:left;height:28px;line-height:28px;font-size:12px;padding-right:20px">'+obj[key]+'</div>';
				}
				html += '</div>';
				$('#rcdiv').append(html);
			})
			parent.loadend();
		}
	})
}

$(document).on('click','.lcrow',function(){
	$('.cell-state-select').removeClass('cell-state-select');
	$('.cell-state-select-first').removeClass('cell-state-select-first');
	var ind;
	if($(this).parent().attr('id') == 'lcdiv'){
		ind = $('#lcdiv .lcrow').index(this);
	}else if($(this).parent().attr('id') == 'rcdiv'){
		ind = $('#rcdiv .lcrow').index(this);
	}
	$('#lcdiv .lcrow').eq(ind).find('div').eq(0).addClass('cell-state-select-first');
	$('#lcdiv .lcrow').eq(ind).find('div').eq(1).addClass('cell-state-select');
	$('#rcdiv .lcrow').eq(ind).find('div').addClass('cell-state-select');
})

$(document).on('mouseover mouseout','.lcrow',function(e){
	var ind;
	if($(this).parent().attr('id') == 'lcdiv'){
		ind = $('#lcdiv .lcrow').index(this);
	}else if($(this).parent().attr('id') == 'rcdiv'){
		ind = $('#rcdiv .lcrow').index(this);
	}
	if(e.type=='mouseover'){
		$('#lcdiv .lcrow').eq(ind).css('background-color','#efefef');
		$('#rcdiv .lcrow').eq(ind).css('background-color','#efefef');
	}else if(e.type=='mouseout'){
		$('#lcdiv .lcrow').eq(ind).css('background-color','#ffffff');
		$('#rcdiv .lcrow').eq(ind).css('background-color','#ffffff');
	}
})

$(document).on('click','#diff-arrow',function(){
	$('#diffpop').slideToggle(200);
})

$(document).click(function(e){
	var target = e.target,
		diffpopel = $('#diffpop')[0],
		diffarrowel = $('#diff-arrow')[0];
	if(diffpopel !== target && diffarrowel !== target){
		$('#diffpop').slideUp(200);
	}
})

$('#cdiv').scroll(function(){
	var top = $('#cdiv').scrollTop();
	var left = $('#cdiv').scrollLeft();
	var cwidth = $('#cdiv').width();
	var rhwidth = $('#rhdiv').width();
	var rhleft = 240-left;
	$('#lcdiv').css('left',left);
	$('#rhdiv').css('left',rhleft+'px');
})


$('#idxcmpgrid').on('click-row.bs.table',function(e,row,element){
	$('.row-state-select').removeClass('row-state-select');
	$(element).addClass('row-state-select');
	$('.cell-state-select').addClass('cell-state-normal');
	$('.cell-state-select').removeClass('cell-state-select');
	$('.cell-state-select-first').addClass('cell-state-normal');
	$('.cell-state-select-first').removeClass('cell-state-select');
	$(element).find('td').removeClass('cell-state-normal');
	$(element).find('td').addClass('cell-state-select');
	$(element).find('td').first().addClass('cell-state-select-first');
	$(element).find('td').first().removeClass('cell-state-select');
})

$('#conditionimg').on('click',function(){
	parent.initCmpOrgList();
})

$('#conditionlbl').on('click',function(){
	var orgArr = org1.split(',');
	parent.initCmpOrgList(date,ccy,cntflg,mrt,orgArr,org2,unt);
})

$('.lbl5').on('click',function(){
	$('.lbl6').attr('class','lbl5');
	$(this).attr('class','lbl6');
	var tablesrc = "getidxcmpdataforgrid?blncod="+blncod+"&cmpcod="+cmpcod+"&date="+date+"&cntflg="+cntflg+"&ccy="+ccy+"&mrt="+this.id+"&org1="+org1+"&org2="+org2;
	$('#idxcmpgrid').bootstrapTable('refresh',{url:tablesrc,silent:true});
	var chartsrc = "idxcmpchart?blncod="+blncod+"&cmpcod="+cmpcod+"&date="+date+"&cntflg="+cntflg+"&ccy="+ccy+"&mrt="+this.id+"&org1="+org1+"&org2="+org2;
	$('#cmpchartif',window.parent.document).attr('src',chartsrc);
})

function freezing(){
	$('tr>:first-child').css("left",$('#freezing').scrollLeft()-1);
	var scrollLeft = $('#freezing').scrollLeft();
	
}
</script>
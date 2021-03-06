<%@page import="kr.pren.vo.ItemImage"%>
<%@page import="kr.pren.dao.ItemImageDao"%>
<%@page import="kr.pren.vo.SubCategory"%>
<%@page import="kr.pren.dao.SubCategoryDao"%>
<%@page import="kr.pren.vo.MainCategory"%>
<%@page import="java.util.List"%>
<%@page import="kr.pren.dao.MainCategoryDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <title>프랜</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
  <style type="text/css">
	th, td{text-align: center;}
  	td{overflow:hidden;text-overflow;ellipsis;}
  </style>
</head>
<body onload="changeSubcategory()">
<%@ include file="../../common/nav2.jsp" %>
<%

	MainCategoryDao mainCategoryDao = MainCategoryDao.getInstance();
	List<MainCategory> mainCategorys = mainCategoryDao.getMainCategory();
	
	
	SubCategoryDao subCategoryDao = SubCategoryDao.getInstance();
	List<SubCategory> subCategorys = subCategoryDao.getAllSubCategories();
		
%>
<div class="container">
<%
		String fails = request.getParameter("result");
		if("deny".equals(fails)){
	%>
		<div class="row">
			<div class="col-sm-12">
				<div class="alert alert-danger">
					<strong>로그인</strong>안되어있습니다.
				</div>
			</div>
		</div>
	<% 
		}
	%>
	<div class="row" style="margin-bottom: 50px;">
		<div class="col-sm-2">
			<div class="panel panel-default">
				<div class="panel-body"><span style="font-size: 23px;">상품관리</span></div>
				<div class="panel-body"><a href="sell_management.jsp">상품관리</a></div>
				<div class="panel-body"><a href="add_item_form.jsp">상품등록</a></div>
				<div class="panel-body"><a href="buy_request_list.jsp">판매현황</a></div>
			</div>
		</div>
		<div class="col-sm-10">
	<%
		String fail = request.getParameter("fail");
		if("error".equals(fail)){
	%>
		<div class="row">
			<div class="col-sm-12">
				<div class="alert alert-success">
					<strong>(오류)</strong>입력 값을 넣어주세요.
				</div>
			</div>
		</div>
	<% 
		}
	%>
			<h3>상품등록</h3>
			<form id="add-item" class="form-inline" action="add_item.jsp" method="post" enctype="multipart/form-data">
			    <div class="form-group">
					<label style="width: 120px;">1차분류</label>
			      	<select class="form-control" name="maincategory" id="main-category" onchange="changeSubcategory()" >
			        <%
	        			for(MainCategory mainC : mainCategorys){
			        %>
			        	<option value="<%=mainC.getNo() %>"><%=mainC.getName() %></option>
					<% 
			        	}
					%>
			      	</select>
	    		</div>
	    		<div class="form-group">
	    			<label>2차분류</label>
	     			<select class="form-control" name="subcategory" id="sub-category" >
	     				<option>-- 선택하세요 --</option>
			        <%
			        	for(SubCategory subC : subCategorys){
			        %>
			       		<option value="<%=subC.getNo()%>" id="subOptions-<%=subC.getMainCateNo()%>" ><%=subC.getName() %></option>
			        <%
			        		}
			        %>
	     			</select>
	    		</div>
			    <div class="form-group">
			    	<label class="radio-inline">
						<input type="radio"  name="usertype" id="user-type-y" value="y" checked="checked" />개인
					</label>
					<label class="radio-inline">
						<input type="radio"  name="usertype" id="user-type-n" value="n" checked="checked" />기업
					</label>
			    </div>
			    <div class="form-group-block" style="margin-top: 10px;">
			    	<label style="width: 120px;">상품명</label>
			    	<input type="text" class="form-control" name="productname" id="product-name" style="width: 500px;" >
			    </div>
			    <div class="form-group-block" style="margin-top: 10px;">
			    	<label style="width: 120px;">메인이미지</label>
			    	<input type="file" class="form-control" name="mainproductimg" id="main-productimg" style="width: 500px;" value="../../resources/images/item_logo/qw2.JPG"/>
			    	<!-- <img src="../../resources/images/item_logo/qw2.JPG" alt="" />-->
			    </div>
			    <div class="form-group-block" style="margin-top: 10px;" id="apppend-box">
			    	<label style="width: 120px;" >상세이미지 <button type="button" id="add-image-box" class="btn btn-primary btn-xs pull-right" onclick="addImageFile()"><span class="glyphicon glyphicon-plus"></span></button></label>
			    	<input type="file" class="form-control" name="subproductimg1" id="sub-productimg" style="width: 500px;" />
			    </div>	
			    <div class="form-group-block" id="image-box" style="margin-top: 10px;"></div>
		    	<!--  
		    	<div class="form-group-block" style="margin-top: 10px;">
			    	<label style="width: 120px;">상품명</label>
			    	<input type="text" class="form-control" name="productname" id="product-name" style="width: 500px;" >
			    </div>
			    -->
			    <div class="form-group-block" style="margin-top: 10px;">
			    	<label style="width: 120px;">기본옵션</label>
			    	<input type="text" class="form-control" name="basicsoption" id="basic-option" style="width: 250px;" value="기본 옵션"/>
			    	<label style="width: 100px; text-align: right;">기본가격 </label>
			    	<input type="text" class="form-control" style="width: 140px;" name="basicproductprice" id="basic-product-price"/>
			    </div>
			    <div class="form-group" style="margin-top: 10px;">
			    	<label style="width: 120px; ">추가옵션 <button type="button" id="add-image-box" class="btn btn-primary btn-xs pull-right" onclick="addOption()"><span class="glyphicon glyphicon-plus"></span></button></label>
			    	<input type="text" class="form-control" name="addoption" id="add-option" style="width: 250px; "/>
			    	<label style="width: 100px; text-align: right;">가격 </label>
			    	<input type="text" class="form-control" style="width: 140px;" name="addoptionprice" id="product-price"/>
			    </div>
				<div class="form-group" style="margin-top: 10px;" id="option-box"></div>
				<div class="form-group" style="padding-left: 0px;">
					<div class="form-group" id="newsbox-1">
						<h4><label style="display: block;">상품 상세설명</label></h4>
				  		<textarea class="form-control" name="productdescription" id="product-description" rows="6" placeholder="상품 상세설명 입력해 주세요" style="width: 900px;"></textarea>
					</div>
				</div>
				<div class="form-group" style="padding-left: 0px;">
					<div class="form-group" id="newsbox-1">
						<h4><label style="display: block;">구매전 안내</label></h4>
			  			<textarea class="form-control" name="productguide" id="product-guide" rows="6" placeholder="구매전 안내 입력해 주세요" style="width: 900px;"></textarea>
			  		</div>
				</div>
				<div class="form-group" style="padding-left: 0px;">
					<div class="form-group" id="newsbox-1">
						<h4><label style="display: block;">환불규정</label></h4>
			  			<textarea class="form-control" name="productrefund" id="product-refund" rows="6" placeholder="환불규정 입력해 주세요" style="width: 900px;"></textarea>
					</div>
				</div>
				<div class="text-right" style="margin-right: 45px; margin-top: 25px;">
					<button type="submit" class="btn btn-primary btn-lg">상품 등록</button>
					<button	type="button" class="btn btn-danger btn-lg">상품 수정</button>
				</div>
			</form>
		</div>
	</div>
</div>
<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript">
	


// 라디오버튼, 체크박스가 체크될 때 마다 실행되는 메소드
function getCheckedValue(e) {
	var isChecked = e.target.checked;
	var val = e.target.value;
	if(isChecked){
		console.log("체크여부", isChecked, "체크된 값", val);
	}
}

// 서브이미지 등록
// + 버튼을 누르면 자동으로 같은 테그가 추가되도록 하는 스크립트
// 생성된 태그들을 div로 묶어서 추가한 이유는 삭제 버튼을 누를때 자식만 삭제를 할수 없기 때문에
// div(부모)태그 에 같은 값을 주어서 삭제 버튼이랑 같은 값을 비교해서 같은 값을 가진 태그만 삭제가능 
var subimageIndex = 1;
function addImageFile(e) {
	var htmlContent  = "<div id='box-"+ ++subimageIndex+"'>";
	htmlContent += '<input type="file" class="form-control" name="subproductimg'+ subimageIndex +'"  style="width: 500px; margin-left:123px; margin-bottom:10px;" />';
	htmlContent +=' <input type="button" value="삭제" onClick="removeRow('+subimageIndex+')" style="cursor:hand" class="btn btn-danger btn-xs">';
	htmlContent += "</div>"
	document.querySelector("#image-box").innerHTML += htmlContent;
}

function removeRow(num) {
	var box = document.querySelector("#box-" + num);
	document.querySelector("#image-box").removeChild(box);
}
//-------------------------------------------------------------------------------------------------------------------------------------------

// 추가옵션 등록
// 위 방식(서브이미지 등록)과 같음
var suboption = 1;
function addOption(e) {
	var html ="<div id='box-"+ ++suboption+"'>";
	    html += '<input type="text" class="form-control" name="addoption'+ suboption +'" id="add-option" style="width: 250px; margin-left:123px; margin-bottom:10px;"/>'
    	+ '<label style="width: 110px; text-align: right;">가격&nbsp;</label>'
    	+ '<input type="text" class="form-control" style="width: 140px; margin-bottom:10px;" name="addoptionprice'+ suboption +'" id="product-price"/>'
    	html +=' <input type="button" value="삭제" onClick="removeOption('+suboption+')" style="cursor:hand" class="btn btn-danger btn-xs">';
    	html += "</div>"
    	
    	document.querySelector("#option-box").innerHTML += html;
}

function removeOption(num) {
	var box = document.querySelector("#box-" + num);
	document.querySelector("#option-box").removeChild(box);
}
//subOptions-126
function changeSubcategory() {
	var mainNo = $("#main-category option:selected").val();
	var ops = document.querySelectorAll("[id^='subOptions-']");
	for(var i =0; i<ops.length; i++) {
		if(ops[i].id != "subOptions-"+mainNo) {
			ops[i].hidden = true;
		} else {
			ops[i].hidden = false;
		}
	}
}
</script>
</body>
</html>













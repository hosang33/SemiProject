<%@page import="java.util.StringJoiner"%>
<%@page import="kr.pren.util.StringUtils"%>
<%@page import="kr.pren.util.CookieUtils"%>
<%@page import="kr.pren.vo.Pagination"%>
<%@page import="kr.pren.dao.MessageDao"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="kr.pren.vo.Order"%>
<%@page import="kr.pren.dao.OrderDao"%>
<%@page import="kr.pren.vo.Review"%>
<%@page import="kr.pren.dao.ReviewDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="kr.pren.util.NumberUtils"%>
<%@page import="kr.pren.vo.Option"%>
<%@page import="kr.pren.dao.OptionDao"%>
<%@page import="kr.pren.dao.UserDao"%>
<%@page import="kr.pren.vo.SaleItem"%>
<%@page import="kr.pren.dao.SaleItemDao"%>
<%@page import="kr.pren.vo.ItemImage"%>
<%@page import="kr.pren.dao.ItemImageDao"%>
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
     .dropdown:hover .dropdown-menu {
    display: block;
    margin-top: 0;
   }
   .dropdown-toggle::after {
    display:none;
   }
   .dropdown-menu::before, 
   .dropdown-menu::after {
    border: none;
    content: none;
   }
   .red, .red a {

     color: red;
   }
     
     
     .starReview1{
       background: url('http://miuu227.godohosting.com/images/icon/ico_review.png') no-repeat -52px 0;
       background-size: auto 100%;
       width: 15px;
       height: 30px;
       float:left;
       text-indent: -9999px;
       cursor: pointer;
   }
   .starReview2{
       background: url('http://miuu227.godohosting.com/images/icon/ico_review.png') no-repeat right 0;
       background-size: auto 100%;
       width: 15px;
       height: 30px;
       float:left;
       text-indent: -9999px;
       cursor: pointer;
   }
   
   .starReview1.on{background-position:0 0;}
   .starReview2.on{background-position:-15px 0;}
   
   .filebox label { 
   
      display: inline-block; padding: .5em .75em; color: #999; 
      font-size: inherit; line-height: normal; vertical-align: middle; 
      background-color: #fdfdfd; cursor: pointer; border: 1px solid black;
      color: black;
      border-bottom-color: black; border-radius: .25em; 
   }
   
   .filebox input[type="file"] {
      /* 파일 필드 숨기기 */
      position: absolute; width: 1px; height: 1px; padding: 0; 
      margin: -1px; overflow: hidden; clip:rect(0,0,0,0); border: 0; 
      
   }

     span.star-prototype, span.star-prototype > * {
     
    height: 21px; 
    background: url(http://i.imgur.com/YsyS5y8.png) 0 -16px repeat-x;
    width: 80px;
    display: inline-block;
    
   }
 
   span.star-prototype > * {
   
    background-position: 0 0;
    max-width:80px; 
    
   }
     
     
     
     
     </style>
</head>
<%@ include file="../../common/nav3.jsp" %>
<%

   String path = request.getRequestURI();

   int productNo = Integer.parseInt(request.getParameter("productNo"));
   
   SaleItemDao saleItemDao = SaleItemDao.getInstance();
   ItemImageDao itemImageDao = ItemImageDao.getInstance();
   OptionDao optionDao = OptionDao.getInstance();
   UserDao userDao = UserDao.getInstance();
   
   List<ItemImage> itemImages = itemImageDao.getItemImageByNo(productNo);
   SaleItem saleItem = saleItemDao.getSaleItemByNo(productNo);
   User user = userDao.getUserByNo(saleItem.getUser().getNo());
   List<Option> options = optionDao.getOptionByNo(productNo);
   SubCategoryDao subCategoryDao = SubCategoryDao.getInstance();
   SubCategory subCategory = subCategoryDao.getSubCategoryByNo(saleItem.getSubCategoryNo());
   
   SimpleDateFormat  format = new SimpleDateFormat("yyyy-MM-dd / HH:mm");
   String formatedDate = format.format(saleItem.getUploadDate());
   
   
   ReviewDao reviewDao = ReviewDao.getInstance();
   OrderDao orderDao = OrderDao.getInstance();
   
   
   MessageDao messageDao = MessageDao.getInstance();
   Map<String, Object> criteria = new HashMap<>();

   //잘못된 페이지번호로 접속시 무조건 1번페이지 반환 
   int pageNo = NumberUtils.stringToNumber(request.getParameter("pageno"),1); 
   //해당 테이블의 보여줄 전체 행의 번호를 조회
   int totalRows = reviewDao.getReviewCountByItemNo(productNo);
   
   Pagination pagination = new Pagination(pageNo, totalRows, 3);
   
   criteria.put("productNo", productNo);
   criteria.put("begin",pagination.getBeginIndex());
   criteria.put("end",pagination.getEndIndex());
   
   List<Review> reviews = reviewDao.getReviewsIsPaging(criteria);

   
   // 쿠키 조회하기
  
   Cookie[] cookies = request.getCookies();
   String recentProductNo = CookieUtils.getCookieValue(cookies, "recent");
  
  
   if(recentProductNo == null) {
	   Cookie cookie1 = new Cookie("recent", String.valueOf(productNo));
	// 쿠키 만료시간 7일
	   cookie1.setMaxAge(60*10);
	   // 도메인 설정
	   cookie1.setDomain("localhost");
	   // 쿠키에 대한 url경로 설정
	   cookie1.setPath("/semiproject");
	   // 쿠키를 클라이언트에 보내기
		response.addCookie(cookie1);
   } else {
	   String[] productNos = recentProductNo.split(":");
	   boolean isExist = StringUtils.isExistInArray(productNos, String.valueOf(productNo));
	   if (!isExist) {

		   String now = null;
		   
		   if (productNos.length == 5) {
			    StringJoiner joiner = new StringJoiner(":");
			    for (int i=1; i<productNos.length; i++) {
			    	joiner.add(productNos[i]);
			    }
			    joiner.add(String.valueOf(productNo));
			    now = joiner.toString();
			    
		   } else {
			   now = recentProductNo + ":" + String.valueOf(productNo);
		   }
		   
		   Cookie cookie1 = new Cookie("recent", now);
		   // 브라우저를 닫을때 쿠키를 삭제
		   // 쿠키 만료시간 7일
		   cookie1.setMaxAge(60*10);
		   // 도메인 설정
		   cookie1.setDomain("localhost");
		   // 쿠키에 대한 url경로 설정
		   cookie1.setPath("/semiproject");
		   // 쿠키를 클라이언트에 보내기
			response.addCookie(cookie1);
		   
	   }
   }
   
%>
<body>
<div class="product-wrap">
   <div class="container">
      <div class="row">
         <div class="col-sm-7" style=" width: 643px;">
            <div class="box mb-30 p-15 thumbnail" >
               <div class="product-summary">
                  <div class="product-img">
                     <img style="width: 603px; height: 480px; padding: 15px 15px;" src="../../resources/images/item_logo/<%=saleItem.getLogoName() !=null ? saleItem.getLogoName() : "productImg.jpg"%>">
                  </div>
                  <div class="seller-info">
                     <div class="item">
                        <div style="margin-bottom: 10px; margin-top:10px; padding-left: 10px; display: inline-block;">
                               <img class="img-circle" src="../../resources/images/user_profile/<%=user.getProfileImgName() !=null ? user.getProfileImgName() : "person.png" %>" style="width: 60px; height: 60px; border: 1px solid rgb(221, 221, 221); border: radius: 100%; margin-right: 5px; display: inline-block; vertical-align: middle;">
                               <strong style="font-size: 25px;"><%=user.getNickName() %></strong>
                             </div>
                             <div style="display: inline-block; float: right;">
                                <span style="display: inline-block; font-size: 20px; margin-top: 40px;"><%=formatedDate %></span>
                             </div>
                     </div>
                  </div>
               </div>
            </div>
            
            <div class="row" id="product-detail-tab"  style="width:100%;">
               <div class="box"style="background-color: white; padding: 20px 13px;">
                   <ul class="nav nav-pills">
                      <li id="a-1" class="active" onclick="fn1(1)"><a href="#">맨위로</a></li>
                     <li id="a-2" onclick="fn1(2)"><a href="#detail"  >상세설명</a></li>
                     <li id="a-3" onclick="fn1(3)"><a href="#guidance" >구매전 안내</a></li>
                      <li id="a-4" onclick="fn1(4)"><a href="#refund" >환불규정</a></li>
                      <li id="a-5" onclick="fn1(5)"><a href="#review" >Review</a></li>
                  </ul>
               </div>
            </div>
            
            <div class="row" style="width: 643px;">
               <div id="detail" class="thumbnail box mb-30 p-15" style="width: 620px; margin-left: 10px;">
                  <!-- 상세 설명 -->
                  <p><%=saleItem.getContent() %></p>
                  <%
                  for (ItemImage i : itemImages) {
                  %>
                     <img src="../../resources/images/user_item/<%=i.getName() %>" style="width: 100%; margin-top: 20px; max-width: 650px;">
                  <%
                     }
                  %>
               </div>
               <hr>
               <div id="guidance" class="thumbnail box mb-30 p-15" style="width: 620px; margin-left: 10px;">
                  <p><%=saleItem.getContentsGuide() %></p>
               </div>
               <hr>
               <div id="refund" class="thumbnail box mb-30 p-15" style="width: 620px; margin-left: 10px;">
                  <p><%=saleItem.getContentsRefund() %></p>
               </div>
               <hr>
               <div class="thumbnail box mb-30 p-15" style="width: 620px; margin-left: 10px;">
                  <div>
                  <%
                     int reviewCount =reviewDao.getReviewCountByItemNo(saleItem.getNo());
                  %>
                     <div style="margin-bottom: 15px; font-size: 20px; font-weight: bold;">
                        <span id="review">Review (<%=reviewCount %> 건)</span>
                     </div>
                  <%
                     for (Review r : reviews) {
                        String reviewDate = format.format(r.getCreatedate());
                        User userInfo = userDao.getUserByNo(r.getUserNo());
                  %>
                     <div style="border-top: 1px solid rgb(225, 225, 225); padding: 20px 0px; ">
                        <div style="text-align: center; display: inline-block; width: 15%; margin-right: 5%;">
                           <img class="img-circle" src="../../resources/images/user_profile/<%=userInfo.getProfileImgName() !=null ? userInfo.getProfileImgName() : "person.png" %>" style="background-color: rgb(225, 225, 225); border-radius: 100%; display: inline-block; vertical-align: top; width: 80px; height: 80px; margin-bottom: 5px;">
                           <div style="font-weight: bold; color: rgb(98, 98, 98);"><%=userInfo.getNickName() %></div>
                        </div>
                        <div style="display: inline-block; vertical-align: top; width: 80%; float: right;">
                        	<div id="first-box" class="pull-right" style="display: inline-block; float: right;">
                 		   	<%
                        		if(loginedUser != null && loginedUser.getNo() == r.getUserNo()) {
                        	%>
	                        	<button class="btn btn-warning btn-xs" onclick="updatePop(<%=r.getNo() %>);">수정</button>
	                        	<a href="review_delete.jsp?productNo=<%=r.getItemNo() %>&reviewNo=<%=r.getNo() %>" class="btn btn-danger btn-xs">삭제</a>
	                        <%
                        		}
	                        %>
	                       	</div>
                        	<div style="position: relative; display: inline-block; font-size: 20px; margin-bottom: 10px; letter-spacing: 5px;">
                            	<div style="color: rgb(225, 225, 225);">
                                	<span class="star-prototype"><%=(double)r.getStar()/2 %></span>
                            	</div>
                       		</div>
                           <div style="line-height: 30px; margin-bottom: 10px; color: rgb(98, 98, 98);"><%=r.getContent() %></div>
                           <div style="display: inline-block; float: left; width: ">
                           		<img style="width: 40px; height: 40px;" src="../../resources/images/review/<%=r.getReviewImg() == null ? "noimage.jpg" : r.getReviewImg() %>"  onclick="imagePop('<%=r.getReviewImg() == null ? "noimage.jpg" : r.getReviewImg()%>')">
                           </div>
                           <div style="color: rgb(185, 185, 185); display: inline-block; float: right;"><%=reviewDate %></div>
                        </div>
                     </div>
                     
                  <%
                     }
                  %>
               
                  </div>
                  <div class="col-sm-12 text-center">
                     <ul class="pagination">
                        <li class="<%=pageNo > 1 ? "" : "disabled"%>"><a href="product_display.jsp?productNo=<%=productNo %>&pageno=<%=pageNo-1%>">&laquo;</a></li>
                        
                        <%
                           for (int num =pagination.getBeginPage(); num<=pagination.getEndPage(); num++) {
                        %>
                              <li class="<%=pageNo == num ? "active" : ""%>"><a href="product_display.jsp?productNo=<%=productNo %>&pageno=<%=num%>"><%=num%></a></li>
                        <%
                           }
                        %>
                        <li class="<%=pageNo < pagination.getTotalPagesCount() ? "" : "disabled"%>"><a href="product_display.jsp?productNo=<%=productNo %>&pageno=<%=pageNo+1%>">&raquo;</a></li>
                     </ul>
                  </div>
               </div>
            </div>
         </div>
         <div class="col-sm-5" style="height: 350px; position: fixed; margin-left: 680px; width: 500px;">
            <div>
               <div class="box mb-30 p-15" style="border: 0px; box-shadow: rgba(41, 42, 43, 0.16) 0px 2px 3px 0.6px;">
                  <div class="product-info" style="margin-top: 20px;">
                     <div class="title-wrap">
                        <div class="title" style="font-size: 12px; font-weight: 700; margin: 15px 8px; background-color: #4facfe; color: white; border-radius: 10px; display: inline-block; padding: 2px 10px;"><%=subCategory.getName() %></div>
                        
                        <div class="sub-title" style="font-size: 22px; font-weight: 700; line-height: 1.25; box-sizing: border-box; margin-left: 10px;"><%=saleItem.getTitle() %></div>
                     </div>
                     <div class="info-wrap">
                        <div style="margin-left: 10px;">
                           <%
                           		if (options.isEmpty()) {
                           %>
                           		<hr/>
                           		<div>*기본옵션이 없는 상품입니다*</div>
                           <%
                           		} else {
									for(Option o : options){
										if(o.getPlus().equals("n")){
							%>
                           
                           <div style="font-weight: bold; font-size: 15px; margin-bottom: 5px; margin-top: 19px; color: rgb(62, 64, 66); margin-left: 10px;">기본옵션</div>
                           <span style="padding-left: 10px;"><%=o.getTitle() %></span>
                           <%
										}
									}
                           		}
						%>
                           <%
								for(Option o : options){
									if(o.getPlus().equals("y")){
						%>
	                           <div style="font-weight: bold; font-size: 15px; margin-bottom: 5px; margin-top: 19px; color: rgb(62, 64, 66); margin-left: 10px;">추가옵션</div>
							<p>
							<span style="padding-left: 10px;"><%=o.getTitle() %></span>
							</p>
						<%
									}
								}
						%>
                        </div>
                        <hr/>
                        <div class="btn-wrap">
                           <div class="total-price" style="font-size: 30px; font-weight: 700; color: #4facfe; text-align: right;">
                              <%=NumberUtils.numberWithComma(saleItem.getPrice()) %><span class="currency"> 원</span>
                           </div>
                           <div style="text-align: right; font-size: 12px; color: rgb(88, 88, 88); font-weight: 300;">*부가세 포함 금액*</div>
                           <div style="display: flex; justify-content: space-between; margin-top: 14px;">
                           <%
                              if(loginedUser != null){
                                 if(loginedUser.getNo() == saleItem.getUser().getNo() ) {
                           %>
                                    <a href="../sell_management/add_item_form2.jsp?productNo=<%=productNo%>" class="btn btn-default" style="padding-top: 13px; margin: 10px 10px 10px 30px; width: 45%; height: 48px; background-color: white; border: 1px solid rgb(225, 225, 225); outline: none; font-size: 16px;">수정하기</a>
                                    <a href="product_delete.jsp?productNo=<%=productNo %>" class="btn btn-default" style="padding-top: 13px; margin: 10px 30px 10px 10px; width: 45%; height: 48px; border: 1px solid rgb(225, 225, 225); outline: none; font-size: 16px;">삭제하기</a>
                           <%
                                 } else {
                           %>
                                    <a href="../message/message_form.jsp?productNo=<%=productNo%>" class="btn btn-default" style="padding-top: 13px; margin: 10px 10px 10px 30px; width: 45%; height: 48px; background-color: white; border: 1px solid rgb(225, 225, 225); outline: none; font-size: 16px;">문의하기</a>
                                    <a href="item_buy_form.jsp?productNo=<%=productNo%>" class="btn btn-danger" style="padding-top: 13px; margin: 10px 30px 10px 10px; width: 45%; height: 48px; border: 1px solid rgb(225, 225, 225); outline: none; font-size: 16px;">주문하기</a>
                           <%
                                 }
                              } 
                           %>
                           
                           <% 
                              if(loginedUser == null){ 
                                 String queryString = request.getQueryString();
                           %>
                                 
                              <a href="../mypage/login_form.jsp?path=<%=path%>?<%=queryString%>" class="btn btn-default" style="padding-top: 13px; margin: 10px 10px 10px 30px; width: 45%; height: 48px; background-color: white; border: 1px solid rgb(225, 225, 225); outline: none; font-size: 16px;">문의하기</a>
                              <a href="../mypage/login_form.jsp?path=<%=path%>?<%=queryString%>" class="btn btn-danger" style="padding-top: 13px; margin: 10px 30px 10px 10px; width: 45%; height: 48px; border: 1px solid rgb(225, 225, 225); outline: none; font-size: 16px;">주문하기</a>
                           <%
                              }
                           %>
                           </div>
                        </div>
                     </div>
                  </div>
               </div>
            </div>
            <%
            if (loginedUser != null) {
            
               Map<String, Object> map = new HashMap<>();
               map.put("userNo", loginedUser.getNo());
               map.put("productNo", productNo);
               
               Order order = orderDao.getNewOrderByMap(map);
               
               
               if (order != null && loginedUser != null && loginedUser.getNo() == order.getUserNo() && "완료".equals(order.getState())) {
                  
            %>
            
            
            <div style="margin-top: 50px;">
               <form id="review-form" action="product_review.jsp" method="post" enctype="multipart/form-data" class="well">
                  <input type="hidden" name="starScore" id="star" value="1"/>
                  <input type="hidden" name="itemNo" id ="item" value="<%=productNo %>">
                  <input type="hidden" name="userNo" id ="userInfo" value="<%=loginedUser.getNo() %>">
                  <div class="form-group">
                      <label  style="font-size: 15px;">리뷰내용</label>
                      <textarea class="form-control" rows="5" name="reviewContent" id="reviewText"></textarea>
                    </div>
                    <div class="form-group" style="display: inline-block;">
                     <label>별점 주기</label>                    
                       <div class="star">
                         <span class="starReview1 on">★</span>
                          <span class="starReview2">★</span>
                        <span class="starReview1">★</span>
                        <span class="starReview2">★</span>
                        <span class="starReview1">★</span>
                        <span class="starReview2">★</span>
                        <span class="starReview1">★</span>
                        <span class="starReview2">★</span>
                        <span class="starReview1">★</span>
                        <span class="starReview2">★</span>
                     </div>
                    </div>
                     <div class="filebox" style="display: inline-block; float: right; margin-top: 20px;">
                         <label for="photo-upload">사진올리기</label> 
                         <input type="file" id="photo-upload" name="reviewFile"> 
                      </div>
                  <div>
                     <button type="button" class="btn btn-danger btn-block" onclick="btn1(event)">등록하기</button>
                  </div>
               </form>
            </div>
            <%
               }
            }
            %>
         </div>
      </div>
      
   </div>
</div>

	<%@ include file="../../common/footer.jsp" %>
</body>
<script type="text/javascript">
   $(window).scroll(function() {
      if ($(this).scrollTop() > 735) {
         $('#product-detail-tab').css({position:'fixed', top:'10px'})
      } else {
         $('#product-detail-tab').css({position:'static'})
      }
   });
   
   
   function fn1(no) {
      var items = document.querySelectorAll('.nav-pills li');
      for(var i=0; i<items.length; i++){
         var li = items[i];
         li.removeAttribute('class');
      }
      
      document.querySelector('#a-' + no).setAttribute('class', 'active');
   }
   
   $('.star span').click(function(){
        $(this).parent().children('span').removeClass('on');
        $(this).addClass('on').prevAll('span').addClass('on');
        
       var len = document.querySelectorAll(".star .on").length;
       document.getElementById("star").value = len;
        
        return false;
      });
   
   function btn1(e) {
      
      var content = document.getElementById("reviewText").value;
      if (content == "") {
         alert('리뷰 내용을 입력해주세요.');
         return;
      }
         alert('리뷰 등록 완료 !');
         document.getElementById("review-form").submit();
   }
   
   $.fn.generateStars = function() {
       return this.each(function(i,e){$(e).html($('<span/>').width($(e).text()*16));});
   };

   // 숫자 평점을 별로 변환하도록 호출하는 함수
   $('.star-prototype').generateStars();
   
   
   function imagePop(imagename) {
	   window.open("imagepopup.jsp?imagename=" + imagename, 'imagepopup', "width=400,height=300")
   }
   
   
   function updatePop(reviewNo) {
		window.open("updateReview.jsp?reviewNo=" + reviewNo , "updatePop", "width=768,height=360,resizable=false")
	}
	
</script>
</html>
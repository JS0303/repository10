<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page pageEncoding="EUC-KR"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>

<%@ page import="com.model2.mvc.service.domain.Product"%>
<%@ page import="com.model2.mvc.common.Search"%>
<%@ page import="com.model2.mvc.common.Page"%>

<!DOCTYPE html>


<%-- /////////////////////// EL / JSTL 적용으로 주석 처리 ////////////////////////
<%

	List<Product> list= (List<Product>)request.getAttribute("list");
	Page resultPage=(Page)request.getAttribute("resultPage");
	
	Search search = (Search)request.getAttribute("search");
	//==> null 을 ""(nullString)으로 변경
	String searchCondition = CommonUtil.null2str(search.getSearchCondition());
	String searchKeyword = CommonUtil.null2str(search.getSearchKeyword());
	
	System.out.println(":: listProduct의 searchCondition :: "+searchCondition);
	System.out.println(":: listProduct의 searchKeyword :: "+searchKeyword);
%>
/////////////////////// EL / JSTL 적용으로 주석 처리 //////////////////////// --%>

<html>

<head>
<meta charset="EUC-KR">
<title>상품목록조회</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">

<!-- CDN(Content Delivery Network) 호스트 사용 -->
<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
	
	//=====기존Code 주석 처리 후  jQuery 변경 ======//
	//검색 / page 두가지 경우 모두 Form 전송을 위해 JavaScrpt 이용  
	function fncGetList(currentPage) {
		console.log(currentPage);
		var menu = $("input[name='menu']").val();
		//document.getElementById("currentPage").value = currentPage;
		$("#currentPage").val(currentPage)
   		//document.detailForm.submit();
		$("form").attr("method" , "POST").attr("action" , "/product/listProduct?menu="+menu).submit();
	}
	//===========================================//
	//==> 추가된부분 : "검색" ,  productName link  Event 연결 및 처리
	 $(function() {
		var menu = $("input[name='menu']").val();
		//==> 검색 Event 연결처리부분
		//==> DOM Object GET 3가지 방법 ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
		//==> 1 과 3 방법 조합 : $("tagName.className:filter함수") 사용함. 
			 $( "td.ct_btn01:contains('검색')" ).on("click" , function() {
				//Debug..
				//alert(  $( "td.ct_btn01:contains('검색')" ).html() );
				fncGetList('1');
			});
			
			
			//==> productName LINK Event 연결처리
			//==> DOM Object GET 3가지 방법 ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
			//==> 3 과 1 방법 조합 : $(".className tagName:filter함수") 사용함.
			if(menu=="manage"){
			$( ".ct_list_pop td:nth-child(3)").on("click" , function() {
					//Debug..
					//alert(  $( this ).text().trim() );
					self.location ="/product/updateProduct?prodNo="+$(this).find("input[name=prodNo]").val();
					
					});
			}
			if(menu=="search"){
			$( ".ct_list_pop td:nth-child(3)").on("click" , function() {
					/*///////////////////// ajax 적용으로 주석처리 //////////////////////////////
					self.location ="/product/getProduct?prodNo="+$(this).find("input[name=prodNo]").val();
					///////////////////// ajax 적용으로 주석처리 //////////////////////////////*/
					var prodNo = $(this).find("input[name=prodNo]").val().trim();
					$.ajax( 
							{
								url : "/product/json/getProduct/"+prodNo ,
								method : "GET" ,
								dataType : "json" ,
								headers : {
									"Accept" : "application/json",
									"Content-Type" : "application/json"
								},
								success : function(JSONData , status) {

									//Debug...
									//alert(status);
									//Debug...
									//alert("JSONData : \n"+JSONData);
									
									var displayValue = "<h3>"
																+"상품번호 : "+JSONData.prodNo+"<br/>"
																+"상품이름 : "+JSONData.prodName+"<br/>"
																+"상세정보 : "+JSONData.prodDetail+"<br/>"
																+"가  격 : "+JSONData.price+"<br/>"
																+"등록일 : "+JSONData.regDateString+"<br/>"
																+"</h3>";
									//Debug...									
									//alert(displayValue);
									$("h3").remove();
									$( "#"+prodNo+"" ).html(displayValue);
								}
						});
					////////////////////////////////////////////////////////////////////////////////////////////	
			
				});
			}
			
			//==> currentPage LINK Event 연결처리
			//==> DOM Object GET 3가지 방법 ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
			//==> 3 과 1 방법 조합 : $(".className tagName:filter함수") 사용함.
			//$("#currentPage").on("click" , function() {
					//Debug.
					//alert(  $( this ).text().trim() );
			//		self.location ="/product/getProduct?prodName="+$(this).text().trim();
			//});
			
			//==> UI 수정 추가부분  :  userId LINK Event End User 에게 보일수 있도록 
			$( ".ct_list_pop td:nth-child(3)" ).css("color" , "red");
			$("h7").css("color" , "red");
			
			
			//==> 아래와 같이 정의한 이유는 ??
			//==> 아래의 주석을 하나씩 풀어 가며 이해하세요.					
			$(".ct_list_pop:nth-child(4n+6)" ).css("background-color" , "whitesmoke");
			//console.log ( $(".ct_list_pop:nth-child(1)" ).html() );
			//console.log ( $(".ct_list_pop:nth-child(2)" ).html() );
			//console.log ( $(".ct_list_pop:nth-child(3)" ).html() );
			//console.log ( $(".ct_list_pop:nth-child(4)" ).html() ); //==> ok
			//console.log ( $(".ct_list_pop:nth-child(5)" ).html() ); 
			//console.log ( $(".ct_list_pop:nth-child(6)" ).html() ); //==> ok
			//console.log ( $(".ct_list_pop:nth-child(7)" ).html() ); 
		});	

</script>
</head>

<body bgcolor="#ffffff" text="#000000">

	<div style="width: 98%; margin-left: 10px;">
		<!-- ////////////////// jQuery Event 처리로 변경됨 /////////////////////////
<form name="detailForm" action="/product/listProduct?menu=${param.menu}" method="post">
////////////////////////////////////////////////////////////////////////////////////////////////// -->
		<form name="detailForm">

			<table width="100%" height="37" border="0" cellpadding="0"
				cellspacing="0">
				<tr>
					<td width="15" height="37"><img src="/images/ct_ttl_img01.gif"
						width="15" height="37" /></td>
					<td background="/images/ct_ttl_img02.gif" width="100%"
						style="padding-left: 10px;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<%-- /////////////////////// EL / JSTL 적용으로 주석 처리 ////////////////////////
				<%
				if (request.getParameter("menu").equals("search")){
				%>
				/////////////////////// EL / JSTL 적용으로 주석 처리 //////////////////////// --%>
								<c:if test="${param.menu=='search'}">
									<td width="93%" class="ct_ttl01">상품 목록조회</td>
								</c:if>
								<%-- /////////////////////// EL / JSTL 적용으로 주석 처리 ////////////////////////
				<%
				}else{
				%>
				/////////////////////// EL / JSTL 적용으로 주석 처리 //////////////////////// --%>
								<c:if test="${param.menu=='manage'}">
									<td width="93%" class="ct_ttl01">상품 관리</td>
								</c:if>
								<%-- /////////////////////// EL / JSTL 적용으로 주석 처리 ////////////////////////
				<%
				}
				%>
				/////////////////////// EL / JSTL 적용으로 주석 처리 //////////////////////// --%>
							</tr>
						</table>
					</td>
					<td width="12" height="37"><img src="/images/ct_ttl_img03.gif"
						width="12" height="37" /></td>
				</tr>
			</table>


			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				style="margin-top: 10px;">
				<tr>
					<td align="right"><select name="searchCondition"
						class="ct_input_g" style="width: 80px">
							<%-- /////////////////////// EL / JSTL 적용으로 주석 처리 ////////////////////////
				<option value="0" <%= (searchCondition.equals("0") ? "selected" : "")%>>상품번호</option>
				<option value="1" <%= (searchCondition.equals("1") ? "selected" : "")%>>상품명</option>
				<option value="2" <%= (searchCondition.equals("2") ? "selected" : "")%>>상품가격</option>
				/////////////////////// EL / JSTL 적용으로 주석 처리 //////////////////////// --%>
							<option value="0"
								${ ! empty search.searchCondition && search.searchCondition==0 ? "selected" : "" }>상품번호</option>
							<option value="1"
								${ ! empty search.searchCondition && search.searchCondition==1 ? "selected" : "" }>상품명</option>
							<option value="2"
								${ ! empty search.searchCondition && search.searchCondition==2 ? "selected" : "" }>상품가격</option>
					</select> <input type="text" name="searchKeyword"
						value="${! empty search.searchKeyword ? search.searchKeyword : ''}"
						class="ct_input_g" style="width: 200px; height: 19px" /></td>

					<td align="right" width="70">
						<table border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="17" height="23"><img
									src="/images/ct_btnbg01.gif" width="17" height="23"></td>
								<td background="/images/ct_btnbg02.gif" class="ct_btn01"
									style="padding-top: 3px;">
									<!-- ////////////////// jQuery Event 처리로 변경됨 /////////////////////////
						<a href="javascript:fncGetProductList(1);">검색</a>
						////////////////////////////////////////////////////////////////////////////////////////////////// -->
									검색
								</td>
								<td width="14" height="23"><img
									src="/images/ct_btnbg03.gif" width="14" height="23"></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>


			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				style="margin-top: 10px;">
				<tr>
					<td colspan="11">전체 ${resultPage.totalCount} 건수, 현재
						${resultPage.currentPage} 페이지</td>
				</tr>
				<tr>
					<td class="ct_list_b" width="100">No</td>
					<td class="ct_line02"></td>
					<!-- ////////////////// jQuery Event 처리로 변경됨 /////////////////////////
		<td class="ct_list_b" width="150">상품명</td>
		////////////////////////////////////////////////////////////////////////////////////////////////// -->
					<td class="ct_list_b" width="150">상품명<br> 
					<h7>(상품명 click:상세정보)</h7>
					<td class="ct_line02"></td>
					<td class="ct_list_b" width="150">가격</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b">등록일</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b">현재상태</td>
				</tr>
				<tr>
					<td colspan="11" bgcolor="808285" height="1"></td>
				</tr>
				<%-- /////////////////////// EL / JSTL 적용으로 주석 처리 ////////////////////////
	<%
		for(int i=0; i<list.size(); i++) {
			Product product = list.get(i);
		%>
/////////////////////// EL / JSTL 적용으로 주석 처리 //////////////////////// --%>

				<c:set var="i" value="0" />
				<c:forEach var="product" items="${list}">
					<c:set var="i" value="${ i+1 }" />
					<tr class="ct_list_pop">
						<td align="center">${i}</td>
						<td></td>
						<td align="left">
							<!-- ////////////////// jQuery Event 처리로 변경됨 /////////////////////////
			<a href="/product/getProduct?prodNo=${product.prodNo}&menu=${param.menu}">${product.prodName}</a>
			////////////////////////////////////////////////////////////////////////////////////////////////// -->
							${product.prodName} 
							<input type="hidden" name="prodNo"	value="${product.prodNo}"> 
							<input type="hidden" name="menu" value="${param.menu}">
						</td>

						<td></td>
						<td align="left">${product.price}</td>
						<td></td>
						<td align="left">${product.regDate}</td>
						<td></td>
						<td align="left"></td>
					</tr>
					
					<tr>
			<!-- //////////////////////////// 추가 , 변경된 부분 /////////////////////////////
			<td colspan="11" bgcolor="D6D7D6" height="1"></td>
			////////////////////////////////////////////////////////////////////////////////////////////  -->
			<td id="${product.prodNo}" colspan="11" bgcolor="D6D7D6" height="1"></td>
		</tr>
				</c:forEach>
				<tr>
					<%-- /////////////////////// EL / JSTL 적용으로 주석 처리 ////////////////////////
	<% } %>	
/////////////////////// EL / JSTL 적용으로 주석 처리 //////////////////////// --%>
					<td colspan="11" bgcolor="D6D7D6" height="1"></td>
				</tr>
			</table>

			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				style="margin-top: 10px;">
				<tr>
					<td align="center"><input type="hidden" id="currentPage"
						name="currentPage" value="" /> <%-- /////////////////////// EL / JSTL 적용으로 주석 처리 ////////////////////////
			<% if( resultPage.getCurrentPage() <= resultPage.getPageUnit() ){ %>
			<c:if test="${ resultPage.currentPage <= resultPage.pageUnit }">
			◀ 이전
			</c:if>
			<% }else{ %>
			<c:if test="${ resultPage.currentPage > resultPage.pageUnit }">
				<a href="javascript:fncGetProductList('${ resultPage.currentPage-1}')">◀ 이전</a>
			</c:if>
			<% } %>
			<%	for(int i=resultPage.getBeginUnitPage();i<= resultPage.getEndUnitPage() ;i++){	%>
			<c:forEach var="i"  begin="${resultPage.beginUnitPage}" end="${resultPage.endUnitPage}" step="1">
				<a href="javascript:fncGetProductList('${ i }');">${ i }</a>
			</c:forEach>
			<% 	}  %>
			<% if( resultPage.getEndUnitPage() >= resultPage.getMaxPage() ){ %>
			<c:if test="${ resultPage.endUnitPage >= resultPage.maxPage }">
			이후 ▶
			</c:if>
			<%-- /////////////////////// EL / JSTL 적용으로 주석 처리 ////////////////////////
			<% }else{ %>	
			<c:if test="${ resultPage.endUnitPage < resultPage.maxPage }">
				<a href="javascript:fncGetProductList('${resultPage.endUnitPage+1}')">이후 ▶</a>
			</c:if>
			<% } %>	
/////////////////////// EL / JSTL 적용으로 주석 처리 //////////////////////// --%>

						<jsp:include page="../common/pageNavigator.jsp" /></td>
				</tr>
			</table>
			<!--  페이지 Navigator 끝 -->

		</form>

	</div>
</body>
</html>
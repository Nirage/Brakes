<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="order" tagdir="/WEB-INF/tags/responsive/order" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:set var="showVatApplicable" value="false"/>
<div class="col-xs-12 col-md-8 col-md-offset-2 js-productsGridContainer h-space-7" data-new-grid="col-md-12 col-md-offset-0" data-old-grid="col-md-8 col-md-offset-2">
  <div class="order-details__section">
    <c:if test="${isAmendOrderDetailsPage}">
    <div class="order-details__quick-add">
      <div class="row">
        <div class="col-xs-12 col-sm-6">
          <order:quickAddOrderDetails />
        </div>
      </div>
    </div>
  </c:if>
    
  <c:if test="${not empty orderDetails}">
    <c:set var="hasNextPage" value="${(orderDetails.pagination.currentPage) < orderDetails.pagination.numberOfPages}"/>
    <ul class="cart__items-list js-orderItemList">
      <%-- Removed entries are displayed on amend order page --%>
      <c:forEach var="entry" items="${orderDetails.results}">
        <c:if test="${entry.product.subjectToVAT eq true}">
             <c:set var="showVatApplicable" value="true"/>
        </c:if>
        <c:choose>
          <c:when test="${not empty entry.substitutedEntry and entry.substitutedEntry.entryStatusCode eq 'SUBSTITUTION_INITIATED' and orderDetails.order.substitutionInProcess eq true }">
            <c:choose>
              <c:when test="${entry.linkedPromoEntry != null}">
                <order:orderLineEntriesDetails orderEntry="${entry.linkedPromoEntry}" itemIndex="${loop.index}" substitutedEntry="${entry.substitutedEntry}"/>
              </c:when>
              <c:otherwise>
                <order:orderLineEntriesDetails orderEntry="${entry}" itemIndex="${loop.index}" substitutedEntry="${entry.substitutedEntry}"/>
              </c:otherwise>
            </c:choose>
        </c:when>
	   <c:when test="${entry.entryStatusCode ne 'SUBSTITUTION_INITIATED' and entry.entryStatusCode ne 'SUBSTITUTED_AND_CANCELLED' and entry.entryStatusCode ne 'SUBSTITUTED_AND_CANCEL_REQUESTED' and entry.entryStatusCode ne 'SUBSTITUTED_AND_CANCELLED_BY_ADMIN' and entry.entryStatusCode ne 'SUBSTITUTE_AND_CANCEL_BY_ADMIN_REQUESTED'}">
         	 <c:choose>
         	 	<c:when test="${entry.promoGroupNumber gt -1 }">
         	 		<div class="cart-item__promo-group">
			           <order:orderLineEntriesDetails orderEntry="${entry}" itemIndex="${loop.index}"/>
			          <c:if test="${entry.linkedPromoEntry != null}">
			         	 <order:orderLineEntriesDetails orderEntry="${entry.linkedPromoEntry}" itemIndex="${loop.index}" promo="true"/>
			          </c:if>
			        </div>
         	 	</c:when>
         	 	<c:otherwise>
         	 		<order:orderLineEntriesDetails orderEntry="${entry}" itemIndex="${loop.index}"/>
         	 	</c:otherwise>
         	 </c:choose>
        
      </c:when>
        </c:choose>
      </c:forEach>
      <c:if test="${hasNextPage}">
        <c:choose>
          <c:when test="${cmsPage.uid eq 'amendorder'}">
            <spring:url value="/my-account/amend/order/results/" var="loadMoreOrdersBaseUrl" htmlEscape="false"/>
          </c:when>
          <c:otherwise>
            <spring:url value="/my-account/order/results/" var="loadMoreOrdersBaseUrl" htmlEscape="false"/>
          </c:otherwise>
        </c:choose>
        <div class="cart-item__load-more order-line-entry__load-more js-orderDetailLoadMoreParent">
          <button class="btn btn-secondary js-orderDetailLoadMore" data-url="${loadMoreOrdersBaseUrl}${orderDetails.order.code}?page=${orderDetails.pagination.currentPage + 1}">
            <spring:theme code="text.order.details.loadMore" />
          </button>
        </div>
      </c:if>
    </ul>
  </c:if>
  </div>
  <c:if test="${showVatApplicable eq true}">
              <div class="row">
                  <div class="vat__text-box h-space-1">
                      <span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color"></span>
                      <spring:theme code="product.vat.applicable"/>
                  </div>
              </div>
     </c:if>
 </div>

 <input type="hidden" id="editing-row-item" />
 <div class="js_spinner spinning-div">
  <img class="spinning-image" src="${themeResourcePath}/images/Spinner-1s-75px.gif" alt="Loading..." />
</div>


<order:orderDetailHandlebarsTemplate />

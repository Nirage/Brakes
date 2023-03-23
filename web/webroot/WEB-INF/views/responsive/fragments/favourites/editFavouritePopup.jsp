<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement"
		   tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="sec"
		   uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>


<spring:htmlEscape defaultHtmlEscape="true" />

<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')" >

	<spring:url value="/favourite/namechange/page/{/favouriteUid}{/productCode}" var="renameFavouriteUrl" htmlEscape="false">
		<spring:param name="favouriteUid"  value="${favouriteUid}"/>
		<spring:param name="productCode"  value="${productCode}"/>
	</spring:url>
	<spring:url value="/favourite/delete/{/favouriteUid}" var="deleteFavouriteUrl" htmlEscape="false">
		<spring:param name="favouriteUid"  value="${favouriteUid}"/>
	</spring:url>

	<c:choose>
		<c:when test="${not empty productCode}">
			<spring:url value="/favourite/changeitemorder" var="changeOrderUrl" htmlEscape="false"/>
		</c:when>
		<c:otherwise>
			<spring:url value="/favourite/changeorder" var="changeOrderUrl" htmlEscape="false"/>
		</c:otherwise>
	</c:choose>


	<div class="edit-wishlist">
		<ycommerce:testId code="edit-favourite-popup">
			<div class="fav-item__edit-section fav-item__edit-section--top">
				<c:if test="${empty productCode}">
					<div class="fav-item__edit-action fav-item-rename  js-favEditAction" data-action="amend" data-id="${favouriteUid}" data-href="${renameFavouriteUrl}">
						<span class="icon icon-amend fav-item__edit-icon"></span>
						<span class="fav-item__edit-text"><spring:theme code="popup.favourite.rename" /></span>
					</div>
				</c:if>
				<div class="fav-item__edit-action fav-item-delete  js-favEditAction" data-action="delete" data-id="${favouriteUid}">
					<span class="icon icon-trash fav-item__edit-icon"></span>
					<span class="fav-item__edit-text"><spring:theme code="popup.favourite.delete" /></span>
				</div>
			</div>
			<c:if test="${sizeOfFavourites > 1}">			
				<div class="fav-item__edit-section fav-item__edit-section-seperator"></div>
				<div class="fav-item__edit-section fav-item__edit-section--bottom">
	     	
	            <div class="fav-item__edit-action fav-item-movetotop js-favEditAction" data-action="move" data-move-type="moveToTop" data-href="${changeOrderUrl}" data-id="${favouriteUid}">
					<span class="icon icon-remove fav-item__edit-icon"></span>
					<span class="fav-item__edit-text"><spring:theme code="popup.favourite.moveToTop" /></span>
				</div>
				<div class="fav-item__edit-action fav-item-moveup js-favEditAction" data-action="move" data-move-type="moveUp" data-href="${changeOrderUrl}" data-id="${favouriteUid}">
					<span class="icon icon-remove fav-item__edit-icon"></span>
					<span class="fav-item__edit-text"><spring:theme code="popup.favourite.moveUp" /></span>
				</div>
				<div class="fav-item__edit-action fav-item-movedown js-favEditAction" data-action="move" data-move-type="moveDown" data-href="${changeOrderUrl}" data-id="${favouriteUid}">
					<span class="icon icon-remove fav-item__edit-icon"></span>
					<span class="fav-item__edit-text"><spring:theme code="popup.favourite.moveDown" /></span>
				</div>
				<div class="fav-item__edit-action fav-item-movetobottom js-favEditAction" data-action="move" data-move-type="moveToBottom" data-href="${changeOrderUrl}" data-id="${favouriteUid}">

					<span class="icon icon-remove fav-item__edit-icon"></span>
					<span class="fav-item__edit-text"><spring:theme code="popup.favourite.moveToBottom" /></span>
				</div>
				</div>
			</c:if>
		</ycommerce:testId>
	</div>
</sec:authorize>

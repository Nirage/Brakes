<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ taglib prefix="commonProduct" tagdir="/WEB-INF/tags/responsive/common/product" %>

<%@ attribute name="title" required="false" type="java.lang.String" %>
<%@ attribute name="subTitle" required="false" type="java.lang.String" %>
<%@ attribute name="maxNumberOfProducts" required="false" type="java.lang.String" %>
<%@ attribute name="notPlp" required="false" type="java.lang.Boolean" %>

<div class="container">
	<div class="row">
		<div class="col-xs-12">
			<div
				id="vue-sf-product-list"
				class="vue-sf-product-list p1"
				data-max-Number-Of-Products="${maxNumberOfProducts}"
				data-not-plp="${notPlp}"
				data-message-update="<spring:theme code='product.variants.update'/>"
				data-message-out-of-stock="<spring:theme code='outOfStock.button.title'/>"
				data-message-discontinued="<spring:theme code='discontinued.button.title'/>"
				data-message-add="<spring:theme code='product.button.addToCart'/>"
			>
				<c:if test="${not empty title || not empty subTitle}">
					<div class="flex align-items-center flex-direction-column">
						<h2 class="site-header__text site-header__text--underline site-header__text--underline-middle">${title}</h2>
						<p class="site-header__subtext">${subTitle}</p>
					</div>
				</c:if>
				<div class="sf-product-list--count mt1">
					<c:forEach var="currentName" begin="1" end="6">
						<div class="col-xs-6 col-sm-3 col-md-2 hide">
							<commonProduct:loading extraClass="p0" />
						</div>
					</c:forEach>
				</div>
			</div>
		</div>
	</div>
</div>
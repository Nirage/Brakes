<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ taglib prefix="component" tagdir="/WEB-INF/tags/shared/component" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:choose>
	<c:when test="${not empty productData}">
	<div class="container">
	<div class="row">
	<div class="col-xs-12">
		<div class="carousel__component search-result">
			<h2 class="text-center site-header__text site-header__text--underline">${fn:escapeXml(title)}</h2>

			<c:choose>
				<c:when test="${component.popup}">
				<div id="quickViewTitle" class="quickView-header display-none">
						<div class="headline">
							<span class="headline-text"><spring:theme code="popup.quick.view.select"/></span>
						</div>
					</div>
					<div class="js-cartProductsCarousel owl-carousel products-carousel">
						
						<c:forEach items="${productData}" var="product">

							<c:url value="${product.url}/quickView" var="productQuickViewUrl"/>
							<div class="carousel__item">
								<a href="${productQuickViewUrl}" class="js-reference-item">
									<div class="carousel__item--thumb">
										<product:productPrimaryReferenceImage product="${product}" format="product"/>
									</div>
									<div class="carousel__item--name">${fn:escapeXml(product.name)}</div>
									<c:choose>
										<c:when test="${product.estimatedPrice != null}">
											<div class="carousel__item--price"><format:fromPrice priceData="${product.estimatedPrice}"/></div>
										</c:when>
										<c:otherwise>
											<div class="carousel__item--price"><format:fromPrice priceData="${product.price}"/></div>
										</c:otherwise>
									</c:choose>
								</a>
							</div>
						</c:forEach>
					</div>
				</c:when>
				<c:otherwise>
					<div class="carousel__component--carousel js-owl-carousel js-owl-default">
						<c:forEach items="${productData}" var="product">

							<c:url value="${product.url}" var="productUrl"/>

							<div class="carousel__item">
								<a href="${productUrl}">
									<div class="carousel__item--thumb">
										<product:productPrimaryImage product="${product}" format="product"/>
									</div>
									<div class="carousel__item--name">${fn:escapeXml(product.name)}</div>
									<c:choose>
										<c:when test="${product.estimatedPrice != null}">
											<div class="carousel__item--price"><format:fromPrice priceData="${product.estimatedPrice}"/></div>
										</c:when>
										<c:otherwise>
											<div class="carousel__item--price"><format:fromPrice priceData="${product.price}"/></div>
										</c:otherwise>
									</c:choose>
								</a>
							</div>
						</c:forEach>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
		</div>
		</div>
		</div>
	</c:when>

	<c:otherwise>
		<component:emptyComponent/>
	</c:otherwise>
</c:choose>


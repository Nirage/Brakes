<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ attribute name="category" required="true" type="java.lang.Object"%>
<%@ attribute name="customCSSClass" required="false" type="java.lang.String"%>
<%@ attribute name="categoryUrl" required="true" type="java.lang.String"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>

<c:set var="ampliencePath" value="https://i1.adis.ws/i/Brakes/" /> <%--TODO: move it to properties file --%>

<spring:url value="${categoryUrl}" var="popularCategoriesURL"/>

<a class="full-width" href="${popularCategoriesURL}">
  <div class="category-tile ${customCSSClass}">
    <c:set var="amplienceImage" value="${ampliencePath}category_${category.code}.jpg?" />
    <c:if test="${not empty category.code}">
      <picture class="product-item__picture flex justify-content-center">
        <source data-size="desktop" data-srcset="${amplienceImage}$plp-desktop$&fmt=webp" media="(min-width: 1240px)" type="image/webp">
        <source data-size="desktop" data-srcset="${amplienceImage}$plp-desktop$" media="(min-width: 1240px)" type="image/jpeg">
        <source data-size="tablet" data-srcset="${amplienceImage}$plp-desktop$&fmt=webp" media="(min-width: 768px)" type="image/webp">
        <source data-size="tablet" data-srcset="${amplienceImage}$plp-desktop$" media="(min-width: 768px)" type="image/jpeg">
        <source data-size="mobile" data-srcset="${amplienceImage}$plp-desktop$&fmt=webp" type="image/webp">
        <source data-size="mobile" data-srcset="${amplienceImage}$plp-desktop$" type="image/jpeg">
        <img data-sizes="auto" class="product-item__image product-image lazyload" data-src="${amplienceImage}$plp-desktop$" alt="${category.name}" title="${category.name}" width="213" height="142">
        <div class="loader__image"></div>
      </picture>
    </c:if>
    <div class="category-tile__name">${category.name}</div>
  </div>
</a>
<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="product" required="true" type="de.hybris.platform.commercefacades.product.data.ProductData" %>
<%@ attribute name="showText" required="false" type="java.lang.Boolean"%>
<%@ attribute name="styleClass" required="false" type="java.lang.String"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<spring:htmlEscape defaultHtmlEscape="true" />

<c:set var="product" value="${product}" scope="request"/>
<c:set var="showText" value="${showText}" scope="request"/>
<c:set var="styleClass" value="${styleClass}" scope="request"/>


        <cms:pageSlot position="AddToFavourites" var="addtofavourites">
            <cms:component component="${addtofavourites}" />
        </cms:pageSlot>



<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="order" required="true" type="com.envoydigital.brakes.facades.orderPosSel.data.OrderPOSandSELData" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="action" tagdir="/WEB-INF/tags/responsive/action" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement" %>


<spring:htmlEscape defaultHtmlEscape="false" />

<div class="hidden-xs">
    <div class="order-sel__title  h-space-3">
        <div class="row">
            <div class="col-xs-12">
                <div class="col-xs-4"><spring:theme code="orderSELsAndPOSSubmit.header.productcode" /></div>
                <div class="col-xs-2"><spring:theme code="orderSELsAndPOSSubmit.header.rrp" /></div>
                <div class="col-xs-2"><spring:theme code="orderSELsAndPOSSubmit.header.size" /></div>
            </div>
        </div>
    </div>
    <c:forEach items="${order.products}" var="product">
        <div class="order-sel____subHeading order-sel__bordered order-sel__para  h-space-3">
            <div class="row">
                <div class="col-xs-12">
                    <div class="col-xs-4 order-sel__sectionText">${product.code}</div>
                    <div class="col-xs-2 order-sel__sectionText">${product.singlePrice}</div>
                    <div class="col-xs-2 order-sel__sectionText"><spring:theme code="orderSELsAndPOS.option.${product.multiPrice}" /></div>
                </div>
            </div>
        </div>
    </c:forEach>
</div>
<%-- Please dont change anything in  this section Start--%>
<div class="visible-xs">
    <c:forEach items="${order.products}" var="product">
        <div class="order-sel____subHeading order-sel__bordered order-sel__para  h-space-3">
            <div class="row">
                <div class="col-xs-12">
                    <div class="clearfix">
                        <div class="col-xs-4 order-sel__title"><spring:theme code="orderSELsAndPOSSubmit.header.productcode" /></div>
                        <div class="col-xs-6 order-sel____subHeading ">${product.code}</div>
                    </div>
                    <div class="clearfix">
                        <div class="col-xs-4 order-sel__title"><spring:theme code="orderSELsAndPOSSubmit.header.rrp" /></div>
                        <div class="col-xs-6 order-sel____subHeading ">${product.singlePrice}</div>
                    </div>
                    <div class="clearfix">
                        <div class="col-xs-4 order-sel__title"><spring:theme code="orderSELsAndPOSSubmit.header.size" /></div>
                        <div class="col-xs-6 order-sel____subHeading "><spring:theme code="orderSELsAndPOS.option.${product.multiPrice}" /></div>
                    </div>
                </div>
            </div>
        </div>
    </c:forEach>
</div>
<%-- Please dont change anything in  this section End--%>
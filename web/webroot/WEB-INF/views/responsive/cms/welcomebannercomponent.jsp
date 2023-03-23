<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="action" tagdir="/WEB-INF/tags/responsive/action" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">

<div class="container">
    <div class="banner__component info-banner">   
        <div class="info-banner__background" <c:if test="${not empty component.media.url}">style="background-image: url(${fn:escapeXml(component.media.url)})"</c:if>></div>
        <div class="info-banner__content">
            <div class="info-banner__content-box">
                <div class="info-banner__main-heading"><spring:theme code="welcomeBanner.salutation" arguments="${user.firstName}" /></div>
                <div class="info-banner__unit-name" title="${user.unit.name}">${user.unit.name}</div>
                <div class="info-banner__uid">${user.unit.uid}</div>
                <c:if test="${empty punchoutUser}">
                    <a href="/my-account/orders" class="btn btn-primary info-banner__btn"><spring:theme code="welcomeBanner.ordersBtn" /></a>
                </c:if>
            </div>
        </div>
    </div>
</div>
</sec:authorize>
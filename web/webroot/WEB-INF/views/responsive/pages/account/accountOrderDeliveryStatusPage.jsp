
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="order" tagdir="/WEB-INF/tags/responsive/order" %>

<template:page pageTitle="${pageTitle}">
    <div class="container order-delivery-status">
        <div class="row">
            <div class="col-md-12">
                <%-- Page header --%>
                <div class="site__header site-header--align-left">
                    <spring:theme code="order.deliverystatus.header"/>
                    <span class="site__header--rectangle site-header__rectangle--align-left"></span>
                </div>
                    <c:choose>
                        <c:when test="${orderDeliveryStatusData.keytreeResult eq 'SUCCESS'}">
                            <order:accountOrderDeliveryStatusTable/>
                        </c:when>
                        <c:otherwise>
                            <div class="order-delivery-status__phonehint">
                                <h4><spring:theme code="order.deliverystatus.error"/></h4>
                            </div>
                        </c:otherwise>
                    </c:choose>

            </div>
        </div>
    </div>
</template:page>
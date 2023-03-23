<%@ attribute name="classification" required="true" type="java.lang.Object" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>


<c:set var="handlingInstructions" value="false"/>
<c:set var="foodSafety" value=""/>
<c:set var="thawingGuidelines" value=""/>
<c:forEach items="${classification.features}" var="feature">
    <c:choose>

        <c:when test="${fn:contains(feature.code, 'food_safety') && feature.shownInPDPAccordion}">
            <c:set var="handlingInstructions" value="true"/>
            <c:forEach items="${feature.featureValues}" var="value" varStatus="status">
                <c:set var="foodSafety" value="${value.value}"/>
            </c:forEach>
        </c:when>

        <c:when test="${fn:contains(feature.code,'thawing_guidelines') && feature.shownInPDPAccordion}">
            <c:forEach items="${feature.featureValues}" var="value" varStatus="status">
                <c:set var="thawingGuidelines" value="${value.value}"/>
            </c:forEach>
            <c:set var="handlingInstructions" value="true"/>
        </c:when>

    </c:choose>

</c:forEach>

<c:if test="${not empty thawingGuidelines}">
    <h5 class="accordion__section-heading"><spring:theme code="productDetails.handlingInstructions.heading"/></h5>
    ${thawingGuidelines}
</c:if>
<c:if test="${not empty foodSafety }">
    <h5 class="accordion__section-heading"><spring:theme code="productDetails.foodSafty.heading"/></h5>
    ${foodSafety}
</c:if>

<c:if test="${product.hasPDPCookingInstructions}">
    <h5 class="accordion__section-heading"><spring:theme code="productDetails.cookingInstructions.heading"/></h5>
    <c:forEach items="${classification.features}" var="feature">

        <c:choose>

            <c:when test="${fn:contains(feature.code, 'food_safety')}">
            </c:when>
            <c:when test="${fn:contains(feature.code,'thawing_guidelines')}">
            </c:when>
            <c:otherwise>
                <c:if test="${fn:contains(feature.code, 'instructions')}">
                    <c:if test="${fn:contains(feature.code, 'oven')}">
                        <c:set var="instructionsIcon" value="icon-oven"/>
                        <c:set var="instruction" value="oven"/>
                    </c:if>
                    <c:if test="${fn:contains(feature.code, 'microwave')}">
                        <c:set var="instructionsIcon" value="icon-microwave"/>
                        <c:set var="instruction" value="microwave"/>

                    </c:if>
                    <c:if test="${fn:contains(feature.code, 'griddle')}">
                        <c:set var="instructionsIcon" value="icon-oven"/>
                        <c:set var="instruction" value="oven"/>
                    </c:if>
                    <c:if test="${fn:contains(feature.code, 'grill')}">
                        <c:set var="instructionsIcon" value="icon-grill"/>
                        <c:set var="instruction" value="grill"/>
                    </c:if>
                    <c:if test="${fn:contains(feature.code, 'steam')}">
                        <c:set var="instructionsIcon" value="icon-steam"/>
                        <c:set var="instruction" value="steam"/>
                    </c:if>
                    <c:if test="${fn:contains(feature.code, 'time') || fn:contains(feature.code, 'pan_fry')}">
                        <c:set var="instructionsIcon" value="icon-fry-pan"/>
                        <c:set var="instruction" value="panFry"/>
                    </c:if>
                    <c:if test="${fn:contains(feature.code, 'deep')}">
                        <c:set var="instructionsIcon" value="icon-deep-fry"/>
                        <c:set var="instruction" value="deepfry"/>
                    </c:if>
                    <c:if test="${feature.shownInPDPAccordion}">
                        <div class="accordion__guidelines-header guidelines-header">
                            <span class="guidelines-header__icon icon ${instructionsIcon}" title="<spring:theme code="icon.title.${instruction}"/>"></span>
                            <span class="guidelines-header__icon-desc">${feature.name}</span>
                        </div>
                        <c:forEach items="${feature.featureValues}" var="value" varStatus="status">
                            <div class="accordion__guidelines-content guidelines-content">
                            ${value.value}
                            </div>
                        </c:forEach>
                    </c:if>
                </c:if>
            </c:otherwise>
        </c:choose>


    </c:forEach>


    <p><spring:theme code="productDetails.cookingInstructions.footer"/></p>
</c:if>


<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:url value="${fn:escapeXml(urlLink)}" var="encodedUrl" />

<div class="banner__component">
    <div style="background-color: #9FBFD2">
        <p>${content}</p>
    </div>
    <c:choose>
        <c:when test="${empty encodedUrl || encodedUrl eq '#'}">
            <c:if test="${not empty media.url}">
                <img title="${fn:escapeXml(media.altText)}" alt="${fn:escapeXml(media.altText)}"
                    src="${media.url}">
            </c:if>
        </c:when>
        <c:otherwise>
            <a href="${encodedUrl}"><img title="${fn:escapeXml(media.altText)}"
                                         alt="${fn:escapeXml(media.altText)}" src="${media.url}"></a>
        </c:otherwise>
    </c:choose>
</div>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:url value="${urlLink}" var="simpleBannerUrl" />

<div class="banner__component simple-banner">
	<c:choose>
		<c:when test="${empty simpleBannerUrl || simpleBannerUrl eq '#'}">
			<c:if test="${not empty media.url}">
				<img title="${fn:escapeXml(media.altText)}" alt="${fn:escapeXml(media.altText)}"
					src="${fn:escapeXml(media.url)}">
			</c:if>
		</c:when>
		<c:otherwise>
			<a tabindex="0" href="${fn:escapeXml(simpleBannerUrl)}" <c:if test="${component.external}">target="_blank"</c:if>><img title="${fn:escapeXml(media.altText)}"
				alt="${fn:escapeXml(media.altText)}" src="${fn:escapeXml(media.url)}"></a>
		</c:otherwise>
	</c:choose>
</div>
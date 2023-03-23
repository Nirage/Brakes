<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="cms" tagdir="/WEB-INF/tags/responsive/template/cms" %>

<c:if test="${cmsPage.uid eq 'productDetails'}">
	<link rel="stylesheet" type="text/css" media="all" href="/_ui/responsive/common/css/viewer.min.css?${releaseVersion}" />
</c:if>

<%-- Theme dependent style file --%>
<link rel="stylesheet" type="text/css" media="all" href="${themeResourcePath}/css/style.bundle.css?${releaseVersion}"/>

<%-- AddOn Theme CSS files - NEED Roberto to check --%>
<c:forEach items="${addOnThemeCssPaths}" var="addOnThemeCss">
	<link rel="stylesheet" type="text/css" media="all" href="${addOnThemeCss}?${releaseVersion}" />
</c:forEach>

<%-- PreviewCSS - NEED Roberto to check --%>
<cms:previewCSS cmsPageRequestContextData="${cmsPageRequestContextData}" />

<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="analytics" tagdir="/WEB-INF/tags/shared/analytics" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ attribute name="googleGTMId" required="true" %>

<script type="text/javascript" src="${fn:escapeXml(sharedResourcePath)}/js/analyticsmediator.js?${releaseVersion}"></script>
<analytics:gtm googleGTMId="${googleGTMId}"/>


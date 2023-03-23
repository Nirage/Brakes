<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="delivery" tagdir="/WEB-INF/tags/responsive/delivery" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<footer>
    <div class="container-fluid">
        <cms:pageSlot position="Footer" var="feature">
            <cms:component component="${feature}"/>
        </cms:pageSlot>
    </div>
</footer>
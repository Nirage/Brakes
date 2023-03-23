<%@ page session="false" trimDirectiveWhitespaces="true" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<div class="v-accordion__title">${component.header}</div>
<div class="col-md-7 p0">
    <p class="h-space-3 font-size-1">${component.paragraphText}</p>
    <a class="btn btn-primary btn--full-width" href="${component.primaryCTALink}" target="_blank">${component.primaryCTA}</a>
</div>

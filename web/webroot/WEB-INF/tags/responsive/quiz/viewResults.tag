<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<spring:htmlEscape defaultHtmlEscape="false" />


<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')" >

	<form:form method="get" action="${contextPath}/my-country-choice/training-modules-results">
		<button type="submit" class="btn btn-secondary btn--margin-top-20 btn--auto-width-desktop js-viewResults ">
			<div class="btn__text-wrapper">
				<span class="btn__text "><spring:theme code="trainingModules.viewResults" /></span>
			</div>
		</button>
	</form:form>

</sec:authorize>



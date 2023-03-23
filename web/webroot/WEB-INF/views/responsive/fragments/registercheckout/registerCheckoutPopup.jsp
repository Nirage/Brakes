<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="popup" tagdir="/WEB-INF/tags/responsive/b2c/popup"%>

<%-- URL varaibles --%>
<spring:url value="/sign-in/register/termsandconditions" var="getTermsAndConditionsUrl"/>
<spring:url value="/policies/privacy-policy" var="getPrivacyPolicyUrl"/>
<spring:url value="/addguestinfo" var="addGuestInfo"/>


<c:choose>
	<c:when test="${showpopup eq false}">
		Do not show the pop up.
	</c:when>
	<c:otherwise>
		<%-- Overlay wrapper --%>
		<div class="b2c-popup__overlay js-popUpOverlay">
			<%-- Overlay inner --%>
			<div id="b2c__root" class="b2c-popup js-b2cRoot">
				<%-- Live postcode search | Begin --%>
				<popup:livePostCodeSearch/>
				<%-- Live postcode search | End --%>
				
				<%-- Sign up | Begin --%>
				<popup:signUp/>
				<%-- Sign up | End --%>

				<%-- Sign up | Begin --%>
				<popup:signUpSuccess/>
				<%-- Sign up | End --%>

				<%-- Log in | Begin --%>
				<popup:logIn/>
				<%-- Log in | End --%>

				<%-- Forgotten password form | Begin --%>
				<popup:forgottenPasswordForm/>
				<%-- Forgotten password form | End --%>

				<%-- Forgotten password message | Begin --%>
				<popup:forgottenPasswordMessage/>
				<%-- Forgotten password message | End --%>

				<%-- Reset password | Begin --%>
				<popup:resetPassword/>
				<%-- Reset password | End --%>
			</div>
		</div> 
	</c:otherwise>
</c:choose>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement"
	tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">

<div class="account-dropdown account-dropdown--user-details">
	<%-- Account dropdown tab + label --%>
	<div tabindex="0" class="account-dropdown__trigger account-dropdown__trigger--user-details js-accountDropdown" data-id="user-details"> 
		<span class="icon icon-user-login"></span> 
		<ycommerce:testId code="header_LoggedUser">
			<span class="account-dropdown__user-name">
				<spring:theme code="b2c.myaccount.dropdown.label" />
			</span>
		</ycommerce:testId>
	</div>

	<div class="account-dropdown__content account-dropdown__content--accountRight hide js-accountDropdownContent text-left" data-id="user-details">
		<%-- Welcome message--%>
		<div class="account-dropdown__section account-dropdown__section--no-border-top">
			<h2 class="account-dropdown__salutation">${user.uid}</h2>
		</div>
		<%-- Contact customer service --%>
		<div class="account-dropdown__section">
			<spring:theme code="b2c.myaccount.dropdown.customer.service.text" />
		</div>
		<%-- Sign out button --%>
		<ycommerce:testId code="header_signOut">	
			<c:url value="/logout" var="logoutUrl"/>
			<div class="account-dropdown__section">
				<a href="${fn:escapeXml(logoutUrl)}" class="account-action">
					<span class="icon icon-logout account-action__icon"></span>	
					<span class="account-action__text">
						<spring:theme code="header.link.logout" />
					</span>
				</a>
			</div>
		</ycommerce:testId>
	</div><%--account-dropdown__content--%>
</div>

</sec:authorize>

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

<c:if test="${!empty punchoutUser}"> <%--  TBC: we might replace this with the related Restriction commented in BRAKESP2-2206-punchout-missing-header-x.impex  --%>
	<div class="navigation navigation--top navigation--punchout">
		<div class="container-xl">
			<div class="row flex align-items-center">
				<div class="col-xs-12">
					<div class="navigation--punchout__text">
						<c:if test="${empty hideHeaderLinks}">
							<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">
								<ycommerce:testId code="header_LoggedUser">
									<spring:theme code="header.welcome" arguments="${user.firstName}"/>
								</ycommerce:testId>
							</sec:authorize>
						</c:if>
					</div>
				</div>
			</div>
		</div>
	</div>
</c:if>
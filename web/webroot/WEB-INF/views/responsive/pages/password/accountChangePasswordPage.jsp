<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:url value="/create-password" var="action"/>
<c:if test="${!isb2cSite}">
	<div class="row">
			<div class="col-md-6 col-sm-8 col-sm-offset-2 col-md-offset-3">
					<div class="login">
							<div class="login__wrapper">
					 <div class="row">
						<div class="col-xs-12 col-md-12">			
							<div class="site__header">
							<spring:theme code="text.pasword.updatePasswordForm"/>
							<span class="site__header--rectangle"></span>
							</div>
						</div>		
						<div class="col-xs-12 col-md-12 password-criteria-text">
							<p><spring:theme code="reset.pwd.criteria.heading"/></p>
							<ul>
							 <li><spring:theme code="reset.pwd.criteria.one" /></li>
							 <li>
								<spring:theme code="reset.pwd.criteria.two" />
							 </li>
							 <li>
								<spring:theme code="reset.pwd.criteria.three" />
							 </li>
							 <li>
								<spring:theme code="reset.pwd.criteria.four" />
							 </li>
							</ul>						
						</div>
						<div class="col-xs-12 col-md-12">						
							<form:form action="${action}" method="post" modelAttribute="brakesUpdatePwdForm">
							
									<form:hidden path="token"/>				
								<formElement:formPasswordBox 
									 idKey="pwd"
									 labelKey="profile.newPassword" 
									 path="pwd" 
									 inputCSS="form-control site__form--input"
									 labelCSS="site__form--label"
									 mandatory="true" />
															 <p>
										 <spring:theme code="reset.pwd.help.txt" />
												 </p>
								<div class="row">
									<div class="col-sm-12">
										<div class="accountActions">
											<button type="submit" class="btn btn-primary btn--full-width">
												<spring:theme code="password.reset.submit.txt" text="Set password" />
											</button>
										</div>
									</div>
								</div>
							</form:form>
						</div>
						</div>	
						</div>
			</div>
		 </div>
	</div>	
</c:if>

<c:if test="${isb2cSite}">
	<div class="row js-b2cPopUpWhitelistedPage">
		<div class="col-sm-offset-2 col-sm-4">
			<div class="login__wrapper">
				<div class="row">
					<div class="col-xs-12 col-md-12">			
						<div class="site__header site__header--textleft">
						<spring:theme code="b2c.text.pasword.updatePasswordForm"/>
						<span class="site__header--rectangle site__header--rectangle--iconleft"></span>
						</div>
					</div>		
					<div class="col-xs-12 col-md-12 password-criteria-text">
						<p><spring:theme code="reset.pwd.criteria.heading"/></p>
						<ul>
							<li><spring:theme code="reset.pwd.criteria.one" /></li>
							<li>
							<spring:theme code="reset.pwd.criteria.two" />
							</li>
							<li>
							<spring:theme code="reset.pwd.criteria.three" />
							</li>
							<li>
							<spring:theme code="reset.pwd.criteria.four" />
							</li>
						</ul>						
					</div>
					<div class="col-xs-12 col-md-12">						
						<form:form action="${action}" method="post" modelAttribute="brakesUpdatePwdForm">
						
								<form:hidden path="token"/>				
							<formElement:formPasswordBox 
									idKey="pwd"
									labelKey="profile.newPassword" 
									path="pwd" 
									inputCSS="form-control site__form--input js-b2cPopUpWhitelistedCTA"
									labelCSS="site__form--label"
									mandatory="true" />
															<p>
										<spring:theme code="reset.pwd.help.txt" />
												</p>
							<div class="row">
								<div class="col-sm-12">
									<div class="accountActions">
										<button type="submit" class="btn btn-primary btn--full-width js-b2cPopUpWhitelistedCTA">
											<spring:theme code="password.reset.submit.txt" text="Set password" />
										</button>
									</div>
								</div>
							</div>
						</form:form>
					</div>
				</div>	
			</div>
		</div>
	</div>	
</c:if>
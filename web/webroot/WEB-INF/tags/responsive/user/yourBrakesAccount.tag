<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="user" tagdir="/WEB-INF/tags/responsive/user"%>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>				
<%@ attribute name="isActive" required="false" type="java.lang.Boolean" %>      
<%@ attribute name="sectionName" required="false" type="java.lang.String"%>
<%@ attribute name="nextSectionName" required="false" type="java.lang.String"%>


<%-- hasAccountsList is used in acc.validation.js --%>
<script>
	var hasAccountsList = true;
</script>

<%-- TODO: BED to make 5 configuralble --%>
<input id="jsMaxAccountsAllowed" type="hidden" value="5" /> 
<input id="accountNumbers" class="js-accountNumbers" type="hidden" value="" name="accountNumbers" />


<div class="site-form__section js-formSection ${isActive ? 'is-active' : 'pristine'}" data-section="${sectionName}">
	<div class="site-form__section-header js-formHeader">
		<spring:theme code="register.link.section2.title" />
		<span class="icon icon-amend"></span>
	</div>
	<div class="site-form__section-content">
		<div class="row">
			<div class="col-xs-12 col-sm-6">
				<div class="row">
					<div class="col-xs-12">
							<div class="custom-txtbox">
								<div class="site-form__formgroup form-group js-formGroup">
									<label class="control-label site-form__label " for="register.accountNumber" data-error-empty="<spring:theme code="error.empty.accountNumber" />" data-error-invalid="<spring:theme code="error.invalid.accountNumber" />">
										<spring:theme code="register.accountNumber" />
									</label>
									<div class="site-form__inputgroup js-inputgroup ">
										<input id="register.accountNumber" name="accountNumber" class="form-control site-form__input js-formField js-accountNumber is-required" data-validation-type="accountnumber" placeholder="<spring:theme code="placeholder.text.accountNumber" />" value=""><span class="icon icon-error site-form__errorsideicon  js-error-icon"></span>
										<span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
									</div>
								<span class="icon icon-caret-up error-msg js-errorMsg hide site-form__errormessage"></span>			
								</div>
							</div>
						<c:forEach items="${accountNumbers}" var="account" varStatus="counter">
							<div class="custom-txtbox">
								<div class="site-form__formgroup form-group js-formGroup">
									<label class="control-label site-form__label " for="register.accountNumber${counter}" data-error-empty="<spring:theme code="error.empty.accountNumber" />" data-error-invalid="<spring:theme code="error.invalid.accountNumber" />">
									</label>
									<div class="site-form__inputgroup js-inputgroup ">
										<input id="register.accountNumber${counter}" name="accountNumber${counter}" class="form-control site-form__input js-formField js-accountNumber" data-validation-type="accountnumber" placeholder="<spring:theme code="placeholder.text.accountNumber" />" value=""><span class="icon icon-error site-form__errorsideicon  js-error-icon"></span>
										<span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
									</div>
								<span class="icon icon-caret-up error-msg js-errorMsg hide site-form__errormessage"></span>			
								</div>
							</div>
						</c:forEach>

						<%-- <formElement:formInputBox 
							idKey="register.accountNumber"
							labelKey="register.accountNumber" 
							path="accountNumber" 
							errorKey="accountNumber"
							inputCSS="form-control site-form__input js-formField"
							labelCSS="site-form__label"
							mandatory="true" 
							showAsterisk="true"
							validationType="any"
							placeholderKey="accountNumber"
							/> --%>

						<div id="jsAccountsList"></div>	
						<button type="button" class="btn btn-secondary btn--margin-top-20 btn--auto-width-desktop js-addAnotherAccount ">
							<div class="btn__text-wrapper">
								<span class="icon icon-plus btn__icon"></span>
								<span class="btn__text "><spring:theme code="register.addAccountNumber"/></span>
							</div>
						 </button>
					</div>
				</div>
			</div>
			<div class="col-xs-12 col-sm-6 col-md-5 col-md-offset-1">
				<div class="row">
					<div class="col-xs-12 col-sm-12 col-md-7">
					  <formElement:formInputBox 
					   idKey="register.tradingName"
					   labelKey="register.tradingName" 
					   errorKey="tradingName"
					   path="tradingName" 
					   inputCSS="form-control site-form__input js-formField"
					   labelCSS="site-form__label"
					   mandatory="true"
					   showAsterisk="true"
					   validationType="name" 
						 placeholderKey="tradingName"
						 tooltipKey="tradingName"
						 tooltipType="collapsable" />
					</div>
					<div class="col-xs-12 col-sm-7 col-md-5">
					  <formElement:formInputBox 
              idKey="register.addressPostcode"
              labelKey="register.addressPostcode" 
              path="postCode" 
              errorKey="addressPostcode"
              inputCSS="form-control site-form__input js-formField"
              labelCSS="site-form__label"
              mandatory="true" 
              showAsterisk="true" />
					</div>
				</div>
			</div>
			</div>
				<user:brakesAccounttermsAndConditions  />
	</div><%-- site-form__section-content:  --%>
</div><%-- site-form__section --%>



<script id="another-account-template" type="text/x-handlebars-template">
  <div class="custom-txtbox">
    <div class="site-form__formgroup form-group js-formGroup">
			<label class="control-label site-form__label " for="register.accountNumber{{counter}}" data-error-empty="<spring:theme code="error.empty.accountNumber" />" data-error-invalid="<spring:theme code="error.invalid.accountNumber" />"></label>
			<div class="site-form__inputgroup js-inputgroup ">
				<input id="register.accountNumber{{counter}}" name="accountNumber{{counter}}" class="form-control site-form__input js-formField js-accountNumber" data-validation-type="accountnumber" placeholder="<spring:theme code="placeholder.text.accountNumber" />" value=""><span class="icon icon-error site-form__errorsideicon  js-error-icon"></span>
				<span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
			</div>
		<span class="icon icon-caret-up error-msg js-errorMsg hide site-form__errormessage"></span>			
	  </div>
  </div>
</script>
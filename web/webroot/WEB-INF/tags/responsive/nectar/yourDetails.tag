<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement"
	tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>				
<%@ attribute name="isActive" required="false" type="java.lang.Boolean" %>      
<%@ attribute name="sectionName" required="false" type="java.lang.String"%>
<%@ attribute name="nextSectionName" required="false" type="java.lang.String"%>
<%@ taglib prefix="user" tagdir="/WEB-INF/tags/responsive/user"%>

<div class="site-form__section js-formSection is-active h-topspace-5" data-section="${sectionName}">
	<div class="site-form__section-header js-formHeader">
		<spring:theme code="text.nectarpoints.collect.page.section4.title" />
		<span class="icon icon-amend"></span>
	</div>
	<div class="site-form__section-content">
		<div class="row">
				<div class="col-xs-12 col-md-4">					
					<div class="site-form__title">
						<formElement:formSelectBox 
							idKey="register.title"
							labelKey="register.title"
							selectCSSClass="form-control site-form__select js-formSelect js-formField js-title"
							path="title"
							errorKey="title"
							mandatory="true"
							showAsterisk="true"
							skipBlank="false"
							skipBlankMessageKey="form.select.title.defaultValue"
							items="${titles}"
							labelCSS="site-form__label"
							validationType="select"
							selectedValue="${collectNectarForm.title}" />
					</div>
				</div>
				<div class="col-xs-12 col-sm-6 col-md-4">
					<formElement:formInputBox 
						idKey="register.firstName"
						labelKey="register.firstName" 
						path="firstName" 
						errorKey="firstName"
						inputCSS="form-control site-form__input js-formField js-firstName"
						labelCSS="site-form__label"
						mandatory="true"
						showAsterisk="true"
						validationType="name" />
				</div>
				<div class="col-xs-12 col-sm-6 col-md-4">
					<formElement:formInputBox 
						idKey="register.lastName"
						labelKey="register.lastName" 
						errorKey="lastName"
						path="lastName" 
						inputCSS="form-control site-form__input js-formField js-lastName"
						labelCSS="site-form__label"
						mandatory="true"
						showAsterisk="true"
						validationType="name" />
				</div>
		</div>	
			<div class="row">
            			<div class="col-xs-12 col-md-4">
            			 <span class="site-form__label">
                         					<spring:theme code="text.nectarpoints.collect.page.relationship.label" /></span>
            			 <formElement:formRadioButton
                                     idKey="nectarCollect.legalOwner"
                                     labelKey="nectarCollect.legalOwner"
                                     path="relationType"
                                     inputCSS="js-radioButtonGroup"
																		 iconCSS="site-form__icon__inline"
                                     labelCSS=""
                                     mandatory="true"
                                     value="LEGAL_OWNER"
                                     tooltipKey="nectarCollect.legalOwner"
                                     tooltipType="collapsable"
                                     />

            			</div>
            </div>
            <div class="row">
                        <div class="col-xs-12 col-md-4">
                         <formElement:formRadioButton
                                     idKey="nectarCollect.authorizedSignatory"
                                     labelKey="nectarCollect.authorizedSignatory"
                                     path="relationType"
                                     inputCSS="js-radioButtonGroup"
																		 iconCSS="site-form__icon__inline"
                                     labelCSS=""
                                     mandatory="true"
                                     value="AUTHORISED_SIGNATORY"
                                     tooltipKey="nectarCollect.authorizedSignatory"
                                     tooltipType="collapsable"
                                     />

                        </div>
            </div>
						
            <div class="row">
                    <div class="col-xs-12 col-md-4">
                     <formElement:formRadioButton
                                 idKey="nectarCollect.employee"
                                 labelKey="nectarCollect.employee"
                                 path="relationType"
                                 inputCSS="js-radioButtonGroup"
																 iconCSS="site-form__icon__inline"
                                 labelCSS=""
                                 mandatory="true"
                                 value="EMPLOYEE"
                                 />

                    </div>
            </div>
						<div class="js-legal-owner-error hide">
							<span class="icon icon-caret-up error-msg js-errorMsg site-form__errormessage">                  <spring:theme code="nectarpoints.empty.radio.button" /></span>
						</div>

            <div class="row">
									<div class="js-owner-info">

            			<div class="col-xs-12 col-md-4">
            				<div class="site-form__title">
            					<formElement:formSelectBox
            						idKey="collectNectar.owners.title"
            						labelKey="collectNectar.owners.title"
            						selectCSSClass="form-control site-form__select js-formSelect js-formField js-owners-title js-owner"
            						path="ownersTitle"
            						errorKey="ownersTitle"
            						mandatory="false"
            						showAsterisk="true"
            						skipBlank="false"
            						skipBlankMessageKey="form.select.title.defaultValue"
            						items="${titles}"
            						labelCSS="site-form__label"
            						validationType="select"
            						selectedValue="${collectNectarForm.ownersTitle}"
												disabled="disabled" />
            			  </div>
            			</div>
            			<div class="col-xs-12 col-sm-6 col-md-4">
            				<formElement:formInputBox
            					idKey="collectNectar.owners.firstName"
            					labelKey="collectNectar.owners.firstName"
            					path="ownersFirstName"
            					errorKey="ownersFirstName"
            					inputCSS="form-control site-form__input js-formField js-owners-firstName js-owner"
            					labelCSS="site-form__label"
            					mandatory="false"
            					showAsterisk="true"
            					validationType="name"
											disabled="disabled" />
            			</div>
            			<div class="col-xs-12 col-sm-6 col-md-4">
            				<formElement:formInputBox
            					idKey="collectNectar.owners.lastName"
            					labelKey="collectNectar.owners.lastName"
            					errorKey="ownersLastName"
            					path="ownersLastName"
            					inputCSS="form-control site-form__input js-formField js-owners-lastName js-owner"
            					labelCSS="site-form__label"
            					mandatory="false"
            					showAsterisk="true"
            					validationType="name"
											disabled="disabled" />
            			</div>
						</div>
						</div>
						<div class="row js-legal-owner-disclaimer hide h-topspace-2">
							<p class="col-xs-12 nectarBanner__subText m-0">
									<spring:theme code="collectNectar.owners.disclaimer" />
							</p>
						</div>
            <div class="row">
						<div class="nectarBanner__topBorder h-topspace-4">
                    <div class="col-xs-12 col-md-9">
                        <formElement:formCheckbox
                                    			idKey="nectarCollect.relationShipCheckLabel"
                                    			labelKey="nectarCollect.relationShipCheck"
                                    			path="relationShipCheck"
                                    			mandatory="true"
                                    			inputCSS="js-formField "
                                    			validationType="checkbox"
                                    			errorKey="relationShipCheck" />
                                    		</div>
                    </div>
            </div>
            <div class="row">
                   <div class="col-xs-12 col-md-9">
                       <formElement:formCheckbox
                                   idKey="nectarCollect.termsCheckLabel"
                                   labelKey="nectarCollect.termsCheck"
                                   path="termsCheck"
                                   mandatory="true"
                                   inputCSS="js-formField"
                                   validationType="checkbox"
                                   errorKey="termsAndConditions"
                                   />

                   </div>
            </div>
						</div>
		</div>
		<!-- user:termsAndConditions/-->

            <div class="site-form__actions form-actions clearfix">
              <ycommerce:testId code="register_Register_button">
                <button type="submit" class="btn btn-primary btn-block js-submitBtn js-nectar-points-submit h-space-3">
                  <spring:theme code="registration.submit" />
                </button>
              </ycommerce:testId>
            </div>
	</div><%-- site-form__section-content: about you --%>
</div><%-- site-form__section --%>

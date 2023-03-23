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
<%@ taglib prefix="common" tagdir="/WEB-INF/tags/responsive/common/"%>


<c:set var="isRequired" value="is-required"/>


<div class="site-form__section js-formSection ${isActive ? 'is-active' : 'pristine'}" data-section="business-details">
  <div class="site-form__section-header js-formHeader">
   	<spring:theme code="text.nectarpoints.collect.page.section1.title" />
    <span class="icon icon-amend"></span>
  </div>
  <div class="site-form__section-content">       
    <div class="row">
      <div class="col-xs-12 col-sm-12">
        <div class="row">
          <div class="col-xs-12 col-md-1 col-sm-2 h-topspace-6">
              <b><spring:theme code="collectNectar.nectarCardNoPrefix" /></b>
          </div>
          <div class="col-xs-12 col-sm-4 col-md-5">
            <input class="js-nectar-card-exists-error" type="hidden" value="<spring:theme code='error.duplicate.nectarCardNo' />" />
            <input class="js-nectar-card-status-error" type="hidden" value="<spring:theme code='error.status.nectarCardNo' />" />
            <formElement:formInputBox
              idKey="collectNectar.nectarCardNo"
              labelKey="collectNectar.nectarCardNo"
              path="nectarCardNo"
              errorKey="nectarCardNumber"
              inputCSS="form-control site-form__input js-formField"
              labelCSS="site-form__label"
              mandatory="true" 
              showAsterisk="true"
              validationType="nectarcardnumber"
              htmlType="number"
              maxlength="11"
            />
          </div>
          <div class="col-xs-12 col-sm-6">
            <formElement:formInputBox
              idKey="collectNectar.businessName"
              labelKey="collectNectar.businessName"
              path="businessName"
              errorKey="businessName"
              inputCSS="form-control site-form__input js-formField"
              labelCSS="site-form__label"
              mandatory="true"
              showAsterisk="true"
              validationType="name"
            />
          </div>
        </div>
       <div class="row">
           <div class="col-xs-12 col-sm-6 col-md-6">
            <div class="site-form__formgroup form-group js-formGroup">
              <div class="col-xs-12 p-0">
                <div class="col-xs-6 col-sm-4 cart-nectarBanner__noPad--md">
                   <label class="site-form__label" for="collectNectar.postCode" data-error-empty="Please provide your postcode" data-error-invalid="Please provide your postcode" data-error-force="Please click the button to find your address">
                  <spring:theme code="salesRep.postcode.label"></spring:theme></label>
                </div>  
              </div>  
              <div class="col-xs-12 col-sm-6 col-md-7 cart-nectarBanner__noPad--md">
                <div class="site-form__inputgroup js-inputgroup">
                  <input id="collectNectar.postCode" name="deliveryPostCode" class="form-control site-form__input js-formField is-required js-postcodeInput force-lookup" value="" autocomplete="noautocomplete" data-validation-type="postcode"/>
                  <span class="icon icon-error site-form__errorsideicon  js-error-icon"></span>
                  <span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
                </div>
                <span class="icon icon-caret-up error-msg js-errorMsg site-form__errormessage hide"></span>         
              </div>
              <div class="col-xs-12 col-sm-6 col-md-5 ">
               <button tabindex="0" type="button" class="btn btn-secondary btn-block js-findPostcode isPristine">
                  <spring:theme code="registration.address.findAddress" />
                </button>
                  <div class="site-form__trigger text-left js-enterAddressManually h-topspace-2 hide">
                    <spring:theme code="registration.address.enterManually" />
                  </div>
              </div>
            </div>  
          </div>
          <div class="col-xs-12 col-sm-6">
            <div id="jsSelectAddress">
            </div>
          </div>
        </div>    
    
        <div class="js-addressFields hide ">
          <div class="row">
            <div class="col-xs-12 col-sm-6">
              <formElement:formInputBox
                idKey="collectNectar.addressLine1"
                labelKey="collectNectar.address"
                path="addressLine1"
                errorKey="addressLine1"
                inputCSS="form-control site-form__input js-formField"
                labelCSS="site-form__label"
                mandatory="true"
                validationType="address"
                placeholderKey="addressLine1"
              />
            </div>
            <div class="col-xs-12 col-sm-6">
              <formElement:formInputBox
                idKey="collectNectar.addressLine2"
                labelKey="collectNectar.address"
                path="addressLine2"
                errorKey="addressLine2"
                inputCSS="form-control site-form__input js-formField"
                labelCSS="site-form__label"
                showAsterisk="false"
                validationType="address"
                placeholderKey="addressLine2"
                hideLabel="true"
              />
            </div>
          </div>
          <div class="row">
            <div class="col-xs-12 col-sm-6">
              <formElement:formInputBox
                idKey="collectNectar.town"
                labelKey="collectNectar.address"
                path="town"
                errorKey="town"
                inputCSS="form-control site-form__input js-formField"
                labelCSS="site-form__label site-form__label__top-space"
                mandatory="true"
                showAsterisk="true"
                validationType="any"
                placeholderKey="town"
                hideLabel="true"
              />
            </div>
            <div class="col-xs-12 col-sm-6">
              <formElement:formInputBox
                idKey="collectNectar.county"
                labelKey="collectNectar.address"
                path="county"
                errorKey="county"
                inputCSS="form-control site-form__input js-formField"
                labelCSS="site-form__label site-form__label__top-space"
                showAsterisk="true"
                mandatory="true"
                validationType="any"
                placeholderKey="county"
                hideLabel="true"
              />
           
            </div>
           </div>  
           <div class="row">
            <div class="col-xs-12 col-sm-6">
                          <formElement:formInputBox
                            idKey="collectNectar.deliveryPostCode"
                            labelKey="collectNectar.address"
                            path="postCode"
                            errorKey="postCode"
                            inputCSS="form-control site-form__input js-formField"
                            labelCSS="site-form__label site-form__label__top-space"
                            showAsterisk="true"
                            mandatory="true"
                            validationType="any"
                            placeholderKey="postCode"
                            hideLabel="true"
                          />
          </div>
           </div>
    </div>
  </div>
   <button type="button" class="btn btn-primary visible-xs btn-block btn--full-width js-formNextBtn site-form__next-btn" data-parent="${sectionName}" data-goto="${nextSectionName}"><spring:theme code="registration.next" /></button>
    <common:postCodeHandlebarTemplate/>

</div><%--site-form__section-content: about your business --%>


</div><%--site-form__section --%>
<script>
	var loqate = window.loqate || {};
	loqate.hybris = {
	forms : [
	  {
	    formId: "collectNectarForm",
			fields:{
				Line1: "collectNectar.addressLine1",
				Line2: "collectNectar.addressLine2",
				City: "collectNectar.town",
				AdminAreaName: "collectNectar.county",
        PostalCode: "collectNectar.deliveryPostCode",
			}
	  }
	]
};
</script>

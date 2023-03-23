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

<c:set var="isRequired" value="is-required"/>

<div class="site-form__section js-formSection is-active h-topspace-3" data-section="manage-your-brakes-account-details">
  <div class="site-form__section-header js-formHeader h-space-3">
   	<spring:theme code="text.nectarpoints.collect.page.section3.title" />
    <span class="icon icon-amend"></span>
  </div>
  <div class="nectarBanner__subText">
    <p ><spring:theme code="text.nectarpoints.collect.page.section3.details.text1" /></p>
    <p><spring:theme code="text.nectarpoints.collect.page.section3.details.text2" /></p>
  </div>

  <div class="site-form__section-content">
    <div class="row">
    <div class="col-xs-12 col-sm-12">
<%--     To clone copy of account section-Start --%>
    <div class="js-add-anothersection js-account-section hide">
    <div class="row">
        <div class="col-xs-9 col-sm-5">
          <div class="custom-txtbox">
          <div class="site-form__formgroup form-group js-formGroup">
            <label class="site-form__label " for="collectNectar.accountNumber">
          <spring:theme code="collectNectar.accountNumber"></spring:theme></label>
            <div class="site-form__inputgroup js-inputgroup ">
              <input id="collectNectar.accountNumber" type="number" name="accountNumber" class="form-control site-form__input is-required js-nectar-account-no" value="" autocomplete="noautocomplete">
              <span class="icon icon-error site-form__errorsideicon  js-error-icon-custom hide"></span>
              <span class="icon icon-tick site-form__validsideicon js-valid-icon-custom hide"></span>
              <span class="icon icon-caret-up error-msg js-errorMsg-custom site-form__errormessage hide"><spring:theme code="error.empty.accountNumber"/></span>
            </div>
          </div>
        </div>
      </div>
        <div class="col-xs-9 col-sm-5">
          <div class="site-form__title">
						<div class="custom-txtbox">
	            <div class="site-form__formgroup form-group js-formGroup ">
                <span class="site-form__label"><spring:theme code="collectNectar.accountType"></spring:theme></span>
			        	<div class="control site-form__dropdown ">
                  <label for="collectNectar.accountType" data-error-empty="Please insert a valid account type">
                    <select id="collectNectar.accountType" name="accountType"  class="form-control site-form__select js-formSelect js-formField jsAccountType is-required" data-validation-type="select">
              
                      <option value="" selected="selected"></option>
                        <c:forEach var="item" items="${accountTypes}">
                          <option value="${item.code}">${item.name}</option>
                        </c:forEach>
                    </select><input type="hidden" name="_accountType" value="1">
                    <span class="icon icon-error site-form__errorsideicon js-error-icon"></span>
                    <span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
                  </label>
			        	</div>

		            <span class="icon icon-caret-up error-msg js-errorMsg hide site-form__errormessage"></span>
			        </div>
	        	</div>
          </div>              
               
        </div>
          <div class="col-xs-1 col-offset-xs-1 col-sm-1  h-topspace-7 hidden-xs">
               <span class="nectarBanner__delete icon icon-trash icon--sm js-account-section-remove"></span>
           </div>   
           <div class="col-xs-1 col-offset-xs-1 col-sm-1 visible-xs">
               <span class="nectarBanner__delete icon icon-trash icon--sm js-account-section-remove"></span>
           </div>  
     </div>
    </div>
    <%--     To clone copy of account section-End --%>

      <div class="js-accountSectionParent">
      <div class="js-account-section">
      <div class="row">
        <div class="col-xs-9 col-sm-5">
          <div class="custom-txtbox">
          <div class="site-form__formgroup form-group js-formGroup">
            <label class="site-form__label " for="collectNectar.accountNumber">
          <spring:theme code="collectNectar.accountNumber"></spring:theme></label>
            <div class="site-form__inputgroup js-inputgroup ">
              <input type="number" id="collectNectar.accountNumber" name="accountNumber" class="form-control site-form__input js-nectar-account-no is-optional" value="" autocomplete="noautocomplete">
              <span class="icon icon-error site-form__errorsideicon  js-error-icon-custom hide"></span>
              <span class="icon icon-tick site-form__validsideicon js-valid-icon-custom  hide"></span>
              <span class="icon icon-caret-up error-msg js-errorMsg-custom site-form__errormessage hide"><spring:theme code="error.empty.accountNumber"/></span>
            </div>
          </div>
        </div>
      </div>
        <div class="col-xs-9 col-sm-5">
					  <div class="site-form__title">
						<div class="custom-txtbox">
	            <div class="site-form__formgroup form-group js-formGroup">
                <span class="site-form__label"><spring:theme code="collectNectar.accountType"></spring:theme></span>
			        	<div class="control site-form__dropdown ">
                  <label for="collectNectar.accountType" data-error-empty="Please insert a valid account type">
                    <select id="collectNectar.accountType" name="accountType" class="form-control site-form__select js-formSelect js-formField jsAccountType is-required" data-validation-type="select">
              
                      <option value="" selected="selected"></option>
                        <c:forEach var="item" items="${accountTypes}">
                          <option value="${item.code}">${item.name}</option>
                        </c:forEach>
                    </select><input type="hidden" name="_accountType" value="1">
                    <span class="icon icon-error site-form__errorsideicon js-error-icon"></span>
                    <span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
                  </label>
			        	</div>

		            <span class="icon icon-caret-up error-msg js-errorMsg hide site-form__errormessage"></span>
			        </div>
	        	</div>
          </div>              
               
                  
                    
      </div>
           <div class="col-xs-1 col-offset-xs-1 col-sm-1  h-topspace-7 hidden-xs">
               <span class="nectarBanner__delete icon icon-trash icon--sm js-account-section-remove"></span>
           </div>   
           <div class="col-xs-1 col-offset-xs-1 col-sm-1 visible-xs">
               <span class="nectarBanner__delete icon icon-trash icon--sm js-account-section-remove"></span>
           </div>  
         </div>
         </div>
         </div>

         
        <div class="row">
            <div class="col-xs-6 col-sm-3 h-topspace-3">
                <div class="nectarBanner__link js-add-another-button">
                  <span class="icon icon-plus" aria-hidden="true"></span>
                  <a class="nectarBanner__link__anchor nectarBanner__subText--bold"><spring:theme code="text.nectarpoints.collect.page.add.account" /></a></div>
            </div>
        </div>
       
        <div class="js-exceed-accountinfo hide h-topspace-3 nectarBanner__subText--bold">
          <spring:theme code="text.nectarpoints.collect.page.add.account.exceed" />
        </div>
       
    </div>
    </div>

    <button type="button" class="btn btn-primary visible-xs btn-block btn--full-width js-formNextBtn site-form__next-btn" data-parent="${sectionName}" data-goto="${nextSectionName}"><spring:theme code="registration.next" /></button>
  </div><%--site-form__section-content: about your business --%>
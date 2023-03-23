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

<div class="site-form__section js-formSection is-active" data-section="${sectionName}">
	<div class="site-form__section-content">
		<div class="row">
      <div class="col-xs-12 col-md-4">
        <div class="site-form__title">
            <formElement:formSelectBox
                idKey="register.title"
                labelKey="register.title"
                selectCSSClass="form-control site-form__select js-formSelect js-formField"
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
              inputCSS="form-control site-form__input js-formField"
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
              inputCSS="form-control site-form__input js-formField"
              labelCSS="site-form__label"
              mandatory="true"
              showAsterisk="true"
              validationType="name" />
      </div>
		</div>
		<div class="row">
      <div class="col-xs-12 col-sm-6">
        <formElement:formInputBox
          idKey="collectNectar.email"
          labelKey="collectNectar.email"
          path="email"
          errorKey="email"
          inputCSS="form-control site-form__input js-formField js-formFieldEmail"
          labelCSS="site-form__label"
          mandatory="true"
          showAsterisk="true"
          validationType="email"
      />
      </div>
      <div class="col-xs-12 col-sm-6">
        <formElement:formInputBox
          idKey="collectNectar.confirmEmail"
          labelKey="collectNectar.confirmEmail"
          path="confirmEmail"
          errorKey="confirmEmail"
          inputCSS="form-control site-form__input js-formField js-formFieldConfirmEmail"
          labelCSS="site-form__label"
          mandatory="true"
          showAsterisk="true"
          validationType="confirmEmail"
      />
      </div>
    </div>

    <div class="row">
      <div class="col-xs-12 col-md-1 col-sm-2 h-topspace-6">
                  <b><spring:theme code="collectNectar.nectarCardNoPrefix" /></b>
      </div>
      <div class="col-xs-12 col-sm-4 col-md-5">
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
      />
      </div>
      <div class="col-xs-12 col-sm-6">
                <formElement:formInputBox
                  idKey="collectNectar.optInCode"
                  labelKey="collectNectar.optInCode"
                  path="optInCode"
                  errorKey="optInCode"
                  inputCSS="form-control site-form__input js-formField"
                  labelCSS="site-form__label"
                  mandatory="true"
                  showAsterisk="true"
                  validationType="any"
                  placeholderKey="optInCode"
              />
        </div>
      </div>
      <div class="site-form__actions form-actions clearfix h-topspace-3">
        <ycommerce:testId code="register_Register_button">
          <button type="submit" class="btn btn-primary btn-block js-submitBtn">
            <spring:theme code="nectar.collect.bonus.submit" />
          </button>
        </ycommerce:testId>
      </div>
	</div><%-- site-form__section-content: about you --%>
</div><%-- site-form__section --%>


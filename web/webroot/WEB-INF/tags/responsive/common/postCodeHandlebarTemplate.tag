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

<script id="select-address-template" type="text/x-handlebars-template">
  <span class="site-form__label">Select address *</span>
  <div class="control site-form__dropdown js-formGroup">
    <label for="{{selectId}}" data-error-empty="<spring:theme code="error.empty.address"/>">
      <select id="{{selectId}}" name="address.select" data-parent-form="{{formId}}" class="form-control site-form__select js-formSelect is-required js-addressSelect js-formField">
        <option value="" selected="selected">- Please select -</option>
        {{#each items}}
          <option value="{{Id}}" >{{Text}} , {{Description}}</option>
          {{else}}
          <option value="{{Id}}" >No addresses available</option>
        {{/each}}
      </select>
     <span class="icon icon-error site-form__errorsideicon js-error-icon"></span>
     <span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
     <span class="icon icon-caret-up error-msg js-errorMsg hide site-form__errormessage"></span>
    </label>
  </div>
</script>
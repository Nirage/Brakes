<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>

<c:url value="/favourite/create" var="createWishListUrl" />

<components:modal id="createWishlistModal" title="wishlist.create.title" width="small">
  <form:form id="createWishForm" action="${createWishListUrl}" class="js-createWishForm" method="post">
    <div class="site-form__formgroup form-group js-formGroup clearfix">
      <label for="new-wishlist-name" class="control-label">
        <spring:theme code="wishlist.create.label"/>
      </label>
      <div class="site-form__inputgroup js-inputgroup ">
        <input type="text" class="form-control js-newWishlistName" id="new-wishlist-name" name="name" autocomplete="noautocomplete" maxlength="80"/>
        <span class="icon icon-error site-form__errorsideicon  js-error-icon"></span>
      </div>
      <span class="icon icon-caret-up error-msg js-errorMsg site-form__errormessage hide">
      <spring:theme code="wishlist.create.error" /></span>
      <span class="icon icon-caret-up error-msg js-errorNameMsg site-form__errormessage hide">
      <spring:theme code="wishlist.create.error.invalidName" /></span>
    </div>
    <input class="js-newWishlistProductCode" type="hidden" name="productCode" value="" />
    <button type="submit" class="btn btn-primary btn--full-width "><spring:theme code="wishlist.submit.cta"/></button>
  </form:form>
</components:modal>

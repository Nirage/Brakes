<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>

<c:url value="/favourite/namechange" var="amendWishListUrl" />

<components:modal id="amendWishlistModal" title="wishlist.rename.title" width="small">
  <form:form id="amendWishListNameForm" action="${amendWishListUrl}" class="js-amendWishListNameForm" method="post">
    <input type="hidden" name="wishlistId" value="" class="js-formWishlistId"/>
    <div class="site-form__formgroup form-group js-formGroup clearfix">
      <label for="amend-wishlist-name" class="control-label">
        <spring:theme code="wishlist.amend.label"/>
      </label>
      <div class="site-form__inputgroup js-inputgroup">
        <input type="text" class="form-control js-amendWishlistName" id="amend-wishlist-name" name="favouriteName" autocomplete="noautocomplete"/>
        <span class="icon icon-error site-form__errorsideicon js-error-icon"></span>
      </div>
      <span class="icon icon-caret-up error-msg js-errorMsg site-form__errormessage hide">
        <span class="js-emptyError hide"><spring:theme code="wishlist.error.empty.title" /></span>
        <span class="js-maxError hide"><spring:theme code="wishlist.error.max.title" /></span>
      </span>
    </div>
    <button type="submit" class="btn btn-primary btn--full-width "><spring:theme code="wishlist.rename.submit.cta"/></button>
  </form:form>
</components:modal>

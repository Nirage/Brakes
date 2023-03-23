<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>

<div class="quick-add quick-add--wishlist-product ${styleClass}">
    <form:form method="post" id="" class="quick-add__form js-wishlistQuickAddForm site-form" data-max-qty="1" modelAttribute="quickAddItemToFavouriteForm" action="${contextPath}/favourites/quickAdd">
        <input type="hidden" id="quickAddItemToFavouriteForm.qty" name="qty" data-validation-type="qty" value="${quickAddItemToFavouriteForm.qty}" />
        <input type="hidden" id="quickAddItemToFavouriteForm.favouriteUid" name="favouriteUid" data-validation-type="favouriteUid" value="${favouriteUid}" />
        <div class="quick-add__header"><spring:theme code="quickAddItemToFavouriteForm.header" /></div>
        <div class="site-form__formgroup js-formGroup">
            <div class="quick-add__inputs-group quick-add__inputs-group--wishlist">
                <div class="site-form__inputgroup js-inputgroup">
                    <label class="hidden" for="quickAddItemToFavouriteForm.productCode"></label>
                    <input type="text" id="quickAddItemToFavouriteForm.productCode" name="productCode" class="quick-add__input quick-add__input--single form-control js-wishlistQuickAddProductCode" maxlength="10" data-validation-type="product-code" placeholder="<spring:theme code='placeholder.text.productCode' />" value="${quickAddFavouriteItemForm.productCode}" autocomplete="noautocomplete" maxlength="3"/>
                    <span class="icon icon-error site-form__errorsideicon js-error-icon"></span>
                </div>
            </div>
            <div class="quick-add__btn-group quick-add__btn-group--wishlist">
                <button type="submit" disabled="disabled" class="btn btn-primary btn-block quick-add__button quick-add__button--symbol js-submitBtn js-wishlistQuickAddSubmitButton">
                    <span class="icon icon-plus"></span>
                </button>
            </div>
            <span class="icon icon-caret-up error-msg js-errorMsg site-form__errormessage hide"></span>
        </div>

    </form:form>
</div>
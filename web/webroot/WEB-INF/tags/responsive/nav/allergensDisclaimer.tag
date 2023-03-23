<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>

<%-- Add quantity modal --%>
<c:set var="title" value="cart.quantity.popup.add.title" />
<div id="allergensFacetModal" class="disclaimer_box js-facetDisclaimer hide">
    <p class="disclaimer_box--title"><spring:theme code="disclaimer.title"/></p>
        <div class="disclaimer-box--text h-space-2">            
                <spring:theme code="disclaimer.content"/>
        </div>
            <button tabindex="0" type="button" class="btn btn-primary h-space-2 js-disclaimerAccept">
                <spring:theme code="disclaimer.button.accept"/>
            </button>
            <button tabindex="0" class="btn btn-red btn--full-width js-disclaimerDecline">
                <spring:theme code="disclaimer.button.decline"/>
            </button>
</div>

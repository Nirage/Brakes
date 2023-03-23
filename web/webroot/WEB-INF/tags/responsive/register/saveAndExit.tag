<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="title" value="cart.quantity.popup.maximum.title" />
<c:set var="title" value="save.exit.heading" />

<components:modal id="saveAndExit" title="${title}" >
    <div class=""saveAndExit>
        <p class="h-space-2"><spring:theme code="save.exit.title"/></p>
         <div>
         <input type="email" value="${registerForm.email}" class="form-control site-form__input js-formField  h-topspace-2 "  
         disabled placeholder="<spring:theme code="save.exit.email.address"/>"/>
         </div>
        

     <button tabindex="0" class="btn btn-primary btn--full-width h-topspace-2 js-SaveEXitSubmit" data-dismiss="modal" aria-label="Close">
            <spring:theme code="save.exit.btn"/>
        </button>   
        <hr class="saveAndExit__hr">
         <button tabindex="0" class="btn btn-secondary btn--full-width js-saveExitBtn" data-dismiss="modal" aria-label="Close">
            <spring:theme code="exit.btn"/>
        </button>
        <hr class="saveAndExit__hr">
        </div>    
</components:modal>

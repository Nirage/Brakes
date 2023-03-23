<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>

<%@ attribute name="extraClass" required="false" type="java.lang.String"%>

<div class="loader__product ${extraClass}">
    <div class="loader__product__img"></div>
    <div class="loader__product__information"></div>
    <hr class="separator">
    <div class="loader__product__interaction">
        <div class="loader__product__price"></div>
        <div class="loader__product__button"></div>
    </div>
</div>
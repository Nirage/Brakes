<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="delivery" tagdir="/WEB-INF/tags/responsive/delivery" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<footer>
    <div class="container-fluid">
            <cms:pageSlot position="Footer" var="feature">
                <cms:component component="${feature}"/>
            </cms:pageSlot>
        <div class="row">
        <div class="footer__bottom ${not empty param['steppedCheckout'] ? 'footer__bottom--stepped-checkout' :'nope'} ">
            <div class="col-md-12 text-center">
                    <cms:pageSlot position="FooterSocial" var="feature">
                        <cms:component component="${feature}"/>
                    </cms:pageSlot>
                <cms:pageSlot position="FooterCopyright" var="feature">
                    <cms:component component="${feature}"/>
                </cms:pageSlot>
            </div>
        </div>
        </div>
    </div>
</footer>

<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')" >
    <delivery:dateConfirmationModal/>
</sec:authorize>
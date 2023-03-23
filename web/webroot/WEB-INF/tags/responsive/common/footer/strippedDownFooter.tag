<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>


<footer class="js-strippedDownFooter">
    <div class="container-fluid">
        <div class="row">
            <div class="footer__bottom">
                <div class="col-md-12 text-center">
                    <cms:pageSlot position="FooterCopyrightStripped" var="feature">
                        <cms:component component="${feature}"/>
                    </cms:pageSlot>
                </div>
            </div>
        </div>
    </div>
</footer>
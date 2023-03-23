<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="footer" tagdir="/WEB-INF/tags/responsive/common/footer"  %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:if test="${component.visible}">

    <c:forEach items="${component.navigationNode.children}" var="childLevel1">
        <input type="checkbox" id="heading-${childLevel1.uid}" name="footer-accordion" autocomplete="off">
    </c:forEach>
    <div class="footer__section-wrapper">
        <c:forEach items="${component.navigationNode.children}" var="childLevel1">
            <div class="footer__section">
                <label role="heading" aria-level="4" for="heading-${childLevel1.uid}" class="footer__heading">${fn:escapeXml(childLevel1.title)}<i class="icon icon-chevron"></i></label>
                <ul class="footer__link-list">
                    <c:forEach items="${childLevel1.children}" step="${component.wrapAfter}" varStatus="i">
                        <c:forEach items="${childLevel1.children}" var="childLevel2" begin="${i.index}" end="${i.index + component.wrapAfter - 1}">
                            <c:forEach items="${childLevel2.entries}" var="childlink">
                                <cms:component component="${childlink.item}" evaluateRestriction="true" class="footer__link" element="li"/>
                            </c:forEach>
                        </c:forEach>
                    </c:forEach>
                </ul>
            </div>
        </c:forEach>
    </div>

</c:if>



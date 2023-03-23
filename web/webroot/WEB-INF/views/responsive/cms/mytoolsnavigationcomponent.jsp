<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>

<c:set value="${fn:escapeXml(component.styleClass)}" var="navigationClass" />

<c:if test="${component.visible}">
    <div class="side-nav js-sideNav">
    <c:if test="${not empty component.navigationNode.title }">
        <h3 class="side-nav__heading js-sideNavHeading">
            <c:out value="${component.navigationNode.title}"/>
        </h3>
    </c:if>
        <ul class="side-nav__list side-nav__list--level1 js-sideNavLevel1">
            <c:forEach items="${component.navigationNode.children}" var="topLevelChild">
            <li class="side-nav__item side-nav__item--level1 ">
                <c:forEach items="${topLevelChild.entries}" var="entry">
                    <cms:component component="${entry.item}" evaluateRestriction="true" />
                </c:forEach>
            </li>
            </c:forEach>
        </ul>
    </div>
</c:if>
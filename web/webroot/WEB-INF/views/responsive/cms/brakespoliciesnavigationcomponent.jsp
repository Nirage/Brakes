<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<c:if test="${not empty component.navigationNode.children}">
  <div class="side-nav-nested side-nav--nested js-sideNav">
    <div class="side-nav-nested__heading js-sideNavHeading">
      <spring:theme code="${component.name}" />
    </div>
    <ul class="side-nav-nested__list side-nav-nested__list--level1 js-sideNavLevel1">
      <c:forEach items="${component.navigationNode.children}" var="childLevel1" > 
        <c:if test="${not empty childLevel1.entries}">
          <c:forEach items="${childLevel1.entries}" var="childlink1">
          <li class="side-nav-nested__item side-nav-nested__item--level1 <c:if test="${not empty childlink1.navigationNode.children}">js-sideNavDrillDown has-sub</c:if>">
            <c:choose> 
              <c:when test="${childlink1.item.url != '/'}">
                <cms:component component="${childlink1.item}" evaluateRestriction="true" element="span" class="" />
                </c:when>
              <c:otherwise>
                <%-- ${childlink1.item.name} --%>
               <div class="side-nav-nested__item-heading"> ${childlink1.item.linkName} </div>
              </c:otherwise>
            </c:choose>
            <c:if test="${not empty childlink1.navigationNode.children}">
              <ul class="side-nav-nested__list side-nav-nested__list--level2">
                <c:forEach items="${childlink1.navigationNode.children}" var="childLevel2">
                  <c:if test="${not empty childLevel2.entries}">
                  <c:forEach items="${childLevel2.entries}" var="childlink2">
                    <li class="side-nav-nested__item side-nav-nested__item--level2">
                      <c:choose> 
                        <c:when test="${childlink2.item.url != ''}">
                         <cms:component component="${childlink2.item}" evaluateRestriction="true" element="span" class="" />
                        </c:when>
                        <c:otherwise>
                         ${childlink2.item.name}
                        </c:otherwise>
                      </c:choose>
                    </li>
                    </c:forEach>
                  </c:if>
                </c:forEach>
              </ul>
            </c:if>
            </li>
          </c:forEach>
        </c:if>
      </c:forEach>
    </ul>
  </div>
</c:if>

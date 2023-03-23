<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ attribute name="headerText" required="true" type="java.lang.String"%>
<%@ attribute name="headerTag" required="false" type="java.lang.String"%>
<%@ attribute name="customCSSClass" required="false" type="java.lang.String"%>

<c:set var="headerElement" value="h2" />
<c:if test="${not empty headerTag}">
  <c:set var="headerElement" value="${headerTag}" />
</c:if>

<div class="site-header ${customCSSClass}">
  <${headerElement} class="site-header__text site-header__text--underline">
    ${headerText}
  </${headerElement}>
</div>
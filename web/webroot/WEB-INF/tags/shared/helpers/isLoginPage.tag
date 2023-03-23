<%@ tag body-content="scriptless" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:choose>
  <c:when test="${fn:containsIgnoreCase(pageBodyCssClasses, 'login')}">
    true
  </c:when>
  <c:otherwise>
    false
  </c:otherwise>
</c:choose>
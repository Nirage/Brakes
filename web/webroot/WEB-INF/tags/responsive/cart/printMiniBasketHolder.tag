<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">
    <c:set var="isLoggedIn" value="true" />
</sec:authorize>

<c:set var="pageHasMiniBasket" value="false" />
<c:if test="${cmsPage.uid eq 'productGrid' || 
              cmsPage.uid eq 'searchGrid' || 
              cmsPage.uid eq 'favouriteItemGrid' || 
              cmsPage.uid eq 'order' || 
              cmsPage.uid eq 'orderamend'}">
  <c:set var="pageHasMiniBasket" value="true" />
</c:if>

<c:if test="${isLoggedIn && pageHasMiniBasket}">
  <div class="cart-print">
    <div class="container">
      <cms:pageSlot position="SiteLogo" var="logo" limit="1">
        <cms:component component="${logo}" element="div" class="cart-print__logo" />
      </cms:pageSlot>
      <div class="js-miniCartPrintHolder">
      </div>
    </div>
  </div>
</c:if>
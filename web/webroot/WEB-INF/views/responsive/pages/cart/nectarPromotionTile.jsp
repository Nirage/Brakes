<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<c:url value="/nectar-points" var="nectarLandingPage"/>
<div class="container">
<div class="row">
  <div class="col-xs-12 cart-nectarBanner__noPad">
    <div class="cart-nectarBanner">
    <div class="row">
    <div class="col-sm-3 col-xs-12">nectar Business</div>
     <div class="cart-nectarBanner__title col-sm-6 col-xs-12"><spring:theme code="basket.nectar.tile.txt"/></div><a class="col-sm-3 col-xs-12 btn btn-primary btn--continue-checkout" href="${nectarLandingPage}"><spring:theme code="basket.nectar.tile.learn.more"/></a>
     </div>
    </div>
    </div>
  </div>
</div>
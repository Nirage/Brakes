<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>

<c:url value="/nectar-points/link-your-account" var="nectarAccountLinkingUrl"/>
<c:url value="/nectar-points/bonus-points" var="nectarAccountBonusUrl"/>
<c:url value="/nectar-points/help-faq" var="nectarPointsHelpUrl"/>
<!-- First section. -->

<div class="nectarBanner--no-margins nectarBanner__bg h-space-3 h-no-margins">
  <div class="container">
    <div class="row">
      <div class="visible-xs">
        <div class="col-xs-12">
          <div class=" nectarBanner__bg--box">
          </div>
        </div>
      </div>

      <div class="col-md-3 col-md-offset-1 col-sm-5 col-sm-offset-2">
        <div class=" nectarBanner__bg--plain">
          <h2 class="nectarBanner__title h-space-2"><spring:theme code="text.nectarpoints.collect.header"/></h2>
          <span class="site-header__rectangle site-header__rectangle--align-left h-space-2"></span>
          <p class="nectarBanner__subText h-space-3"><spring:theme code="text.nectarpoints.collect.details"/></p>
          <a href="https://www.nectar.com/register/business/enrol.htm" class="button btn btn-primary h-space-3" target="_blank"><spring:theme code="text.nectarpoints.collect.register.now"/></a>
        </div>
      </div>
    </div>
  </div>
</div>

<div class="container">
  <div class="row">
    <div class="col-xs-12">
      <div class=" nectarBanner__bg nectarBanner__bordered h-space-8">
        <div class="visible-xs">
          <div class="col-xs-12">
            <div class=" nectarBanner__bg--box">
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-sm-6 col-xs-12">
            <div class=" nectarBanner__bg--plain">
              <div class="nectarBanner__subTitle h-space-1"><spring:theme code="text.nectarpoints.already.account.header"/></div  >
                <span class="site-header__rectangle site-header__rectangle--align-left h-space-3"></span>
                <p class="nectarBanner__subText h-space-3"><spring:theme code="text.nectarpoints.already.account.details"/></p>
                <div class="row">
                  <div class="col-xs-12 col-md-6">
                    <a href="${nectarAccountLinkingUrl}" class="button btn btn-primary btn--full-width h-sm-space-1" ><spring:theme code="text.nectarpoints.account.link.button"/></a></div>
                  <div class="col-xs-12 col-md-6">
                    <a href="${nectarAccountBonusUrl}" class="button btn btn-primary btn--full-width" ><spring:theme code="text.nectarpoints.account.bonus.button"/></a>
                  </div>
                
                </div>
               
           
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

  <!-- About Nectar business section. -->
  <div class="row">
    <div class="col-sm-4 h-space-3">
      <div class="nectar__tile ">
        <h2 class="nectarBanner__subTitle js-nectarTilecTitle"><spring:theme code="text.nectarpoints.about.header"/></h2>
        <p class="nectarBanner__subText h-space-2 js-nectarTilecText"><spring:theme code="text.nectarpoints.about.details"/></p>
        <a href="https://www.nectar.com/" class="button btn btn-primary" target="_blank"><spring:theme code="text.nectarpoints.about.button"/></a>
      </div>
    </div>

    <!-- Spend your points section. -->
    <div class="col-sm-4 h-space-3">
      <div class="nectar__tile ">
        <h2 class="nectarBanner__subTitle flex-column js-nectarTilecTitle"><spring:theme code="text.nectarpoints.spend.header"/></h2>
        <p class="nectarBanner__subText h-space-2 js-nectarTilecText"><spring:theme code="text.nectarpoints.spend.details"/></p>
        <a href="https://www.nectar.com/brands?lo=redeem" class="button btn btn-primary" target="_blank"><spring:theme code="text.nectarpoints.spend.button"/></a>
      </div>
    </div>
      <!-- Need help section. -->
      <div class="col-sm-4 h-space-3">
        <div class="nectar__tile ">
          <h2 class="nectarBanner__subTitle flex-column js-nectarTilecTitle"><spring:theme code="text.nectarpoints.help.header"/></h2>
          <p class="nectarBanner__subText h-space-2 js-nectarTilecText"><spring:theme code="text.nectarpoints.help.details"/></p>
          <a href="${nectarPointsHelpUrl}" class="button btn btn-primary" ><spring:theme code="text.nectarpoints.help.button"/></a>
        </div>
      </div>
    </div> 
  </div>
</div>

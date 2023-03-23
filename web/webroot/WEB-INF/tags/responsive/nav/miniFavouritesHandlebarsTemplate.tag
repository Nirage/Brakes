<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<c:url value="/my-account/favourites" var="favouritesUrl"/>

<script id="mini-favourites-template" type="text/x-handlebars-template">

  <div class="mini-favourites__body">
    <div class="mini-favourites__heading">
      <spring:theme code="popup.favourites.heading" />
    </div>

  <ul class="mini-favourites__list">
    {{#each this}}
      <li class="mini-favourites__item">
        <a class="mini-favourites__link js-favouritesNavLink" href="${favouritesUrl}/{{encodeURIComponent uid}}">
          <span class="mini-favourites__name">{{name}}</span>
          <span class="qty">({{itemsCount}})</span>
        </a>
      </li>
    {{/each}}
  </ul>
  <div class="mini-favourites__footer">
    <a href="${fn:escapeXml(favouritesUrl)}" class="btn btn-primary btn--full-width">
      <spring:theme code="popup.favourites.showall" />
    </a>
  </div>
  </div>
</script>
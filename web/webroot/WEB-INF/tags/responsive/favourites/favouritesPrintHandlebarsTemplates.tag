<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>


<script id="favourites-print-template" type="text/x-handlebars-template">
  <div class="wishlist-print">
    <div class="container">
      <cms:pageSlot position="SiteLogo" var="logo" limit="1">
        <cms:component component="${logo}" element="div" class="wishlist-print__logo" />
      </cms:pageSlot>
      <div class="wishlist-print__wrapper">
					<div class="wishlist-print__info">
						<span class="wishlist-print__id">
              {{details.name}}
						</span>
					</div>
          <div class="wishlist-print__details">
            <div class="wishlist-print__details-entry">
              <span class="wishlist-print__details-entry-name"><spring:theme code="wishlist.print.noOfItems" /></span>
              <span class="wishlist-print__details-entry-value">{{itemCount}}</span>
            </div>
            <div class="wishlist-print__details-entry">
              <span class="wishlist-print__details-entry-name"><spring:theme code="wishlist.print.createdBy" /></span>
              <span class="wishlist-print__details-entry-value">{{details.createdBy}}</span>
            </div>
            <div class="wishlist-print__details-entry">
              <span class="wishlist-print__details-entry-name"><spring:theme code="wishlist.print.createdAt" /></span>
              <span class="wishlist-print__details-entry-value">{{details.createdAt}}</span>
            </div>
            <div class="wishlist-print__details-entry">
              <span class="wishlist-print__details-entry-name"><spring:theme code="wishlist.print.lastModified" /></span>
              <span class="wishlist-print__details-entry-value">{{details.modifiedTime}}</span>
            </div>              
          </div>
					<table class="wishlist-print__products">
						<tr class="wishlist-print__product-row">
							<th colspan="2"><spring:theme code="wishlist.print.product" /></th>
							<th><spring:theme code="wishlist.print.code" /></th>
							<th><spring:theme code="wishlist.print.skuPrice" /></th>
						</tr>
            {{#each results}}
							<tr class="wishlist-print__product-row">
								<td>
                  {{#if product.images.length}}
                  <img class="wishlist-print__product-img" src="{{product.images.0.url}}?$plp-mobile$" />
                  {{else}}
                  <img class="wishlist-print__product-img" src="https://i1.adis.ws/i/Brakes/image-not-available?$plp-mobile$" />
                  {{/if}}
                </td>
                <td align="left">
									<span class="wishlist-print__product-name">{{product.name}}</span>
								</td>
								<td>
                  {{#if product.prefix}}{{product.prefix}}&nbsp;{{/if}}{{product.code}}
                </td>
								<td>
                  <div class="js-loadPrice" data-product-code="{{product.sapProductCode}}" data-price-per-divider="{{product.pricePerDivider}}">
                    <span class="js-loadPriceValue">{{product.price}}</span>
                  </div>
                </td>
							</tr>
				    {{/each}}
					</table>
				</div> <%-- wishlist-print__wrapper --%>
    </div><%-- container --%>
  </div><%-- wishlist-print --%>
</script>

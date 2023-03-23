<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<script id="orders-print-template" type="text/x-handlebars-template">
  <div class="order-print">
    <div class="container">
      <cms:pageSlot position="SitePrintLogo" var="logo" limit="1">
        <cms:component component="${logo}" element="div" class="order-print__logo" />
      </cms:pageSlot>
      <div class="order-print__wrapper">
					<table class="order-print__info-table" border="0" width="100%" sytle="border-collapse:collapse;">
            <tr>
              <td colspan="2" class="order-print__info">
                <spring:theme code="order.print.order.summary" />
                <span class="order-print__id">
                  {{order.code}}
                </span>
              </td>
            </tr>
          
            <%-- <tr class="order-print__details"> --%>
            <tr class="order-print__details-entry">
              <td width="30%" class="order-print__details-entry-name"><spring:theme code="order.print.items.ordered" /></td>
              <td width="70%" class="order-print__details-entry-value">{{itemCount}}</td>
            </tr>
            <tr class="order-print__details-entry">
              <td class="order-print__details-entry-name"><spring:theme code="order.print.delivery" /></td>
              <td class="order-print__details-entry-value">
                {{order.deliveryDatePrintPageFormatted}}
              </td>
            </div>
            <tr class="order-print__details-entry">
              <td class="order-print__details-entry-name"><spring:theme code="order.print.customer.Ref" /></td>
              <td class="order-print__details-entry-value">{{order.purchaseOrderNumber }}</td>
            </tr>
            <tr class="order-print__details-entry">
              <td class="order-print__details-entry-name"><spring:theme code="order.print.replacedby" /></td>
              <td class="order-print__details-entry-value">{{order.placedBy}}</td>
            </tr> 
            <tr class="order-print__details-entry">
              <td class="order-print__details-entry-name"><spring:theme code="order.print.line.status" /></td>
              <td class="order-print__details-entry-value">{{order.orderStatusName}}</td>
            </tr>  
            <tr class="order-print__details-entry">
              <td class="order-print__details-entry-name"><spring:theme code="order.print.Net.Total" /></td>
              <td class="order-print__details-entry-value">{{order.total.formattedValue}}</td>
            </tr>
          </table>               
    
					<table class="order-print__products">
						<tr class="order-print__product-row">
							<th><spring:theme code="order.print.product" /></th>
							<th align="center"><spring:theme code="order.print.quantity" /></th>
							<th><spring:theme code="order.print.line.total" /></th>
              <th><spring:theme code="order.print.Status" /></th>
						</tr>
            {{#each results}}
							<tr class="order-print__product-row">
								<td>
                  {{#if product.prefix}}{{product.prefix}}&nbsp;{{/if}}{{product.code}} - <span class="order-print__product-name">{{product.name}}</span>
                  {{#if product.subjectToVAT}}
                    <span class="order-print__vat"> *</span>
                  {{/if}}
                  <br/>
                  {{product.packSize}}
								</td>
                <td>
                  {{quantity}}
                    {{#if product.netWeight}}
                    <div class="js-loadPrice" data-product-code="{{product.code}}" data-price-per-divider="{{product.pricePerDivider}}">
                        <span class="js-loadPriceValue">{{product.estimatedPrice.formattedValue}}</span>
                    </div>
                    {{else}}
                    <div class="js-loadPrice" data-product-code="{{product.code}}" data-price-per-divider="{{product.pricePerDivider}}">
                        <span class="js-loadPriceValue">{{product.totalPrice.formattedValue}}</span>
                    </div>
                    {{/if}}
                </td>
								<td>
                    {{totalPrice.formattedValue}}
                </td>
                <td>
                    {{status}}
                </td>
							</tr>
				    {{/each}}
            <tr class="order-print__product-row">
              <td class="order-print__total" colspan="4" align="right">
                 <spring:theme code="order.totals.total" />&nbsp;{{order.total.formattedValue}}
              </td>
            </tr>
            {{#if hasVatPricing}}
            <tr>
              <td colspan="4" align="left" class="order-print__vat">       
                <spring:theme code="order.print.vat.applicable" />
              </td>
            </tr>
            {{/if}}
					</table>
				</div> 
    </div>
  </div>
</script>

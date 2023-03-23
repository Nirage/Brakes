<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="entry" required="true" type="de.hybris.platform.commercefacades.order.data.OrderEntryData" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="entryNumberHtml" value="${fn:escapeXml(entry.entryNumber)}"/>

<c:if test="${entry.updateable}">
        <div class="js-cartItemDetailGroup">
          <button type="button" class="btn cart-item__remove js-cartItemDetailBtn" aria-haspopup="true"
                  aria-expanded="false" id="editEntry_${entryNumberHtml}" data-form-id="addToCartForm${fn:escapeXml(entry.product.code)}">
              <span class="icon icon-trash icon--sm"></span>
          </button>
        </div>
    </c:if>
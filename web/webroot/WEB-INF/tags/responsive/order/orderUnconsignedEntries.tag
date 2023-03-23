<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="order" required="true" type="de.hybris.platform.commercefacades.order.data.OrderData" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="order" tagdir="/WEB-INF/tags/responsive/order" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="itemsCounter" value="0"/>
<c:set var="blocksCounter" value="1"/>
<fmt:formatDate pattern = "dd MMM yyyy" value = "${orderData.deliveryDate}" var="deliveryDate" />

<spring:htmlEscape defaultHtmlEscape="true" />

<ul class="item__list checkout-confirmation__product">     
	<c:forEach items="${order.unconsignedEntries}" var="entry" varStatus="loop">   
		<order:orderEntryDetails orderEntry="${entry}" order="${order}" itemIndex="${loop.index}"/>
	</c:forEach>
</ul>
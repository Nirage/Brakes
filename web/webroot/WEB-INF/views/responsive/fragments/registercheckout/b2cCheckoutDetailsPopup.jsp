<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="delivery" tagdir="/WEB-INF/tags/responsive/b2c/delivery"%>

<c:choose>
		<%-- DON'T SHOW delivery address form --%>
	<c:when test="${showpopup eq false}">
		Do not show the pop up.
	</c:when>
	<%-- SHOW delivery address form --%>
	<c:otherwise>
		<%-- Add delivery address form --%>
		<delivery:addDeliveryAddress/>
	</c:otherwise>
</c:choose>
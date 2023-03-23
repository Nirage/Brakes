<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="favourite" required="true" type="com.envoydigital.brakes.facades.wishlist.data.FavouritesData"%>
<%@ attribute name="styleClass" required="false" type="java.lang.String"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="favouriteUid" value="${favourite.uid}" scope="request"/>
<c:set var="styleClass" value="${styleClass}" scope="request"/>
<cms:pageSlot position="QuickAddItemToFavourite" var="quickadditemtofavourite">
  <cms:component component="${quickadditemtofavourite}" />
</cms:pageSlot>

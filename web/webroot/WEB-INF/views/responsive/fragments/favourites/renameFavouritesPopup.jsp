<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>


<spring:url value="/favourite/namechange/{/favouriteUid}" var="renameFavouriteUrl" htmlEscape="false">
		<spring:param name="favouriteUid"  value="${favouriteUid}"/>
	</spring:url>
	
<h3><spring:theme code="wishlist.rename.title"/></h3>
     <form:form action="${renameFavouriteUrl}" method="post">
        <spring:theme code="wishlist.create.label"/><br>
        <input type="text" name="favouriteName"><br>
        <button type="submit"><spring:theme code="wishlist.rename.submit.cta"/></button>
       </form:form>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<c:url value="/favourite/create" var="createWishListUrl" />
<h3><spring:theme code="wishlist.create.title"/></h3>
     <form:form action="${createWishListUrl}" method = "post">
        <spring:theme code="wishlist.create.label"/><br>
        <input type="text" name="name"><br>
        <input type="hidden" name="productCode" value="">
        <button type="submit"><spring:theme code="wishlist.submit.cta"/></button>
       </form:form>
   

<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="reOrderedSuccess" required="true" %>

<c:if test="${not empty reOrderedSuccess && reOrderedSuccess eq true}">
    <script>window.reOrderedSuccess = true;</script>
</c:if>
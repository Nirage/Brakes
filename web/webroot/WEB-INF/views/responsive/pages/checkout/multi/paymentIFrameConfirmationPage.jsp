<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" session="false" %>

<c:if test="${not empty url}">
	Processing Payment, please wait....
	<script type="text/javascript">
		parent.document.location.href = '<c:url value="${url}"/>';
	</script>
</c:if>
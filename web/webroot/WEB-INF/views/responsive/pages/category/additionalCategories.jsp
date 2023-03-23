<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<c:if test="${not empty additionalCategories}">
    <div class="site-form__formgroup form-group m0">
        <div class="control site-form__dropdown">
            <i class="glyphicon glyphicon-th-large"></i>
            <select id="additionalCategory" name="additionalCategory" class="form-control site-form__select site-form__select--fixed-width">
                <option selected disabled><spring:theme code="text.categories.additionalcategories.header"/></option>
                <c:forEach items="${additionalCategories}" var="additionalCategory">
                    <option value="${additionalCategory.url}">${additionalCategory.name}</option>
                </c:forEach>
            </select>
        </div>
    </div>
</c:if>
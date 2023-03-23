<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="suggestions" required="true" type="java.util.List" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:if test="${not empty suggestions}">
	<div class="searchSpellingSuggestionPrompt search-result__sugg-text col-xs-12">
		<spring:theme code="search.spellingSuggestion.prompt" />&nbsp;
		<c:forEach items="${suggestions}" var="suggestion" varStatus="loop">
		    <spring:url value="/search?text=${suggestion.term}" var="spellingSuggestionQueryUrl" htmlEscape="false"/>
            <a class="search-result__sugg-link" href="${fn:escapeXml(spellingSuggestionQueryUrl)}">${fn:escapeXml(suggestion.term)}</a>
        </c:forEach>	
	</div>
</c:if>

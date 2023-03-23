<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="selpos" tagdir="/WEB-INF/tags/responsive/selpos"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<div class="row">
	<div class="col-xs-12">
		<%-- section heading --%>
		<div class="site-header site-header--align-left h-space-5">
			<h1 class="site-header__text site-header--align-left">${pageData.currentCategory.title}</h1>
			<span class="site-header__rectangle site-header__rectangle--align-left"></span>
			<p class="site-header__subtext">${pageData.currentCategory.description}</p>
		</div>
		<%-- progress Bar --%>
		<div class="col-xs-12 order-sel__bordered p-0">
			<selpos:progressBar currentPosition="${pageData.currentPosition}" type="${pageData.type}" breadcrumbs="${pageData.breadcrumbs}"/>
		</div>
	</div>
	<%-- order options --%>
	<div class="col-xs-12 p-0">
		<c:choose>
			<c:when test="${pageData.option.type eq 'sels'}">
				<selpos:sels pageData="${pageData}"/>
			</c:when>
			<c:when test="${pageData.option.type eq 'descriptive'}">
				<selpos:descriptive pageData="${pageData}"/>
			</c:when>
			<c:when test="${pageData.option.type eq 'multibuy'}">
				<selpos:multibuy pageData="${pageData}"/>
			</c:when>
			<c:when test="${pageData.option.type eq 'a3a4posters'}">
				<selpos:a3a4posters pageData="${pageData}"/>
			</c:when>
			<c:when test="${pageData.option.type eq 'a4menus'}">
				<selpos:a4menus pageData="${pageData}"/>
			</c:when>
			<c:when test="${pageData.option.type eq 'tillcards'}">
				<selpos:tillcards pageData="${pageData}"/>
			</c:when>
			<c:otherwise>
				<selpos:category categories="${pageData.subCategories}"/>
			</c:otherwise>
		</c:choose>
	</div>
</div>





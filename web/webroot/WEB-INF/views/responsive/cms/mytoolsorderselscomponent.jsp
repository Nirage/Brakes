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

<div class="row">
    <div class="col-xs-12">
        <div class="site-header site-header--align-left">
            <h1 class="site-header__text site-header--align-left">${cmsPage.title}</h1>
            <span class="site-header__rectangle site-header__rectangle--align-left"></span>
            <p class="site-header__subtext"><spring:theme code="orderSELs.description" /></p>
        </div>

    </div>
    <div class="col-xs-12">
    </div>

</div>


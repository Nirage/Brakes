<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>

<c:set var="showVatApplicable" value="false"/>

<script type="text/javascript">
	window.monetateComponentProductList = [];
	window.monetateQ = window.monetateQ || [];
	window.monetateQ.push([
	"setPageType",
		"${cmsPage.uid}"
	]);
</script>

<c:if test="${fn:length(productData) > 0 }">
    <div class="content">
        <div class="site-component">
            <div class="container">
                <div class="row">
                    <div class="col-xs-12">
                        <div class="site-header">
                            <h2 class="site-header__text site-header__text  site-header__text--underline"><spring:theme code="recentPurchases.component.title"/></h2>
                            <p class="site-header__subtext site-header__subtext--full-width "><spring:theme code="recentPurchases.component.subtitle"/></p>
                        </div>
                    </div>
                    <div class="col-xs-12">    
                        <div class="products-component__list product__listing js-PromoEnabledList js-scrollEnabledList">
                            <c:forEach items="${productData}" var="productData">
                                <c:if test="${productData.subjectToVAT eq true}">
                                    <c:set var="showVatApplicable" value="true"/>
                                </c:if>
                                <%-- Product list --%>
                                <product:productListerGridItem product="${productData}"/>
                                <script type="text/javascript">
                                    monetateComponentProductList.push("${productData.code}");
                                </script>
                            </c:forEach>
                            <%-- View All Recent Purchases Button --%>
                            <div class="flex flex-100 align-items-center justify-content-center">
                                <a class="btn btn-primary mt1 plr-2 width-auto" href="/my-account/recent-purchased-products" title="<spring:theme code='recentPurchases.component.button'/>">
                                    <spring:theme code="recentPurchases.component.button"/>
                                </a>
                            </div>
                            <script type="text/javascript">
                                window.monetateQ.push([ "addProducts", monetateComponentProductList ]);
                                window.monetateQ.push(["trackData"]);
                            </script>
                        </div>
                    </div>
                </div>
                <c:if test="${showVatApplicable eq true}">
                    <div class="row">
                        <div class="vat__text-box h-space-1">
                            <span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color"></span>
                            <spring:theme code="product.vat.applicable"/>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    <div class="js_spinner spinning-div">
        <img class="spinning-image" src="${themeResourcePath}/images/Spinner-1s-75px.gif" alt="Loading..." />
    </div>
    <cart:quantityCartModals/>
    <nav:plpHandlebarsTemplates />
</c:if>






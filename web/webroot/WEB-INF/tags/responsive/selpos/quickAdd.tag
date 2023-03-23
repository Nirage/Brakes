<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="categoryCode" required="true" type="java.lang.String" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="action" tagdir="/WEB-INF/tags/responsive/action" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement" %>
<%@ taglib prefix="selpos" tagdir="/WEB-INF/tags/responsive/selpos"%>



<spring:htmlEscape defaultHtmlEscape="false" />


<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')" >


	<div class="row order-sel__bordered h-space-2">
		<div class="col-xs-12">
			<div class="order-sel__title h-space-2"><spring:theme code="orderSELsAndPOS.sels.section2" /></div>
			<div class="order-sel__title h-space-2"><spring:theme code="orderSELsAndPOS.sels.quickadd" /></div>
			<p class="site-header__subtext h-space-3"><spring:theme code="orderSELsAndPOS.sels.quickadd.description" /></p>

				<input type="hidden" value="/my-country-choice/order-sels-and-pos/autocompleteProduct?categoryCode=${categoryCode}&term=" class="js-productcodeSuggestUrl"/>

				<div class="site-form__section is-active">
					<div class="site-form__section-content">
						<div class="row">
							<div class="col-xs-12 col-sm-6 col-md-6">
								<div class="custom-txtbox">
									<div class="site-form__formgroup form-group js-formGroup">
										<label class="h-space-2 " for=""><spring:theme code="orderSELsAndPOS.input.code" /></label>
										<div class="site-form__inputgroup js-inputgroup">
											<input id="" name="productCode" class="form-control site-form__input order-sel__gap order-sel__input is-optional js-selProductCode" value="" autocomplete="off" placeholder="<spring:theme code="orderSELsAndPOS.sels.placeholder.productcode" />"">
											<input type="hidden" class="js-selProductName"/>
										</div>	
									</div>
								</div>
								<div id= "selProductCodeList" class="order-sel__list">
							</div>

							</div>
							<div class="col-xs-12 col-sm-6 col-md-3">
								<div class="custom-txtbox">
									<div class="site-form__formgroup form-group js-formGroup">
										<label class=" h-space-2 " for=""><spring:theme code="orderSELsAndPOS.sels.header.multiprice"/></label>
										<div class="site-form__inputgroup js-inputgroup">
											<input id=""  class="form-control site-form__input order-sel__gap order-sel__input is-optional js-selMultiPrice" value="" autocomplete="noautocomplete" placeholder="<spring:theme code="orderSELsAndPOS.sels.placeholder.multiPrice" />"">
										</div>	
									</div>
								</div>
							</div>
							<div class="col-xs-12 col-md-3">
									<div class="custom-txtbox">
									<div class="site-form__formgroup form-group js-formGroup">
										<label class="h-space-2 visible-md visible-lg" for=""><spring:theme code="orderSELsAndPOS.sels.header.singleprice" /></label>
										<label class="h-topspace-2 h-space-2 hidden-md hidden-lg" for=""><spring:theme code="orderSELsAndPOS.sels.header.singleprice" /></label>
										<div class="site-form__inputgroup js-inputgroup">
											<input id="" class="form-control site-form__input order-sel__gap order-sel__input is-optional js-selSinglePrice" value="" autocomplete="noautocomplete" placeholder="<spring:theme code="orderSELsAndPOS.sels.placeholder.singlePrice" />"">
										</div>	
									</div>
								</div>
							</div>
						</div>

						<div class="site-form__actions form-actions clearfix h-topspace-2 h-space-1">
							<button type="button" class="btn btn-primary btn-block btn-md js-selEntryConfirm">
								<spring:theme code="orderSELsAndPOS.confirm" />
							</button>
						</div>

					</div>
				</div>
		</div>

	</div>
<selpos:productListHandlebarsTemplate/>


</sec:authorize>



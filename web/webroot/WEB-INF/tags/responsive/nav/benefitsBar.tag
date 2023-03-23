<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<c:set var="indexCount" value="0" />
<div class="benefits-bar">
	<div class="container">
		<div class="row">
			<div class="col-xs-12 col-sm-6 col-sm-offset-3 col-md-12 col-md-offset-0">
				<div class="benefits-bar__list js-benefitsCarousel owl-carousel">
					<cms:pageSlot position="BenefitBar" var="component">
						<div class=" benefits-bar__item">
            				<c:set var="indexCount" value="${indexCount + 1}" />
							<span class="benefits-bar__content ga-benefits-bar-${indexCount}"><cms:component component="${component}"/></span>
						</div>
					</cms:pageSlot>
				</div>
			</div>
		</div>
	</div>
</div>

<script>
	window.benefitsBarCount = ${indexCount} || 1 ;
</script>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@ taglib prefix="customerTools" tagdir="/WEB-INF/tags/responsive/customerTools"%>
<%@ attribute name="calcOneId" required="false" type="java.lang.String"%>
<%@ attribute name="calcTwoId" required="false" type="java.lang.String"%>
<%@ attribute name="calcThreeId" required="false" type="java.lang.String"%>
<%@ attribute name="customCSSClass" required="false" type="java.lang.String"%>

<%-- Calculator One starts --%>
<customerTools:calculatorMenuPriceToCostPrice calcId="${calcOneId}" isActive="true" customCSSClass="${customCSSClass}"/>

<%-- Calculator Two starts --%>
<customerTools:calculatorMenuPriceAndCostPrice calcId="${calcTwoId}" isActive="false" customCSSClass="${customCSSClass}"/>

<%-- Calculator Three starts --%>
<customerTools:calculatorCostPriceToMenuPrice calcId="${calcThreeId}" isActive="false" customCSSClass="${customCSSClass}"/>
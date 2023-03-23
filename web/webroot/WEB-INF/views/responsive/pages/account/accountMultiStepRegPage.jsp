<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="user" tagdir="/WEB-INF/tags/responsive/user"%>

<c:set var="allSteps" value="4" />
<c:set var="singleColumn" value="false" />
 
<c:choose>
	<c:when test="${step eq 'STEP_ONE'}">
		<c:set var="currentStep" value="1" />

		<cms:pageSlot position="StepOne" var="feature">
			<c:if test="${empty feature.amplienceSlotId}"><c:set var="singleColumn" value="true" /></c:if>
		</cms:pageSlot>
	</c:when>
	<c:when test="${step eq 'STEP_TWO'}">
        <c:set var="currentStep" value="2" />
		<cms:pageSlot position="StepTwo" var="feature">
			<c:if test="${empty feature.amplienceSlotId}"><c:set var="singleColumn" value="true" /></c:if>
		</cms:pageSlot>
    </c:when>
    <c:when test="${step eq 'STEP_THREE'}">
          <c:set var="currentStep" value="3" />
		  		<cms:pageSlot position="StepThree" var="feature">
			<c:if test="${empty feature.amplienceSlotId}"><c:set var="singleColumn" value="true" /></c:if>
		</cms:pageSlot>
    </c:when>
    <c:when test="${step eq 'STEP_FOUR'}">
		<c:set var="currentStep" value="4" />
			<cms:pageSlot position="StepFour" var="feature">
			<c:if test="${empty feature.amplienceSlotId}"><c:set var="singleColumn" value="true" /></c:if>
		</cms:pageSlot>
    </c:when>
	<c:otherwise>
		<c:set var="currentStep" value="0" />
	</c:otherwise>
</c:choose>

<template:page pageTitle="${pageTitle}">
	<div class="container container--narrow">
		<div class="row">
			<div class="col-xs-12 ">
				<user:registrationProgressBar currentStep="${currentStep}" totalSteps="${allSteps}" position="top"/>
			</div>
		</div>
		<div class="row">
			<div class="col-xs-12  ${singleColumn ? 'single-column' : 'col-sm-6'}">
				<cms:pageSlot position="MiddleContent" var="feature" element="div" >
					<cms:component component="${feature}"  element="div"/>
				</cms:pageSlot>
			</div>
			<div class="col-xs-12 col-sm-6">
				<div class="registration-media-wrapper">
				<c:if test="${step eq 'STEP_ONE'}">
                    <cms:pageSlot position="StepOne" var="feature" element="div" >
						<cms:component component="${feature}" element="div"/>
                    </cms:pageSlot>
				</c:if>
				<c:if test="${step eq 'STEP_TWO'}">
                    <cms:pageSlot position="StepTwo" var="feature" element="div" >
                         <cms:component component="${feature}"  element="div"/>
                    </cms:pageSlot>
                </c:if>
                <c:if test="${step eq 'STEP_THREE'}">
                    <cms:pageSlot position="StepThree" var="feature" element="div" >
                          <cms:component component="${feature}"  element="div"/>
                    </cms:pageSlot>
                </c:if>
                <c:if test="${step eq 'STEP_FOUR'}">
                    <cms:pageSlot position="StepFour" var="feature" element="div" >
                        <cms:component component="${feature}"  element="div"/>
                    </cms:pageSlot>
                </c:if>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-xs-12">
				<user:registrationProgressBar currentStep="${currentStep}" totalSteps="${allSteps}" position="bottom"/>
			</div>
		</div>
	</div>

	  <user:registrationMultiStepFixedFooter currentStep="${currentStep}" totalSteps="${allSteps}"/>
</template:page>


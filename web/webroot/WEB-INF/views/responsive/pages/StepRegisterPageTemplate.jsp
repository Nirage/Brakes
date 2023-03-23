<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="user" tagdir="/WEB-INF/tags/responsive/user"%>

<c:set var="allSteps" value="4" />

<template:page pageTitle="${pageTitle}">
	<div class="container container--narrow">
		<div class="row">
			<div class="col-xs-12 ">
				<user:registrationProgressBar currentStep="${currentStep}" totalSteps="${allSteps}" position="top"/>
			</div>
		</div>
		<div class="row">
			<div class="col-xs-12 col-sm-6">
				<cms:pageSlot position="MiddleContent" var="feature" element="div" >
					<cms:component component="${feature}"  element="div"/>
				</cms:pageSlot>
			</div>
			<div class="col-xs-12 col-sm-6">
				<div class="registration-media-wrapper">
                    <cms:pageSlot position="StepOne" var="feature" element="div" >
                            <cms:component component="${feature}"  element="div"/>
                    </cms:pageSlot>
                    <cms:pageSlot position="StepTwo" var="feature" element="div" >
                        <cms:component component="${feature}"  element="div"/>
                    </cms:pageSlot>
                    <cms:pageSlot position="StepThree" var="feature" element="div" >
                        <cms:component component="${feature}"  element="div"/>
                    </cms:pageSlot>
                    <cms:pageSlot position="StepFour" var="feature" element="div" >
                        <cms:component component="${feature}"  element="div"/>
                    </cms:pageSlot>
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


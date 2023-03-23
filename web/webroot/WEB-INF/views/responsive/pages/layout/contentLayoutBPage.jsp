<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>

<template:page pageTitle="${pageTitle}">
	<div class="container amp-templatepage amp-templatepage--b">
		<div class="row">
			<div class="col-xs-12">
				<cms:pageSlot position="Section1" var="feature">
					<cms:component component="${feature}" element="div" class=""/>
				</cms:pageSlot>
			</div>
		</div>
		<div class="row ">
			<div class="col-md-8 amp-templatepage__main-content">
				<cms:pageSlot position="Section2A" var="feature" element="div" class="">
					<cms:component component="${feature}"/>
				</cms:pageSlot>
				<cms:pageSlot position="Section2B" var="feature" element="div" class="">
					<cms:component component="${feature}"/>
				</cms:pageSlot>
				<cms:pageSlot position="Section2C" var="feature" element="div" class="">
					<cms:component component="${feature}"/>
				</cms:pageSlot>
				<cms:pageSlot position="Section2D" var="feature" element="div" class="">
					<cms:component component="${feature}"/>
				</cms:pageSlot>
				<cms:pageSlot position="Section2E" var="feature" element="div" class="">
					<cms:component component="${feature}"/>
				</cms:pageSlot>
				<cms:pageSlot position="Section2F" var="feature" element="div" class="">
					<cms:component component="${feature}"/>
				</cms:pageSlot>
				<cms:pageSlot position="Section2G" var="feature" element="div" class="">
					<cms:component component="${feature}"/>
				</cms:pageSlot>
				<cms:pageSlot position="Section2H" var="feature" element="div" class="">
					<cms:component component="${feature}"/>
				</cms:pageSlot>
				<cms:pageSlot position="Section2I" var="feature" element="div" class="">
					<cms:component component="${feature}"/>
				</cms:pageSlot>
			</div>
			<div class="col-md-4">
				<cms:pageSlot position="Section3A" var="feature" element="div" class="">
					<cms:component component="${feature}"/>
				</cms:pageSlot>
				<cms:pageSlot position="Section3B" var="feature" element="div" class="">
					<cms:component component="${feature}"/>
				</cms:pageSlot>
				<cms:pageSlot position="Section3C" var="feature" element="div" class="">
					<cms:component component="${feature}"/>
				</cms:pageSlot>
				<cms:pageSlot position="Section3D" var="feature" element="div" class="">
					<cms:component component="${feature}"/>
				</cms:pageSlot>
				<cms:pageSlot position="Section3E" var="feature" element="div" class="">
					<cms:component component="${feature}"/>
				</cms:pageSlot>
				<cms:pageSlot position="Section3F" var="feature" element="div" class="">
					<cms:component component="${feature}"/>
				</cms:pageSlot>
				<cms:pageSlot position="Section3G" var="feature" element="div" class="">
					<cms:component component="${feature}"/>
				</cms:pageSlot>
				<cms:pageSlot position="Section3H" var="feature" element="div" class="">
					<cms:component component="${feature}"/>
				</cms:pageSlot>
				<cms:pageSlot position="Section3I" var="feature" element="div" class="">
					<cms:component component="${feature}"/>
				</cms:pageSlot>
			</div>
		</div>
	</div>

</template:page>

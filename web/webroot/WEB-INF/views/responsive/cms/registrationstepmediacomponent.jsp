<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="media-component">
    <c:if test="${component.mediaUrl ne ''}">
        <div class="media-component__media">
            <c:choose>  
                <c:when test="${component.mediaType.code eq 'VIDEO'}">
                    <div class="embed-responsive embed-responsive-16by9">
                        <video class="media-component__picture-img img-responsive media-component__video" controls="" width="100%" protocol="https" preload="auto" muted>
                            <source src="${component.mediaUrl}">
                        </video>
                    </div>
                </c:when>
                <c:when test="${component.mediaType.code eq 'YOUTUBE_VIDEO'}">
                    <div class="embed-responsive embed-responsive-16by9 media-component__youtube">
                        <iframe class="embed-responsive-item" src="${component.mediaUrl}?mute=1" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                    </div>
                </c:when>
                <c:when test="${component.mediaType.code eq 'IMAGE'}">
                    <picture class="media-component__picture">
                        <img class="media-component__picture-img img-responsive" src="${component.mediaUrl}" alt="${component.mediaCaption}" title="${component.mediaCaption}" />
                    </picture>
                </c:when>
            </c:choose>
        </div>
    </c:if>

    <c:if test="${component.mediaCaption ne ''}">
        <div class="media-component__caption">
            ${component.mediaCaption}   
        </div>
    </c:if>

    <div class="media-component__html">
        <c:if test="${component.mediaCaptionLink.url ne ''}">
        <a href="${component.mediaCaptionLink.url}" target="_blank" title="">
        </c:if>
            ${component.mediaCaptionLink.linkName}
        <c:if test="${component.mediaCaptionLink.url ne ''}">
        </a>
        </c:if>
    </div>
</div>
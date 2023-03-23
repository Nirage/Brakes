<%@ tag trimDirectiveWhitespaces="true" %>
<%@ attribute name="id" required="false" type="java.lang.String"%>
<%@ attribute name="title" required="false" type="java.lang.String"%>
<%@ attribute name="icon" required="false" type="java.lang.String"%>
<%@ attribute name="width" required="false" type="java.lang.String"%>
<%@ attribute name="customCSSClass" required="false" type="java.lang.String"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Introducing otherClasses, as there is a bug in EL engine which will remove space between two EL expressions
Adding tham to the variable first, solves the issue --%>
<c:set var="otherClasses" value="${width} ${customCSSClass}" />

<div id="${id}" class="modal fade ${not empty title ? 'has-title ': ' '} ${otherClasses}" tabindex="-1" role="dialog">
    <div class="vertical-alignment-helper">
        <div class="modal-dialog vertical-align-center" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="modal-header__inner">
                        <c:if test="${not empty title}">
                            <h4 class="modal-title"><c:if test="${not empty icon}"><span class="${icon}"></span></c:if><spring:theme code="${title}"/></h4>
                        </c:if>
                        <c:if test="${empty title}">
                            <h4 class="modal-title js-orderModalMessage hide" data-message="CUTT_OFF"><spring:theme code="text.order.delivery.cutOffTime.popup.title"/></h4>
                            <h4 class="modal-title js-orderModalMessage hide" data-message="STATUS"><spring:theme code="text.order.delivery.status.popup.title"/></h4>
                            <h4 class="modal-title js-orderModalMessage hide" data-message="ORDER_LOCK"><spring:theme code="text.order.delivery.orderLock.popup.title"/></h4>
                            <h4 class="modal-title js-orderModalMessage hide" data-message="UNSUBMITTED"><spring:theme code="text.order.delivery.unsubmitted.popup.title" /></h4>
                        </c:if>
                        <button type="button" class="icon icon-close modal-header__close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true"></span></button>
                    </div>
                </div>
                <div class="modal-body">
                    <%-- Modal content --%>
                    <jsp:doBody/>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div>
</div><!-- /.modal -->


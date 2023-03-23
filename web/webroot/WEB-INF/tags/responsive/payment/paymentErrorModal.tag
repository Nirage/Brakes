<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>



<components:modal id="paymentErrorModal">
    <div class="row">
        <h2 class="site-header__text site-header--align-left "><spring:theme code="mydetails.payment.error.title"></spring:theme></h2>
    </div>
    <div class="text-center">
        <a class="btn btn-primary h-space-3 h-topspace-2" data-dismiss="modal" tabindex="0" title="<spring:theme code="mydetails.payment.error.close"></spring:theme>"><spring:theme code="mydetails.payment.error.close"></spring:theme></a>
    </div>    
</components:modal>

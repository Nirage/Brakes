<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme" %>

<div class="container">
    <div class="flex justify-content-center align-items-center flex-direction-column" style="height: 300px">
        <div id="onload-loading"
            class="hide" 
            data-body-message="<spring:theme code='help.success.redirect.msg'/>"
            data-error-message="<spring:theme code='single.signon.error.msg'/>"
            data-href="/sfCloudInstance/status"
            data-back-to-home="<spring:theme code='header.back.to.homepage'/>"
            data-no-new-tab
        ></div>
    </div>
</div>
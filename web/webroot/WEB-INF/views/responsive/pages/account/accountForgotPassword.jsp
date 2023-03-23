<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="user" tagdir="/WEB-INF/tags/responsive/user" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>


<c:url value="/forgot-password" var="forgotPasswordUrl"/>


<div class="row">
    <div class="col-md-6 col-sm-8 col-sm-offset-2 col-md-offset-3">
        <div class="login">
            <div class="login__wrapper">
                <user:forgotpassword actionNameKey="login.forgotpassword" action="${forgotPasswordUrl}"/>
            </div>
        </div>
    </div>
</div>



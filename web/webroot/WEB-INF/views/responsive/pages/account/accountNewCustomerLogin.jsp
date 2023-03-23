
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="user" tagdir="/WEB-INF/tags/responsive/user" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>


<c:url value="/j_spring_security_check" var="loginActionUrl"/>


<div class="row">
    <div class="col-md-12">
        <div class="login">
            <div class="login__wrapper">
                <user:login actionNameKey="login.login" action="${loginActionUrl}"/>
                <user:gotoRegister actionNameKey="login.login" action="${loginActionUrl}"/>
            </div>
        </div>
    </div>
</div>
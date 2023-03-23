
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div style="background-image: url('${backgroundImage.url}');background-size:cover;background-position-x:center;background-position-y:center;" class="${fn:toLowerCase(fn:replace(page, '.jsp', ''))} container-fluid js-bgImageComponent" >
    <div >
        <c:import charEncoding="UTF-8" url="${page}" />
    </div>
</div>

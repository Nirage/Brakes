<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<div class="page-${fn:toLowerCase(fn:replace(page.uid, '.jsp', ''))}">
  <div style="background-image: url('${backgroundImage}');background-size:cover;background-position-x:center;background-position-y:center;" class="container-fluid backgroundimage-component js-bgImageComponent" >
    <div class="content-wrapper">
      <c:forEach var="component" items="${components}">
        <cms:component component="${component}" />
      </c:forEach>
    </div>
  </div>
</div>


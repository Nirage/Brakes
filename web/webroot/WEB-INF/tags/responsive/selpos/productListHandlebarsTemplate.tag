<%@ tag trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>


<script id="sel-productCode-list-template" type="text/x-handlebars-template">
  {{#each this}}
    <div class="order-sel__listitem">
      <a class="js-listCode"><span class="js-listCodeVal">{{code}}</span><span>- {{name}}</span></a>
    </div>
  {{/each}}
</script>

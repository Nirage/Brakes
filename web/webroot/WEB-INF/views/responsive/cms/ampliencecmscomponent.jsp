<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${not empty amplienceSlotId}">
  <div class="js-amplienceSlot container" data-amplience-id="${amplienceSlotId}"></div>
</c:if>
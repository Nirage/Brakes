<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>



<components:modal id="addPaymentCardModal" title="Card details">
 
     <div class="text-center b2b-payment-iframe__container">
     	<iframe src="${iframeURL}" id="paymentIframe" >
     	</iframe>	
     </div>
         
    
</components:modal>




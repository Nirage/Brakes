

<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ attribute name="productListing" required="true" type="java.lang.Object"%>


<c:if test="${cmsPage.uid eq 'productDetails'}">
  <c:if test="${fn:length(productListing) eq 1 }">
  <script>
    window.productListObject = [
      {
        id: '<c:if test="${not empty productListing[0].prefix}">${productListing[0].prefix}</c:if>${productListing[0].code}',
        <c:if test="${not empty productListing[0].sapProductCode}">sapProductCode: '<c:out value="${productListing[0].sapProductCode}" escapeXml="true"/>',</c:if>
        name: '<c:out value="${productListing[0].name}" escapeXml="true"/>',
          <c:if test="${productListing[0].estimatedPrice != null}">
            price: '${productListing[0].estimatedPrice.value}',
          </c:if>
          <c:if test="${productListing[0].estimatedPrice == null}">
            price: '${productListing[0].price.value}',
          </c:if>
        <c:if test="${not empty productListing[0].manufacturer}">brand: '<c:out value="${productListing[0].manufacturer}" escapeXml="true"/>',</c:if>
        <c:if test="${not empty productListing[0].categories}">category: '<c:forEach items="${productListing[0].categories}" var="category" varStatus="loop">
                      <c:out value="${category.name}" escapeXml="true"/><c:if test="${!loop.last}">_</c:if>
                  </c:forEach>',</c:if>
      }
    ];
    </script>
  </c:if>
</c:if>

<c:if test="${cmsPage.uid eq 'favouriteItemGrid'}">
  <c:if test="${fn:length(productListing) ge 1 }">
    <script type="text/javascript">

      window.productListObject = [<c:forEach var="prodItem" items="${productListing}"> 
      {
        id: '<c:if test="${not empty prodItem.product.prefix}">${prodItem.product.prefix}</c:if>${prodItem.product.code}',
        <c:if test="${not empty prodItem.product.sapProductCode}">sapProductCode: '<c:out value="${prodItem.product.sapProductCode}" escapeXml="true"/>',</c:if>
        name: '<c:out value="${prodItem.product.name}" escapeXml="true"/>',
          <c:if test="${prodItem.product.estimatedPrice != null}">
            price: '${prodItem.product.estimatedPrice.value}',
          </c:if>
          <c:if test="${prodItem.product.estimatedPrice == null}">
          price: '${prodItem.product.price.value}',
          </c:if>
        <c:if test="${not empty prodItem.product.manufacturer}">brand: '<c:out value="${prodItem.product.manufacturer}" escapeXml="true"/>',</c:if>
        <c:if test="${not empty prodItem.product.categories}">category: '<c:forEach items="${prodItem.product.categories}" var="category" varStatus="loop">
                      <c:out value="${category.name}" escapeXml="true"/><c:if test="${!loop.last}">_</c:if>
                  </c:forEach>',</c:if>
      },
      </c:forEach>];
      
    </script>
  </c:if>
</c:if>

<c:if test="${cmsPage.uid ne 'productDetails' && cmsPage.uid ne 'favouriteItemGrid'}">
  <c:if test="${fn:length(productListing) ge 1 }">
    <script type="text/javascript">

      window.productListObject = [<c:forEach var="prodItem" items="${productListing}"> 
      {
        id: '<c:if test="${not empty prodItem.prefix}">${prodItem.prefix}</c:if>${prodItem.code}',
        name: '<c:out value="${prodItem.name}" escapeXml="true"/>',
          <c:if test="${prodItem.estimatedPrice != null}">
              price: '${prodItem.estimatedPrice.value}',
          </c:if>
          <c:if test="${prodItem.estimatedPrice == null}">
              price: '${prodItem.price.value}',
          </c:if>
        <c:if test="${not empty prodItem.manufacturer}">brand: '<c:out value="${prodItem.manufacturer}" escapeXml="true"/>',</c:if>
        <c:if test="${not empty prodItem.categories}">category: '<c:forEach items="${prodItem.categories}" var="category" varStatus="loop">
                      <c:out value="${category.name}" escapeXml="true"/><c:if test="${!loop.last}">_</c:if>
                  </c:forEach>',</c:if>
      },
      </c:forEach>];
      
    </script>
  </c:if>
</c:if>
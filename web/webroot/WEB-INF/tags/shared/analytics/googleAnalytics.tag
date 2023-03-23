<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="analytics" tagdir="/WEB-INF/tags/shared/analytics" %>

<%--  Product Listing for JS layer --%>
<c:if test="${cmsPage.uid ne 'favouriteItemGrid' && cmsPage.uid ne 'orders'}">
  <analytics:googleAnalyticsProducts productListing="${searchPageData.results}"/>
</c:if>

<!--  Determination of enhanced flag based on page   -->
<!-- Analytics calculation of dynamic variables -->
<c:choose>
         <c:when test="${cmsPage.uid == 'orderConfirmationPage' && empty gaEvent}">
                <c:set var="enhanced" value="1"/>
         		<c:set var="page" value="transaction"/>
         		<c:set var="event" value="dataLoaded"/>
         </c:when>
         <c:when test="${(cmsPage.uid eq 'productGrid' || cmsPage.uid eq'searchGrid') && empty gaEvent}">
            <c:if test="${cmsPage.uid eq 'productGrid'}">
                <c:set var="page" value="PLP"/>
            </c:if>
            <c:if test="${cmsPage.uid eq 'searchGrid'}">
                  <c:set var="page" value="SRP"/>
            </c:if>
            <c:set var="plpUrl" value="${requestScope['javax.servlet.forward.servlet_path']}?${requestScope['javax.servlet.forward.query_string']}"/>
            <c:if test = "${fn:contains(plpUrl, 'sort=') || fn:contains(plpUrl, 'q=')}">
                   <c:set var="vpvUrl" value="${plpUrl}"/>
            </c:if>
            <c:set var="event" value="dataLoaded"/>
            <c:set var="enhanced" value="0"/>
         </c:when>
         <c:when test="${cmsPage.uid eq 'productDetails' && empty gaEvent}">
          <c:choose>
            <c:when test="${userStatus eq 'logged in'}">
              <c:set var="enhanced" value="0"/>
            </c:when>
            <c:otherwise>
              <c:set var="enhanced" value="1"/>
            </c:otherwise>
          </c:choose>
          <c:set var="page" value="PDP"/>
          <c:set var="event" value="dataLoaded"/>
         </c:when>
         <c:when test="${cmsPage.uid eq 'checkoutPage' && empty gaEvent}">
           <c:set var="enhanced" value="1"/>
           <c:set var="page" value="Checkout"/>
           <c:set var="event" value="dataLoaded"/>
         </c:when>
         <c:when test="${not empty gaEvent}">
                 <c:set var="enhanced" value="1"/>
                 <c:set var="event" value="ga_event"/>
         </c:when>
         <c:otherwise>
               <c:set var="enhanced" value="0"/>
               <c:set var="page" value="${cmsPage.uid}"/>
               <c:set var="event" value="dataLoaded"/>
         </c:otherwise>
</c:choose>

<c:set var="orderCode" value="${ycommerce:encodeJavaScript(orderData.code)}"/>


<c:choose>
  <c:when test="${fn:escapeXml(gaCategory) eq 'add to basket' || fn:escapeXml(gaCategory) eq 'remove from basket' || not empty clearedCart}">
    <c:set var="isActionable" value="true" />
  </c:when>
  <c:otherwise>
    <c:set var="isActionable" value="false"/>
  </c:otherwise>
</c:choose>

<script type="text/javascript">
window.dataLayer = window.dataLayer || [];
window.dataLayer.push({
	 'event': '${event}',
	 'enhanced': ${enhanced},
	  'user': {
		  'status': '${userStatus}',
		  'id': '${user.unit.uid}',
		  'type':  '<c:forEach items="${userGroups}" var="group" varStatus="loop">
                               <c:out value="${group.name}" /><c:if test="${!loop.last}">,</c:if>
                       </c:forEach>'
			 }
		   <c:if test="${event eq 'dataLoaded'}">
		   ,
          'page': {
                      'type': '${page}'
                      <c:choose>
                         <c:when test="${page eq 'PLP'}">
                          <c:if test="${not empty searchPageData.pagination.currentPage}">
                            ,
                              'number': ${searchPageData.pagination.currentPage}       
                          </c:if>
                            ,
                            'searchTerm': '${fn:replace(searchPageData.freeTextSearch, "&#x20;", " ")}',
                            'vpv': '${vpvUrl}'
                         </c:when>
                         <c:when test="${page eq 'SRP'}">
                            <c:if test="${not empty searchPageData.pagination.currentPage}">
                            ,
                              'number': ${searchPageData.pagination.currentPage}
                            
                            </c:if>
                            <c:if test="${empty vpvUrl}">
                              ,
                              'searchTerm': '${fn:replace(searchPageData.freeTextSearch, "&#x20;", " ")}'
                            </c:if>
                            <c:if test="${not empty vpvUrl}">
                              ,
                              'vpv': '${vpvUrl}'
                            </c:if>
                          </c:when>
                         <c:when test="${page eq 'PDP'}">
                          ,
                            'number':1,
                            'searchTerm': '${searchTerm}'
                         </c:when>
                      </c:choose>
                  }
                </c:if>
                <c:if test="${event eq 'ga_event'}">
                                 ,
                                 'ga_event' : {
                                    'category': '${fn:escapeXml(gaCategory)}',
                                    'action': <c:choose>
                                                  <c:when test="${cmsPage.uid eq 'cartPage' && not empty clearedCart}">
                                                     'basket',
                                                  </c:when>
                                                  <c:when test="${cmsPage.uid ne 'cartPage' && not empty clearedCart}">
                                                     'mini basket',
                                                   </c:when>
                                                  <c:otherwise>
                                                     '${fn:escapeXml(gaAction)}',
                                                  </c:otherwise>
                                               </c:choose>
                                    'label': "${fn:escapeXml(gaLabel)}",
                                    'value':0,
                                    'nonInteraction':0
                                  }
                </c:if>
	    <c:choose>
		<c:when test="${pageType == 'ORDERCONFIRMATION'}">
                 			 ,
                 			 'ecommerce': {
                 				    'currencyCode': '${orderData.totalPrice.currencyIso}',
                 				    'purchase': {
                 				        'actionField': {
                 				          'id': '${orderCode}',
                 				          'revenue': '${orderData.totalPriceWithTax.value}',
                 				          'tax':'${orderData.totalTax.value}',

                 				        },

                 				        'products': [ <c:forEach items="${orderData.entries}" var="item" varStatus="productLoop">
                                                        {
                                                        'id': '${item.product.prefix}${item.product.code}',
                                                         'name': '${fn:replace(item.product.name, '\'', '\\\'')}',
                                                         'price': '${item.basePrice.value}',
                                                         'brand': '${fn:replace(item.product.manufacturer, '\'', '\\\'')}',
                                                         'category': '<c:forEach items="${item.product.categories}" var="category" varStatus="loop">
                                                                                                     <c:out value="${category.name}" escapeXml="true"/><c:if test="${!loop.last}">_</c:if>
                                                                                             </c:forEach>',
                                                         'quantity': '${item.quantity}',
                                                         'dimension5':'${item.dimension5}'
                                                       }
                                                     <c:if test="${not empty item.linkedPromoEntry}">
                                                        ,
                                                         {
                                                            'id': '${item.linkedPromoEntry.product.prefix}${item.linkedPromoEntry.product.code}',
                                                             'name': '${fn:replace(item.linkedPromoEntry.product.name, '\'', '\\\'')}',
                                                             'price': '${item.linkedPromoEntry.totalPrice.value}',
                                                             'brand': '${fn:replace(item.linkedPromoEntry.product.manufacturer, '\'', '\\\'')}',
                                                             'category': '<c:forEach items="${item.linkedPromoEntry.product.categories}" var="category" varStatus="loop">
                                                                                                         <c:out value="${category.name}" escapeXml="true"/><c:if test="${!loop.last}">_</c:if>
                                                                                                 </c:forEach>',
                                                             'quantity': '${item.linkedPromoEntry.quantity}',
                                                             'dimension5':'${item.linkedPromoEntry.dimension5}'
                                                           }
                                                     </c:if>

                 				             <c:if test="${!productLoop.last}">,</c:if>
                 				           </c:forEach>
                 				        ]
                 				    }
                 		     }
         </c:when>
         <c:when test="${cmsPage.uid eq 'checkoutPage' && isActionable eq false}">
         			 ,
         			 'ecommerce': {
         				    'currencyCode': '${cartData.totalPrice.currencyIso}',
         				    'checkout': {
         				        'actionField': {
         				          'step': 1
         				        },

         				        'products': [ <c:forEach items="${cartData.entries}" var="item" varStatus="productLoop">
         				            {
         				        	'id': '${item.product.prefix}${item.product.code}',
         				        	 'name': "${fn:escapeXml(item.product.name)}",
         				        	 'price': '${item.basePrice.value}',
         				             'brand': '${fn:escapeXml(item.product.manufacturer)}',
         				             'category': '<c:forEach items="${item.product.categories}" var="category" varStatus="loop">
                                                                                 <c:out value="${category.name}" escapeXml="true"/><c:if test="${!loop.last}">_</c:if>
                                                                         </c:forEach>',
         				             'quantity': '${item.quantity}'
         				           }
         				             <c:if test="${!productLoop.last}">,</c:if>
         				           </c:forEach>
         				        ]
         				    }
         			 }
           </c:when>
           <c:when test="${cmsPage.uid eq 'cartPage' && isActionable eq false}">
         			 ,
         			 'ecommerce': {
         				    'currencyCode': '${cartData.totalPrice.currencyIso}',
         				    'details': {
         				        'products': [ <c:forEach items="${cartData.entries}" var="item" varStatus="productLoop">
         				            {
         				        	'id': '${item.product.prefix}${item.product.code}',
         				        	 'name': "${fn:escapeXml(item.product.name)}",
         				        	 'price': '${item.basePrice.value}',
         				             'brand': '${fn:escapeXml(item.product.manufacturer)}',
         				             'category': '<c:forEach items="${item.product.categories}" var="category" varStatus="loop">
                                                                                 <c:out value="${category.name}" escapeXml="true"/><c:if test="${!loop.last}">_</c:if>
                                                                         </c:forEach>',
         				             'quantity': '${item.quantity}'
         				           }
         				             <c:if test="${!productLoop.last}">,</c:if>
         				           </c:forEach>
         				        ]
         				    }
         			 }
           </c:when>
           <c:when test="${cmsPage.uid eq 'productDetails' && userStatus ne 'logged in'}">
                     			 ,
                     			 'ecommerce': {
                     				    'currencyCode': '${product.price.currencyIso}',
                     				        'detail': { 'products': [
                                                  {
                                                  'id': '${product.prefix}${product.code}',
                                                    'name': "${fn:escapeXml(product.name)}",
                                                    'price': '${product.price.value}',
                                                    'brand': '${fn:escapeXml(product.manufacturer)}',
                                                    'category': '<c:forEach items="${product.categories}" var="category" varStatus="loop">
                                                                  <c:out value="${category.name}" escapeXml="true"/><c:if test="${!loop.last}">_</c:if>
                                                                </c:forEach>'
                                                  }
                                                ]
                     				                }
                     				        }
            </c:when>
          <c:when test="${fn:escapeXml(gaCategory) eq 'add to basket'}">
                          ,
                          'ecommerce': {
                              'currencyCode': '${cartData.totalPrice.currencyIso}',
                                'add': {
                                        'products':
                                                    [ <c:forEach items="${cartData.entries}" var="item" varStatus="productLoop">
                                                                    <c:if test="${item.product.code eq productCode}">
                                                                      {
                                                                      'id': '${item.product.prefix}${item.product.code}',
                                                                        'name': "${fn:escapeXml(item.product.name)}",
                                                                        'price': '${item.basePrice.value}',
                                                                        'brand': '${fn:escapeXml(item.product.manufacturer)}',
                                                                        'category': '<c:forEach items="${item.product.categories}" var="category" varStatus="loop">
                                                                                                                    <c:out value="${category.name}" escapeXml="true"/><c:if test="${!loop.last}">_</c:if>
                                                                                                            </c:forEach>',
                                                                        'quantity': '${qty}'
                                                                      }
                                                                      <c:if test="${!productLoop.last}">,</c:if>
                                                                    </c:if>
                                                                  </c:forEach>
                                                      ]
                                      }
                                }
            </c:when>
            <c:when test="${fn:escapeXml(gaCategory) eq 'remove from basket'}">
                                 			 ,
                                 			 'ecommerce': {
                                 				    'currencyCode': '${cartData.totalPrice.currencyIso}',
                                 				     'remove': {
                                 				              'products':
                                 				                          [
                                                                              <c:if test="${not empty removedProduct}">
                                                                                {
                                                                                'id': '${removedProduct.prefix}${removedProduct.code}',
                                                                                 'name': "${fn:escapeXml(removedProduct.name)}",
                                                                                 'price': '${productPrice}',
                                                                                 'brand': '${fn:escapeXml(removedProduct.manufacturer)}',
                                                                                 'category': '<c:forEach items="${removedProduct.categories}" var="category" varStatus="loop">
                                                                                                                             <c:out value="${category.name}" escapeXml="true"/><c:if test="${!loop.last}">_</c:if>
                                                                                                                     </c:forEach>',
                                                                                 'quantity': '${qty}'
                                                                               }
                                                                              </c:if>

                                 				                            ]
                                 				            }
                                 				     }
            </c:when>
            <c:when test="${not empty clearedCart}">
                         ,
                         'ecommerce': {
                                'currencyCode': '${clearedCart.totalPrice.currencyIso}',
                                 'remove': {
                                          'products':
                                                      [ <c:forEach items="${clearedCart.entries}" var="item" varStatus="productLoop">
                                                            {
                                                            'id': '${item.product.prefix}${item.product.code}',
                                                             'name': "${fn:escapeXml(item.product.name)}",
                                                             'price': '${item.basePrice.value}',
                                                             'brand': '${fn:escapeXml(item.product.manufacturer)}',
                                                             'category': '<c:forEach items="${item.product.categories}" var="category" varStatus="loop">
                                                                                                          <c:out value="${category.name}" escapeXml="true"/><c:if test="${!loop.last}">_</c:if>
                                                                                                  </c:forEach>',
                                                             'quantity': '${item.quantity}'
                                                           }
                                                             <c:if test="${!productLoop.last}">,</c:if>
                                                           </c:forEach>
                                                      ]
                                        }
                                 }
             </c:when>
		</c:choose>
		});
</script>
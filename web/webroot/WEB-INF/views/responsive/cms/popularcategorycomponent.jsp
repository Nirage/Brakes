<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components" %>




<div class="content">
	<div class="site-component">
		<div class="container">
			<div class="row">
				<div class="col-xs-12">
					<components:siteheader headerText="${component.title}"/>
				</div>
			</div>
			<div class="row">
				<div class="col-xs-12">
					<ul class="categories-list inline-list row text-center">
						<c:forEach items="${component.categories}" var="category" >
							<li class="categories-list__item col-xs-12 col-sm-4 col-md-2">
								<components:categoryTile category="${category}" categoryUrl="${categoryUrlMap[category.code]}"/>
							</li>
						</c:forEach>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>






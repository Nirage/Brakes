<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<div class="global-alerts">
    <div class="alert alert-info alert-dismissable hide js-productDeletedAlert h-topspace-2">
        <button class="close" aria-hidden="true" data-dismiss="alert" type="button">
            <span class="icon icon-close icon--sm"></span>
        </button>
        <span class="icon icon-tick alert__icon alert__icon--info"></span>
        <span class="alert__text ">
            <spring:theme code="product.deleted.success" />
        </span>
    </div>
</div>
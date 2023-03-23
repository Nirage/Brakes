<script setup lang="ts">
interface Props {
  name: string;
  code: string;
  url: string;
  cartEntry?: object;
  isOutOfStock: boolean;
  isDiscontinued: boolean;
  isLoggedIn: boolean;
  CSRFToken: string;
  messageUpdate?: string;
  messageOutOfStock?: string;
  messageDiscontinued?: string;
  messageAdd?: string;
}

defineProps<Props>();
</script>

<template>
  <div class="addtocart">
    <div class="actions-container-for-SearchResultsGrid">
      <div class="SearchResultsGrid-ListPickUpInStoreAction" data-index="1"></div>

      <div class="SearchResultsGrid-ListAddToCartAction" data-index="2">
        <input type="hidden" id="cartLargeQuantity" value="100" />
        <input type="hidden" id="cartMaximumQuantity" value="999" />

        <input type="hidden" value="false" class="js-cartViewPromotion" />

        <form :id="`addToCartForm${code}`" :data-id="code" class="cart__add add_to_cart_form js-addToCartForm" action="/cart/add" method="post">
          <input type="hidden" name="productCodePost" :value="code" />
          <input type="hidden" name="entryNumber" value="" />
          <input type="hidden" name="productNamePost" :value="name" />
          <input type="hidden" name="productPostPrice" value="" />
          <input type="hidden" name="qty" class="js-productCartQty" value="0" />
          <input type="hidden" name="productCartQty" class="js-productCartQty" value="0" />
          <input type="hidden" name="CSRFToken" :value="CSRFToken" />

          <div class="js-productQtyUpdate quantity-update cart__quantity col-xs-12 col-sm-12">
            <button
              type="button"
              class="btn btn-success quantity-update__btn quantity-update__btn--minus icon icon-minus js-qtyBtn"
              data-action="remove"
              aria-label="Remove from cart"
            ></button>
            <input
              class="quantity-update__input js-productQtyInput"
              type="number"
              inputmode="numeric"
              aria-label="Quantity"
              value="1"
              min="0"
              max="1000"
            />
            <button
              type="button"
              class="btn btn-success quantity-update__btn icon quantity-update__btn--plus icon-plus js-qtyBtn"
              data-action="add"
              aria-label="Add to cart"
            ></button>
          </div>
          <button
            v-if="isLoggedIn"
            type="button"
            :disabled="cartEntry || isOutOfStock || isDiscontinued ? true : false"
            class="col-xs-12 btn btn-primary btn-block js-addToCartBtn js-qtyChangeBtn cart__add-button"
            data-action="add"
            :data-product-code="code"
          >
            <span v-if="cartEntry">{{ messageUpdate }}</span>
            <span v-else-if="isOutOfStock">{{ messageOutOfStock }}</span>
            <span v-else-if="isDiscontinued">{{ messageDiscontinued }}</span>
            <span v-else>{{ messageAdd }}</span>
          </button>
          <button v-else type="button" class="js-displayLoginPopup col-xs-12 cart__add-button btn btn-primary btn-block">{{ messageAdd }}</button>
        </form>
        <form :id="`configureForm${code}`" class="configure_form" :action="`${url}/configuratorPage/`" method="get"></form>

        <div id="discontinuedInfo" class="discontinued__info js-discontinuedInfoSection hide">
          <button class="close js-discontinuedClose" aria-hidden="true" type="button">
            <span class="icon icon-close icon--sm"></span>
          </button>
          <div class="discontinued__infoSection">
            <p class="discontinued__infoTitle">Sorry! We don't stock this anymore.</p>
            <div class="discontinued__infoContent h-space-2">
              This product has been discontinued from the Brakes range. Click below to see alternatives
            </div>
          </div>
        </div>

        <div id="discontinuedInfo" class="discontinued__info discontinued__info__noPadding js-outOfStockInfoSection hide">
          <button class="close js-outOfStockClose" aria-hidden="true" type="button">
            <span class="icon icon-close icon--sm"></span>
          </button>
          <div class="discontinued__infoSection">
            <p class="discontinued__sectionTitle">This product is temporarily unavailable</p>
            <div class="discontinued__infoContent h-space-2">This product is temporarily unavailable,check back soon to order later.</div>
          </div>
        </div>
      </div>

      <div class="SearchResultsGrid-ListOrderFormAction" data-index="3"></div>
    </div>
  </div>
</template>

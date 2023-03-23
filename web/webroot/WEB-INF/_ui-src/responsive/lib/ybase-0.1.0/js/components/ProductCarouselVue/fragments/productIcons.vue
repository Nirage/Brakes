<script setup lang="ts">
interface Props {
  code: string;
  hasPotentialPromo: boolean;
  newProduct: boolean;
}

const productData = defineProps<Props>();
</script>

<template>
  <div class="product-item__icons product-item__icons--top">
    <div
      :class="`item-icons item-icons--promo item-icons--first ${productData.hasPotentialPromo ? '' : 'hidden'} js-productPromoIcon`"
      :data-code="productData.code"
    >
      <span :data-code="productData.code" class="badge badge--promotion">Offer</span>
    </div>
    <div
      v-if="productData.newProduct"
      :class="`item-icons item-icons--new ${productData.hasPotentialPromo ? 'item-icons--second' : 'item-icons--first'}`"
    >
      <span class="icon icon-new icon-new--royal-blue"></span>
    </div>
    <div class="item-icons item-icons--user-actions text-right js-userActions">
      <div class="add-to-favourites js-displayWishlist" :data-product-id="productData.code">
        <!-- <a href="/sign-in"> -->
        <span class="icon icon-Heart js-wishlistIcon" title="Add to favourites"></span>
        <!-- </a> -->
      </div>
      <div class="js-productWishlistHolder product-wishlist-holder"></div>
    </div>
  </div>
</template>

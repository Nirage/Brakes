<script setup lang="ts">
interface Props {
  images?: Array<any>;
  name: string;
}

const product = defineProps<Props>();
const imageUrl = product.images ? product.images[0]?.url : 'https://i1.adis.ws/i/Brakes/image-not-available';
</script>

<template>
  <picture class="product-item__picture">
    <source data-size="desktop" :srcset="`${imageUrl}?fmt=webp&$plp-desktop$`" media="(min-width: 1240px)" type="image/webp" />
    <source data-size="tablet" :srcset="`${imageUrl}?fmt=webp&$plp-tablet$`" media="(min-width: 768px)" type="image/webp" />
    <source data-size="mobile" :srcset="`${imageUrl}?fmt=webp&$plp-mobile$`" type="image/webp" />
    <img
      class="product-item__image product-image lazyload"
      :src="`${imageUrl}$plp-tablet$`"
      :alt="product.name"
      :title="product.name"
      width="213"
      height="142"
    />
  </picture>
</template>

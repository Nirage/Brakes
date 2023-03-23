<script setup lang="ts">
import 'lazysizes';

interface Props {
  lazyImageData: {
    prop: string;
    url: string;
  };
}

const props = defineProps<Props>();
const data = props.lazyImageData;
</script>

<template>
  <picture class="product-item__picture flex position-absolute">
    <source data-size="desktop" :data-srcset="`${data.url}?$ca-card-desktop$&amp;fmt=webp`" media="(min-width: 1240px)" />
    <source data-size="tablet" :data-srcset="`${data.url}?$ca-card-tablet$&amp;fmt=webp`" media="(min-width: 768px)" />
    <source data-size="mobile" :data-srcset="`${data.url}?$ca-card-mobile$&amp;fmt=webp`" />
    <img
      data-sizes="auto"
      class="product-item__image product-image lazyload"
      :data-src="`${data.url}?$ca-card-desktop$`"
      alt="Award-winning food"
      title="Award-winning food"
    />
    <span class="loader__image"></span>
  </picture>
</template>

<script setup lang="ts">
interface Props {
  name: string;
  code: string;
  url: string;
  prefix: string;
  productInfoIcons?: [];
}

const product = defineProps<Props>();
</script>

<template>
  <div class="product-item__info">
    <div class="product-item__code">
      <a :href="product.url" :title="product.name">{{ product.prefix }}&nbsp;{{ product.code }}</a>
    </div>
    <div class="product-item__advice-icons text-right">
      <span v-for="infoIcons in product.productInfoIcons" :key="infoIcons" title="">
        <img :src="`https://brakes.a.bigcontent.io/v1/static/icon-${infoIcons}`" :alt="`icon-${infoIcons}`" class="product-item__advice-icons-img" />
      </span>
    </div>
  </div>
</template>

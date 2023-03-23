<script setup lang="ts">
import { ref, onMounted } from 'vue';
import axios from 'axios';

import productItemInformation from './fragments/productItemInformation.vue';
import productIcons from './fragments/productIcons.vue';
import productImage from './fragments/productImage.vue';
import productItemPrice from './fragments/productItemPrice.vue';
import addToCart from './fragments/addToCart.vue';

interface Props {
  sfProductListData: {
    id: string;
    url: string;
    heading: string;
    paragraph: string;
    maxNumberOfProducts?: number;
    notPlp?: boolean;
    messageUpdate?: string;
    messageOutOfStock?: string;
    messageDiscontinued?: string;
    messageAdd?: string;
    currencySymbol: string;
    isLoggedIn: boolean | null;
    CSRFToken: string;
  };
}

const productList = defineProps<Props>();
const props = productList.sfProductListData;
const params = new URLSearchParams({'url': window.location.href});
const results = ref([]);
const getResults = async () => {
  try {
    const { data } = await axios.get(props.url, { params: params });
    results.value = data.results.slice(0, props.maxNumberOfProducts ? props.maxNumberOfProducts : 6);
    const arrayOfProductCodes = results.value.map((product) => {
      return product.sapProductCode ? product.sapProductCode : product.code;
    });
    ACC.productprice?.getPrices(arrayOfProductCodes);
  } catch (error) {
    console.log(error);
  }
};

onMounted(() => getResults());
</script>

<template>
  <div
    v-if="results.length"
    :id="props.id"
    class="vue-sf-product-list flex justify-content-center align-items-center flex-direction-column suggestions"
  >
    <h2 v-if="props.heading" class="site-header__text site-header__text--underline site-header__text--underline-middle">
      {{ props.heading }}
    </h2>
    <p v-if="props.paragraph" class="site-header__subtext">{{ props.paragraph }}</p>
    <div class="product__listing product__listing--suggestions product__grid js-plpGrid full-width">
      <div v-for="product in results" :key="product.code" class="product-item--noborder js-productItem js-product col-xs-6 col-sm-4 col-md-2">
        <div class="similar__btn js-similarBtnParent"></div>
        <div
          :class="`product-item--border js-productItemBorder ${product.hasPotentialPromo ? 'product-item--promotion-border overflow-hide' : ''} ${
            product.isDiscontinued || product.isOutOfStock ? 'product-item--discontinued' : ''
          }`"
          :data-code="product.code"
        >
          <productIcons v-bind="product" :hasPotentialPromo="product.hasPotentialPromo" :newProduct="product.newProduct" />
          <a :href="product.url" class="product-item__thumb" :title="product.name">
            <productImage v-bind="product" />
          </a>
          <productItemInformation v-bind="product" />
          <a :href="product.url" class="product-item__name product-name elipsis-3-line">
            {{ product.name }}
          </a>
          <div class="product-item__qty">{{ props.notPlp ? `Case Quantity: ${product.unitsPerCase}` : 'Sponsored Listing' }}</div>
          <productItemPrice v-bind="product" :currencySymbol="props.currencySymbol" />
          <div class="product-item__size">Pack size: {{ product.packSize }}</div>
          <addToCart
            v-bind="product"
            :CSRFToken="props.CSRFToken"
            :isLoggedIn="props.isLoggedIn"
            :messageUpdate="props.messageUpdate"
            :messageOutOfStock="props.messageOutOfStock"
            :messageDiscontinued="props.messageDiscontinued"
            :messageAdd="props.messageAdd"
          />
        </div>
      </div>
    </div>
  </div>
</template>

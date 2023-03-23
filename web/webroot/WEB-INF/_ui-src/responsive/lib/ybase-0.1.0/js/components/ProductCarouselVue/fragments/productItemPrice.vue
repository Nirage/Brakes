<script setup lang="ts">
interface Props {
  name: string;
  code: string;
  wasPrice?: any;
  potentialPromotions?: boolean;
  sapProductCode: string;
  pricePerDivider?: number;
  estimatedPrice?: number;
  subjectToVAT: boolean;
  currencySymbol: string;
  unitPriceDescriptor: string;
}

const product = defineProps<Props>();
</script>

<template>
  <div :class="`product-item__price js-productItemPrice ${product.wasPrice ? 'has-was-price' : ''}`">
    <div v-if="product.potentialPromotions" class="promo">Promotion</div>
    <div class="product-price product-price--current-price">
      <div
        class="js-loadPrice product-price--load-price__wrapper"
        :data-product-code="product.sapProductCode ? product.sapProductCode : product.code"
        :data-price-per-divider="product.pricePerDivider"
      >
        <div class="js-loadWasPrice product-price product-price--was-price hidden">
          <span class="product-price__value product-price__value--was-price">
            <span class="js-loadWasPriceValue"></span>
          </span>
          <span class="product-price__value product-price__value--was-price hidden">
            <span class="js-loadWasPriceValueEach"></span>
          </span>
        </div>
        <span
          :class="`product-price__value product-price__value--current js-loadPriceValue 
                  ${product.estimatedPrice ? 'is-weighted-product' : ''}`"
        >
        </span>
        <span v-if="product.subjectToVAT" class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color hidden js-loadPriceVAT"></span>
        <div :class="`js-loadPriceEach product-price__price-each hidden ${product.estimatedPrice ? 'is-weighted-product' : ''}`">
          <span class="js-productPrice" :title="product.name">
            {{ product.currencySymbol }} <span class="js-unitPrice"></span>
            {{ product.unitPriceDescriptor }}
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import externalLoader from '../ExternalServiceLoader/index.vue';

interface Props {
  loaderData: {
    id: string;
    bodyMessage: string;
    errorMessage: string;
    noNewTab: string;
    backToHome: string;
    url: string;
  };
}

const loader = defineProps<Props>();
const data = loader.loaderData;
</script>

<template>
  <div :id="data.id" :data-body-message="data.bodyMessage" :data-error-message="data.errorMessage" :data-href="data.url">
    <div class="flex justify-content-center align-items-center flex-direction-column position-relative">
      <externalLoader v-bind="data" />
    </div>
  </div>
</template>

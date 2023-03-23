<script setup lang="ts">
import { ref } from 'vue';
import externalLoader from '../ExternalServiceLoader/index.vue';

interface Props {
  popoverData: {
    id: string;
    type: boolean;
    ssoMessage: string;
    helpMessage: string;
    errorMessage: string;
    url: string;
  };
}

const popover = defineProps<Props>();
const data = popover.popoverData;
const show: any = ref<boolean>(true);
const bodyMessage: string = data.type ? data.ssoMessage : data.helpMessage;
const closePopover = (): void => {
  show.value = false;
  document.body?.classList.remove('overflow-hide');
};
</script>

<template>
  <div
    :id="data.id"
    :class="`vue-modal-bg ${show ? '' : 'hide'}`"
    :data-sso-message="data.ssoMessage"
    :data-help-message="data.helpMessage"
    :data-error-message="data.errorMessage"
    :data-href="data.url"
  >
    <div class="vue-modal text-center position-relative">
      <externalLoader v-bind="data" :bodyMessage="bodyMessage" :closePopover="closePopover" />
    </div>
  </div>
</template>

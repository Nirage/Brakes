<script setup lang="ts">
import { ref, onMounted } from 'vue';
import axios from 'axios';

interface Props {
  errorMessage: string;
  bodyMessage: string;
  backToHome?: string;
  noNewTab?: string;
  url: string;
  closePopover?: () => void;
}

const loader = defineProps<Props>();
const icon: any = ref<string>('');
const clickMobileButton = (): void => {
  const mq = window.matchMedia('(min-width: 768px)') as MediaQueryList;
  const mobileMenu = document.querySelector('.js-menu') as HTMLButtonElement;
  if (!mq.matches && mobileMenu?.querySelector('.icon-close')) {
    mobileMenu?.click();
  }
};
const redirectAction = (url: string): void => {
  const redirectWindow = window.open(url, typeof loader.noNewTab === 'string' ? '_self' : '_blank');
  if (redirectWindow) {
    redirectWindow?.location;
  } else {
    window.location.href = url;
  }
  loader.closePopover && loader.closePopover();
};
const generateUrl = async () => {
  clickMobileButton();

  try {
    const { data } = await axios.get(loader.url);
    const { url, error } = data;

    if (url) {
      icon.value = 'success';
      setTimeout(() => redirectAction(url), 1600);
    } else {
      icon.value = 'error';
      if (!error) return;
      console.log('Error', error.errorCode, error.errorMessage);
    }
  } catch (error) {
    console.log(error);
    icon.value = 'error';
  }
};

onMounted(() => generateUrl());
</script>

<template>
  <div class="external-loader flex justify-content-center align-items-center flex-direction-column">
    <svg v-if="icon === 'success'" class="mark-icon check-mark" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 52 52">
      <circle class="mark-icon__circle" cx="26" cy="26" r="25" fill="none" />
      <path class="mark-icon__check" fill="none" d="M14.1 27.2l7.1 7.2 16.7-16.8" />
    </svg>

    <svg v-else-if="icon === 'error'" class="mark-icon cross-mark" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 52 52">
      <circle class="mark-icon__circle" cx="26" cy="26" r="25" fill="none" />
      <path class="cross__path cross__path--right" fill="none" d="M16,16 l20,20" />
      <path class="cross__path cross__path--left" fill="none" d="M16,36 l20,-20" />
    </svg>

    <div v-else class="spinner">
      <i v-for="index in 10" :key="index" />
    </div>
    <h3>{{ icon === 'error' ? errorMessage : bodyMessage }}</h3>
    <button
      v-if="icon === 'error' && loader.closePopover"
      id="close-popover"
      class="btn btn-secondary mt1 text-dark-grey"
      type="button"
      @click="loader.closePopover"
    >
      Close
    </button>
    <a v-else-if="icon === 'error' && !loader.closePopover" href="/" class="btn btn-primary text-capitalize mt1">{{ backToHome }}</a>
  </div>
</template>

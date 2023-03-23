<script setup lang="ts">
import ReactWrapper from '../reactWrapper.vue';
import Login from './index.tsx';

defineProps<{ loginData: { [key: string]: string | boolean } }>();
</script>

<template>
  <ReactWrapper :component="Login" v-bind="loginData" />
</template>
